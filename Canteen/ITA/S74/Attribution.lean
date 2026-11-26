import Canteen.Core.StatuteSyntax
import Canteen.ITA.S38.CapitalGains

/-!
# Subsection 74.2(1): capital gains attributed back to the transferor

*Income Tax Act*, as consolidated to 2026-10-29 (verbatim in `statute/ITA-74-2-74-5.txt`).

Where an individual has lent or transferred property, directly or indirectly, to or for the
benefit of the individual's spouse or common-law partner (the **recipient**), then for the
recipient's dispositions of that property (or property substituted for it) in the **attribution
period** (throughout which the individual is resident in Canada and the recipient is the
individual's spouse or common-law partner):

* (a) the recipient's taxable capital gains less allowable capital losses on it, if positive, are
  the individual's taxable capital gain; (b) if negative, the individual's allowable capital loss;
* (c), (d) likewise for listed personal property, as gains and losses of the individual;
* (e) those amounts are deemed not to be the recipient's.

**74.5(1)**: none of this applies if the property was transferred for fair market value
consideration, any debt taken back bears interest at least at the lesser of the prescribed rate
and an arm's length rate, paid each year within 30 days after year-end, and, for a spouse, the
transferor elected out of 73(1). **74.5(3)(b)**: nor to a disposition while the two live apart
because of a breakdown of the relationship, if they jointly elect.

Income attribution (74.1) is in `IncomeAttribution`. Not encoded: 74.3, 74.4, and substituted
property beyond being given as such.
-/

namespace Canteen.ITA.Attribution

open CapitalGains

/-- 74.5(1)(b): where the consideration included indebtedness. -/
structure Indebtedness where
  /-- (b)(i) interest at least the lesser of the prescribed rate and an arm's length rate. -/
  adequateInterest : Bool
  /-- (b)(ii), (iii) the interest for the year and each preceding year paid within 30 days after year-end. -/
  interestPaidOnTime : Bool
  deriving Repr, DecidableEq, Inhabited

/-- The original transfer or loan. -/
structure Transfer where
  /-- The recipient is, or has since become, the individual's spouse or common-law partner. -/
  toSpouse : Bool := true
  /-- 74.5(1)(a): the fair market value transferred did not exceed the consideration received. -/
  fairMarketValueConsideration : Bool := false
  /-- 74.5(1)(b): any indebtedness in the consideration. -/
  indebtedness : Option Indebtedness := none
  /-- 74.5(1)(c): the transferor elected out of 73(1) (for a transfer to a spouse). -/
  electedOutOf73_1 : Bool := false
  deriving Repr, DecidableEq, Inhabited

/-- The 74.5(1) exception: a transfer for fair market value. -/
statute fairMarketValueException (t : Transfer) named "subsection 74.5(1)" cites "ITA 74.5(1)"
  applies where
    | (a) t.fairMarketValueConsideration
        => "The fair market value of the transferred property did not exceed the fair market value of the consideration."
        else "The transferor received less than fair market value as consideration."
    | (b) (t.indebtedness.all fun d => d.adequateInterest && d.interestPaidOnTime)
        => "Any indebtedness taken as consideration bore interest at least at the lesser of the prescribed and an arm's length rate, paid within 30 days after each year-end."
        else "Interest on the indebtedness taken as consideration was too low or not paid within 30 days after a year-end."
    | (c) (!t.toSpouse || t.electedOutOf73_1)
        => "The transferor elected not to have subsection 73(1) apply (or the transfer was not to a spouse or common-law partner)."
        else "The transferor did not elect out of subsection 73(1)."

/-- One of the recipient's dispositions of the lent or transferred property, or substituted property. -/
structure RecipientDisposition where
  disposition : Disposition
  /-- In the attribution period: the individual resident in Canada and the recipient the
  individual's spouse or common-law partner throughout. -/
  inAttributionPeriod : Bool := true
  /-- 74.5(3)(b): while living apart because of a breakdown, with a joint election. -/
  separatedWithJointElection : Bool := false
  deriving Repr, DecidableEq, Inhabited

/-- Whether 74.2(1) reaches this disposition. -/
def attributed (t : Transfer) (r : RecipientDisposition) : Bool :=
  t.toSpouse && r.inAttributionPeriod && !r.separatedWithJointElection && !fairMarketValueException.holds t

/-- 74.2(1)(a) to (d): the amounts deemed to be the individual's. -/
def toIndividual (t : Transfer) (rs : List RecipientDisposition) : Attribution :=
  let ds := (rs.filter (attributed t)).map (·.disposition)
  let ordinary := ds.filter (!·.isListed)
  let listed := ds.filter (·.isListed)
  let tcg := Year.sumBy ordinary (·.taxableCapitalGain)
  let acl := Year.sumBy ordinary (·.allowableCapitalLoss)
  let lg := Year.sumBy listed (·.gain)
  let ll := Year.sumBy listed (·.loss)
  { taxableCapitalGains := tcg - acl, allowableCapitalLosses := acl - tcg,
    lppGains := lg - ll, lppLosses := ll - lg }

/-- 74.2(1)(e): the recipient's year, without the attributed dispositions. -/
def recipientYear (t : Transfer) (rs : List RecipientDisposition) (others : List Disposition := []) : Year :=
  { dispositions := others ++ (rs.filter (!attributed t ·)).map (·.disposition) }

/-! ## Truths about attribution -/

private theorem one_way (x y : Nat) : x - y = 0 ∨ y - x = 0 := by
  rcases Nat.le_total x y with h | h
  · exact .inl (Nat.sub_eq_zero_of_le h)
  · exact .inr (Nat.sub_eq_zero_of_le h)

/-- Only one of (a) and (b) is ever non-zero: the net amount goes one way. -/
theorem net_one_way (t : Transfer) (rs : List RecipientDisposition) :
    (toIndividual t rs).taxableCapitalGains = 0 ∨ (toIndividual t rs).allowableCapitalLosses = 0 :=
  one_way _ _

/-- A transfer for fair market value, with adequate interest paid and an election out of 73(1),
attributes nothing. -/
theorem nothing_on_fair_market_value (t : Transfer) (h : fairMarketValueException.holds t = true)
    (rs : List RecipientDisposition) : toIndividual t rs = {} := by
  have : rs.filter (attributed t) = [] := by
    rw [List.filter_eq_nil_iff]; intro r _; simp [attributed, h]
  simp only [toIndividual, this, List.map_nil, List.filter_nil]
  rfl

/-- A gift to a spouse, sold by the spouse in the attribution period without a separation
election, is attributed. -/
theorem attributed_of_gift (t : Transfer) (r : RecipientDisposition) (hs : t.toSpouse = true)
    (hf : t.fairMarketValueConsideration = false) (hp : r.inAttributionPeriod = true)
    (he : r.separatedWithJointElection = false) : attributed t r = true := by
  simp [attributed, fairMarketValueException, hs, hf, hp, he]

end Canteen.ITA.Attribution

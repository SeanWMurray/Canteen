import Canteen.Core.StatuteSyntax
import Canteen.ITA.S38.CapitalGains

/-!
# Subsection 69(1): transfers not at arm's length, and gifts

*Income Tax Act*, subsection 69(1), as consolidated to 2026-10-29 (verbatim in `statute/ITA-69-1.txt`):

> (a) where a taxpayer has acquired anything from a person with whom the taxpayer was not dealing
> at arm's length at an amount in excess of the fair market value …, the taxpayer shall be deemed
> to have acquired it at that fair market value;
> (b) where a taxpayer has disposed of anything (i) to a person with whom the taxpayer was not
> dealing at arm's length for no proceeds or for proceeds less than the fair market value …,
> (ii) to any person by way of gift, or (iii) to a trust because of a disposition … that does not
> result in a change in the beneficial ownership …; the taxpayer shall be deemed to have received
> proceeds of disposition therefor equal to that fair market value; and
> (c) where a taxpayer acquires a property by way of gift, bequest or inheritance or because of a
> disposition that does not result in a change in the beneficial ownership …, the taxpayer is
> deemed to acquire the property at its fair market value.

Whether the parties deal at arm's length is an `Answer`, which section 251
(`RelatedPersons.armsLengthAnswer`) can supply: a fact for related persons, otherwise usually a
judgment call. "Except as expressly otherwise provided" (for example, the rollovers in 70(6) and
73(1)) is not encoded: where such a provision applies, this one should not be used.

Proven: the **asymmetry** of 69(1). A sale below fair market value to a non-arm's length buyer
raises the seller's proceeds to fair market value, but leaves the buyer's cost at the price paid.
-/

namespace Canteen.ITA.NonArmsLength

/-- A transfer of property, from both sides. -/
structure Transfer where
  description : String
  /-- The price paid (nil for a gift). -/
  price : Cents
  fairMarketValue : Cents
  /-- The parties dealt with each other at arm's length. -/
  armsLength : Answer
  /-- By way of gift (and, for the acquirer, a bequest or inheritance). -/
  gift : Bool := false
  /-- A disposition to a trust, or an acquisition, that does not change beneficial ownership. -/
  noChangeInBeneficialOwnership : Bool := false
  deriving Repr, DecidableEq, Inhabited

/-- 69(1)(b): the seller is deemed to receive fair market value. -/
statute sellerAtFairMarketValue (t : Transfer) named "paragraph 69(1)(b)" cites "ITA 69(1)(b)"
  applies where
    | "(i), (ii) or (iii)" judgments (if t.gift || t.noChangeInBeneficialOwnership then [] else t.armsLength.judgments)
        ((!t.armsLength.value && t.price < t.fairMarketValue) || t.gift || t.noChangeInBeneficialOwnership)
        => "The property was disposed of to a person not dealing at arm's length for less than its fair market value, by way of gift, or to a trust without a change in beneficial ownership."
        else "The property was not disposed of to a person not dealing at arm's length for less than its fair market value, by way of gift, or to a trust without a change in beneficial ownership."

/-- 69(1)(a) and (c): the buyer is deemed to acquire at fair market value. -/
statute buyerAtFairMarketValue (t : Transfer) named "paragraphs 69(1)(a) and (c)" cites "ITA 69(1)"
  applies where
    | "(a) or (c)" judgments (if t.gift || t.noChangeInBeneficialOwnership then [] else t.armsLength.judgments)
        ((!t.armsLength.value && t.price > t.fairMarketValue) || t.gift || t.noChangeInBeneficialOwnership)
        => "The property was acquired from a person not dealing at arm's length for more than its fair market value (a), or by gift, bequest or inheritance, or without a change in beneficial ownership (c)."
        else "The property was not acquired from a person not dealing at arm's length for more than its fair market value, or by gift, bequest or inheritance, or without a change in beneficial ownership."

/-- The seller's proceeds of disposition. -/
def sellerProceeds (t : Transfer) : Cents :=
  if sellerAtFairMarketValue.holds t then t.fairMarketValue else t.price

/-- The buyer's cost. -/
def buyerCost (t : Transfer) : Cents :=
  if buyerAtFairMarketValue.holds t then t.fairMarketValue else t.price

/-- The seller's disposition, for the capital gains computation, at the proceeds 69(1) deems. -/
def sellerDisposition (t : Transfer) (adjustedCostBase : Cents) : CapitalGains.Disposition :=
  { description := t.description, proceeds := sellerProceeds t, adjustedCostBase }

/-! ## Truths about 69(1) -/

/-- **The asymmetry.** Selling below fair market value to a person not at arm's length (not as a
gift): the seller is taxed as if paid fair market value, but the buyer's cost is only the price, so
the difference is taxed again when the buyer sells. -/
theorem undervalue_sale_double_counted (t : Transfer) (hnal : t.armsLength.value = false)
    (hlow : t.price < t.fairMarketValue) (hg : t.gift = false) (hb : t.noChangeInBeneficialOwnership = false) :
    sellerProceeds t = t.fairMarketValue ∧ buyerCost t = t.price := by
  have hnot : ¬ t.fairMarketValue < t.price := Nat.lt_asymm hlow
  simp [sellerProceeds, buyerCost, sellerAtFairMarketValue, buyerAtFairMarketValue, hnal, hlow, hg, hb, hnot]

/-- At arm's length, and not a gift, the price stands on both sides. -/
theorem arms_length_price_stands (t : Transfer) (hal : t.armsLength.value = true) (hg : t.gift = false)
    (hb : t.noChangeInBeneficialOwnership = false) : sellerProceeds t = t.price ∧ buyerCost t = t.price := by
  simp [sellerProceeds, buyerCost, sellerAtFairMarketValue, buyerAtFairMarketValue, hal, hg, hb]

/-- A gift is at fair market value on both sides. -/
theorem gift_at_fair_market_value (t : Transfer) (hg : t.gift = true) :
    sellerProceeds t = t.fairMarketValue ∧ buyerCost t = t.fairMarketValue := by
  simp [sellerProceeds, buyerCost, sellerAtFairMarketValue, buyerAtFairMarketValue, hg]

/-- 69(1) never lowers the seller's proceeds below the price. -/
theorem price_le_sellerProceeds (t : Transfer) (hg : t.gift = false) (hb : t.noChangeInBeneficialOwnership = false) :
    t.price ≤ sellerProceeds t := by
  unfold sellerProceeds
  split
  · rename_i h
    simp only [sellerAtFairMarketValue, Rule.statute_holds, Rule.clause_holds, List.all_cons, List.all_nil,
      List.any_nil, hg, hb, Bool.or_false, Bool.and_true, Bool.not_false, Bool.and_eq_true, Bool.not_eq_true',
      decide_eq_true_eq] at h
    exact Nat.le_of_lt h.2
  · exact Nat.le_refl _

end Canteen.ITA.NonArmsLength

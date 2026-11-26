import Canteen.Core.StatuteSyntax
import Canteen.Core.Answer
import Canteen.ITA.S85.TransferToCorporation

/-!
# Subsections 84.1(1) and (2): shares sold to a non-arm's length corporation

*Income Tax Act*, as consolidated to 2026-10-29 (verbatim in `statute/ITA-84.1-1-2.txt`):

> (1) Where after May 22, 1985 a taxpayer resident in Canada (other than a corporation) disposes
> of shares that are capital property of the taxpayer (… the "subject shares") of any class of the
> capital stock of a corporation resident in Canada (… the "subject corporation") to another
> corporation (… the "purchaser corporation") with which the taxpayer does not deal at arm's
> length and, immediately after the disposition, the subject corporation would be connected
> (within the meaning assigned by subsection 186(4) …) with the purchaser corporation,
> (a) where shares (… the "new shares") of the purchaser corporation have been issued as
> consideration for the subject shares, in computing the paid-up capital … in respect of any
> particular class of shares … of the purchaser corporation, there shall be deducted … (A − B) ×
> C / A where A is the increase … in the paid-up capital in respect of all shares … as a result of
> the issue of the new shares, B is the amount, if any, by which the greater of (i) the paid-up
> capital, immediately before the disposition, in respect of the subject shares, and (ii) subject
> to paragraphs 84.1(2)(a) and (a.1), the adjusted cost base to the taxpayer … of the subject
> shares, exceeds the fair market value … of any consideration (other than the new shares)
> received …, and C is the increase … in the paid-up capital in respect of the particular class …;
> and (b) … a dividend shall be deemed to be paid to the taxpayer by the purchaser corporation …
> in an amount determined by the formula (A + D) − (E + F) where … D is the fair market value …
> of any consideration (other than the new shares) …, E is the greater of (i) [that paid-up
> capital] and (ii) [that adjusted cost base], and F is the total of all amounts … deducted …
> under paragraph 84.1(1)(a) …
>
> (2) For the purposes of this section, … (a.1) [the adjusted cost base of a share acquired from a
> non-arm's length person, or substituted for one, is reduced by (i) pre-1972 valuation-day
> growth and (ii) gains of the taxpayer or a non-arm's length individual on previous dispositions
> of the share after 1984, or the lesser amount sheltered by the capital gains exemption]; (b)
> [the taxpayer is deemed not to deal at arm's length with the purchaser corporation if one of a
> group of fewer than 6 persons that controlled the subject corporation before, and the
> purchaser corporation after, the members of the second group all being in the first]; … (d) a
> trust and a beneficiary of the trust or a person related to a beneficiary of the trust shall be
> deemed not to deal with each other at arm's length; and (e) … if this paragraph applies because
> of subsection (2.31) or (2.32) [a qualifying intergenerational transfer], the taxpayer and the
> purchaser corporation are deemed to deal with each other at arm's length …

And section 54 "proceeds of disposition" does not include (k) an amount "to the extent that the
amount is deemed by subsection 84.1(1) … to be a dividend paid to the taxpayer".

The upshot: what the taxpayer takes out, in boot or paid-up capital, above the greater of the
subject shares' paid-up capital and their "hard" adjusted cost base (after (2)(a.1)) is a
dividend, not a capital gain. Whether the subject corporation is connected with the purchaser
corporation (186(4)) is a fact; arm's length is a fact or a judgment call, unless (2)(b) or (d)
deems it, or (2)(e) does the opposite. The (2)(a.1) reduction is given as an amount, and 84.1(2)(a)
(shares acquired before 1972) is not encoded, nor are the conditions of (2.31) and (2.32).
-/

namespace Canteen.ITA.SurplusStripping

open TransferToCorporation (ShareClass)

structure Facts where
  /-- The subject shares, e.g. `"shares of Opco"`. -/
  description : String
  /-- The taxpayer is resident in Canada and is not a corporation. -/
  residentNonCorporation : Bool := true
  /-- The subject shares are capital property of the taxpayer. -/
  capitalProperty : Bool := true
  /-- The subject corporation is resident in Canada. -/
  subjectResident : Bool := true
  /-- The taxpayer deals at arm's length with the purchaser corporation, but for (2)(b), (d), (e). -/
  armsLength : Answer := .fact false
  /-- (2)(b): one of a group of fewer than 6 persons controlling the subject corporation before
  and the purchaser corporation after, all members of the later group in the earlier. -/
  groupControl : Bool := false
  /-- (2)(d): the taxpayer is a trust and the purchaser corporation a beneficiary or a person
  related to one, or the reverse. -/
  trustAndBeneficiary : Bool := false
  /-- (2)(e): (2.31) or (2.32) (an intergenerational business transfer) applies. -/
  intergenerational : Bool := false
  /-- Immediately after, the subject corporation is connected with the purchaser corporation (186(4)). -/
  connected : Bool := true
  /-- The paid-up capital of the subject shares immediately before the disposition. -/
  subjectPaidUpCapital : Cents
  /-- The subject shares' adjusted cost base immediately before the disposition. -/
  adjustedCostBase : Cents
  /-- (2)(a.1): the reduction of the adjusted cost base (valuation-day growth, and gains of the
  taxpayer or a non-arm's length individual on previous dispositions, as (i) and (ii) set out). -/
  costReduction : Cents := 0
  /-- D: the fair market value of the consideration other than the new shares. -/
  boot : Cents := 0
  /-- The new shares, by class, with their paid-up capital increase (C) before 84.1. -/
  newShares : List ShareClass := []
  /-- The proceeds of disposition but for paragraph (k) of the definition (for a 85(1) transfer,
  the elected amount; for a sale, the price). -/
  proceedsOtherwise : Cents
  deriving Repr, Inhabited

/-- Not at arm's length, for 84.1: by (2)(b) or (d), unless (2)(e) applies; otherwise as given. -/
def notArmsLength (f : Facts) : Bool :=
  !f.intergenerational && (f.groupControl || f.trustAndBeneficiary || !f.armsLength.value)

def armsLengthJudgments (f : Facts) : List String :=
  if f.intergenerational || f.groupControl || f.trustAndBeneficiary then [] else f.armsLength.judgments

/-- Subsection 84.1(1). -/
statute applies (f : Facts) named "subsection 84.1(1)" cites "ITA 84.1(1)"
  applies where
    | "taxpayer" f.residentNonCorporation
        => "The taxpayer is resident in Canada and is not a corporation."
        else "The taxpayer is a corporation, or is not resident in Canada."
    | "subject shares" (f.capitalProperty && f.subjectResident)
        => "The subject shares are capital property of the taxpayer, of a corporation resident in Canada."
        else "The subject shares are not capital property of the taxpayer of a corporation resident in Canada."
    | "not at arm's length" judgments (armsLengthJudgments f) (notArmsLength f)
        => "The taxpayer does not deal at arm's length with the purchaser corporation (or is deemed not to by 84.1(2)(b) or (d))."
        else "The taxpayer deals at arm's length with the purchaser corporation (or is deemed to by 84.1(2)(e))."
    | "connected" f.connected
        => "Immediately after, the subject corporation is connected with the purchaser corporation (186(4))."
        else "Immediately after, the subject corporation is not connected with the purchaser corporation."

/-! ## The formulas -/

/-- (2)(a.1): the "hard" adjusted cost base. -/
def hardCost (f : Facts) : Cents := f.adjustedCostBase - f.costReduction

/-- E, and (a)'s "greater of": the subject shares' paid-up capital or hard adjusted cost base. -/
def e (f : Facts) : Cents := max f.subjectPaidUpCapital (hardCost f)

/-- A: the paid-up capital increase of all the new shares. -/
def a (f : Facts) : Cents := (f.newShares.map (·.paidUpCapitalIncrease)).sum

/-- B: E less the boot. -/
def b (f : Facts) : Cents := e f - f.boot

/-- (a): the reduction for one class, (A − B) × C / A. -/
def reduction (f : Facts) (s : ShareClass) : Cents :=
  if a f = 0 then 0 else (a f - b f) * s.paidUpCapitalIncrease / a f

/-- F: the total reduction. -/
def fTotal (f : Facts) : Cents := (f.newShares.map (reduction f)).sum

/-- The class's paid-up capital after (a). -/
def paidUpCapital (f : Facts) (s : ShareClass) : Cents := s.paidUpCapitalIncrease - reduction f s

/-- (b): the deemed dividend, (A + D) − (E + F), where 84.1(1) applies. -/
def dividend (f : Facts) : Cents := if applies.holds f then (a f + f.boot) - (e f + fTotal f) else 0

/-- Section 54 "proceeds of disposition" (k): the proceeds, less the deemed dividend. -/
def proceeds (f : Facts) : Cents := f.proceedsOtherwise - dividend f

/-- The taxpayer's disposition, for the capital gains computation. -/
def disposition (f : Facts) : CapitalGains.Disposition :=
  { description := s!"{f.description} (to the purchaser corporation)", proceeds := proceeds f,
    adjustedCostBase := f.adjustedCostBase }

/-- A 85(1) transfer of shares, with the subject shares' paid-up capital and the (2)(a.1) reduction:
the boot, new shares and elected amount come from the transfer. -/
def ofTransfer (t : TransferToCorporation.Facts) (subjectPaidUpCapital : Cents) (costReduction : Cents := 0)
    (armsLength : Answer := .fact false) (connected : Bool := true) : Facts :=
  { description := t.description, armsLength, connected, subjectPaidUpCapital, adjustedCostBase := t.costAmount,
    costReduction, boot := TransferToCorporation.bootTotal t, newShares := t.preferred ++ t.common,
    proceedsOtherwise := TransferToCorporation.electedAmount t }

def explain (f : Facts) : Finding :=
  let ex := applies.explain f
  if !applies.holds f then ex else
  ⟨true, ex.steps ++ [
    ⟨s!"The greater of the subject shares' paid-up capital ({formatCents f.subjectPaidUpCapital}) and their adjusted cost " ++
      s!"base as 84.1(2)(a.1) reduces it ({formatCents (hardCost f)}) is {formatCents (e f)}.", "ITA 84.1(1)(a) B, (b) E; 84.1(2)(a.1)"⟩,
    ⟨s!"The new shares' paid-up capital is reduced by {formatCents (fTotal f)}, to {formatCents (a f - fTotal f)}.", "ITA 84.1(1)(a)"⟩,
    ⟨s!"A dividend of {formatCents (dividend f)} is deemed paid to the taxpayer" ++
      (if dividend f > 0 then s!": the {formatCents f.boot} of other consideration exceeds {formatCents (e f)}." else "."),
      "ITA 84.1(1)(b)"⟩,
    ⟨s!"The taxpayer's proceeds of disposition are {formatCents (proceeds f)}.", "ITA 54 \"proceeds of disposition\" (k)"⟩],
    ex.reliesOn⟩

/-- Subsection 84.1(1), as a rule, with its consequences. -/
def rule : Rule Facts where
  name := "subsection 84.1(1)"
  citation := "ITA 84.1(1)"
  holds := applies.holds
  explain := explain
  sound := fun f => by unfold explain; split <;> simp_all

/-! ## Truths about 84.1 -/

private theorem arith_within (x d y : Nat) (h1 : d ≤ y) (h2 : y - d ≤ x) : (x + d) - (y + (x - (y - d))) = 0 := by omega
private theorem arith_over (x d y : Nat) : (x + d) - (y + x) = d - y := by omega

/-- With one class of new shares and boot no more than E, no dividend: the paid-up capital is
ground to E less the boot, so nothing comes out above E. -/
theorem no_dividend_within_e (f : Facts) (s : ShareClass) (h : f.newShares = [s]) (hp : 0 < s.paidUpCapitalIncrease)
    (hb : f.boot ≤ e f) (hab : b f ≤ a f) : dividend f = 0 := by
  have ha : a f = s.paidUpCapitalIncrease := by simp [a, h]
  have hr : fTotal f = a f - b f := by
    simp [fTotal, h, reduction, ha, Nat.pos_iff_ne_zero.mp hp, Nat.mul_div_cancel _ hp]
  unfold dividend; split
  · rw [hr]; unfold b at hab ⊢
    exact arith_within _ _ _ hb hab
  · rfl

/-- **Surplus stripping.** With one class of new shares whose paid-up capital is at most E less the
boot, boot over E is a dividend, dollar for dollar. -/
theorem boot_over_e_is_dividend (f : Facts) (s : ShareClass) (h : f.newShares = [s]) (hp : 0 < s.paidUpCapitalIncrease)
    (he : e f ≤ f.boot) (happ : applies.holds f = true) : dividend f = f.boot - e f := by
  have ha : a f = s.paidUpCapitalIncrease := by simp [a, h]
  have hb : b f = 0 := Nat.sub_eq_zero_of_le he
  have hr : fTotal f = a f := by
    simp [fTotal, h, reduction, ha, hb, Nat.pos_iff_ne_zero.mp hp, Nat.mul_div_cancel _ hp]
  simp only [dividend, happ, ite_true, hr]
  exact arith_over _ _ _

/-- The dividend comes out of the proceeds: the capital gain falls by the same amount. -/
theorem proceeds_add_dividend (f : Facts) (h : dividend f ≤ f.proceedsOtherwise) :
    proceeds f + dividend f = f.proceedsOtherwise := Nat.sub_add_cancel h

/-- An intergenerational transfer meeting (2.31) or (2.32) is outside 84.1. -/
theorem intergenerational_outside (f : Facts) (h : f.intergenerational = true) : dividend f = 0 := by
  simp [dividend, applies, notArmsLength, h]

end Canteen.ITA.SurplusStripping

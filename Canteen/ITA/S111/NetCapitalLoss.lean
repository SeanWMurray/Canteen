import Canteen.ITA.S3.Income

/-!
# Net capital losses: 111(8), 111(1)(b) and 111(1.1)

*Income Tax Act*, as consolidated to 2026-10-29 (verbatim in `statute/ITA-111-net-capital-loss.txt`):

* **111(8) "net capital loss"** for a year is A − B + C − D: A, the amount in 3(b)(ii) (allowable
  capital losses in excess of allowable business investment losses); B, the lesser of the total
  in 3(b)(i) and A (what 3(b) used); C, business investment losses of the tenth preceding year that
  expired as non-capital losses (the least of three amounts, nil after a loss restriction event);
  and D, reductions under section 80.
* **111(1)(b)** in computing taxable income, a taxpayer may deduct net capital losses "for
  taxation years preceding and the three taxation years immediately following the year".
* **111(1.1)(a)** the deduction is the lesser of the amount in 3(b) for the year and the total of
  each amount claimed, A, times B / C: the year's section 38 fraction over the loss year's.

Not encoded: 111(1.1)(b) (pre-1986 losses, up to $2,000) and (c) (the Minister's amount).

Each loss year's section 38 fraction is given (½ unless stated): the Act's current text states
only ½. Where A × B / C is not a whole number of half-cents it is rounded down.
-/

namespace Canteen.ITA.NetCapitalLoss

open CapitalGains

/-- The C term of 111(8): business investment losses of the tenth preceding year, converted. -/
structure ExpiredBIL where
  /-- (a) allowable business investment losses of the tenth preceding year. -/
  abilTenthYear : HalfCents := 0
  /-- (b) the unused non-capital loss of the tenth preceding year. -/
  unusedNonCapitalLoss : HalfCents := 0
  /-- (c) the taxpayer was subject to a loss restriction event since then. -/
  lossRestrictionEvent : Bool := false
  deriving Repr, DecidableEq, Inhabited

def ExpiredBIL.amount (c : ExpiredBIL) : HalfCents :=
  if c.lossRestrictionEvent then 0 else min c.abilTenthYear c.unusedNonCapitalLoss

/-- The net capital loss of a year (111(8)), in half-cents. -/
def netCapitalLoss (y : Year) (expired : ExpiredBIL := {}) (section80 : HalfCents := 0) : HalfCents :=
  let a := y.allowableCapitalLosses - y.allowableBusinessInvestmentLosses
  let b := min (y.taxableCapitalGains + y.lppTaxableNetGain) a
  a - b + expired.amount - section80

/-- A claim under 111(1)(b) for the net capital loss of a loss year. -/
structure Claim where
  lossYear : Nat
  /-- The amount claimed, in half-cents. -/
  amount : HalfCents
  /-- The loss year's section 38 fraction, as (numerator, denominator). -/
  fraction : Nat × Nat := (1, 2)
  deriving Repr, DecidableEq, Inhabited

/-- 111(1)(b): a net capital loss of a preceding year, or of one of the three following years. -/
def Claim.allowedFor (c : Claim) (year : Nat) : Bool :=
  c.lossYear < year || (year < c.lossYear && c.lossYear ≤ year + 3)

/-- 111(1.1)(a)(ii): A × B / C, with B = ½ (the year's fraction) and C the loss year's. -/
def Claim.adjusted (c : Claim) : HalfCents :=
  c.amount * c.fraction.2 / (2 * c.fraction.1)

/-- 111(1.1)(a): the deduction for the year: the lesser of the amount in 3(b) and the total of the
allowed claims, adjusted. -/
def deduction (year : Nat) (para3b : HalfCents) (claims : List Claim) : HalfCents :=
  min para3b ((claims.filter (·.allowedFor year)).foldl (· + ·.adjusted) 0)

/-- Taxable income (2(2)), in half-cents: income less the net capital loss deduction and any other
Division C deductions (given). -/
structure TaxableIncomeFacts where
  taxationYear : Nat
  income : Income.Facts
  claims : List Claim := []
  /-- Other Division C deductions, in cents. -/
  otherDivisionC : Cents := 0
  deriving Inhabited

def ncld (t : TaxableIncomeFacts) : HalfCents := deduction t.taxationYear (Income.paraB t.income) t.claims

def taxableIncome (t : TaxableIncomeFacts) : HalfCents :=
  Income.income t.income - ncld t - 2 * t.otherDivisionC

def report (t : TaxableIncomeFacts) : Argument :=
  let h := formatHalfCents
  let base := Income.report t.income
  let claimSteps := t.claims.map fun c =>
    if !c.allowedFor t.taxationYear then
      (⟨s!"The net capital loss of {c.lossYear} cannot be deducted in {t.taxationYear}: only losses of preceding years and " ++
        "of the three following years can.", "ITA 111(1)(b)"⟩ : Step)
    else if c.fraction == (1, 2) then
      ⟨s!"Claimed in respect of the net capital loss of {c.lossYear}: {h c.amount}.", "ITA 111(1)(b)"⟩
    else
      ⟨s!"Claimed in respect of the net capital loss of {c.lossYear}: {h c.amount}, which at that year's fraction of " ++
        s!"{c.fraction.1}/{c.fraction.2} becomes {h c.adjusted} at ½.", "ITA 111(1)(b), (1.1)(a)(ii)"⟩
  let tail : List Step := if t.claims.isEmpty && t.otherDivisionC == 0 then [] else
    [⟨s!"The net capital loss deduction is the lesser of the amount in 3(b), {h (Income.paraB t.income)}, and the claims: " ++
        s!"{h (ncld t)}.", "ITA 111(1.1)(a)"⟩,
     ⟨s!"Taxable income: income of {h (Income.income t.income)}, less {h (ncld t)} and other deductions of " ++
        s!"{formatCents t.otherDivisionC}: {h (taxableIncome t)}.", "ITA 2(2); 111"⟩]
  ⟨base.steps ++ claimSteps ++ tail, base.reliesOn⟩

/-! ## Truths about net capital losses -/

/-- Net capital losses can reduce only taxable capital gains: the deduction never exceeds the
amount in 3(b). -/
theorem deduction_le_para3b (year : Nat) (b : HalfCents) (cs : List Claim) : deduction year b cs ≤ b :=
  Nat.min_le_left _ _

/-- A loss year's net capital loss, claimed at the same fraction, is deducted at face value. -/
theorem adjusted_same_fraction (c : Claim) (h : c.fraction = (1, 2)) : c.adjusted = c.amount := by
  simp [Claim.adjusted, h]

/-- A loss of the same year, or more than three years later, can never be deducted. -/
theorem not_allowed_same_year (c : Claim) (year : Nat) (h : c.lossYear = year) : c.allowedFor year = false := by
  simp [Claim.allowedFor, h]

theorem not_allowed_far_future (c : Claim) (year : Nat) (h : year + 3 < c.lossYear) : c.allowedFor year = false := by
  simp only [Claim.allowedFor, Bool.or_eq_false_iff, decide_eq_false_iff_not, Bool.and_eq_false_iff]
  exact ⟨by omega, .inr (by omega)⟩

/-- With no gains in the year, the whole of the year's allowable capital losses (beyond its
ABILs) is a net capital loss. -/
theorem netCapitalLoss_no_gains (y : Year) (h : y.taxableCapitalGains + y.lppTaxableNetGain = 0) :
    netCapitalLoss y = y.allowableCapitalLosses - y.allowableBusinessInvestmentLosses := by
  simp [netCapitalLoss, h, ExpiredBIL.amount]

end Canteen.ITA.NetCapitalLoss

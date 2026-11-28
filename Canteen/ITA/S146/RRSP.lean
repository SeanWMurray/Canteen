import Canteen.Core.Money
import Canteen.Core.Finding

/-!
# The RRSP deduction: 146(1) "RRSP deduction limit" and "unused RRSP deduction room", 146(5), (5.1)

*Income Tax Act*, as consolidated to 2026-10-29 (verbatim in `statute/ITA-146-1-5-5.1.txt`):

**146(1) "RRSP deduction limit"**: A + B + R − C: A the unused RRSP deduction room at the end of the
preceding year; B the lesser of the RRSP dollar limit for the year and 18% of earned income for the
preceding year, less the pension adjustment for the preceding year (and prescribed amounts); R the
pension adjustment reversal; C the net past service pension adjustment. **"unused RRSP deduction
room"** at the end of a year: the same, less D, the deductions under 146(5) to (5.2) for the year.

**146(5)** A deduction, as claimed, of at most the lesser of (a) the premiums paid (to the end of the year
or within 60 days after) not yet deducted, and (b) the RRSP deduction limit less the 146(5.1)
deduction. **146(5.1)** The same for premiums to a spousal plan, within the limit less the 146(5)
deduction.

The RRSP dollar limit (the money purchase limit of the preceding year, 147.1(1), indexed to the
average wage, not the CPI), the pension adjustment, PAR and PSPA are given, as on a notice of
assessment; **earned income** (146(1)) is computed for a resident from its parts: employment income
(without 8(1)(c), (m), (m.2)), active business income, rent and one's own royalties, support received,
56(1)(c.2), (g), (n) research, (o), (r)(v) and CPP disability, less business and rental losses and
60(b) and (c.2) deductions. The non-resident parts ((c), (d), (g)) are not encoded. The excluded portions of premiums (146(5)(a)(i) to (iv.1)) and the 204.2
overcontribution tax are not encoded.
-/

namespace Canteen.ITA.RRSP

structure Facts where
  /-- A: unused RRSP deduction room at the end of the preceding year (may be negative). -/
  unusedRoom : Int := 0
  /-- The RRSP dollar limit for the year. -/
  dollarLimit : Cents
  earnedIncomePrior : Cents := 0
  pensionAdjustment : Cents := 0
  /-- R and C. -/
  pensionAdjustmentReversal : Cents := 0
  netPastServiceAdjustment : Cents := 0
  /-- 146(5)(a): premiums to the taxpayer's own plans, not yet deducted; 146(5.1): to spousal plans. -/
  premiums : Cents := 0
  spousalPremiums : Cents := 0
  /-- The amount claimed, if less than what is available (own plans first). -/
  claim : Option Cents := none
  deriving Repr, DecidableEq, Inhabited

/-- B. -/
def newRoom (f : Facts) : Cents := min f.dollarLimit (f.earnedIncomePrior * 18 / 100) - f.pensionAdjustment

/-- The RRSP deduction limit. -/
def limit (f : Facts) : Int := f.unusedRoom + newRoom f + f.pensionAdjustmentReversal - f.netPastServiceAdjustment

/-- 146(5) and (5.1) together: within the limit (nothing if it is negative). -/
def available (f : Facts) : Cents := min (f.premiums + f.spousalPremiums) (limit f).toNat

def deduction (f : Facts) : Cents := min (f.claim.getD (available f)) (available f)

/-- Unused room at the end of the year. -/
def unusedAtEnd (f : Facts) : Int := limit f - deduction f

/-- Premiums carried forward, undeducted. -/
def undeducted (f : Facts) : Cents := (f.premiums + f.spousalPremiums) - deduction f

def explain (f : Facts) : Finding :=
  let c := formatCents
  ⟨deduction f > 0, [
    ⟨s!"The RRSP deduction limit: unused room {f.unusedRoom} cents, plus the lesser of the dollar limit {c f.dollarLimit} and 18% of " ++
      s!"earned income less the pension adjustment, {c (newRoom f)}: {limit f} cents.", "ITA 146(1) \"RRSP deduction limit\""⟩,
    ⟨s!"Premiums of {c (f.premiums + f.spousalPremiums)}; {c (deduction f)} deducted, {c (undeducted f)} carried forward; unused room at " ++
      s!"the end of the year {unusedAtEnd f} cents.", "ITA 146(5), (5.1)"⟩], []⟩

/-! ## Earned income (146(1)), for a resident -/

/-- 146(1) "earned income", for a taxpayer resident throughout the year. -/
structure EarnedIncome where
  /-- (a)(i): employment income, without the 8(1)(c), (m) and (m.2) deductions. -/
  employment : Cents := 0
  /-- (a)(ii): business income, alone or as an active partner. -/
  business : Cents := 0
  /-- (a)(iii): rental income from real property, and royalties on one's own work or invention. -/
  rentalAndRoyalties : Cents := 0
  /-- (b): support received (56(1)(b)) and 56(1)(c.2), (g), (o), (r)(v) amounts; (b.01) research grants;
  (b.1) CPP or QPP disability. -/
  supportAndOther : Cents := 0
  /-- (e): business and rental losses; (f): support deductible under 60(b), and 60(c.2). -/
  losses : Cents := 0
  supportPaid : Cents := 0
  deriving Repr, DecidableEq, Inhabited

def EarnedIncome.amount (e : EarnedIncome) : Cents :=
  (e.employment + e.business + e.rentalAndRoyalties + e.supportAndOther) - (e.losses + e.supportPaid)

/-- Next year's B: the lesser of next year's dollar limit and 18% of this year's earned income, less this
year's pension adjustment. -/
def nextRoom (e : EarnedIncome) (nextDollarLimit pensionAdjustment : Cents) : Cents :=
  min nextDollarLimit (e.amount * 18 / 100) - pensionAdjustment

/-! ## Truths -/

theorem deduction_le_premiums (f : Facts) : deduction f ≤ f.premiums + f.spousalPremiums :=
  Nat.le_trans (Nat.min_le_right _ _) (Nat.min_le_left _ _)

/-- The deduction is within the RRSP deduction limit (nil when the limit is negative). -/
theorem deduction_le_limit (f : Facts) : deduction f ≤ (limit f).toNat :=
  Nat.le_trans (Nat.min_le_right _ _) (Nat.min_le_right _ _)

/-- Pension and investment income (other than rent and one's own royalties) are not earned income. -/
theorem no_earned_income : ({} : EarnedIncome).amount = 0 := rfl

end Canteen.ITA.RRSP

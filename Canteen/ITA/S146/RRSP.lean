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
average wage, not the CPI) and the earned income, pension adjustment, PAR and PSPA are given, as on a
notice of assessment. The excluded portions of premiums (146(5)(a)(i) to (iv.1)) and the 204.2
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

/-! ## Truths -/

theorem deduction_le_premiums (f : Facts) : deduction f ≤ f.premiums + f.spousalPremiums :=
  Nat.le_trans (Nat.min_le_right _ _) (Nat.min_le_left _ _)

/-- The deduction is within the RRSP deduction limit (nil when the limit is negative). -/
theorem deduction_le_limit (f : Facts) : deduction f ≤ (limit f).toNat :=
  Nat.le_trans (Nat.min_le_right _ _) (Nat.min_le_right _ _)

end Canteen.ITA.RRSP

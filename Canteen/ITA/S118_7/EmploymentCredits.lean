import Canteen.Core.Money

/-!
# The Canada employment credit (118(10)), and the credits and deduction for CPP and EI (118.7, 60(e.1))

*Income Tax Act*, as consolidated to 2026-10-29 (verbatim in `statute/ITA-118-10-118.7-60-e.1.txt`):

* **118(10)** 14% of the lesser of $1,000 (indexed) and the individual's income from an office or
  employment.
* **118.7** 14% of (a) employment insurance premiums and (b) Canada Pension Plan contributions under
  subsection 8(1) of that Act (the base contributions), each up to the year's maximum.
* **60(e.1)** the enhanced contributions under 8(1.1) and (1.2) of that Act, up to their maximum, are
  deducted in computing income.

The premiums and contributions are computed under the Employment Insurance Act and the Canada Pension
Plan, and are given here; the maximums and the 118(10) amount default to their 2025 values: $1,471,
EI $1,077.48, base CPP $3,356.10, enhanced CPP $678 + $396. Not encoded: self-employed contributions
(60(e), 118.7(c)), Quebec plans (118.7(a.1), (a.2)), 56(1)(r)(v). Rounded down to the cent.
-/

namespace Canteen.ITA.EmploymentCredits

structure Amounts where
  employmentAmount : Cents := 147100
  eiMaximum : Cents := 107748
  cppBaseMaximum : Cents := 335610
  cppEnhancedMaximum : Cents := 107400
  deriving Repr, DecidableEq, Inhabited

structure Facts where
  /-- Income from an office or employment. -/
  employmentIncome : Cents := 0
  eiPremiums : Cents := 0
  /-- Employee's contributions under CPP 8(1), and under 8(1.1) and (1.2). -/
  cppBase : Cents := 0
  cppEnhanced : Cents := 0
  amounts : Amounts := {}
  deriving Repr, DecidableEq, Inhabited

/-- 118(10). -/
def employmentCredit (f : Facts) : Cents := min f.amounts.employmentAmount f.employmentIncome * 1400 / 10000

/-- 118.7. -/
def contributionCredit (f : Facts) : Cents :=
  (min f.eiPremiums f.amounts.eiMaximum + min f.cppBase f.amounts.cppBaseMaximum) * 1400 / 10000

/-- 60(e.1). -/
def enhancedDeduction (f : Facts) : Cents := min f.cppEnhanced f.amounts.cppEnhancedMaximum

def credits (f : Facts) : Cents := employmentCredit f + contributionCredit f

/-! ## Truths -/

/-- The employment credit is at most 14% of the indexed amount: $205.94 for 2025. -/
theorem employmentCredit_le (f : Facts) : employmentCredit f ≤ f.amounts.employmentAmount * 1400 / 10000 :=
  Nat.div_le_div_right (Nat.mul_le_mul_right _ (Nat.min_le_left _ _))

/-- With no employment income, no employment credit. -/
theorem no_employment (f : Facts) (h : f.employmentIncome = 0) : employmentCredit f = 0 := by
  simp [employmentCredit, h]

end Canteen.ITA.EmploymentCredits

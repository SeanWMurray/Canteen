import Canteen.ITA.S127_5.MinimumTax

/-!
# Tests: moving expenses (62(1), 248(1) "eligible relocation")

Constructed examples.
-/

namespace Canteen.Tests.MovingExpenses

open Canteen Canteen.ITA Canteen.ITA.MovingExpenses

/-- A move 300 km closer to a new job, $12,000 of expenses, $20,000 earned there by year end. -/
def move : Facts := { oldResidenceKm := 320, newResidenceKm := 20, paid := 1200000, limitIncome := 2000000 }

example : eligible.holds move = true ∧ deduction move = 1200000 ∧ unused move = 0 := by decide
-- Only $8,000 earned there by year end: $8,000 now, $4,000 the next year.
example : deduction { move with limitIncome := 800000 } = 800000 ∧ unused { move with limitIncome := 800000 } = 400000 := by decide
example : deduction { move with paid := 0, carried := 400000, limitIncome := 6000000 } = 400000 := by decide
-- 39 km closer is not enough; exactly 40 is.
example : deduction { move with oldResidenceKm := 59 } = 0 ∧ deduction { move with oldResidenceKm := 60 } = 1200000 := by decide
-- Not ordinarily resident at both, outside Canada, or reimbursements left out of income: nothing.
example : deduction { move with ordinarilyResided := false } = 0 ∧ deduction { move with inCanada := false } = 0 ∧
    deduction { move with reimbursementsIncluded := false } = 0 := by decide
-- A student, against $5,000 of scholarships.
example : deduction { move with toWork := false, limitIncome := 500000 } = 500000 := by decide
-- The explanation says which condition fails.
example : (eligible.explain { move with oldResidenceKm := 59 }).conclusion = false := by decide

/-! ## In the individual's year -/

def mover : IndividualYear.Facts :=
  { taxationYear := 2025, employmentAndBusiness := 6000000, claimsPersonal := true, moving := some move }

example : IndividualYear.movingDeduction mover = 1200000 ∧ IndividualYear.income mover = 2 * 4800000 := by decide
example : MinimumTax.adjustedTaxableIncome mover = 2 * 4800000 := by decide

end Canteen.Tests.MovingExpenses

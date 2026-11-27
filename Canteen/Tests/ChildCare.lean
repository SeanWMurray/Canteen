import Canteen.ITA.S127_5.MinimumTax

/-!
# Tests: child care expenses (63)

Constructed examples.
-/

namespace Canteen.Tests.ChildCare

open Canteen Canteen.ITA Canteen.ITA.ChildCare

def kids : List Child := [{ age := 3 }, { age := 9 }]

-- $8,000 (under 7) + $5,000: $13,000, all of the $15,000 paid that it covers.
example : annualTotal { paid := 1500000, children := kids, earnedIncome := 6000000 } = 1300000 := by decide
example : deduction { paid := 1500000, children := kids, earnedIncome := 6000000 } = 1300000 := by decide
-- Two-thirds of $15,000 of earned income caps it at $10,000.
example : deduction { paid := 1500000, children := kids, earnedIncome := 1500000 } = 1000000 := by decide
-- A child eligible for the disability credit: $11,000.
example : annualTotal { paid := 0, children := [{ age := 12, disability := true }], earnedIncome := 0 } = 1100000 := by decide
-- At 17, only if dependent and infirm.
example : annualTotal { paid := 0, children := [{ age := 17 }], earnedIncome := 0 } = 0 ∧
    annualTotal { paid := 0, children := [{ age := 17, infirmDependant := true }], earnedIncome := 0 } = 500000 := by decide
-- The higher-income spouse, while the other was a full-time student for 10 weeks: 1/40 of $13,000 a week, $3,250.
example : deduction { paid := 1500000, children := kids, earnedIncome := 9000000, higherIncome := true, weeks := 10 } = 325000 := by decide

/-! ## In the individual's year -/

def lower : IndividualYear.Facts :=
  { taxationYear := 2025, employmentAndBusiness := 5000000, claimsPersonal := true,
    childCare := some { paid := 1500000, children := kids, earnedIncome := 0 }, supportingPersonIncome := some 9000000 }
def higher : IndividualYear.Facts :=
  { lower with employmentAndBusiness := 9000000, supportingPersonIncome := some 5000000 }

-- The lower-income spouse deducts $13,000; earned income is the year's employment income.
example : IndividualYear.childCareDeduction lower = 1300000 ∧ IndividualYear.income lower = 2 * 3700000 := by decide
-- The higher-income spouse, with the other at home, deducts nothing (63(2)).
example : IndividualYear.childCareDeduction higher = 0 := by decide
-- The minimum tax allows it too.
example : MinimumTax.adjustedTaxableIncome lower = 2 * 3700000 := by decide

end Canteen.Tests.ChildCare

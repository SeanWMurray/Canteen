import Canteen.ITA.S127_5.MinimumTax

/-!
# Tests: shareholder benefits (15(1))

Constructed examples.
-/

namespace Canteen.Tests.ShareholderBenefit

open Canteen Canteen.ITA Canteen.ITA.ShareholderBenefit

/-- The shareholder uses Opco's cottage all summer: worth $12,000; the shareholder paid $2,000. -/
def cottage : Facts := { description := "use of Opco's cottage", value := 1200000, paid := 200000 }

example : inclusion cottage = 1000000 := by decide
-- Paid full value: nothing.
example : inclusion { cottage with paid := 1200000 } = 0 := by decide
-- Conferred as an employee (judged): not 15(1), and the explanation rests on the call.
def asEmployee : Facts := { cottage with asShareholder := .judged "J-CAP" false }
example : inclusion asEmployee = 0 ∧ (explain asEmployee).reliesOn = ["J-CAP"] := by decide
-- A dividend, a redemption, a winding-up, or a rights offering to all: not 15(1).
example : inclusion { cottage with way := .dividend } = 0 ∧ inclusion { cottage with way := .redemption } = 0 ∧
    inclusion { cottage with way := .windingUp } = 0 ∧ inclusion { cottage with way := .rightsOffering } = 0 := by decide
-- The part section 84 deems a dividend comes off.
example : inclusion { cottage with deemedDividend := 400000 } = 600000 := by decide
-- 88(1) is excepted only for a resident corporation; 86.1(1) only for a non-resident.
example : inclusion { cottage with way := .section88, corporationResident := false } = 1000000 ∧
    inclusion { cottage with way := .section86_1, corporationResident := false } = 0 := by decide
-- Not a shareholder: not 15(1).
example : inclusion { cottage with shareholder := false } = 0 := by decide

/-! ## In the individual's year -/

def owner : IndividualYear.Facts := { taxationYear := 2025, employmentAndBusiness := 8000000, claimsPersonal := true, shareholderBenefits := [cottage] }
example : IndividualYear.shareholderBenefitIncome owner = 1000000 ∧ IndividualYear.income owner = 2 * 9000000 := by decide
example : MinimumTax.adjustedTaxableIncome owner = 2 * 9000000 := by decide

end Canteen.Tests.ShareholderBenefit

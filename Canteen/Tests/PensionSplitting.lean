import Canteen.ITA.S127_5.MinimumTax

/-!
# Tests: pension income, the age and pension credits, and pension splitting

2025 amounts. Constructed examples.
-/

namespace Canteen.Tests.PensionSplitting

open Canteen Canteen.ITA Canteen.ITA.PensionSplitting

def rpp : Payment := ⟨"pension plan annuity", 3000000, .pensionPlan⟩
def rrif : Payment := ⟨"RRIF payments", 2000000, .registeredFund⟩
def cpp : Payment := ⟨"Canada Pension Plan", 1000000, .government⟩

-- At 65, all but CPP is eligible; under 65, only the pension plan annuity.
example : eligiblePensionIncome true [rpp, rrif, cpp] = 5000000 ∧ eligiblePensionIncome false [rpp, rrif, cpp] = 3000000 := by decide
-- A RRIF received on a spouse's death is qualified.
example : eligiblePensionIncome false [⟨"RRIF", 2000000, .registeredFund true⟩] = 2000000 := by decide
-- Up to half may be split; married for six months, a quarter.
example : splitLimit true [rpp, rrif] = 2500000 ∧ splitLimit true [rpp, rrif] 6 = 1250000 := by decide
-- The age amount: in full to $45,522, then less 15% of the excess; gone at $105,709.
example : ageAmount {} 4500000 = 902800 ∧ ageAmount {} 6000000 = 685630 ∧ ageAmount {} 10600000 = 0 := by decide
example : ageCredit {} true 4500000 = 126392 ∧ ageCredit {} false 4500000 = 0 := by decide
-- The pension credit: 14% of up to $2,000.
example : pensionCredit 5000000 = 28000 ∧ pensionCredit 100000 = 14000 := by decide

/-! ## In the individual's year -/

def senior : IndividualYear.Facts :=
  { taxationYear := 2025, age65 := true, claimsPersonal := true, pensions := [rpp, cpp] }

-- Pensions are income; the age credit on $40,000 is in full, and the pension credit is $280.
example : IndividualYear.income senior = 2 * 4000000 ∧ IndividualYear.ageAndPensionCredits senior = 126392 + 28000 := by decide
-- Splitting more than the limit deducts only the limit, $15,000.
example : IndividualYear.splitOutAllowed { senior with splitOut := 2000000 } = 1500000 ∧
    IndividualYear.income { senior with splitOut := 2000000 } = 2 * 2500000 := by decide
-- A transferee under 65 receiving qualified pension income gets the pension credit.
example : IndividualYear.eligiblePension { taxationYear := 2025, splitIn := 500000 } = 500000 ∧
    IndividualYear.eligiblePension { taxationYear := 2025, splitIn := 500000, splitInQualified := false } = 0 := by decide
-- Half the age and pension credits count toward the basic minimum tax credit.
example : MinimumTax.basicCredit senior - MinimumTax.basicCredit { senior with age65 := false, pensions := [cpp] } = 77196 := by decide

end Canteen.Tests.PensionSplitting

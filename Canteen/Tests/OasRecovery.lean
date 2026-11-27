import Canteen.ITA.S127_5.MinimumTax

/-!
# Tests: the Old Age Security recovery tax (180.2, 60(w))

2025 threshold: $93,454. Constructed examples.
-/

namespace Canteen.Tests.OasRecovery

open Canteen Canteen.ITA Canteen.ITA.OasRecovery

-- 15% of the excess, up to the benefits.
example : tax 870000 10000000 = 98190 ∧ tax 870000 9000000 = 0 ∧ tax 870000 16000000 = 870000 := by decide

def oas : PensionSplitting.Payment := ⟨"Old Age Security", 870000, .oldAgeSecurity⟩
def senior (pension : Cents) : IndividualYear.Facts :=
  { taxationYear := 2025, age65 := true, claimsPersonal := true, pensions := [⟨"pension", pension, .pensionPlan⟩, oas] }

-- OAS is income but not pension income.
example : IndividualYear.oasReceived (senior 9000000) = 870000 ∧ IndividualYear.eligiblePension (senior 9000000) = 9000000 := by decide
-- With $98,700 of adjusted income: $786.90 of recovery tax, deducted, leaving income of $97,913.10.
example : IndividualYear.adjustedIncome (senior 9000000) = 2 * 9870000 ∧ IndividualYear.oasRecovery (senior 9000000) = 78690 ∧
    IndividualYear.income (senior 9000000) = 2 * 9791310 := by decide
-- Below the threshold: none.
example : IndividualYear.oasRecovery (senior 5000000) = 0 ∧ IndividualYear.income (senior 5000000) = 2 * 5870000 := by decide
-- High income: all of it is recovered.
example : IndividualYear.oasRecovery (senior 20000000) = 870000 := by decide
-- The minimum tax counts pension income and the 60(w) deduction.
example : MinimumTax.adjustedTaxableIncome (senior 9000000) = 2 * 9791310 := by decide

end Canteen.Tests.OasRecovery

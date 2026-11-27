import Canteen.ITA.S127_5.MinimumTax

/-!
# Tests: employee stock options (7(1)(a), 7(1.1), 110(1)(d), (d.1))

1,000 shares at a $10 exercise price, worth $30 when acquired. Constructed examples.
-/

namespace Canteen.Tests.StockOptions

open Canteen Canteen.ITA Canteen.ITA.StockOptions

def publicCo : Facts := { acquired := ⟨2025, 3, 1⟩, valueAtAcquisition := 3000000, exercisePrice := 1000000 }

-- A $20,000 benefit in 2025, half deducted; the shares cost $30,000.
example : benefit publicCo = 2000000 ∧ inclusionYear publicCo = some 2025 ∧ deduction publicCo = 1000000 ∧
    adjustedCostBase publicCo = 3000000 := by decide
-- Over the $200,000 vesting limit (a non-qualified security), or priced below value at grant: no deduction.
example : deduction { publicCo with nonQualified := true } = 0 ∧ deduction { publicCo with priceAtLeastValueAtGrant := false } = 0 := by decide

-- A CCPC share, exercised in 2023, sold in mid-2025: the benefit is received in 2025.
def ccpc : Facts := { publicCo with acquired := ⟨2023, 3, 1⟩, disposed := some ⟨2025, 6, 1⟩, ccpcArmsLength := true, priceAtLeastValueAtGrant := false }
example : inclusionYear ccpc = some 2025 := by decide
-- Kept two years: half deducted under 110(1)(d.1), though (d) does not apply.
example : qualifiesD ccpc = false ∧ qualifiesD1 ccpc = true ∧ deduction ccpc = 1000000 := by decide
-- Sold within two years: no deduction.
example : deduction { ccpc with disposed := some ⟨2024, 1, 15⟩ } = 0 := by decide
-- Not yet sold: no benefit received yet.
example : inclusionYear { ccpc with disposed := none } = none := by decide

/-! ## In the individual's year -/

def employee : IndividualYear.Facts :=
  { taxationYear := 2025, employmentAndBusiness := 10000000, claimsPersonal := true, stockOptions := [publicCo] }

-- $120,000 of income; $110,000 taxable after the deduction.
example : IndividualYear.income employee = 2 * 12000000 ∧ IndividualYear.taxableIncome employee = 2 * 11000000 := by decide
-- The minimum tax allows no 110(1)(d) deduction (127.52(1)(h)).
example : MinimumTax.adjustedTaxableIncome employee = 2 * 12000000 := by decide
-- In 2026, the 2025 option is not income again.
example : IndividualYear.stockOptionBenefits { employee with taxationYear := 2026 } = 0 := by decide
-- The CCPC option counts only in the year of sale.
example : IndividualYear.stockOptionBenefits { employee with stockOptions := [ccpc] } = 2000000 ∧
    IndividualYear.stockOptionBenefits { employee with taxationYear := 2023, stockOptions := [ccpc] } = 0 := by decide

end Canteen.Tests.StockOptions

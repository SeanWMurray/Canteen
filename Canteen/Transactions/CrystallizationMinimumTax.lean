import Canteen.ITA.S127_5.MinimumTax

/-!
# Layer 3: the minimum tax on crystallizing the capital gains exemption

A constructed example under 3, 38, 110.6, 117(2), 118(1) and 127.5 to 127.531, federal tax only.

* An individual with no other income in 2025 realizes a gain on qualified small business corporation
  shares (cost $100) and claims the capital gains deduction for all of it.
* How large a gain can be sheltered without minimum tax?

The 120.2 carryforward of minimum tax paid, and provincial tax, are not computed.
-/

namespace Canteen.Transactions.CrystallizationMinimumTax

open Canteen Canteen.ITA

def shares (gain : Cents) : CapitalGains.Disposition :=
  { description := "QSBC shares", proceeds := gain + 10000, adjustedCostBase := 10000 }

/-- The year, with `gain` realized and sheltered. -/
def year (gain : Cents) : IndividualYear.Facts :=
  { taxationYear := 2025, capital := ⟨[shares gain], 0, {}⟩, personalAmounts := some {},
    deduction110_6 := some { qualifying := [shares gain] } }

/-! ## Analysis -/

/-- The whole $1,250,000 limit: the deduction shelters the $625,000 taxable gain, and no regular tax is payable. -/
theorem no_regular_tax :
    IndividualYear.capitalGainsDeduction (year 125000000) = 2 * 62500000 ∧ IndividualYear.taxableIncome (year 125000000) = 0 ∧
    IndividualYear.federalTax (year 125000000) = 0 := by decide

/-- For the minimum tax the gain counts in full and only 7/5 of the deduction comes off: $375,000. -/
theorem adjusted : MinimumTax.adjustedTaxableIncome (year 125000000) = 2 * 37500000 := by decide

/-- **$39,548.33 of minimum tax.** 20.5% of $197,118 over the exemption, less half the personal credit. -/
theorem minimum_tax : MinimumTax.taxPayable (year 125000000) = 3954833 := by decide

/-- A $600,000 gain stays within the exemption: adjusted taxable income of $180,000, less than
$177,882 plus what the credit covers, so no tax at all. -/
theorem smaller_gain :
    MinimumTax.adjustedTaxableIncome (year 60000000) = 2 * 18000000 ∧ MinimumTax.taxPayable (year 60000000) = 0 := by decide

/-- $620,000 does not: 20.5% of $8,118, less the $860.86 credit, is $803.33. -/
theorem slightly_larger : MinimumTax.taxPayable (year 62000000) = 80333 := by decide

end Canteen.Transactions.CrystallizationMinimumTax

import Canteen.ITA.S127_5.MinimumTax

/-!
# Layer 3: the minimum tax on crystallizing the capital gains exemption

A constructed example under 3, 38, 110.6, 117(2), 118(1) and 127.5 to 127.531, federal tax only.

* An individual with no other income in 2025 realizes a gain on qualified small business corporation
  shares (cost $100) and claims the capital gains deduction for all of it.
* How large a gain can be sheltered without minimum tax?

* The minimum tax paid can be recovered in the next seven years (120.2). The individual earns a salary
  in 2026.

Provincial tax is not computed.
-/

namespace Canteen.Transactions.CrystallizationMinimumTax

open Canteen Canteen.ITA

def shares (gain : Cents) : CapitalGains.Disposition :=
  { description := "QSBC shares", proceeds := gain + 10000, adjustedCostBase := 10000 }

/-- The year, with `gain` realized and sheltered. -/
def year (gain : Cents) : IndividualYear.Facts :=
  { taxationYear := 2025, capital := ⟨[shares gain], 0, {}⟩, claimsPersonal := true,
    deduction110_6 := some { qualifying := [shares gain] } }

/-! ## Analysis -/

/-- The whole $1,250,000 limit: the deduction shelters the $625,000 taxable gain, and no regular tax is payable. -/
theorem no_regular_tax :
    IndividualYear.capitalGainsDeduction (year 125000000) = 2 * 62500000 ∧ IndividualYear.taxableIncome (year 125000000) = 0 ∧
    IndividualYear.federalTax (year 125000000) = 0 := by decide

/-- For the minimum tax the gain counts in full and only 7/5 of the deduction comes off: $375,000. -/
theorem adjusted : MinimumTax.adjustedTaxableIncome (year 125000000) = 2 * 37500000 := by decide

/-- **$39,391.53 of minimum tax.** 20.5% of $197,118 over the exemption, less half the personal credit. -/
theorem minimum_tax : MinimumTax.taxPayable (year 125000000) = 3939153 := by decide

/-- A $600,000 gain stays within the exemption: adjusted taxable income of $180,000, less than
$177,882 plus what the credit covers, so no tax at all. -/
theorem smaller_gain :
    MinimumTax.adjustedTaxableIncome (year 60000000) = 2 * 18000000 ∧ MinimumTax.taxPayable (year 60000000) = 0 := by decide

/-- $620,000 does not: 20.5% of $8,118, less the $1,017.66 credit, is $646.53. -/
theorem slightly_larger : MinimumTax.taxPayable (year 62000000) = 64653 := by decide

/-! ## Recovering it in 2026 -/

/-- 2026, with a salary, at 2026 amounts. -/
def nextYear (salary : Cents) : IndividualYear.Facts :=
  { taxationYear := 2026, employmentAndBusiness := salary, claimsPersonal := true }

def carried : List MinimumTax.Carryforward := [⟨2025, MinimumTax.additional (year 125000000)⟩]

/-- The 2025 minimum tax is all additional tax, carried forward. -/
theorem carried_forward : MinimumTax.additional (year 125000000) = 3939153 := by decide

/-- With a $250,000 salary, 2026 regular tax of $54,714.26 exceeds the minimum amount by more than $39,391.53: the whole
$39,391.53 comes back, and 2026 tax is $15,322.73. -/
theorem recovered :
    IndividualYear.federalTax (nextYear 25000000) = 5471426 ∧ MinimumTax.recovery (nextYear 25000000) carried = 3939153 ∧
    MinimumTax.taxAfterRecovery (nextYear 25000000) carried = 1532273 := by decide

/-- With $200,000, $37,386.26 comes back, and $2,005.27 waits for a later year. -/
theorem partly_recovered :
    MinimumTax.recovery (nextYear 20000000) carried = 3738626 ∧
    MinimumTax.additional (year 125000000) - MinimumTax.recovery (nextYear 20000000) carried = 200527 := by decide

end Canteen.Transactions.CrystallizationMinimumTax

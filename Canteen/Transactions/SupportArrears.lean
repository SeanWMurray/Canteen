import Canteen.ITA.S127_5.MinimumTax

/-!
# Layer 3: support in arrears, and child support first

A constructed example under 56(1)(b), 56.1(4), 60(b) and 117(2), federal tax only.

* Separated spouses with a child. A court order made on 1 January 2025 requires the payer to pay $1,000 a
  month of child support and $1,500 a month of spousal support: $30,000 a year.
* In 2025 the payer pays only $24,000. In 2026 the payer pays the year's $30,000 and the $6,000 owing.
* The payer earns $120,000 a year, the recipient $40,000.

How much does the payer deduct, and the recipient include, each year? Provincial tax is not computed.
-/

namespace Canteen.Transactions.SupportArrears

open Canteen Canteen.ITA

/-- The support, as at the end of 2025 or 2026. -/
def support2025 : Support.Facts := { paidSince1997 := 2400000, childSupportPayable := 1200000 }
def support2026 : Support.Facts := { paidSince1997 := 2400000 + 3600000, childSupportPayable := 2400000, deductedBefore := 1200000 }

def payer (year : Nat) (s : Option Support.Facts) : IndividualYear.Facts :=
  { taxationYear := year, employmentAndBusiness := 12000000, claimsPersonal := true, supportPaid := s.toList }
def recipient (year : Nat) (s : Option Support.Facts) : IndividualYear.Facts :=
  { taxationYear := year, employmentAndBusiness := 4000000, claimsPersonal := true, supportReceived := s.toList }

/-! ## Analysis -/

/-- The amounts are support amounts: periodic, at the recipient's discretion, under a court order to a
spouse living apart. -/
theorem is_support : Support.supportAmount.holds support2025 = true := by decide

/-- 2025: of the $24,000 paid, $12,000 is child support (all of it payable, so all of it first); only
$12,000 is deductible, not the $18,000 of spousal support ordered. -/
theorem deductible_2025 : Support.amount support2025 = 1200000 := by decide

/-- The payer's tax falls by $2,748.75 ($5,250 at 26% and $6,750 at 20.5%: the deduction crosses the
$114,750 threshold); the recipient's rises by $1,680 (14%). -/
theorem tax_2025 :
    IndividualYear.federalTax (payer 2025 none) - IndividualYear.federalTax (payer 2025 (some support2025)) = 274875 ∧
    IndividualYear.federalTax (recipient 2025 (some support2025)) - IndividualYear.federalTax (recipient 2025 none) = 168000 := by
  decide

/-- 2026: $36,000 paid, $60,000 in all; child support payable $24,000, $12,000 deducted before: $24,000 is
deductible, the year's $18,000 of spousal support and the $6,000 of arrears. -/
theorem deductible_2026 : Support.amount support2026 = 2400000 := by decide

/-- Over the two years, $36,000 is deducted: exactly the spousal support ordered, once it is all paid. -/
theorem two_years : Support.amount support2025 + Support.amount support2026 = 3600000 := by decide

/-- **Child support first.** Had the payer paid only $12,000 in 2025, nothing would be deductible. -/
theorem nothing_until_caught_up : Support.amount { support2025 with paidSince1997 := 1200000 } = 0 := by decide

/-- A lump sum is not an allowance on a periodic basis: not deductible. -/
theorem lump_sum : Support.amount { support2025 with periodicAllowance := .fact false } = 0 := by decide

end Canteen.Transactions.SupportArrears

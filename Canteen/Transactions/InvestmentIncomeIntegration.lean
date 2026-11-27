import Canteen.ITA.S3.IndividualYear
import Canteen.ITA.S129.RefundableTax

/-!
# Layer 3: investment income earned personally, or through a holding company

A constructed comparison under 3, 82(1), 117(2), 121, 123 to 125, 123.3 and 129, federal tax only.

* An individual with a $200,000 salary in 2025 has $100,000 of interest income each year.
* Option A: earn it personally.
* Option B: earn it in Holdco, a CCPC the individual owns. Holdco pays Part I tax and the 10⅔%
  refundable tax, and pays the individual a non-eligible dividend of everything left plus the dividend
  refund: $92,000.

Provincial tax, which is where integration is usually measured, is not computed.
-/

namespace Canteen.Transactions.InvestmentIncomeIntegration

open Canteen Canteen.ITA

def salary : Cents := 20000000
def interest : Cents := 10000000

/-- Option A: the individual's year with the interest. -/
def personal : IndividualYear.Facts :=
  { taxationYear := 2025, employmentAndBusiness := salary + interest, personalAmounts := some {} }

/-- Option B: Holdco's year. -/
def holdco (dividend : Cents) : RefundableTax.Facts :=
  { rates := { taxableIncome := interest, aggregateInvestmentIncome := interest }, nonEligibleDividendsPaid := dividend }

/-- The dividend Holdco can pay: the interest less its tax, plus the refund that the dividend itself earns. -/
def dividend : Cents := 9200000

/-- Option B: the individual's year with the dividend. -/
def throughHoldco : IndividualYear.Facts :=
  { taxationYear := 2025, employmentAndBusiness := salary, dividends := [{ description := "Holdco dividend", amount := dividend }],
    personalAmounts := some {} }

/-- The individual's year without the interest at all, to measure the tax on it. -/
def baseline : IndividualYear.Facts := { taxationYear := 2025, employmentAndBusiness := salary, personalAmounts := some {} }

/-! ## Analysis -/

/-- Holdco: Part I tax with the 10⅔% is $38,666.66; the dividend refund on $92,000 of dividends is
the whole $30,666.66 non-eligible account; so its tax is $8,000. -/
theorem holdco_tax :
    RefundableTax.partITax (holdco dividend) = 3866666 ∧ RefundableTax.dividendRefund (holdco dividend) = 3066666 ∧
    RefundableTax.partITax (holdco dividend) - RefundableTax.dividendRefund (holdco dividend) = 800000 := by decide

/-- The $92,000 dividend is exactly what Holdco has: the interest less its tax, plus the refund. -/
theorem dividend_is_whats_left :
    interest - RefundableTax.partITax (holdco dividend) + RefundableTax.dividendRefund (holdco dividend) = dividend := by decide

/-- Earned personally, the interest adds $31,130.94 of federal tax. -/
theorem personal_tax : IndividualYear.federalTax personal - IndividualYear.federalTax baseline = 3113094 := by decide

/-- Paid out as a non-eligible dividend, the $92,000 adds $23,491.10 of federal tax. -/
theorem dividend_tax : IndividualYear.federalTax throughHoldco - IndividualYear.federalTax baseline = 2349110 := by decide

/-- **Near integration.** Through Holdco the total federal tax on the interest is $31,491.10 ($8,000
corporate and $23,491.10 personal), $360.16 more than earning it personally. -/
theorem integration :
    800000 + (IndividualYear.federalTax throughHoldco - IndividualYear.federalTax baseline) = 3149110 ∧
    800000 + (IndividualYear.federalTax throughHoldco - IndividualYear.federalTax baseline) -
      (IndividualYear.federalTax personal - IndividualYear.federalTax baseline) = 36016 := by decide

end Canteen.Transactions.InvestmentIncomeIntegration

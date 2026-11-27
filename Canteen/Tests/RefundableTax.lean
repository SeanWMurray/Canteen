import Canteen.ITA.S129.RefundableTax

/-!
# Tests: refundable taxes (123.3, 186(1), 129(1), (4))

An investment holding company (a CCPC) earns $100,000 of interest. Constructed examples.
-/

namespace Canteen.Tests.RefundableTax

open Canteen Canteen.ITA Canteen.ITA.RefundableTax

def holdco : Facts := { rates := { taxableIncome := 10000000, aggregateInvestmentIncome := 10000000 } }

-- Part I: 28%, plus 10⅔%: $38,666.66.
example : CorporateRates.tax holdco.rates = 2800000 ∧ additionalTax holdco = 1066666 ∧ partITax holdco = 3866666 := by decide
-- 30⅔%, $30,666.66, goes into the non-eligible account.
example : nonEligibleAccount holdco = 3066666 := by decide
-- Paying $80,000 of non-eligible dividends brings it all back: the corporate tax left is $8,000 (8%).
def paying : Facts := { holdco with nonEligibleDividendsPaid := 8000000 }
example : dividendRefund paying = 3066666 ∧ partITax paying - dividendRefund paying = 800000 := by decide
-- Paying $40,000: half of it.
example : dividendRefund { holdco with nonEligibleDividendsPaid := 4000000 } = 1533333 := by decide

-- Part IV: a $10,000 eligible dividend from a public company costs $3,833.33, refunded when paid out.
def portfolio : Facts := { rates := { taxableIncome := 0 }, portfolioEligible := 1000000 }
example : partIV portfolio = 383333 ∧ eligibleAccount portfolio = 383333 := by decide
example : dividendRefund { portfolio with eligibleDividendsPaid := 1000000 } = 383333 := by decide
-- Paid out as a non-eligible dividend instead, the eligible account still funds the refund (129(1)(a)(ii)(B)).
example : refundCross { portfolio with nonEligibleDividendsPaid := 1000000 } = 383333 := by decide
-- An eligible dividend cannot draw on the non-eligible account.
example : dividendRefund { holdco with eligibleDividendsPaid := 8000000 } = 0 := by decide
-- A dividend from a connected subsidiary carries the subsidiary's refund (186(1)(b)).
example : partIV { rates := { taxableIncome := 0 }, connectedFromNonEligible := 3066666 } = 3066666 := by decide
-- A public corporation: no 10⅔% and no non-eligible account from Part I.
example : additionalTax { holdco with rates := { holdco.rates with ccpc := false } } = 0 := by decide
-- Active business income is not investment income: no refundable tax on it.
example : additionalTax { rates := { taxableIncome := 10000000, activeBusinessIncome := 10000000 } } = 0 := by decide

end Canteen.Tests.RefundableTax

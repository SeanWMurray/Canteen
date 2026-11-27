import Canteen.ITA.S3.CorporateYear

/-!
# Tests: a corporation's year

Opco, a CCPC, has $400,000 of active business income in 2025, $50,000 of interest, a $20,000 eligible
dividend from a public company, a $30,000 capital gain and a $10,000 gift, and pays $60,000 of
non-eligible dividends. Holdco receives a $100,000 dividend from a connected Opco with $40,000 of safe
income, a purpose of which is to reduce the gain on Opco's shares. Constructed examples.
-/

namespace Canteen.Tests.CorporateYear

open Canteen Canteen.ITA Canteen.ITA.CorporateYear

def sale : CapitalGains.Disposition := { description := "shares of Pubco", proceeds := 10000000, adjustedCostBase := 7000000 }
def bankco : Received := Received.portfolio "a dividend from Bankco" 2000000 (eligible := true)

def opco : Facts := { taxationYear := 2025, activeBusinessIncome := 40000000, propertyIncome := 5000000, dividends := [bankco], capital := ⟨[sale], 0, {}⟩, gifts := [⟨2025, 1000000⟩], nonEligibleDividendsPaid := 6000000 }

-- Income: $400,000 + $50,000 + $20,000 + a $15,000 taxable capital gain = $485,000 (in half-cents).
example : income opco = 2 * 48500000 := by decide
-- Taxable income: less the $10,000 gift and the $20,000 dividend (112(1)): $455,000.
example : taxableIncome opco = 2 * 45500000 := by decide
-- Aggregate investment income: the $15,000 gain and the $50,000 of interest; not the dividend.
example : aggregateInvestmentIncome opco = 2 * 6500000 := by decide
-- Part I: 28% of $455,000 less 19% of $400,000 (125(1)), $51,400, plus 10⅔% of the $55,000 over the small
-- business amount (123.3), $5,866.66.
example : partITax opco = 5726666 := by decide
example : RefundableTax.additionalTax (refundableFacts opco) = 586666 := by decide
-- Part IV: 38⅓% of the $20,000 portfolio dividend.
example : partIVTax opco = 766666 := by decide
-- The $60,000 of non-eligible dividends would draw $23,000: $16,866.66 from the non-eligible account
-- (30⅔% of $55,000) and the rest from the eligible account (129(1)(a)(ii)(B)).
example : RefundableTax.nonEligibleAccount (refundableFacts opco) = 1686666 := by decide
example : dividendRefund opco = 2300000 := by decide
example : netTax opco = 5726666 + 766666 - 2300000 := by decide
-- GRIP: no adjusted taxable income left over, so the pool is the $20,000 eligible dividend received.
example : GeneralRateIncomePool.pool (gripFacts opco) = 2000000 := by decide
-- CDA: the untaxed half of the gain.
example : capitalDividendAccount opco = 2 * 1500000 := by decide

-- A net capital loss of 2022 claimed ($10,000 in half-cents is $5,000) comes off taxable income and investment income.
def opcoLoss : Facts := { opco with netCapitalLossClaims := [⟨2022, 1000000, (1, 2)⟩] }
example : taxableIncome opcoLoss = 2 * 45500000 - 1000000 := by decide
example : aggregateInvestmentIncome opcoLoss = 2 * 6500000 - 1000000 := by decide

-- Not a CCPC: no small business deduction, no 123.3 tax, a refund only of the eligible account.
def pubco : Facts := { opco with ccpc := false }
example : RefundableTax.additionalTax (refundableFacts pubco) = 0 := by decide
example : CorporateRates.smallBusinessAmount (ratesFacts pubco) = 0 := by decide

-- A dividend from a non-resident corporation is not deductible: income from property, no Part IV tax.
def foreignco : Received := { dividend := { description := "a dividend from Foreignco", amount := 1000000, payer := .other, reducesGain := .fact false, safeIncome := 0 } }
def opcoForeign : Facts := { opco with dividends := [bankco, foreignco] }
example : aggregateInvestmentIncome opcoForeign = 2 * 7500000 := by decide
example : partIVTax opcoForeign = 766666 := by decide
example : dividendDeduction opcoForeign = 2000000 := by decide

-- Losses from property reduce investment income.
example : aggregateInvestmentIncome { opco with propertyLosses := 2000000 } = 2 * 4500000 := by decide

-- Holdco: $60,000 over safe income is a capital gain (55(2)(c)); $40,000 stays a dividend, deducted.
def strip : Received := { dividend := { description := "the dividend on Opco's shares", amount := 10000000, reducesGain := .fact true, safeIncome := 4000000 }, connected := true }
def holdco : Facts := { taxationYear := 2025, dividends := [strip] }
example : dividendsIncluded holdco = 4000000 ∧ dividendDeduction holdco = 4000000 := by decide
example : income holdco = 2 * 7000000 := by decide
example : taxableIncome holdco = 2 * 3000000 := by decide
example : aggregateInvestmentIncome holdco = 2 * 3000000 := by decide
-- 28% of $30,000, all investment income (no 13% reduction), plus 10⅔%: $11,600.
example : partITax holdco = 1160000 := by decide
-- The untaxed half of the 55(2) gain is in the capital dividend account.
example : capitalDividendAccount holdco = 2 * 3000000 := by decide
-- Connected: Part IV tax is the share of Opco's refund, here none.
example : partIVTax holdco = 0 := by decide
-- On a redemption the caught part goes to proceeds instead (given in the disposition), not a separate gain.
def redemption : Facts := { holdco with dividends := [{ strip with dividend := { strip.dividend with onRedemption := true, unrelatedEvents := [.dispositionOfProperty] } }] }
example : income redemption = 2 * 4000000 := by decide
-- With a connected payer's $10,000 refund on the dividend, Holdco pays $10,000 of Part IV tax.
example : partIVTax { holdco with dividends := [{ strip with refundFromNonEligible := 1000000 }] } = 1000000 := by decide

-- The judgment calls the conclusions rest on.
def judged : Facts := { holdco with dividends := [{ strip with dividend := { strip.dividend with reducesGain := .judged "J-55" true } }] }
example : (explain judged).reliesOn = ["J-55"] := by decide

end Canteen.Tests.CorporateYear

namespace Canteen.Tests.CorporateYear.Losses

open Canteen Canteen.ITA Canteen.ITA.CorporateYear Canteen.Tests.CorporateYear

-- Opco with a $100,000 non-capital loss of 2023: by default all of it is deducted, $355,000 left.
def opcoNcl : Facts := { opco with nonCapitalLosses := [⟨2023, 2 * 10000000⟩] }
example : taxableIncome opcoNcl = 2 * 35500000 := by decide
example : nonCapitalLossesForward opcoNcl = [] := by decide
-- A claim of $40,000 only: $415,000 taxable, $60,000 carried forward.
def opcoPart : Facts := { opcoNcl with nonCapitalLossClaim := some (2 * 4000000) }
example : taxableIncome opcoPart = 2 * 41500000 := by decide
example : nonCapitalLossesForward opcoPart = [⟨2023, 2 * 6000000⟩] := by decide
-- The default claim never takes more than taxable income: a small year leaves the rest for later.
def smallYear : Facts := { taxationYear := 2025, propertyIncome := 3000000, nonCapitalLosses := [⟨2023, 2 * 10000000⟩] }
example : taxableIncome smallYear = 0 ∧ nonCapitalLossesForward smallYear = [⟨2023, 2 * 7000000⟩] := by decide

-- Holdco: a $100,000 portfolio dividend and $30,000 of interest over its property income. The dividend
-- is deducted in full; the property loss is a non-capital loss of $30,000 (111(8)), though income is $70,000.
def holdcoLoss : Facts := { taxationYear := 2025, propertyLosses := 3000000, dividends := [Received.portfolio "a dividend from Bankco" 10000000] }
example : income holdcoLoss = 2 * 7000000 := by decide
example : taxableIncome holdcoLoss = 0 := by decide
example : nonCapitalLoss holdcoLoss = 2 * 3000000 := by decide
example : nonCapitalLossesForward holdcoLoss = [⟨2025, 2 * 3000000⟩] := by decide
-- No Part I tax, but Part IV tax on the dividend all the same (186(1)(c), (d) not encoded).
example : partITax holdcoLoss = 0 ∧ partIVTax holdcoLoss = 3833333 := by decide
-- Next year that loss reduces income from a $50,000 interest year to $20,000.
example : taxableIncome { taxationYear := 2026, propertyIncome := 5000000, nonCapitalLosses := nonCapitalLossesForward holdcoLoss } = 2 * 2000000 := by decide

end Canteen.Tests.CorporateYear.Losses

namespace Canteen.Tests.CorporateYear.PartIVLosses

open Canteen Canteen.ITA Canteen.ITA.CorporateYear Canteen.Tests.CorporateYear Canteen.Tests.CorporateYear.Losses

-- 186(1)(c): Holdco claims its $30,000 loss of the year against Part IV tax: 38⅓% of it, $11,500, off
-- the $38,333.33; nothing of the loss is left to carry forward.
def holdcoClaim : Facts := { holdcoLoss with partIVOwnLossClaim := 2 * 3000000 }
example : partIVTax holdcoClaim = 3833333 - 1150000 := by decide
example : nonCapitalLossesForward holdcoClaim = [] := by decide
-- A claim over the loss is limited to it.
example : partIVTax { holdcoLoss with partIVOwnLossClaim := 2 * 9000000 } = 3833333 - 1150000 := by decide
-- Half claimed: $15,000 carries forward.
example : nonCapitalLossesForward { holdcoLoss with partIVOwnLossClaim := 2 * 1500000 } = [⟨2025, 2 * 1500000⟩] := by decide
-- The reduction comes off the non-eligible part: with the dividend eligible, the eligible account keeps
-- what is left of the Part IV tax.
def holdcoEligible : Facts := { holdcoClaim with dividends := [Received.portfolio "a dividend from Bankco" 10000000 (eligible := true)] }
example : RefundableTax.partIVEligible (refundableFacts holdcoEligible) = 3833333 - 1150000 := by decide
-- 186(1)(d): a $20,000 loss of 2023, not needed against Part I (no taxable income), claimed against Part IV.
def holdcoCarried : Facts := { holdcoLoss with nonCapitalLosses := [⟨2023, 2 * 2000000⟩], partIVCarriedLossClaim := 2 * 2000000 }
example : partIVTax holdcoCarried = 3833333 - 766666 := by decide
example : nonCapitalLossesForward holdcoCarried = [⟨2025, 2 * 3000000⟩] := by decide

end Canteen.Tests.CorporateYear.PartIVLosses

namespace Canteen.Tests.CorporateYear.Grind

open Canteen Canteen.ITA Canteen.ITA.CorporateYear Canteen.Tests.CorporateYear

-- Opco's adjusted aggregate investment income: the $15,000 gain, the $50,000 of interest and the $20,000
-- portfolio dividend (deducted under 112(1), but not from a connected corporation): $85,000.
example : adjustedAggregateInvestmentIncome opco = 2 * 8500000 := by decide
-- Had the shares sold been an active asset (shares of a connected small business), the gain is left out.
example : adjustedAggregateInvestmentIncome { opco with activeAssets := ["shares of Pubco"] } = 2 * 7000000 := by decide
-- Holdco's dividend from connected Opco is left out; its 55(2) gain is not.
example : adjustedAggregateInvestmentIncome holdco = 2 * 3000000 := by decide

-- Next year Opco's business limit is ground by 5 × ($85,000 − $50,000): $325,000.
def opcoNext : Facts := { opco with taxationYear := 2026, businessLimitFacts := some { groupInvestmentIncome := adjustedAggregateInvestmentIncome opco / 2 } }
example : businessLimit opcoNext = 32500000 := by decide
-- So $75,000 of its $400,000 of active business income loses the small business rate.
example : CorporateRates.smallBusinessAmount (ratesFacts opcoNext) = 32500000 := by decide

end Canteen.Tests.CorporateYear.Grind

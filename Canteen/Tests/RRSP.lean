import Canteen.ITA.S146.RRSP
import Canteen.ITA.S3.IndividualYear

/-!
# Tests: the RRSP deduction (146(1), (5), (5.1))

The dollar limit is given (as for 2025, $32,490). Constructed examples.
-/

namespace Canteen.Tests.RRSP

open Canteen Canteen.ITA Canteen.ITA.RRSP

-- $100,000 earned last year, no pension: 18% is $18,000; with $5,000 of unused room, a $23,000 limit.
def saver : Facts := { unusedRoom := 500000, dollarLimit := 3249000, earnedIncomePrior := 10000000, premiums := 2000000 }
example : newRoom saver = 1800000 ∧ limit saver = 2300000 := by decide
-- $20,000 contributed: all deducted; $3,000 of room left.
example : deduction saver = 2000000 ∧ unusedAtEnd saver = 300000 := by decide
-- $250,000 earned: capped at the dollar limit.
example : newRoom { saver with earnedIncomePrior := 25000000 } = 3249000 := by decide
-- A pension adjustment of $10,000 reduces it.
example : newRoom { saver with pensionAdjustment := 1000000 } = 800000 := by decide
-- $30,000 contributed: $23,000 deducted, $7,000 carried forward.
example : deduction { saver with premiums := 3000000 } = 2300000 ∧ undeducted { saver with premiums := 3000000 } = 700000 := by decide
-- Contributions to a spousal plan count against the contributor's limit.
example : deduction { saver with premiums := 1500000, spousalPremiums := 1500000 } = 2300000 := by decide
-- Claiming less, to deduct later when the rate is higher.
example : deduction { saver with claim := some 500000 } = 500000 ∧ undeducted { saver with claim := some 500000 } = 1500000 := by decide

-- In an individual's year: $100,000 of salary, the $20,000 contribution deducted: income $80,000.
def year : IndividualYear.Facts := { taxationYear := 2025, employmentAndBusiness := 10000000, rrsp := some saver }
example : IndividualYear.rrspDeduction year = 2000000 ∧ IndividualYear.income year = 2 * 8000000 := by decide
-- It saves tax at the marginal rate: 20.5% of $20,000, $4,100.
example : IndividualYear.federalTax { year with rrsp := none } - IndividualYear.federalTax year = 410000 := by decide

-- Earned income: $100,000 of salary and $12,000 of net rent, less a $2,000 business loss: $110,000;
-- next year's room at a $33,000 dollar limit: 18%, $19,800.
def earned : EarnedIncome := { employment := 10000000, rentalAndRoyalties := 1200000, losses := 200000 }
example : earned.amount = 11000000 ∧ nextRoom earned 3300000 0 = 1980000 := by decide
-- Support paid comes off; support received counts.
example : ({ earned with supportPaid := 1000000 } : EarnedIncome).amount = 10000000 := by decide
-- From an individual's year: $100,000 of salary.
example : (IndividualYear.earnedIncome year).amount = 10000000 := by decide

end Canteen.Tests.RRSP

import Canteen.ITA.S89.GeneralRateIncomePool

/-!
# Tests: the general rate income pool (89(1)) and Part III.1 tax (185.1(1))

Opco, a CCPC, earns $1,000,000 of active business income; its business limit is $500,000.
Constructed examples.
-/

namespace Canteen.Tests.GeneralRateIncomePool

open Canteen Canteen.ITA Canteen.ITA.GeneralRateIncomePool

def opco : Facts := { rates := { taxableIncome := 100000000, activeBusinessIncome := 100000000 } }

-- Adjusted taxable income: the $500,000 taxed at the general rate; 72% of it, $360,000, is the pool.
example : adjustedTaxableIncome opco = 50000000 ∧ pool opco = 36000000 := by decide
-- $360,000 of eligible dividends: none excessive.
example : excessive { opco with eligiblePaid := 36000000 } = 0 := by decide
-- $400,000: $40,000 excessive, and $8,000 of Part III.1 tax (20%).
example : excessive { opco with eligiblePaid := 40000000 } = 4000000 ∧ partIII1 { opco with eligiblePaid := 40000000 } = 800000 := by decide
-- Where the pool was artificially increased, the whole dividend is excessive, at 30%.
example : partIII1 { opco with eligiblePaid := 36000000, artificial := .fact true } = 10800000 := by decide
-- All income within the business limit: nothing goes into the pool.
example : pool { opco with rates := { opco.rates with businessLimit := 100000000 } } = 0 := by decide
-- Investment income does not go into the pool for a CCPC...
example : pool { rates := { taxableIncome := 10000000, aggregateInvestmentIncome := 10000000 } } = 0 := by decide
-- ...but eligible dividends received do.
example : pool { rates := { taxableIncome := 0 }, eligibleReceived := 1000000 } = 1000000 := by decide
-- Last year's eligible dividends come off, except those designated excessive; the pool can go negative.
example : pool { opco with priorPool := 0, eligiblePaidLastYear := 40000000, excessiveLastYear := 4000000 } = 0 := by decide
example : pool { rates := { taxableIncome := 0 }, eligiblePaidLastYear := 1000000 } = -1000000 := by decide
-- A negative pool makes every eligible dividend excessive.
example : excessive { rates := { taxableIncome := 0 }, priorPool := -1000000, eligiblePaid := 500000 } = 500000 := by decide
-- Not a CCPC: no small business deduction, so all its income is adjusted taxable income.
example : adjustedTaxableIncome { rates := { taxableIncome := 10000000, activeBusinessIncome := 10000000, ccpc := false } } = 10000000 := by decide


/-! ## The 185.1(2) election -/

def over : Facts := { opco with eligiblePaid := 40000000 }
-- Electing the whole $40,000 excess: $360,000 stays eligible, $40,000 becomes non-eligible, no Part III.1 tax.
example : elected over ⟨4000000, true⟩ = 4000000 ∧ eligibleAfter over ⟨4000000, true⟩ = 36000000 ∧
    partIII1After over ⟨4000000, true⟩ = 0 := by decide
-- Claiming more than the excess elects only the excess.
example : elected over ⟨10000000, true⟩ = 4000000 := by decide
-- Electing half: Part III.1 tax on the other $20,000, $4,000.
example : partIII1After over ⟨2000000, true⟩ = 400000 := by decide
-- Without every shareholder's concurrence, the election is not valid.
example : elected over ⟨4000000, false⟩ = 0 ∧ partIII1After over ⟨4000000, false⟩ = 800000 := by decide
-- Not where the pool was artificially increased (185.1(1)(b)).
example : elected { over with artificial := .fact true } ⟨40000000, true⟩ = 0 := by decide

end Canteen.Tests.GeneralRateIncomePool

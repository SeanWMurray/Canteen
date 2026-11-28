import Canteen.ITA.S128_1.Emigration

/-!
# Tests: the deemed disposition on emigration (128.1(4)(b), (c))

An individual leaves Canada for Australia. Constructed examples.
-/

namespace Canteen.Tests.Emigration

open Canteen Canteen.ITA Canteen.ITA.Emigration

def portfolio : Holding := { description := "a portfolio of US shares", fairMarketValue := 50000000, adjustedCostBase := 30000000 }
def condo : Holding := { description := "the Vancouver condominium", fairMarketValue := 90000000, adjustedCostBase := 60000000, canadianRealProperty := true }
def rrsp : Holding := { description := "the RRSP", fairMarketValue := 40000000, adjustedCostBase := 0, excludedRight := true }
def leaving : Facts := { holdings := [portfolio, condo, rrsp] }

-- Only the portfolio: a $200,000 gain, $100,000 taxable.
example : (dispositions leaving).length = 1 := by decide
example : netTaxableGains leaving = 2 * 10000000 := by decide
-- The portfolio is reacquired at $500,000; the condo keeps its $600,000 cost.
example : portfolio.costAfter leaving = 50000000 ∧ condo.costAfter leaving = 60000000 := by decide
-- Shares with an accrued loss: the loss is realized too.
def loser : Holding := { description := "shares of Techco", fairMarketValue := 10000000, adjustedCostBase := 25000000 }
example : netTaxableGains { holdings := [portfolio, loser] } = 2 * 2500000 := by decide
-- A short-term resident (48 of the last 120 months) who brought the portfolio to Canada: not deemed disposed of.
example : netTaxableGains { holdings := [{ portfolio with ownedOnArrivalOrInherited := true }], monthsResident := 48 } = 0 := by decide
-- Resident 72 months: it is.
example : netTaxableGains { holdings := [{ portfolio with ownedOnArrivalOrInherited := true }], monthsResident := 72 } = 2 * 10000000 := by decide

-- 128.1(1): arriving from Australia with shares of an Australian company bought for $100,000, now
-- worth $300,000: their cost in Canada is $300,000.
def ausShares : Arriving := { description := "shares of an Australian company", fairMarketValue := 30000000, adjustedCostBase := 10000000 }
example : ausShares.costOnArrival = 30000000 := by decide
-- A Toronto rental property already owned (taxable Canadian property): keeps its cost.
example : ({ description := "a Toronto rental", fairMarketValue := 80000000, adjustedCostBase := 50000000, property := some (.realProperty true) } : Arriving).costOnArrival = 50000000 := by decide
-- An excluded right (a foreign pension, say): keeps its cost.
example : ({ ausShares with excludedRight := true } : Arriving).costOnArrival = 10000000 := by decide

end Canteen.Tests.Emigration

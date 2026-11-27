import Canteen.ITA.S125.BusinessLimit

/-!
# Tests: the business limit (125(2), (3), (5)(b), (5.1))

Constructed examples.
-/

namespace Canteen.Tests.BusinessLimit

open Canteen Canteen.ITA Canteen.ITA.BusinessLimit

-- Not associated: $500,000.
example : limit {} = 50000000 := by decide
-- Associated, with 60% assigned: $300,000; without an agreement, nil; percentages over 100%, nil.
example : limit { associated := true, assigned := some 6000 } = 30000000 := by decide
example : limit { associated := true } = 0 := by decide
example : limit { associated := true, assigned := some 6000, totalAssigned := 12000 } = 0 := by decide
-- A first year of 146 days: 146/365 of $500,000, $200,000. A year of 357 days (51 weeks) is not prorated.
example : limit { days := 146 } = 20000000 := by decide
example : limit { days := 357 } = 50000000 := by decide
-- Passive income: $100,000 of adjusted aggregate investment income takes 5 × $50,000 off: $250,000.
example : limit { groupInvestmentIncome := 10000000 } = 25000000 := by decide
-- $150,000 or more: nil.
example : limit { groupInvestmentIncome := 15000000 } = 0 := by decide
-- $50,000 or less: no reduction.
example : limit { groupInvestmentIncome := 5000000 } = 50000000 := by decide
-- Taxable capital of $30 million: 0.225% × $20 million = $45,000, half of $90,000: $250,000.
example : limit { taxableCapital := 3000000000 } = 25000000 := by decide
-- $50 million: nil.
example : limit { taxableCapital := 5000000000 } = 0 := by decide
-- Both: the greater reduction applies, not both together. $20M of capital takes $125,000; $80,000 of
-- passive income takes $150,000: $350,000.
example : capitalReduction { taxableCapital := 2000000000, groupInvestmentIncome := 8000000 } = 12500000 := by decide
example : limit { taxableCapital := 2000000000, groupInvestmentIncome := 8000000 } = 35000000 := by decide
-- The grind applies to the shared limit: 60% of $500,000, less 5 × $10,000 × 60%.
example : limit { associated := true, assigned := some 6000, groupInvestmentIncome := 6000000 } = 27000000 := by decide

-- 256(2)(b)(ii): the electing third corporation has no business limit; the two others keep theirs.
example : limit { electedThird := true } = 0 := by decide

end Canteen.Tests.BusinessLimit

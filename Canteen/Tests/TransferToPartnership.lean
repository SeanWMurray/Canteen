import Canteen.ITA.S96.TransferToPartnership

/-!
# Tests: transferring property to a partnership (97(2))

Land with a $100,000 cost and a $500,000 value. Constructed examples.
-/

namespace Canteen.Tests.TransferToPartnership

open Canteen Canteen.ITA Canteen.ITA.TransferToPartnership

def land : Facts := { description := "the land", fairMarketValue := 50000000, costAmount := 10000000, agreed := 10000000 }
-- At cost, for a partnership interest: no gain; the interest's cost goes up by $100,000.
example : proceeds land = 10000000 ∧ gain land = 0 ∧ interestCostChange land = 10000000 := by decide
-- $150,000 of cash too: the proceeds rise to it; a $50,000 gain; the interest's cost does not change.
example : proceeds { land with boot := 15000000 } = 15000000 ∧ interestCostChange { land with boot := 15000000 } = 0 := by decide
-- $600,000 of cash, more than the land's value: proceeds capped at $500,000; the interest's cost falls $100,000.
example : proceeds { land with boot := 60000000 } = 50000000 ∧ interestCostChange { land with boot := 60000000 } = -10000000 := by decide
-- Without the joint election: at value, a $400,000 gain.
example : gain { land with jointElection := false } = 40000000 := by decide
-- An agreed amount below cost is raised to the lesser of value and cost.
example : proceeds { land with agreed := 0 } = 10000000 := by decide
-- Taxable Canadian property in: the interest is taxable Canadian property for 60 months.
example : interestTCP { land with taxableCanadian := true } = true := by decide

end Canteen.Tests.TransferToPartnership

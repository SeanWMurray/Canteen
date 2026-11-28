import Canteen.ITA.S107.TrustDistribution

/-!
# Tests: distributions of trust property (107(2), (2.1), (4.1))

A family trust distributes shares worth $900,000, which cost it $100,000, to an adult child.
Constructed examples.
-/

namespace Canteen.Tests.TrustDistribution

open Canteen Canteen.ITA Canteen.ITA.TrustDistribution

def shares : Distribution := { description := "the Opco shares", trustCost := 10000000, fairMarketValue := 90000000 }
-- The rollover: no gain to the trust; the child takes the trust's $100,000 cost.
example : shares.trustGain = 0 ∧ shares.beneficiaryCost = 10000000 := by decide
-- The parent who settled the trust is a trustee whose consent each sale needs (75(2)): no rollover; an
-- $800,000 gain to the trust, and the child's cost is $900,000.
def tainted : Distribution := { shares with section75_2Applied := true }
example : tainted.trustGain = 80000000 ∧ tainted.beneficiaryCost = 90000000 := by decide
-- The same distribution back to the parent who contributed the shares: the rollover applies.
example : ({ tainted with toContributorOrSpouse := true } : Distribution).trustGain = 0 := by decide
-- After the parent's death: 107(4.1)(d) no longer applies.
example : ({ tainted with contributorExists := false } : Distribution).trustGain = 0 := by decide
-- A capital interest bought for $50,000 (cost amount nil): the child's cost is bumped by $50,000.
example : ({ shares with interestACB := 5000000 } : Distribution).beneficiaryCost = 15000000 := by decide
-- Depreciable property: half the bump.
example : ({ shares with interestACB := 5000000, nonDepreciableCapital := false } : Distribution).beneficiaryCost = 12500000 := by decide

end Canteen.Tests.TrustDistribution

import Canteen.ITA.S96.Partnership

/-!
# Tests: partnerships (96(1), 53(1)(e), 53(2)(c), 40(3.1), (3.12))

A real estate limited partnership. Constructed examples.
-/

namespace Canteen.Tests.Partnership

open Canteen Canteen.ITA Canteen.ITA.Partnership

-- A year with $100,000 of rental income and a $40,000 capital gain; a 25% member.
def good : Year := { income := 10000000, capitalGains := 4000000 }
def ana : Member := { name := "Ana", shareBp := 2500, openingACB := 5000000, drawings := 2000000 }
example : ana.income good = 2500000 ∧ ana.taxableCapitalGains good = 500000 := by decide
-- At the end of the period, the cost is $50,000 − $20,000 drawn = $30,000 (the period's income goes in
-- after); the next period opens at $30,000 + $25,000 + the whole $10,000 gain = $65,000.
example : ana.acbBefore good = 3000000 ∧ ana.nextOpening good = 6500000 := by decide
-- A bad year: $300,000 of losses; a 25% limited partner with $50,000 of cost who draws $42,500. At the end
-- of the period its cost is $7,500 (no 40(3.1) gain); at risk $7,500, so $7,500 of its $75,000 share of
-- losses is deductible and $67,500 is a limited partnership loss; the next period opens at nil.
def bad : Year := { losses := 30000000 }
def ltd : Member := { name := "Ben", shareBp := 2500, limited := true, openingACB := 5000000, drawings := 4250000 }
example : ltd.acbBefore bad = 750000 ∧ ltd.deemedGain bad = 0 := by decide
example : ltd.atRisk bad = 750000 ∧ ltd.deductibleLoss bad = 750000 ∧ ltd.limitedPartnershipLoss bad = 6750000 := by decide
example : ltd.nextOpening bad = 0 := by decide
-- A general partner in the same position: all $75,000 deductible; the next period opens at −$67,500.
example : ({ ltd with limited := false } : Member).deductibleLoss bad = 7500000 ∧ ({ ltd with limited := false } : Member).nextOpening bad = -6750000 := by decide
-- Distributions over the cost: a limited partner with $10,000 of cost draws $30,000: −$20,000 at the end of
-- the period, a $20,000 gain under 40(3.1), and the cost reset to nil.
def overdrawn : Member := { name := "Cy", shareBp := 1000, limited := true, openingACB := 1000000, drawings := 3000000 }
example : overdrawn.deemedGain {} = 2000000 ∧ overdrawn.acbAfter {} = 0 := by decide
-- An amount owed to the partnership reduces the amount at risk.
example : ({ ltd with amountsOwing := 500000 } : Member).atRisk bad = 250000 := by decide
-- 40(3.12): later, with $30,000 of cost back and $20,000 of earlier gains: $20,000 may be elected as a loss.
example : ({ overdrawn with openingACB := 0, drawings := 0, contributions := 3000000, priorDeemedGains := 2000000 } : Member).electableLoss {} = 2000000 := by decide

end Canteen.Tests.Partnership

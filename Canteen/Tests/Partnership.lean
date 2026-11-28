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
-- Cost: $50,000 + $25,000 + the whole $10,000 gain − $20,000 drawn = $65,000.
example : ana.acbBefore good = 6500000 := by decide
-- A bad year: $300,000 of losses; a 25% limited partner with $50,000 of cost who draws $42,500: $50,000 −
-- $75,000 − $42,500 = −$67,500, a $67,500 gain under 40(3.1), and the cost back to nil.
def bad : Year := { losses := 30000000 }
def ltd : Member := { name := "Ben", shareBp := 2500, limited := true, openingACB := 5000000, drawings := 4250000 }
example : ltd.acbBefore bad = -6750000 := by decide
example : ltd.deemedGain bad = 6750000 ∧ ltd.acbAfter bad = 0 := by decide
-- A general partner in the same position: no gain; the cost stays negative.
example : ({ ltd with limited := false } : Member).deemedGain bad = 0 ∧ ({ ltd with limited := false } : Member).acbAfter bad = -6750000 := by decide
-- 40(3.12): the next year, with $30,000 of cost back and $67,500 of earlier gains: up to $30,000 may be elected as a loss.
example : ({ ltd with openingACB := 0, drawings := 0, contributions := 3000000, priorDeemedGains := 6750000 } : Member).electableLoss {} = 3000000 := by decide

end Canteen.Tests.Partnership

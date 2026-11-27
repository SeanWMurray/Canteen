import Canteen.ITA.S46.PersonalUse

/-!
# Tests: personal-use property, the $1,000 rule (46)

Constructed examples.
-/

namespace Canteen.Tests.PersonalUse

open Canteen Canteen.ITA Canteen.ITA.PersonalUse

def item (cost proceeds : Cents) : CapitalGains.Disposition := { description := "a painting", proceeds, adjustedCostBase := cost }

-- Bought for $400, sold for $900: both are raised to $1,000, no gain.
example : (apply (item 40000 90000)).gain = 0 := by decide
-- Sold for $2,500: a $1,500 gain, not $2,100.
example : (apply (item 40000 250000)).gain = 150000 := by decide
-- Bought for $3,000, sold for $500: the proceeds are raised to $1,000.
example : (apply (item 300000 50000)).proceeds = 100000 := by decide
-- Excluded property given to a charity: no floor.
example : (apply (item 40000 90000) true).gain = 50000 := by decide

-- Six antique chairs, $100 each ($600 in all), worth $6,000 as a set, sold one at a time to the same buyer for $1,000 each.
def chair : CapitalGains.Disposition := item 10000 100000
def chairs (asSet : Answer) : SetFacts := { ordinarilyASet := asSet, piecemealToOneGroup := true, totalValue := 600000 }

-- As a set (46(3)): each chair is part of one property, with a sixth of the $1,000, $166.66: an $833.34 gain on each.
example : set.holds (chairs (.fact true)) = true ∧ (applyPiece (chairs (.fact true)) chair 60000).gain = 83334 := by decide
-- Taken one by one, each would get the whole $1,000 floor and show no gain: what 46(3) prevents.
example : (apply chair).gain = 0 := by decide
-- Not ordinarily a set (judged): each chair stands alone; the explanation rests on the call.
example : (applyPiece (chairs (.judged "J-SET" false)) chair 60000).gain = 0 ∧
    (set.explain (chairs (.judged "J-SET" false))).reliesOn = ["J-SET"] := by decide
-- Sold to unrelated buyers, or worth $1,000 or less in total: not 46(3).
example : set.holds { chairs (.fact true) with piecemealToOneGroup := false } = false ∧
    set.holds { chairs (.fact true) with totalValue := 100000 } = false := by decide

end Canteen.Tests.PersonalUse

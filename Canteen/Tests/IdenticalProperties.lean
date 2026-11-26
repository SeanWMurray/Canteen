import Canteen.ITA.S47.IdenticalProperties

/-!
# Tests: identical properties (47(1))

Shares of ABC Ltd. bought at different prices. Constructed examples.
-/

namespace Canteen.Tests.IdenticalProperties

open Canteen Canteen.ITA Canteen.ITA.IdenticalProperties

-- 100 shares at $10 and 100 at $13: an average cost of $11.50.
def bought : Pool := (run "shares of ABC Ltd." {} [.buy 100 100000, .buy 100 130000]).1
example : bought = ⟨200, 230000⟩ ∧ bought.average = 1150 := by decide
-- Selling 50 for $700: their cost is $575, a $125 gain; 150 shares costing $1,725 remain.
def afterSale := run "shares of ABC Ltd." {} [.buy 100 100000, .buy 100 130000, .sell 50 70000]
example : afterSale.1 = ⟨150, 172500⟩ := by decide
example : (afterSale.2.map (·.gain)) = [12500] := by decide
-- Buying more after the sale re-averages: 150 at $11.50 and 50 at $15.50 average $12.50.
example : (run "shares of ABC Ltd." {} [.buy 100 100000, .buy 100 130000, .sell 50 70000, .buy 50 77500]).1.average = 1250 := by
  decide

-- Three shares bought for $10.00 in all, sold one at a time: $3.33, $3.33, $3.34. No cent is lost.
def thirds := run "shares" {} [.buy 3 1000, .sell 1 500, .sell 1 500, .sell 1 500]
example : thirds.2.map (·.adjustedCostBase) = [333, 333, 334] ∧ thirds.1 = ⟨0, 0⟩ := by decide

-- A superficial loss of $509.99 added to the cost of the 100 shares bought back (53(1)(f)).
example : (run "shares" {} [.buy 100 100000, .addToCost 50999]).1.average = 1509 := by decide

-- Selling more than the pool holds is read as selling all of it.
example : (run "shares" {} [.buy 10 1000, .sell 20 3000]).2.map (·.adjustedCostBase) = [1000] := by decide

-- The pool feeds the capital gains computation.
example : CapitalGains.Year.paragraph3b ⟨afterSale.2, 0, {}⟩ = 12500 := by decide

end Canteen.Tests.IdenticalProperties

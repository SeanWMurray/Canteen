import Canteen.ITA.S43.PartialDisposition

/-!
# Tests: disposing of part of a property (43(1))

A 100-acre farm property costing $300,000 and worth $1,000,000; 10 road-front acres, worth
$250,000, are sold for that. Constructed examples.
-/

namespace Canteen.Tests.PartialDisposition

open Canteen Canteen.ITA Canteen.ITA.PartialDisposition

def roadFront : Facts :=
  { description := "10 road-front acres", adjustedCostBase := 30000000, partMeasure := 25000000, wholeMeasure := 100000000,
    reasonable := .judged "J-43" true, proceeds := 25000000 }

-- By value, a quarter of the cost: $75,000; a $175,000 gain; $225,000 of cost stays with the rest.
example : partCost roadFront = 7500000 ∧ (disposition roadFront).gain = 17500000 ∧ remainingCost roadFront = 22500000 := by decide
-- By area instead (10 of 100 acres), a tenth: $30,000, and a $220,000 gain. Which is reasonable is J-43.
example : partCost { roadFront with partMeasure := 10, wholeMeasure := 100 } = 3000000 := by decide
#guard (explain roadFront).reliesOn == ["J-43"]

end Canteen.Tests.PartialDisposition

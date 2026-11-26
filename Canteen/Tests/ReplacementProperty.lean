import Canteen.ITA.S44.ReplacementProperty

/-!
# Tests: replacement property (44(1))

A warehouse with a $400,000 adjusted cost base is expropriated in 2024 for $1,000,000. Constructed
examples.
-/

namespace Canteen.Tests.ReplacementProperty

open Canteen Canteen.ITA Canteen.ITA.ReplacementProperty

def warehouse : Facts :=
  { description := "the warehouse", kind := .involuntary, initialYear := 2024, replacedInYear := some 2025,
    proceeds := 100000000, adjustedCostBase := 40000000, replacementCost := 90000000 }

-- Replaced for $900,000: only the $100,000 not reinvested is a gain; $500,000 is deferred.
example : gain warehouse = 10000000 ∧ deferred warehouse = 50000000 ∧ replacementCostAfter warehouse = 40000000 := by decide
example : (disposition warehouse).gain = 10000000 := by decide
-- Replaced for $1,200,000: the whole gain is deferred.
example : gain { warehouse with replacementCost := 120000000 } = 0 ∧
    replacementCostAfter { warehouse with replacementCost := 120000000 } = 60000000 := by decide
-- Expropriation: until the end of the second year after (2026); not 2027.
example : applies.holds { warehouse with replacedInYear := some 2026 } = true := by decide
example : gain { warehouse with replacedInYear := some 2027 } = 60000000 := by decide
-- A former business property sold: only until the end of the first year after.
example : applies.holds { warehouse with kind := .formerBusinessProperty, replacedInYear := some 2025 } = true := by decide
example : applies.holds { warehouse with kind := .formerBusinessProperty, replacedInYear := some 2026 } = false := by decide
-- Not replaced, not elected, a share, or neither kind: the whole $600,000 gain.
example : gain { warehouse with replacedInYear := none } = 60000000 := by decide
example : gain { warehouse with elected := false } = 60000000 := by decide
example : gain { warehouse with share := true } = 60000000 := by decide
example : gain { warehouse with kind := .other } = 60000000 := by decide

/-! ## Read-back -/

#guard ((rule.explain warehouse).render.splitOn "\n" |>.drop 3) ==
  ["4. Therefore subsection 44(1) applies. [ITA 44(1)]",
   "5. The gain otherwise would be $600,000.00; the proceeds exceed the replacement property's cost of $900,000.00 (and outlays) by $100,000.00. The gain is the lesser, $100,000.00. [ITA 44(1)(e)(i)]",
   "6. The $500,000.00 deferred reduces the replacement property's cost to $400,000.00. [ITA 44(1)(f)]"]

end Canteen.Tests.ReplacementProperty

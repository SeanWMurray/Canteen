import Canteen.ITA.S117.Rates

/-!
# Tests: the federal rates (117(2))

2025 brackets. Constructed examples.
-/

namespace Canteen.Tests.Rates

open Canteen Canteen.ITA Canteen.ITA.Rates

example : tax 0 = 0 := by decide
-- $50,000: 14%, $7,000.
example : tax 5000000 = 700000 := by decide
-- $57,375, the top of the first bracket: $8,032.50.
example : tax 5737500 = 803250 := by decide
-- $100,000: $8,032.50 + 20.5% of $42,625 = $16,770.62.
example : tax 10000000 = 1677062 := by decide
-- $300,000: every bracket. $8,032.50 + $11,761.875 + $16,414.32 + $21,904.28 + 33% of $46,586 = $73,486.355, rounded down once.
example : tax 30000000 = 7348635 := by decide
-- Indexed brackets for a later year are given.
example : tax 6000000 { first := 6000000 } = 840000 := by decide

#guard (explain 10000000).steps.map (·.citation) == ["ITA 117(2)"]

end Canteen.Tests.Rates

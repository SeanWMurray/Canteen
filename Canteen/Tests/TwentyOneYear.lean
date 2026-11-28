import Canteen.ITA.S104.TwentyOneYear

/-!
# Tests: the 21-year deemed disposition (104(4))

Constructed examples.
-/

namespace Canteen.Tests.TwentyOneYear

open Canteen Canteen.ITA Canteen.ITA.TwentyOneYear

-- A family trust settled 2005-06-15: its 21st anniversary is 2026-06-15; then 2047 and 2068.
def family : Kind := .ordinary ⟨2005, 6, 15⟩
example : dayIn family 2026 = some ⟨2026, 6, 15⟩ ∧ dayIn family 2047 = some ⟨2047, 6, 15⟩ := by decide +kernel
example : dayIn family 2025 = none ∧ dayIn family 2030 = none := by decide +kernel
-- Its Opco shares, worth $5 million with a $100 cost: a deemed gain in 2026; leased equipment (depreciable) is not deemed disposed of.
def opco : Holding := { description := "the Opco shares", fairMarketValue := 500000000, adjustedCostBase := 10000 }
def equipment : Holding := { description := "leased equipment", fairMarketValue := 2000000, adjustedCostBase := 3000000, covered := false }
example : netTaxableGains family 2026 [opco, equipment] = 499990000 := by decide +kernel
example : netTaxableGains family 2025 [opco] = 0 := by decide +kernel
-- A trust created before 1972: January 1, 1993 was its first day.
example : dayIn (.ordinary ⟨1965, 3, 1⟩) 1993 = some ⟨1993, 1, 1⟩ := by decide +kernel
-- A spousal trust: the day the spouse dies, and 21 years later; nothing while the spouse is alive.
example : dayIn (.lifeInterest (some ⟨2030, 4, 2⟩)) 2030 = some ⟨2030, 4, 2⟩ ∧ dayIn (.lifeInterest (some ⟨2030, 4, 2⟩)) 2051 = some ⟨2051, 4, 2⟩ := by decide +kernel
example : dayIn (.lifeInterest none) 2030 = none := by decide

end Canteen.Tests.TwentyOneYear

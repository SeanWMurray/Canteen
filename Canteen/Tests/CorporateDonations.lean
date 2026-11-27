import Canteen.ITA.S110_1.CorporateDonations

/-!
# Tests: a corporation's charitable gifts (110.1(1)(a))

Opco has $100,000 of income in 2025. Constructed examples.
-/

namespace Canteen.Tests.CorporateDonations

open Canteen Canteen.ITA Canteen.ITA.CorporateDonations

def opco (gifts : List Gift) : Facts := { taxationYear := 2025, income := 10000000, gifts }

-- A $50,000 gift: all deducted.
example : deduction (opco [⟨2025, 5000000⟩]) = 5000000 := by decide
-- $120,000 of gifts: 75% of income, $75,000; $45,000 carries forward.
example : deduction (opco [⟨2025, 12000000⟩]) = 7500000 ∧ carriedForward (opco [⟨2025, 12000000⟩]) = 4500000 := by decide
-- A gift of shares with a $40,000 taxable capital gain lifts the limit by a quarter of it: $85,000.
example : limit { opco [] with giftGains := 4000000 } = 8500000 := by decide
-- Never more than income, however large the gains.
example : limit { opco [] with giftGains := 100000000 } = 10000000 := by decide
-- A gift from 2020 is still available in 2025; one from 2019 has expired.
example : availableTotal (opco [⟨2020, 1000000⟩, ⟨2019, 1000000⟩]) = 1000000 := by decide
-- A gift of a later year does not count yet.
example : availableTotal (opco [⟨2026, 1000000⟩]) = 0 := by decide
-- No income, no deduction.
example : deduction { opco [⟨2025, 5000000⟩] with income := 0 } = 0 := by decide

end Canteen.Tests.CorporateDonations

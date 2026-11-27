import Canteen.ITA.S111.NonCapitalLoss

/-!
# Tests: non-capital losses (111(8), 111(1)(a), 111(3))

Amounts in half-cents. Constructed examples.
-/

namespace Canteen.Tests.NonCapitalLoss

open Canteen Canteen.ITA Canteen.ITA.NonCapitalLoss

-- Losses of 2020 ($30,000), 2022 ($50,000), 2026 ($20,000, carried back) and 2004 ($10,000), in 2025.
def losses : List Loss := [⟨2026, 4000000⟩, ⟨2022, 10000000⟩, ⟨2004, 2000000⟩, ⟨2020, 6000000⟩]

-- 2004 is more than 20 years back: $100,000 is available.
example : availableTotal 2025 losses = 20000000 := by decide
-- Oldest first: 2020, 2022, then 2026.
example : (queue 2025 losses).map (·.year) = [2020, 2022, 2026] := by decide
-- A $60,000 claim uses all of 2020 and $30,000 of 2022.
example : take 12000000 (queue 2025 losses) = [6000000, 6000000, 0] := by decide
example : deduction 2025 12000000 losses = 12000000 := by decide
example : (remaining 2025 12000000 losses).map (·.unused) = [0, 4000000, 4000000] := by decide
-- A claim over the losses takes only what there is.
example : deduction 2025 30000000 losses = 20000000 := by decide
-- A loss of 2029 is too far ahead for 2025; one of 2025 itself is not deductible in it.
example : availableTotal 2025 [⟨2029, 1000000⟩, ⟨2025, 1000000⟩] = 0 := by decide
-- A 2005 loss is available in 2025 (the 20th year) and not in 2026.
example : (Loss.available ⟨2005, 1⟩ 2025, Loss.available ⟨2005, 1⟩ 2026) = (true, false) := by decide

-- 111(8): $100,000 of business losses and a $20,000 ABIL against $50,000 under 3(c): $70,000.
def year : Facts := { taxationYear := 2025, sourceLosses := 10000000, abil := 4000000, para3c := 10000000 }
example : amount year = 14000000 := by decide
-- From the eleventh following year the ABIL is out (it has become a net capital loss): $50,000.
example : amountAt year 2036 = 10000000 ∧ amountAt year 2035 = 14000000 := by decide
-- A 112(1) deduction counts in E.
example : amount { taxationYear := 2025, divisionC := 2 * 10000000, para3c := 2 * 7000000 } = 2 * 3000000 := by decide
-- Income covers the losses: none.
example : amount { year with para3c := 30000000 } = 0 := by decide
-- Reductions (farm loss, 111(10), section 80).
example : amount { year with reductions := 4000000 } = 10000000 := by decide

end Canteen.Tests.NonCapitalLoss

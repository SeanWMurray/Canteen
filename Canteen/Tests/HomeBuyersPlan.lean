import Canteen.ITA.S146_01.HomeBuyersPlan

/-!
# Tests: the Home Buyers' Plan (146.01)

A first-time buyer withdraws $60,000 from an RRSP. Constructed examples.
-/

namespace Canteen.Tests.HomeBuyersPlan

open Canteen Canteen.ITA Canteen.ITA.HomeBuyersPlan

-- Within the limit; $60,001 is over it; and not while a balance remains.
example : withinLimit 6000000 0 = true ∧ withinLimit 6000100 0 = false ∧ withinLimit 1000000 500000 = false := by decide
-- The first year of repayment: $4,000 required (a fifteenth). Repaying it: nothing included.
example : required 6000000 0 = 400000 ∧ inclusion 6000000 0 400000 = 0 := by decide
-- Repaying nothing: $4,000 included.
example : inclusion 6000000 0 0 = 400000 := by decide
-- Paying $10,000 in the first year: the next year's requirement falls to $50,000 / 14.
example : schedule 6000000 0 [1000000, 0] = [0, 357142] := by decide
-- Never repaying: $4,000 a year for 15 years, $60,000 in all.
example : schedule 6000000 0 (List.replicate 15 0) = List.replicate 15 400000 := by decide
example : (schedule 6000000 0 (List.replicate 15 0)).sum = 6000000 := by decide
-- In the fifteenth year all that remains is required.
example : required 123456 14 = 123456 := by decide

end Canteen.Tests.HomeBuyersPlan

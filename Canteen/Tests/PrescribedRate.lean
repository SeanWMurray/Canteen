import Canteen.ITA.Reg4301.PrescribedRate

/-!
# Tests: the prescribed rate (Reg. 4301)

Constructed auction yields.
-/

namespace Canteen.Tests.PrescribedRate

open Canteen Canteen.ITA Canteen.ITA.PrescribedRate

-- Two auctions at 3.123% and 3.087%: a mean of 3.105%, rounded up: 4%; 8% on amounts owed; 6% on an
-- individual's refund, 4% on a corporation's.
def july : List Nat := [3123, 3087]
example : general july = 400 ∧ owing july = 800 ∧ refund july false = 600 ∧ refund july true = 400 := by decide
-- A mean of exactly 3%: 3%, not 4%.
example : general [3000, 3000] = 300 := by decide
-- A mean just over: 3.0005% rounds up to 4%.
example : general [3000, 3001] = 400 := by decide
-- Three auctions near zero, as in 2021: 0.112%, 0.118%, 0.121%: 1%.
example : general [112, 118, 121] = 100 := by decide

end Canteen.Tests.PrescribedRate

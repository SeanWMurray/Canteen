import Canteen.ITA.S146_3.RRIFMinimum

/-!
# Tests: the RRIF minimum amount (146.3(1); Reg. 7308)

A $500,000 RRIF. Constructed examples.
-/

namespace Canteen.Tests.RRIFMinimum

open Canteen Canteen.ITA Canteen.ITA.RRIFMinimum

-- Age 65: 1/25, $20,000. Age 70: 1/20, $25,000.
example : minimum { value := 50000000, age := 65 } = 2000000 ∧ minimum { value := 50000000, age := 70 } = 2500000 := by decide
-- Age 71: 5.28%, $26,400. Age 80: 6.82%, $34,100. 95 or older: 20%, $100,000.
example : minimum { value := 50000000, age := 71 } = 2640000 ∧ minimum { value := 50000000, age := 80 } = 3410000 := by decide
example : minimum { value := 50000000, age := 97 } = 10000000 := by decide
-- The year the fund is set up: nil.
example : minimum { value := 50000000, age := 75, firstYear := true } = 0 := by decide
-- Using a younger spouse's age (63): 1/27.
example : minimum { value := 54000000, age := 63 } = 2000000 := by decide
-- A qualifying (pre-1993) fund at 71: still 1/(90 − 71), 1/19.
example : minimum { value := 57000000, age := 71, qualifying := true } = 3000000 := by decide

end Canteen.Tests.RRIFMinimum

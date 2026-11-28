import Canteen.ITA.S122_5.GstCredit

/-!
# Tests: the GST/HST credit (122.5(3))

Constructed examples; the indexed amounts are computed (see the module on their base year).
-/

namespace Canteen.Tests.GstCredit

open Canteen Canteen.ITA Canteen.ITA.GstCredit

-- For payments from July 2025: $349, $184, $11,337, $45,521.
example : (amount adult 2025, amount child 2025, amount phaseIn 2025, amount threshold 2025) = (34900, 18400, 1133700, 4552100) := by decide +kernel
-- A single person with $20,000 of income for 2024: $349 + the lesser of $184 and 2% of $8,663 ($173.26) =
-- $522.26 a year, $130.56 a quarter.
def single : Facts := { taxationYear := 2024, income := 2000000, adjustedIncome := 2000000 }
example : annual single = 52226 ∧ quarterly single = 13056 := by decide +kernel
-- A couple with two children, $40,000 of adjusted income: $349 × 2 + $184 × 2 = $1,066.
example : annual { taxationYear := 2024, relation := true, dependants := 2, income := 2000000, adjustedIncome := 4000000 } = 106600 := by decide +kernel
-- A single parent with one child, claiming the eligible dependant amount: $349 × 2 + $184 = $882.
example : annual { taxationYear := 2024, dependants := 1, eligibleDependantClaimed := true, income := 3000000, adjustedIncome := 3000000 } = 88200 := by decide +kernel
-- $60,000 of adjusted income, single: 5% of $14,479 ($723.95) wipes it out.
example : annual { single with income := 6000000, adjustedIncome := 6000000 } = 0 := by decide +kernel

end Canteen.Tests.GstCredit

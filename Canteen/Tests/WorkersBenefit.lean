import Canteen.ITA.S122_7.WorkersBenefit

/-!
# Tests: the Canada workers benefit (122.7)

Constructed examples; the indexed amounts are computed.
-/

namespace Canteen.Tests.WorkersBenefit

open Canteen Canteen.ITA Canteen.ITA.WorkersBenefit

-- The indexed amounts, 2022 to 2025: $1,428, $1,518, $1,590, $1,633; for a family $2,813 in 2025.
example : (amount maxSingle 2022, amount maxSingle 2023, amount maxSingle 2024, amount maxSingle 2025) = (142800, 151800, 159000, 163300) := by decide +kernel
example : amount maxFamily 2025 = 281300 ∧ amount thresholdSingle 2025 = 2685500 ∧ amount supplementMax 2025 = 84300 := by decide +kernel
-- A single worker in 2025 earning $20,000: 27% of $17,000 is $4,590, capped at $1,633; income under the
-- threshold: $1,633.
example : benefit { taxationYear := 2025, workingIncome := 2000000, adjustedNetIncome := 2000000 } = 163300 := by decide +kernel
-- Earning $30,000: less 15% of $3,145 ($471.75): $1,161.25.
example : benefit { taxationYear := 2025, workingIncome := 3000000, adjustedNetIncome := 3000000 } = 116125 := by decide +kernel
-- $2,500 of working income: nothing.
example : benefit { taxationYear := 2025, workingIncome := 250000, adjustedNetIncome := 250000 } = 0 := by decide +kernel
-- A worker with the disability credit, earning $20,000: the supplement too, $843.
example : supplement { taxationYear := 2025, workingIncome := 2000000, adjustedNetIncome := 2000000, disability := true } = 84300 := by decide +kernel

end Canteen.Tests.WorkersBenefit

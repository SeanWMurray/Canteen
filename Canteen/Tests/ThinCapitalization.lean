import Canteen.ITA.S18.ThinCapitalization

/-!
# Tests: thin capitalization (18(4))

Canco, owned by a US parent, borrows from it. Constructed examples.
-/

namespace Canteen.Tests.ThinCapitalization

open Canteen Canteen.ITA Canteen.ITA.ThinCapitalization

def month (debt : Cents) : Month := { maxDebt := debt, paidUpCapital := 100000000 }

-- $5 million owed all year, $1 million of paid-up capital and $1 million of retained earnings: equity
-- $2 million, 1.5 times is $3 million; $2 million of the $5 million is excess: 40% of the $300,000 of
-- interest, $120,000, is denied.
def canco : Facts := { interest := 30000000, retainedEarnings := 100000000, months := List.replicate 12 (month 500000000) }
example : equityAmount canco = 200000000 ∧ excessDebt canco = 200000000 := by decide
example : denied canco = 12000000 ∧ deductible canco = 18000000 := by decide
-- Within the ratio: $3 million owed: nothing denied.
example : denied { canco with months := List.replicate 12 (month 300000000) } = 0 := by decide
-- The average of the monthly maximums: $6 million for six months and nothing for six, an average of
-- $3 million: within the ratio, though the debt was over it half the year.
example : denied { canco with months := List.replicate 6 (month 600000000) ++ List.replicate 6 (month 0) } = 0 := by decide
-- Contributed surplus from the parent counts as equity.
example : equityAmount { canco with months := List.replicate 12 { month 500000000 with contributedSurplus := 50000000 } } = 250000000 := by decide

-- 214(16): the $120,000 denied is a dividend to the parent: $30,000 of Part XIII tax at 25%, or $6,000
-- at a 5% treaty rate.
example : deemedDividend canco = 12000000 ∧ partXIII canco = 3000000 := by decide
example : partXIII { canco with dividendRate := 5 } = 600000 := by decide

end Canteen.Tests.ThinCapitalization

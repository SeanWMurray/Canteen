import Canteen.ITA.S84.PaidUpCapitalIncrease

/-!
# Tests: an increase in paid-up capital (84(1), 53(1)(b))

Opco adds $100,000 to the paid-up capital of its common shares. Constructed examples.
-/

namespace Canteen.Tests.PaidUpCapitalIncrease

open Canteen Canteen.ITA Canteen.ITA.PaidUpCapitalIncrease

def bump : Facts := { description := "the common shares of Opco", increase := 10000000, sharesHeld := 100, sharesOutstanding := 100 }

-- Out of retained earnings, for nothing: a $100,000 dividend, added to the sole holder's cost.
example : dividendPaid bump = 10000000 ∧ dividend bump = 10000000 ∧ costAddition bump = 10000000 := by decide
-- By a stock dividend: none under 84(1).
example : dividendPaid { bump with stockDividend := true } = 0 := by decide
-- For $100,000 of new money (or property): none; for $60,000, $40,000.
example : dividendPaid { bump with netAssetIncrease := 10000000 } = 0 ∧ dividendPaid { bump with netAssetIncrease := 6000000 } = 4000000 := by
  decide
-- Moved from another class's paid-up capital: none.
example : dividendPaid { bump with otherClassesReduction := 10000000 } = 0 := by decide
-- Qualifying contributed surplus converted: none.
example : dividendPaid { bump with qualifyingSurplus := 10000000 } = 0 := by decide
-- A holder of 25 of 100 shares receives a quarter.
example : dividend { bump with sharesHeld := 25 } = 2500000 := by decide
-- A non-resident corporation: no 84(1) dividend.
example : dividendPaid { bump with corporationResident := false } = 0 := by decide
-- A corporate holder's part deducted under 112(1) and subject to 55(2) is not added to cost.
example : costAddition bump 4000000 = 6000000 := by decide
-- For an individual, a taxable dividend, grossed up.
example : Dividends.inclusion { taxationYear := 2025, dividends := [asDividend bump] } = 11500000 := by decide

end Canteen.Tests.PaidUpCapitalIncrease

import Canteen.ITA.S123.CorporateRates

/-!
# Tests: corporate rates (123(1), 124(1), 123.4(2), 125(1))

Constructed examples, for a calendar year after 2018.
-/

namespace Canteen.Tests.CorporateRates

open Canteen Canteen.ITA Canteen.ITA.CorporateRates

-- A CCPC with $100,000 of active business income: 9%, $9,000.
example : tax { taxableIncome := 10000000, activeBusinessIncome := 10000000 } = 900000 := by decide
-- $800,000: $500,000 at 9% and $300,000 at 15%, $90,000.
example : tax { taxableIncome := 80000000, activeBusinessIncome := 80000000 } = 9000000 := by decide
-- Associated with another CCPC that takes the whole business limit: all at 15%.
example : tax { taxableIncome := 10000000, activeBusinessIncome := 10000000, businessLimit := 0 } = 1500000 := by decide
-- A CCPC's investment income gets neither the small business deduction nor the general rate
-- reduction: 28% here (before the 123.3 refundable tax, not encoded).
example : tax { taxableIncome := 10000000, aggregateInvestmentIncome := 10000000 } = 2800000 := by decide
-- A public corporation: 15%.
example : tax { taxableIncome := 10000000, ccpc := false } = 1500000 := by decide
-- Income not earned in a province gets no abatement: 25%.
example : tax { taxableIncome := 10000000, ccpc := false, provincialIncome := some 0 } = 2500000 := by decide
-- A personal services business: no small business deduction, no general rate reduction.
example : tax { taxableIncome := 10000000, ccpc := false, personalServicesIncome := 10000000 } = 2800000 := by decide

end Canteen.Tests.CorporateRates

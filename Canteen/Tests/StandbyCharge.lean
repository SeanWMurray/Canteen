import Canteen.ITA.S127_5.MinimumTax

/-!
# Tests: the automobile standby charge (6(1)(e), 6(2))

Constructed examples.
-/

namespace Canteen.Tests.StandbyCharge

open Canteen Canteen.ITA Canteen.ITA.StandbyCharge

/-- A $40,000 car the employer owns, available all year. -/
def owned : Facts := { availableDays := 365, cost := 4000000, ownedDays := 365 }

-- 2% a month for 12 months: $9,600.
example : charge owned = 960000 := by decide
-- Required for work, driven primarily for work, 10,000 personal km of the 20,004 allowed: $4,799.04.
example : charge { owned with requiredForWork := true, primarilyForWork := true, personalKm := 10000 } = 479904 := by decide
-- Not primarily for work: no reduction, whatever the kilometres.
example : charge { owned with requiredForWork := true, personalKm := 10000 } = 960000 := by decide
-- Over 20,004 personal km: no reduction either.
example : charge { owned with requiredForWork := true, primarilyForWork := true, personalKm := 25000 } = 960000 := by decide
-- Leased at $600 a month including $100 of insurance: 2/3 of $6,000, $4,000.
example : charge { availableDays := 365, leasePayments := 720000, leaseInsurance := 120000 } = 400000 := by decide
-- 15 days owned: half a month, $400; 45 days: 1.5 rounds down to 1, $800; 46 days: 2, $1,600.
example : charge { availableDays := 15, cost := 4000000, ownedDays := 15 } = 40000 ∧
    charge { availableDays := 45, cost := 4000000, ownedDays := 45 } = 80000 ∧
    charge { availableDays := 46, cost := 4000000, ownedDays := 46 } = 160000 := by decide
-- What the employee pays for its use comes off.
example : benefit { owned with employeePaid := 120000 } = 840000 := by decide
-- Not available at all: nothing.
example : charge { owned with availableDays := 0 } = 0 := by decide

/-! ## In the individual's year -/

def employee : IndividualYear.Facts := { taxationYear := 2025, employmentAndBusiness := 7000000, claimsPersonal := true, standby := [owned] }

example : IndividualYear.standbyBenefits employee = 960000 ∧ IndividualYear.income employee = 2 * 7960000 := by decide
example : MinimumTax.adjustedTaxableIncome employee = 2 * 7960000 := by decide

end Canteen.Tests.StandbyCharge

import Canteen.ITA.S67_1.MealsEntertainment

/-!
# Tests: meals and entertainment (67.1)

Constructed examples.
-/

namespace Canteen.Tests.MealsEntertainment

open Canteen Canteen.ITA Canteen.ITA.MealsEntertainment

def lunch : Expense := { description := "a client lunch", year := 2025, amount := 24000 }

-- Half of a $240 client lunch.
example : lunch.deemed = 12000 := by decide
-- A $2,000 dinner where $800 is reasonable: half of $800.
example : ({ lunch with amount := 200000, reasonable := some 80000 } : Expense).deemed = 40000 := by decide
-- Billed to the client, the charge identified in writing (67.1(2)(c)): in full.
example : ({ lunch with exception := some .billedToClient } : Expense).deemed = 24000 := by decide
-- A restaurant's own food (a): in full. A charity gala (b): in full.
example : ({ lunch with exception := some .ordinaryBusiness } : Expense).deemed = 24000 := by decide
example : ({ lunch with exception := some .charityFundraiser } : Expense).deemed = 24000 := by decide
-- The holiday party, open to all staff (f): in full, if no more than six such events in the year.
def party : Expense := { description := "the holiday party", year := 2025, amount := 600000, exception := some .staffEvent }
example : party.deemed 6 = 600000 := by decide
example : party.deemed 7 = 300000 := by decide
-- An exception that is a judgment call, and found not to apply.
example : ({ lunch with exception := some .taxableBenefit, exceptionApplies := .judged "J-BEN" false } : Expense).deemed = 12000 := by decide
example : (explain { expenses := [{ lunch with exception := some .taxableBenefit, exceptionApplies := .judged "J-BEN" true }] }).reliesOn = ["J-BEN"] := by decide
-- A long-haul truck driver's meals: 80% after 2010; 70% in 2009.
def trucker : Expense := { description := "meals on the road", year := 2025, amount := 100000, truckDriver := true }
example : trucker.deemed = 80000 := by decide
example : ({ trucker with year := 2009 } : Expense).deemed = 70000 := by decide

-- 67.1(3): a $1,500 conference fee over three days with meals, none of it identified: $150 of food,
-- of which half counts, and $1,350 of fee: $1,425.
def conference : Conference := { description := "a three-day tax conference", year := 2025, fee := 150000, daysWithFood := 3 }
example : conference.foodPart = 15000 ∧ conference.deemed = 142500 := by decide
-- With $300 identified for meals: half of that, and $1,200: $1,350.
example : ({ conference with identified := some 30000 } : Conference).deemed = 135000 := by decide

-- Together.
def year : Facts := { expenses := [lunch, party, trucker], conferences := [conference], staffEvents := 2 }
example : total year = 24000 + 600000 + 100000 + 150000 := by decide
example : deductible year = 12000 + 600000 + 80000 + 142500 := by decide

end Canteen.Tests.MealsEntertainment

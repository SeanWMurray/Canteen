import Canteen.ITA.S127_5.MinimumTax

/-!
# Tests: the tuition credit, its carryforward and its transfer (118.5, 118.61, 118.81, 118.9)

2025 amounts. Constructed examples.
-/

namespace Canteen.Tests.Tuition

open Canteen Canteen.ITA Canteen.ITA.IndividualYear

/-- A student with no income and $6,000 of tuition: a $840 credit, no tax to use it against. -/
def student : Facts := { taxationYear := 2025, claimsPersonal := true, tuitionFees := 600000, tuitionDesignated := 70000 }

example : tuitionCredit student = 84000 ∧ taxBeforeTuition student = 0 ∧ tuitionCurrentUsed student = 0 := by decide
-- $700 (14% of $5,000) goes to the parent; the other $140 is carried forward.
example : tuitionTransferFrom student = 70000 ∧ tuitionUnused student = 14000 := by decide
-- Without a designation, all $840 is carried forward.
example : tuitionTransferFrom { student with tuitionDesignated := 0 } = 0 ∧ tuitionUnused { student with tuitionDesignated := 0 } = 84000 := by
  decide

/-- With $20,000 of earnings and $8,000 of tuition: $541.94 of tax after the personal credit. -/
def working : Facts := { student with employmentAndBusiness := 2000000, tuitionFees := 800000 }

-- The $1,120 credit first clears the $541.94; only $700 less that, $158.06, can go to the parent; $420 is carried.
example : taxBeforeTuition working = 54194 ∧ tuitionCurrentUsed working = 54194 ∧ federalTax working = 0 := by decide
example : tuitionTransferFrom working = 15806 ∧ tuitionUnused working = 42000 := by decide

-- The next year, the $420 carried in is used first, before the year's own credit.
def nextYear : Facts := { taxationYear := 2026, employmentAndBusiness := 3000000, claimsPersonal := true, tuitionCarried := 42000 }
example : tuitionCarryUsed nextYear = 42000 ∧ tuitionUnused nextYear = 0 := by decide

/-- The parent, deducting what was transferred. -/
def parent : Facts := { taxationYear := 2025, employmentAndBusiness := 10000000, claimsPersonal := true, tuitionTransferredIn := tuitionTransferFrom student }
example : federalTax { parent with tuitionTransferredIn := 0 } - federalTax parent = 70000 := by decide
-- Half of the tuition credits used count toward the basic minimum tax credit.
example : MinimumTax.basicCredit parent - MinimumTax.basicCredit { parent with tuitionTransferredIn := 0 } = 35000 := by decide

end Canteen.Tests.Tuition

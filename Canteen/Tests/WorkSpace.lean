import Canteen.ITA.S18.WorkSpace

/-!
# Tests: work space in the home (18(12), 8(13))

Constructed examples.
-/

namespace Canteen.Tests.WorkSpace

open Canteen Canteen.ITA Canteen.ITA.WorkSpace

-- A consultant's home office, the principal place of business: $4,000 of costs against $60,000 of income.
def office : Facts := { principalPlace := .fact true, expenses := 400000, income := 6000000 }
example : deduction office = 400000 ∧ carriedForward office = 0 := by decide
-- A first year with $1,500 of income: $1,500 deducted, $2,500 carried forward.
def startUp : Facts := { office with income := 150000 }
example : deduction startUp = 150000 ∧ carriedForward startUp = 250000 := by decide
-- The next year, $3,000 of income: the $2,500 and $500 of that year's $4,000; $3,500 carried.
def second : Facts := { office with carriedIn := carriedForward startUp, income := 300000 }
example : deduction second = 300000 ∧ carriedForward second = 350000 := by decide
-- A room used for meetings with clients, but also by the family: not exclusive, and not the principal
-- place of business: nothing, and the carryforward is lost.
example : deduction { second with principalPlace := .fact false } = 0 ∧ carriedForward { second with principalPlace := .fact false } = 0 := by decide
-- A dentist's separate treatment room at home, used only for patients: (a)(ii).
example : deduction { expenses := 300000, income := 9000000, exclusiveForMeetings := .fact true } = 300000 := by decide
-- An employee who principally works from home (8(13)): limited to employment income; judged.
def employee : Facts := { source := .employment, principalPlace := .judged "J-HOME" true, expenses := 250000, income := 8000000 }
example : deduction employee = 250000 := by decide
example : (explain employee).reliesOn = ["J-HOME"] := by decide

end Canteen.Tests.WorkSpace

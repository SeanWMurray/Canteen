import Canteen.ITA.S118_2.MedicalExpenses
import Canteen.ITA.S127_5.MinimumTax

/-!
# Tests: the medical expense credit (118.2(1))

2025 threshold: $2,834. Constructed examples.
-/

namespace Canteen.Tests.MedicalExpenses

open Canteen Canteen.ITA Canteen.ITA.MedicalExpenses

def dental : Expense := { description := "dental work", amount := 500000 }

-- Income $50,000: 3% is $1,500, less than $2,834. $5,000 − $1,500 = $3,500; 14% is $490.
example : reduction { income := 5000000, expenses := [dental] } = 150000 ∧ credit { income := 5000000, expenses := [dental] } = 49000 := by decide
-- Income $150,000: 3% is $4,500, so the $2,834 threshold applies: 14% of $2,166 is $303.24.
example : credit { income := 15000000, expenses := [dental] } = 30324 := by decide
-- Below the floor: nothing.
example : credit { income := 15000000, expenses := [{ dental with amount := 200000 }] } = 0 := by decide
-- No receipts, claimed by someone else, or outside the period: not counted.
example : familyExpenses { income := 0, expenses := [{ dental with receipts := false }, { dental with claimedElsewhere := true },
    { dental with inPeriod := false }] } = 0 := by decide
-- Not a medical expense (judged): not counted, and the explanation says so.
def cosmetic : Expense := { description := "cosmetic surgery", amount := 1000000, medical := .judged "J-MED" false }
example : credit { income := 5000000, expenses := [cosmetic] } = 0 ∧ (explain { income := 5000000, expenses := [cosmetic] }).reliesOn = ["J-MED"] := by
  decide
-- A dependent parent with $20,000 of income: $4,000 less 3% of $20,000 ($600), even where the family has none.
def parent : Expense := { description := "parent's care", amount := 400000, patient := .dependant "parent" 2000000 }
example : otherDependants { income := 15000000, expenses := [parent] } = 340000 ∧ credit { income := 15000000, expenses := [parent] } = 47600 := by
  decide
-- Two expenses for the same dependant are pooled, and the floor comes off once.
example : otherDependants { income := 15000000, expenses := [parent, parent] } = 740000 := by decide

/-! ## In the individual's year -/

def year : IndividualYear.Facts :=
  { taxationYear := 2025, employmentAndBusiness := 5000000, claimsPersonal := true, medicalExpenses := [dental] }

-- $490 off federal tax, and half of it counts toward the basic minimum tax credit.
example : IndividualYear.medicalCredit year = 49000 ∧
    IndividualYear.federalTax { year with medicalExpenses := [] } - IndividualYear.federalTax year = 49000 := by decide
example : MinimumTax.basicCredit year - MinimumTax.basicCredit { year with medicalExpenses := [] } = 24500 := by decide

end Canteen.Tests.MedicalExpenses

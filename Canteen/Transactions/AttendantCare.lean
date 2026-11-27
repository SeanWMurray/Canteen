import Canteen.ITA.S127_5.MinimumTax

/-!
# Layer 3: attendant care, as a medical expense or with the disability credit

A constructed example under 118.2(1), (2)(b), (b.1), 118.3(1), 118(1) and 117(2), federal tax only.

* An individual with a severe and prolonged impairment, certified and filed, earns $60,000 in 2025 and
  pays `cost` for full-time attendant care.
* Option A: claim all of it as a medical expense (118.2(2)(b)). Then 118.3(1)(c) denies the
  disability credit.
* Option B: claim only $10,000 of it, under 118.2(2)(b.1), and the disability credit.

Provincial tax is not computed.
-/

namespace Canteen.Transactions.AttendantCare

open Canteen Canteen.ITA

def impairment : Disability.Facts := { impairment := .fact true }

def attendant (amount : Cents) : MedicalExpenses.Expense := { description := "full-time attendant care", amount }

/-- Option A: all the care as a medical expense, and no disability credit. -/
def optionA (cost : Cents) : IndividualYear.Facts :=
  { taxationYear := 2025, employmentAndBusiness := 6000000, claimsPersonal := true, medicalExpenses := [attendant cost],
    disability := some { impairment with attendantCareClaimed := true } }

/-- Option B: $10,000 of it under 118.2(2)(b.1), and the disability credit. -/
def optionB (cost : Cents) : IndividualYear.Facts :=
  { taxationYear := 2025, employmentAndBusiness := 6000000, claimsPersonal := true,
    medicalExpenses := [attendant (min cost 1000000)], disability := some impairment }

/-! ## Analysis -/

/-- With $25,000 of care: A's medical credit is 14% of $23,200, $3,248, and no disability credit;
B's is 14% of $8,200, $1,148, plus the $1,419.32 disability credit. -/
theorem credits_25000 :
    IndividualYear.medicalCredit (optionA 2500000) = 324800 ∧ IndividualYear.disabilityCredit (optionA 2500000) = 0 ∧
    IndividualYear.medicalCredit (optionB 2500000) = 114800 ∧ IndividualYear.disabilityCredit (optionB 2500000) = 141932 := by decide

/-- So A is $680.68 better at $25,000 of care... -/
theorem a_better_at_25000 : IndividualYear.federalTax (optionB 2500000) - IndividualYear.federalTax (optionA 2500000) = 68068 := by decide

/-- ...and B is $1,139.32 better at $12,000. -/
theorem b_better_at_12000 : IndividualYear.federalTax (optionA 1200000) - IndividualYear.federalTax (optionB 1200000) = 113932 := by decide

/-- **The break-even is $20,138 of care**: $10,000 plus the $10,138 disability amount, whatever the
income, since both options take off the same 3% of income. There the two are within a cent. -/
theorem break_even :
    IndividualYear.federalTax (optionA 2013800) = IndividualYear.federalTax (optionB 2013800) := by decide

/-- A dollar more and A wins; a dollar less and B does. -/
theorem either_side :
    IndividualYear.federalTax (optionA 2013900) < IndividualYear.federalTax (optionB 2013900) ∧
    IndividualYear.federalTax (optionB 2013700) < IndividualYear.federalTax (optionA 2013700) := by decide

end Canteen.Transactions.AttendantCare

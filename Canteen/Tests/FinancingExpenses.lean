import Canteen.ITA.S20.FinancingExpenses

/-!
# Tests: financing expenses (20(1)(e), (e.1))

Constructed examples.
-/

namespace Canteen.Tests.FinancingExpenses

open Canteen Canteen.ITA Canteen.ITA.FinancingExpenses

-- $25,000 of legal and lender's fees on a business loan: $5,000 a year.
def loanFees : Expense := { description := "fees to arrange the term loan", purpose := .borrowing, amount := 2500000 }
example : loanFees.deduction = 500000 := by decide
-- Over five full years, all of it, and nothing in a sixth.
example : loanFees.schedule 6 = [500000, 500000, 500000, 500000, 500000, 0] := by decide
-- A first year of 146 days: 146/365 of $5,000, $2,000.
example : loanFees.deduction 146 = 200000 := by decide
-- The loan repaid in year 3 with $10,000 deducted: the remaining $15,000.
example : ({ loanFees with deductedBefore := 1000000, settled := true } : Expense).deduction = 1500000 := by decide
-- Share issue costs: settlement has no effect (20(1)(e)(v) is for borrowings).
def issue : Expense := { description := "prospectus costs", purpose := .issuance, amount := 1000000, deductedBefore := 400000, settled := true }
example : issue.deduction = 200000 := by decide
-- A fee computed by reference to profit is an excluded amount.
example : ({ loanFees with excluded := true } : Expense).deduction = 0 := by decide
-- A loan used to buy a life insurance policy or exempt-income property: none.
example : ({ loanFees with exemptUse := true } : Expense).deduction = 0 := by decide
-- 20(1)(e.1): a $1,200 annual standby charge, in full; one relating to several years, not under (e.1).
example : deduction { expenses := [loanFees], fees := [⟨"the standby charge", 120000, true, false⟩] } = 620000 := by decide
example : deduction { fees := [⟨"a three-year guarantee fee", 360000, false, false⟩] } = 0 := by decide

end Canteen.Tests.FinancingExpenses

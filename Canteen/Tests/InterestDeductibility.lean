import Canteen.ITA.S20.InterestDeductibility

/-!
# Tests: interest on borrowed money (20(1)(c), 20(3))

$200,000 borrowed at 5%: $10,000 of interest a year. Constructed examples.
-/

namespace Canteen.Tests.InterestDeductibility

open Canteen Canteen.ITA Canteen.ITA.InterestDeductibility

def loan : Borrowing := { description := "the loan", principal := 20000000, interest := 1000000, use := .property }

-- Borrowed to buy shares: all $10,000 deductible.
example : deduction loan = 1000000 := by decide
-- To earn business income: deductible.
example : deduction { loan with use := .business } = 1000000 := by decide
-- For a home: nil.
example : deduction { loan with use := .personal } = 0 := by decide
-- To buy property with exempt income, or a life insurance policy: nil.
example : deduction { loan with use := .exempt } = 0 ∧ deduction { loan with use := .lifeInsurance } = 0 := by decide
-- No legal obligation to pay interest: nil.
example : deduction { loan with legalObligation := false } = 0 := by decide
-- No purpose of earning income (judged): nil, and the explanation says it rests on the judgment call.
def noPurpose : Borrowing := { loan with incomePurpose := .judged "J-INC" false }
example : deduction noPurpose = 0 ∧ (explain noPurpose).reliesOn = ["J-INC"] := by decide
-- 20(3): a new loan repaying the investment loan is deductible; one repaying a mortgage is not.
example : deduction { loan with use := .refinancing, previousUse := .property } = 1000000 := by decide
example : deduction { loan with use := .refinancing, previousUse := .personal } = 0 := by decide
-- Only $150,000 traced to the shares: 75% of the interest.
example : deduction { loan with traced := some 15000000 } = 750000 := by decide
-- An unreasonable rate: only a reasonable amount.
example : deduction { loan with interest := 3000000, reasonable := some 1200000 } = 1200000 := by decide
-- Totals, and the property part for the minimum tax.
example : total [loan, { loan with use := .business }, { loan with use := .personal }] = 2000000 ∧
    propertyPart [loan, { loan with use := .business }] = 1000000 := by decide

end Canteen.Tests.InterestDeductibility

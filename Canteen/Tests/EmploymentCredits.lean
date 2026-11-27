import Canteen.ITA.S127_5.MinimumTax

/-!
# Tests: the Canada employment credit, and the CPP and EI credits and deduction

2025 amounts. Constructed examples.
-/

namespace Canteen.Tests.EmploymentCredits

open Canteen Canteen.ITA Canteen.ITA.EmploymentCredits

-- 14% of the lesser of $1,471 and employment income.
example : employmentCredit { employmentIncome := 5000000 } = 20594 ∧ employmentCredit { employmentIncome := 100000 } = 14000 := by decide
-- 14% of EI premiums and base CPP, each capped.
example : contributionCredit { eiPremiums := 107748, cppBase := 335610 } = 62070 := by decide
example : contributionCredit { eiPremiums := 200000, cppBase := 500000 } = 62070 := by decide
-- The enhanced contributions are deducted, up to $1,074.
example : enhancedDeduction { cppEnhanced := 107400 } = 107400 ∧ enhancedDeduction { cppEnhanced := 200000 } = 107400 := by decide

def employee : IndividualYear.Facts :=
  { taxationYear := 2025, employmentAndBusiness := 6000000, personalAmounts := some {},
    employment := some { employmentIncome := 6000000, eiPremiums := 98400, cppBase := 279675, cppEnhanced := 56500 } }

-- In the year: the enhanced contributions come off income, and the credits off tax.
example : IndividualYear.income employee = 2 * (6000000 - 56500) := by decide
example : IndividualYear.employmentCredits employee = 20594 + 52930 := by decide
-- Half of them count toward the basic minimum tax credit.
example : MinimumTax.basicCredit employee - MinimumTax.basicCredit { employee with employment := none } = 36762 := by decide

end Canteen.Tests.EmploymentCredits

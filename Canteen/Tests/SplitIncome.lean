import Canteen.ITA.S120_4.SplitIncome

/-!
# Tests: tax on split income (120.4)

Family members receive dividends from Opco, a private corporation carrying on the family business
(a related business in respect of each of them). Constructed examples.
-/

namespace Canteen.Tests.SplitIncome

open Canteen Canteen.ITA Canteen.ITA.SplitIncome

def opcoDividend (a : Cents) : Dividends.Dividend := { description := "dividend from Opco", amount := a }
def fromOpco (a : Cents) : Amount := { description := "Opco dividend", source := .privateDividend (opcoDividend a) }
def person (age : Nat) (as : List Amount) : Facts := { taxationYear := 2025, age, amounts := as }

-- A 15-year-old: a $10,000 dividend is $11,500 of split income, taxed at 33%: $3,795, less the
-- $1,038.46 dividend tax credit.
def child : Facts := person 15 [fromOpco 1000000]
example : splitIncome child = 1150000 ∧ tax child = 379500 ∧ dividendCredits child = 103846 ∧ minimumTax child = 275654 := by decide
-- Even a "reasonable return" does not help a minor.
example : splitIncome (person 15 [{ fromOpco 1000000 with reasonableReturn := .judged "J-REASONABLE" true }]) = 1150000 := by decide
-- A 20-year-old: a reasonable return on arm's length capital is excluded (often a judgment call).
def student : Facts := person 20 [{ fromOpco 1000000 with reasonableReturn := .judged "J-REASONABLE" true }]
example : splitIncome student = 0 := by decide
#guard (rule.explain student).reliesOn == ["J-REASONABLE"]
-- A 30-year-old spouse holding 10% of the votes and value of a non-service corporation: excluded shares.
example : splitIncome (person 30 [{ fromOpco 1000000 with excludedShares := true }]) = 0 := by decide
-- An adult actively engaged in the business on a regular, continuous and substantial basis.
example : splitIncome (person 40 [{ fromOpco 1000000 with excludedBusiness := .judged "J-ENGAGED" true }]) = 0 := by decide
-- An adult whose dividend is not derived from a related business.
example : splitIncome (person 40 [{ fromOpco 1000000 with relatedBusiness := .fact false }]) = 0 := by decide
-- But an adult, not engaged, without excluded shares or a reasonable return: split income.
example : splitIncome (person 40 [fromOpco 1000000]) = 1150000 := by decide
-- Dividends on listed shares are not split income.
example : splitIncome (person 15 [{ fromOpco 1000000 with source := .listedDividend (opcoDividend 1000000) }]) = 0 := by decide
-- A child's dividends on shares inherited from a parent are excluded.
example : splitIncome (person 15 [{ fromOpco 1000000 with inherited := true }]) = 0 := by decide
-- Not a specified individual: a non-resident.
example : splitIncome { child with residentAtYearEnd := false } = 0 := by decide

end Canteen.Tests.SplitIncome

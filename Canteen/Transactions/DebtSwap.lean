import Canteen.ITA.S127_5.MinimumTax

/-!
# Layer 3: a debt swap, making mortgage interest deductible

A constructed example under 20(1)(c), 20(3), 3, 38, 117(2), 118(1), 121 and 127.5, federal tax only.

* An individual earns a $150,000 salary, has a $200,000 mortgage on their home at 5% ($10,000 of
  interest a year), and a $200,000 portfolio of public-company shares, which cost $150,000 and pay
  $6,000 of eligible dividends a year.
* At the start of 2025 they sell the portfolio, pay off the mortgage, borrow $200,000 at 5%, and buy the
  portfolio back. The borrowed money is used directly to buy the shares (Singleton).
* Judgment call `J-INC`: is the borrowed money used for the purpose of earning income from the shares
  (Ludco: a reasonable expectation of dividends)?

The 2026 year uses the 2025 bracket and personal amounts. Provincial tax is not computed.
-/

namespace Canteen.Transactions.DebtSwap

open Canteen Canteen.ITA

def calls : List JudgmentCall :=
  [{ id := "J-INC", question := "Is the $200,000 borrowed in 2025 used for the purpose of earning income from the shares it buys back?",
     riskIfYes := .low, riskIfNo := .high }]

def position : List Judgment := [(calls.head!).assume true]

def dividends : List Dividends.Dividend := [{ description := "portfolio dividends", amount := 600000, eligible := true }]

def mortgage : InterestDeductibility.Borrowing :=
  { description := "the mortgage", principal := 20000000, interest := 1000000, use := .personal }

def loan (branch : List Judgment) : InterestDeductibility.Borrowing :=
  { description := "the investment loan", principal := 20000000, interest := 1000000, use := .property,
    incomePurpose := Answer.ofBranch "J-INC" branch }

def sale : CapitalGains.Disposition := { description := "the portfolio", proceeds := 20000000, adjustedCostBase := 15000000 }

def year (taxationYear : Nat) (borrowings : List InterestDeductibility.Borrowing) (sold : Bool := false) : IndividualYear.Facts :=
  { taxationYear, employmentAndBusiness := 15000000, dividends, personalAmounts := some {}, borrowings,
    capital := ⟨if sold then [sale] else [], 0, {}⟩ }

/-! ## Analysis -/

/-- Mortgage interest is not deductible: the money was used to buy a home. -/
theorem mortgage_not_deductible : InterestDeductibility.deduction mortgage = 0 := by decide

/-- The investment loan's $10,000 is, on the position that it is used to earn income... -/
theorem loan_deductible : InterestDeductibility.deduction (loan position) = 1000000 := by decide

/-- ...and the conclusion rests on that judgment call. -/
theorem relies_on_purpose : (InterestDeductibility.explain (loan position)).reliesOn = ["J-INC"] := by decide

/-- Without the swap, federal tax is $27,768.54 a year. -/
theorem without_swap : IndividualYear.federalTax (year 2025 [mortgage]) = 2776854 := by decide

/-- In 2025 the sale realizes a $50,000 gain: $25,000 taxable, $6,500 of tax, so the year costs
$3,900 more despite the deduction. -/
theorem swap_year : IndividualYear.federalTax (year 2025 [loan position] true) = 3166854 ∧
    IndividualYear.federalTax (year 2025 [loan position] true) - IndividualYear.federalTax (year 2025 [mortgage]) = 390000 := by decide

/-- From 2026, $2,600 a year less: the $10,000 deduction at 26%. -/
theorem yearly_saving : IndividualYear.federalTax (year 2026 [mortgage]) - IndividualYear.federalTax (year 2026 [loan position]) = 260000 := by
  decide

/-- **Ahead by the end of 2027.** −$3,900 in 2025, then $2,600 a year: $1,300 ahead after three years. -/
theorem payback : 2 * 260000 - 390000 = 130000 := by decide

/-- The minimum tax does not apply: adjusted taxable income is $151,000. -/
theorem no_minimum_tax :
    MinimumTax.adjustedTaxableIncome (year 2026 [loan position]) = 2 * 15100000 ∧
    MinimumTax.taxPayable (year 2026 [loan position]) = IndividualYear.federalTax (year 2026 [loan position]) := by decide

/-! ## What if -/

/-- If the money was not used to earn income, the deduction is lost, and the swap only costs the tax on the gain. -/
theorem if_no_purpose : InterestDeductibility.deduction (loan [(calls.head!).assume false]) = 0 := by decide

/-- 20(3): refinancing the investment loan with another lender in 2027 keeps the interest deductible. -/
theorem refinanced :
    InterestDeductibility.deduction { loan position with use := .refinancing, previousUse := .property } = 1000000 := by decide

/-- If only $150,000 of the loan bought shares and $50,000 bought a car, 75% of the interest is deductible:
$1,950 a year saved. -/
theorem partly_traced :
    IndividualYear.federalTax (year 2026 [mortgage]) -
      IndividualYear.federalTax (year 2026 [{ loan position with traced := some 15000000 }]) = 195000 := by decide

end Canteen.Transactions.DebtSwap

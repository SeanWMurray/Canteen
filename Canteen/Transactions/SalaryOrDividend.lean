import Canteen.ITA.S127_5.MinimumTax
import Canteen.ITA.S123.CorporateRates

/-!
# Layer 3: paying the owner-manager a salary or dividends

A constructed comparison under 3, 9(1), 82(1), 117(2), 118, 118(10), 118.7, 121, 123 to 125 and 60(e.1),
federal tax only.

* Opco, a CCPC, has $100,000 of active business income in 2025, within its business limit, before
  paying its owner, who has no other income.
* Option A: a salary, with Opco's share of Canada Pension Plan contributions, using up the $100,000 (both
  deductible to Opco, so it has no taxable income).
* Option B: no salary; Opco pays tax at 9% and the rest, $91,000, as a non-eligible dividend.
* The owner holds more than 40% of Opco's voting shares, so is not insurable under the Employment
  Insurance Act: no EI premiums.

The 2025 CPP contributions are computed under the Canada Pension Plan, not the Act: 5.95% of earnings
between $3,500 and $71,300 (4.95% base under 8(1), 1% enhanced under 8(1.1)), and 4% between $71,300
and $81,200 (8(1.2)), from employee and employer alike. CPP contributions also buy a pension, which is
not valued here, nor is the RRSP room a salary creates. Provincial tax, which narrows the gap, is not
computed.
-/

namespace Canteen.Transactions.SalaryOrDividend

open Canteen Canteen.ITA

def available : Cents := 10000000

/-- CPP 8(1): base contributions, 4.95% of earnings from $3,500 to $71,300. -/
def cppBase (salary : Cents) : Cents := (min salary 7130000 - 350000) * 495 / 10000
/-- CPP 8(1.1), (1.2): 1% on the same band, and 4% from $71,300 to $81,200. -/
def cppEnhanced (salary : Cents) : Cents :=
  (min salary 7130000 - 350000) * 100 / 10000 + (min salary 8120000 - 7130000) * 400 / 10000
def cpp (salary : Cents) : Cents := cppBase salary + cppEnhanced salary

/-- The salary that, with the employer's matching CPP, uses up the $100,000: $95,569.90. -/
def salary : Cents := 9556990

/-- Option A: the owner's year with the salary. -/
def withSalary : IndividualYear.Facts :=
  { taxationYear := 2025, employmentAndBusiness := salary, personalAmounts := some {},
    employment := some { employmentIncome := salary, cppBase := cppBase salary, cppEnhanced := cppEnhanced salary } }

/-- Option B: Opco's tax, and the owner's year with the dividend. -/
def opco : CorporateRates.Facts := { taxableIncome := available, activeBusinessIncome := available }
def dividend : Cents := available - CorporateRates.tax opco
def withDividend : IndividualYear.Facts :=
  { taxationYear := 2025, personalAmounts := some {}, dividends := [{ description := "Opco dividend", amount := dividend }] }

/-! ## Analysis -/

/-- The salary and Opco's matching CPP use up the $100,000 exactly: $3,356.10 of base and $1,074 of
enhanced contributions each. -/
theorem salary_uses_it_all : salary + cpp salary = available ∧ cppBase salary = 335610 ∧ cppEnhanced salary = 107400 := by decide

/-- Option A: the owner's federal tax is $12,866.49, after $675.79 of employment and CPP credits and
the 60(e.1) deduction of the enhanced contributions. -/
theorem salary_tax :
    IndividualYear.federalTax withSalary = 1286649 ∧ IndividualYear.employmentCredits withSalary = 67579 ∧
    IndividualYear.enhancedCpp withSalary = 107400 := by decide

/-- Option B: Opco pays $9,000; the $91,000 dividend costs the owner $6,173.87 of federal tax. -/
theorem dividend_tax : CorporateRates.tax opco = 900000 ∧ dividend = 9100000 ∧ IndividualYear.federalTax withDividend = 617387 := by
  decide

/-- **Federally, the dividend leaves the owner $6,552.82 more**: $84,826.13 against $78,273.31. Tax
and CPP come to $21,726.69 with the salary ($8,860.20 of it CPP, which buys a pension) and $15,173.87
with the dividend. -/
theorem what_the_owner_keeps :
    salary - cpp salary - IndividualYear.federalTax withSalary = 7827331 ∧
    dividend - IndividualYear.federalTax withDividend = 8482613 ∧
    IndividualYear.federalTax withSalary + 2 * cpp salary = 2172669 ∧
    CorporateRates.tax opco + IndividualYear.federalTax withDividend = 1517387 := by decide

/-- Without CPP, the two federal routes are close: $12,866.49 of tax on the salary against $15,173.87
on the dividend route, the dividend tax credit not quite integrating at the small business rate. -/
theorem tax_alone : CorporateRates.tax opco + IndividualYear.federalTax withDividend - IndividualYear.federalTax withSalary = 230738 := by
  decide

/-- Neither pays minimum tax. -/
theorem no_minimum_tax :
    MinimumTax.taxPayable withSalary = IndividualYear.federalTax withSalary ∧
    MinimumTax.taxPayable withDividend = IndividualYear.federalTax withDividend := by decide

end Canteen.Transactions.SalaryOrDividend

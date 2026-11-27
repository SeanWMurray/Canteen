import Canteen.ITA.S3.IndividualYear
import Canteen.ITA.S89.GeneralRateIncomePool

/-!
# Layer 3: how much of a dividend to designate eligible

A constructed example under 82(1), 89(1), 117(2), 121, 123 to 125 and 185.1(1), federal tax only.

* Opco, a CCPC with a $500,000 business limit, earns $1,000,000 of active business income in 2025
  and has no pool from earlier years. Its federal tax is $120,000 (9% on the first $500,000, 15% on
  the rest), leaving $880,000.
* Opco pays all $880,000 to its sole shareholder, who has no other income, in the same year.
* How much should Opco designate as eligible dividends (89(14))?

Option A designates exactly its general rate income pool, $360,000. Option B designates nothing.
Option C designates $425,000, the after-tax income it earned at the general rate.

The 185.1(2) election (to treat the excess as a separate non-eligible dividend), the minimum tax
and provincial tax are not computed.
-/

namespace Canteen.Transactions.EligibleDesignation

open Canteen Canteen.ITA

def opcoRates : CorporateRates.Facts := { taxableIncome := 100000000, activeBusinessIncome := 100000000 }

def opco (eligible : Cents) : GeneralRateIncomePool.Facts := { rates := opcoRates, eligiblePaid := eligible }

def paidOut : Cents := 88000000

/-- The shareholder's year, with `eligible` of the $880,000 designated eligible. -/
def shareholder (eligible : Cents) : IndividualYear.Facts :=
  { taxationYear := 2025, personalAmounts := some {},
    dividends := [{ description := "eligible dividends", amount := eligible, eligible := true },
                  { description := "other dividends", amount := paidOut - eligible }] }

/-- Total federal tax on the income: Opco's, the Part III.1 tax, and the shareholder's. -/
def total (eligible : Cents) : Cents :=
  CorporateRates.tax opcoRates + GeneralRateIncomePool.partIII1 (opco eligible) + IndividualYear.federalTax (shareholder eligible)

/-! ## Analysis -/

/-- Opco's tax is $120,000, and its pool at year end is $360,000: 72% of the $500,000 taxed at the
general rate. -/
theorem opco_tax : CorporateRates.tax opcoRates = 12000000 ∧ paidOut = 100000000 - CorporateRates.tax opcoRates ∧
    GeneralRateIncomePool.adjustedTaxableIncome (opco 0) = 50000000 ∧ GeneralRateIncomePool.pool (opco 0) = 36000000 := by decide

/-- Option A: designating the pool, nothing is excessive. -/
theorem designate_pool : GeneralRateIncomePool.excessive (opco 36000000) = 0 := by decide

/-- Option C: designating $425,000, $65,000 is excessive and bears $13,000 of Part III.1 tax. -/
theorem over_designate :
    GeneralRateIncomePool.excessive (opco 42500000) = 6500000 ∧ GeneralRateIncomePool.partIII1 (opco 42500000) = 1300000 := by decide

/-- The shareholder's federal tax: $205,430.45 under A, $215,340.02 under B, $203,641.23 under C. -/
theorem shareholder_tax :
    IndividualYear.federalTax (shareholder 36000000) = 20543045 ∧ IndividualYear.federalTax (shareholder 0) = 21534002 ∧
    IndividualYear.federalTax (shareholder 42500000) = 20364123 := by decide

/-- **Designate the pool.** In total, A costs $325,430.45, B $335,340.02 and C $336,641.23: designating
the pool saves $9,909.57 over designating nothing, and the extra $65,000 designated under C saves the
shareholder $1,789.22 but costs $13,000 of Part III.1 tax. -/
theorem designate_the_pool :
    total 36000000 = 32543045 ∧ total 0 = 33534002 ∧ total 42500000 = 33664123 ∧
    total 0 - total 36000000 = 990957 ∧ total 42500000 - total 36000000 = 1121078 := by decide

end Canteen.Transactions.EligibleDesignation

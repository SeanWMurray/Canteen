import Canteen.ITA.S3.IndividualYear

/-!
# Tests: an individual's year, from income to taxable income

In 2025 an individual earns a $100,000 salary and a $10,000 non-eligible dividend, recaptures
$15,000 on a rental building, is attributed $4,000 of interest on money given to a spouse, and sells
qualified small business corporation shares at a $400,000 gain. A $10,000 net capital loss from
2020 is claimed. Amounts in half-cents: $1 is 200. Constructed examples.
-/

namespace Canteen.Tests.IndividualYear

open Canteen Canteen.ITA Canteen.ITA.IndividualYear

def qsbcSale : CapitalGains.Disposition := { description := "Opco shares", proceeds := 40010000, adjustedCostBase := 10000 }

def rental : Depreciable.ClassFacts :=
  { name := "Class 1", acquisitions := [30000000], depreciation := 2000000,
    dispositions := [{ description := "the building", proceeds := 29500000, capitalCost := 30000000 }],
    ownsPropertyAtYearEnd := false }

def year : Facts :=
  { taxationYear := 2025, employmentAndBusiness := 10000000,
    dividends := [{ description := "dividend from Opco", amount := 1000000 }],
    depreciableClasses := [rental],
    attributions := [{ recipient := .spouse, amounts := [{ description := "interest on the gift", income := 400000 }] }],
    capital := ⟨[qsbcSale], 0, {}⟩,
    netCapitalLossClaims := [{ lossYear := 2020, amount := 2000000 }],
    deduction110_6 := some { qualifying := [qsbcSale] } }

-- Sources: $100,000 + $11,500 + $15,000 recapture + $4,000 = $130,500; with the $400,000 gain's
-- taxable half, income is $330,500.
example : recapture year = 1500000 := by decide
example : income year = 2 * 33050000 := by decide
-- The $10,000 net capital loss is deducted, and the capital gains deduction is $190,000: the
-- $200,000 taxable gain less the net capital loss deducted (it reduces the annual gains limit).
example : netCapitalLossDeduction year = 2 * 1000000 ∧ capitalGainsDeduction year = 2 * 19000000 := by decide
-- Taxable income: $130,500.
example : taxableIncome year = 2 * 13050000 := by decide
-- Without the loss claim, the deduction is the whole $200,000, and taxable income the same $130,500.
example : capitalGainsDeduction { year with netCapitalLossClaims := [] } = 2 * 20000000 ∧
    taxableIncome { year with netCapitalLossClaims := [] } = 2 * 13050000 := by decide
-- Without the capital gains deduction, taxable income is $320,500.
example : taxableIncome { year with deduction110_6 := none } = 2 * 32050000 := by decide

/-! ## Read-back -/

#guard (explain year).render.splitOn "\n" ==
  ["1. Employment and business income $100,000.00; dividends included $11,500.00 (with the gross-up); recapture $15,000.00; income attributed $4,000.00. [ITA 3(a); 82(1); 13(1); 74.1]",
   "2. Taxable capital gains, net: $200,000.00. [ITA 3(b)]",
   "3. Losses: business $0.00, terminal $0.00, attributed $0.00; interest deducted $0.00. [ITA 3(d); 20(16); 74.1; 20(1)(c)]",
   "4. Income for the year: $330,500.00. [ITA 3]",
   "5. Less the net capital loss deduction $10,000.00, the capital gains deduction $190,000.00, and other deductions $0.00: taxable income $130,500.00. [ITA 2(2); 111(1)(b); 110.6(2), (2.1)]",
   "6. Tax under 117(2) on taxable income, $23,889.37, less the dividend tax credit of $1,038.46, the personal credit of $0.00, the donation credit of $0.00, the medical expense credit of $0.00 and other credits of $0.00: $22,850.91. [ITA 117(2); 120.4(2); 121; 118; 118.1; 118.2]"]

/-! ## Federal tax -/

-- On taxable income of $130,500: 14% of $57,375, 20.5% of $57,375, 26% of $15,750: $23,889.37.
example : Rates.tax 13050000 = 2388937 := by decide
example : federalTax year = 2285091 := by decide

-- A child's $10,000 Opco dividend, all split income: deducted from income, taxed at 33% less the credit.
def childYear : Facts :=
  { taxationYear := 2025, dividends := [{ description := "Opco dividend", amount := 1000000 }],
    split := some { taxationYear := 2025, age := 15, amounts := [{ description := "Opco dividend", source := .privateDividend { description := "Opco dividend", amount := 1000000 } }] } }
example : income childYear = 0 ∧ federalTax childYear = 275654 := by decide
-- Without 120.4, the same dividend at the lowest rate would bear almost no tax.
example : federalTax { childYear with split := none } = 57154 := by decide

-- With the basic personal credit: income of $330,500 is above the 117(2)(e) threshold, so only the
-- $12,298 base, a $1,721.72 credit.
example : personalCredit { year with personalAmounts := some {} } = 172172 ∧ federalTax { year with personalAmounts := some {} } = 2112919 := by
  decide

-- Donating $10,000 of shares of a public company (taxed at nil under 38(a.1)): a credit of 14% of
-- $200 and 29% of $9,800.
example : donationCredit { year with charitableGifts := 1000000 } = 287000 := by decide

end Canteen.Tests.IndividualYear

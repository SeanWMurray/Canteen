import Canteen.ITA.S3.Income
import Canteen.ITA.S111.NetCapitalLoss
import Canteen.ITA.S110_6.CapitalGainsDeduction
import Canteen.ITA.S82.Dividends
import Canteen.ITA.S13.Depreciable
import Canteen.ITA.S74.IncomeAttribution
import Canteen.ITA.S117.Rates
import Canteen.ITA.S118.PersonalCredits
import Canteen.ITA.S118_1.Donations
import Canteen.ITA.S120_4.SplitIncome
import Canteen.ITA.S20.InterestDeductibility
import Canteen.ITA.S118_2.MedicalExpenses
import Canteen.ITA.S118_3.Disability

/-!
# An individual's year: income from the encoded sources, and taxable income

This puts the encoded provisions together for one individual and one taxation year:

* **3(a)** income from sources: employment and business income (given), taxable dividends with the
  gross-up (82(1)), recapture of capital cost allowance (13(1)), and income attributed to the
  individual (74.1);
* **3(b)** the capital gains computation (sections 38 to 41, with 74.2 attribution);
* **3(c)** Subdivision E deductions (given);
* **3(d)** losses from sources: business losses (given), terminal losses (20(16)), losses
  attributed to the individual (74.1), and interest deductible under 20(1)(c);
* **taxable income (2(2))**: income less the net capital loss deduction (111(1)(b)), the capital
  gains deduction (110.6(2.1)), computed after it as 110.6 requires, and other Division C
  deductions (given).

Recapture is treated as income from the business, and a terminal loss as a business loss, of the
year. Split income (120.4) is deducted from income (20(1)(ww)) and taxed at the highest rate. Federal
tax is 117(2) on taxable income plus the split income tax, less the dividend tax credit (121) and
the basic personal and spouse credit (118(1)), the donation credit (118.1), the medical expense
credit (118.2), the disability credit (118.3), and other non-refundable credits (given). Amounts
are in cents, except section 3 and taxable income, in half-cents.
-/

namespace Canteen.ITA.IndividualYear

open CapitalGains (HalfCents Disposition Year formatHalfCents)

/-- The individual's history for the capital gains deduction. -/
structure DeductionHistory where
  /-- The year's dispositions of qualified small business corporation shares (part of the year's). -/
  qualifying : List Disposition := []
  /-- The year's dispositions of qualified farm or fishing property (part of the year's). -/
  farmOrFishing : List Disposition := []
  limit : Cents := 62500000
  priorWeighted : HalfCents := 0
  priorDeductions : HalfCents := 0
  priorA : HalfCents := 0
  priorB : HalfCents := 0
  cumulativeNetInvestmentLoss : HalfCents := 0
  deriving Repr, Inhabited

structure Facts where
  taxationYear : Nat
  /-- Employment and business income, other than recapture. -/
  employmentAndBusiness : Cents := 0
  dividends : List Dividends.Dividend := []
  depreciableClasses : List Depreciable.ClassFacts := []
  /-- Property transferred or lent by the individual, whose income 74.1 attributes back. -/
  attributions : List IncomeAttribution.Facts := []
  capital : Year := ⟨[], 0, {}⟩
  subdivisionE : Cents := 0
  /-- Business losses, other than terminal losses. -/
  businessLosses : Cents := 0
  /-- Borrowings whose interest may be deductible under 20(1)(c). -/
  borrowings : List InterestDeductibility.Borrowing := []
  netCapitalLossClaims : List NetCapitalLoss.Claim := []
  deduction110_6 : Option DeductionHistory := none
  otherDivisionC : Cents := 0
  /-- Tax on split income: the individual's split income facts (its dividends are also in `dividends`). -/
  split : Option SplitIncome.Facts := none
  /-- The 117(2) bracket amounts for the year (2025 by default). -/
  brackets : Rates.Brackets := {}
  /-- 118(1): the indexed amounts for the year, if the basic personal (and spouse) credit is claimed. -/
  personalAmounts : Option PersonalCredits.Amounts := none
  supportsSpouse : Bool := false
  spouseIncome : Cents := 0
  spouseInfirm : Bool := false
  /-- 118.1: total charitable gifts (with those carried forward), and the gains on gifts (B to D). -/
  charitableGifts : Cents := 0
  giftGains : Cents := 0
  deathYear : Bool := false
  /-- 118.2: medical expenses. -/
  medicalExpenses : List MedicalExpenses.Expense := []
  /-- 118.3(1): the individual's disability facts, if the credit is claimed. -/
  disability : Option Disability.Facts := none
  /-- Other non-refundable credits, given. -/
  otherCredits : Cents := 0
  deriving Inhabited

def dividendFacts (f : Facts) : Dividends.Facts := { taxationYear := f.taxationYear, dividends := f.dividends }

def recapture (f : Facts) : Cents := (f.depreciableClasses.map (·.recapture)).sum
def terminalLosses (f : Facts) : Cents := (f.depreciableClasses.map (·.terminalLoss)).sum
def attributedIncome (f : Facts) : Cents := (f.attributions.map IncomeAttribution.attributedIncome).sum
def attributedLoss (f : Facts) : Cents := (f.attributions.map IncomeAttribution.attributedLoss).sum

/-- 20(1)(c): interest deducted, in computing income from the business or property. -/
def interestDeduction (f : Facts) : Cents := InterestDeductibility.total f.borrowings

/-- Split income (120.4), deducted in computing income (20(1)(ww)). -/
def splitIncome (f : Facts) : Cents := (f.split.map SplitIncome.splitIncome).getD 0

/-- Section 3, from the components. -/
def incomeFacts (f : Facts) : Income.Facts :=
  { incomeFromSources := (f.employmentAndBusiness + Dividends.inclusion (dividendFacts f) + recapture f + attributedIncome f) - splitIncome f,
    capital := f.capital, subdivisionE := f.subdivisionE,
    sourceLosses := f.businessLosses + terminalLosses f + attributedLoss f + interestDeduction f }

def income (f : Facts) : HalfCents := Income.income (incomeFacts f)

/-- 111(1)(b), (1.1). -/
def netCapitalLossDeduction (f : Facts) : HalfCents :=
  NetCapitalLoss.deduction f.taxationYear f.capital.paragraph3b f.netCapitalLossClaims

/-- 110.6(2) and (2.1), with the year's net capital loss deduction in the annual gains limit. -/
def capitalGainsDeduction (f : Facts) : HalfCents :=
  match f.deduction110_6 with
  | none => 0
  | some h => CapitalGainsDeduction.total
      { taxationYear := f.taxationYear, year := f.capital, qualifying := h.qualifying, farmOrFishing := h.farmOrFishing,
        limit := h.limit,
        priorWeighted := h.priorWeighted, priorDeductions := h.priorDeductions, priorA := h.priorA, priorB := h.priorB,
        cumulativeNetInvestmentLoss := h.cumulativeNetInvestmentLoss, netCapitalLossesDeducted := netCapitalLossDeduction f }

/-- Taxable income (2(2)), in half-cents. -/
def taxableIncome (f : Facts) : HalfCents :=
  income f - netCapitalLossDeduction f - capitalGainsDeduction f - 2 * f.otherDivisionC

/-- 118(1): the basic personal (and spouse) credit, on the individual's income for the year. -/
def personalFacts (f : Facts) (a : PersonalCredits.Amounts) : PersonalCredits.Facts :=
  { income := income f / 2, supportsSpouse := f.supportsSpouse, spouseIncome := f.spouseIncome, spouseInfirm := f.spouseInfirm, amounts := a, brackets := f.brackets }

def personalCredit (f : Facts) : Cents :=
  match f.personalAmounts with
  | none => 0
  | some a => PersonalCredits.credit (personalFacts f a)

def donationFacts (f : Facts) : Donations.Facts :=
  { charitableGifts := f.charitableGifts, income := income f / 2, amountTaxable := taxableIncome f / 2, deathYear := f.deathYear, giftGains := f.giftGains, brackets := f.brackets }

/-- 118.1(3): the donation credit. -/
def donationCredit (f : Facts) : Cents := Donations.credit (donationFacts f)

/-- 118.2(1): the medical expense credit, on the individual's income for the year. -/
def medicalCredit (f : Facts) : Cents := MedicalExpenses.credit { income := income f / 2, expenses := f.medicalExpenses }

/-- 118.3(1): the disability credit. -/
def disabilityCredit (f : Facts) : Cents := (f.disability.map Disability.credit).getD 0

/-- Tax under 117(2) on taxable income, plus tax on split income (120.4(2)), less the dividend tax
credit, the personal credit, the donation credit, the medical expense credit and other credits. -/
def federalTax (f : Facts) : Cents :=
  (Rates.tax (taxableIncome f / 2) f.brackets + (f.split.map SplitIncome.tax).getD 0) -
    (Dividends.credit (dividendFacts f) + personalCredit f + donationCredit f + medicalCredit f + disabilityCredit f + f.otherCredits)

def explain (f : Facts) : Finding :=
  let h := formatHalfCents
  let c := formatCents
  ⟨taxableIncome f > 0, [
    ⟨s!"Employment and business income {c f.employmentAndBusiness}; dividends included {c (Dividends.inclusion (dividendFacts f))} " ++
      s!"(with the gross-up); recapture {c (recapture f)}; income attributed {c (attributedIncome f)}.",
      "ITA 3(a); 82(1); 13(1); 74.1"⟩,
    ⟨s!"Taxable capital gains, net: {h f.capital.paragraph3b}.", "ITA 3(b)"⟩,
    ⟨s!"Losses: business {c f.businessLosses}, terminal {c (terminalLosses f)}, attributed {c (attributedLoss f)}; " ++
      s!"interest deducted {c (interestDeduction f)}.", "ITA 3(d); 20(16); 74.1; 20(1)(c)"⟩,
    ⟨s!"Income for the year: {h (income f)}.", "ITA 3"⟩,
    ⟨s!"Less the net capital loss deduction {h (netCapitalLossDeduction f)}, the capital gains deduction " ++
      s!"{h (capitalGainsDeduction f)}, and other deductions {c f.otherDivisionC}: taxable income {h (taxableIncome f)}.",
      "ITA 2(2); 111(1)(b); 110.6(2), (2.1)"⟩,
    ⟨s!"Tax under 117(2) on taxable income, {c (Rates.tax (taxableIncome f / 2) f.brackets)}" ++
      (if splitIncome f > 0 then s!", plus tax on split income of {c ((f.split.map SplitIncome.tax).getD 0)}" else "") ++
      s!", less the dividend tax credit of {c (Dividends.credit (dividendFacts f))}, the personal credit of {c (personalCredit f)}, " ++
      s!"the donation credit of {c (donationCredit f)}, the medical expense credit of {c (medicalCredit f)}, " ++
      s!"the disability credit of {c (disabilityCredit f)} and other credits of {c f.otherCredits}: {c (federalTax f)}.",
      "ITA 117(2); 120.4(2); 121; 118; 118.1; 118.2; 118.3"⟩], (f.disability.map (·.impairment.judgments)).getD []⟩

/-! ## Truths about the year -/

/-- Taxable income never exceeds income. -/
theorem taxable_le_income (f : Facts) : taxableIncome f ≤ income f := by
  unfold taxableIncome
  exact Nat.le_trans (Nat.sub_le _ _) (Nat.le_trans (Nat.sub_le _ _) (Nat.sub_le _ _))

/-- The capital gains deduction never exceeds the year's net taxable capital gains. -/
theorem capital_gains_deduction_le (f : Facts) : capitalGainsDeduction f ≤ f.capital.paragraph3b := by
  unfold capitalGainsDeduction
  split
  · exact Nat.zero_le _
  · rename_i h _
    exact Nat.le_trans (CapitalGainsDeduction.total_le_annual _)
      (Nat.le_trans (Nat.sub_le _ _) (Nat.min_le_left _ _))

end Canteen.ITA.IndividualYear

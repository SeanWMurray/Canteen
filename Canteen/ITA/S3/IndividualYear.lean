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
import Canteen.ITA.S60_03.PensionSplitting
import Canteen.ITA.S180_2.OasRecovery
import Canteen.ITA.S118_7.EmploymentCredits
import Canteen.ITA.S117_1.YearAmounts
import Canteen.ITA.S118_01.SmallCredits
import Canteen.ITA.S118_5.Tuition
import Canteen.ITA.S56.Support
import Canteen.ITA.S63.ChildCare
import Canteen.ITA.S62.MovingExpenses
import Canteen.ITA.S6.StandbyCharge
import Canteen.ITA.S15.ShareholderBenefit
import Canteen.ITA.S7.StockOptions
import Canteen.ITA.S118_62.StudentLoanInterest
import Canteen.ITA.S146.RRSP

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

Every dollar amount 117.1 indexes (the brackets, the personal, age, disability, employment and
medical amounts, the OAS threshold, the capital gains deduction limit) is the taxation year's, from
`YearAmounts`; a year not yet computed uses the latest year's, and the explanation warns of it.

Recapture is treated as income from the business, and a terminal loss as a business loss, of the
year. Split income (120.4) is deducted from income (20(1)(ww)) and taxed at the highest rate. Federal
tax is 117(2) on taxable income plus the split income tax, less the dividend tax credit (121) and
the basic personal and spouse credit (118(1)), the donation credit (118.1), the medical expense
credit (118.2), the disability credit (118.3), the age and pension credits (118(2), (3)), and other
non-refundable credits (given). Pension income is included in income from sources, and a
split-pension amount is deducted by the pensioner (60(c), in 3(c)) and included by the transferee
(56(1)(a.2)). Amounts
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
  /-- 110.6(2)(a): the limit, if not the year's indexed amount. -/
  limit : Option Cents := none
  priorWeighted : HalfCents := 0
  priorDeductions : HalfCents := 0
  priorA : HalfCents := 0
  priorB : HalfCents := 0
  cumulativeNetInvestmentLoss : HalfCents := 0
  deriving Repr, Inhabited

structure Facts where
  taxationYear : Nat
  /-- Employment and business income, other than recapture and the benefits computed below. -/
  employmentAndBusiness : Cents := 0
  /-- 15(1): benefits conferred by corporations on the individual as shareholder. -/
  shareholderBenefits : List ShareholderBenefit.Facts := []
  /-- 7(1)(a), 7(1.1), 110(1)(d), (d.1): securities acquired under employee option agreements; each counts in the
  year its benefit is received. -/
  stockOptions : List StockOptions.Facts := []
  /-- 6(1)(e): automobiles the employer made available. -/
  standby : List StandbyCharge.Facts := []
  dividends : List Dividends.Dividend := []
  depreciableClasses : List Depreciable.ClassFacts := []
  /-- Property transferred or lent by the individual, whose income 74.1 attributes back. -/
  attributions : List IncomeAttribution.Facts := []
  capital : Year := ⟨[], 0, {}⟩
  subdivisionE : Cents := 0
  /-- Business losses, other than terminal losses. -/
  businessLosses : Cents := 0
  /-- 60(b): support paid, one entry per recipient; 56(1)(b): support received, one per payer. -/
  supportPaid : List Support.Facts := []
  supportReceived : List Support.Facts := []
  /-- 63: child care expenses claimed (earned income is the year's employment and business income); the
  supporting person's income, if any, for 63(2). -/
  childCare : Option ChildCare.Facts := none
  supportingPersonIncome : Option Cents := none
  /-- 62(1): moving expenses for an eligible relocation. -/
  moving : Option MovingExpenses.Facts := none
  /-- Borrowings whose interest may be deductible under 20(1)(c). -/
  borrowings : List InterestDeductibility.Borrowing := []
  netCapitalLossClaims : List NetCapitalLoss.Claim := []
  deduction110_6 : Option DeductionHistory := none
  otherDivisionC : Cents := 0
  /-- Tax on split income: the individual's split income facts (its dividends are also in `dividends`). -/
  split : Option SplitIncome.Facts := none
  /-- 118(1): the basic personal (and spouse or eligible dependant) credit is claimed. -/
  claimsPersonal : Bool := false
  supportsSpouse : Bool := false
  spouseIncome : Cents := 0
  spouseInfirm : Bool := false
  /-- 118(1)(b): an eligible dependant, if no spouse amount is claimed. -/
  eligibleDependant : Option PersonalCredits.Dependant := none
  /-- 118(1)(b.1), (d): infirm children under 18, and the incomes of infirm adult dependants. -/
  infirmChildren : Nat := 0
  caregiverDependants : List Cents := []
  /-- 118.1: total charitable gifts (with those carried forward), and the gains on gifts (B to D). -/
  charitableGifts : Cents := 0
  giftGains : Cents := 0
  deathYear : Bool := false
  /-- 118.2: medical expenses. -/
  medicalExpenses : List MedicalExpenses.Expense := []
  /-- 65 or over at the end of the year (118(2), (7)). -/
  age65 : Bool := false
  /-- Pension and similar payments received (118(7), (8)), included in income. -/
  pensions : List PensionSplitting.Payment := []
  /-- 60.03, 60(c): the split-pension amount elected as pensioner (capped at the 60.03(1) limit). -/
  splitOut : Cents := 0
  /-- 56(1)(a.2): the split-pension amount received as transferee, and whether it was qualified
  pension income to the pensioner (60.03(2)(b)(ii)). -/
  splitIn : Cents := 0
  splitInQualified : Bool := true
  /-- 118(10), 118.7, 60(e.1): employment income (part of `employmentAndBusiness`), and the CPP and EI amounts. -/
  employment : Option EmploymentCredits.Facts := none
  /-- 118.3(1): the individual's disability facts, if the credit is claimed. -/
  disability : Option Disability.Facts := none
  /-- 118.3(2): disability credits transferred from dependants (see `disabilityTransferFrom`). -/
  disabilityTransferred : Cents := 0
  /-- 118.01 to 118.07: adoption, home accessibility, home buyers' and volunteer credits (the adoption limit
  is the year's). -/
  smallCredits : SmallCredits.Facts := {}
  /-- 118.5(1)(a): qualifying tuition fees paid for the year; 118.61: unused tuition credits carried in
  (as credits); 118.81(b): the amount designated for transfer; 118.9: credits transferred to the
  individual by a child or grandchild (see `tuitionTransferFrom`). -/
  tuitionFees : Cents := 0
  tuitionCarried : Cents := 0
  tuitionDesignated : Cents := 0
  tuitionTransferredIn : Cents := 0
  /-- 146(5), (5.1): RRSP premiums, and the facts of the RRSP deduction limit. -/
  rrsp : Option RRSP.Facts := none
  /-- 118.62: student loan interest paid, this year and in the five before (the year is the taxation year). -/
  studentLoanInterest : List StudentLoanInterest.Payment := []
  /-- Other non-refundable credits, given. -/
  otherCredits : Cents := 0
  deriving Inhabited

/-- The indexed amounts (117.1) for the taxation year. A year not yet computed takes the latest year's,
and `amountsKnown` is false: the explanation says so. -/
def amounts (f : Facts) : YearAmounts := (YearAmounts.forYear f.taxationYear).getD YearAmounts.latest.2

/-- The year's EI and CPP maximums, where an employment credit is claimed. -/
def employmentAmounts (f : Facts) (e : EmploymentCredits.Facts) : EmploymentCredits.Amounts :=
  let fallback : EmploymentCredits.Amounts := { e.amounts with employmentAmount := (amounts f).employmentAmount }
  (EmploymentCredits.amountsFor f.taxationYear (amounts f).employmentAmount).getD fallback

def employmentFacts (f : Facts) : Option EmploymentCredits.Facts :=
  f.employment.map fun e => { e with amounts := employmentAmounts f e }

/-- Every amount the year uses is the year's own. -/
def amountsKnown (f : Facts) : Bool :=
  (YearAmounts.forYear f.taxationYear).isSome &&
    (f.employment.isNone || (EmploymentCredits.amountsFor f.taxationYear 0).isSome)

def dividendFacts (f : Facts) : Dividends.Facts := { taxationYear := f.taxationYear, dividends := f.dividends }

def recapture (f : Facts) : Cents := (f.depreciableClasses.map (·.recapture)).sum
def terminalLosses (f : Facts) : Cents := (f.depreciableClasses.map (·.terminalLoss)).sum
def attributedIncome (f : Facts) : Cents := (f.attributions.map IncomeAttribution.attributedIncome).sum
def attributedLoss (f : Facts) : Cents := (f.attributions.map IncomeAttribution.attributedLoss).sum

/-- 20(1)(c): interest deducted, in computing income from the business or property. -/
def interestDeduction (f : Facts) : Cents := InterestDeductibility.total f.borrowings

/-- 60.03(1), 60(c): the split-pension amount deducted, at most the limit. -/
def splitOutAllowed (f : Facts) : Cents := min f.splitOut (PensionSplitting.splitLimit f.age65 f.pensions)

def pensionTotal (f : Facts) : Cents := (f.pensions.map (·.amount)).sum

/-- 60(e.1): enhanced CPP contributions, deducted in 3(c). -/
def enhancedCpp (f : Facts) : Cents := ((employmentFacts f).map EmploymentCredits.enhancedDeduction).getD 0

/-- 118(10) and 118.7: the employment, CPP and EI credits. -/
def employmentCredits (f : Facts) : Cents := ((employmentFacts f).map EmploymentCredits.credits).getD 0

/-- 56(1)(b), 60(b). -/
def supportIncluded (f : Facts) : Cents := (f.supportReceived.map Support.amount).sum
def supportDeducted (f : Facts) : Cents := (f.supportPaid.map Support.amount).sum

/-- 6(1)(e): standby charges included in employment income. -/
def standbyBenefits (f : Facts) : Cents := (f.standby.map StandbyCharge.benefit).sum

/-- 7(1)(a): the option benefits received in this taxation year. -/
def optionsThisYear (f : Facts) : List StockOptions.Facts :=
  f.stockOptions.filter fun o => StockOptions.inclusionYear o == some f.taxationYear

def stockOptionBenefits (f : Facts) : Cents := ((optionsThisYear f).map StockOptions.benefit).sum

/-- 110(1)(d), (d.1): deducted in computing taxable income (not allowed for the minimum tax, 127.52(1)(h)). -/
def stockOptionDeduction (f : Facts) : Cents := ((optionsThisYear f).map StockOptions.deduction).sum

/-- 15(1). -/
def shareholderBenefitIncome (f : Facts) : Cents := (f.shareholderBenefits.map ShareholderBenefit.inclusion).sum

/-- The sources of income computed here other than employment and business income, dividends, recapture
and attribution: standby charges, pensions, split pension received, support, shareholder benefits. -/
def otherSources (f : Facts) : Cents :=
  standbyBenefits f + stockOptionBenefits f + pensionTotal f + f.splitIn + supportIncluded f + shareholderBenefitIncome f

/-- 62(1). -/
def movingDeduction (f : Facts) : Cents := (f.moving.map MovingExpenses.deduction).getD 0

/-- 146(5), (5.1): the RRSP deduction. -/
def rrspDeduction (f : Facts) : Cents := (f.rrsp.map RRSP.deduction).getD 0

/-- The Subdivision E deductions computed here, other than 63 and 60(w): 60(c), 60(e.1), 60(b), 62, 146(5). -/

def otherSubdivisionE (f : Facts) : Cents := splitOutAllowed f + enhancedCpp f + supportDeducted f + movingDeduction f + rrspDeduction f

/-- Split income (120.4), deducted in computing income (20(1)(ww)). -/
def splitIncome (f : Facts) : Cents := (f.split.map SplitIncome.splitIncome).getD 0

/-- Section 3, from the components, before the 63 and 60(w) deductions. -/
def incomeFactsCore (f : Facts) : Income.Facts :=
  { incomeFromSources := (f.employmentAndBusiness + Dividends.inclusion (dividendFacts f) + recapture f + attributedIncome f +
        otherSources f) - splitIncome f,
    capital := f.capital, subdivisionE := f.subdivisionE + otherSubdivisionE f,
    sourceLosses := f.businessLosses + terminalLosses f + attributedLoss f + interestDeduction f }

/-- 63: the child care facts, with the year's earned income and, where the supporting person's income is
given, 63(2) decided on incomes before section 63 (and 60(w)). -/
def childCareFacts (f : Facts) (c : ChildCare.Facts) : ChildCare.Facts :=
  { c with earnedIncome := f.employmentAndBusiness + standbyBenefits f + stockOptionBenefits f,
           higherIncome := match f.supportingPersonIncome with
             | some i => decide (i < Income.income (incomeFactsCore f) / 2)
             | none => c.higherIncome }

def childCareDeduction (f : Facts) : Cents := (f.childCare.map fun c => ChildCare.deduction (childCareFacts f c)).getD 0

/-- Section 3, with the 63 deduction in 3(c), before the 60(w) deduction. -/
def incomeFactsBase (f : Facts) : Income.Facts :=
  { incomeFactsCore f with subdivisionE := (incomeFactsCore f).subdivisionE + childCareDeduction f }

/-- Old Age Security benefits included in income. -/
def oasReceived (f : Facts) : Cents := ((f.pensions.filter (·.kind == .oldAgeSecurity)).map (·.amount)).sum

/-- 180.2(1): adjusted income, without the 60(w) deduction, in half-cents. -/
def adjustedIncome (f : Facts) : HalfCents := Income.income (incomeFactsBase f)

/-- 180.2(2): the Part I.2 tax, deducted in computing income under 60(w). -/
def oasRecovery (f : Facts) : Cents := OasRecovery.tax (oasReceived f) (adjustedIncome f / 2) (amounts f).oasThreshold

/-- Section 3, with the 60(w) deduction in 3(c). -/
def incomeFacts (f : Facts) : Income.Facts :=
  { incomeFactsBase f with subdivisionE := (incomeFactsBase f).subdivisionE + oasRecovery f }

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
        limit := h.limit.getD (amounts f).capitalGainsLimit,
        priorWeighted := h.priorWeighted, priorDeductions := h.priorDeductions, priorA := h.priorA, priorB := h.priorB,
        cumulativeNetInvestmentLoss := h.cumulativeNetInvestmentLoss, netCapitalLossesDeducted := netCapitalLossDeduction f }

/-- Taxable income (2(2)), in half-cents. -/
def taxableIncome (f : Facts) : HalfCents :=
  income f - netCapitalLossDeduction f - capitalGainsDeduction f - 2 * (f.otherDivisionC + stockOptionDeduction f)

/-- 118(1): the basic personal (and spouse) credit, on the individual's income for the year. -/
def personalFacts (f : Facts) : PersonalCredits.Facts :=
  { income := income f / 2, supportsSpouse := f.supportsSpouse, spouseIncome := f.spouseIncome, spouseInfirm := f.spouseInfirm,
    dependant := f.eligibleDependant, infirmChildren := f.infirmChildren, caregiverDependants := f.caregiverDependants,
    amounts := { base := (amounts f).bpaBase, enhanced := (amounts f).bpaEnhanced, infirm := (amounts f).infirm,
                 caregiver := (amounts f).caregiver, caregiverThreshold := (amounts f).caregiverThreshold },
    brackets := (amounts f).brackets }

def personalCredit (f : Facts) : Cents := if f.claimsPersonal then PersonalCredits.credit (personalFacts f) else 0

def donationFacts (f : Facts) : Donations.Facts :=
  { charitableGifts := f.charitableGifts, income := income f / 2, amountTaxable := taxableIncome f / 2, deathYear := f.deathYear, giftGains := f.giftGains, brackets := (amounts f).brackets }

/-- 118.1(3): the donation credit. -/
def donationCredit (f : Facts) : Cents := Donations.credit (donationFacts f)

/-- 118.2(1): the medical expense credit, on the individual's income for the year. -/
def medicalCredit (f : Facts) : Cents := MedicalExpenses.credit { income := income f / 2, expenses := f.medicalExpenses, threshold := (amounts f).medicalThreshold }

/-- 118(3), with 60.03(2): eligible pension income, less the split-pension amount given, plus the
amount received to the extent it is eligible for the transferee. -/
def eligiblePension (f : Facts) : Cents :=
  (PensionSplitting.eligiblePensionIncome f.age65 f.pensions - splitOutAllowed f) +
    (if f.age65 || f.splitInQualified then f.splitIn else 0)

/-- 118(2) and 118(3): the age and pension credits. -/
def ageAndPensionCredits (f : Facts) : Cents :=
  PensionSplitting.ageCredit ⟨(amounts f).age, (amounts f).ageThreshold⟩ f.age65 (income f / 2) + PensionSplitting.pensionCredit (eligiblePension f)

/-- The year's 118.3(1) amounts. -/
def disabilityFacts (f : Facts) (d : Disability.Facts) : Disability.Facts :=
  { d with amounts := ⟨(amounts f).disability, (amounts f).disabilitySupplement, (amounts f).disabilityCare⟩ }

/-- 118.3(1): the disability credit. -/
def disabilityCredit (f : Facts) : Cents := (f.disability.map fun d => Disability.credit (disabilityFacts f d)).getD 0

/-- 118.01 to 118.07, with the year's adoption limit. -/
def smallCredits (f : Facts) : Cents := SmallCredits.credit { f.smallCredits with adoptionLimit := (amounts f).adoptionLimit }

/-- 118.3(2)(d): tax before Division E deductions other than 118 to 118.07 and 118.7. -/
def taxBeforeCredits (f : Facts) : Cents :=
  (Rates.tax (taxableIncome f / 2) (amounts f).brackets + (f.split.map SplitIncome.tax).getD 0) - (personalCredit f + ageAndPensionCredits f + employmentCredits f + smallCredits f)

/-- 118.3(2): what a supporter may deduct for this person's unused disability credit. -/
def disabilityTransferFrom (s : Disability.Supporter) (dependant : Facts) : Cents :=
  match dependant.disability with
  | none => 0
  | some d => Disability.transfer s (disabilityFacts dependant d) (taxBeforeCredits dependant)

/-- Tax after the credits in 118 to 118.07, 118.3 and 118.7: what 118.61(2) and 118.81 measure against. -/
def taxBeforeTuition (f : Facts) : Cents :=
  taxBeforeCredits f - (disabilityCredit f + f.disabilityTransferred)

def tuitionCredit (f : Facts) : Cents := Tuition.credit f.tuitionFees
def tuitionCarryUsed (f : Facts) : Cents := Tuition.carryforwardUsed f.tuitionCarried (taxBeforeTuition f)
def tuitionCurrentUsed (f : Facts) : Cents := Tuition.currentUsed (tuitionCredit f) (taxBeforeTuition f) (tuitionCarryUsed f)

/-- 118.81, 118.9: what a parent or grandparent designated by this student may deduct. -/
def tuitionTransferFrom (student : Facts) : Cents :=
  Tuition.transferred (tuitionCredit student) (taxBeforeTuition student) (tuitionCarryUsed student) student.tuitionDesignated

/-- 118.61(1): the unused credits at the end of the year, to carry forward. -/
def tuitionUnused (f : Facts) : Cents := Tuition.unused f.tuitionCarried (tuitionCredit f) (taxBeforeTuition f) f.tuitionDesignated

/-- 118.5, 118.61, 118.9: the tuition credits used in the year. -/
def tuitionCredits (f : Facts) : Cents := tuitionCarryUsed f + tuitionCurrentUsed f + f.tuitionTransferredIn

/-- 118.62: the student loan interest credit, claiming no more interest than the tax left after tuition
needs (the rest carries forward). -/
def studentLoanFacts (f : Facts) : StudentLoanInterest.Facts :=
  { taxationYear := f.taxationYear, payments := f.studentLoanInterest,
    claim := some ((taxBeforeTuition f - tuitionCredits f) * 100 / 14) }

def studentLoanCredit (f : Facts) : Cents := StudentLoanInterest.credit (studentLoanFacts f)

/-- Tax under 117(2) on taxable income, plus tax on split income (120.4(2)), less the dividend tax
credit, the personal credit, the donation credit, the medical expense credit and other credits. -/
def federalTax (f : Facts) : Cents :=
  taxBeforeTuition f - (tuitionCredits f + studentLoanCredit f + Dividends.credit (dividendFacts f) + donationCredit f + medicalCredit f + f.otherCredits)

def explain (f : Facts) : Finding :=
  let h := formatHalfCents
  let c := formatCents
  ⟨taxableIncome f > 0,
    (if amountsKnown f then [] else
      [⟨s!"Warning: the indexed amounts (or CPP and EI maximums) for {f.taxationYear} are not yet computed; those of " ++
        s!"{YearAmounts.latest.1} (or 2025) are used instead.", "ITA 117.1"⟩]) ++ [
    ⟨s!"Employment and business income {c f.employmentAndBusiness}; dividends included {c (Dividends.inclusion (dividendFacts f))} " ++
      s!"(with the gross-up); recapture {c (recapture f)}; income attributed {c (attributedIncome f)}.",
      "ITA 3(a); 82(1); 13(1); 74.1"⟩,
    ⟨s!"Taxable capital gains, net: {h f.capital.paragraph3b}.", "ITA 3(b)"⟩] ++
    (if supportIncluded f + supportDeducted f > 0 then
      [⟨s!"Support received and included: {c (supportIncluded f)}; support paid and deducted: {c (supportDeducted f)}.",
        "ITA 56(1)(b); 60(b)"⟩] else []) ++ [
    ⟨s!"Losses: business {c f.businessLosses}, terminal {c (terminalLosses f)}, attributed {c (attributedLoss f)}; " ++
      s!"interest deducted {c (interestDeduction f)}.", "ITA 3(d); 20(16); 74.1; 20(1)(c)"⟩,
    ⟨s!"Income for the year: {h (income f)}.", "ITA 3"⟩,
    ⟨s!"Less the net capital loss deduction {h (netCapitalLossDeduction f)}, the capital gains deduction " ++
      s!"{h (capitalGainsDeduction f)}, and other deductions {c f.otherDivisionC}: taxable income {h (taxableIncome f)}.",
      "ITA 2(2); 111(1)(b); 110.6(2), (2.1)"⟩,
    ⟨s!"Tax under 117(2) on taxable income, {c (Rates.tax (taxableIncome f / 2) (amounts f).brackets)}" ++
      (if splitIncome f > 0 then s!", plus tax on split income of {c ((f.split.map SplitIncome.tax).getD 0)}" else "") ++
      s!", less the dividend tax credit of {c (Dividends.credit (dividendFacts f))}, the personal credit of {c (personalCredit f)}, " ++
      s!"the age and pension credits of {c (ageAndPensionCredits f)}, the employment, CPP and EI credits of " ++
      s!"{c (employmentCredits f)}, the adoption, accessibility, home buyers' and volunteer credits of {c (smallCredits f)}, " ++
      s!"the tuition credits of {c (tuitionCredits f)}, " ++
      s!"the donation credit of {c (donationCredit f)}, the medical expense credit of {c (medicalCredit f)}, " ++
      s!"the disability credit of {c (disabilityCredit f + f.disabilityTransferred)} and other credits of {c f.otherCredits}: {c (federalTax f)}.",
      "ITA 117(2); 120.4(2); 121; 118 to 118.07; 118.1; 118.2; 118.3; 118.5; 118.61; 118.7; 118.9"⟩],
    ((f.disability.map (·.impairment.judgments)).getD [] ++
      ((f.supportPaid ++ f.supportReceived).map fun s => s.periodicAllowance.judgments ++ s.recipientDiscretion.judgments).flatten).eraseDups⟩

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

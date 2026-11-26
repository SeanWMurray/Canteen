import Canteen.ITA.S3.Income
import Canteen.ITA.S111.NetCapitalLoss
import Canteen.ITA.S110_6.CapitalGainsDeduction
import Canteen.ITA.S82.Dividends
import Canteen.ITA.S13.Depreciable
import Canteen.ITA.S74.IncomeAttribution

/-!
# An individual's year: income from the encoded sources, and taxable income

This puts the encoded provisions together for one individual and one taxation year:

* **3(a)** income from sources: employment and business income (given), taxable dividends with the
  gross-up (82(1)), recapture of capital cost allowance (13(1)), and income attributed to the
  individual (74.1);
* **3(b)** the capital gains computation (sections 38 to 41, with 74.2 attribution);
* **3(c)** Subdivision E deductions (given);
* **3(d)** losses from sources: business losses (given), terminal losses (20(16)) and losses
  attributed to the individual (74.1);
* **taxable income (2(2))**: income less the net capital loss deduction (111(1)(b)), the capital
  gains deduction (110.6(2.1)), computed after it as 110.6 requires, and other Division C
  deductions (given).

Recapture is treated as income from the business, and a terminal loss as a business loss, of the
year. The dividend tax credit (121) is reported but tax itself (117, 118) is not computed. Amounts
are in cents, except section 3 and taxable income, in half-cents.
-/

namespace Canteen.ITA.IndividualYear

open CapitalGains (HalfCents Disposition Year formatHalfCents)

/-- The individual's history for the capital gains deduction. -/
structure DeductionHistory where
  /-- The year's dispositions of qualified small business corporation shares (part of the year's). -/
  qualifying : List Disposition := []
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
  netCapitalLossClaims : List NetCapitalLoss.Claim := []
  deduction110_6 : Option DeductionHistory := none
  otherDivisionC : Cents := 0
  deriving Inhabited

def dividendFacts (f : Facts) : Dividends.Facts := { taxationYear := f.taxationYear, dividends := f.dividends }

def recapture (f : Facts) : Cents := (f.depreciableClasses.map (·.recapture)).sum
def terminalLosses (f : Facts) : Cents := (f.depreciableClasses.map (·.terminalLoss)).sum
def attributedIncome (f : Facts) : Cents := (f.attributions.map IncomeAttribution.attributedIncome).sum
def attributedLoss (f : Facts) : Cents := (f.attributions.map IncomeAttribution.attributedLoss).sum

/-- Section 3, from the components. -/
def incomeFacts (f : Facts) : Income.Facts :=
  { incomeFromSources := f.employmentAndBusiness + Dividends.inclusion (dividendFacts f) + recapture f + attributedIncome f,
    capital := f.capital, subdivisionE := f.subdivisionE,
    sourceLosses := f.businessLosses + terminalLosses f + attributedLoss f }

def income (f : Facts) : HalfCents := Income.income (incomeFacts f)

/-- 111(1)(b), (1.1). -/
def netCapitalLossDeduction (f : Facts) : HalfCents :=
  NetCapitalLoss.deduction f.taxationYear f.capital.paragraph3b f.netCapitalLossClaims

/-- 110.6(2.1), with the year's net capital loss deduction in its annual gains limit. -/
def capitalGainsDeduction (f : Facts) : HalfCents :=
  match f.deduction110_6 with
  | none => 0
  | some h => CapitalGainsDeduction.deduction
      { taxationYear := f.taxationYear, year := f.capital, qualifying := h.qualifying, limit := h.limit,
        priorWeighted := h.priorWeighted, priorDeductions := h.priorDeductions, priorA := h.priorA, priorB := h.priorB,
        cumulativeNetInvestmentLoss := h.cumulativeNetInvestmentLoss, netCapitalLossesDeducted := netCapitalLossDeduction f }

/-- Taxable income (2(2)), in half-cents. -/
def taxableIncome (f : Facts) : HalfCents :=
  income f - netCapitalLossDeduction f - capitalGainsDeduction f - 2 * f.otherDivisionC

def explain (f : Facts) : Finding :=
  let h := formatHalfCents
  let c := formatCents
  ⟨taxableIncome f > 0, [
    ⟨s!"Employment and business income {c f.employmentAndBusiness}; dividends included {c (Dividends.inclusion (dividendFacts f))} " ++
      s!"(with the gross-up); recapture {c (recapture f)}; income attributed {c (attributedIncome f)}.",
      "ITA 3(a); 82(1); 13(1); 74.1"⟩,
    ⟨s!"Taxable capital gains, net: {h f.capital.paragraph3b}.", "ITA 3(b)"⟩,
    ⟨s!"Losses: business {c f.businessLosses}, terminal {c (terminalLosses f)}, attributed {c (attributedLoss f)}.",
      "ITA 3(d); 20(16); 74.1"⟩,
    ⟨s!"Income for the year: {h (income f)}.", "ITA 3"⟩,
    ⟨s!"Less the net capital loss deduction {h (netCapitalLossDeduction f)}, the capital gains deduction " ++
      s!"{h (capitalGainsDeduction f)}, and other deductions {c f.otherDivisionC}: taxable income {h (taxableIncome f)}.",
      "ITA 2(2); 111(1)(b); 110.6(2.1)"⟩,
    ⟨s!"The dividend tax credit, against tax, is {c (Dividends.credit (dividendFacts f))}.", "ITA 121"⟩], []⟩

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
    exact Nat.le_trans (CapitalGainsDeduction.deduction_le_annual _)
      (Nat.le_trans (Nat.sub_le _ _) (Nat.min_le_left _ _))

end Canteen.ITA.IndividualYear

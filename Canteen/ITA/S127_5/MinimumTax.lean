import Canteen.ITA.S3.IndividualYear

/-!
# The minimum tax (127.5 to 127.531)

*Income Tax Act*, as consolidated to 2026-10-29 (verbatim in `statute/ITA-127.5-minimum-tax.txt`):

* **127.5** where an individual's tax payable under Division E is less than the minimum amount, the
  tax payable is the minimum amount.
* **127.51** the minimum amount: 20.5% × (adjusted taxable income − the first dollar amount in
  117(2)(d)) − the basic minimum tax credit.
* **127.52(1)** adjusted taxable income: taxable income computed as if (d) capital gains and losses
  (and listed personal property gains) were included at 1/1, (d.1) gains on gifts of listed
  securities at 3/10, (f) dividends were not grossed up, (h)(ii) 7/5 of the capital gains deduction
  were deductible, and (i)(ii) net capital losses were deductible only as computed at the ordinary rate.
* **127.531** the basic minimum tax credit: ½ of the 118(1) credits (and the others in (a)), and 4/5
  of the donation credit.

Not encoded: the rental, film, tax shelter, partnership and resource adjustments ((b) to (c.3), (e),
(e.1)), (g), the other parts of (h), (j) (half of carrying charges and other deductions: Subdivision E
deductions and other Division C deductions are taken in full), the special foreign tax credit (127.54),
127.55, the carryforward of minimum tax paid (120.2), and the interaction with split income (120.4(3));
the minimum amount is computed for a year without split income. Allowable business investment losses
stay at ½ (38(c) is not read as 1/1). Amounts are rounded down to the cent.
-/

namespace Canteen.ITA.MinimumTax

open CapitalGains (HalfCents Disposition Year formatHalfCents)
open IndividualYear (Facts)

/-- (d), (d.1): a disposition's gain at 1/1 (3/10 for a gift of listed securities), in half-cents. -/
def gain (d : Disposition) : HalfCents :=
  if d.giftToQualifiedDonee then 6 * d.capitalGain / 10 else 2 * d.capitalGain

/-- 3(b), read with (d) and (d.1). -/
def paragraph3b (y : Year) : HalfCents :=
  (Year.sumBy y.nonListed gain + 2 * y.attribution.taxableCapitalGains + 2 * y.lppNetGain) -
    (2 * y.allowableCapitalLosses - y.allowableBusinessInvestmentLosses)

/-- (f): dividends included without the gross-up. -/
def dividends (f : Facts) : Cents :=
  let d := IndividualYear.dividendFacts f
  Dividends.paraA d + Dividends.paraA1 d + Dividends.paraCD d

/-- Income for the year, on the 127.52(1) assumptions, in half-cents. -/
def income (f : Facts) : HalfCents :=
  (2 * ((f.employmentAndBusiness + dividends f + IndividualYear.recapture f + IndividualYear.attributedIncome f) -
      IndividualYear.splitIncome f) + paragraph3b f.capital - 2 * f.subdivisionE) -
    (2 * (f.businessLosses + IndividualYear.terminalLosses f + IndividualYear.attributedLoss f) +
      f.capital.allowableBusinessInvestmentLosses)

/-- 127.52(1): adjusted taxable income, in half-cents: (h)(ii) 7/5 of the capital gains deduction,
and (i)(ii) the net capital loss deduction as computed at the ordinary rate. -/
def adjustedTaxableIncome (f : Facts) : HalfCents :=
  income f - IndividualYear.netCapitalLossDeduction f - 7 * IndividualYear.capitalGainsDeduction f / 5 -
    2 * f.otherDivisionC

/-- 127.531: the basic minimum tax credit. -/
def basicCredit (f : Facts) : Cents :=
  IndividualYear.personalCredit f / 2 + 4 * IndividualYear.donationCredit f / 5 + f.otherCredits / 2

/-- 127.51: the minimum amount. -/
def minimumAmount (f : Facts) : Cents :=
  2050 * (adjustedTaxableIncome f / 2 - f.brackets.third) / 10000 - basicCredit f

/-- 127.5: tax payable is the greater of the Division E amount and the minimum amount. -/
def taxPayable (f : Facts) : Cents := max (IndividualYear.federalTax f) (minimumAmount f)

/-- The minimum tax paid over the Division E amount (what 120.2 would carry forward). -/
def additional (f : Facts) : Cents := minimumAmount f - IndividualYear.federalTax f

def explain (f : Facts) : Finding :=
  let h := formatHalfCents
  let c := formatCents
  ⟨additional f > 0, [
    ⟨s!"Adjusted taxable income, with capital gains at 1/1 (3/10 on gifts of listed securities), dividends without " ++
      s!"the gross-up and 7/5 of the capital gains deduction: {h (adjustedTaxableIncome f)}.",
      "ITA 127.52(1)(d), (d.1), (f), (h), (i)"⟩,
    ⟨s!"20.5% of the amount over {c f.brackets.third}, less the basic minimum tax credit of {c (basicCredit f)}: " ++
      s!"a minimum amount of {c (minimumAmount f)}.", "ITA 127.51; 127.531"⟩,
    ⟨s!"Tax under Division E is {c (IndividualYear.federalTax f)}; tax payable is {c (taxPayable f)}.", "ITA 127.5"⟩], []⟩

/-! ## Truths about the minimum tax -/

/-- The minimum tax never lowers tax payable. -/
theorem regular_le (f : Facts) : IndividualYear.federalTax f ≤ taxPayable f := Nat.le_max_left _ _

/-- With adjusted taxable income within the exemption, the minimum tax does not apply. -/
theorem within_exemption (f : Facts) (h : adjustedTaxableIncome f / 2 ≤ f.brackets.third) :
    taxPayable f = IndividualYear.federalTax f := by
  have h0 : minimumAmount f = 0 := by
    unfold minimumAmount
    rw [Nat.sub_eq_zero_of_le h]; simp
  unfold taxPayable; rw [h0]; exact Nat.max_eq_left (Nat.zero_le _)

private theorem max_eq_add_sub (a b : Nat) : max a b = a + (b - a) := by omega

/-- Tax payable is the Division E amount plus the additional minimum tax. -/
theorem split (f : Facts) : taxPayable f = IndividualYear.federalTax f + additional f :=
  max_eq_add_sub _ _

end Canteen.ITA.MinimumTax

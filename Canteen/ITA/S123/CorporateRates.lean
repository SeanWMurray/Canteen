import Canteen.Core.Finding
import Canteen.Core.Money

/-!
# Corporate tax: 123(1), 124(1), 123.4(2) and 125(1)

*Income Tax Act*, as consolidated to 2026-10-29 (verbatim in `statute/ITA-123-125-corporate-rates.txt`):

* **123(1)** A corporation's tax is 38% of its amount taxable.
* **124(1)** Less 10% of its taxable income earned in the year in a province (the abatement).
* **123.4(2)** Less the general rate reduction percentage (13% for days after 2011) of its full rate
  taxable income: taxable income less, for a Canadian-controlled private corporation, the amount
  eligible for the small business deduction and its aggregate investment income, and less income from
  a personal services business.
* **125(1)** A corporation that was a Canadian-controlled private corporation throughout the year
  deducts its small business deduction rate (19% for days after 2018) times the least of (a) its
  income from an active business carried on in Canada, (b) its taxable income, and (c) its business
  limit ($500,000, nil if associated unless allocated, 125(2), (3)).

So, for a year after 2018: active business income of a CCPC within the business limit is taxed at 9%,
and other income (other than investment income of a CCPC, which 123.3 and Part IV treat separately)
at 15%. The business limit after the 125(5.1) grinds and any allocation is given; the (b)(i) to (iii)
reductions are nil. Each product is computed on the whole and rounded down once.
-/

namespace Canteen.ITA.CorporateRates

structure Facts where
  taxableIncome : Cents
  /-- 124(1): taxable income earned in the year in a province (all of it, by default). -/
  provincialIncome : Option Cents := none
  /-- A Canadian-controlled private corporation throughout the year. -/
  ccpc : Bool := true
  /-- 125(1)(a): income from an active business carried on in Canada. -/
  activeBusinessIncome : Cents := 0
  /-- 125(1)(c): the business limit, after 125(2) to (5.1). -/
  businessLimit : Cents := 50000000
  /-- 129(4) "aggregate investment income" (for a CCPC). -/
  aggregateInvestmentIncome : Cents := 0
  /-- Income from a personal services business. -/
  personalServicesIncome : Cents := 0
  deriving Repr, DecidableEq, Inhabited

/-- 125(1): the least of (a), (b) and (c). -/
def smallBusinessAmount (f : Facts) : Cents :=
  if f.ccpc then min f.activeBusinessIncome (min f.taxableIncome f.businessLimit) else 0

/-- 123.4(1) "full rate taxable income". -/
def fullRateTaxableIncome (f : Facts) : Cents :=
  f.taxableIncome - (f.personalServicesIncome + (if f.ccpc then smallBusinessAmount f + f.aggregateInvestmentIncome else 0))

/-- Part I tax: 38%, less the 10% abatement, the 19% small business deduction and the 13% general
rate reduction, in basis points of cents, rounded down once. -/
def tax (f : Facts) : Cents :=
  (3800 * f.taxableIncome - (1000 * f.provincialIncome.getD f.taxableIncome + 1900 * smallBusinessAmount f +
    1300 * fullRateTaxableIncome f)) / 10000

def explain (f : Facts) : Finding :=
  let c := formatCents
  ⟨tax f > 0, [
    ⟨s!"38% of taxable income of {c f.taxableIncome}, less the 10% abatement.", "ITA 123(1); 124(1)"⟩,
    ⟨s!"Less 19% of {c (smallBusinessAmount f)}, the least of active business income, taxable income and the business limit.",
      "ITA 125(1)"⟩,
    ⟨s!"Less 13% of full rate taxable income of {c (fullRateTaxableIncome f)}.", "ITA 123.4(2)"⟩,
    ⟨s!"Tax: {c (tax f)}.", "ITA 123–125"⟩], []⟩

/-! ## Truths about corporate rates -/

private theorem nine (n : Nat) : (3800 * (100 * n) - (1000 * (100 * n) + 1900 * (100 * n) + 1300 * 0)) / 10000 = 9 * n := by
  have : 3800 * (100 * n) - (1000 * (100 * n) + 1900 * (100 * n) + 1300 * 0) = 10000 * (9 * n) := by omega
  rw [this, Nat.mul_div_cancel_left _ (by decide)]

/-- **9%.** A CCPC whose taxable income is all active business income within the business limit pays 9%. -/
theorem small_business_rate (n : Nat) (h : 100 * n ≤ 50000000) :
    tax { taxableIncome := 100 * n, activeBusinessIncome := 100 * n } = 9 * n := by
  have hm : min (100 * n) (min (100 * n) 50000000) = 100 * n := by simp [Nat.min_eq_left h]
  have hf : (100 * n) - (0 + (100 * n + 0)) = 0 := by omega
  simp only [tax, smallBusinessAmount, fullRateTaxableIncome, ite_true, Option.getD_none, hm, hf]
  exact nine n

private theorem fifteen (n : Nat) : (3800 * (100 * n) - (1000 * (100 * n) + 1900 * 0 + 1300 * (100 * n))) / 10000 = 15 * n := by
  have : 3800 * (100 * n) - (1000 * (100 * n) + 1900 * 0 + 1300 * (100 * n)) = 10000 * (15 * n) := by omega
  rw [this, Nat.mul_div_cancel_left _ (by decide)]

/-- **15%.** A corporation that is not a CCPC pays 15% on its taxable income. -/
theorem general_rate (n : Nat) : tax { taxableIncome := 100 * n, ccpc := false } = 15 * n := by
  simp only [tax, smallBusinessAmount, fullRateTaxableIncome, Bool.false_eq_true, ite_false, Option.getD_none, Nat.add_zero,
    Nat.sub_zero]
  exact fifteen n

end Canteen.ITA.CorporateRates

import Canteen.Core.Money

/-!
# Part I.2: the Old Age Security recovery tax (180.2), and its deduction (60(w))

*Income Tax Act*, as consolidated to 2026-10-29 (verbatim in `statute/ITA-180.2-60-w.txt`):

* **180.2(1)** "adjusted income": income under Part I, without (among others) the 60(w) deduction.
* **180.2(2)** the tax: A(1 − B), A the lesser of (a) the Old Age Security benefits included in income
  (less any 60(n)(i) repayment) and (b) 15% of adjusted income over $50,000 (indexed); B the Part XIII
  rate on them (nil for a resident).
* **60(w)** the Part I.2 tax is deducted in computing income under Part I.

The threshold defaults to its 2025 indexed value, $93,454. Not encoded: the other 180.2(1)
adjustments (56(1)(q.1), 56(6), section 79, 40(3.21), 20(1)(ww), 60(y), (z)), 60(n)(i), the Part XIII
rate, and withholding (180.2(3) to (6)). Rounded down to the cent.
-/

namespace Canteen.ITA.OasRecovery

/-- 180.2(2): the Part I.2 tax, for a resident. -/
def tax (oas adjustedIncome : Cents) (threshold : Cents := 9345400) : Cents :=
  min oas ((adjustedIncome - threshold) * 15 / 100)

/-- Never more than the benefits. -/
theorem tax_le_oas (oas a t : Cents) : tax oas a t ≤ oas := Nat.min_le_left _ _

/-- Nothing at or below the threshold. -/
theorem below_threshold (oas a t : Cents) (h : a ≤ t) : tax oas a t = 0 := by
  unfold tax; rw [Nat.sub_eq_zero_of_le h]; simp

end Canteen.ITA.OasRecovery

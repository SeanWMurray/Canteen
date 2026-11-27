import Canteen.Core.Money
import Canteen.Core.Finding

/-!
# Paragraph 110.1(1)(a): a corporation's charitable gifts

*Income Tax Act*, as consolidated to 2026-10-29 (verbatim in `statute/ITA-110.1-1-a.txt`):

**110.1(1)(a)** In computing taxable income, a corporation deducts the eligible amounts of its gifts to
qualified donees made in the year or the five preceding years, up to the lesser of its income for the
year and 0.75A + 0.25(B + C + D): A its income for the year; B the taxable capital gains on gifts of
property made in the year (in proportion to the eligible amount over the proceeds); C taxable capital
gains for the year under 40(1.01) on earlier dispositions; D recapture on gifts of depreciable property
of the year, up to the gain over capital cost (in the same proportion).

B, C and D are given. Gifts are used oldest first, so the earliest expire last; what is unused carries
forward, a gift no more than five years. Not encoded: 110.1(1)(b) to (d) (Crown, cultural and
ecological gifts), 110.1(1.1) (the acquisition of control rule), 110.1(2.1), (3) and (6).
-/

namespace Canteen.ITA.CorporateDonations

structure Gift where
  /-- The taxation year (as a calendar year) in which it was made. -/
  year : Nat
  /-- Its eligible amount, less any part deducted in an earlier year. -/
  unused : Cents
  deriving Repr, DecidableEq, Inhabited

structure Facts where
  taxationYear : Nat
  /-- A: income for the year. -/
  income : Cents
  /-- B, C, D, in taxable (or recaptured) amounts. -/
  giftGains : Cents := 0
  gains40_1_01 : Cents := 0
  giftRecapture : Cents := 0
  gifts : List Gift
  deriving Repr, DecidableEq, Inhabited

/-- Gifts of the year and the five preceding years. -/
def available (f : Facts) : List Gift :=
  f.gifts.filter fun g => g.year ≤ f.taxationYear && f.taxationYear ≤ g.year + 5

def availableTotal (f : Facts) : Cents := ((available f).map (·.unused)).sum

/-- The limit: the lesser of income and 0.75A + 0.25(B + C + D). -/
def limit (f : Facts) : Cents :=
  min f.income ((75 * f.income + 25 * (f.giftGains + f.gains40_1_01 + f.giftRecapture)) / 100)

/-- 110.1(1)(a): the deduction. -/
def deduction (f : Facts) : Cents := min (availableTotal f) (limit f)

/-- What carries forward: the available gifts not deducted (those over five years old expire). -/
def carriedForward (f : Facts) : Cents := availableTotal f - deduction f

def explain (f : Facts) : Finding :=
  let c := formatCents
  ⟨deduction f > 0, [
    ⟨s!"Gifts of the year and the five before: {c (availableTotal f)}. The limit is the lesser of income, {c f.income}, " ++
      s!"and 75% of it plus 25% of the gains on gifts, {c (limit f)}.", "ITA 110.1(1)(a)"⟩,
    ⟨s!"{c (deduction f)} is deducted; {c (carriedForward f)} carries forward.", "ITA 110.1(1)(a)"⟩], []⟩

/-! ## Truths -/

/-- Never more than the corporation's income. -/
theorem deduction_le_income (f : Facts) : deduction f ≤ f.income :=
  Nat.le_trans (Nat.min_le_right _ _) (Nat.min_le_left _ _)

/-- Without gains on gifts, never more than 75% of income. -/
theorem three_quarters (f : Facts) (h : f.giftGains + f.gains40_1_01 + f.giftRecapture = 0) :
    deduction f ≤ 75 * f.income / 100 := by
  have h1 : deduction f ≤ limit f := Nat.min_le_right _ _
  have h2 : limit f ≤ 75 * f.income / 100 := by
    unfold limit; rw [h, Nat.mul_zero, Nat.add_zero]; exact Nat.min_le_right _ _
  exact Nat.le_trans h1 h2

/-- What is deducted and what carries forward make up the gifts available. -/
theorem deducted_plus_carried (f : Facts) : deduction f + carriedForward f = availableTotal f :=
  Nat.add_sub_cancel' (Nat.min_le_left _ _)

end Canteen.ITA.CorporateDonations

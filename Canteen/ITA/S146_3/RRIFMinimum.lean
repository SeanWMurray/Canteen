import Canteen.Core.Money
import Canteen.Core.Finding

/-!
# The RRIF minimum amount: 146.3(1) "minimum amount", and Regulation 7308(3), (4)

*Income Tax Act*, as consolidated to 2026-10-29 (verbatim in `statute/ITA-146.3-1-minimum-amount.txt`),
and the *Income Tax Regulations* (verbatim in `statute/ITR-7308-3-4.txt`):

**146.3(1) "minimum amount"**: nil for the year the fund is entered into; otherwise A × B + C, A the fair
market value of the fund's property at the beginning of the year, B the prescribed factor for the
annuitant (or, by election, the spouse), C an adjustment for certain annuity contracts. **Reg. 7308(4)**
The factor for age Y at the beginning of the year: under 71, 1/(90 − Y); 71, 0.0528; rising to 0.2000 at
95 or older. **7308(3)**: for a fund that was a qualifying RRIF (one existing before 1993) at the beginning
of the year, 1/(90 − X) under 72 and the same factors from 72.

The age (the annuitant's, or the spouse's where elected) and the value are given; C is nil (no annuity
contracts held by the fund). Withholding (153(1)(l)) on amounts over the minimum is not encoded.
-/

namespace Canteen.ITA.RRIFMinimum

/-- Reg. 7308(3), (4): the factor from 71 (or 72), in ten-thousandths. -/
def tableFactor (age : Nat) : Nat :=
  match age with
  | 71 => 528 | 72 => 540 | 73 => 553 | 74 => 567 | 75 => 582 | 76 => 598 | 77 => 617 | 78 => 636
  | 79 => 658 | 80 => 682 | 81 => 708 | 82 => 738 | 83 => 771 | 84 => 808 | 85 => 851 | 86 => 899
  | 87 => 955 | 88 => 1021 | 89 => 1099 | 90 => 1192 | 91 => 1306 | 92 => 1449 | 93 => 1634 | 94 => 1879
  | _ => 2000

structure Facts where
  /-- A: the fair market value at the beginning of the year. -/
  value : Cents
  /-- The age at the beginning of the year (of the annuitant, or the spouse if so elected). -/
  age : Nat
  /-- The year the fund was entered into: nil. -/
  firstYear : Bool := false
  /-- Reg. 7308(3): a qualifying retirement income fund at the beginning of the year. -/
  qualifying : Bool := false
  deriving Repr, DecidableEq, Inhabited

/-- The age from which the table applies. -/
def tableFrom (f : Facts) : Nat := if f.qualifying then 72 else 71

/-- The minimum amount for the year. -/
def minimum (f : Facts) : Cents :=
  if f.firstYear then 0
  else if f.age < tableFrom f then f.value / (90 - f.age)
  else f.value * tableFactor f.age / 10000

def explain (f : Facts) : Finding :=
  let c := formatCents
  ⟨minimum f > 0, [
    if f.firstYear then ⟨"The year the fund was entered into: the minimum amount is nil.", "ITA 146.3(1) \"minimum amount\""⟩
    else if f.age < tableFrom f then ⟨s!"Age {f.age}: the factor is 1/(90 − {f.age}); the minimum is {c (minimum f)} of {c f.value}.",
      "ITA 146.3(1) \"minimum amount\"; ITR 7308(4)"⟩
    else ⟨s!"Age {f.age}: the prescribed factor is {tableFactor f.age} ten-thousandths; the minimum is {c (minimum f)} of {c f.value}.",
      if f.qualifying then "ITA 146.3(1) \"minimum amount\"; ITR 7308(3)" else "ITA 146.3(1) \"minimum amount\"; ITR 7308(4)"⟩], []⟩

/-! ## Truths -/

theorem tableFactor_le (age : Nat) : tableFactor age ≤ 2000 := by
  unfold tableFactor; split <;> decide

private theorem fifth_of_table (v t : Nat) (h : t ≤ 2000) : v * t / 10000 ≤ v / 5 :=
  Nat.le_trans (Nat.div_le_div_right (Nat.mul_le_mul_left _ h)) (by omega)

/-- Never more than a fifth of the fund. -/
theorem minimum_le (f : Facts) : minimum f ≤ f.value / 5 := by
  have h72 : tableFrom f ≤ 72 := by unfold tableFrom; split <;> decide
  unfold minimum
  by_cases h0 : f.firstYear = true
  · simp [h0]
  · by_cases ha : f.age < tableFrom f
    · have h1 : 5 ≤ 90 - f.age := by omega
      simp only [h0, ha, ite_false, ite_true, Bool.false_eq_true]
      exact Nat.div_le_div_left h1 (by decide)
    · simp only [h0, ha, ite_false, Bool.false_eq_true]
      exact fifth_of_table _ _ (tableFactor_le _)

end Canteen.ITA.RRIFMinimum

import Canteen.Core.Money
import Canteen.Core.Finding

/-!
# Capital cost allowance: Regulation 1100(1)(a) rates, and the 1100(2) half-year rule and AIIP

*Income Tax Regulations*, as consolidated to 2026-10-29 (verbatim in `statute/ITR-1100-1-a-2.txt`):

**1100(1)(a)** A taxpayer may claim, for property of each class in Schedule II, up to the class's rate of
the undepreciated capital cost at the end of the year: Class 1, 4%; 8, 20%; 10 and 10.1, 30%; 12, 100%;
14.1, 5%; 17, 8%; 43, 30%; 45, 45%; 50, 55%; 53, 50%; 54, 30% and the others listed.

**1100(2)** The UCC (before the year's claim) is adjusted by A(B) + A.1(B.1) − 0.5(C): C (= F − G) the
additions of the year other than accelerated investment incentive property (AIIP), less the year's
dispositions (the half-year rule); B (= D − E) the AIIP that became available for use in the year, less
any excess of dispositions over the other additions; A, for property of the general classes, 1/2 if it
became available for use before 2024 and nil after 2023.

The rates are for the classes listed here; A for the classes with their own factor (43.1, 43.2, 44, 46, 50
after April 15, 2024, 53, 54 to 56, the 1100(1)(v) and Class 43 cases) is given, not computed; A.1 and B.1, the excluded classes in C(b), short taxation years (1100(3))
and the 13(7) rules for automobiles and change of use are not encoded. Whether property is AIIP
(1104(4)) and the year it became available for use (13(26) to (32)) are facts.
-/

namespace Canteen.ITA.CapitalCostAllowance

/-- Reg. 1100(1)(a): the rate for a class, in tenths of a percent. -/
def rate : String → Option Nat
  | "1" => some 40 | "2" => some 60 | "3" => some 50 | "4" => some 60 | "5" => some 100 | "6" => some 100
  | "7" => some 150 | "8" => some 200 | "9" => some 250 | "10" => some 300 | "10.1" => some 300 | "11" => some 350
  | "12" => some 1000 | "14.1" => some 50 | "16" => some 400 | "17" => some 80 | "18" => some 600 | "22" => some 500
  | "23" => some 1000 | "25" => some 1000 | "26" => some 50 | "28" => some 300 | "30" => some 400 | "31" => some 50
  | "32" => some 100 | "33" => some 150 | "35" => some 70 | "37" => some 150 | "41" => some 250 | "42" => some 120
  | "43" => some 300 | "43.1" => some 300 | "43.2" => some 500 | "44" => some 250 | "45" => some 450 | "46" => some 300
  | "47" => some 80 | "48" => some 150 | "49" => some 80 | "50" => some 550 | "51" => some 60 | "52" => some 1000
  | "53" => some 500 | "54" => some 300
  | _ => none

structure ClassYear where
  cls : String
  /-- The UCC at the end of the year before the 1100(2) adjustment and the year's claim. -/
  ucc : Cents
  /-- F: the year's additions (element A) other than AIIP. -/
  additions : Cents := 0
  /-- D: AIIP that became available for use in the year. -/
  aiip : Cents := 0
  /-- G: the year's deductions for dispositions (element F of 13(21)). -/
  dispositions : Cents := 0
  /-- The year the AIIP became available for use (for A). -/
  availableYear : Nat := 2025
  /-- A as a fraction, for a class with its own factor (1100(2) A(b) to (c.5): Classes 43.1, 43.2, 44, 46, 50
  for property acquired after April 15, 2024, 53, 54 to 56 and the others); if not given, the general
  classes' A(a). -/
  aFactor : Option (Nat × Nat) := none
  deriving Repr, DecidableEq, Inhabited

/-- C: the half-year rule's net additions. -/
def ClassYear.c (y : ClassYear) : Cents := y.additions - y.dispositions
/-- B: the AIIP less the excess of dispositions over other additions. -/
def ClassYear.b (y : ClassYear) : Cents := y.aiip - (y.dispositions - y.additions)

/-- A: as given for a class with its own factor, or for the general classes (A(a)) 1/2 before 2024 and
nil after 2023. -/
def ClassYear.a (y : ClassYear) : Nat × Nat := y.aFactor.getD (if y.availableYear < 2024 then (1, 2) else (0, 1))

/-- A(B). -/
def ClassYear.enhancement (y : ClassYear) : Cents := y.b * y.a.1 / max y.a.2 1

/-- The UCC as adjusted by 1100(2). -/
def ClassYear.adjusted (y : ClassYear) : Cents := (y.ucc + y.enhancement) - y.c / 2

/-- 1100(1)(a): the most that may be claimed. -/
def ClassYear.maximum (y : ClassYear) : Cents := y.adjusted * (rate y.cls).getD 0 / 1000

/-- The UCC after claiming the maximum. -/
def ClassYear.closing (y : ClassYear) (claim : Cents) : Cents := y.ucc - min claim y.maximum

def explain (y : ClassYear) : Finding :=
  let c := formatCents
  ⟨y.maximum > 0, [
    ⟨s!"Class {y.cls}: UCC before the claim {c y.ucc}; less half the net additions ({c y.c})" ++
      (if y.enhancement > 0 then s!", plus {y.a.1}/{y.a.2} of the accelerated investment incentive property ({c y.enhancement})" else "") ++
      s!": {c y.adjusted}.", "ITR 1100(2)"⟩,
    ⟨s!"At the class rate, the most that may be claimed is {c y.maximum}.", "ITR 1100(1)(a)"⟩], []⟩

/-! ## Truths -/

/-- The half-year rule: an addition in a year with nothing else claims at half the rate. -/
theorem half_year (cls : String) (x : Cents) (r : Nat) (h : rate cls = some r) :
    ({ cls, ucc := x, additions := x } : ClassYear).maximum = (x - x / 2) * r / 1000 := by
  simp [ClassYear.maximum, ClassYear.adjusted, ClassYear.c, ClassYear.b, ClassYear.enhancement, ClassYear.a, h]

/-- Never more than the UCC itself, for rates of 100% or less. -/
theorem maximum_le (y : ClassYear) (h : (rate y.cls).getD 0 ≤ 1000) : y.maximum ≤ y.adjusted :=
  Nat.le_trans (Nat.div_le_div_right (Nat.mul_le_mul_left _ h)) (Nat.le_of_eq (Nat.mul_div_cancel _ (by decide)))

end Canteen.ITA.CapitalCostAllowance

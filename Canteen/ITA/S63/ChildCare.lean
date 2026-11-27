import Canteen.Core.Money
import Canteen.Core.Finding

/-!
# Section 63: child care expenses

*Income Tax Act*, as consolidated to 2026-10-29 (verbatim in `statute/ITA-63.txt`):

* **63(1)** a taxpayer may deduct child care expenses paid for services in the year for an eligible child
  (receipted, not claimed by another, not reimbursed), up to (e) the lesser of 2/3 of earned income and
  the total of the annual child care expense amounts, less (f) what a higher-income supporting person
  deducted for the same children under 63(2).
* **63(2)** where the taxpayer's income exceeds that of a supporting person of the child (both computed
  without section 63 and 60(v.1) and (w)), the deduction is limited to the total periodic child care
  expense amounts times C: the weeks the supporting person was a student (full-time), incapable of caring
  for children because of infirmity, in prison, or separated, plus the months as a part-time student.
* **63(3)** "annual child care expense amount": $11,000 for a child eligible for the disability credit,
  $8,000 for a child under 7 at the end of the year, $5,000 otherwise; "periodic": 1/40 of it; "eligible
  child": a child of the taxpayer or spouse (or dependent on them, with income no more than 118(1.1) F),
  under 16 at any time in the year or dependent because of infirmity; "earned income": employment income,
  business income and the like.

The expenses that qualify (child care expenses as defined in 63(3), the receipts, the 63(1)(c) and (d)
exclusions) are facts: the qualifying amount paid is given. The amounts are not indexed. Not encoded:
63(2.2) to (2.3) (students' claims), 63(3) "child care expense" exclusions, 64.
-/

namespace Canteen.ITA.ChildCare

structure Child where
  /-- Age at the end of the year. -/
  age : Nat
  /-- (a): a person for whom the 118.3 disability amount may be deducted. -/
  disability : Bool := false
  /-- "eligible child" (d): dependent on the taxpayer or spouse, with a mental or physical infirmity. -/
  infirmDependant : Bool := false
  deriving Repr, DecidableEq, Inhabited

/-- "eligible child": under 16 at any time in the year (16 or younger at its end), or dependent and infirm. -/
def Child.eligible (c : Child) : Bool := c.age ≤ 16 || c.infirmDependant

/-- "annual child care expense amount". -/
def Child.annual (c : Child) : Cents :=
  if !c.eligible then 0 else if c.disability then 1100000 else if c.age < 7 then 800000 else 500000

structure Facts where
  /-- Qualifying child care expenses paid for services in the year. -/
  paid : Cents
  children : List Child
  /-- The taxpayer's earned income for the year. -/
  earnedIncome : Cents
  /-- (f): deducted for these children by a higher-income supporting person under 63(2). -/
  deductedByOther : Cents := 0
  /-- 63(2): the taxpayer's income exceeds a supporting person's (both without 63, 60(v.1) and (w)). -/
  higherIncome : Bool := false
  /-- 63(2) C (i): weeks the supporting person was a full-time student, incapacitated, in prison or separated. -/
  weeks : Nat := 0
  /-- C (ii): other months the supporting person was a part-time student. -/
  months : Nat := 0
  deriving Repr, DecidableEq, Inhabited

def annualTotal (f : Facts) : Cents := (f.children.map Child.annual).sum

/-- 63(1)(e), (f). -/
def limit (f : Facts) : Cents := min (f.earnedIncome * 2 / 3) (annualTotal f) - f.deductedByOther

/-- 63(2)(b): A × C, A the periodic amounts (1/40 of the annual). -/
def higherIncomeLimit (f : Facts) : Cents := annualTotal f * (f.weeks + f.months) / 40

/-- The deduction. -/
def deduction (f : Facts) : Cents :=
  let d := min f.paid (limit f)
  if f.higherIncome then min d (higherIncomeLimit f) else d

def explain (f : Facts) : Finding :=
  let c := formatCents
  ⟨deduction f > 0, [
    ⟨s!"The annual child care expense amounts for the eligible children total {c (annualTotal f)}; two-thirds of earned income " ++
      s!"is {c (f.earnedIncome * 2 / 3)}.", "ITA 63(1)(e); 63(3)"⟩] ++
    (if f.higherIncome then
      [⟨s!"The taxpayer has the higher income: the deduction is limited to 1/40 of those amounts for each of {f.weeks + f.months} " ++
        s!"weeks and months, {c (higherIncomeLimit f)}.", "ITA 63(2)"⟩] else []) ++
    [⟨s!"Of {c f.paid} paid, {c (deduction f)} is deductible.", "ITA 63(1)"⟩], []⟩

/-! ## Truths -/

/-- Never more than what was paid, nor more than two-thirds of earned income. -/
theorem deduction_le (f : Facts) : deduction f ≤ f.paid ∧ deduction f ≤ f.earnedIncome * 2 / 3 := by
  have h1 : min f.paid (limit f) ≤ f.paid := Nat.min_le_left _ _
  have h2 : min f.paid (limit f) ≤ f.earnedIncome * 2 / 3 :=
    Nat.le_trans (Nat.min_le_right _ _) (Nat.le_trans (Nat.sub_le _ _) (Nat.min_le_left _ _))
  unfold deduction; simp only
  split
  · exact ⟨Nat.le_trans (Nat.min_le_left _ _) h1, Nat.le_trans (Nat.min_le_left _ _) h2⟩
  · exact ⟨h1, h2⟩

/-- The higher-income spouse deducts nothing while the other is at home: no weeks, no months. -/
theorem higher_income_nil (f : Facts) (h : f.higherIncome = true) (hw : f.weeks = 0) (hm : f.months = 0) : deduction f = 0 := by
  simp [deduction, higherIncomeLimit, h, hw, hm]

end Canteen.ITA.ChildCare

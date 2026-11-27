import Canteen.Core.StatuteSyntax
import Canteen.Core.Money

/-!
# Subsection 62(1): moving expenses, and "eligible relocation" (248(1))

*Income Tax Act*, as consolidated to 2026-10-29 (verbatim in `statute/ITA-62-1-248-eligible-relocation.txt`):

* **248(1) "eligible relocation"** a relocation (a) to enable the taxpayer to work or carry on business at
  a new work location in Canada, or to be a full-time post-secondary student there, (b) from an old residence
  to a new residence, each ordinarily resided in, (c) both in Canada (unless the taxpayer is absent from but
  resident in Canada), and (d) where the old residence is at least 40 km farther from the new work location
  than the new residence is.
* **62(1)** moving expenses paid in respect of an eligible relocation are deducted, to the extent that (a)
  they were not paid on the taxpayer's behalf by an employer, (b) they were not deductible in the preceding
  year, (c) they do not exceed the income for the year from the employment or business at the new work
  location (for a student, the scholarships and research grants included under 56(1)(n) and (o)), and (d)
  any reimbursements and allowances are included in income.

Expenses not deductible in a year because of (c) may be deducted in the next (read with (b)). Which
expenses are moving expenses (62(3)) is a fact: the amount paid is given. Distances are in whole
kilometres, by the shortest normal route (Giannakopoulos). Not encoded: 62(2) (moving out of Canada), 62(3).
-/

namespace Canteen.ITA.MovingExpenses

structure Facts where
  /-- (a): to work or carry on business at the new work location (`false`: to study there full time). -/
  toWork : Bool := true
  /-- (b): ordinarily resided at the old residence before, and at the new residence after. -/
  ordinarilyResided : Bool := true
  /-- (a), (c): the new work location and both residences are in Canada (or the taxpayer is absent from but resident in Canada). -/
  inCanada : Bool := true
  /-- (d): distances to the new work location, in kilometres. -/
  oldResidenceKm : Nat
  newResidenceKm : Nat
  /-- Moving expenses paid in the year, not paid by an employer on the taxpayer's behalf (62(1)(a)). -/
  paid : Cents
  /-- Moving expenses paid earlier, for this relocation, not yet deducted. -/
  carried : Cents := 0
  /-- 62(1)(c): income for the year from the new work location (or, for a student, 56(1)(n), (o) amounts). -/
  limitIncome : Cents
  /-- 62(1)(d): reimbursements and allowances received are included in income. -/
  reimbursementsIncluded : Bool := true
  deriving Repr, DecidableEq, Inhabited

/-- 248(1) "eligible relocation". -/
statute eligible (f : Facts) named "\"eligible relocation\" (248(1))" cites "ITA 248(1) \"eligible relocation\""
  applies where
    | (b) f.ordinarilyResided
        => "The taxpayer ordinarily resided at the old residence before the move and at the new residence after."
        else "The taxpayer did not ordinarily reside at both the old and the new residence."
    | "(a), (c)" f.inCanada
        => "The new work location and both residences are in Canada."
        else "The new work location or a residence is outside Canada."
    | (d) decide (f.newResidenceKm + 40 ≤ f.oldResidenceKm)
        => "The old residence is at least 40 km farther from the new work location than the new residence is."
        else "The move does not bring the taxpayer at least 40 km closer to the new work location."

/-- 62(1): the deduction for the year. -/
def deduction (f : Facts) : Cents :=
  if eligible.holds f && f.reimbursementsIncluded then min (f.paid + f.carried) f.limitIncome else 0

/-- What carries to the next year. -/
def unused (f : Facts) : Cents := if eligible.holds f && f.reimbursementsIncluded then f.paid + f.carried - deduction f else 0

def explain (f : Facts) : Finding :=
  let e := eligible.explain f
  let c := formatCents
  ⟨e.conclusion, e.steps ++
    (if eligible.holds f then
      [⟨s!"Moving expenses of {c (f.paid + f.carried)}, up to the {c f.limitIncome} of income " ++
        (if f.toWork then "from the new work location" else "from scholarships and research grants") ++
        s!": {c (deduction f)} deducted, {c (unused f)} carried to the next year.", "ITA 62(1)"⟩] else []), []⟩

/-! ## Truths -/

/-- Never more than the income at the new location, nor than what was paid. -/
theorem deduction_le (f : Facts) : deduction f ≤ f.limitIncome ∧ deduction f ≤ f.paid + f.carried := by
  unfold deduction; split
  · exact ⟨Nat.min_le_right _ _, Nat.min_le_left _ _⟩
  · exact ⟨Nat.zero_le _, Nat.zero_le _⟩

/-- What is deducted and what is carried add up to what was paid (for an eligible relocation). -/
private theorem add_sub_min (a b : Nat) : min a b + (a - min a b) = a := Nat.add_sub_cancel' (Nat.min_le_left _ _)

theorem deducted_plus_unused (f : Facts) (h : (eligible.holds f && f.reimbursementsIncluded) = true) :
    deduction f + unused f = f.paid + f.carried := by
  simp only [deduction, unused, h, ite_true]; exact add_sub_min _ _

end Canteen.ITA.MovingExpenses

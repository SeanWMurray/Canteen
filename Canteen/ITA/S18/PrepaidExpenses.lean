import Canteen.Core.Money
import Canteen.Core.Finding
import Canteen.Core.Date

/-!
# Subsection 18(9): prepaid expenses

*Income Tax Act*, as consolidated to 2026-10-29 (verbatim in `statute/ITA-18-9.txt`):

**18(9)(a)** In computing income from a business or property (other than on the 28(1) cash method), no
deduction for an outlay or expense to the extent it can reasonably be regarded as made (i) for services
to be rendered after the end of the year, (ii) for interest, taxes, rent or royalties for a period after
the end of the year, (iii) for insurance for a period after the end of the year, or (iv) for a designated
employee benefit to be provided after the end of the year. **(b)** The part that would otherwise have
been deductible is deductible in the later year to which it can reasonably be considered to relate,
except interest prepaid by a corporation, partnership or trust.

An outlay is allocated to the days of the period it covers, and each taxation year deducts the share of
its days, rounded down. The exceptions within (a)(ii) and (iii) for insurers and group term life
insurance, (iv)'s designated employee benefits, and (c) to (e) are not encoded; neither is 20(1)(c)
for interest that (b) does not carry.
-/

namespace Canteen.ITA.PrepaidExpenses

inductive Kind where
  | services
  | interest
  | taxes
  | rent
  | royalties
  | insurance
  deriving Repr, DecidableEq, Inhabited

structure Outlay where
  description : String
  kind : Kind
  amount : Cents
  /-- The period it is for, first and last days. -/
  periodStart : Date
  periodEnd : Date
  deriving Repr, DecidableEq, Inhabited

/-- A taxation year, first and last days. -/
structure TaxYear where
  start : Date
  finish : Date
  deriving Repr, DecidableEq, Inhabited

def Outlay.days (o : Outlay) : Nat := o.periodEnd.toDays + 1 - o.periodStart.toDays

/-- The days of the outlay's period within the taxation year. -/
def Outlay.overlap (o : Outlay) (y : TaxYear) : Nat :=
  min o.periodEnd.toDays y.finish.toDays + 1 - max o.periodStart.toDays y.start.toDays

/-- The part that relates to the taxation year. -/
def Outlay.share (o : Outlay) (y : TaxYear) : Cents := if o.days = 0 then 0 else o.amount * min (o.overlap y) o.days / o.days

/-- The part for the days of the period up to the end of the taxation year. -/
def Outlay.upTo (o : Outlay) (y : TaxYear) : Cents :=
  if o.days = 0 then 0 else o.amount * min (min o.periodEnd.toDays y.finish.toDays + 1 - o.periodStart.toDays) o.days / o.days

/-- 18(9)(a), (b): deductible in the year, for an outlay made in `paidIn`. In the year paid, the share of
that year and of any earlier days of the period; later, the year's share (for interest of a
corporation, partnership or trust, nothing under (b)). -/
def Outlay.deduction (o : Outlay) (paidIn y : TaxYear) (entity : Bool) : Cents :=
  if y == paidIn then o.upTo y
  else if y.start.toDays > paidIn.finish.toDays then
    (if entity && o.kind == .interest then 0 else o.share y)
  else 0

structure Facts where
  year : TaxYear
  /-- The taxpayer is a corporation, partnership or trust (for prepaid interest under (b)). -/
  entity : Bool := true
  /-- Outlays, each with the taxation year it was paid in. -/
  outlays : List (Outlay × TaxYear) := []
  deriving Repr, DecidableEq, Inhabited

def deduction (f : Facts) : Cents := (f.outlays.map fun (o, p) => o.deduction p f.year f.entity).sum

def explain (f : Facts) : Finding :=
  let c := formatCents
  let steps : List Step := f.outlays.map fun (o, p) =>
    ⟨s!"{o.description}: {c o.amount} for {o.days} days from {o.periodStart}; {min (o.overlap f.year) o.days} of them in the year: " ++
      s!"{c (o.deduction p f.year f.entity)} deducted now.", if f.year == p then "ITA 18(9)(a)" else "ITA 18(9)(b)"⟩
  ⟨deduction f > 0, steps ++ [⟨s!"Prepaid expenses deducted in the year: {c (deduction f)}.", "ITA 18(9)"⟩], []⟩

/-! ## Truths -/

theorem Outlay.share_le (o : Outlay) (y : TaxYear) : o.share y ≤ o.amount := by
  unfold Outlay.share; split
  · exact Nat.zero_le _
  · rename_i h
    calc o.amount * min (o.overlap y) o.days / o.days ≤ o.amount * o.days / o.days :=
          Nat.div_le_div_right (Nat.mul_le_mul_left _ (Nat.min_le_right _ _))
      _ = o.amount := Nat.mul_div_cancel _ (Nat.pos_of_ne_zero h)

/-- A period entirely within the year: all of it. -/
theorem Outlay.within (o : Outlay) (y : TaxYear) (h1 : y.start.toDays ≤ o.periodStart.toDays) (h2 : o.periodEnd.toDays ≤ y.finish.toDays)
    (h3 : o.periodStart.toDays ≤ o.periodEnd.toDays) : o.share y = o.amount := by
  have hd : o.days ≠ 0 := by unfold Outlay.days; omega
  have ho : o.overlap y = o.days := by
    unfold Outlay.overlap Outlay.days
    rw [Nat.min_eq_left h2, Nat.max_eq_left h1]
  simp only [Outlay.share, hd, ite_false, ho, Nat.min_self]
  exact Nat.mul_div_cancel _ (Nat.pos_of_ne_zero hd)

end Canteen.ITA.PrepaidExpenses

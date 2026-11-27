import Canteen.Core.Money
import Canteen.Core.Finding

/-!
# Paragraph 6(1)(e) and subsection 6(2): the automobile standby charge

*Income Tax Act*, as consolidated to 2026-10-29 (verbatim in `statute/ITA-6-1-e-6-2.txt`):

* **6(1)(e)** an employee includes a reasonable standby charge for an automobile the employer makes
  available, less what the employee pays the employer for its use (other than operating expenses).
* **6(2)** the reasonable standby charge is A/B × [2% × (C × D) + 2/3 × (E − F)]: B 1,667 km times the
  total available days over 30; A the personal kilometres if less than B, where the employee must use the
  car for work and drives it primarily for work, and B otherwise; C the employer's cost of an owned car,
  D the days it was owned over 30; E the lease payments for the days leased, F the insurance in them.
  Days over 30 are rounded to the nearest whole number (half down) only if more than one and not whole.

The charge is computed exactly, as a fraction, and rounded down to the cent once. The facts (cost, lease
payments, kilometres, days) are given. Not encoded: 6(1)(k) (the operating cost benefit, at a prescribed
rate), 6(2.1) (automobile salespersons), and the definition of "automobile".
-/

namespace Canteen.ITA.StandbyCharge

structure Facts where
  /-- The total available days in the year. -/
  availableDays : Nat
  /-- C, D: the employer's cost of the automobile, and the available days on which the employer owned it. -/
  cost : Cents := 0
  ownedDays : Nat := 0
  /-- E, F: lease payments for the available days leased, and the insurance included in them. -/
  leasePayments : Cents := 0
  leaseInsurance : Cents := 0
  /-- A (a): required to use it for work, and the kilometres driven primarily for work. -/
  requiredForWork : Bool := false
  primarilyForWork : Bool := false
  personalKm : Nat := 0
  /-- 6(1)(e)(ii): paid by the employee to the employer for its use (not operating expenses). -/
  employeePaid : Cents := 0
  deriving Repr, DecidableEq, Inhabited

/-- Days over 30, as a fraction (numerator, denominator): rounded to the nearest whole number (half
down) if more than one and not whole. -/
def months (days : Nat) : Nat × Nat :=
  if days ≤ 30 then (days, 30)
  else (days / 30 + (if days % 30 > 15 then 1 else 0), 1)

/-- B, as a fraction: 1,667 km times the months. -/
def b (f : Facts) : Nat × Nat := let (n, d) := months f.availableDays; (1667 * n, d)

/-- A/B, as a fraction (numerator, denominator), never more than 1. -/
def ratio (f : Facts) : Nat × Nat :=
  let (bn, bd) := b f
  if f.requiredForWork && f.primarilyForWork && f.personalKm * bd < bn then (f.personalKm * bd, bn) else (1, 1)

/-- 6(2): the reasonable standby charge. -/
def charge (f : Facts) : Cents :=
  let (dn, dd) := months f.ownedDays
  let (rn, rd) := ratio f
  -- 2% × C × D + 2/3 × (E − F) = (6 × C × dn + 200 × dd × (E − F)) / (300 × dd)
  if f.availableDays = 0 then 0
  else rn * (6 * f.cost * dn + 200 * dd * (f.leasePayments - f.leaseInsurance)) / (rd * 300 * dd)

/-- 6(1)(e): the benefit included in income. -/
def benefit (f : Facts) : Cents := charge f - f.employeePaid

def explain (f : Facts) : Finding :=
  let c := formatCents
  let (rn, rd) := ratio f
  ⟨benefit f > 0, [
    ⟨s!"The automobile was available for {f.availableDays} days" ++
      (if rn < rd then s!", driven {f.personalKm} km for personal use, less than 1,667 km a month: the charge is reduced" else "") ++
      s!". The reasonable standby charge is {c (charge f)}.", "ITA 6(2)"⟩,
    ⟨s!"Less {c f.employeePaid} paid for its use, the benefit is {c (benefit f)}.", "ITA 6(1)(e)"⟩], []⟩

/-! ## Truths -/

private theorem twelve (c : Nat) : 6 * c * 12 / 300 = c * 24 / 100 := by omega

/-- An owned car available all year: 2% of its cost for each of 12 months, 24%. -/
theorem full_year (cost : Cents) : charge { availableDays := 365, cost, ownedDays := 365 } = cost * 24 / 100 := by
  simp [charge, months, ratio, b]
  exact twelve cost

end Canteen.ITA.StandbyCharge

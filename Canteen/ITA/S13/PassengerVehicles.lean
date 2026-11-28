import Canteen.Core.Money
import Canteen.Core.Finding

/-!
# Passenger vehicles: the cost limit (13(7)(g), (i)), interest (67.2) and lease costs (67.3), with
# Regulation 7307

*Income Tax Act* (verbatim in `statute/ITA-13-7-g-i-67.2-67.3.txt`) and *Income Tax Regulations*
(verbatim in `statute/ITR-7307.txt`), as consolidated to 2026-10-29:

**13(7)(g)** A passenger vehicle's capital cost is at most the prescribed amount; **(i)** a zero-emission
passenger vehicle's, at most the 7307(1.1) amount. **Reg. 7307(1)**: A + B, A by the year acquired
($30,000 from 2001 to 2021, $34,000 in 2022, $36,000 in 2023, $37,000 in 2024, $38,000 after 2024), B the
sales taxes on A; **(1.1)** $55,000 (March 19, 2019 to 2021), $59,000 (2022), $61,000 (after 2022), plus taxes.

**67.2** Interest on money borrowed to buy a passenger vehicle is deemed at most A/30 per day: **7307(2)**
$300 for vehicles acquired from 2001 to 2023, $350 after 2023.

**67.3** Lease charges are deemed at most the lesser of (c) A × B / 30 − C − D − E (A the 7307(3) monthly
amount plus taxes: $800 from 2001 to 2021, $900 in 2022, $950 in 2023, $1,050 in 2024, $1,100 after
2024; B the days of the lease to the end of the year; C what was deducted before) and (d) (A × B) / 0.85C
− D − E (A the year's lease charges, B the 7307(1) amount, C the greater of 100/85 of it (7307(4)) and the
manufacturer's list price); D the interest at the prescribed rate on refundable amounts over $1,000, E
reimbursements.

The sales tax rate (for the B elements of 7307) and D are given. Acquisitions and leases before 2001,
designated immediate expensing property, and 13(2), 20(4), (16.1) and 85(1)(e.4) are not encoded.
-/

namespace Canteen.ITA.PassengerVehicles

/-- 7307(1) A, by the year acquired or leased (after 2000). -/
def costA (year : Nat) : Cents :=
  if year ≤ 2021 then 3000000 else if year == 2022 then 3400000 else if year == 2023 then 3600000
  else if year == 2024 then 3700000 else 3800000

/-- 7307(1.1) A, for a zero-emission passenger vehicle (after March 18, 2019). -/
def zevA (year : Nat) : Cents := if year ≤ 2021 then 5500000 else if year == 2022 then 5900000 else 6100000

/-- 7307(3) A, the monthly lease amount (after 2000). -/
def leaseA (year : Nat) : Cents :=
  if year ≤ 2021 then 80000 else if year == 2022 then 90000 else if year == 2023 then 95000
  else if year == 2024 then 105000 else 110000

/-- 7307(2): the monthly interest amount (after 2000). -/
def interestA (year : Nat) : Cents := if year ≤ 2023 then 30000 else 35000

/-- A + B: the amount plus the sales taxes on it, at the rate given in basis points. -/
def withTax (a : Cents) (taxBp : Nat) : Cents := a + a * taxBp / 10000

/-- 13(7)(g), (i): the capital cost. -/
def capitalCost (cost : Cents) (year : Nat) (taxBp : Nat) (zeroEmission : Bool := false) : Cents :=
  min cost (withTax (if zeroEmission then zevA year else costA year) taxBp)

/-- 67.2: the interest deductible. -/
def interest (actual : Cents) (year : Nat) (days : Nat) : Cents := min actual (interestA year * days / 30)

structure Lease where
  /-- The year the lease was entered into. -/
  year : Nat
  /-- The sales tax rate, in basis points. -/
  taxBp : Nat := 0
  /-- (d) A: the year's lease charges. -/
  charges : Cents
  /-- (c) B: days from the start of the lease to the end of the year (or of the lease). -/
  daysToDate : Nat
  /-- (c) C: deducted in earlier years. -/
  deductedBefore : Cents := 0
  /-- The manufacturer's list price. -/
  listPrice : Cents
  /-- D (interest on refundable amounts over $1,000), for (c) and for (d); E reimbursements. -/
  depositInterestToDate : Cents := 0
  depositInterestYear : Cents := 0
  reimbursementsToDate : Cents := 0
  reimbursementsYear : Cents := 0
  deriving Repr, DecidableEq, Inhabited

/-- 67.3(c). -/
def Lease.paraC (l : Lease) : Cents :=
  withTax (leaseA l.year) l.taxBp * l.daysToDate / 30 - l.deductedBefore - l.depositInterestToDate - l.reimbursementsToDate

/-- 67.3(d): A × B / (0.85 × C), C the greater of 7307(4) (100/85 of the 7307(1) amount) and the list price. -/
def Lease.paraD (l : Lease) : Cents :=
  let b := withTax (costA l.year) l.taxBp
  let c := max (b * 100 / 85) l.listPrice
  (if c = 0 then 0 else l.charges * b * 100 / (85 * c)) - l.depositInterestYear - l.reimbursementsYear

/-- 67.3: the lease charges deductible (at most the actual charges). -/
def Lease.deductible (l : Lease) : Cents := min l.charges (min l.paraC l.paraD)

def explain (l : Lease) : Finding :=
  let c := formatCents
  ⟨l.deductible < l.charges, [
    ⟨s!"Lease charges of {c l.charges}. The monthly limit gives {c l.paraC}; the cost limit, against a list price of " ++
      s!"{c l.listPrice}, gives {c l.paraD}. Deductible: {c l.deductible}.", "ITA 67.3(c), (d); ITR 7307(1), (3), (4)"⟩], []⟩

/-! ## Truths -/

theorem capitalCost_le (cost : Cents) (year taxBp : Nat) (z : Bool) : capitalCost cost year taxBp z ≤ cost := Nat.min_le_left _ _

theorem Lease.deductible_le (l : Lease) : l.deductible ≤ l.charges := Nat.min_le_left _ _

/-- A vehicle costing under the limit keeps its cost. -/
theorem under_limit (cost : Cents) (year taxBp : Nat) (h : cost ≤ withTax (costA year) taxBp) : capitalCost cost year taxBp = cost := by
  simp [capitalCost, Nat.min_eq_left h]

end Canteen.ITA.PassengerVehicles

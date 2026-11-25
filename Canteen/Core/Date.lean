/-!
# Dates

Calendar dates (proleptic Gregorian), converted to day numbers so that periods
such as "30 days before and 30 days after" can be computed. Generic: nothing
here is specific to tax.
-/

namespace Canteen

/-- A calendar date. Use `Date.valid` to check it is a real date. -/
structure Date where
  year : Nat
  month : Nat
  day : Nat
  deriving Repr, DecidableEq, Inhabited

namespace Date

def isLeapYear (y : Nat) : Bool :=
  (y % 4 == 0 && y % 100 != 0) || y % 400 == 0

def daysInMonth (y m : Nat) : Nat :=
  match m with
  | 2 => if isLeapYear y then 29 else 28
  | 4 | 6 | 9 | 11 => 30
  | _ => 31

/-- A real calendar date in year 1 or later. -/
def valid (d : Date) : Bool :=
  1 ≤ d.year && 1 ≤ d.month && d.month ≤ 12 && 1 ≤ d.day && d.day ≤ daysInMonth d.year d.month

/-- Days since 1 March of year 0. Consecutive valid dates get consecutive numbers. -/
def toDays (d : Date) : Nat :=
  let y := if d.month ≤ 2 then d.year - 1 else d.year
  let mp := (d.month + 9) % 12
  let doy := (153 * mp + 2) / 5 + d.day - 1
  y * 365 + y / 4 - y / 100 + y / 400 + doy

/-- The date with the given day number (inverse of `toDays` on valid dates). -/
def ofDays (n : Nat) : Date :=
  let era := n / 146097
  let doe := n % 146097
  let yoe := (doe - doe / 1460 + doe / 36524 - doe / 146096) / 365
  let y := yoe + era * 400
  let doy := doe - (365 * yoe + yoe / 4 - yoe / 100)
  let mp := (5 * doy + 2) / 153
  let d := doy - (153 * mp + 2) / 5 + 1
  let m := if mp < 10 then mp + 3 else mp - 9
  ⟨if m ≤ 2 then y + 1 else y, m, d⟩

/-- The date `n` days later. -/
def addDays (d : Date) (n : Nat) : Date := ofDays (d.toDays + n)

/-- The date `n` days earlier. -/
def subDays (d : Date) (n : Nat) : Date := ofDays (d.toDays - n)

/-- `other` falls in the period that begins `n` days before `d` and ends `n` days
after it, both ends included. -/
def withinDaysAround (d other : Date) (n : Nat) : Bool :=
  d.toDays ≤ other.toDays + n && other.toDays ≤ d.toDays + n

/-- `other` falls on `d` or in the `n` days after it. -/
def withinDaysAfter (d other : Date) (n : Nat) : Bool :=
  d.toDays ≤ other.toDays && other.toDays ≤ d.toDays + n

/-- `d` is earlier than `other`. -/
def before (d other : Date) : Bool := d.toDays < other.toDays

private def pad2 (n : Nat) : String := if n < 10 then s!"0{n}" else toString n

/-- ISO format, e.g. `2025-06-15`. -/
def toIso (d : Date) : String := s!"{d.year}-{pad2 d.month}-{pad2 d.day}"

instance : ToString Date := ⟨toIso⟩

theorem withinDaysAround_comm (d other : Date) (n : Nat) :
    d.withinDaysAround other n = other.withinDaysAround d n := by
  simp only [withinDaysAround, Bool.and_comm]

theorem withinDaysAround_self (d : Date) (n : Nat) : d.withinDaysAround d n = true := by
  simp [withinDaysAround]

end Date

end Canteen

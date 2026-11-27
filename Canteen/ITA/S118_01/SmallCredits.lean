import Canteen.Core.Money

/-!
# Sections 118.01 to 118.07: the adoption, home accessibility, home buyers', and volunteer credits

*Income Tax Act*, as consolidated to 2026-10-29 (verbatim in `statute/ITA-118.01-118.07.txt`):

* **118.01(2)** in the year an adoption period ends, 14% of the lesser of $15,000 (indexed) and the
  eligible adoption expenses less reimbursements and assistance; **(3)** where more than one individual
  claims for the child, together no more than one could.
* **118.041(3)** 14% of the lesser of $20,000 and the qualifying expenditures on an eligible dwelling.
* **118.05(3)** in the year a qualifying home is acquired, 14% of $10,000; **(4)** shared as in 118.01(3).
* **118.06(2)** 14% of $6,000 for an individual with at least 200 hours of volunteer firefighting or
  search and rescue service; **118.07(2)** the same for search and rescue, if no 118.06 claim.

Whether the expenses, home, dwelling and services qualify (the definitions in each section) are
facts. The adoption limit is the year's indexed amount. Where a credit is shared, the individual's
share of the amount is given. Not encoded: the definitions, the certificates (118.06(3), 118.07(3)), and
the 118.041 qualifying expenditure rules.
-/

namespace Canteen.ITA.SmallCredits

structure Adoption where
  /-- C: the eligible adoption expenses for the child. -/
  expenses : Cents
  /-- D: reimbursements and other assistance. -/
  assistance : Cents := 0
  /-- 118.01(3): the individual's share of the amount, where another also claims. -/
  share : Option Cents := none
  deriving Repr, DecidableEq, Inhabited

structure Facts where
  /-- 118.01: an adoption period ending in the year, and the indexed limit for the year. -/
  adoption : Option Adoption := none
  adoptionLimit : Cents := 1500000
  /-- 118.041: qualifying expenditures on an eligible dwelling. -/
  accessibility : Cents := 0
  /-- 118.05: a qualifying home acquired in the year, and the individual's share of the $10,000 if shared. -/
  homeBuyer : Bool := false
  homeBuyerShare : Option Cents := none
  /-- 118.06, 118.07: hours of eligible volunteer firefighting and search and rescue service. -/
  firefighterHours : Nat := 0
  searchRescueHours : Nat := 0
  deriving Repr, DecidableEq, Inhabited

/-- 118.01(2) B, with (3). -/
def adoptionAmount (f : Facts) : Cents :=
  match f.adoption with
  | none => 0
  | some a =>
    let b := min f.adoptionLimit (a.expenses - a.assistance)
    match a.share with
    | some s => min s b
    | none => b

/-- 118.041(3) B. -/
def accessibilityAmount (f : Facts) : Cents := min 2000000 f.accessibility

/-- 118.05(3), (4). -/
def homeBuyerAmount (f : Facts) : Cents :=
  if f.homeBuyer then min 1000000 (f.homeBuyerShare.getD 1000000) else 0

/-- 118.06(2), or else 118.07(2): $6,000 with 200 hours of either service, claimed once. -/
def volunteerAmount (f : Facts) : Cents :=
  if 200 ≤ f.firefighterHours + f.searchRescueHours then 600000 else 0

def total (f : Facts) : Cents := adoptionAmount f + accessibilityAmount f + homeBuyerAmount f + volunteerAmount f

/-- The credits, at 14%. -/
def credit (f : Facts) : Cents := total f * 1400 / 10000

/-! ## Truths -/

/-- The adoption amount never exceeds the year's limit. -/
theorem adoption_le (f : Facts) : adoptionAmount f ≤ f.adoptionLimit := by
  unfold adoptionAmount; split
  · exact Nat.zero_le _
  · split
    · exact Nat.le_trans (Nat.min_le_right _ _) (Nat.min_le_left _ _)
    · exact Nat.min_le_left _ _

/-- Never more than $6,000 for volunteer service, however many hours of both kinds. -/
theorem volunteer_le (f : Facts) : volunteerAmount f ≤ 600000 := by
  unfold volunteerAmount; split <;> decide

end Canteen.ITA.SmallCredits

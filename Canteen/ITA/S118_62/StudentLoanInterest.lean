import Canteen.Core.Money
import Canteen.Core.Finding

/-!
# Section 118.62: the credit for interest on student loans

*Income Tax Act*, as consolidated to 2026-10-29 (verbatim in `statute/ITA-118.62.txt`):

**118.62** An individual may deduct from tax the appropriate percentage of the interest paid in the year,
or in any of the five preceding years after 1997 to the extent not already used, by the individual or a
related person, on a loan under the Canada Student Loans Act, the Canada Student Financial Assistance
Act, the Apprentice Loans Act or a provincial law governing financial assistance to post-secondary
students; not amounts paid under a judgment.

The appropriate percentage is the lowest rate in 117(2), 14% as encoded. The interest is used oldest
first; what is claimed and what remains are computed. Which loans qualify is a fact.
-/

namespace Canteen.ITA.StudentLoanInterest

structure Payment where
  /-- The year paid. -/
  year : Nat
  /-- Interest paid on a qualifying loan, less any part used in an earlier year. -/
  unused : Cents
  /-- Paid under a judgment: excluded. -/
  judgment : Bool := false
  deriving Repr, DecidableEq, Inhabited

structure Facts where
  taxationYear : Nat
  payments : List Payment := []
  /-- The interest claimed; by default all that is available. -/
  claim : Option Cents := none
  deriving Repr, DecidableEq, Inhabited

/-- The year and the five preceding years after 1997. -/
def Payment.available (p : Payment) (year : Nat) : Bool :=
  !p.judgment && p.year ≤ year && year ≤ p.year + 5 && 1997 < p.year

def availableTotal (f : Facts) : Cents := ((f.payments.filter (·.available f.taxationYear)).map (·.unused)).sum

def claimed (f : Facts) : Cents := min (f.claim.getD (availableTotal f)) (availableTotal f)

/-- The appropriate percentage: 14%. -/
def credit (f : Facts) : Cents := claimed f * 14 / 100

/-- Interest that may still be claimed later (the year's and the four before, if unclaimed). -/
def carriedForward (f : Facts) : Cents := availableTotal f - claimed f

def explain (f : Facts) : Finding :=
  let c := formatCents
  ⟨credit f > 0, [
    ⟨s!"Student loan interest paid in {f.taxationYear} and the five years before, not yet used: {c (availableTotal f)}; claimed: " ++
      s!"{c (claimed f)}, for a credit of 14%, {c (credit f)}; {c (carriedForward f)} may be claimed later.", "ITA 118.62"⟩], []⟩

/-! ## Truths -/

theorem claimed_le (f : Facts) : claimed f ≤ availableTotal f := Nat.min_le_right _ _

theorem claimed_plus_carried (f : Facts) : claimed f + carriedForward f = availableTotal f :=
  Nat.add_sub_cancel' (claimed_le f)

/-- Interest paid under a judgment never counts. -/
theorem judgment_excluded (p : Payment) (y : Nat) (h : p.judgment = true) : p.available y = false := by
  simp [Payment.available, h]

end Canteen.ITA.StudentLoanInterest

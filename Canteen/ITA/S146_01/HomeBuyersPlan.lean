import Canteen.Core.Money
import Canteen.Core.Finding

/-!
# Section 146.01: the Home Buyers' Plan

*Income Tax Act*, as consolidated to 2026-10-29 (verbatim in `statute/ITA-146.01-1-3-4.txt`):

**146.01(1) "regular eligible amount"** and **"supplemental eligible amount"**: amounts withdrawn from an
RRSP to acquire a qualifying home, among the conditions (h) or (g) that the year's eligible amounts not
exceed $60,000, and (i) or (h) that the HBP balance be nil at the beginning of the year. **"HBP
balance"**: eligible amounts received, less amounts designated as repaid (146.01(3)) and amounts included
in income (146.01(4), (5)).

**146.01(3)** An individual may designate, for a year, contributions to an RRSP of the year or the first
60 days after, up to what remains of the eligible amounts, as repayments.

**146.01(4)** For each year of the participation period the individual includes [(A − B − C) / (15 − D)]
− E: A the eligible amounts, B the amounts designated for preceding years, C the amounts included for
preceding years, D the lesser of 14 and the years since repayment began, E the amount designated for the
year. So each year's required repayment is the balance over the years left, and what is not repaid is
income.

The repayments designated are given year by year from the first year of repayment (the year after the
completion date, determined under 146.01(2); the deferral for 2022 to 2025 withdrawals is the caller's).
The other conditions of an eligible amount (first-time buyer, qualifying home, written agreement) are
facts. 146.01(5) (death or emigration) and (4.1) are not encoded.
-/

namespace Canteen.ITA.HomeBuyersPlan

/-- (h), (i): the year's withdrawals within $60,000, with a nil balance at the start of the year. -/
def withinLimit (yearWithdrawals : Cents) (openingBalance : Cents) : Bool := yearWithdrawals ≤ 6000000 && openingBalance == 0

/-- One year of 146.01(4): the inclusion, given the balance (A − B − C), the years since repayment
began (for D), and the amount designated (E). -/
def inclusion (balance : Cents) (yearsSince : Nat) (designated : Cents) : Cents :=
  balance / (15 - min 14 yearsSince) - designated

/-- The year's required repayment. -/
def required (balance : Cents) (yearsSince : Nat) : Cents := balance / (15 - min 14 yearsSince)

/-- The schedule: for each year's designated repayment, the inclusion, from the given balance. -/
def schedule : Cents → Nat → List Cents → List Cents
  | _, _, [] => []
  | balance, k, d :: ds =>
    let i := inclusion balance k d
    i :: schedule (balance - min balance d - i) (k + 1) ds

def explain (balance : Cents) (yearsSince : Nat) (designated : Cents) : Finding :=
  let c := formatCents
  ⟨inclusion balance yearsSince designated > 0, [
    ⟨s!"The HBP balance is {c balance}; the year's required repayment is {c (required balance yearsSince)} (the balance over " ++
      s!"{15 - min 14 yearsSince} years); {c designated} was designated as repaid, so {c (inclusion balance yearsSince designated)} " ++
      "is included in income.", "ITA 146.01(3), (4)"⟩], []⟩

/-! ## Truths -/

/-- Repaying at least what is required: nothing included. -/
theorem repaid (balance : Cents) (k : Nat) (d : Cents) (h : required balance k ≤ d) : inclusion balance k d = 0 :=
  Nat.sub_eq_zero_of_le h

/-- In the fifteenth year (and after) the whole balance is required. -/
theorem last_year (balance : Cents) (k : Nat) (h : 14 ≤ k) : required balance k = balance := by
  simp [required, Nat.min_eq_left h]

end Canteen.ITA.HomeBuyersPlan

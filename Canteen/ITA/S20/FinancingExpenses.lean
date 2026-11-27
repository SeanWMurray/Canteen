import Canteen.Core.Money
import Canteen.Core.Finding

/-!
# Paragraphs 20(1)(e) and (e.1): financing expenses

*Income Tax Act*, as consolidated to 2026-10-29 (verbatim in `statute/ITA-20-1-e-e.1.txt`):

**20(1)(e)** An expense, not otherwise deductible and not an excluded amount, incurred in the year or
earlier (i) in issuing shares (or units, or partnership interests), (ii) in borrowing money used to earn
income from a business or property (not to acquire exempt-income property), (ii.1) in incurring
indebtedness for property acquired to earn income, or (ii.2) in rescheduling, restructuring or
assuming such a debt: the lesser of (iii) 20% of the expense, prorated by the days in the year over 365,
and (iv) the expense less what was deductible for it in earlier years. (iv.1) Excluded: principal or
interest, and amounts contingent on use or production or computed by reference to revenue, profit,
cash flow, commodity prices or dividends. (v) When all the debt obligations of a borrowing or
indebtedness in (ii) or (ii.1) are settled or extinguished in the year, other than as part of a series
of refinancings and for consideration that is not the taxpayer's (or a non-arm's length person's)
units, interests, shares or debt, the rest is deducted.

**20(1)(e.1)** Standby charges, guarantee, registrar, transfer agent, filing and service fees and the
like, relating solely to the year, for such a borrowing, indebtedness or restructuring (and not
contingent or computed by reference to revenue, profit and the like), are deducted in the year.

The purpose, whether the expense is an excluded amount, and the settlement of (v) are facts. 20(1)(e)(vi)
(a partnership that has ceased to exist) is not encoded.
-/

namespace Canteen.ITA.FinancingExpenses

inductive Purpose where
  /-- (i) issuing shares, units or partnership interests. -/
  | issuance
  /-- (ii) borrowing money used to earn income from a business or property. -/
  | borrowing
  /-- (ii.1) indebtedness for property acquired to earn income. -/
  | indebtedness
  /-- (ii.2) rescheduling, restructuring or assuming such a debt. -/
  | restructuring
  deriving Repr, DecidableEq, Inhabited

structure Expense where
  description : String
  purpose : Purpose
  amount : Cents
  /-- (iv.1): principal or interest, or contingent or computed by reference to revenue, profit and the like. -/
  excluded : Bool := false
  /-- (ii), (ii.1): the money or property is used for exempt income (or the property is a life insurance policy). -/
  exemptUse : Bool := false
  /-- (iv): deductible for it in earlier taxation years. -/
  deductedBefore : Cents := 0
  /-- (v): all the debt obligations settled or extinguished in the year, at arm's length, not refinanced. -/
  settled : Bool := false
  deriving Repr, DecidableEq, Inhabited

def Expense.eligible (e : Expense) : Bool := !e.excluded && !(e.exemptUse && e.purpose != .issuance)

def Expense.remaining (e : Expense) : Cents := e.amount - e.deductedBefore

/-- (iii): 20%, prorated by the days in the year over 365. -/
def Expense.fifth (e : Expense) (days : Nat) : Cents := e.amount * 20 * days / (100 * 365)

/-- (v) applies to borrowings and indebtedness only. -/
def Expense.fullySettled (e : Expense) : Bool := e.settled && (e.purpose == .borrowing || e.purpose == .indebtedness)

/-- 20(1)(e): the deduction for the year. -/
def Expense.deduction (e : Expense) (days : Nat := 365) : Cents :=
  if !e.eligible then 0 else if e.fullySettled then e.remaining else min (e.fifth days) e.remaining

/-- The deductions year by year over full years, from the first. -/
def Expense.schedule (e : Expense) : Nat → List Cents
  | 0 => []
  | n + 1 => e.deduction :: ({ e with deductedBefore := e.deductedBefore + e.deduction } : Expense).schedule n

/-- 20(1)(e.1): an annual fee. -/
structure Fee where
  description : String
  amount : Cents
  /-- Relates solely to the year. -/
  solelyToYear : Bool := true
  /-- Contingent, or computed by reference to revenue, profit and the like. -/
  contingent : Bool := false
  deriving Repr, DecidableEq, Inhabited

def Fee.deduction (f : Fee) : Cents := if f.solelyToYear && !f.contingent then f.amount else 0

structure Facts where
  expenses : List Expense := []
  fees : List Fee := []
  /-- The days in the taxation year. -/
  days : Nat := 365
  deriving Repr, DecidableEq, Inhabited

def deduction (f : Facts) : Cents := (f.expenses.map (·.deduction f.days)).sum + (f.fees.map Fee.deduction).sum

def explain (f : Facts) : Finding :=
  let c := formatCents
  let steps : List Step := f.expenses.map fun e =>
    if !e.eligible then ⟨s!"{e.description}: not deductible under 20(1)(e) " ++
        (if e.excluded then "(principal, interest, or a contingent or profit-based amount)." else "(for exempt income)."), "ITA 20(1)(e)(ii), (iv.1)"⟩
    else if e.fullySettled then ⟨s!"{e.description}: the debt is settled, so the {c e.remaining} not yet deducted is deducted.", "ITA 20(1)(e)(v)"⟩
    else ⟨s!"{e.description}: the lesser of 20% of {c e.amount} for {f.days} days, {c (e.fifth f.days)}, and the {c e.remaining} " ++
        s!"not yet deducted: {c (e.deduction f.days)}.", "ITA 20(1)(e)(iii), (iv)"⟩
  let fees : List Step := f.fees.map fun x =>
    ⟨s!"{x.description}: {c x.deduction}.", "ITA 20(1)(e.1)"⟩
  ⟨deduction f > 0, steps ++ fees ++ [⟨s!"Financing expenses deducted: {c (deduction f)}.", "ITA 20(1)(e), (e.1)"⟩], []⟩

/-! ## Truths -/

/-- Never more than what is left of the expense. -/
theorem Expense.deduction_le_remaining (e : Expense) (days : Nat) : e.deduction days ≤ e.remaining := by
  unfold Expense.deduction
  split
  · exact Nat.zero_le _
  · split
    · exact Nat.le_refl _
    · exact Nat.min_le_right _ _

/-- A full year of an expense not yet deducted: a fifth. -/
theorem Expense.full_year (e : Expense) (h : e.eligible = true) (hs : e.fullySettled = false) (h0 : e.deductedBefore = 0) :
    e.deduction = min (e.amount * 20 * 365 / 36500) e.amount := by
  simp [Expense.deduction, Expense.fifth, Expense.remaining, h, hs, h0]

end Canteen.ITA.FinancingExpenses

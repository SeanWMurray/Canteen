import Canteen.Core.Money
import Canteen.Core.Finding
import Canteen.Core.Answer

/-!
# Doubtful and bad debts: 20(1)(l), 20(1)(p), 12(1)(d), 12(1)(i)

*Income Tax Act*, as consolidated to 2026-10-29 (verbatim in `statute/ITA-12-1-d-i-20-1-l-p.txt`):

**20(1)(l)(i)** A reserve of a reasonable amount for doubtful debts that have been included in income for
the year or an earlier year. **12(1)(d)** Last year's 20(1)(l) reserve is included in income this year.

**20(1)(p)(i)** Debts established in the year to have become bad, that have been included in income for
the year or an earlier year, are deducted. **12(1)(i)** Amounts received in the year on account of a debt
deducted as bad in an earlier year are included.

For each receivable: whether it has been included in income (a trade receivable from sales, as opposed
to a loan, say), and whether it is doubtful (with the reasonable reserve for it) or has been established
to be bad (a fact or a judgment call). A reserve is never more than the debt. The lenders' and financial
institutions' parts, 20(1)(l)(ii) and 20(1)(p)(ii), and 12(1)(i.1), are not encoded. A debt not included
in income that goes bad is a capital loss, if anything (50(1), `BadDebtOrShare`).
-/

namespace Canteen.ITA.DoubtfulDebts

structure Receivable where
  description : String
  amount : Cents
  /-- Included in income for the year or an earlier year (a trade receivable, not a loan). -/
  includedInIncome : Bool := true
  /-- 20(1)(l)(i): doubtful, with the reasonable reserve for it. -/
  reserve : Cents := 0
  /-- 20(1)(p)(i): established in the year to have become bad. -/
  bad : Answer := .fact false
  deriving Repr, DecidableEq, Inhabited

structure Facts where
  receivables : List Receivable := []
  /-- 12(1)(d): the reserve deducted under 20(1)(l) last year. -/
  priorReserve : Cents := 0
  /-- 12(1)(i): received in the year on account of debts deducted as bad in earlier years. -/
  recoveries : Cents := 0
  deriving Repr, DecidableEq, Inhabited

/-- 20(1)(l)(i): for a debt included in income, not established to be bad. -/
def Receivable.reserveAllowed (r : Receivable) : Cents :=
  if r.includedInIncome && !r.bad.value then min r.reserve r.amount else 0

/-- 20(1)(p)(i). -/
def Receivable.badDebt (r : Receivable) : Cents := if r.includedInIncome && r.bad.value then r.amount else 0

def reserve (f : Facts) : Cents := (f.receivables.map Receivable.reserveAllowed).sum
def badDebts (f : Facts) : Cents := (f.receivables.map Receivable.badDebt).sum
def deductions (f : Facts) : Cents := reserve f + badDebts f
def inclusions (f : Facts) : Cents := f.priorReserve + f.recoveries

/-- The net effect on income: deductions less inclusions. -/
def net (f : Facts) : Int := (deductions f : Int) - (inclusions f : Int)

def judgments (f : Facts) : List String := f.receivables.foldl (fun ids r => mergeIds ids r.bad.judgments) []

def explain (f : Facts) : Finding :=
  let c := formatCents
  let steps : List Step := f.receivables.filterMap fun r =>
    if !r.includedInIncome && (r.bad.value || r.reserve > 0) then
      some ⟨s!"{r.description}: never included in income, so neither a reserve nor a bad debt deduction.", "ITA 20(1)(l)(i), (p)(i)"⟩
    else if r.badDebt > 0 then some ⟨s!"{r.description}: established to be bad in the year: {c r.badDebt} deducted.", "ITA 20(1)(p)(i)"⟩
    else if r.reserveAllowed > 0 then some ⟨s!"{r.description}: doubtful: a reserve of {c r.reserveAllowed}.", "ITA 20(1)(l)(i)"⟩
    else none
  ⟨deductions f > 0, steps ++
    [⟨s!"Last year's reserve, {c f.priorReserve}, and recoveries of debts written off, {c f.recoveries}, are included.", "ITA 12(1)(d), (i)"⟩,
     ⟨s!"Deducted: {c (reserve f)} of reserve and {c (badDebts f)} of bad debts; included: {c (inclusions f)}.", "ITA 12(1)(d), (i); 20(1)(l), (p)"⟩],
    judgments f⟩

/-! ## Truths -/

theorem Receivable.reserve_le (r : Receivable) : r.reserveAllowed ≤ r.amount := by
  unfold Receivable.reserveAllowed; split
  · exact Nat.min_le_right _ _
  · exact Nat.zero_le _

/-- A debt is either reserved for or written off, never both. -/
theorem Receivable.not_both (r : Receivable) : r.reserveAllowed = 0 ∨ r.badDebt = 0 := by
  unfold Receivable.reserveAllowed Receivable.badDebt
  cases r.includedInIncome <;> cases r.bad.value <;> simp

/-- A debt never included in income gives no deduction under either. -/
theorem Receivable.not_included (r : Receivable) (h : r.includedInIncome = false) : r.reserveAllowed = 0 ∧ r.badDebt = 0 := by
  simp [Receivable.reserveAllowed, Receivable.badDebt, h]

/-- The reserve reverses: next year's income includes it. -/
theorem reverses (f g : Facts) (h : g.priorReserve = reserve f) : reserve f ≤ inclusions g := by
  unfold inclusions; rw [h]; exact Nat.le_add_right _ _

end Canteen.ITA.DoubtfulDebts

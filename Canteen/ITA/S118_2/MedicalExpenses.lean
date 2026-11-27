import Canteen.Core.Answer
import Canteen.Core.Money

/-!
# Subsection 118.2(1): the medical expense credit

*Income Tax Act*, as consolidated to 2026-10-29 (verbatim in `statute/ITA-118.2-1.txt`):

**118.2(1)** An individual may deduct A × [(B − C) + D]: A the appropriate percentage (14%); B the
medical expenses for the individual, their spouse or common-law partner, and their children under 18,
(a) evidenced by receipts, (b), (c) not claimed before or by anyone else, and (d) paid within a
12-month period ending in the year (24 months including the day of death, for a person who died in
the year); C the lesser of $1,813 (indexed) and 3% of the individual's income; D for each other
dependant (118(6)), their medical expenses so paid, less the lesser of $1,813 (indexed) and 3% of the
dependant's income.

Whether an amount is a medical expense (the list in 118.2(2), and 118.2(2.1) to (4)) is a fact or a
judgment call for each expense; the 12-month period is given as a fact. The threshold defaults to its
2025 indexed amount, $2,834. Not encoded: section 64, 122.51 and 118.2(2), (3). Rounded down to the
cent.
-/

namespace Canteen.ITA.MedicalExpenses

/-- Whom an expense is for. -/
inductive Patient where
  /-- The individual, their spouse or common-law partner, or a child under 18 at the end of the year (B). -/
  | family
  /-- Another dependant (118(6)), with their income for the year (D). -/
  | dependant (name : String) (income : Cents)
  deriving Repr, DecidableEq, Inhabited

structure Expense where
  description : String
  amount : Cents
  patient : Patient := .family
  /-- (a): evidenced by receipts filed with the Minister. -/
  receipts : Bool := true
  /-- (b), (c): claimed in an earlier year, or by another taxpayer. -/
  claimedElsewhere : Bool := false
  /-- (d): paid within the 12-month period chosen (24 months around a death). -/
  inPeriod : Bool := true
  /-- It is a medical expense under 118.2(2). Sometimes a judgment call. -/
  medical : Answer := .fact true
  deriving Repr, Inhabited

structure Facts where
  /-- The individual's income for the year. -/
  income : Cents
  expenses : List Expense
  /-- The indexed $1,813 (2025: $2,834). -/
  threshold : Cents := 283400
  deriving Repr, Inhabited

/-- Paragraphs (a) to (d), and a medical expense. -/
def Expense.counts (e : Expense) : Bool := e.receipts && !e.claimedElsewhere && e.inPeriod && e.medical.value

def Expense.isFamily (e : Expense) : Bool := e.patient = .family

def floor (threshold income : Cents) : Cents := min threshold (income * 3 / 100)

/-- B. -/
def familyExpenses (f : Facts) : Cents :=
  ((f.expenses.filter fun e => e.isFamily && e.counts).map (·.amount)).sum

/-- C. -/
def reduction (f : Facts) : Cents := floor f.threshold f.income

/-- E − F for one dependant. -/
def dependantAmount (f : Facts) (name : String) (income : Cents) : Cents :=
  ((f.expenses.filter fun e => e.patient = .dependant name income && e.counts).map (·.amount)).sum - floor f.threshold income

/-- The dependants, each once. -/
def dependants (f : Facts) : List (String × Cents) :=
  (f.expenses.filterMap fun e => match e.patient with | .dependant n i => some (n, i) | .family => none).eraseDups

/-- D. -/
def otherDependants (f : Facts) : Cents := ((dependants f).map fun (n, i) => dependantAmount f n i).sum

/-- The amount, (B − C) + D. -/
def amount (f : Facts) : Cents := (familyExpenses f - reduction f) + otherDependants f

/-- The credit, at 14%. -/
def credit (f : Facts) : Cents := amount f * 1400 / 10000

def explain (f : Facts) : Finding :=
  let c := formatCents
  ⟨credit f > 0, [
    ⟨s!"Medical expenses for the individual, spouse and minor children: {c (familyExpenses f)}, less the lesser of " ++
      s!"{c f.threshold} and 3% of income, {c (reduction f)}.", "ITA 118.2(1) B, C"⟩,
    ⟨s!"Other dependants, each less the lesser of {c f.threshold} and 3% of their income: {c (otherDependants f)}.", "ITA 118.2(1) D"⟩,
    ⟨s!"The credit is 14% of {c (amount f)}: {c (credit f)}.", "ITA 118.2(1) A"⟩],
    (f.expenses.map (·.medical.judgments)).foldl (· ++ ·) [] |>.eraseDups⟩

/-! ## Truths about the credit -/

/-- The reduction is at most the indexed threshold. -/
theorem reduction_le (f : Facts) : reduction f ≤ f.threshold := Nat.min_le_left _ _

/-- With only family expenses, nothing is claimed unless they exceed 3% of income or the threshold. -/
theorem below_floor (f : Facts) (h : otherDependants f = 0) (hb : familyExpenses f ≤ reduction f) : credit f = 0 := by
  unfold credit amount; rw [h, Nat.sub_eq_zero_of_le hb]

end Canteen.ITA.MedicalExpenses

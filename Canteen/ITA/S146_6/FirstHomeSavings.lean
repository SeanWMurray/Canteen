import Canteen.Core.Money
import Canteen.Core.Finding

/-!
# Section 146.6: the First Home Savings Account (FHSA) deduction

*Income Tax Act*, as consolidated to 2026-10-29 (verbatim in `statute/ITA-146.6-1-5.txt`):

**146.6(1) "annual FHSA limit"** for a year: the least of (a) A + B − C, A the year's contributions
(before the first qualifying withdrawal), B last year's (a) amount over last year's limit, C designated
amounts; (b) $8,000 + D − (E − F), D the FHSA carryforward, E the net RRSP-to-FHSA transfers, F prior
years' transfer adjustments; and (c) nil after the maximum participation period or death. **"FHSA
carryforward"**: the least of $8,000, last year's (b) amount less last year's (a) amount, and nil before
the period began.

**146.6(5)** The deduction for a year is at most the lesser of (a) the annual limits of the year and
earlier years less earlier deductions, and (b) $40,000 less earlier deductions and net transfers.

Modelled without RRSP transfers (E, F), designated amounts (C) or withdrawals: each year of the
participation period is given its contributions and the amount deducted. Excess contributions (the
Part XI.01 tax, 207.02) are not encoded beyond carrying in B.
-/

namespace Canteen.ITA.FirstHomeSavings

/-- A year of the participation period. -/
structure Year where
  contributions : Cents
  /-- The amount the holder chooses to deduct (by default all that is available). -/
  deduction : Option Cents := none
  deriving Repr, DecidableEq, Inhabited

/-- What one year carries to the next: (a), (b), the limits and deductions so far. -/
structure State where
  paraA : Cents := 0
  paraB : Cents := 0
  limit : Cents := 0
  limits : Cents := 0
  deducted : Cents := 0
  started : Bool := false
  deriving Repr, DecidableEq, Inhabited

/-- The year's FHSA carryforward. -/
def carryforward (s : State) : Cents := if s.started then min 800000 (s.paraB - s.paraA) else 0

/-- 146.6(5): available to deduct. -/
def available (s : State) (limit : Cents) : Cents := min (s.limits + limit - s.deducted) (4000000 - s.deducted)

/-- One year: the annual limit, the deduction, and the state after. -/
def step (s : State) (y : Year) : State :=
  let b := if s.started then s.paraA - s.limit else 0
  let a := y.contributions + b
  let pb := 800000 + carryforward s
  let lim := min a pb
  let d := min (y.deduction.getD (available s lim)) (available s lim)
  { paraA := a, paraB := pb, limit := lim, limits := s.limits + lim, deducted := s.deducted + d, started := true }

/-- The states after each year. -/
def run : State → List Year → List State
  | _, [] => []
  | s, y :: ys => let s' := step s y; s' :: run s' ys

def limits (ys : List Year) : List Cents := (run {} ys).map (·.limit)
def deductions (ys : List Year) : List Cents :=
  let ss := run {} ys
  (ss.zip ({} :: ss)).map fun (now, before) => now.deducted - before.deducted

def explain (ys : List Year) : Finding :=
  let c := formatCents
  ⟨true, (List.zip (limits ys) (deductions ys)).map fun (l, d) =>
    ⟨s!"Annual FHSA limit {c l}; deducted {c d}.", "ITA 146.6(1) \"annual FHSA limit\"; 146.6(5)"⟩, []⟩

/-! ## Truths -/

/-- The carryforward is never more than $8,000, so a year's limit never more than $16,000. -/
theorem carryforward_le (s : State) : carryforward s ≤ 800000 := by
  unfold carryforward; split
  · exact Nat.min_le_left _ _
  · exact Nat.zero_le _

theorem limit_le (s : State) (y : Year) : (step s y).limit ≤ 1600000 :=
  Nat.le_trans (Nat.min_le_right _ _) (Nat.add_le_add_left (carryforward_le s) _)

private theorem within (x d a : Nat) (ha : a ≤ 4000000 - x) (hx : x ≤ 4000000) : x + min d a ≤ 4000000 := by omega

/-- Never more deducted in total than $40,000. -/
theorem deducted_le (s : State) (y : Year) (h : s.deducted ≤ 4000000) : (step s y).deducted ≤ 4000000 := by
  simp only [step]
  exact within _ _ _ (by unfold available; exact Nat.min_le_right _ _) h

end Canteen.ITA.FirstHomeSavings

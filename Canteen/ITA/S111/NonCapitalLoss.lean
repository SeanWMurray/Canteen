import Canteen.ITA.S38.CapitalGains
import Canteen.Core.Finding

/-!
# Non-capital losses: what they are (111(8)) and their deduction (111(1)(a), 111(3))

*Income Tax Act*, as consolidated to 2026-10-29 (verbatim in `statute/ITA-111-1-a-3-8-non-capital-loss.txt`):

**111(8) "non-capital loss"** of a taxpayer for a taxation year, at any time: (A + B) − (D + D.1 + D.2),
where A is E − F: E the total of (a) the taxpayer's losses for the year from an office, employment,
business or property, (b) the amounts deducted under 111(1)(a.1) or (b), 110.6, 110.61 or 110.62, or
deductible under 110(1)(d) to (g) and (k), 112, 113(1) and 138(6), in computing taxable income, and
(c) if that time is before the taxpayer's eleventh following taxation year, its allowable business
investment loss for the year; F the amount under 3(c). B (110.5, 115(1)(a)(vii)), D (the farm loss),
D.1 (111(10)) and D.2 (section 80) are given, together, as reductions; B is not encoded.

**111(1)(a)** In computing taxable income, a taxpayer may deduct such portion as it claims of its
non-capital losses for the 20 taxation years immediately preceding and the 3 immediately following.

**111(3)** (a) only to the extent the loss exceeds what was deducted for it in earlier years (and
claimed under 186(1)(c) and (d)); (b) no amount for a year's loss until the deductible losses of
preceding years have been deducted.

Losses are in half-cents (an allowable business investment loss can be an odd half). Each loss is given
with what is left of it after earlier years (111(3)(a)). Years are counted as calendar years. A claim
is applied to the losses oldest first, which 111(3)(b) requires. Losses of taxation years ending before
2006 (carried forward 7 or 10 years) and 111(4) to (5.5) (an acquisition of control) are not encoded.
-/

namespace Canteen.ITA.NonCapitalLoss

open CapitalGains (HalfCents formatHalfCents)

/-- The amounts in the 111(8) formula for one taxation year. -/
structure Facts where
  taxationYear : Nat
  /-- E (a): losses from an office, employment, business or property, in cents. -/
  sourceLosses : Cents := 0
  /-- E (b): the Division C amounts listed (111(1)(b), 110.6, 110(1)(d) to (g), (k), 112, 113(1), ...), in half-cents. -/
  divisionC : HalfCents := 0
  /-- E (c): the year's allowable business investment loss. -/
  abil : HalfCents := 0
  /-- F: the amount under 3(c). -/
  para3c : HalfCents
  /-- D, D.1 and D.2. -/
  reductions : HalfCents := 0
  deriving Repr, Inhabited

/-- E, at the start of the given taxation year: the ABIL counts only before the eleventh following year. -/
def e (f : Facts) (at_ : Nat) : HalfCents :=
  2 * f.sourceLosses + f.divisionC + (if at_ < f.taxationYear + 11 then f.abil else 0)

/-- The non-capital loss for the year, measured in the given taxation year. -/
def amountAt (f : Facts) (at_ : Nat) : HalfCents := e f at_ - f.para3c - f.reductions

/-- The non-capital loss for the year, at the end of the year. -/
def amount (f : Facts) : HalfCents := amountAt f f.taxationYear

/-- A non-capital loss carried over, with what is left of it (111(3)(a)). -/
structure Loss where
  year : Nat
  unused : HalfCents
  deriving Repr, DecidableEq, Inhabited

/-- 111(1)(a): the 20 preceding and the 3 following taxation years. -/
def Loss.available (l : Loss) (year : Nat) : Bool :=
  (l.year < year && year ≤ l.year + 20) || (year < l.year && l.year ≤ year + 3)

/-- Insertion by year (structural, so that it computes in proofs). -/
def insertByYear (l : Loss) : List Loss → List Loss
  | [] => [l]
  | x :: xs => if l.year ≤ x.year then l :: x :: xs else x :: insertByYear l xs

def sortByYear : List Loss → List Loss
  | [] => []
  | x :: xs => insertByYear x (sortByYear xs)

/-- The losses available in the year, oldest first (111(3)(b)). -/
def queue (year : Nat) (losses : List Loss) : List Loss := sortByYear (losses.filter (·.available year))

def availableTotal (year : Nat) (losses : List Loss) : HalfCents := ((queue year losses).map (·.unused)).sum

/-- A claim applied to the losses in order: what is taken from each. -/
def take : HalfCents → List Loss → List HalfCents
  | _, [] => []
  | c, l :: ls => min c l.unused :: take (c - min c l.unused) ls

/-- 111(1)(a): the deduction for a claim of the given amount. -/
def deduction (year : Nat) (claim : HalfCents) (losses : List Loss) : HalfCents := (take claim (queue year losses)).sum

/-- What is left of each available loss after the year's claim. -/
def remaining (year : Nat) (claim : HalfCents) (losses : List Loss) : List Loss :=
  List.zipWith (fun l d => { l with unused := l.unused - d }) (queue year losses) (take claim (queue year losses))

def explain (year : Nat) (claim : HalfCents) (losses : List Loss) : Finding :=
  let h := formatHalfCents
  let used := ((queue year losses).zip (take claim (queue year losses))).filterMap fun (l, d) =>
    if d = 0 then none else some (⟨s!"From the non-capital loss of {l.year}: {h d} of {h l.unused}.", "ITA 111(1)(a); 111(3)"⟩ : Step)
  ⟨deduction year claim losses > 0,
    [⟨s!"Non-capital losses of the 20 years before {year} and the 3 after: {h (availableTotal year losses)}. Claimed: {h claim}, " ++
      "applied to the oldest first.", "ITA 111(1)(a); 111(3)(b)"⟩] ++ used ++
    [⟨s!"Deducted: {h (deduction year claim losses)}.", "ITA 111(1)(a)"⟩], []⟩

/-! ## Truths -/

private theorem min_step (c u r : Nat) : min c u + min (c - min c u) r = min c (u + r) := by omega

/-- A claim takes the lesser of itself and the losses available. -/
theorem take_sum (c : HalfCents) (ls : List Loss) : (take c ls).sum = min c (ls.map (·.unused)).sum := by
  induction ls generalizing c with
  | nil => simp [take]
  | cons l ls ih => simp only [take, List.sum_cons, List.map_cons, ih]; exact min_step _ _ _

theorem deduction_eq (year : Nat) (claim : HalfCents) (losses : List Loss) :
    deduction year claim losses = min claim (availableTotal year losses) := take_sum _ _

/-- Never more than claimed, nor more than the losses available. -/
theorem deduction_le_claim (year : Nat) (claim : HalfCents) (losses : List Loss) : deduction year claim losses ≤ claim := by
  rw [deduction_eq]; exact Nat.min_le_left _ _

theorem deduction_le_available (year : Nat) (claim : HalfCents) (losses : List Loss) :
    deduction year claim losses ≤ availableTotal year losses := by
  rw [deduction_eq]; exact Nat.min_le_right _ _

theorem take_zero (ls : List Loss) : (take 0 ls).sum = 0 := by
  rw [take_sum]; exact Nat.zero_min _

private theorem used_up (c u : Nat) (h : 0 < c - min c u) : min c u = u := by omega

/-- 111(3)(b): a later loss is drawn on only once the earlier one is used up. -/
theorem earlier_first (c : HalfCents) (l : Loss) (ls : List Loss) (h : 0 < (take (c - min c l.unused) ls).sum) :
    min c l.unused = l.unused := by
  apply used_up
  apply Nat.pos_of_ne_zero
  intro h0
  rw [h0, take_zero] at h
  exact Nat.lt_irrefl _ h

/-- A loss of the same year, or one more than 20 years old, cannot be deducted. -/
theorem not_same_year (l : Loss) : l.available l.year = false := by
  simp [Loss.available]

theorem expired (l : Loss) (year : Nat) (h : l.year + 20 < year) : l.available year = false := by
  simp only [Loss.available]
  have h1 : ¬ year ≤ l.year + 20 := by omega
  have h2 : ¬ year < l.year := by omega
  simp [h1, h2]

/-- No losses from sources, no listed deductions, no ABIL: no non-capital loss. -/
theorem no_losses (f : Facts) (h : f.sourceLosses = 0 ∧ f.divisionC = 0 ∧ f.abil = 0) : amount f = 0 := by
  obtain ⟨h1, h2, h3⟩ := h
  simp [amount, amountAt, e, h1, h2, h3]

end Canteen.ITA.NonCapitalLoss

import Canteen.Core.Finding
import Canteen.Core.Money

/-!
# Subsection 117(2): the federal rates for individuals

*Income Tax Act*, as consolidated to 2026-10-29 (verbatim in `statute/ITA-117-2.txt`):

> (2) The tax payable under this Part by an individual on the individual's taxable income … (the
> "amount taxable") for a taxation year is (a) 14% of the amount taxable, if [it] is equal to or less
> than the amount determined for the taxation year in respect of $57,375; (b) if [it] is greater than
> $57,375, but is equal to or less than $114,750, the maximum amount determinable … under paragraph
> (a), plus 20.5% of the amount by which [it] exceeds $57,375 …; (c) … $177,882 … 26% …; (d) …
> $253,414 … 29% …; and (e) if [it] is greater than $253,414, the maximum amount determinable … under
> paragraph (d), plus 33% of the amount by which [it] exceeds $253,414 for the year.

The bracket amounts are for 2025; for later years they are indexed under 117.1(1), and the indexed
amounts are given (in an individual's year, the year's from `YearAmounts`). The rates are those of the consolidated text; any transitional rate for 2025 in
the amending Act (an application provision, not in the consolidated text) is not applied. The tax is
computed on the whole amount, in hundredths of a basis point of cents, and rounded down to the cent.
-/

namespace Canteen.ITA.Rates

/-- The bracket thresholds, in cents. -/
structure Brackets where
  first : Cents := 5737500
  second : Cents := 11475000
  third : Cents := 17788200
  fourth : Cents := 25341400
  deriving Repr, DecidableEq, Inhabited

/-- The rates, in basis points: 14%, 20.5%, 26%, 29%, 33%. -/
def rates : List Nat := [1400, 2050, 2600, 2900, 3300]

/-- The part of `x` between `lo` and `hi`. -/
def slice (x lo hi : Nat) : Nat := min x hi - lo

/-- The five slices of the amount taxable. -/
def slices (b : Brackets) (x : Cents) : List Nat :=
  [slice x 0 b.first, slice x b.first b.second, slice x b.second b.third, slice x b.third b.fourth, x - b.fourth]

/-- Subsection 117(2): the tax on the amount taxable, in cents. -/
def tax (x : Cents) (b : Brackets := {}) : Cents :=
  ((slices b x).zip rates |>.map fun (s, r) => s * r).sum / 10000

def explain (x : Cents) (b : Brackets := {}) : Finding :=
  ⟨tax x b > 0, [⟨s!"On an amount taxable of {formatCents x}, the tax under subsection 117(2) is {formatCents (tax x b)}: " ++
    s!"14% to {formatCents b.first}, 20.5% to {formatCents b.second}, 26% to {formatCents b.third}, 29% to " ++
    s!"{formatCents b.fourth}, and 33% above.", "ITA 117(2)"⟩], []⟩

/-! ## Truths about the rates -/

theorem slice_mono (lo hi x y : Nat) (h : x ≤ y) : slice x lo hi ≤ slice y lo hi :=
  Nat.sub_le_sub_right (Nat.le_min.mpr ⟨Nat.le_trans (Nat.min_le_left _ _) h, Nat.min_le_right _ _⟩) _

private theorem weighted_mono (b : Brackets) (x y : Nat) (h : x ≤ y) :
    ((slices b x).zip rates |>.map fun (s, r) => s * r).sum ≤ ((slices b y).zip rates |>.map fun (s, r) => s * r).sum := by
  simp only [slices, rates, List.zip_cons_cons, List.zip_nil_right, List.map_cons, List.map_nil, List.sum_cons, List.sum_nil]
  have := slice_mono 0 b.first x y h
  have := slice_mono b.first b.second x y h
  have := slice_mono b.second b.third x y h
  have := slice_mono b.third b.fourth x y h
  have : x - b.fourth ≤ y - b.fourth := Nat.sub_le_sub_right h _
  apply Nat.add_le_add (Nat.mul_le_mul_right _ ‹_›)
  apply Nat.add_le_add (Nat.mul_le_mul_right _ ‹_›)
  apply Nat.add_le_add (Nat.mul_le_mul_right _ ‹_›)
  apply Nat.add_le_add (Nat.mul_le_mul_right _ ‹_›)
  exact Nat.add_le_add (Nat.mul_le_mul_right _ ‹_›) (Nat.le_refl _)

/-- **More income, never less tax.** -/
theorem tax_mono (b : Brackets) (x y : Cents) (h : x ≤ y) : tax x b ≤ tax y b :=
  Nat.div_le_div_right (weighted_mono b x y h)

end Canteen.ITA.Rates

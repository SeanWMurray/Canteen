import Canteen.ITA.S117.Rates

/-!
# Section 118.1: the charitable donation credit

*Income Tax Act*, as consolidated to 2026-10-29 (verbatim in `statute/ITA-118.1-donations.txt`):

**"total charitable gifts"**: the eligible amounts of gifts to qualified donees made by the individual
(or spouse) in the year or the five preceding years, not yet deducted.

**"total gifts"**: the least of the total charitable gifts and, (ii) in the year of death and the year
before, the individual's income, or (iii) otherwise, the lesser of income and 0.75A + 0.25(B + C + D
− E): A the income; B the taxable capital gains on gifts (in proportion to the eligible amount); C
40(1.01) gains; D recapture on gifts of depreciable property; E [a reduction].

**118.1(3)** The credit is A × B + C × D + E × F: A the appropriate percentage (14%), B the lesser of
$200 and total gifts; C the highest individual percentage (33%), D the lesser of total gifts over
$200 and the amount taxable over the 117(2)(e) threshold; E 29%, F total gifts over $200 and D.

The gains and recapture in B to D are given, and E is nil. The credit is rounded down to the cent.
Not encoded: the eligible amount (248(31)) and the split-receipting rules, cultural and ecological
gifts, and 118.1(5) to (13).
-/

namespace Canteen.ITA.Donations

structure Facts where
  /-- "total charitable gifts": the year's gifts and those of the five preceding years not yet deducted. -/
  charitableGifts : Cents
  /-- The individual's income for the year. -/
  income : Cents
  /-- The amount taxable (taxable income) for 117(2). -/
  amountTaxable : Cents
  /-- The year of death or the year before. -/
  deathYear : Bool := false
  /-- B, C, D: taxable capital gains on gifts, 40(1.01) gains, and recapture on gifts. -/
  giftGains : Cents := 0
  brackets : Rates.Brackets := {}
  deriving Repr, DecidableEq, Inhabited

/-- "total gifts". -/
def totalGifts (f : Facts) : Cents :=
  if f.deathYear then min f.charitableGifts f.income
  else min f.charitableGifts (min f.income ((3 * f.income + f.giftGains) / 4))

/-- 118.1(3) D: the gifts above $200 matched by taxable income in the top bracket. -/
def topSlice (f : Facts) : Cents := min (totalGifts f - 20000) (f.amountTaxable - f.brackets.fourth)

/-- 118.1(3): the credit. -/
def credit (f : Facts) : Cents :=
  (min 20000 (totalGifts f) * 1400 + topSlice f * 3300 + (totalGifts f - 20000 - topSlice f) * 2900) / 10000

/-- The gifts carried forward: those not within "total gifts" this year. -/
def carriedForward (f : Facts) : Cents := f.charitableGifts - totalGifts f

def explain (f : Facts) : Finding :=
  let c := formatCents
  ⟨credit f > 0, [
    ⟨s!"Total gifts for the year are {c (totalGifts f)} of {c f.charitableGifts} given" ++
      (if carriedForward f > 0 then s!"; {c (carriedForward f)} can be carried forward." else "."),
      "ITA 118.1(1) \"total gifts\""⟩,
    ⟨s!"The credit is 14% of the first $200, 33% of {c (topSlice f)} (matched by income in the top bracket), and 29% of the " ++
      s!"rest: {c (credit f)}.", "ITA 118.1(3)"⟩], []⟩

/-! ## Truths about the donation credit -/

/-- Total gifts never exceed the income for the year. -/
theorem totalGifts_le_income (f : Facts) : totalGifts f ≤ f.income := by
  unfold totalGifts; split
  · exact Nat.min_le_right _ _
  · exact Nat.le_trans (Nat.min_le_right _ _) (Nat.min_le_left _ _)

/-- In the year of death, gifts up to all of the income count. -/
theorem death_year (f : Facts) (h : f.deathYear = true) (hg : f.charitableGifts ≤ f.income) : totalGifts f = f.charitableGifts := by
  simp [totalGifts, h, Nat.min_eq_left hg]

end Canteen.ITA.Donations

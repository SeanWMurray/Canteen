import Canteen.ITA.S38.CapitalGains

/-!
# Subsection 43(1): disposing of part of a property

*Income Tax Act*, as consolidated to 2026-10-29 (verbatim in `statute/ITA-43-1.txt`):

> (1) For the purpose of computing a taxpayer's gain or loss for a taxation year from the
> disposition of part of a property, the adjusted cost base to the taxpayer, immediately before the
> disposition, of that part is the portion of the adjusted cost base to the taxpayer at that time of
> the whole property that can reasonably be regarded as attributable to that part.

What "can reasonably be regarded as attributable" to the part is a question of judgment; the usual
measure is relative fair market value (for example, an acre sold from a farm worth more per acre
near the road). The portion is given as a share of the whole, by value unless stated, and rounded
down to the cent; the rest of the cost stays with the part kept. Identical properties are not
"part of a property": 47(1) averages them instead.
-/

namespace Canteen.ITA.PartialDisposition

structure Facts where
  /-- The part disposed of, e.g. `"5 acres of the farm"`. -/
  description : String
  /-- The adjusted cost base of the whole property immediately before. -/
  adjustedCostBase : Cents
  /-- The measure of the part and of the whole (by default, their fair market values). -/
  partMeasure : Nat
  wholeMeasure : Nat
  /-- Whether that measure is how much of the cost can reasonably be regarded as attributable to the
  part. Often a judgment call where the parts differ in kind or location. -/
  reasonable : Answer := .fact true
  proceeds : Cents
  outlaysAndExpenses : Cents := 0
  deriving Repr, Inhabited

/-- The portion of the cost attributable to the part, rounded down. -/
def partCost (f : Facts) : Cents :=
  if f.wholeMeasure = 0 then 0 else f.adjustedCostBase * min f.partMeasure f.wholeMeasure / f.wholeMeasure

/-- The cost left with the part kept. -/
def remainingCost (f : Facts) : Cents := f.adjustedCostBase - partCost f

def disposition (f : Facts) : CapitalGains.Disposition :=
  { description := f.description, proceeds := f.proceeds, adjustedCostBase := partCost f,
    outlaysAndExpenses := f.outlaysAndExpenses }

def explain (f : Facts) : Finding :=
  ⟨true, [⟨s!"The adjusted cost base of {f.description} is the portion of the whole's {formatCents f.adjustedCostBase} " ++
      s!"reasonably attributable to it ({f.partMeasure} of {f.wholeMeasure}): {formatCents (partCost f)}; " ++
      s!"{formatCents (remainingCost f)} stays with the rest.", "ITA 43(1)"⟩], f.reasonable.judgments⟩

/-! ## Truths about partial dispositions -/

theorem partCost_le (f : Facts) : partCost f ≤ f.adjustedCostBase := by
  unfold partCost; split
  · exact Nat.zero_le _
  · rename_i h
    exact Nat.div_le_of_le_mul (by rw [Nat.mul_comm f.wholeMeasure]; exact Nat.mul_le_mul_left _ (Nat.min_le_right _ _))

/-- Nothing is lost: the part's cost and the cost kept add up to the whole. -/
theorem costs_add_up (f : Facts) : partCost f + remainingCost f = f.adjustedCostBase := by
  unfold remainingCost
  exact Nat.add_sub_cancel' (partCost_le f)

end Canteen.ITA.PartialDisposition

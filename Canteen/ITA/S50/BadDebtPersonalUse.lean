import Canteen.Core.StatuteSyntax
import Canteen.Core.Answer
import Canteen.Core.Money

/-!
# Subsection 50(2): a personal-use debt that goes bad

*Income Tax Act*, subsection 50(2), as consolidated to 2026-10-29 (verbatim in
`statute/ITA-50-2.txt`):

> (2) Where at the end of a taxation year a debt that is a personal-use property of a taxpayer
> is owing to the taxpayer by a person with whom the taxpayer deals at arm's length and is
> established by the taxpayer to have become a bad debt in the year,
> (a) the taxpayer shall be deemed to have disposed of it at the end of the year for proceeds
> equal to the amount, if any, by which (i) its adjusted cost base to the taxpayer immediately
> before the end of the year exceeds (ii) the amount of the taxpayer's gain, if any, from the
> disposition of the personal-use property the proceeds of disposition of which included the
> debt; and
> (b) the taxpayer shall be deemed to have reacquired the debt immediately after the end of
> the year at a cost equal to the amount of the proceeds determined under paragraph 50(2)(a).

The effect, proven below: the loss on the bad debt is never more than the gain on the sale
that gave rise to it (`loss_eq_min`). Subparagraph 40(2)(g)(iii) excludes such a debt from the
denial of losses on personal-use property, so that loss is allowed.
-/

namespace Canteen.ITA.BadDebtPersonalUse

/-- The facts subsection 50(2) needs. -/
structure Facts where
  /-- The debt is personal-use property of the taxpayer (for example, a debt owing in respect
  of the disposition of personal-use property: section 54, "personal-use property" (b)). -/
  personalUse : Bool
  /-- It is owing by a person with whom the taxpayer deals at arm's length (section 251). -/
  debtorArmsLength : Answer
  /-- The taxpayer establishes that it became a bad debt in the year. -/
  badDebt : Answer
  /-- (a)(i) Its adjusted cost base immediately before the end of the year. -/
  adjustedCostBase : Cents
  /-- (a)(ii) The taxpayer's gain, if any, from the disposition of the personal-use property
  whose proceeds included the debt. -/
  gain : Cents
  deriving Repr, DecidableEq, Inhabited

/-- Subsection 50(2) applies. -/
statute rule (f : Facts) named "subsection 50(2)" cites "ITA 50(2)"
  applies where
    | "personal-use property" f.personalUse
        => "The debt is personal-use property of the taxpayer."
        else "The debt is not personal-use property of the taxpayer."
    | "arm's length" judgments (f.debtorArmsLength.judgments) f.debtorArmsLength.value
        => "It is owing by a person with whom the taxpayer deals at arm's length."
        else "It is not owing by a person with whom the taxpayer deals at arm's length."
    | "bad debt" judgments (f.badDebt.judgments) f.badDebt.value
        => "The taxpayer establishes that it became a bad debt in the year."
        else "The taxpayer does not establish that it became a bad debt in the year."

/-- (a): the deemed proceeds, the amount, if any, by which (i) exceeds (ii). -/
def deemedProceeds (f : Facts) : Cents := f.adjustedCostBase - f.gain

/-- (b): the cost at which the debt is deemed reacquired. -/
def reacquisitionCost (f : Facts) : Cents := deemedProceeds f

/-- The loss on the deemed disposition. -/
def loss (f : Facts) : Cents := f.adjustedCostBase - deemedProceeds f

/-- The loss is the lesser of the debt's cost and the gain on the sale that gave rise to it. -/
theorem loss_eq_min (f : Facts) : loss f = min f.adjustedCostBase f.gain := by
  show f.adjustedCostBase - (f.adjustedCostBase - f.gain) = min f.adjustedCostBase f.gain
  by_cases h : f.adjustedCostBase ≤ f.gain
  · rw [Nat.sub_eq_zero_of_le h, Nat.sub_zero, Nat.min_eq_left h]
  · have h' : f.gain ≤ f.adjustedCostBase := Nat.le_of_lt (Nat.lt_of_not_le h)
    rw [Nat.sub_sub_self h', Nat.min_eq_right h']

/-- So the loss never exceeds the gain. -/
theorem loss_le_gain (f : Facts) : loss f ≤ f.gain := by
  rw [loss_eq_min]; exact Nat.min_le_right _ _

/-- Where there was no gain, there is no loss: the deemed proceeds are the whole cost. -/
theorem loss_of_no_gain (f : Facts) (h : f.gain = 0) : loss f = 0 := by
  rw [loss_eq_min, h]; simp

end Canteen.ITA.BadDebtPersonalUse

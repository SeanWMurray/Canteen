import Canteen.ITA.S50.BadDebtPersonalUse
import Canteen.ITA.S40.Paragraph40_2_g

/-!
# Tests: subsection 50(2), with paragraph 40(2)(g)

A cottage (personal-use property) is sold to an arm's length buyer at a gain, for proceeds that
include a $50,000.00 note. The note goes bad. Constructed examples.
-/

namespace Canteen.Tests.BadDebt

open Canteen Canteen.ITA

def note (gain : Cents) : BadDebtPersonalUse.Facts :=
  { personalUse := true, debtorArmsLength := .fact true, badDebt := .fact true,
    adjustedCostBase := 5000000, gain := gain }

example : BadDebtPersonalUse.rule.holds (note 10000000) = true := by decide
-- A $100,000 gain on the cottage: deemed proceeds nil, the whole $50,000 is the loss.
example : BadDebtPersonalUse.deemedProceeds (note 10000000) = 0 ∧ BadDebtPersonalUse.loss (note 10000000) = 5000000 := by
  decide
-- A $20,000 gain: deemed proceeds $30,000, and the loss is capped at the gain.
example : BadDebtPersonalUse.deemedProceeds (note 2000000) = 3000000 ∧ BadDebtPersonalUse.loss (note 2000000) = 2000000 := by
  decide
-- No gain: no loss.
example : BadDebtPersonalUse.loss (note 0) = 0 := by decide
-- Not owing by an arm's length person, or not established as bad: 50(2) does not apply.
example : BadDebtPersonalUse.rule.holds { note 0 with debtorArmsLength := .fact false } = false := by decide
example : BadDebtPersonalUse.rule.holds { note 0 with badDebt := .judged "J-BAD" false } = false := by decide
#guard (BadDebtPersonalUse.rule.explain { note 0 with badDebt := .judged "J-BAD" true }).reliesOn == ["J-BAD"]

/-- The deemed disposition, under paragraph 40(2)(g). -/
def underParagraph (n : BadDebtPersonalUse.Facts) : Paragraph40_2_g.Facts :=
  { sl := ⟨{ description := "the note", date := ⟨2025, 12, 31⟩, proceeds := BadDebtPersonalUse.deemedProceeds n,
             adjustedCostBase := n.adjustedCostBase, outlaysAndExpenses := 0 }, []⟩,
    debt := { isDebtOrRight := true, considerationForCapitalProperty := true, armsLength := n.debtorArmsLength },
    personalUse := { debtForPersonalUseProperty := true,
                     debtReferredTo50_2 := BadDebtPersonalUse.rule.holds n } }

-- Subparagraph (iii) does not deny the loss (a debt referred to in 50(2)), and (ii) does not
-- either (consideration for capital property sold at arm's length): the loss stands.
example : Paragraph40_2_g.paragraph.holds (underParagraph (note 2000000)) = false := by decide
example : Paragraph40_2_g.deniedLoss (underParagraph (note 2000000)) = 0 := by decide
-- Had the buyer not dealt at arm's length, 50(2) would not apply, the debt would be
-- personal-use property within (iii), and the loss would be nil.
example : Paragraph40_2_g.paragraph.holds (underParagraph { note 2000000 with debtorArmsLength := .fact false }) = true := by
  decide

end Canteen.Tests.BadDebt

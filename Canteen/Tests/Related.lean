import Canteen.ITA.S53.CostAddition
import Canteen.ITA.S251_1.Affiliation
import Canteen.Transactions.SpouseRepurchase
import Canteen.Transactions.SiblingAndLateRepurchase

/-!
# Tests: paragraph 53(1)(f), paragraph 251.1(1)(a), and the two transactions
-/

namespace Canteen.Tests.Related

open Canteen Canteen.ITA

/-! ## Paragraph 53(1)(f) -/

def base : CostAddition.Facts :=
  { owner := "the taxpayer's spouse", property := "100 common shares of ABC Ltd.", cost := 105000,
    substitutedProperty := true, superficialLoss := 50999 }

example : CostAddition.addition base = 50999 := rfl
example : CostAddition.adjustedCostBase base = 155999 := rfl
example : CostAddition.addition { base with stopLossAmount := 999 } = 50000 := rfl     -- (i) less (ii)
example : CostAddition.addition { base with stopLossAmount := 60000 } = 0 := rfl       -- (ii) exceeds (i)
example : CostAddition.addition { base with substitutedProperty := false } = 0 := rfl
example : CostAddition.rule.holds base = true := rfl
example : CostAddition.rule.holds { base with stopLossAmount := 50999 } = false := rfl  -- equal: nothing added

#guard CostAddition.rule.explainText base ==
  "1. The 100 common shares of ABC Ltd. owned by the taxpayer's spouse are substituted property of the taxpayer's spouse, within the meaning of paragraph (a) of the definition \"superficial loss\" in section 54. [ITA 53(1)(f)]\n" ++
  "2. The loss that was a superficial loss because of the acquisition by the taxpayer's spouse is $509.99; the amount described in subparagraph (ii) is $0.00. [ITA 53(1)(f)(i), (ii)]\n" ++
  "3. So $509.99 is added to the cost of the property: its adjusted cost base to the taxpayer's spouse is $1,050.00 + $509.99 = $1,559.99. [ITA 53(1)(f)]"

/-! ## Paragraph 251.1(1)(a) -/

example : Affiliation.affiliated.holds ⟨true, true, .fact false⟩ = true := rfl     -- spouses
example : Affiliation.affiliated.holds ⟨true, false, .fact false⟩ = false := rfl   -- siblings
example : Affiliation.affiliated.holds ⟨true, false, .fact true⟩ = true := rfl     -- another paragraph
example : Affiliation.affiliated.holds ⟨false, true, .fact false⟩ = false := rfl   -- not an individual
example : Affiliation.acquirer "X" ⟨true, true, .fact false⟩ = .affiliated "X" := rfl
example : Affiliation.acquirer "X" ⟨true, false, .fact false⟩ = .notAffiliated "X" := rfl
example : Affiliation.acquirer "X" ⟨true, false, .judged "J" true⟩ = .judged "X" ["J"] true := rfl
#guard (Affiliation.affiliated.explain ⟨true, false, .judged "J" true⟩).reliesOn == ["J"]

#guard Affiliation.affiliated.explainText ⟨true, true, .fact false⟩ ==
  "1. The first person is an individual. [ITA 251.1(1)(a)]\n" ++
  "2. The second person is a spouse or common-law partner of the individual. [ITA 251.1(1)(a)]\n" ++
  "3. Therefore paragraph 251.1(1)(a) applies. [ITA 251.1(1)(a)]\n" ++
  "4. Therefore affiliation under subsection 251.1(1) applies. [ITA 251.1(1)]"

/-! ## The transactions -/

open Transactions in
example : SuperficialLoss.superficialLoss (SpouseRepurchase.facts SpouseRepurchase.position) = true :=
  SpouseRepurchase.superficial_on_position

-- The sibling transaction on every branch, by computation as well as by the lemmas.
open Transactions.SiblingAndLateRepurchase in
example : ∀ b₁ b₂ : Bool, SuperficialLoss.superficialLoss ⟨sale, [siblingPurchase b₁, lateRepurchase b₂]⟩ = false := by
  decide

-- One day earlier, the repurchase would make the loss superficial.
open Transactions.SiblingAndLateRepurchase in
example : SuperficialLoss.superficialLoss
    ⟨sale, [{ lateRepurchase true with date := ⟨2025, 4, 2⟩ }]⟩ = true := by decide

end Canteen.Tests.Related

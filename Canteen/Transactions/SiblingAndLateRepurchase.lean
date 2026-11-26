import Canteen.ITA.S54.SuperficialLoss
import Canteen.ITA.S40.LossDenial
import Canteen.ITA.S251_1.Affiliation
import Canteen.Lemmas.SuperficialLoss
import Canteen.Core.Branch

/-!
# Layer 3: a sibling buys in the period, and the taxpayer buys back on day 31

A constructed transaction where the loss stands, whatever the answers to the identity
judgment calls. The proof reuses the Layer 2 lemmas: the sibling is not affiliated, so the
sibling's purchase never matters; the taxpayer's repurchase falls outside the period, so it
never matters either.

* 2025-03-03: the taxpayer sells 50 common shares of DEF Inc. for $2,000.00. Adjusted cost
  base $3,000.00.
* 2025-03-10: the taxpayer's sibling buys 50 common shares of DEF Inc., and still holds them
  at the end of the period.
* 2025-04-03 (day 31): the taxpayer buys 50 common shares of DEF Inc. back.
-/

namespace Canteen.Transactions.SiblingAndLateRepurchase

open Canteen Canteen.ITA Canteen.ITA.SuperficialLoss

/-! ## Facts -/

def sale : Disposition :=
  { description := "50 common shares of DEF Inc.", date := ⟨2025, 3, 3⟩,
    proceeds := 200000, adjustedCostBase := 300000, outlaysAndExpenses := 0 }

/-- Two individuals who are siblings: not spouses or common-law partners, and no other
paragraph of 251.1(1) applies. -/
def siblingRelation : Affiliation.Facts :=
  { individual := true, spouseOrCommonLawPartner := false }

def siblingPurchase (identical : Bool) : Acquisition :=
  { description := "50 common shares of DEF Inc.", date := ⟨2025, 3, 10⟩,
    acquirer := Affiliation.acquirer "the taxpayer's sibling" siblingRelation,
    identity := .identical "J-SIB" identical, heldAtEndOfPeriod := true }

def lateRepurchase (identical : Bool) : Acquisition :=
  { description := "50 common shares of DEF Inc.", date := ⟨2025, 4, 3⟩,
    acquirer := .taxpayer, identity := .identical "J-LATE" identical, heldAtEndOfPeriod := true }

def calls : List JudgmentCall :=
  [{ id := "J-SIB", question := "Are the sibling's shares identical to the shares sold?",
     riskIfYes := .low, riskIfNo := .high },
   { id := "J-LATE", question := "Are the shares bought back identical to the shares sold?",
     riskIfYes := .low, riskIfNo := .high }]

def facts (branch : List Judgment) : SuperficialLoss.Facts :=
  ⟨sale, [siblingPurchase (answerOf branch "J-SIB"), lateRepurchase (answerOf branch "J-LATE")]⟩

/-- The taxpayer is an individual: the foreign affiliate carve-out in 40(2)(g) is not engaged. -/
def surplusCarveOut : Bool := false

def denialFacts (branch : List Judgment) : LossDenial.Facts :=
  ⟨facts branch, surplusCarveOut⟩

/-! ## Analysis -/

theorem loss_amount : isLoss sale = true ∧ lossAmount sale = 100000 := by decide

/-- Siblings are not affiliated under subsection 251.1(1). -/
theorem sibling_not_affiliated : Affiliation.affiliated.holds siblingRelation = false :=
  (Affiliation.individuals_not_spouses _ rfl).trans rfl

theorem sibling_acquirer (b : Bool) :
    (siblingPurchase b).acquirer = .notAffiliated "the taxpayer's sibling" := by
  cases b <;> rfl

/-- The period runs from 2025-02-01 to 2025-04-02, so a purchase on 2025-04-03 is outside it. -/
theorem repurchase_outside_period (b : Bool) : inPeriod sale (lateRepurchase b) = false := by
  cases b <;> decide

/-- The loss is not a superficial loss, however the identity judgment calls are answered.
Proven from the Layer 2 lemmas, not by computation. -/
theorem not_superficial (b₁ b₂ : Bool) :
    superficialLoss ⟨sale, [siblingPurchase b₁, lateRepurchase b₂]⟩ = false := by
  rw [not_affiliated_irrelevant _ _ _ _ (sibling_acquirer b₁),
      outside_period_irrelevant _ _ _ (repurchase_outside_period b₂)]
  exact not_of_no_acquisitions _ rfl

/-- The judgment calls don't matter: the result is the same on all four branches. -/
theorem same_on_every_branch : SuperficialLoss.rule.SameOnEveryBranch calls facts false :=
  fun _ _ => not_superficial _ _

/-- Subparagraph 40(2)(g)(i) denies nothing: the $1,000.00 loss stands. -/
theorem loss_stands (branch : List Judgment) :
    LossDenial.rule.holds (denialFacts branch) = false ∧ LossDenial.deniedLoss (denialFacts branch) = 0 := by
  have h := not_superficial (answerOf branch "J-SIB") (answerOf branch "J-LATE")
  simp only [LossDenial.rule_holds, LossDenial.deniedLoss, denialFacts, facts] at h ⊢
  simp [h]

end Canteen.Transactions.SiblingAndLateRepurchase

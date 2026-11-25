import Canteen.ITA.S54.SuperficialLoss
import Canteen.ITA.S40.LossDenial
import Canteen.Lemmas.SuperficialLoss
import Canteen.Core.Branch

/-!
# Layer 3: a taxpayer sells shares at a loss, and the spouse buys them back

A constructed transaction, analysed under section 54 "superficial loss" and subparagraph
40(2)(g)(i). Each step of the analysis is a theorem; the memo in
`Canteen/Blueprints/SpouseRepurchase.lean` links to them.

* 2025-06-15: the taxpayer sells 100 common shares of ABC Ltd. for $1,000.00. Adjusted cost
  base $1,500.00; commission $9.99.
* 2025-06-20: the taxpayer's spouse buys 100 common shares of ABC Ltd., and still holds
  them on 2025-07-15.
* Judgment call `J-ID`: are the spouse's shares identical to the shares sold?
-/

namespace Canteen.Transactions.SpouseRepurchase

open Canteen Canteen.ITA Canteen.ITA.SuperficialLoss

/-! ## Facts -/

/-- The taxpayer's sale. Nothing engages an exception in paragraphs (c) to (h). -/
def sale : Disposition :=
  { description := "100 common shares of ABC Ltd.", date := ⟨2025, 6, 15⟩,
    proceeds := 100000, adjustedCostBase := 150000, outlaysAndExpenses := 999 }

/-- The spouse's purchase. The spouse is affiliated with the taxpayer (paragraph
251.1(1)(a)); `identical` is the answer to judgment call `J-ID`. -/
def spousePurchase (identical : Bool) : Acquisition :=
  { description := "100 common shares of ABC Ltd.", date := ⟨2025, 6, 20⟩,
    acquirer := .affiliated "the taxpayer's spouse",
    identity := .identical "J-ID" identical, heldAtEndOfPeriod := true }

/-- The one judgment call. Shares of the same class of the same corporation are generally
regarded as identical, so answering "yes" is low risk and "no" high risk. -/
def calls : List JudgmentCall :=
  [{ id := "J-ID",
     question := "Are the spouse's 100 common shares of ABC Ltd. identical to the 100 common shares of ABC Ltd. the taxpayer sold?",
     riskIfYes := .low, riskIfNo := .high }]

/-- The facts on a branch. -/
def facts (branch : List Judgment) : SuperficialLoss.Facts :=
  ⟨sale, [spousePurchase (answerOf branch "J-ID")]⟩

/-- The facts for 40(2)(g)(i): an individual, so the foreign affiliate carve-out is not engaged. -/
def denialFacts (branch : List Judgment) : LossDenial.Facts :=
  ⟨facts branch, false⟩

/-- The position taken: the shares are identical. -/
def position : List Judgment :=
  [(calls.head!).assume true]

/-- The alternative: they are not. -/
def alternative : List Judgment :=
  [(calls.head!).assume false]

/-! ## Analysis -/

/-- The taxpayer has a loss of $509.99. -/
theorem loss_amount : isLoss sale = true ∧ lossAmount sale = 50999 := by decide

/-- The spouse's purchase falls in the period, and the spouse is affiliated with the taxpayer. -/
theorem purchase_in_period (b : Bool) :
    inPeriod sale (spousePurchase b) = true ∧
      (spousePurchase b).acquirer.isTaxpayerOrAffiliated = true := by
  cases b <;> decide

/-- If the shares are identical, the purchase meets paragraph (a). -/
theorem purchase_meets_a : paraA sale (spousePurchase true) = true := by decide

/-- Whatever the answer to `J-ID`, the purchase meets paragraph (b). -/
theorem purchase_meets_b (b : Bool) : paraB (spousePurchase b) = true := by
  cases b <;> rfl

/-- No exception in paragraphs (c) to (h) applies. -/
theorem no_exception : excepted sale = false := by decide

/-- On the position taken, the loss is a superficial loss. -/
theorem superficial_on_position : superficialLoss (facts position) = true :=
  (superficialLoss_iff _).mpr
    ⟨loss_amount.1, ⟨spousePurchase true, by decide, purchase_meets_a, purchase_meets_b true⟩, no_exception⟩

/-- On the position taken, subparagraph 40(2)(g)(i) makes the $509.99 loss nil. -/
theorem loss_nil_on_position :
    LossDenial.rule.holds (denialFacts position) = true ∧
      LossDenial.deniedLoss (denialFacts position) = 50999 := by decide

/-- On the alternative, the loss is not a superficial loss. -/
theorem not_superficial_on_alternative : superficialLoss (facts alternative) = false := by decide

/-- The outcome turns on `J-ID`: it is not the same on every branch. -/
theorem turns_on_identity :
    ¬ SuperficialLoss.rule.SameOnEveryBranch calls facts true ∧
    ¬ SuperficialLoss.rule.SameOnEveryBranch calls facts false := by decide

end Canteen.Transactions.SpouseRepurchase

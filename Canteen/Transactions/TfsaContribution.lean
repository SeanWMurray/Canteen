import Canteen.ITA.S40.Paragraph40_2_g
import Canteen.ITA.S251_1.Affiliation
import Canteen.Core.Branch

/-!
# Layer 3: shares contributed in kind to the taxpayer's TFSA at a loss

A constructed transaction under paragraph 40(2)(g) as a whole.

* 2025-09-02: the taxpayer contributes 80 common shares of JKL Corp. to the trust governed by
  the taxpayer's TFSA. They are worth $4,000.00 (the proceeds); their adjusted cost base is
  $5,000.00. The taxpayer is the TFSA's holder, so a beneficiary under it.
* The trust acquires the same shares that day and still holds them at the end of the period.
* Judgment call `J-AFF`: is the trust affiliated with the taxpayer, under one of paragraphs
  251.1(1)(b) to (g)? (A trust is an individual for the purposes of the Act, subsection 104(2),
  but it is not the taxpayer's spouse, so paragraph 251.1(1)(a) does not apply.)

The answer to `J-AFF` decides whether the loss is also a superficial loss under subparagraph
(i). It does not decide the outcome: clause (iv)(A) makes the loss nil either way, on the
facts alone.
-/

namespace Canteen.Transactions.TfsaContribution

open Canteen Canteen.ITA Canteen.ITA.SuperficialLoss Canteen.ITA.Paragraph40_2_g

/-! ## Facts -/

def contribution : Disposition :=
  { description := "80 common shares of JKL Corp.", date := ⟨2025, 9, 2⟩,
    proceeds := 400000, adjustedCostBase := 500000, outlaysAndExpenses := 0 }

/-- The property went to the trust governed by the taxpayer's TFSA, of which the taxpayer is a beneficiary. -/
def transferFacts : TransferFacts :=
  { plan := .tfsa, taxpayerBeneficiary := true }

/-- The trust is an individual (subsection 104(2)) but not the taxpayer's spouse; whether
another paragraph of 251.1(1) applies is judgment call `J-AFF`. -/
def trustRelation (branch : List Judgment) : Affiliation.Facts :=
  { individual := true, spouseOrCommonLawPartner := false, otherParagraph := Answer.ofBranch "J-AFF" branch }

/-- The trust's acquisition of the same shares. -/
def trustAcquisition (branch : List Judgment) : Acquisition :=
  { description := "80 common shares of JKL Corp.", date := ⟨2025, 9, 2⟩,
    acquirer := Affiliation.acquirer "the trust governed by the taxpayer's TFSA" (trustRelation branch),
    identity := .same, heldAtEndOfPeriod := true }

def calls : List JudgmentCall :=
  [{ id := "J-AFF",
     question := "Is the trust governed by the taxpayer's TFSA affiliated with the taxpayer under one of paragraphs 251.1(1)(b) to (g)?",
     riskIfYes := .medium, riskIfNo := .medium }]

/-- The taxpayer is an individual: the foreign affiliate carve-out is not engaged. -/
def surplusCarveOut : Bool := false

def facts (branch : List Judgment) : Paragraph40_2_g.Facts :=
  { sl := ⟨contribution, [trustAcquisition branch]⟩, surplusExcludedProperty := surplusCarveOut,
    transfer := some transferFacts }

def affiliatedBranch : List Judgment := [(calls.head!).assume true]
def notAffiliatedBranch : List Judgment := [(calls.head!).assume false]

/-! ## Analysis -/

theorem loss_amount : isLoss contribution = true ∧ lossAmount contribution = 100000 := by decide

/-- Clause (iv)(A) applies on every branch: a loss on property disposed of to a TFSA trust
under which the taxpayer is a beneficiary. -/
theorem iv_applies (branch : List Judgment) : planTransferLoss.holds (facts branch) = true :=
  planTransferLoss_tfsa _ loss_amount.1 transferFacts rfl rfl rfl

/-- Whether the loss is also a superficial loss turns on `J-AFF`. -/
theorem superficial_iff_affiliated :
    superficialLoss (facts affiliatedBranch).sl = true ∧ superficialLoss (facts notAffiliatedBranch).sl = false := by
  decide

/-- Paragraph 40(2)(g) makes the loss nil on every branch: `J-AFF` doesn't matter. -/
theorem nil_on_every_branch : paragraph.SameOnEveryBranch calls facts true := by
  decide

/-- The whole $1,000.00 loss is nil, on either answer. -/
theorem denied_loss (branch : List Judgment) : deniedLoss (facts branch) = 100000 := by
  have h : paragraph.holds (facts branch) = true := by
    rw [paragraph_holds, iv_applies]
    simp [facts, surplusCarveOut]
  simp only [deniedLoss, h, ↓reduceIte]
  exact loss_amount.2

/-- The explanation rests on the facts alone, citing (iv) rather than (i), on either answer. -/
theorem explanation_factual :
    (paragraph.explain (facts affiliatedBranch)).isFactual = true ∧
      (paragraph.explain (facts notAffiliatedBranch)).isFactual = true := by
  decide

end Canteen.Transactions.TfsaContribution

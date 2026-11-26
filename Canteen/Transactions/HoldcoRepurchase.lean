import Canteen.ITA.S40.Paragraph40_2_g
import Canteen.ITA.S53.CostAddition
import Canteen.ITA.S251_1.AffiliatedPersons
import Canteen.Core.Branch

/-!
# Layer 3: shares sold at a loss and bought by a family holding company

A constructed transaction under section 54 "superficial loss", paragraph 40(2)(g),
paragraph 53(1)(f) and section 251.1.

* 2025-11-03: the taxpayer sells 500 common shares of MNO Ltd. for $10,000.00. Adjusted cost
  base $14,000.00.
* 2025-11-20: Holdco buys 500 common shares of MNO Ltd. for $10,100.00, and still holds them
  at the end of the period. The taxpayer and the taxpayer's spouse each own half of Holdco's
  voting shares, so together they control it.
* Judgment call `J-ID`: are Holdco's shares identical to the shares sold?

What if: had the taxpayer owned Holdco half and half with an unrelated friend instead, the two
would not be an affiliated group, and the outcome would turn on whether the taxpayer controls
Holdco de facto (judgment call `J-DEFACTO`).
-/

namespace Canteen.Transactions.HoldcoRepurchase

open Canteen Canteen.ITA Canteen.ITA.SuperficialLoss Canteen.ITA.AffiliatedPersons

/-! ## Facts -/

def taxpayer : Nat := 0
def spouse : Nat := 1
def holdco : Nat := 2
def friend : Nat := 3

/-- The family: the taxpayer and spouse, who together control Holdco. -/
def world : World :=
  { persons := [⟨taxpayer, "the taxpayer", .individual⟩, ⟨spouse, "the taxpayer's spouse", .individual⟩,
                ⟨holdco, "Holdco", .corporation⟩],
    spouses := [(taxpayer, spouse)],
    controls := [⟨holdco, .group [taxpayer, spouse], .fact true, false⟩] }

def sale : Disposition :=
  { description := "500 common shares of MNO Ltd.", date := ⟨2025, 11, 3⟩,
    proceeds := 1000000, adjustedCostBase := 1400000, outlaysAndExpenses := 0 }

def holdcoPurchase (identical : Bool) : Acquisition :=
  { description := "500 common shares of MNO Ltd.", date := ⟨2025, 11, 20⟩,
    acquirer := AffiliatedPersons.acquirer world taxpayer holdco,
    identity := .identical "J-ID" identical, heldAtEndOfPeriod := true }

def calls : List JudgmentCall :=
  [{ id := "J-ID", question := "Are Holdco's 500 common shares of MNO Ltd. identical to the shares sold?",
     riskIfYes := .low, riskIfNo := .high }]

def surplusCarveOut : Bool := false

/-- The facts for the superficial loss definition. -/
def slFacts (branch : List Judgment) : SuperficialLoss.Facts :=
  ⟨sale, [holdcoPurchase (answerOf branch "J-ID")]⟩

def facts (branch : List Judgment) : Paragraph40_2_g.Facts :=
  { sl := slFacts branch, surplusExcludedProperty := surplusCarveOut }

def position : List Judgment := [(calls.head!).assume true]

/-- What Holdco paid: $10,100.00. -/
def holdcoCost : Cents := 1010000

def holdcoCostFacts : CostAddition.Facts :=
  { owner := "Holdco", property := "500 common shares of MNO Ltd.", cost := holdcoCost,
    substitutedProperty := paraA sale (holdcoPurchase true) && paraB (holdcoPurchase true),
    superficialLoss := Paragraph40_2_g.deniedLoss (facts position) }

/-! ## Analysis -/

theorem loss_amount : isLoss sale = true ∧ lossAmount sale = 400000 := by decide

/-- Holdco is affiliated with the taxpayer: the spouses are an affiliated group (251.1(1)(a)),
and Holdco is controlled by that group (251.1(1)(b)(ii)). On the facts alone. -/
theorem holdco_affiliated :
    affiliated ⟨world, taxpayer, holdco⟩ = true ∧ (rule.explain ⟨world, taxpayer, holdco⟩).reliesOn = [] := by
  decide +kernel

theorem purchase_in_period (b : Bool) :
    inPeriod sale (holdcoPurchase b) = true ∧ (holdcoPurchase b).acquirer.isTaxpayerOrAffiliated = true := by
  cases b <;> decide +kernel

theorem no_exception : excepted sale = false := by decide

theorem superficial_on_position : superficialLoss (slFacts position) = true := by decide +kernel

/-- Paragraph 40(2)(g) makes the $4,000.00 loss nil. -/
theorem loss_nil_on_position :
    Paragraph40_2_g.paragraph.holds (facts position) = true ∧ Paragraph40_2_g.deniedLoss (facts position) = 400000 := by
  decide +kernel

theorem turns_on_identity :
    ¬ Paragraph40_2_g.paragraph.SameOnEveryBranch calls facts true ∧
    ¬ Paragraph40_2_g.paragraph.SameOnEveryBranch calls facts false := by decide +kernel

/-- Under 53(1)(f), the $4,000.00 is added to Holdco's $10,100.00 cost: $14,100.00. -/
theorem holdco_adjusted_cost_base :
    CostAddition.addition holdcoCostFacts = 400000 ∧ CostAddition.adjustedCostBase holdcoCostFacts = 1410000 := by
  decide +kernel

/-! ## What if Holdco were owned with an unrelated friend -/

/-- The taxpayer and a friend each own half of Holdco: together they control it (de jure), but
they are not an affiliated group. Whether the taxpayer alone controls it de facto is
judgment call `J-DEFACTO`. -/
def friendWorld (branch : List Judgment) : World :=
  { persons := [⟨taxpayer, "the taxpayer", .individual⟩, ⟨friend, "a friend", .individual⟩,
                ⟨holdco, "Holdco", .corporation⟩],
    controls := [⟨holdco, .group [taxpayer, friend], .fact true, false⟩,
                 { corporation := holdco, controller := .person taxpayer, answer := Answer.ofBranch "J-DEFACTO" branch,
                   deFactoOnly := true }] }

def friendCalls : List JudgmentCall :=
  [{ id := "J-DEFACTO", question := "Does the taxpayer alone control Holdco, directly or indirectly in any manner whatever?",
     riskIfYes := .medium, riskIfNo := .medium }]

def friendFacts (branch : List Judgment) : SuperficialLoss.Facts :=
  ⟨sale, [{ holdcoPurchase true with acquirer := AffiliatedPersons.acquirer (friendWorld branch) taxpayer holdco }]⟩

/-- With the friend, the loss is superficial only if the taxpayer controls Holdco de facto. -/
theorem friend_turns_on_defacto :
    superficialLoss (friendFacts [(friendCalls.head!).assume true]) = true ∧
    superficialLoss (friendFacts [(friendCalls.head!).assume false]) = false := by
  decide +kernel

/-- And the explanation says so: either way, it relies on `J-DEFACTO`. -/
theorem friend_relies_on_defacto :
    (SuperficialLoss.rule.explain (friendFacts [(friendCalls.head!).assume false])).reliesOn = ["J-DEFACTO"] := by
  decide +kernel

end Canteen.Transactions.HoldcoRepurchase

import Canteen.Examples.RuleX
import Canteen.Core.Combine
import Canteen.Core.Branch
import Canteen.Core.SeriesReport

/-!
# Worked example: a multi-step toy series

A toy plan, **not a real transaction**: a taxpayer acquires property in two lots,
then files an election. Rule X is checked after every step, with:

* condition A: the taxpayer holds at least 100 units (computed from the state);
* condition B: judgment call `J-B`, answered differently on each branch;
* the exception: an election has been filed (computed from the state).
-/

namespace Canteen.Examples

/-- The toy state: units held, and whether the election has been filed. -/
structure Holding where
  units : Nat
  electionFiled : Bool
  deriving Repr, DecidableEq

/-- Rule X's facts, read from the state and from the branch's answer to `J-B`. -/
def toXFacts (branch : List Judgment) (h : Holding) : XFacts :=
  ⟨decide (100 ≤ h.units), answerOf branch "J-B", h.electionFiled⟩

/-- Rule X, applied to the state on a given branch. -/
def xOn (branch : List Judgment) : Rule Holding :=
  ruleX.comap (toXFacts branch)

/-- The one judgment call: assuming "yes" is a medium risk; "no" is low. -/
def toyCalls : List JudgmentCall :=
  [{ id := "J-B", question := "Is condition B met?", riskIfYes := .medium, riskIfNo := .low }]

def toyStart : Holding := ⟨0, false⟩

def toyPlan : List (TxStep Holding) :=
  [ ⟨"Acquire 60 units", fun h => { h with units := h.units + 60 }⟩,
    ⟨"Acquire 50 more units", fun h => { h with units := h.units + 50 }⟩,
    ⟨"File the election", fun h => { h with electionFiled := true }⟩ ]

/-- The whole plan as one English argument, on a given branch. -/
def toyArgument (branch : List Judgment) : Argument :=
  explainSeries [xOn branch] toyPlan toyStart

/-! ## Results -/

/-- After the whole plan, Rule X does not apply on any branch: the judgment call
doesn't matter (the exception applies). -/
theorem x_fails_after_plan :
    ruleX.SameOnEveryBranch toyCalls (fun b => toXFacts b (runSeries toyPlan toyStart)) false := by
  decide

/-- After the first two steps, whether Rule X applies turns on judgment call `J-B`. -/
theorem x_after_two_steps_depends_on_B :
    ¬ ruleX.SameOnEveryBranch toyCalls (fun b => toXFacts b (runSeries (toyPlan.take 2) toyStart)) true ∧
    ¬ ruleX.SameOnEveryBranch toyCalls (fun b => toXFacts b (runSeries (toyPlan.take 2) toyStart)) false := by
  decide

/-- If `J-B` is answered "no", Rule X never applies at any point of *any* plan, from
any start. Proven once, by the series invariant, for all plans. -/
theorem x_never_applies_if_B_no (branch : List Judgment) (hB : answerOf branch "J-B" = false)
    (plan : List (TxStep Holding)) (start : Holding) :
    ∀ t ∈ traceSeries plan start, (xOn branch).holds t = false := by
  have hP : ∀ h : Holding, (xOn branch).holds h = false := by
    intro h
    simp only [xOn, Rule.comap_holds, ruleX, toXFacts, hB]
    exact x_iff_B false ▸ by cases decide (100 ≤ h.units) <;> cases h.electionFiled <;> rfl
  exact traceSeries_invariant (fun t => (xOn branch).holds t = false) plan
    (fun _ _ s _ => hP _) start (hP start)

end Canteen.Examples

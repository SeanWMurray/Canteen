import Canteen.Examples.RuleX
import Canteen.Core.Branch

/-!
# Tests: branches over judgment calls
-/

namespace Canteen.Tests.Branch

open Canteen Canteen.Examples

def jB : JudgmentCall := { id := "J-B", question := "Is condition B met?", riskIfYes := .medium, riskIfNo := .low }
def jE : JudgmentCall := { id := "J-E", question := "Does the exception apply?", riskIfYes := .high, riskIfNo := .low }

/-! ## Enumerating branches -/

example : (branches []).length = 1 := rfl
example : (branches [jB, jE]).length = 4 := by decide
#guard (branches [jB, jE]).map describeBranch ==
  ["J-B = yes, J-E = yes", "J-B = yes, J-E = no", "J-B = no, J-E = yes", "J-B = no, J-E = no"]
example : (jB.assume true).risk = .medium ∧ (jB.assume false).risk = .low := by decide

example : answerOf [jB.assume true] "J-B" = true := by decide
example : answerOf [jB.assume false] "J-B" = false := by decide

/-! ## Rule X with B and the exception both left to judgment -/

/-- Condition A is a fact; B and the exception are judgment calls. -/
def facts (condA : Bool) (b : List Judgment) : XFacts :=
  ⟨condA, answerOf b "J-B", answerOf b "J-E"⟩

/-- Without A, Rule X fails on every branch: the judgment calls don't matter. -/
theorem x_without_A_settled : ruleX.SameOnEveryBranch [jB, jE] (facts false) false := by decide

/-- With A, they do: Rule X applies on some branches but not others. -/
theorem x_with_A_open :
    ¬ ruleX.SameOnEveryBranch [jB, jE] (facts true) true ∧
    ¬ ruleX.SameOnEveryBranch [jB, jE] (facts true) false := by decide

example (answers : List Bool) (h : answers.length = 2) :
    ruleX.holds (facts false (List.zipWith JudgmentCall.assume [jB, jE] answers)) = false :=
  x_without_A_settled.holds answers h

/-! ## Branch report -/

#guard ruleX.renderBranches [jB, jE] (facts true) ==
  "Branch 1 (J-B = yes, J-E = yes):\n" ++
  "1. The exception applies, so Rule X does not apply. [s.X(c)]\n" ++
  "Conclusion: Rule X does not apply. Risk: low.\n\n" ++
  "Branch 2 (J-B = yes, J-E = no):\n" ++
  "1. Conditions A and B are met and no exception applies, so Rule X applies. [s.X]\n" ++
  "Conclusion: Rule X applies. Risk: medium.\n\n" ++
  "Branch 3 (J-B = no, J-E = yes):\n" ++
  "1. The exception applies, so Rule X does not apply. [s.X(c)]\n" ++
  "Conclusion: Rule X does not apply. Risk: low.\n\n" ++
  "Branch 4 (J-B = no, J-E = no):\n" ++
  "1. Condition B is not met, so Rule X does not apply. [s.X(b)]\n" ++
  "Conclusion: Rule X does not apply. Risk: low.\n\n" ++
  "Summary: Rule X applies on 1 of 4 branches, so the conclusion depends on the judgment calls."

#guard ruleX.renderBranches [jB, jE] (facts false) ==
  "Branch 1 (J-B = yes, J-E = yes):\n" ++
  "1. Condition A is not met, so Rule X does not apply. [s.X(a)]\n" ++
  "Conclusion: Rule X does not apply. Risk: low.\n\n" ++
  "Branch 2 (J-B = yes, J-E = no):\n" ++
  "1. Condition A is not met, so Rule X does not apply. [s.X(a)]\n" ++
  "Conclusion: Rule X does not apply. Risk: low.\n\n" ++
  "Branch 3 (J-B = no, J-E = yes):\n" ++
  "1. Condition A is not met, so Rule X does not apply. [s.X(a)]\n" ++
  "Conclusion: Rule X does not apply. Risk: low.\n\n" ++
  "Branch 4 (J-B = no, J-E = no):\n" ++
  "1. Condition A is not met, so Rule X does not apply. [s.X(a)]\n" ++
  "Conclusion: Rule X does not apply. Risk: low.\n\n" ++
  "Summary: Rule X does not apply on any branch, so the judgment calls do not affect the conclusion."

end Canteen.Tests.Branch

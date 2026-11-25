import Canteen.Examples.RuleX

/-!
# Tests: Rule X

The validation practices of design §6 applied to the placeholder Rule X:
known-answer tests, non-vacuity, read-back of every branch, and a deliberately
broken explanation that Lean refuses to accept as a `Rule`.
-/

namespace Canteen.Tests.RuleX

open Canteen Canteen.Examples

/-! ## Known-answer tests -/

example : ruleX.holds ⟨true, true, false⟩ = true := rfl
example : ruleX.holds ⟨true, false, false⟩ = false := rfl
example : ruleX.holds ⟨false, true, false⟩ = false := rfl
example : ruleX.holds ⟨true, true, true⟩ = false := rfl

/-! ## Non-vacuity: Rule X applies in one scenario and fails in another -/

theorem ruleX_nonVacuous : ruleX.NonVacuous :=
  .of_witnesses ruleX ⟨true, true, false⟩ ⟨false, false, false⟩ rfl rfl

/-! ## Judgment calls

Rule X does depend on judgment call B in general, but not once condition A fails. -/

theorem ruleX_depends_on_B : ¬ ruleX.IndependentOf (fun f b => { f with condB := b }) := by
  intro h
  have := h ⟨true, true, false⟩ false
  simp [ruleX, xHolds] at this

theorem ruleX_independent_of_B_without_A :
    ∀ f : XFacts, f.condA = false → ∀ b, ruleX.holds { f with condB := b } = false := by
  intro ⟨a, b, e⟩ ha b'
  subst ha
  exact x_fails_without_A b' e

/-! ## Read-back: the explanation for every branch (design §6)

All eight scenarios, rendered with the judgment calls each conclusion relies on. -/

def allScenarios : List XFacts := Id.run do
  let mut out := []
  for a in [true, false] do
    for b in [true, false] do
      for e in [false, true] do
        out := out ++ [⟨a, b, e⟩]
  return out

#guard allScenarios.length == 8

#guard (ruleX.explain ⟨true, true, false⟩).renderWithJudgments xJudgments ==
  "1. Conditions A and B are met and no exception applies, so Rule X applies. [s.X]\n" ++
  "Relies on these judgment calls:\n" ++
  "- J-B: Is condition B met? Assumed: yes. Risk: medium.\n" ++
  "Overall risk: medium."

#guard ruleX.explainText ⟨false, true, false⟩ ==
  "1. Condition A is not met, so Rule X does not apply. [s.X(a)]"

#guard ruleX.explainText ⟨true, true, true⟩ ==
  "1. The exception applies, so Rule X does not apply. [s.X(c)]"

#guard ruleX.explainText ⟨true, false, false⟩ ==
  "1. Condition B is not met, so Rule X does not apply. [s.X(b)]"

-- Conclusions resting only on facts carry low risk.
#guard (allScenarios.filter fun f => (ruleX.explain f).reliesOn.isEmpty).all
  fun f => findingRisk xJudgments (ruleX.explain f) == .low

/-! ## A deliberately broken rule is caught

This explanation forgets the exception: it says Rule X applies whenever A and B
hold. Its soundness obligation is provably false, so it can never be packaged as
a `Rule`. (`tests/should-fail/BrokenRule.lean` checks that trying to do so is a
build error.) -/

def brokenExplain (f : XFacts) : Finding :=
  if f.condA && f.condB then
    ⟨true, [⟨"Conditions A and B are met, so Rule X applies.", "s.X"⟩], ["J-B"]⟩
  else
    ⟨false, [⟨"Condition A or B is not met, so Rule X does not apply.", "s.X"⟩], ["J-B"]⟩

theorem brokenExplain_unsound : ¬ ∀ f, (brokenExplain f).conclusion = xHolds f := by
  intro h
  have := h ⟨true, true, true⟩
  simp [brokenExplain, xHolds] at this

end Canteen.Tests.RuleX

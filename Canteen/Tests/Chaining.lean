import Canteen.Examples.RuleZ

/-!
# Tests: chained arguments and combined rules
-/

namespace Canteen.Tests.Chaining

open Canteen Canteen.Examples

/-! ## Arguments -/

def f1 : Finding := ⟨true, [⟨"First.", "s.1"⟩], ["J-1"]⟩
def f2 : Finding := ⟨true, [⟨"Second.", "s.2"⟩], ["J-2", "J-1"]⟩

-- Steps are kept in order; judgment ids are merged without duplicates.
example : (Argument.ofFinding f1 ++ Argument.ofFinding f2).reliesOn = ["J-1", "J-2"] := by decide
example : (Argument.concat [.note "A." "s.A", .ofFinding f1, .ofFinding f2]).steps.length = 3 := by decide
#guard Argument.empty.render [] == "Relies on no judgment calls."
#guard (Argument.concat [.note "Because A." "s.A", .note "Therefore B." "s.B"]).render [] ==
  "1. Because A. [s.A]\n2. Therefore B. [s.B]\nRelies on no judgment calls."

/-! ## Rule Z = Rule X and Rule Y -/

example : ruleZ.holds ⟨⟨true, true, false⟩, ⟨true⟩⟩ = true := rfl
example : ruleZ.holds ⟨⟨true, true, false⟩, ⟨false⟩⟩ = false := rfl
example : ruleZ.holds ⟨⟨true, true, true⟩, ⟨true⟩⟩ = false := rfl

theorem ruleZ_nonVacuous : ruleZ.NonVacuous :=
  .of_witnesses ruleZ ⟨⟨true, true, false⟩, ⟨true⟩⟩ ⟨⟨false, true, false⟩, ⟨true⟩⟩ rfl rfl

#guard (ruleZ.explain ⟨⟨true, true, false⟩, ⟨true⟩⟩).renderWithJudgments xJudgments ==
  "1. Conditions A and B are met and no exception applies, so Rule X applies. [s.X]\n" ++
  "2. Condition C is met, so Rule Y applies. [s.Y]\n" ++
  "3. Therefore Rule Z applies. [s.Z]\n" ++
  "Relies on these judgment calls:\n" ++
  "- J-B: Is condition B met? Assumed: yes. Risk: medium.\n" ++
  "Overall risk: medium."

-- Both fail; X fails on judgment call B, Y fails on the facts. The explanation
-- cites Y, so it rests on facts alone.
#guard (ruleZ.explain ⟨⟨true, false, false⟩, ⟨false⟩⟩).renderWithJudgments xJudgments ==
  "1. Condition C is not met, so Rule Y does not apply. [s.Y]\n" ++
  "2. Therefore Rule Z does not apply. [s.Z]\n" ++
  "Relies on no judgment calls."

-- Both fail on the facts: the first rule's reason is given.
#guard ruleZ.explainText ⟨⟨false, true, false⟩, ⟨false⟩⟩ ==
  "1. Condition A is not met, so Rule X does not apply. [s.X(a)]\n" ++
  "2. Therefore Rule Z does not apply. [s.Z]"

/-! ## `or` and `not` -/

/-- Placeholder: Rule W applies if Rule X or Rule Y applies. -/
def ruleW : Rule ZFacts := Rule.or "Rule W" "s.W" (ruleX.comap ZFacts.x) (ruleY.comap ZFacts.y)

/-- Placeholder: Rule V applies unless Rule Y applies. -/
def ruleV : Rule YFacts := Rule.not "Rule V" "s.V" ruleY

example : ruleW.holds ⟨⟨false, false, false⟩, ⟨true⟩⟩ = true := rfl
example : ruleW.holds ⟨⟨false, false, false⟩, ⟨false⟩⟩ = false := rfl

-- Both apply; X relies on judgment call B, Y on facts alone. The explanation cites Y.
#guard (ruleW.explain ⟨⟨true, true, false⟩, ⟨true⟩⟩).renderWithJudgments xJudgments ==
  "1. Condition C is met, so Rule Y applies. [s.Y]\n" ++
  "2. Therefore Rule W applies. [s.W]\n" ++
  "Relies on no judgment calls."

-- Neither applies: both reasons are given, and both rules' judgment calls are listed.
#guard (ruleW.explain ⟨⟨true, false, false⟩, ⟨false⟩⟩).renderWithJudgments xJudgments ==
  "1. Condition B is not met, so Rule X does not apply. [s.X(b)]\n" ++
  "2. Condition C is not met, so Rule Y does not apply. [s.Y]\n" ++
  "3. Therefore Rule W does not apply. [s.W]\n" ++
  "Relies on these judgment calls:\n" ++
  "- J-B: Is condition B met? Assumed: yes. Risk: medium.\n" ++
  "Overall risk: medium."

#guard ruleV.explainText ⟨true⟩ ==
  "1. Condition C is met, so Rule Y applies. [s.Y]\n2. Therefore Rule V does not apply. [s.V]"
#guard ruleV.explainText ⟨false⟩ ==
  "1. Condition C is not met, so Rule Y does not apply. [s.Y]\n2. Therefore Rule V applies. [s.V]"

end Canteen.Tests.Chaining

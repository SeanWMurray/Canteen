import Canteen.Core.Render

/-!
# Tests: core language

Known-answer and sanity tests for `Risk`, `Judgment`, `Finding` and rendering.
-/

namespace Canteen.Tests.Core

open Canteen

/-! ## Risk -/

example : Risk.low.max .medium = .medium := rfl
example : Risk.high.max .medium = .high := rfl
example : Risk.medium.max .medium = .medium := rfl
example : Risk.low.rank < Risk.medium.rank ∧ Risk.medium.rank < Risk.high.rank := by decide

/-! ## Judgment -/

def jLow : Judgment := { id := "J-1", question := "Is it a capital property?", answer := true, risk := .low }
def jHigh : Judgment := { id := "J-2", question := "Was a main purpose tax avoidance?", answer := false, risk := .high }
def jMed : Judgment := { id := "J-3", question := "Is the price fair market value?", answer := true, risk := .medium }
def registry : List Judgment := [jLow, jHigh, jMed]

example : jHigh.flip.answer = true := rfl
example : Judgment.find? registry "J-3" = some jMed := by decide
example : Judgment.find? registry "J-9" = none := by decide

/-! ## findingRisk: the highest risk among the judgment calls relied on -/

def finding (ids : List String) : Finding :=
  ⟨true, [⟨"Example step.", "s.1"⟩], ids⟩

example : findingRisk registry (finding []) = .low := rfl
example : findingRisk registry (finding ["J-1"]) = .low := rfl
example : findingRisk registry (finding ["J-3"]) = .medium := rfl
example : findingRisk registry (finding ["J-1", "J-3"]) = .medium := rfl
example : findingRisk registry (finding ["J-2", "J-1"]) = .high := rfl
-- An id missing from the registry contributes no risk to the number, but
-- `renderWithJudgments` lists it as unregistered (see below).
example : findingRisk registry (finding ["J-9"]) = .low := rfl

example : (finding []).isFactual = true := rfl
example : (finding ["J-1"]).isFactual = false := rfl
example : (finding ["J-3", "J-2"]).judgments registry = [jHigh, jMed] := by decide

/-! ## Rendering -/

def twoSteps : Finding :=
  ⟨true, [⟨"The property is capital property.", "s.54"⟩,
          ⟨"Therefore the gain is a capital gain.", "s.39(1)(a)"⟩], ["J-1", "J-2"]⟩

#guard twoSteps.render ==
  "1. The property is capital property. [s.54]\n2. Therefore the gain is a capital gain. [s.39(1)(a)]"

#guard (Finding.mk false [] []).render == ""

#guard twoSteps.renderWithJudgments registry ==
  "1. The property is capital property. [s.54]\n" ++
  "2. Therefore the gain is a capital gain. [s.39(1)(a)]\n" ++
  "Relies on these judgment calls:\n" ++
  "- J-1: Is it a capital property? Assumed: yes. Risk: low.\n" ++
  "- J-2: Was a main purpose tax avoidance? Assumed: no. Risk: high.\n" ++
  "Overall risk: high."

#guard (finding []).renderWithJudgments registry ==
  "1. Example step. [s.1]\nRelies on no judgment calls."

#guard (finding ["J-9"]).renderWithJudgments registry ==
  "1. Example step. [s.1]\n" ++
  "Relies on these judgment calls:\n" ++
  "- J-9: (not in the judgment registry)\n" ++
  "Overall risk: low."

end Canteen.Tests.Core

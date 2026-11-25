import Canteen.Examples.ToySeries

/-!
# Tests: the toy series renders a full English argument

Roadmap Phase 3 is done when "a multi-step toy series renders a full English
argument". These tests fix that argument, on each branch, word for word.
-/

namespace Canteen.Tests.ToySeries

open Canteen Canteen.Examples

def yes : List Judgment := [(toyCalls.head!).assume true]
def no : List Judgment := [(toyCalls.head!).assume false]

-- The report's conclusions after each step (proven to match Rule X by `reportSeries_sound`).
example : (reportSeries [xOn yes] 1 toyPlan toyStart).map (·.findings.map (·.conclusion)) =
    [[false], [true], [false]] := by decide
example : (reportSeries [xOn no] 1 toyPlan toyStart).map (·.findings.map (·.conclusion)) =
    [[false], [false], [false]] := by decide

example : (toyArgument yes).risk yes = .medium := by decide
example : (toyArgument no).risk no = .low := by decide

#guard renderEachBranch toyCalls toyArgument ==
  "Branch 1 (J-B = yes):\n" ++
  "1. Step 1: Acquire 60 units. [plan, step 1]\n" ++
  "2. Condition A is not met, so Rule X does not apply. [s.X(a)]\n" ++
  "3. Step 2: Acquire 50 more units. [plan, step 2]\n" ++
  "4. Conditions A and B are met and no exception applies, so Rule X applies. [s.X]\n" ++
  "5. Step 3: File the election. [plan, step 3]\n" ++
  "6. The exception applies, so Rule X does not apply. [s.X(c)]\n" ++
  "7. So, across the plan: Rule X applies after step 2 only. [s.X]\n" ++
  "Relies on these judgment calls:\n" ++
  "- J-B: Is condition B met? Assumed: yes. Risk: medium.\n" ++
  "Overall risk: medium.\n\n" ++
  "Branch 2 (J-B = no):\n" ++
  "1. Step 1: Acquire 60 units. [plan, step 1]\n" ++
  "2. Condition A is not met, so Rule X does not apply. [s.X(a)]\n" ++
  "3. Step 2: Acquire 50 more units. [plan, step 2]\n" ++
  "4. Condition B is not met, so Rule X does not apply. [s.X(b)]\n" ++
  "5. Step 3: File the election. [plan, step 3]\n" ++
  "6. The exception applies, so Rule X does not apply. [s.X(c)]\n" ++
  "7. So, across the plan: Rule X does not apply after any step. [s.X]\n" ++
  "Relies on these judgment calls:\n" ++
  "- J-B: Is condition B met? Assumed: no. Risk: low.\n" ++
  "Overall risk: low."

/-! ## Summary sentences -/

#guard englishList ["1"] == "1"
#guard englishList ["1", "2"] == "1 and 2"
#guard englishList ["1", "2", "3"] == "1, 2 and 3"

-- A plan where Rule X applies after several steps.
def longPlan : List (TxStep Holding) :=
  [⟨"Acquire 120 units", fun h => { h with units := h.units + 120 }⟩,
   ⟨"Acquire 10 more units", fun h => { h with units := h.units + 10 }⟩,
   ⟨"Acquire 5 more units", fun h => { h with units := h.units + 5 }⟩]

#guard appliesAfterSentence (reportSeries [xOn yes] 1 longPlan toyStart) (xOn yes) ==
  "Rule X applies after steps 1, 2 and 3."

end Canteen.Tests.ToySeries

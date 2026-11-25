-- expect: proved that the proposition
/-
Phase 2 check: a deliberately broken rule must be caught automatically.

This explanation forgets the exception in s.X(c), so its soundness proof
cannot succeed and the `Rule` cannot be built.
-/
import Canteen.Examples.RuleX

open Canteen Canteen.Examples

def brokenExplain (f : XFacts) : Finding :=
  if f.condA && f.condB then
    ⟨true, [⟨"Conditions A and B are met, so Rule X applies.", "s.X"⟩], ["J-B"]⟩
  else
    ⟨false, [⟨"Condition A or B is not met, so Rule X does not apply.", "s.X"⟩], ["J-B"]⟩

def brokenRule : Rule XFacts where
  name := "Rule X (broken)"
  citation := "s.X"
  holds := xHolds
  explain := brokenExplain
  sound := by
    intro ⟨a, b, e⟩
    cases a <;> cases b <;> cases e <;> decide

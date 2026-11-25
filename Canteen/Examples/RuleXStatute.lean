import Canteen.Core.StatuteSyntax
import Canteen.Examples.RuleX

/-!
# Rule X, written in statute form

The placeholder Rule X of design §4.4, written with the `statute` command, and proven to
be the same rule as the hand-written `ruleX`. The statute form needs no proof of its own.
-/

namespace Canteen.Examples

/-- *Rule X applies where (a) condition A and (b) condition B are met, except where (c)
the exception applies.* -/
statute ruleXStatute (f : XFacts) named "Rule X" cites "s.X"
  applies where
    | (a) f.condA => "Condition A is met." else "Condition A is not met."
    | (b) judgment "J-B" f.condB => "Condition B is met." else "Condition B is not met."
  except where
    | (c) f.exception => "The exception applies." else "The exception does not apply."

/-- The statute form is the same rule as the hand-written one. -/
theorem ruleXStatute_eq (f : XFacts) : ruleXStatute.holds f = ruleX.holds f := by
  obtain ⟨a, b, e⟩ := f
  cases a <;> cases b <;> cases e <;> rfl

end Canteen.Examples

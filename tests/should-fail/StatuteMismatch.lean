-- expect: proved that the proposition
/-
Phase 6 check: a statute-form rule that leaves out a clause is caught. This Rule X
forgets the exception in (c); its equivalence with the hand-written rule cannot be proven.
-/
import Canteen.Examples.RuleXStatute

open Canteen Canteen.Examples

statute ruleXForgetful (f : XFacts) named "Rule X" cites "s.X"
  applies where
    | (a) f.condA => "Condition A is met." else "Condition A is not met."
    | (b) judgment "J-B" f.condB => "Condition B is met." else "Condition B is not met."

theorem ruleXForgetful_eq : ∀ a b e : Bool, ruleXForgetful.holds ⟨a, b, e⟩ = ruleX.holds ⟨a, b, e⟩ := by
  decide

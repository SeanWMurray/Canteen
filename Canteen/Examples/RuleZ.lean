import Canteen.Examples.RuleX
import Canteen.Core.Combine

/-!
# Worked example: chaining rules

Placeholders, **not real provisions**:

* *Rule Y applies if condition C is met.*
* *Rule Z applies if Rule X and Rule Y both apply.*

Rule Z is built with `Rule.and`, so its explanation chains the reasons for X and Y
and is sound with nothing further to prove.
-/

namespace Canteen.Examples

/-- The facts Rule Y needs. -/
structure YFacts where
  /-- Condition C, a computable fact. -/
  condC : Bool
  deriving Repr, DecidableEq

def yExplain (f : YFacts) : Finding :=
  if f.condC then ⟨true, [⟨"Condition C is met, so Rule Y applies.", "s.Y"⟩], []⟩
  else ⟨false, [⟨"Condition C is not met, so Rule Y does not apply.", "s.Y"⟩], []⟩

/-- Rule Y: condition C. -/
def ruleY : Rule YFacts where
  name := "Rule Y"
  citation := "s.Y"
  holds := YFacts.condC
  explain := yExplain
  sound := fun ⟨c⟩ => by cases c <;> rfl

/-- The facts Rule Z needs: everything Rule X and Rule Y need. -/
structure ZFacts where
  x : XFacts
  y : YFacts
  deriving Repr, DecidableEq

/-- Rule Z: Rule X and Rule Y both apply. -/
def ruleZ : Rule ZFacts :=
  Rule.and "Rule Z" "s.Z" (ruleX.comap ZFacts.x) (ruleY.comap ZFacts.y)

/-- Rule Z never applies without condition C, whatever the answer to judgment call B. -/
theorem z_fails_without_C : ∀ x : XFacts, ruleZ.holds ⟨x, ⟨false⟩⟩ = false := by
  intro x; simp [ruleZ, ruleY]

/-- When Rule Z fails because condition C fails, the explanation rests on facts alone,
even if condition B (a judgment call) also fails. -/
theorem z_without_C_is_factual (x : XFacts) : (ruleZ.explain ⟨x, ⟨false⟩⟩).isFactual = true :=
  Rule.and_explain_factual _ _ _ _ _ (.inr ⟨by rfl, by rfl⟩)

end Canteen.Examples

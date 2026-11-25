import Canteen.Core.Render

/-!
# Worked example: Rule X

A placeholder rule, **not a real provision** (design §4.4):
*"Rule X applies if conditions A and B are met and no exception applies."*
Condition B is a judgment call (`J-B`); condition A and the exception are facts.
-/

namespace Canteen.Examples

/-- The facts Rule X needs. -/
structure XFacts where
  /-- Condition A, a computable fact. -/
  condA : Bool
  /-- Condition B, a judgment call (`J-B`). -/
  condB : Bool
  /-- Whether the exception in s.X(c) applies. -/
  exception : Bool
  deriving Repr, DecidableEq

/-- Rule X: A and B and not the exception. -/
def xHolds (f : XFacts) : Bool :=
  f.condA && f.condB && !f.exception

/-- Rule X with reasons. The computable conditions (A, the exception) are tested
before the judgment call (B), so a conclusion relies on judgment only when it has
to (design principle 3). -/
def xExplain (f : XFacts) : Finding :=
  if f.condA = false then
    ⟨false, [⟨"Condition A is not met, so Rule X does not apply.", "s.X(a)"⟩], []⟩
  else if f.exception = true then
    ⟨false, [⟨"The exception applies, so Rule X does not apply.", "s.X(c)"⟩], []⟩
  else if f.condB = false then
    ⟨false, [⟨"Condition B is not met, so Rule X does not apply.", "s.X(b)"⟩], ["J-B"]⟩
  else
    ⟨true, [⟨"Conditions A and B are met and no exception applies, so Rule X applies.", "s.X"⟩],
      ["J-B"]⟩

theorem xExplain_sound (f : XFacts) : (xExplain f).conclusion = xHolds f := by
  obtain ⟨a, b, e⟩ := f
  cases a <;> cases b <;> cases e <;> decide

/-- Rule X, with its explanation proven sound. -/
def ruleX : Rule XFacts where
  name := "Rule X"
  citation := "s.X"
  holds := xHolds
  explain := xExplain
  sound := xExplain_sound

/-- The judgment calls Rule X uses. -/
def xJudgments : List Judgment :=
  [{ id := "J-B", question := "Is condition B met?", answer := true, risk := .medium }]

/-! ## Layer 2 lemmas: conclusions that don't depend on the judgment call -/

/-- Rule X never applies without condition A, whatever the answer to judgment call B. -/
theorem x_fails_without_A : ∀ b e : Bool, xHolds ⟨false, b, e⟩ = false := by
  decide

/-- Rule X never applies when the exception applies, whatever the answer to B. -/
theorem x_fails_with_exception : ∀ a b : Bool, xHolds ⟨a, b, true⟩ = false := by
  decide

/-- Once A holds and the exception is out, Rule X turns exactly on judgment call B. -/
theorem x_iff_B (b : Bool) : xHolds ⟨true, b, false⟩ = b := by
  cases b <;> rfl

/-- When the explanation relies on no judgment call, Rule X does not apply:
every positive conclusion rests on judgment call B. -/
theorem x_factual_is_negative (f : XFacts) (h : (xExplain f).reliesOn = []) :
    xHolds f = false := by
  obtain ⟨a, b, e⟩ := f
  cases a <;> cases b <;> cases e <;> simp_all [xExplain, xHolds]

/-- If Rule X applies, its explanation relies on judgment call B. -/
theorem x_applies_relies_on_B (f : XFacts) (h : xHolds f = true) :
    (xExplain f).reliesOn = ["J-B"] := by
  obtain ⟨a, b, e⟩ := f
  cases a <;> cases b <;> cases e <;> simp_all [xExplain, xHolds]

end Canteen.Examples

import Canteen.Core.Risk

/-!
# Judgment

A fact the model cannot compute and must be told (design §4.3), such as
whether a purpose test is met. Each judgment call is named, states the
question it answers, records the answer assumed on the current branch, and
carries a risk rating. Judgment is never hidden (design principle 1).
-/

namespace Canteen

/-- A judgment call: a named, risk-rated true/false switch. -/
structure Judgment where
  /-- Stable identifier, e.g. `"J-001"`. -/
  id : String
  /-- The question, in plain English. -/
  question : String
  /-- The answer assumed on this branch. -/
  answer : Bool
  /-- Confidence in that answer. -/
  risk : Risk
  deriving Repr, DecidableEq, Inhabited

namespace Judgment

/-- The same judgment call answered the other way, e.g. to explore the other branch. -/
def flip (j : Judgment) : Judgment :=
  { j with answer := !j.answer }

@[simp] theorem flip_flip (j : Judgment) : j.flip.flip = j := by
  cases j; simp [flip]

@[simp] theorem flip_id (j : Judgment) : j.flip.id = j.id := rfl

/-- Look up a judgment call by id in a registry. -/
def find? (registry : List Judgment) (id : String) : Option Judgment :=
  registry.find? (·.id == id)

end Judgment

end Canteen

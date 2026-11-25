import Canteen.Core.Finding

/-!
# Rule

The central abstraction (design §4.3): a statutory provision encoded as a
function from facts to a true/false result, bundled with its English
explanation and a proof (`sound`) that the two agree. Lean refuses to build a
`Rule` whose explanation could ever contradict its logic.
-/

namespace Canteen

/-- A statutory rule over a type of facts, with a checked English explanation. -/
structure Rule (Facts : Type) where
  /-- Human-readable name, e.g. `"Rule X"`. -/
  name : String
  /-- Statutory reference for the rule as a whole. -/
  citation : String
  /-- The rule itself. -/
  holds : Facts → Bool
  /-- The same rule, with reasons. -/
  explain : Facts → Finding
  /-- The explanation always reaches the same conclusion as the rule. -/
  sound : ∀ f, (explain f).conclusion = holds f

namespace Rule

variable {Facts : Type}

/-- The rule applies to these facts. -/
def Applies (r : Rule Facts) (f : Facts) : Prop :=
  r.holds f = true

instance (r : Rule Facts) (f : Facts) : Decidable (r.Applies f) :=
  inferInstanceAs (Decidable (r.holds f = true))

/-- The explanation's conclusion is the rule's result (the `sound` field, as a simp lemma). -/
@[simp] theorem explain_conclusion (r : Rule Facts) (f : Facts) :
    (r.explain f).conclusion = r.holds f :=
  r.sound f

/-- Non-vacuity (design §6): the rule applies in some scenario and fails in another.
A rule that is always true or always false usually means a mis-encoding. -/
def NonVacuous (r : Rule Facts) : Prop :=
  (∃ f, r.holds f = true) ∧ (∃ f, r.holds f = false)

/-- Discharge non-vacuity by giving one scenario where the rule applies and one where it doesn't. -/
theorem NonVacuous.of_witnesses (r : Rule Facts) (yes no : Facts)
    (hyes : r.holds yes = true) (hno : r.holds no = false) : r.NonVacuous :=
  ⟨⟨yes, hyes⟩, ⟨no, hno⟩⟩

/-- The rule's result does not depend on a given judgment switch: for every
scenario, changing only that switch (via `set`) leaves the result unchanged.
This is the "make it irrelevant" technique of design §4.5, stated generically. -/
def IndependentOf (r : Rule Facts) (set : Facts → Bool → Facts) : Prop :=
  ∀ f b, r.holds (set f b) = r.holds f

end Rule

end Canteen

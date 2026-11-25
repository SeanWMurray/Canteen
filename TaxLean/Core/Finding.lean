import TaxLean.Core.Judgment

/-!
# Step and Finding

The result of applying a rule (design §4.3): the conclusion, the numbered
English steps that led there, and the ids of the judgment calls it relied on.
`findingRisk` gives a finding's overall risk: the highest risk among the
judgment calls it relies on (design §4.5).
-/

namespace TaxLean

/-- One step of an English argument: a single sentence and its statutory reference. -/
structure Step where
  /-- One English sentence. -/
  claim : String
  /-- Statutory reference, e.g. `"s.X(a)"`. -/
  citation : String
  deriving Repr, DecidableEq, Inhabited

/-- The result of applying a rule, with its reasons. -/
structure Finding where
  /-- Whether the rule applies. -/
  conclusion : Bool
  /-- The argument, in order. -/
  steps : List Step
  /-- Ids of the judgment calls this conclusion depends on. -/
  reliesOn : List String
  deriving Repr, DecidableEq, Inhabited

/-- A finding's overall risk: the highest risk among the judgment calls in
`registry` that it relies on, or `low` if it relies on none. -/
def findingRisk (registry : List Judgment) (f : Finding) : Risk :=
  registry.foldl
    (fun (r : Risk) (j : Judgment) => if f.reliesOn.contains j.id then r.max j.risk else r)
    .low

namespace Finding

/-- Does this finding rest on any judgment call at all? -/
def isFactual (f : Finding) : Bool :=
  f.reliesOn.isEmpty

/-- The judgment calls in `registry` this finding relies on. -/
def judgments (registry : List Judgment) (f : Finding) : List Judgment :=
  registry.filter (fun j => f.reliesOn.contains j.id)

end Finding

/-! ## Facts about `findingRisk` -/

private theorem foldl_const_risk (reg : List Judgment) (r : Risk) :
    reg.foldl (fun (r : Risk) (_ : Judgment) => r) r = r := by
  induction reg generalizing r with
  | nil => rfl
  | cons _ _ ih => exact ih r

/-- A conclusion that relies on no judgment call has low risk, whatever the registry. -/
theorem findingRisk_of_reliesOn_nil (reg : List Judgment) (f : Finding)
    (h : f.reliesOn = []) : findingRisk reg f = .low := by
  unfold findingRisk
  simp only [h, List.contains_nil, Bool.false_eq_true, ↓reduceIte]
  exact foldl_const_risk reg .low

/-- Against an empty registry every finding has low risk. -/
@[simp] theorem findingRisk_nil (f : Finding) : findingRisk [] f = .low := rfl

end TaxLean

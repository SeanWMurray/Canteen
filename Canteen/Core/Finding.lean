import Canteen.Core.Judgment

/-!
# Step and Finding

The result of applying a rule (design §4.3): the conclusion, the numbered
English steps that led there, and the ids of the judgment calls it relied on.
`findingRisk` gives a finding's overall risk: the highest risk among the
judgment calls it relies on (design §4.5).
-/

namespace Canteen

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

/-- Merge two lists of judgment ids: everything in `a`, then the ids of `b` not
already in `a`. Combining arguments never drops a dependency (`mem_mergeIds`). -/
def mergeIds (a b : List String) : List String :=
  a ++ b.filter (fun id => !a.contains id)

/-- The highest risk among the judgment calls in `registry` whose ids are in `ids`,
or `low` if there are none. -/
def riskOf (registry : List Judgment) (ids : List String) : Risk :=
  registry.foldl
    (fun (r : Risk) (j : Judgment) => if ids.contains j.id then r.max j.risk else r)
    .low

/-- A finding's overall risk: the highest risk among the judgment calls in
`registry` that it relies on, or `low` if it relies on none. -/
def findingRisk (registry : List Judgment) (f : Finding) : Risk :=
  riskOf registry f.reliesOn

namespace Finding

/-- Does this finding rest on any judgment call at all? -/
def isFactual (f : Finding) : Bool :=
  f.reliesOn.isEmpty

/-- The judgment calls in `registry` this finding relies on. -/
def judgments (registry : List Judgment) (f : Finding) : List Judgment :=
  registry.filter (fun j => f.reliesOn.contains j.id)

end Finding

/-! ## Facts about `mergeIds` and `riskOf` -/

theorem mem_mergeIds {a b : List String} {id : String} :
    id ∈ mergeIds a b ↔ id ∈ a ∨ id ∈ b := by
  by_cases h : id ∈ a <;> simp [mergeIds, h]

private theorem foldl_const_risk (reg : List Judgment) (r : Risk) :
    reg.foldl (fun (r : Risk) (_ : Judgment) => r) r = r := by
  induction reg generalizing r with
  | nil => rfl
  | cons _ _ ih => exact ih r

/-- With no ids, the risk is low. -/
@[simp] theorem riskOf_nil_ids (reg : List Judgment) : riskOf reg [] = .low := by
  unfold riskOf
  simp only [List.contains_nil, Bool.false_eq_true, ↓reduceIte]
  exact foldl_const_risk reg .low

/-- Against an empty registry the risk is low. -/
@[simp] theorem riskOf_nil_registry (ids : List String) : riskOf [] ids = .low := rfl

private theorem riskOf_foldl_mono (reg : List Judgment) {ids ids' : List String}
    (h : ∀ id ∈ ids, id ∈ ids') (r r' : Risk) (hr : r.rank ≤ r'.rank) :
    (reg.foldl (fun (r : Risk) (j : Judgment) => if ids.contains j.id then r.max j.risk else r) r).rank ≤
      (reg.foldl (fun (r : Risk) (j : Judgment) => if ids'.contains j.id then r.max j.risk else r) r').rank := by
  induction reg generalizing r r' with
  | nil => exact hr
  | cons j rest ih =>
    apply ih
    by_cases hj : j.id ∈ ids
    · have hj' : j.id ∈ ids' := h _ hj
      simp only [List.contains_iff_mem, hj, hj', ↓reduceIte]
      exact Risk.max_mono_left hr j.risk
    · simp only [List.contains_iff_mem, hj, ↓reduceIte]
      split
      · exact Nat.le_trans hr (Risk.le_max_left r' j.risk)
      · exact hr

/-- Relying on more judgment calls never lowers the risk. -/
theorem riskOf_mono (reg : List Judgment) {ids ids' : List String}
    (h : ∀ id ∈ ids, id ∈ ids') : (riskOf reg ids).rank ≤ (riskOf reg ids').rank :=
  riskOf_foldl_mono reg h .low .low (Nat.le_refl _)

/-- A conclusion that relies on no judgment call has low risk, whatever the registry. -/
theorem findingRisk_of_reliesOn_nil (reg : List Judgment) (f : Finding)
    (h : f.reliesOn = []) : findingRisk reg f = .low := by
  simp [findingRisk, h]

/-- Against an empty registry every finding has low risk. -/
@[simp] theorem findingRisk_nil (f : Finding) : findingRisk [] f = .low := rfl

end Canteen

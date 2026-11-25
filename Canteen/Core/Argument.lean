import Canteen.Core.Render

/-!
# Chained arguments

Findings from several rules and steps joined into one numbered argument, with
the judgment calls it relies on listed at the end, each with its risk, and the
overall risk (design §5, level 2).

Combining arguments never drops a judgment dependency (`mem_reliesOn_append`)
and never lowers the risk (`risk_le_append_left`, `risk_le_append_right`).
-/

namespace Canteen

/-- A numbered English argument and the judgment calls it relies on. -/
structure Argument where
  /-- The argument, in order. -/
  steps : List Step
  /-- Ids of the judgment calls the argument relies on, without duplicates. -/
  reliesOn : List String
  deriving Repr, DecidableEq, Inhabited

namespace Argument

/-- The empty argument. -/
def empty : Argument := ⟨[], []⟩

/-- A single step that relies on no judgment call, e.g. a fact or a connective
("Step 2 of the plan: …", "Therefore …"). -/
def note (claim citation : String) : Argument := ⟨[⟨claim, citation⟩], []⟩

/-- A finding's reasons, as an argument. -/
def ofFinding (f : Finding) : Argument := ⟨f.steps, f.reliesOn⟩

/-- One argument followed by another. -/
def append (a b : Argument) : Argument :=
  ⟨a.steps ++ b.steps, mergeIds a.reliesOn b.reliesOn⟩

instance : Append Argument := ⟨append⟩

/-- Several arguments, one after the other. -/
def concat (as : List Argument) : Argument :=
  as.foldl (· ++ ·) empty

/-- The argument's overall risk: the highest risk among the judgment calls it relies on. -/
def risk (registry : List Judgment) (a : Argument) : Risk :=
  riskOf registry a.reliesOn

/-- The numbered argument, then the judgment calls it relies on (question, assumed
answer, risk) and the overall risk. Ids missing from the registry are listed as
unregistered, so a dependency is never silently dropped. -/
def render (registry : List Judgment) (a : Argument) : String :=
  let answer (b : Bool) := if b then "yes" else "no"
  let line (id : String) : String :=
    match Judgment.find? registry id with
    | some j => s!"- {j.id}: {j.question} Assumed: {answer j.answer}. Risk: {j.risk}."
    | none => s!"- {id}: (not in the judgment registry)"
  let tail :=
    if a.reliesOn.isEmpty then
      ["Relies on no judgment calls."]
    else
      "Relies on these judgment calls:" :: a.reliesOn.map line ++
        [s!"Overall risk: {a.risk registry}."]
  "\n".intercalate (renderSteps 1 a.steps ++ tail)

/-! ## Facts about combining arguments -/

@[simp] theorem steps_append (a b : Argument) : (a ++ b).steps = a.steps ++ b.steps := rfl

@[simp] theorem reliesOn_append (a b : Argument) :
    (a ++ b).reliesOn = mergeIds a.reliesOn b.reliesOn := rfl

/-- Every judgment call relied on by either part is relied on by the whole. -/
theorem mem_reliesOn_append {a b : Argument} {id : String} :
    id ∈ (a ++ b).reliesOn ↔ id ∈ a.reliesOn ∨ id ∈ b.reliesOn :=
  mem_mergeIds

theorem risk_le_append_left (registry : List Judgment) (a b : Argument) :
    (a.risk registry).rank ≤ ((a ++ b).risk registry).rank :=
  riskOf_mono registry fun _ h => mem_reliesOn_append.mpr (.inl h)

theorem risk_le_append_right (registry : List Judgment) (a b : Argument) :
    (b.risk registry).rank ≤ ((a ++ b).risk registry).rank :=
  riskOf_mono registry fun _ h => mem_reliesOn_append.mpr (.inr h)

@[simp] theorem risk_ofFinding (registry : List Judgment) (f : Finding) :
    (ofFinding f).risk registry = findingRisk registry f := rfl

end Argument

/-- A finding's argument followed by the judgment calls it relies on and its risk. -/
def Finding.renderWithJudgments (registry : List Judgment) (f : Finding) : String :=
  (Argument.ofFinding f).render registry

end Canteen

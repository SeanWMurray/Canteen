import TaxLean.Core.Rule

/-!
# Rendering

Turning a `Finding` into a numbered, cited English argument (design §4.3, §5).
-/

namespace TaxLean

/-- Number the steps starting at `n`: `"n. claim [citation]"`. -/
def renderSteps : Nat → List Step → List String
  | _, [] => []
  | n, s :: rest => s!"{n}. {s.claim} [{s.citation}]" :: renderSteps (n + 1) rest

namespace Finding

/-- The finding's argument as numbered lines, one per step. -/
def render (f : Finding) : String :=
  "\n".intercalate (renderSteps 1 f.steps)

/-- The argument followed by the judgment calls it relies on, each with its
question, assumed answer and risk, and the overall risk. Judgment ids missing
from the registry are listed as unregistered so they are never silently dropped. -/
def renderWithJudgments (registry : List Judgment) (f : Finding) : String :=
  let answer (b : Bool) := if b then "yes" else "no"
  let line (id : String) : String :=
    match Judgment.find? registry id with
    | some j => s!"- {j.id}: {j.question} Assumed: {answer j.answer}. Risk: {j.risk}."
    | none => s!"- {id}: (not in the judgment registry)"
  let tail :=
    if f.reliesOn.isEmpty then
      ["Relies on no judgment calls."]
    else
      "Relies on these judgment calls:" :: f.reliesOn.map line ++
        [s!"Overall risk: {findingRisk registry f}."]
  "\n".intercalate (renderSteps 1 f.steps ++ tail)

end Finding

theorem renderSteps_length (n : Nat) (ss : List Step) : (renderSteps n ss).length = ss.length := by
  induction ss generalizing n with
  | nil => rfl
  | cons _ _ ih => simp [renderSteps, ih]

namespace Rule

variable {Facts : Type}

/-- The rule's explanation for these facts as a numbered English argument. -/
def explainText (r : Rule Facts) (f : Facts) : String :=
  (r.explain f).render

end Rule

end TaxLean

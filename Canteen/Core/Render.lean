import Canteen.Core.Rule

/-!
# Rendering

Turning a `Finding` into a numbered, cited English argument (design §4.3, §5).
-/

namespace Canteen

/-- Number the steps starting at `n`: `"n. claim [citation]"`. -/
def renderSteps : Nat → List Step → List String
  | _, [] => []
  | n, s :: rest => s!"{n}. {s.claim} [{s.citation}]" :: renderSteps (n + 1) rest

namespace Finding

/-- The finding's argument as numbered lines, one per step. -/
def render (f : Finding) : String :=
  "\n".intercalate (renderSteps 1 f.steps)

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

end Canteen

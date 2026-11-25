-- expect: has unproven statements: [S1]
/-
Phase 5 check: a memo statement backed by a proof with a gap is shown as unproven,
and the blueprint is refused.
-/
import Canteen.Core.Blueprint

open Lean Canteen Canteen.Blueprint

theorem claimed : 2 + 2 = 5 := by
  sorry

def memo : Blueprint where
  title := "A memo with a gap"
  sections := [{ heading := "Analysis", nodes := [
    { id := "S1", kind := .step, title := "A claim", statement := "Two and two make five.", lean := [``claimed] } ] }]

#eval show CoreM Unit from check memo

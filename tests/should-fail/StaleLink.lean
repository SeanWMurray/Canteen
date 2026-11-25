-- expect: Unknown constant
/-
Phase 5 check: a memo cannot link to a theorem that does not exist (for example, one
that was renamed or deleted). The link is a build error, not a dead link.
-/
import Canteen.Blueprints.SpouseRepurchase

open Lean Canteen Canteen.Blueprint

def memo : Blueprint where
  title := "A memo with a stale link"
  sections := [{ heading := "Analysis", nodes := [
    { id := "S1", kind := .step, title := "A claim", statement := "The loss is nil.",
      lean := [``Canteen.Transactions.SpouseRepurchase.loss_is_nil_renamed] } ] }]

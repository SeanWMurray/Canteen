-- expect: has hidden dependencies
/-
Extension check: a memo may not understate what its conclusions depend on. Here the
step's proof uses the sale (the period is counted from its date), but the memo does not
say the step uses the sale. `Blueprint.check` finds the dependency in the proof and refuses
the memo.
-/
import Canteen.Blueprints.SpouseRepurchase

open Lean Canteen Canteen.Blueprint Canteen.Transactions.SpouseRepurchase

def memo : Blueprint where
  title := "A memo that hides a dependency"
  sections := [{ heading := "Analysis", nodes := [
    { id := "F1", kind := .fact, title := "The sale", statement := "The sale.", lean := [``sale] },
    { id := "F3", kind := .fact, title := "The purchase", statement := "The purchase.", lean := [``spousePurchase] },
    { id := "A2", kind := .step, title := "In the period", statement := "The purchase is in the period.",
      lean := [``purchase_in_period], uses := ["F3"] } ] }]

#eval show CoreM Unit from check memo

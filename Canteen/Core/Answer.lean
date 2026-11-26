import Canteen.Core.Branch

/-!
# Answers: a fact, or a judgment call

Many conditions are sometimes settled by the facts and sometimes a matter of judgment
(for example, whether two persons deal at arm's length). An `Answer` records which, so a
rule can rely on the judgment call only when there is one (design principle 1).
-/

namespace Canteen

/-- The answer to a yes-or-no question: settled by the facts, or a judgment call. -/
inductive Answer where
  /-- Settled by the facts. -/
  | fact (value : Bool)
  /-- A judgment call, with the answer assumed on this branch. -/
  | judged (judgment : String) (assumed : Bool)
  deriving Repr, DecidableEq, Inhabited

namespace Answer

/-- The answer on this branch. -/
def value : Answer → Bool
  | .fact b => b
  | .judged _ b => b

/-- The judgment calls the answer rests on: none for a fact. -/
def judgments : Answer → List String
  | .fact _ => []
  | .judged j _ => [j]

/-- Judgment call `id`, answered as on `branch`. -/
def ofBranch (id : String) (branch : List Judgment) : Answer :=
  .judged id (answerOf branch id)

@[simp] theorem value_fact (b : Bool) : (Answer.fact b).value = b := rfl
@[simp] theorem value_judged (j : String) (b : Bool) : (Answer.judged j b).value = b := rfl
@[simp] theorem judgments_fact (b : Bool) : (Answer.fact b).judgments = [] := rfl

end Answer

end Canteen

import Canteen.Core.Argument
import Canteen.Core.Series

/-!
# Series reports

Rules applied after every step of a transaction series, and the whole series
rendered as one numbered English argument (design §5 level 2, roadmap Phase 3).
`reportSeries_sound` proves the reported conclusions are exactly the rules'
results on the states the series passes through.
-/

namespace Canteen

variable {State : Type}

/-- What the rules found after one step of a series. -/
structure StepReport (State : Type) where
  /-- The step's number in the plan, from 1. -/
  index : Nat
  /-- What the step does. -/
  description : String
  /-- The state after the step. -/
  after : State
  /-- One finding per rule, in the order the rules were given. -/
  findings : List Finding

/-- Apply every rule after every step, numbering the steps from `n`. -/
def reportSeries (rules : List (Rule State)) : Nat → List (TxStep State) → State → List (StepReport State)
  | _, [], _ => []
  | n, st :: rest, s =>
    let s' := st.apply s
    ⟨n, st.description, s', rules.map (·.explain s')⟩ :: reportSeries rules (n + 1) rest s'

theorem traceSeries_eq_cons (steps : List (TxStep State)) (s : State) :
    traceSeries steps s = s :: (traceSeries steps s).tail := by
  cases steps <;> rfl

/-- The report's conclusions are the rules' results on every state after the start. -/
theorem reportSeries_sound (rules : List (Rule State)) (n : Nat)
    (steps : List (TxStep State)) (s : State) :
    (reportSeries rules n steps s).map (fun sr => sr.findings.map (·.conclusion)) =
      (traceSeries steps s).tail.map (fun t => rules.map (·.holds t)) := by
  induction steps generalizing n s with
  | nil => rfl
  | cons st rest ih =>
    simp only [reportSeries, List.map_cons, List.map_map, traceSeries, List.tail_cons]
    rw [ih, traceSeries_eq_cons rest (st.apply s)]
    simp [Function.comp_def]

/-- "1", "1 and 2", "1, 2 and 3". -/
def englishList : List String → String
  | [] => ""
  | [a] => a
  | [a, b] => s!"{a} and {b}"
  | a :: rest => s!"{a}, {englishList rest}"

/-- The steps after which `r` applies, as a sentence. -/
def appliesAfterSentence (reports : List (StepReport State)) (r : Rule State) : String :=
  match reports.filter (fun sr => r.holds sr.after) |>.map (·.index) with
  | [] => s!"{r.name} does not apply after any step."
  | [i] => s!"{r.name} applies after step {i} only."
  | is => s!"{r.name} applies after steps {englishList (is.map toString)}."

/-- The whole series as one argument: each step, the rules' reasons after it, then a
summary of when each rule applies. -/
def explainSeries (rules : List (Rule State)) (steps : List (TxStep State)) (s : State) : Argument :=
  let reports := reportSeries rules 1 steps s
  let body := reports.map fun sr =>
    Argument.note s!"Step {sr.index}: {sr.description}." s!"plan, step {sr.index}" ++
      Argument.concat (sr.findings.map Argument.ofFinding)
  let summary := rules.map fun r =>
    Argument.note s!"So, across the plan: {appliesAfterSentence reports r}" r.citation
  Argument.concat (body ++ summary)

end Canteen

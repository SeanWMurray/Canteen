/-!
# Series of transactions

A transaction series is a state that changes step by step (design §4.6).
`State` will later carry tax attributes (cost amounts, capital accounts and so
on). Properties of a whole series are proven by induction over the step list;
`runSeries_invariant` and `traceSeries_invariant` package that induction once.
-/

namespace Canteen

/-- One step of a transaction series. -/
structure TxStep (State : Type) where
  /-- What the step does, in plain English. -/
  description : String
  /-- The step's effect on the state. -/
  apply : State → State

variable {State : Type}

/-- The state after running every step in order. -/
def runSeries : List (TxStep State) → State → State
  | [], s => s
  | step :: rest, s => runSeries rest (step.apply s)

/-- Every state the series passes through: the start state, then the state after each step. -/
def traceSeries : List (TxStep State) → State → List State
  | [], s => [s]
  | step :: rest, s => s :: traceSeries rest (step.apply s)

@[simp] theorem runSeries_nil (s : State) : runSeries [] s = s := rfl

@[simp] theorem runSeries_cons (step : TxStep State) (rest : List (TxStep State)) (s : State) :
    runSeries (step :: rest) s = runSeries rest (step.apply s) := rfl

/-- Running two series back to back is running their concatenation. -/
theorem runSeries_append (xs ys : List (TxStep State)) (s : State) :
    runSeries (xs ++ ys) s = runSeries ys (runSeries xs s) := by
  induction xs generalizing s with
  | nil => rfl
  | cons _ _ ih => exact ih _

/-- If every step preserves `P`, the whole series preserves `P`. -/
theorem runSeries_invariant (P : State → Prop) (steps : List (TxStep State))
    (hstep : ∀ st ∈ steps, ∀ s, P s → P (st.apply s)) :
    ∀ s, P s → P (runSeries steps s) := by
  induction steps with
  | nil => intro s hs; exact hs
  | cons st rest ih =>
    intro s hs
    exact ih (fun st' h => hstep st' (List.mem_cons_of_mem _ h)) _
      (hstep st (List.mem_cons_self ..) s hs)

@[simp] theorem traceSeries_length (steps : List (TxStep State)) (s : State) :
    (traceSeries steps s).length = steps.length + 1 := by
  induction steps generalizing s with
  | nil => rfl
  | cons _ _ ih => simp [traceSeries, ih]

/-- The final state of the trace is the result of `runSeries`. -/
theorem traceSeries_getLast? (steps : List (TxStep State)) (s : State) :
    (traceSeries steps s).getLast? = some (runSeries steps s) := by
  induction steps generalizing s with
  | nil => rfl
  | cons st rest ih =>
    cases rest with
    | nil => rfl
    | cons st' rest' =>
      simp only [traceSeries] at ih ⊢
      rw [List.getLast?_cons_cons]
      exact ih _

/-- If the start state satisfies `P` and every step preserves `P`, then every
state the series passes through satisfies `P`. For example: "rule X never
triggers at any step". -/
theorem traceSeries_invariant (P : State → Prop) (steps : List (TxStep State))
    (hstep : ∀ st ∈ steps, ∀ s, P s → P (st.apply s)) :
    ∀ s, P s → ∀ t ∈ traceSeries steps s, P t := by
  induction steps with
  | nil =>
    intro s hs t ht
    simp only [traceSeries, List.mem_singleton] at ht
    exact ht ▸ hs
  | cons st rest ih =>
    intro s hs t ht
    simp only [traceSeries, List.mem_cons] at ht
    rcases ht with rfl | ht
    · exact hs
    · exact ih (fun st' h => hstep st' (List.mem_cons_of_mem _ h)) _
        (hstep st (List.mem_cons_self ..) s hs) t ht

end Canteen

import TaxLean.Core.Series

/-!
# Tests: transaction series

A toy series over a simple state, checking `runSeries`, `traceSeries` and the
invariant lemmas.
-/

namespace TaxLean.Tests.Series

open TaxLean

/-- A toy state: an adjusted cost base and a count of dispositions. -/
structure ToyState where
  acb : Nat
  dispositions : Nat
  deriving Repr, DecidableEq

def buy (amount : Nat) : TxStep ToyState :=
  ⟨s!"Buy for {amount}", fun s => { s with acb := s.acb + amount }⟩

def sellAll : TxStep ToyState :=
  ⟨"Sell all", fun s => { acb := 0, dispositions := s.dispositions + 1 }⟩

def plan : List (TxStep ToyState) := [buy 100, buy 50, sellAll, buy 30]

def start : ToyState := ⟨0, 0⟩

example : runSeries plan start = ⟨30, 1⟩ := rfl
example : traceSeries plan start = [⟨0, 0⟩, ⟨100, 0⟩, ⟨150, 0⟩, ⟨0, 1⟩, ⟨30, 1⟩] := rfl
example : runSeries ([buy 100] ++ [sellAll]) start = runSeries [sellAll] (runSeries [buy 100] start) :=
  runSeries_append _ _ _

/-- No step ever reduces the number of dispositions, so it never goes below its start value. -/
theorem dispositions_monotone (n : Nat) :
    ∀ t ∈ traceSeries plan ⟨0, n⟩, n ≤ t.dispositions := by
  refine traceSeries_invariant (fun s : ToyState => n ≤ s.dispositions) plan ?_ _ (Nat.le_refl n)
  intro st hst s hs
  simp only [plan, List.mem_cons, List.not_mem_nil, or_false] at hst
  rcases hst with rfl | rfl | rfl | rfl <;> simp [buy, sellAll] <;> omega

end TaxLean.Tests.Series

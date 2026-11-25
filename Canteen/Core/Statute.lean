import Canteen.Core.Combine

/-!
# Statute-shaped rules

Most provisions have one shape: *X applies where (a) … and (b) …, except where (c) … or
(d) ….* `Rule.statute` builds a rule of that shape from its conditions and exceptions,
each itself a `Rule` (a single `Rule.clause`, or any other rule). Its explanation is
derived from the same data, and `statuteFinding_conclusion` proves it sound once, for every
rule of this shape: a rule written this way needs no proof of its own.

The `statute` command (`Canteen/Core/StatuteSyntax.lean`) writes these in a form close to
the statute's own text.

The explanation follows design principle 3 (prefer facts over judgment): a failure on the
facts alone is cited before one that rests on a judgment call (`statute_explain_factual`).
-/

namespace Canteen.Rule

variable {Facts : Type}

/-- The citation of a paragraph: `"s.X"` and `"(a)"` give `"s.X(a)"`;
`"ITA 54 \"superficial loss\""` and `"(a)"` give `"ITA 54 \"superficial loss\" (a)"`;
a label that is not a paragraph letter is added after a space. -/
def subCitation (base label : String) : String :=
  if label.isEmpty then base
  else if label.startsWith "(" && !base.endsWith "\"" then base ++ label
  else s!"{base} {label}"

/-- A single condition: a test, the sentence when it is met and when it is not, and the
judgment calls it rests on (none, for a fact). -/
def clause (label citation : String) (test : Facts → Bool) (met notMet : String)
    (reliesOn : Facts → List String := fun _ => []) : Rule Facts where
  name := label
  citation := citation
  holds := test
  explain := fun f => ⟨test f, [⟨if test f then met else notMet, citation⟩], reliesOn f⟩
  sound := fun _ => rfl

/-- The explanation of a statute-shaped rule. In order: a condition that fails on the
facts alone; an exception that applies on the facts alone; any failing condition; any
applying exception; otherwise every condition and exception, and the rule applies. -/
def statuteFinding (name citation : String) (conds excs : List (Rule Facts)) (f : Facts) : Finding :=
  let neg (r : Rule Facts) : Finding :=
    ⟨false, (r.explain f).steps ++ [therefore name citation false], (r.explain f).reliesOn⟩
  match conds.find? (fun r => !(r.explain f).conclusion && (r.explain f).isFactual) with
  | some r => neg r
  | none =>
    match excs.find? (fun r => (r.explain f).conclusion && (r.explain f).isFactual) with
    | some r => neg r
    | none =>
      match conds.find? (fun r => !(r.explain f).conclusion) with
      | some r => neg r
      | none =>
        match excs.find? (fun r => (r.explain f).conclusion) with
        | some r => neg r
        | none =>
          let all := conds ++ excs
          ⟨true, all.flatMap (fun r => (r.explain f).steps) ++ [therefore name citation true],
            all.foldl (fun ids r => mergeIds ids (r.explain f).reliesOn) []⟩

/-- Soundness, once for every statute-shaped rule. -/
theorem statuteFinding_conclusion (name citation : String) (conds excs : List (Rule Facts)) (f : Facts) :
    (statuteFinding name citation conds excs f).conclusion =
      (conds.all (·.holds f) && !excs.any (·.holds f)) := by
  unfold statuteFinding
  cases h1 : conds.find? (fun r => !(r.explain f).conclusion && (r.explain f).isFactual) with
  | some r =>
    have hp := List.find?_some h1
    have hm := List.mem_of_find?_eq_some h1
    simp only [explain_conclusion, Bool.and_eq_true, Bool.not_eq_true'] at hp
    have : conds.all (·.holds f) = false := List.all_eq_false.mpr ⟨r, hm, by simp [hp.1]⟩
    simp [this]
  | none =>
  cases h2 : excs.find? (fun r => (r.explain f).conclusion && (r.explain f).isFactual) with
  | some r =>
    have hp := List.find?_some h2
    have hm := List.mem_of_find?_eq_some h2
    simp only [explain_conclusion, Bool.and_eq_true] at hp
    have : excs.any (·.holds f) = true := List.any_eq_true.mpr ⟨r, hm, hp.1⟩
    simp [this]
  | none =>
  cases h3 : conds.find? (fun r => !(r.explain f).conclusion) with
  | some r =>
    have hp := List.find?_some h3
    have hm := List.mem_of_find?_eq_some h3
    simp only [explain_conclusion, Bool.not_eq_true'] at hp
    have : conds.all (·.holds f) = false := List.all_eq_false.mpr ⟨r, hm, by simp [hp]⟩
    simp [this]
  | none =>
  cases h4 : excs.find? (fun r => (r.explain f).conclusion) with
  | some r =>
    have hp := List.find?_some h4
    have hm := List.mem_of_find?_eq_some h4
    simp only [explain_conclusion] at hp
    have : excs.any (·.holds f) = true := List.any_eq_true.mpr ⟨r, hm, hp⟩
    simp [this]
  | none =>
    rw [List.find?_eq_none] at h3 h4
    have hc : conds.all (·.holds f) = true := List.all_eq_true.mpr fun r hr => by
      simpa using h3 r hr
    have he : excs.any (·.holds f) = false := List.any_eq_false.mpr fun r hr => by
      simpa using h4 r hr
    simp [hc, he]

/-- A rule of the shape *`name` applies where every condition holds, except where an
exception applies*. Sound by `statuteFinding_conclusion`. -/
def statute (name citation : String) (conds excs : List (Rule Facts)) : Rule Facts where
  name := name
  citation := citation
  holds := fun f => conds.all (·.holds f) && !excs.any (·.holds f)
  explain := statuteFinding name citation conds excs
  sound := statuteFinding_conclusion name citation conds excs

@[simp] theorem statute_holds (name citation : String) (conds excs : List (Rule Facts)) (f : Facts) :
    (statute name citation conds excs).holds f = (conds.all (·.holds f) && !excs.any (·.holds f)) := rfl

@[simp] theorem clause_holds (label citation : String) (test : Facts → Bool) (met notMet : String)
    (reliesOn : Facts → List String) (f : Facts) :
    (clause label citation test met notMet reliesOn).holds f = test f := rfl

/-- Prefer facts over judgment: if a condition fails, or an exception applies, on the facts
alone, the explanation relies on no judgment call. -/
theorem statute_explain_factual (name citation : String) (conds excs : List (Rule Facts)) (f : Facts)
    (h : (∃ r ∈ conds, r.holds f = false ∧ (r.explain f).isFactual = true) ∨
         (∃ r ∈ excs, r.holds f = true ∧ (r.explain f).isFactual = true)) :
    ((statute name citation conds excs).explain f).isFactual = true := by
  simp only [statute, statuteFinding]
  cases h1 : conds.find? (fun r => !(r.explain f).conclusion && (r.explain f).isFactual) with
  | some r =>
    have hp := List.find?_some h1
    simp only [Bool.and_eq_true] at hp
    simpa [Finding.isFactual] using hp.2
  | none =>
  cases h2 : excs.find? (fun r => (r.explain f).conclusion && (r.explain f).isFactual) with
  | some r =>
    have hp := List.find?_some h2
    simp only [Bool.and_eq_true] at hp
    simpa [Finding.isFactual] using hp.2
  | none =>
    exfalso
    rw [List.find?_eq_none] at h1 h2
    rcases h with ⟨r, hr, hf, hfa⟩ | ⟨r, hr, ht, hfa⟩
    · exact h1 r hr (by simp [hf, hfa])
    · exact h2 r hr (by simp [ht, hfa])

end Canteen.Rule

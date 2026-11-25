import Canteen.Core.Rule

/-!
# Combining rules

Rules built from other rules (design §5, level 2). Each combinator is proven
sound once, so every rule built with them comes with a checked explanation:
there is nothing further to prove.

* `Rule.comap` uses a rule on a larger set of facts (e.g. a whole transaction).
* `Rule.and`, `Rule.or`, `Rule.not` build a named rule from others. The
  explanation chains the sub-arguments and ends with "Therefore …".

Where a combined conclusion could be explained by more than one sub-rule, the
explanation prefers one that rests on facts rather than judgment
(design principle 3; see `and_explain_factual`).
-/

namespace Canteen

namespace Rule

variable {Facts G : Type}

/-- "Therefore {name} applies." or "Therefore {name} does not apply." -/
def therefore (name citation : String) (applies : Bool) : Step :=
  if applies then ⟨s!"Therefore {name} applies.", citation⟩
  else ⟨s!"Therefore {name} does not apply.", citation⟩

/-- Use a rule on a different type of facts, by saying how to read its facts from them. -/
def comap (g : G → Facts) (r : Rule Facts) : Rule G where
  name := r.name
  citation := r.citation
  holds := r.holds ∘ g
  explain := r.explain ∘ g
  sound := fun x => r.sound (g x)

/-! ## `and` -/

/-- The explanation for "both apply". If both fail, it explains the failure with the
second rule only when that rests on facts and the first does not. -/
def andFinding (name citation : String) (e₁ e₂ : Finding) : Finding :=
  match e₁.conclusion, e₂.conclusion with
  | true, true =>
    ⟨true, e₁.steps ++ e₂.steps ++ [therefore name citation true], mergeIds e₁.reliesOn e₂.reliesOn⟩
  | true, false => ⟨false, e₂.steps ++ [therefore name citation false], e₂.reliesOn⟩
  | false, true => ⟨false, e₁.steps ++ [therefore name citation false], e₁.reliesOn⟩
  | false, false =>
    if e₂.isFactual && !e₁.isFactual then
      ⟨false, e₂.steps ++ [therefore name citation false], e₂.reliesOn⟩
    else
      ⟨false, e₁.steps ++ [therefore name citation false], e₁.reliesOn⟩

theorem andFinding_conclusion (name citation : String) (e₁ e₂ : Finding) :
    (andFinding name citation e₁ e₂).conclusion = (e₁.conclusion && e₂.conclusion) := by
  obtain ⟨c₁, _, _⟩ := e₁
  obtain ⟨c₂, _, _⟩ := e₂
  cases c₁ <;> cases c₂ <;> simp only [andFinding] <;> (try split) <;> rfl

/-- The rule `name` applies when both `r₁` and `r₂` apply. -/
def and (name citation : String) (r₁ r₂ : Rule Facts) : Rule Facts where
  name := name
  citation := citation
  holds := fun f => r₁.holds f && r₂.holds f
  explain := fun f => andFinding name citation (r₁.explain f) (r₂.explain f)
  sound := fun f => by simp [andFinding_conclusion]

/-! ## `or` -/

/-- The explanation for "either applies". If both apply, it explains the result with
the second rule only when that rests on facts and the first does not. -/
def orFinding (name citation : String) (e₁ e₂ : Finding) : Finding :=
  match e₁.conclusion, e₂.conclusion with
  | false, false =>
    ⟨false, e₁.steps ++ e₂.steps ++ [therefore name citation false], mergeIds e₁.reliesOn e₂.reliesOn⟩
  | false, true => ⟨true, e₂.steps ++ [therefore name citation true], e₂.reliesOn⟩
  | true, false => ⟨true, e₁.steps ++ [therefore name citation true], e₁.reliesOn⟩
  | true, true =>
    if e₂.isFactual && !e₁.isFactual then
      ⟨true, e₂.steps ++ [therefore name citation true], e₂.reliesOn⟩
    else
      ⟨true, e₁.steps ++ [therefore name citation true], e₁.reliesOn⟩

theorem orFinding_conclusion (name citation : String) (e₁ e₂ : Finding) :
    (orFinding name citation e₁ e₂).conclusion = (e₁.conclusion || e₂.conclusion) := by
  obtain ⟨c₁, _, _⟩ := e₁
  obtain ⟨c₂, _, _⟩ := e₂
  cases c₁ <;> cases c₂ <;> simp only [orFinding] <;> (try split) <;> rfl

/-- The rule `name` applies when `r₁` or `r₂` (or both) apply. -/
def or (name citation : String) (r₁ r₂ : Rule Facts) : Rule Facts where
  name := name
  citation := citation
  holds := fun f => r₁.holds f || r₂.holds f
  explain := fun f => orFinding name citation (r₁.explain f) (r₂.explain f)
  sound := fun f => by simp [orFinding_conclusion]

/-! ## `not` -/

/-- The rule `name` applies exactly when `r` does not, e.g. "unless Rule X applies". -/
def not (name citation : String) (r : Rule Facts) : Rule Facts where
  name := name
  citation := citation
  holds := fun f => !r.holds f
  explain := fun f =>
    let e := r.explain f
    ⟨!e.conclusion, e.steps ++ [therefore name citation !e.conclusion], e.reliesOn⟩
  sound := fun f => by simp

/-! ## Facts about the combinators -/

@[simp] theorem comap_holds (g : G → Facts) (r : Rule Facts) (x : G) :
    (r.comap g).holds x = r.holds (g x) := rfl

@[simp] theorem and_holds (n c : String) (r₁ r₂ : Rule Facts) (f : Facts) :
    (Rule.and n c r₁ r₂).holds f = (r₁.holds f && r₂.holds f) := rfl

@[simp] theorem or_holds (n c : String) (r₁ r₂ : Rule Facts) (f : Facts) :
    (Rule.or n c r₁ r₂).holds f = (r₁.holds f || r₂.holds f) := rfl

@[simp] theorem not_holds (n c : String) (r : Rule Facts) (f : Facts) :
    (Rule.not n c r).holds f = !r.holds f := rfl

/-- Prefer facts over judgment: if a combined `and` fails and either part fails on
the facts alone (relying on no judgment call), the combined explanation relies on
no judgment call either. -/
theorem and_explain_factual (n c : String) (r₁ r₂ : Rule Facts) (f : Facts)
    (h : (r₁.holds f = false ∧ (r₁.explain f).isFactual = true) ∨
         (r₂.holds f = false ∧ (r₂.explain f).isFactual = true)) :
    ((Rule.and n c r₁ r₂).explain f).isFactual = true := by
  simp only [Rule.and]
  rw [← r₁.sound f, ← r₂.sound f] at h
  generalize r₁.explain f = e₁ at h ⊢
  generalize r₂.explain f = e₂ at h ⊢
  obtain ⟨c₁, s₁, d₁⟩ := e₁
  obtain ⟨c₂, s₂, d₂⟩ := e₂
  cases c₁ <;> cases c₂ <;> simp_all [andFinding, Finding.isFactual] <;> split <;> rcases h with h | h <;> simp_all

/-- Prefer facts over judgment, for `or`: if a combined `or` applies and either part
applies on the facts alone, the combined explanation relies on no judgment call. -/
theorem or_explain_factual (n c : String) (r₁ r₂ : Rule Facts) (f : Facts)
    (h : (r₁.holds f = true ∧ (r₁.explain f).isFactual = true) ∨
         (r₂.holds f = true ∧ (r₂.explain f).isFactual = true)) :
    ((Rule.or n c r₁ r₂).explain f).isFactual = true := by
  simp only [Rule.or]
  rw [← r₁.sound f, ← r₂.sound f] at h
  generalize r₁.explain f = e₁ at h ⊢
  generalize r₂.explain f = e₂ at h ⊢
  obtain ⟨c₁, s₁, d₁⟩ := e₁
  obtain ⟨c₂, s₂, d₂⟩ := e₂
  cases c₁ <;> cases c₂ <;> simp_all [orFinding, Finding.isFactual] <;> split <;> rcases h with h | h <;> simp_all

end Rule

end Canteen

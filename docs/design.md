# TaxLean: A Verified Reasoning Language for Tax Analysis

**Status:** Design draft, v0.1
**Scope:** Purpose, architecture and the technical foundation (the core language). Encoding specific *Income Tax Act* provisions is out of scope here and comes in later phases.

---

## 1. Purpose

Tax analysis is a chain of reasoning: *these facts satisfy these conditions, so this provision applies, so this outcome follows.* Today that chain lives in memos and in people's heads. A missed condition, a misapplied exception, or a "therefore" that doesn't actually follow can go unnoticed.

TaxLean is a framework built on the **Lean 4** proof assistant that lets us:

1. **Encode statutory rules as precise definitions.** Each provision becomes a definition with its conditions and exceptions written out exactly.
2. **Represent judgment calls explicitly.** Questions the statute leaves to judgment (for example, purpose tests) become named true/false switches with a risk rating. They are never silently assumed.
3. **Prove conclusions mechanically.** Lean checks every logical step. A conclusion is accepted only if it follows from the encoded rules and the stated facts.
4. **Reason across branches.** For any judgment call we can (a) assume one answer, (b) split into both branches, or (c) prove a conclusion holds on *every* branch, meaning the judgment call doesn't matter.
5. **Build reusable truths.** Results proven once about a provision become building blocks for analyzing future transactions.
6. **Produce English arguments.** Every finding carries a plain-English, cited, numbered argument, and Lean proves that argument agrees with the underlying logic.

### What it does and does not guarantee

| Lean guarantees | Lean does **not** guarantee |
|---|---|
| Every proven conclusion follows logically from the definitions and facts | That the definitions faithfully match the statute |
| No step was skipped (checked with `#print axioms`) | That the facts entered are true |
| The English explanation agrees with the formal rule | That the CRA or a court will agree |
| Changing a rule flags every proof that depends on it | That a judgment call was answered correctly |

The right-hand column is managed through the validation practices in §6.

---

## 2. Key Concepts

| Concept | Meaning in TaxLean |
|---|---|
| **Rule** | A statutory provision encoded as a function from facts to a true/false result, bundled with its English explanation and a proof that the two agree. |
| **Facts** | A structured record of the inputs a rule needs. Some fields are computed (e.g., amounts compared), others are judgment calls. |
| **Judgment** | A fact that requires professional judgment. It carries an ID, the question it answers, the answer assumed, and a risk level. |
| **Finding** | The result of applying a rule: the conclusion, the numbered English steps that led there, and the judgment calls it relied on. |
| **Lemma / theorem** | A proven truth about one or more rules, e.g., "if condition X fails, the rule never applies, whatever the judgment calls." |
| **Scenario** | One complete setting of all facts and switches, i.e. one branch. |
| **Series** | An ordered list of transaction steps, where each step's output state feeds the next. |

---

## 3. Architecture: Four Layers

Each layer may only depend on the layers below it.

```
┌──────────────────────────────────────────────────────────┐
│ Layer 4  Series of transactions                          │
│          Multi-step plans; invariants proven across steps│
├──────────────────────────────────────────────────────────┤
│ Layer 3  Specific transactions                           │
│          Concrete fact patterns; outcomes proven         │
├──────────────────────────────────────────────────────────┤
│ Layer 2  Reusable lemmas                                 │
│          Proven truths about individual provisions       │
├──────────────────────────────────────────────────────────┤
│ Layer 1  Statute encoding                                │
│          One definition per provision/paragraph          │
├──────────────────────────────────────────────────────────┤
│ Layer 0  Core language (this document)                   │
│          Rule, Facts, Judgment, Finding, Risk, Series,   │
│          rendering, validation tooling                   │
└──────────────────────────────────────────────────────────┘
```

- **Layer 0** is generic: it knows nothing about tax. It defines the vocabulary every rule uses.
- **Layer 1** is the trusted base. It is not proven, so it must be reviewed carefully against the statute.
- **Layers 2–4** are fully checked by Lean.

---

## 4. Technical Foundation

### 4.1 Toolchain

| Component | Purpose |
|---|---|
| **Lean 4** | The language and proof checker |
| **elan** | Lean version manager (installs and pins the toolchain) |
| **Lake** | Lean's build tool and package manager |
| **VS Code + "Lean 4" extension** | Editor with the live goal/infoview panel |
| **Git** | Version control; each statutory amendment is a commit |
| **Mathlib** *(optional, later)* | Extra tactics and exact rational numbers; not needed for Phase 1 |
| **Lean Blueprint** *(later)* | English argument documents linked to Lean theorems, with dependency graphs |

Setup:

```bash
# Install elan (which installs Lean)
curl https://elan.lean-lang.org/elan-init.sh -sSf | sh

# Create the project
lake new TaxLean
cd TaxLean
lake build
```

### 4.2 Project layout

```
TaxLean/
├── lean-toolchain            # pinned Lean version
├── lakefile.toml             # build configuration
├── TaxLean.lean              # root file; imports everything
├── TaxLean/
│   ├── Core/                 # Layer 0 — generic language
│   │   ├── Risk.lean
│   │   ├── Judgment.lean
│   │   ├── Finding.lean
│   │   ├── Rule.lean
│   │   ├── Series.lean
│   │   └── Render.lean
│   ├── ITA/                  # Layer 1 — one file per provision (later)
│   ├── Lemmas/               # Layer 2 — reusable truths (later)
│   ├── Transactions/         # Layers 3–4 — specific deals (later)
│   └── Tests/                # known-answer and sanity tests
└── blueprint/                # English argument documents (later)
```

### 4.3 Core types (Layer 0)

> The code below is a design sketch. It has not been compiled yet, so expect minor fixes on the first `lake build`.

**Risk**: how confident we are in a judgment call.

```lean
namespace TaxLean

inductive Risk where
  | low | medium | high
  deriving Repr, DecidableEq

def Risk.rank : Risk → Nat
  | .low => 0 | .medium => 1 | .high => 2

def Risk.max (a b : Risk) : Risk :=
  if a.rank ≥ b.rank then a else b
```

**Judgment**: a fact the model can't compute and must be told.

```lean
structure Judgment where
  id       : String   -- stable identifier, e.g. "J-001"
  question : String   -- the question in plain English
  answer   : Bool     -- the answer assumed on this branch
  risk     : Risk     -- confidence in that answer
  deriving Repr
```

**Step and Finding**: the result of applying a rule, with its reasoning.

```lean
structure Step where
  claim    : String   -- one English sentence
  citation : String   -- statutory reference
  deriving Repr

structure Finding where
  conclusion : Bool
  steps      : List Step
  reliesOn   : List String   -- Judgment ids this conclusion depends on
  deriving Repr
```

**Rule**: the central abstraction. A rule cannot be built unless it comes with a proof that its English explanation agrees with its logic.

```lean
structure Rule (Facts : Type) where
  name     : String
  citation : String
  holds    : Facts → Bool        -- the rule itself
  explain  : Facts → Finding     -- the same rule, with reasons
  sound    : ∀ f, (explain f).conclusion = holds f
```

The `sound` field is the key design choice. The English output is not a separate, unchecked layer: Lean refuses to accept a rule whose explanation could ever contradict its logic.

**Rendering**: turning a Finding into a numbered English argument.

```lean
def renderSteps : Nat → List Step → List String
  | _, [] => []
  | n, s :: rest => s!"{n}. {s.claim} [{s.citation}]" :: renderSteps (n + 1) rest

def Finding.render (f : Finding) : String :=
  "\n".intercalate (renderSteps 1 f.steps)
```

### 4.4 A generic worked example

A placeholder rule, not a real provision: *"Rule X applies if conditions A and B are met and no exception applies."*

```lean
structure XFacts where
  condA     : Bool
  condB     : Bool   -- a judgment call
  exception : Bool

def xHolds (f : XFacts) : Bool :=
  f.condA && f.condB && !f.exception

def xExplain (f : XFacts) : Finding :=
  if f.condA = false then
    ⟨false, [⟨"Condition A is not met, so Rule X does not apply.", "s.X(a)"⟩], []⟩
  else if f.exception = true then
    ⟨false, [⟨"The exception applies, so Rule X does not apply.", "s.X(c)"⟩], []⟩
  else if f.condB = false then
    ⟨false, [⟨"Condition B is not met, so Rule X does not apply.", "s.X(b)"⟩], ["J-B"]⟩
  else
    ⟨true, [⟨"Conditions A and B are met and no exception applies, so Rule X applies.", "s.X"⟩], ["J-B"]⟩

theorem xExplain_sound (f : XFacts) : (xExplain f).conclusion = xHolds f := by
  obtain ⟨a, b, e⟩ := f
  cases a <;> cases b <;> cases e <;> decide

def ruleX : Rule XFacts :=
  { name := "Rule X", citation := "s.X",
    holds := xHolds, explain := xExplain, sound := xExplain_sound }
```

The explanation checks the computable conditions (A, the exception) before the judgment call (B). Where possible, a conclusion then rests on facts rather than judgment, and `reliesOn` stays empty.

**A Layer 2 lemma: conclusions that don't depend on the judgment call**

```lean
theorem x_fails_without_A :
    ∀ b e : Bool, xHolds ⟨false, b, e⟩ = false := by
  decide
```

This proves Rule X never applies without condition A, whatever the answer to judgment call B. `decide` checks every branch automatically.

### 4.5 Three ways to handle a judgment call

| Technique | Lean mechanism | Use when |
|---|---|---|
| **Assume** | Fix the switch in the scenario, or take it as a hypothesis `(h : f.condB = true)` | You've reached a position on the judgment call |
| **Branch** | `by_cases h : f.condB = true`, or `cases` on the Bool | You want to set out both outcomes |
| **Make it irrelevant** | `∀ b : Bool, …` proven by `decide` | You can show the outcome is the same either way: the strongest result |

**Branch risk.** A Finding's overall risk is the highest risk among the judgment calls it relies on:

```lean
def findingRisk (registry : List Judgment) (f : Finding) : Risk :=
  registry.foldl
    (fun r j => if f.reliesOn.contains j.id then r.max j.risk else r)
    .low
```

### 4.6 Series of transactions (Layer 4 foundation)

A transaction series is modelled as a state that changes step by step:

```lean
structure TxStep (State : Type) where
  description : String
  apply       : State → State

def runSeries {State : Type} : List (TxStep State) → State → State
  | [], s => s
  | step :: rest, s => runSeries rest (step.apply s)
```

`State` will later carry tax attributes (cost amounts, capital accounts and so on). Properties of a whole series, like "rule X never triggers at any step," are proven by induction over the step list.

---

## 5. From Logic to English Arguments

Three levels, built in order:

1. **Per-rule explanations (Phase 1).** Every `Rule` carries `explain`, with soundness proven. `#eval (ruleX.explain facts).render` prints a cited argument.
2. **Chained arguments (Phase 3).** Findings from several rules and steps are joined into one numbered argument ("1. Because… 2. Therefore…") with judgment calls listed at the end, each with its risk.
3. **Blueprint documents (Phase 4).** Memo-style English write-ups where each statement links to the Lean theorem behind it, with a dependency graph showing which judgment calls each conclusion rests on.

---

## 6. Validation: Working Without a Reviewer

Lean checks the logic. These practices check the parts Lean can't:

| Practice | How |
|---|---|
| **Known-answer tests** | Encode worked examples (published interpretations, textbook examples, decided cases) as `example` statements in `Tests/`. A wrong encoding fails to prove. |
| **Sanity theorems** | Prove properties the statute obviously has. If one won't prove, the encoding is wrong. |
| **Non-vacuity checks** | For every rule, show one scenario where it applies and one where it doesn't (`#eval` or `example … := by decide`). This guards against contradictory definitions. |
| **No hidden gaps** | Ban `sorry` and `axiom` in committed code; run `#print axioms` on key theorems. |
| **Mirror the statute** | One definition per paragraph, labelled with its citation, and no clever compression. Reviewable line by line against the Act. |
| **Read-back** | Render each rule's explanation for all branches and compare it with the statute text. Optionally, have an AI paraphrase the Lean definitions without seeing the statute. |
| **Continuous build** | Run `lake build` on every commit (e.g., GitHub Actions). Amending a definition immediately shows every proof and test that breaks. |

---

## 7. Roadmap

| Phase | Deliverable | Done when |
|---|---|---|
| **0. Setup** | Toolchain installed, empty project builds | `lake build` succeeds |
| **1. Core language** | `Risk`, `Judgment`, `Step`, `Finding`, `Rule`, rendering, the Rule X example | Example compiles; soundness and branch lemmas proven |
| **2. Validation harness** | `Tests/` structure, non-vacuity template, CI build, axiom check | A deliberately broken rule is caught automatically |
| **3. Chaining & series** | Combining findings, `TxStep`/`runSeries`, branch risk reporting | A multi-step toy series renders a full English argument |
| **4. First real provision** | One provision with its exceptions fully encoded, plus known-answer tests | All tests pass; output reviewed against the statute |
| **5. Blueprint** | English argument document linked to Lean theorems | Dependency graph shows proven/unproven status |
| **6. Ergonomics** *(optional)* | Custom Lean syntax (`syntax`/`macro_rules`) so rules read closer to statutory language | Rules can be written in a statute-like form |

---

## 8. Design Principles

1. **Judgment is never hidden.** Every judgment call is a named, risk-rated switch.
2. **Explanations are checked.** No rule exists without a proof that its English agrees with its logic.
3. **Prefer facts over judgment.** Explanations test computable conditions first, so conclusions rest on judgment only when they have to.
4. **Mirror the source.** The encoding follows the statute's structure, even when a shorter form is possible.
5. **Build upward.** Prove small truths once and reuse them; never re-derive.
6. **Every assumption is visible.** A conclusion's dependencies — statute, facts, judgment calls — can always be listed.

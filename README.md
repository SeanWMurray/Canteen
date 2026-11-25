# Canteen

A verified reasoning language for tax analysis, built on the [Lean 4](https://lean-lang.org) proof assistant.
Statutory rules are encoded as precise definitions. Judgment calls are named, risk-rated switches.
Every conclusion is proven mechanically and comes with a numbered, cited English argument that Lean proves agrees with the logic.

The full design is in [`docs/design.md`](docs/design.md).

## Status

| Phase | | |
|---|---|---|
| 0. Setup | Done | Lean 4.36.0 pinned in `lean-toolchain`; `lake build` succeeds |
| 1. Core language | Done | `Risk`, `Judgment`, `Step`, `Finding`, `Rule`, rendering, series, and the Rule X example with its soundness and branch lemmas |
| 2. Validation harness | Done | Tests, non-vacuity, read-back, axiom audit, CI, and broken rules caught automatically |
| 3. Chaining and series | Done | Chained arguments, rule combinators, branches over judgment calls with risk, series reports; a toy series renders a full English argument |
| 4–6 | Not started | First real provision, blueprint, ergonomics |

## Building

Install [elan](https://github.com/leanprover/elan) (the Lean version manager), then from the repository root:

```bash
lake build --wfail            # build everything, run all tests and the axiom audit
scripts/check-imports.sh      # every module is imported, so built and audited
scripts/check-should-fail.sh  # broken rules and hidden gaps are rejected
```

CI (`.github/workflows/build.yml`) runs all three on every push and pull request.

## Layout

```
Canteen.lean               root: imports every module
Audit.lean                 runs the axiom/sorry audit on every build
Canteen/
  Core/                    Layer 0: the generic language
    Risk.lean                low < medium < high, and Risk.max
    Judgment.lean            named, risk-rated true/false switches
    Finding.lean             Step, Finding, findingRisk
    Rule.lean                Rule (with its soundness proof), NonVacuous, IndependentOf
    Render.lean              numbered, cited English for a single finding
    Argument.lean            chained arguments with judgment calls and overall risk
    Combine.lean             Rule.comap, Rule.and, Rule.or, Rule.not (sound by construction)
    Branch.lean              every branch of the judgment calls; SameOnEveryBranch
    Series.lean              TxStep, runSeries, traceSeries, invariant lemmas
    SeriesReport.lean        rules applied after every step; the series as one argument
    Audit.lean               the #audit_axioms command
  Examples/                placeholders, not real provisions
    RuleX.lean               Rule X from design §4.4, with its lemmas
    RuleZ.lean               Rule Z = Rule X and Rule Y, built with Rule.and
    ToySeries.lean           a three-step plan checked against Rule X on each branch
  Tests/                   known-answer, sanity, non-vacuity and read-back tests
  ITA/  Lemmas/  Transactions/   Layers 1–4 (later phases)
tests/should-fail/         files that must fail to compile
scripts/                   CI checks
docs/design.md             the design
```

## Writing a rule

A `Rule` bundles the rule (`holds`), its explanation (`explain`) and a proof (`sound`) that the two always agree.
Lean will not build a rule whose English could contradict its logic. The pattern, from `Canteen/Examples/RuleX.lean`:

```lean
def ruleX : Rule XFacts where
  name := "Rule X"
  citation := "s.X"
  holds := xHolds
  explain := xExplain
  sound := xExplain_sound   -- ∀ f, (xExplain f).conclusion = xHolds f
```

`#eval (ruleX.explain facts).render` prints the argument. `renderWithJudgments` also lists the judgment calls relied on, with their risk.

## Chaining, branches and series

Rules built from other rules need no further proof: `Rule.and`, `Rule.or` and `Rule.not` are proven sound once.
Where a combined conclusion could be explained either way, the explanation prefers reasons that rest on facts over reasons that rest on judgment (`and_explain_factual`, `or_explain_factual`).

```lean
def ruleZ : Rule ZFacts :=
  Rule.and "Rule Z" "s.Z" (ruleX.comap ZFacts.x) (ruleY.comap ZFacts.y)
```

Judgment calls are declared as `JudgmentCall`s with a risk for each answer. `branches` lists every combination of answers (proven complete by `mem_branches`), and facts are built from a branch with `answerOf`, so the switches always match the judgment calls reported.
`Rule.renderBranches` reports the outcome and risk on each branch. `Rule.SameOnEveryBranch` states that the judgment calls don't matter and is proven `by decide`.

`explainSeries` applies rules after every step of a plan and renders the whole plan as one argument (`reportSeries_sound` proves the report matches the rules). From `Canteen/Examples/ToySeries.lean`, on the branch where J-B is "yes":

```
1. Step 1: Acquire 60 units. [plan, step 1]
2. Condition A is not met, so Rule X does not apply. [s.X(a)]
3. Step 2: Acquire 50 more units. [plan, step 2]
4. Conditions A and B are met and no exception applies, so Rule X applies. [s.X]
5. Step 3: File the election. [plan, step 3]
6. The exception applies, so Rule X does not apply. [s.X(c)]
7. So, across the plan: Rule X applies after step 2 only. [s.X]
Relies on these judgment calls:
- J-B: Is condition B met? Assumed: yes. Risk: medium.
Overall risk: medium.
```

## Validation (design §6)

| Practice | Where |
|---|---|
| Known-answer tests | `Canteen/Tests/*.lean` (`example … := rfl`, `#guard` on rendered text) |
| Sanity theorems | `Risk` laws in `Core/Risk.lean`; Rule X lemmas in `Examples/RuleX.lean` |
| Non-vacuity | `Rule.NonVacuous`; `ruleX_nonVacuous` in `Tests/RuleX.lean` |
| No hidden gaps | `#audit_axioms` in `Audit.lean` fails the build on any `sorry`, `axiom` or `native_decide` |
| Read-back | Every Rule X branch rendered and checked in `Tests/RuleX.lean` |
| Broken rules caught | `brokenExplain_unsound`, plus `tests/should-fail/` (including a false claim that a judgment call doesn't matter) |
| Continuous build | `.github/workflows/build.yml` |

## What Lean does and does not guarantee

Lean guarantees that every proven conclusion follows from the definitions and facts, and that the English explanation agrees with the formal rule.
It does **not** guarantee that the definitions match the statute, that the facts are true, or that the CRA or a court will agree.
Those are managed by the validation practices above.

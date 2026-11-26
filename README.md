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
| 4. First real provision | Encoded; awaiting review | Section 54 "superficial loss" with all its exceptions, and subparagraph 40(2)(g)(i); see [`docs/review/superficial-loss.md`](docs/review/superficial-loss.md) |
| 5. Blueprint | Done | Memos whose statements link to Lean, with dependency graphs coloured by proven/unproven status; see [`docs/blueprint/`](docs/blueprint/README.md) |
| 6. Ergonomics | Done | The `statute` command: rules written in the statute's own shape, sound with nothing to prove |
| Beyond the roadmap | Done | All of paragraph 40(2)(g), 40(3.3) to (3.5), 50(2), 53(1)(f), 251.1(1)(a) to (h), and 251(1) to (6) encoded; five transactions; diagrams drawn from the Lean; memos checked against what their proofs use |

## Building

Install [elan](https://github.com/leanprover/elan) (the Lean version manager), then from the repository root:

```bash
lake build --wfail            # build everything, run all tests and the axiom audit
scripts/check-imports.sh      # every module is imported, so built and audited
scripts/check-should-fail.sh  # broken rules and hidden gaps are rejected
scripts/blueprint.sh --check  # the blueprint and graph documents match the Lean sources
```

CI (`.github/workflows/build.yml`) runs all four on every push and pull request.
After changing a blueprint, a diagram, or anything they show, run `scripts/blueprint.sh` and commit `docs/blueprint/` and `docs/graphs/`.

## Layout

```
Canteen.lean               root: imports every module
Audit.lean                 runs the axiom/sorry audit on every build
Canteen/
  Core/                    Layer 0: the generic language
    Risk.lean                low < medium < high, and Risk.max
    Date.lean                calendar dates, day arithmetic, "within 30 days" periods
    Money.lean               amounts in cents, formatted as $1,234.56
    Judgment.lean            named, risk-rated true/false switches
    Finding.lean             Step, Finding, findingRisk
    Rule.lean                Rule (with its soundness proof), NonVacuous, IndependentOf
    Render.lean              numbered, cited English for a single finding
    Argument.lean            chained arguments with judgment calls and overall risk
    Combine.lean             Rule.comap, Rule.and, Rule.or, Rule.not (sound by construction)
    Answer.lean              an answer that is either a fact or a judgment call
    Statute.lean             Rule.statute: "applies where …, except where …" (sound once, for all)
    StatuteSyntax.lean       the `statute` command
    Branch.lean              every branch of the judgment calls; SameOnEveryBranch
    Series.lean              TxStep, runSeries, traceSeries, invariant lemmas
    SeriesReport.lean        rules applied after every step; the series as one argument
    Audit.lean               the #audit_axioms command
    Blueprint.lean           memos linked to Lean: status, dependency graphs, hidden-dependency check
    Graphs.lean              flowcharts, decision trees and series diagrams, drawn from the Lean
    LeanGraph.lean           the architecture diagram, from the compiled modules
  Examples/                placeholders, not real provisions
    RuleX.lean               Rule X from design §4.4, with its lemmas
    RuleZ.lean               Rule Z = Rule X and Rule Y, built with Rule.and
    ToySeries.lean           a three-step plan checked against Rule X on each branch
  ITA/                     Layer 1: the Income Tax Act, one file per provision
    S54/SuperficialLoss.lean   section 54, "superficial loss", paragraph by paragraph
    S54/SuperficialLossStatute.lean   the same, in statute form (proven equal)
    S40/LossDenial.lean        subparagraph 40(2)(g)(i)
    S40/LossDenialStatute.lean        the same, in statute form (proven equal)
    S40/DebtLoss.lean          subparagraph 40(2)(g)(ii): debts
    S40/PersonalUseLoss.lean   subparagraph 40(2)(g)(iii), with "personal-use property" and "listed personal property"
    S40/PlanTransferLoss.lean  subparagraph 40(2)(g)(iv): transfers to TFSAs, RRSPs and other plans
    S40/Paragraph40_2_g.lean   paragraph 40(2)(g) as a whole
    S53/CostAddition.lean      paragraph 53(1)(f): the loss is added to the substituted property's cost
    S251_1/Affiliation.lean    paragraph 251.1(1)(a): spouses are affiliated (two persons, statute form)
    S251_1/AffiliatedPersons.lean   section 251.1(1)(a) to (h) for a whole world of persons, with diagrams
    S251/RelatedPersons.lean   section 251: related persons, blood relationship, and arm's length
    S50/BadDebtPersonalUse.lean   subsection 50(2): a personal-use debt that goes bad
    S40/SuspendedLoss.lean     subsections 40(3.3) to (3.5): suspended losses of corporations, trusts, partnerships
    S54/Timeline.lean          a timeline chart of the superficial loss period
  Lemmas/                  Layer 2: reusable truths about provisions
  Transactions/            Layer 3: concrete transactions, each step a theorem
    SpouseRepurchase.lean    shares sold at a loss and bought by the spouse
    SiblingAndLateRepurchase.lean   a sibling buys, and the taxpayer buys back on day 31
    TfsaContribution.lean    shares contributed in kind to a TFSA at a loss
    HoldcoRepurchase.lean    shares bought back by a holding company the spouses control
    SisterCompanyRepurchase.lean   a company's loss suspended when its sister company buys
  Blueprints/              memo-style documents linked to the Lean above
  Graphs/                  the diagram pages
  Tests/                   known-answer, sanity, non-vacuity and read-back tests
statute/                   verbatim statute text for each encoded provision, with its currency date
docs/review/               review notes: statute-to-Lean mapping, interpretation choices, read-back
docs/blueprint/            blueprints rendered to Markdown (generated; do not edit)
docs/graphs/               diagrams rendered to Markdown (generated; do not edit)
tests/should-fail/         files that must fail to compile
scripts/                   CI checks
docs/design.md             the design
```

## Writing a rule

The quickest way is the `statute` command, which reads like the provision:

```lean
statute ruleX (f : XFacts) named "Rule X" cites "s.X"
  applies where
    | (a) f.condA => "Condition A is met." else "Condition A is not met."
    | (b) judgment "J-B" f.condB => "Condition B is met." else "Condition B is not met."
  except where
    | (c) f.exception => "The exception applies." else "The exception does not apply."
```

It defines `ruleX : Rule XFacts`, and needs no proof: every rule of this shape is sound by one theorem proven once (`Rule.statuteFinding_conclusion`).
Each clause is cited as the rule's citation plus its label (`s.X(a)`), may rest on a judgment call (`judgment "J-B"`, or `judgments ids` computed from the facts), or may be a whole other rule (`| (i) := (otherRule.comap g)`).
The explanation cites a failure on the facts before one that rests on a judgment call (`Rule.statute_explain_factual`).
Section 54 "superficial loss" and subparagraph 40(2)(g)(i) are written this way in `Canteen/ITA/`, each proven equal to its paragraph-by-paragraph encoding.

For full control over the explanation (dates, amounts, per-item reasons), write the rule by hand.
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

## The provisions encoded

Section 54, "superficial loss", is encoded paragraph by paragraph: the loss, paragraphs (a) and (b), every exception in (c) to (h), and the deeming rules in (i) and (j).
All of paragraph 40(2)(g) is encoded: (i) superficial losses, (ii) debts, (iii) personal-use property (with the s. 54 definitions it uses), and (iv) transfers to TFSAs, RRSPs and other plans, under the carve-out in its opening words.
Paragraph 53(1)(f) adds a superficial loss to the cost of the substituted property.
Section 251.1, paragraphs (a) to (h), decides who is affiliated: spouses, corporations and their controllers, pairs of corporations, partnerships and their majority-interest partners, trusts and their majority-interest beneficiaries, and pairs of trusts. Section 251 decides who is related (by blood, marriage, common-law partnership or adoption, and through control of corporations) and so who is deemed not to deal at arm's length. Because affiliation and relatedness are each defined in terms of themselves, each is computed for a whole world of persons as the smallest relation closed under the paragraphs, and every pair keeps the chain of paragraphs that makes it so.
Whether a property is "identical" is a judgment call; inputs decided by provisions not yet encoded (affiliation under s. 251.1, for example) are taken as facts.

```
1. The taxpayer disposed of 100 common shares of ABC Ltd. on 2025-06-15 for proceeds of $1,000.00. The adjusted cost base plus outlays and expenses was $1,509.99, so the taxpayer's loss from the disposition is $509.99. [ITA 40(1)(b)]
2. On 2025-06-20, within the period from 2025-05-16 to 2025-07-15, the taxpayer acquired 100 common shares of ABC Ltd. That property is identical to the particular property (judgment call J-ID). [ITA 54 "superficial loss" (a)]
3. At the end of that period, on 2025-07-15, the taxpayer or a person affiliated with the taxpayer owned or had a right to acquire that property. [ITA 54 "superficial loss" (b)]
4. The disposition is not one described in paragraphs (c) to (h), so the taxpayer's loss of $509.99 is a superficial loss. [ITA 54 "superficial loss"]
```

The statute-to-Lean mapping, the interpretation choices to confirm, and the full read-back are in [`docs/review/superficial-loss.md`](docs/review/superficial-loss.md).

## Blueprints: memos linked to Lean

A blueprint (`Canteen/Blueprints/`) is a memo whose statements each name the Lean declarations behind them and the earlier statements they use.
`scripts/blueprint.sh` renders it to Markdown in [`docs/blueprint/`](docs/blueprint/README.md), with a dependency graph that GitHub draws.

- **Status comes from Lean.** A statement backed by a theorem is *proven*; by definitions only, *encoded*; by nothing, *not formalized*. Facts and judgment calls are shown as such.
- **Links can't go stale.** Declarations are written as ``` ``Name ``` literals, so a renamed or deleted theorem is a build error.
- **Gaps are refused.** A statement backed by `sorry` is *unproven*, and the blueprint is not published.
- **Every assumption is visible.** Each statement lists the facts, judgment calls and unformalized statements it rests on.
- **Memos can't understate their dependencies.** Lean reads the proofs to find which statements each one really uses; a memo that leaves one out is refused. Each memo shows this second graph alongside its own.

Memos: [the spouse repurchase](docs/blueprint/spouse-repurchase.md) (the loss is denied and moves to the spouse's cost), [the sibling and day-31 repurchase](docs/blueprint/sibling-and-late-repurchase.md) (the loss stands, resting on no judgment call), [a TFSA contribution in kind](docs/blueprint/tfsa-contribution.md) (the loss is nil under 40(2)(g)(iv) whether or not the TFSA trust is affiliated), [a family holding company's repurchase](docs/blueprint/holdco-repurchase.md) (Holdco is affiliated through 251.1(1)(b)(ii); with a friend as co-owner it would turn on de facto control), and [a sister company's repurchase](docs/blueprint/sister-company-repurchase.md) (the company's loss is suspended under 40(3.4) and released when the sister sells).

## Graphs

Every diagram is drawn from the Lean definitions, so it always shows the rules as encoded ([`docs/graphs/`](docs/graphs/README.md)):

- [Flowcharts](docs/graphs/flowcharts.md) of each statute-form rule, from the outline the `statute` command records.
- [Decision trees](docs/graphs/decision-trees.md) over the judgment calls, with the conclusion and risk on each branch.
- [Timelines](docs/graphs/timelines.md) of the superficial loss period: the disposition, the 61 days, and every acquisition.
- [Who is affiliated with whom](docs/graphs/affiliation.md): worlds of persons under section 251.1, each affiliated pair labelled with its paragraph.
- [Who is related to whom](docs/graphs/related.md): a family tree under section 251, with each related pair.
- [A transaction series](docs/graphs/series.md), state by state.
- [The provision map](docs/graphs/provisions.md): which encoded provisions build on which.
- [The architecture](docs/graphs/architecture.md), read from the compiled modules.

## Validation (design §6)

| Practice | Where |
|---|---|
| Known-answer tests | `Canteen/Tests/*.lean` (`example … := rfl`, `#guard` on rendered text) |
| Sanity theorems | `Risk` laws in `Core/Risk.lean`; Rule X lemmas in `Examples/RuleX.lean` |
| Non-vacuity | `Rule.NonVacuous`; `ruleX_nonVacuous` in `Tests/RuleX.lean` |
| No hidden gaps | `#audit_axioms` in `Audit.lean` fails the build on any `sorry`, `axiom` or `native_decide` |
| Read-back | Every Rule X branch rendered and checked in `Tests/RuleX.lean` |
| Broken rules caught | `brokenExplain_unsound`, plus `tests/should-fail/` (including a false claim that a judgment call doesn't matter, and a statute-form rule missing a clause) |
| Continuous build | `.github/workflows/build.yml` |
| Memos match the proofs | `docs/blueprint/` and `docs/graphs/` are regenerated and compared in CI; stale links, gaps and hidden dependencies are rejected (`tests/should-fail/`) |

## What Lean does and does not guarantee

Lean guarantees that every proven conclusion follows from the definitions and facts, and that the English explanation agrees with the formal rule.
It does **not** guarantee that the definitions match the statute, that the facts are true, or that the CRA or a court will agree.
Those are managed by the validation practices above.

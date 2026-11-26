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
| Beyond the roadmap | Done | Sections 3, 38 to 41 and 111, recapture and terminal losses (13(1), (21), 20(16)) (the capital gains computation, net capital losses and taxable income), 45(1) to (4), 69(1), 70(5) and (6), 73(1), 74.1, 74.2, 82(1) and 121, 112(1) and 55(2), 83(2) and 89(1) (capital dividends), 84(3), (4) and (4.1), 40(3), 84.1, 85(1) and (2.1), 51, 86, 87(1), (2)(e) and (4), 88(1), the capital gains deduction (110.6(2.1)), the principal residence exemption, replacement property (44(1)), identical properties (47(1)), the Canadian securities election (39(4)), all of paragraph 40(2)(g), 40(2)(e.1), 40(3.3) to (3.6), 50(2), 53(1)(f), sections 251 and 251.1 (with the amalgamation rules), loss restriction events (251.2(2)(a), 256(7)(a)), connected corporations (186(4)) encoded; eight transactions; diagrams drawn from the Lean; memos checked against what their proofs use |

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
    S251/Amalgamation.lean     251.1(2), 251(3.1), (3.2): amalgamations, through a hypothetical world
    S38/CapitalGains.lean      40(1), 39(1), 38, 41: gains, losses, inclusion rates, listed personal property
    S3/Income.lean             section 3: income for the year, with a step-by-step report
    S111/NetCapitalLoss.lean   111(8), (1)(b), (1.1): net capital losses, and taxable income
    S69/NonArmsLength.lean     69(1): transfers not at arm's length, and gifts
    S73/SpousalRollover.lean   73(1), (1.01): the spousal rollover, displacing 69(1)
    S70/Death.lean             70(5), (6), (6.2): deemed disposition on death, and the spousal rollover
    S74/Attribution.lean       74.2(1), 74.5(1), (3): capital gains attributed back to the transferor
    S74/IncomeAttribution.lean   74.1(1) to (3), 74.5(2), (3)(a): income attributed back to the transferor or lender
    S82/Dividends.lean         82(1), 121: taxable dividends, the gross-up, and the dividend tax credit
    S55/IntercorporateDividends.lean   112(1), 55(2): intercorporate dividends, and when they are capital gains
    S13/Depreciable.lean       13(1), (21), 20(16): undepreciated capital cost, recapture, terminal loss
    S84/Redemption.lean        84(3): redemptions, the deemed dividend, and the proceeds
    S84/ReturnOfCapital.lean   84(4), (4.1), 53(2)(a)(ii), 40(3): returns of capital, negative cost
    S89/CapitalDividendAccount.lean   83(2), 89(1): the capital dividend account, and capital dividends
    S86/ShareExchange.lean     86(1) to (3): share exchanges in a reorganization, estate freezes
    S88/WindingUp.lean         88(1): winding up a subsidiary into its parent, and the bump
    S87/Amalgamation.lean      87(1), (2)(e), (4): amalgamations, and the shareholder rollover
    S51/ConvertibleProperty.lean   51(1), (2), (4): converting shares or debt into shares
    S3/IndividualYear.lean     2(2), 3: an individual's year, from every encoded source to taxable income
    S39/CanadianSecurities.lean   39(4) to (6): the election that settles capital account for Canadian securities
    S44/ReplacementProperty.lean   44(1): replacement property, deferring a gain
    S47/IdenticalProperties.lean   47(1): identical properties, and the average cost
    S186/Connected.lean        186(2), (4): connected corporations
    S45/ChangeInUse.lean       45(1) to (4): change in use, and the 45(2) and (3) elections
    S85/TransferToCorporation.lean   85(1), (2.1): the section 85 rollover, and paid-up capital
    S84_1/SurplusStripping.lean   84.1: shares sold to a non-arm's length corporation; the deemed dividend
    S110_6/CapitalGainsDeduction.lean   110.6: qualified small business corporation shares, the gains limits, the deduction
    S251_2/LossRestrictionEvent.lean   251.2(2)(a), 256(7)(a): acquisitions of control, and when they are not
    S50/BadDebtPersonalUse.lean   subsection 50(2): a personal-use debt that goes bad
    S40/SuspendedLoss.lean     subsections 40(3.3) to (3.5): suspended losses of corporations, trusts, partnerships
    S40/ShareToAffiliate.lean  40(3.6), 53(1)(f.2): a share disposed of to an affiliated corporation
    S40/RelatedDebt.lean       40(2)(e.1), 53(1)(f.1): a debt disposed of within a related group
    S40/PrincipalResidence.lean   40(2)(b) and 54 "principal residence": the exemption, with family-unit designations
    S54/Timeline.lean          a timeline chart of the superficial loss period
  Lemmas/                  Layer 2: reusable truths about provisions
  Transactions/            Layer 3: concrete transactions, each step a theorem
    SpouseRepurchase.lean    shares sold at a loss and bought by the spouse
    SiblingAndLateRepurchase.lean   a sibling buys, and the taxpayer buys back on day 31
    TfsaContribution.lean    shares contributed in kind to a TFSA at a loss
    HoldcoRepurchase.lean    shares bought back by a holding company the spouses control
    SisterCompanyRepurchase.lean   a company's loss suspended when its sister company buys
    Crystallization.lean     the capital gains exemption crystallized, then a strip caught by 84.1
    SaleThroughHoldco.lean   a sale through Holdco: capital dividends, and a dividend caught by 55(2)
    PostMortemPipeline.lean  the gain at death taxed once, through a pipeline under 84.1
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
Section 251.1, paragraphs (a) to (h), decides who is affiliated: spouses, corporations and their controllers, pairs of corporations, partnerships and their majority-interest partners, trusts and their majority-interest beneficiaries, and pairs of trusts. Section 251 decides who is related (by blood, marriage, common-law partnership or adoption, and through control of corporations) and so who is deemed not to deal at arm's length. The tax result follows: 40(1) computes each gain or loss (with reserves), 39(1) and 38 make it a capital gain or loss and apply the inclusion rate, section 41 pools listed personal property, section 3 computes income for the year, and section 111 carries unused capital losses to other years and computes taxable income, so a loss denied by 40(2)(g) or suspended by 40(3.4) visibly changes the taxpayer's income. Amalgamations (251.1(2), 251(3.1), (3.2)) are encoded as the Act frames them: a hypothetical world in which the new corporation existed immediately before, with its later shareholders. Because affiliation and relatedness are each defined in terms of themselves, each is computed for a whole world of persons as the smallest relation closed under the paragraphs, and every pair keeps the chain of paragraphs that makes it so.
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

Memos: [the spouse repurchase](docs/blueprint/spouse-repurchase.md) (the loss is denied and moves to the spouse's cost), [the sibling and day-31 repurchase](docs/blueprint/sibling-and-late-repurchase.md) (the loss stands, resting on no judgment call), [a TFSA contribution in kind](docs/blueprint/tfsa-contribution.md) (the loss is nil under 40(2)(g)(iv) whether or not the TFSA trust is affiliated), [a family holding company's repurchase](docs/blueprint/holdco-repurchase.md) (Holdco is affiliated through 251.1(1)(b)(ii); with a friend as co-owner it would turn on de facto control), [a sister company's repurchase](docs/blueprint/sister-company-repurchase.md) (the company's loss is suspended under 40(3.4) and released when the sister sells), [a crystallization and surplus strip](docs/blueprint/crystallization.md) (85(1), 84.1 and 110.6: the exemption shelters the gain, but 84.1(2)(a.1) turns the later note into a dividend, and the matching loss is superficial), [a sale through a holding company](docs/blueprint/sale-through-holdco.md) (55(2) makes a pre-sale dividend over safe income a capital gain; the capital dividend account carries the untaxed halves out tax-free), and [a post-mortem pipeline](docs/blueprint/post-mortem-pipeline.md) (the gain at death is taxed once; the estate's full cost keeps 84.1 from making the note a dividend).

## Graphs

Every diagram is drawn from the Lean definitions, so it always shows the rules as encoded ([`docs/graphs/`](docs/graphs/README.md)):

- [Flowcharts](docs/graphs/flowcharts.md) of each statute-form rule, from the outline the `statute` command records.
- [Decision trees](docs/graphs/decision-trees.md) over the judgment calls, with the conclusion and risk on each branch.
- [Timelines](docs/graphs/timelines.md) of the superficial loss period: the disposition, the 61 days, and every acquisition.
- [Who is affiliated with whom](docs/graphs/affiliation.md): worlds of persons under section 251.1, each affiliated pair labelled with its paragraph.
- [Who is related to whom](docs/graphs/related.md): a family tree under section 251, with each related pair.
- [A transaction series](docs/graphs/series.md), state by state.
- [The dashboard](docs/graphs/dashboard.md): every statement by status, every judgment call by risk, the transactions by date, and a mind map of the Act as encoded.
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

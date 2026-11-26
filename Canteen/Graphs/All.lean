import Canteen.Core.Graphs
import Canteen.Examples.RuleXStatute
import Canteen.Examples.ToySeries
import Canteen.ITA.S54.SuperficialLossStatute
import Canteen.ITA.S54.Timeline
import Canteen.ITA.S40.LossDenialStatute
import Canteen.ITA.S40.Paragraph40_2_g
import Canteen.ITA.S251_1.Affiliation
import Canteen.Transactions.SpouseRepurchase
import Canteen.Transactions.SiblingAndLateRepurchase
import Canteen.Transactions.TfsaContribution
import Canteen.Transactions.HoldcoRepurchase
import Canteen.ITA.S251_1.AffiliatedPersons
import Canteen.ITA.S251.RelatedPersons
import Canteen.ITA.S251.Amalgamation
import Canteen.ITA.S40.SuspendedLoss
import Canteen.ITA.S50.BadDebtPersonalUse
import Canteen.ITA.S40.ShareToAffiliate
import Canteen.ITA.S40.RelatedDebt
import Canteen.ITA.S40.PrincipalResidence
import Canteen.Transactions.SisterCompanyRepurchase

/-!
# Every graph page, and what is on it

`scripts/blueprint.sh` renders each page to `docs/graphs/<file>.md`. Every diagram is drawn
from the Lean definitions, so it always shows the rule as encoded. The architecture page is
drawn from the compiled modules by the script itself.
-/

namespace Canteen.Graphs

open Canteen.ITA

/-- A page of diagrams: file name, title, introduction, and (heading, Mermaid source) pairs. -/
structure Page where
  file : String
  title : String
  intro : String
  diagrams : List (String × String)

/-- Rule X with both condition B and the exception left to judgment. -/
def ruleXCalls : List JudgmentCall :=
  [{ id := "J-B", question := "Is condition B met?", riskIfYes := .medium, riskIfNo := .low },
   { id := "J-E", question := "Does the exception apply?", riskIfYes := .high, riskIfNo := .low }]

def ruleXFacts (b : List Judgment) : Examples.XFacts :=
  ⟨true, answerOf b "J-B", answerOf b "J-E"⟩

/-- A sale with purchases on days −31, −30, +30 and +31, to show the edges of the period. -/
def boundaries : SuperficialLoss.Facts :=
  let buy (d : Date) : SuperficialLoss.Acquisition :=
    { description := "100 common shares of ABC Ltd.", date := d, acquirer := .taxpayer,
      identity := .same, heldAtEndOfPeriod := true }
  ⟨{ description := "100 common shares of ABC Ltd.", date := ⟨2025, 6, 15⟩,
     proceeds := 100000, adjustedCostBase := 150000, outlaysAndExpenses := 0 },
   [buy ⟨2025, 5, 15⟩, buy ⟨2025, 5, 16⟩, buy ⟨2025, 7, 15⟩, buy ⟨2025, 7, 16⟩]⟩

/-- A debt taken as the price of capital property, sold at a loss, with the income purpose and
arm's length dealing both left to judgment. -/
def debtCalls : List JudgmentCall :=
  [{ id := "J-PURPOSE", question := "Was the debt acquired to gain or produce income from a business or property?",
     riskIfYes := .medium, riskIfNo := .medium },
   { id := "J-ARM", question := "Was the taxpayer dealing at arm's length with the buyer?",
     riskIfYes := .medium, riskIfNo := .low }]

def debtFacts (b : List Judgment) : Paragraph40_2_g.Facts :=
  { sl := ⟨{ description := "a promissory note", date := ⟨2025, 5, 1⟩, proceeds := 600000,
             adjustedCostBase := 1000000, outlaysAndExpenses := 0 }, []⟩,
    debt := { isDebtOrRight := true, incomePurpose := Answer.ofBranch "J-PURPOSE" b,
              considerationForCapitalProperty := true, armsLength := Answer.ofBranch "J-ARM" b } }

/-- A family group: spouses, their companies, a partnership and a trust, and a friend. -/
def familyGroup : AffiliatedPersons.World :=
  { persons := [⟨0, "Ann", .individual⟩, ⟨1, "Bob (Ann's spouse)", .individual⟩, ⟨2, "Cy (a friend)", .individual⟩,
                ⟨10, "Annco", .corporation⟩, ⟨11, "Famco", .corporation⟩, ⟨12, "Cyco", .corporation⟩,
                ⟨20, "AB Partners", .partnership⟩, ⟨30, "The Family Trust", .trust⟩],
    spouses := [(0, 1)],
    controls := [⟨10, .person 0, .fact true, false⟩, ⟨11, .group [0, 1], .fact true, false⟩, ⟨12, .person 2, .fact true, false⟩],
    partnershipInterests := [⟨20, 0, 30, 30⟩, ⟨20, 1, 30, 30⟩, ⟨20, 2, 40, 40⟩],
    beneficialInterests := [⟨30, 1, 60, 60⟩, ⟨30, 2, 40, 40⟩] }

/-- Three generations, with an in-law, a cousin, a child adopted in fact, and two companies. -/
def threeGenerations : AffiliatedPersons.World :=
  { persons := [⟨0, "Gran", .individual⟩, ⟨1, "Ann", .individual⟩, ⟨2, "Uncle", .individual⟩, ⟨3, "Bob", .individual⟩,
                ⟨4, "Kid", .individual⟩, ⟨5, "Cousin", .individual⟩, ⟨6, "Ward", .individual⟩,
                ⟨10, "Annco", .corporation⟩, ⟨11, "Cousinco", .corporation⟩],
    spouses := [(1, 3)], children := [(0, 1), (0, 2), (1, 4), (2, 5)], adoptions := [(1, 6)],
    controls := [⟨10, .person 1, .fact true, false⟩, ⟨11, .person 5, .fact true, false⟩] }

/-- A parent (Pco, controlled by Ann) and its subsidiary (Sco) amalgamate to form Newco,
controlled by Ann. -/
def parentSubAmalgamation : Amalgamation.Facts :=
  { before := { persons := [⟨0, "Ann", .individual⟩, ⟨10, "Pco", .corporation⟩, ⟨11, "Sco", .corporation⟩],
                controls := [⟨10, .person 0, .fact true, false⟩, ⟨11, .person 10, .fact true, false⟩] },
    predecessors := [10, 11], newCorp := ⟨20, "Newco (supposed)", .corporation⟩,
    controlAfter := [⟨20, .person 0, .fact true, false⟩] }

def holding (h : Examples.Holding) : String :=
  s!"{h.units} units, election {if h.electionFiled then "filed" else "not filed"}"

/-- The provisions on the provision map, by the module that encodes them. -/
def provisions : List (Lean.Name × String) :=
  [(`Canteen.ITA.S54.SuperficialLoss, "54 \"superficial loss\""),
   (`Canteen.ITA.S54.SuperficialLossStatute, "54 \"superficial loss\", in statute form"),
   (`Canteen.ITA.S40.LossDenial, "40(2)(g)(i) superficial losses"),
   (`Canteen.ITA.S40.Paragraph40_2_g_Facts, "40(2)(g): the facts"),
   (`Canteen.ITA.S40.DebtLoss, "40(2)(g)(ii) debts"),
   (`Canteen.ITA.S40.PersonalUseLoss, "40(2)(g)(iii) personal-use property, with 54 definitions"),
   (`Canteen.ITA.S40.PlanTransferLoss, "40(2)(g)(iv) registered plans"),
   (`Canteen.ITA.S40.Paragraph40_2_g, "40(2)(g) as a whole"),
   (`Canteen.ITA.S40.SuspendedLoss, "40(3.3) to (3.5) suspended losses"),
   (`Canteen.ITA.S40.ShareToAffiliate, "40(3.6), 53(1)(f.2) shares to an affiliated corporation"),
   (`Canteen.ITA.S40.RelatedDebt, "40(2)(e.1), 53(1)(f.1) debts within a related group"),
   (`Canteen.ITA.S40.PrincipalResidence, "40(2)(b), 54 principal residence"),
   (`Canteen.ITA.S50.BadDebtPersonalUse, "50(2) bad personal-use debts"),
   (`Canteen.ITA.S53.CostAddition, "53(1)(f) cost of substituted property"),
   (`Canteen.ITA.S251_1.Affiliation, "251.1(1)(a), two persons"),
   (`Canteen.ITA.S251_1.AffiliatedPersons, "251.1 affiliated persons, with 248(1) and 251(6)"),
   (`Canteen.ITA.S251.RelatedPersons, "251(1) to (6) related persons, arm's length"),
   (`Canteen.ITA.S251.Amalgamation, "251.1(2), 251(3.1), (3.2) amalgamations"),
   (`Canteen.ITA.S38.CapitalGains, "38 to 41 capital gains and losses"),
   (`Canteen.ITA.S3.Income, "3 income for the year"),
   (`Canteen.ITA.S111.NetCapitalLoss, "111 net capital losses, taxable income")]

/-! ## The dashboard -/

/-- Every judgment call in the transactions and examples, with where it arises. -/
def allJudgmentCalls : List (String × JudgmentCall) :=
  (Transactions.SpouseRepurchase.calls.map ("spouse repurchase", ·)) ++
  (Transactions.SiblingAndLateRepurchase.calls.map ("sibling repurchase", ·)) ++
  (Transactions.TfsaContribution.calls.map ("TFSA contribution", ·)) ++
  (Transactions.HoldcoRepurchase.calls.map ("Holdco repurchase", ·)) ++
  (Transactions.HoldcoRepurchase.friendCalls.map ("Holdco what-if", ·)) ++
  (debtCalls.map ("debt example", ·)) ++ (ruleXCalls.map ("Rule X", ·))

private def riskPos : Risk → Nat
  | .low => 15 | .medium => 50 | .high => 85

private def pct (n : Nat) : String := if n < 10 then s!"0.0{n}" else s!"0.{n}"

/-- The judgment calls as a quadrant chart: risk of answering "yes" across, "no" up. Calls in
the same place are spread out a little so each can be read. -/
def judgmentQuadrant : String := Id.run do
  let mut out := ["quadrantChart", "    title Judgment calls by risk",
    "    x-axis Low risk if yes --> High risk if yes", "    y-axis Low risk if no --> High risk if no",
    "    quadrant-1 Risky either way", "    quadrant-2 Safer to answer yes",
    "    quadrant-3 Safe either way", "    quadrant-4 Safer to answer no"]
  let mut seen : List (Nat × Nat) := []
  for (whereFrom, c) in allJudgmentCalls do
    let x0 := riskPos c.riskIfYes
    let y0 := riskPos c.riskIfNo
    let k := (seen.filter (· == (x0, y0))).length
    seen := seen ++ [(x0, y0)]
    let x := x0 + 4 * (k % 3)
    let y := y0 + 4 * (k / 3)
    out := out ++ [s!"    {c.id} in {whereFrom}: [{pct x}, {pct y}]"]
  return "\n".intercalate out

/-- The transactions' key dates, from their facts. -/
def transactionTimeline : String :=
  let ev (d : Date) (t : String) := s!"    {d} : {t}"
  "\n".intercalate [
    "timeline", "    title The transactions, by date",
    ev Transactions.SiblingAndLateRepurchase.sale.date "Sibling repurchase, the sale",
    ev (Transactions.SiblingAndLateRepurchase.lateRepurchase true).date "Sibling repurchase, buy-back on day 31",
    ev Transactions.SpouseRepurchase.sale.date "Spouse repurchase, the sale",
    ev (Transactions.SpouseRepurchase.spousePurchase true).date "Spouse repurchase, the spouse buys",
    ev Transactions.SisterCompanyRepurchase.sale.date "Sister company, Opco sells",
    ev Transactions.SisterCompanyRepurchase.sisterPurchase.date "Sister company, Sisterco buys",
    ev Transactions.TfsaContribution.contribution.date "TFSA contribution in kind",
    ev Transactions.HoldcoRepurchase.sale.date "Holdco repurchase, the sale",
    ev (Transactions.HoldcoRepurchase.holdcoPurchase true).date "Holdco repurchase, Holdco buys",
    ev ((SuspendedLoss.releaseDate Transactions.SisterCompanyRepurchase.facts).getD ⟨2026, 2, 2⟩)
      "Sister company, the suspended loss is released"]

/-- The Act as encoded, section by section. Each node is a Mermaid "markdown string", so the
parentheses in citations are not read as node shapes. -/
def actMindmap : String := Id.run do
  let tree : List (Nat × String) := [
    (2, "s. 3"), (3, "income for the year: (a) to (f)"),
    (2, "ss. 38 to 41"), (3, "38: inclusion rates"), (3, "39(1): capital gains and losses"), (3, "40(1): gains and losses, reserves"),
    (3, "41: listed personal property"),
    (2, "s. 40"), (3, "40(2)(b): the principal residence exemption"), (3, "40(2)(g): losses that are nil"), (4, "(i) superficial losses"), (4, "(ii) debts"),
    (4, "(iii) personal-use property"), (4, "(iv) TFSAs, RRSPs and other plans"),
    (3, "40(2)(e.1): debts within a related group"), (3, "40(3.3) to (3.5): suspended losses"),
    (3, "40(3.6): shares to an affiliated corporation"),
    (2, "s. 50"), (3, "50(2): bad personal-use debts"),
    (2, "s. 53"), (3, "53(1)(f): cost of substituted property"), (3, "53(1)(f.1), (f.2): cost after 40(2)(e.1), 40(3.6)"),
    (2, "s. 54"), (3, "superficial loss"), (3, "principal residence"), (3, "personal-use property"), (3, "listed personal property"),
    (2, "s. 111"), (3, "111(8): net capital loss"), (3, "111(1)(b), (1.1): deduction"),
    (2, "s. 248"), (3, "248(1): majority-interest partner"),
    (2, "s. 251"), (3, "251(1): arm's length"), (3, "251(2), (3): related persons"), (3, "251(3.1), (3.2): amalgamations"),
    (3, "251(6): blood, marriage, adoption"),
    (2, "s. 251.1"), (3, "251.1(1)(a) to (h): affiliated persons"), (3, "251.1(2): amalgamations"), (3, "251.1(3), (4): definitions and rules")]
  let mut out := ["mindmap", "  root((Income Tax Act, as encoded))"]
  for ((depth, label), i) in tree.zipIdx do
    out := out ++ [("".pushn ' ' (2 * depth)) ++ s!"n{i}[\"`{label}`\"]"]
  return "\n".intercalate out

def pages : List Page := [
  { file := "flowcharts", title := "Flowcharts of the rules"
    intro := "Each rule written with the `statute` command, drawn from its outline: every condition must be met, and " ++
      "no exception may apply. Grey clauses are facts, orange clauses rest on a judgment call, and blue clauses are " ++
      "other rules. The explanation Lean gives cites a failure on the facts before one that rests on judgment."
    diagrams := [
      ("Section 54, \"superficial loss\"", flowchart SuperficialLoss.superficialLossStatute.outline),
      ("Paragraph 40(2)(g) as a whole", flowchart Paragraph40_2_g.paragraph.outline),
      ("Subparagraph 40(2)(g)(i)", flowchart LossDenial.lossDenialStatute.outline),
      ("Subparagraph 40(2)(g)(ii): debts", flowchart Paragraph40_2_g.debtLoss.outline),
      ("Subparagraph 40(2)(g)(iii): personal-use property", flowchart Paragraph40_2_g.personalUseLoss.outline),
      ("Section 54 \"personal-use property\"", flowchart Paragraph40_2_g.personalUseProperty.outline),
      ("Subsection 40(3.3): suspended losses", flowchart SuspendedLoss.applies.outline),
      ("Subsection 50(2): a personal-use debt that goes bad", flowchart BadDebtPersonalUse.rule.outline),
      ("Subsection 40(3.6): a share disposed of to an affiliated corporation", flowchart ShareToAffiliate.applies.outline),
      ("Paragraph 40(2)(e.1): a debt within a related group", flowchart RelatedDebt.applies.outline),
      ("Section 54 \"principal residence\", for an individual and a year", flowchart PrincipalResidence.principalResidence.outline),
      ("Subparagraph 40(2)(g)(iv): transfers to registered plans", flowchart Paragraph40_2_g.planTransferLoss.outline),
      ("Clause 40(2)(g)(iv)(A)", flowchart Paragraph40_2_g.planTransferA.outline),
      ("Clause 40(2)(g)(iv)(B)", flowchart Paragraph40_2_g.planTransferB.outline),
      ("Paragraph 251.1(1)(a)", flowchart Affiliation.paragraphA.outline),
      ("Rule X (the placeholder from the design)", flowchart Examples.ruleXStatute.outline)] },
  { file := "decision-trees", title := "Decision trees over the judgment calls"
    intro := "Every way of answering a rule's judgment calls, with the conclusion and its risk at each leaf. A tree " ++
      "whose leaves all agree is a judgment call that doesn't matter."
    diagrams := [
      ("Spouse repurchase: are the shares identical?",
        branchTree SuperficialLoss.rule Transactions.SpouseRepurchase.calls Transactions.SpouseRepurchase.facts),
      ("Sibling and day-31 repurchase: two judgment calls, one answer",
        branchTree SuperficialLoss.rule Transactions.SiblingAndLateRepurchase.calls
          Transactions.SiblingAndLateRepurchase.facts),
      ("TFSA contribution: paragraph 40(2)(g) on both answers to J-AFF",
        branchTree Paragraph40_2_g.paragraph Transactions.TfsaContribution.calls Transactions.TfsaContribution.facts),
      ("A debt sold at a loss: income purpose and arm's length dealing both judged",
        branchTree Paragraph40_2_g.debtLoss debtCalls debtFacts),
      ("Rule X with condition B and the exception both left to judgment",
        branchTree Examples.ruleX ruleXCalls ruleXFacts)] },
  { file := "timelines", title := "Timelines of the superficial loss period"
    intro := "The disposition, the period in paragraph (a) (30 days before to 30 days after, both ends included), every " ++
      "acquisition, and the end of the period in paragraph (b). Acquisitions that meet both (a) and (b) are red."
    diagrams := [
      ("Spouse repurchase", SuperficialLoss.timeline
        (Transactions.SpouseRepurchase.facts Transactions.SpouseRepurchase.position)),
      ("Sibling purchase and day-31 repurchase", SuperficialLoss.timeline (Transactions.SiblingAndLateRepurchase.facts [])),
      ("The edges of the period: days −31, −30, +30 and +31", SuperficialLoss.timeline boundaries),
      ("A suspended loss under 40(3.4): Opco and Sisterco", SuspendedLoss.timeline Transactions.SisterCompanyRepurchase.facts)] },
  { file := "affiliation", title := "Who is affiliated with whom"
    intro := "Worlds of persons under section 251.1, drawn from the computed relation. Rounded boxes are individuals, " ++
      "boxes corporations, hexagons partnerships, cylinders trusts. Dashed arrows are control (orange where a judgment " ++
      "call); each solid line is an affiliated pair, labelled with the paragraph that makes it so. Affiliation is not " ++
      "transitive: Cy's company is affiliated with Cy, but not with Ann."
    diagrams := [
      ("A family group", AffiliatedPersons.diagram familyGroup),
      ("Holdco, owned by the taxpayer and spouse", AffiliatedPersons.diagram Transactions.HoldcoRepurchase.world),
      ("An amalgamation: the hypothetical world of 251.1(2), with Newco supposed to exist immediately before",
        AffiliatedPersons.diagram (Amalgamation.hypothetical parentSubAmalgamation)),
      ("Holdco, owned with a friend, if the taxpayer controls it de facto",
        AffiliatedPersons.diagram (Transactions.HoldcoRepurchase.friendWorld
          [(Transactions.HoldcoRepurchase.friendCalls.head!).assume true]))] },
  { file := "related", title := "Who is related to whom"
    intro := "A family under section 251: children by blood (solid arrows), an adoption in fact (dotted), a marriage " ++
      "(thick line) and control of two companies (dashed). Each thin line is a related pair, labelled with its " ++
      "paragraph. Cousins, and an uncle and his nephew, are not related: blood relationship covers only descendants " ++
      "and brothers and sisters (251(6)(a)). A step-parent is, through marriage (251(6)(b)). Cousinco is related to " ++
      "Uncle, through Cousin (251(2)(b)(iii)), but not to Annco."
    diagrams := [("Three generations", RelatedPersons.diagram threeGenerations)] },
  { file := "series", title := "A transaction series, step by step"
    intro := "The toy three-step plan from `Canteen/Examples/ToySeries.lean`, with Rule X checked after every step. " ++
      "Green states are ones where Rule X applies."
    diagrams := [
      ("If condition B is met (J-B = yes)", seriesGraph [Examples.xOn [(Examples.toyCalls.head!).assume true]]
        Examples.toyPlan Examples.toyStart holding),
      ("If condition B is not met (J-B = no)", seriesGraph [Examples.xOn [(Examples.toyCalls.head!).assume false]]
        Examples.toyPlan Examples.toyStart holding)] } ]

end Canteen.Graphs

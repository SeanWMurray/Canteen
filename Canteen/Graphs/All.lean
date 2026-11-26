import Canteen.Core.Graphs
import Canteen.Examples.RuleXStatute
import Canteen.Examples.ToySeries
import Canteen.ITA.S54.SuperficialLossStatute
import Canteen.ITA.S54.Timeline
import Canteen.ITA.S40.LossDenialStatute
import Canteen.ITA.S251_1.Affiliation
import Canteen.Transactions.SpouseRepurchase
import Canteen.Transactions.SiblingAndLateRepurchase

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

def holding (h : Examples.Holding) : String :=
  s!"{h.units} units, election {if h.electionFiled then "filed" else "not filed"}"

def pages : List Page := [
  { file := "flowcharts", title := "Flowcharts of the rules"
    intro := "Each rule written with the `statute` command, drawn from its outline: every condition must be met, and " ++
      "no exception may apply. Grey clauses are facts, orange clauses rest on a judgment call, and blue clauses are " ++
      "other rules. The explanation Lean gives cites a failure on the facts before one that rests on judgment."
    diagrams := [
      ("Section 54, \"superficial loss\"", flowchart SuperficialLoss.superficialLossStatute.outline),
      ("Subparagraph 40(2)(g)(i)", flowchart LossDenial.lossDenialStatute.outline),
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
      ("Rule X with condition B and the exception both left to judgment",
        branchTree Examples.ruleX ruleXCalls ruleXFacts)] },
  { file := "timelines", title := "Timelines of the superficial loss period"
    intro := "The disposition, the period in paragraph (a) (30 days before to 30 days after, both ends included), every " ++
      "acquisition, and the end of the period in paragraph (b). Acquisitions that meet both (a) and (b) are red."
    diagrams := [
      ("Spouse repurchase", SuperficialLoss.timeline
        (Transactions.SpouseRepurchase.facts Transactions.SpouseRepurchase.position)),
      ("Sibling purchase and day-31 repurchase", SuperficialLoss.timeline (Transactions.SiblingAndLateRepurchase.facts [])),
      ("The edges of the period: days −31, −30, +30 and +31", SuperficialLoss.timeline boundaries)] },
  { file := "series", title := "A transaction series, step by step"
    intro := "The toy three-step plan from `Canteen/Examples/ToySeries.lean`, with Rule X checked after every step. " ++
      "Green states are ones where Rule X applies."
    diagrams := [
      ("If condition B is met (J-B = yes)", seriesGraph [Examples.xOn [(Examples.toyCalls.head!).assume true]]
        Examples.toyPlan Examples.toyStart holding),
      ("If condition B is not met (J-B = no)", seriesGraph [Examples.xOn [(Examples.toyCalls.head!).assume false]]
        Examples.toyPlan Examples.toyStart holding)] } ]

end Canteen.Graphs

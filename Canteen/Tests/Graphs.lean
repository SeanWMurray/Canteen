import Canteen.Graphs.All
import Canteen.Core.LeanGraph

/-!
# Tests: diagrams
-/

namespace Canteen.Tests.Graphs

open Canteen Canteen.Graphs

#guard wrap "one two three four five six" 9 == "one two<br/>three<br/>four five<br/>six"
#guard esc "say \"hi\"" == "say #quot;hi#quot;"

-- The flowchart of Rule X, in full.
#guard flowchart Examples.ruleXStatute.outline == "\n".intercalate ([
  "flowchart TD",
  "  S([\"Rule X · s.X\"]):::start",
  "  C0[\"<b>(a)</b> Condition A is met<br/>[s.X(a)]\"]:::fact",
  "  C1[\"<b>(b)</b> Condition B is met<br/><i>judgment call: J-B</i><br/>[s.X(b)]\"]:::judgment",
  "  E0[\"<b>(c)</b> The exception applies<br/>[s.X(c)]\"]:::fact",
  "  Y([\"Rule X applies\"]):::yes",
  "  N([\"Rule X does not apply\"]):::no",
  "  S --> C0",
  "  C0 -->|met| C1",
  "  C0 -->|not met| N",
  "  C1 -->|met| E0",
  "  C1 -->|not met| N",
  "  E0 -->|does not apply| Y",
  "  E0 -->|applies| N"] ++ classDefs.map ("  " ++ ·))

-- A decision tree has one leaf per branch: 2 calls, 4 leaves.
#guard ((branchTree Examples.ruleX ruleXCalls ruleXFacts).splitOn "]):::").length - 1 == 4

-- The timeline shows the period and marks qualifying acquisitions as critical.
#guard ((ITA.SuperficialLoss.timeline boundaries).splitOn ":milestone, crit,").length - 1 == 2

-- Transitive reduction drops an import already implied by another.
#guard LeanGraph.transitiveReduction [(`C, [`B, `A]), (`B, [`A]), (`A, [])] ==
  [(`C, [`B]), (`B, [`A]), (`A, [])]

end Canteen.Tests.Graphs

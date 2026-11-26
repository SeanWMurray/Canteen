import Canteen.Core.Statute
import Canteen.Core.Branch
import Canteen.Core.SeriesReport

/-!
# Graphs

Mermaid diagrams drawn from the Lean data, so a picture can never disagree with the rule it
shows. GitHub draws Mermaid in Markdown.

* `flowchart`: a statute-form rule, from its `Outline`.
* `branchTree`: a rule's outcome and risk on every answer to the judgment calls.
* `seriesGraph`: the states a transaction series passes through, and which rules apply.

The Lean-level graphs (project architecture, what each proof uses) are in
`Canteen/Core/LeanGraph.lean`.
-/

namespace Canteen.Graphs

/-- Text safe inside a quoted Mermaid label. -/
def esc (s : String) : String :=
  (s.replace "\"" "#quot;").replace "\n" " "

/-- Break text into lines of about `width` characters, at spaces, for a Mermaid label. -/
def wrap (s : String) (width : Nat := 44) : String :=
  let words := s.splitOn " "
  let (lines, cur) := words.foldl (fun (acc : List String × String) w =>
    let (lines, cur) := acc
    if cur.isEmpty then (lines, w)
    else if cur.length + 1 + w.length > width then (lines ++ [cur], w)
    else (lines, cur ++ " " ++ w)) ([], "")
  "<br/>".intercalate (lines ++ (if cur.isEmpty then [] else [cur]))

private def stripPeriod (s : String) : String :=
  if s.endsWith "." then (s.dropEnd 1).toString else s

/-- The colours used by every diagram. -/
def classDefs : List String :=
  [ "classDef fact fill:#eeeeee,stroke:#616161,color:#212121",
    "classDef judgment fill:#ffe0b2,stroke:#ef6c00,color:#e65100",
    "classDef rule fill:#bbdefb,stroke:#1565c0,color:#0d47a1",
    "classDef yes fill:#c8e6c9,stroke:#2e7d32,color:#1b5e20",
    "classDef no fill:#ffcdd2,stroke:#c62828,color:#b71c1c",
    "classDef start fill:#ffffff,stroke:#212121,color:#212121" ]

private def kindClass : ClauseKind → String
  | .fact => "fact"
  | .judgment _ => "judgment"
  | .rule _ => "rule"

private def clauseLabel (c : ClauseOutline) : String :=
  let note := match c.kind with
    | .judgment ids => s!"<br/><i>judgment call: {ids}</i>"
    | _ => ""
  let label := if c.label.isEmpty then "" else s!"<b>{c.label}</b> "
  esc s!"{label}{wrap (stripPeriod c.text)}{note}<br/>[{c.citation}]"

/-- A statute-form rule as a flowchart: each condition must be met, and no exception may
apply. Grey clauses are facts, orange judgment calls, blue other rules. -/
def flowchart (o : Outline) : String := Id.run do
  let conds := o.conditions.zipIdx.map fun (c, i) => (s!"C{i}", c)
  let excs := o.exceptions.zipIdx.map fun (c, i) => (s!"E{i}", c)
  let all := conds ++ excs
  let mut out := ["flowchart TD", s!"  S([\"{esc o.name} · {esc o.citation}\"]):::start"]
  for (id, c) in all do
    out := out ++ [s!"  {id}[\"{clauseLabel c}\"]:::{kindClass c.kind}"]
  out := out ++ [s!"  Y([\"{esc o.name} applies\"]):::yes", s!"  N([\"{esc o.name} does not apply\"]):::no"]
  let ids := all.map (·.1) ++ ["Y"]
  out := out ++ [s!"  S --> {ids.head!}"]
  for ((id, _), i) in conds.zipIdx do
    out := out ++ [s!"  {id} -->|met| {ids[i + 1]!}", s!"  {id} -->|not met| N"]
  for ((id, _), i) in excs.zipIdx do
    out := out ++ [s!"  {id} -->|does not apply| {ids[conds.length + i + 1]!}", s!"  {id} -->|applies| N"]
  return "\n".intercalate (out ++ classDefs.map ("  " ++ ·))

/-- Every answer to the judgment calls as a tree, with the rule's conclusion and risk at
each leaf. -/
def branchTree {Facts : Type} (r : Rule Facts) (calls : List JudgmentCall)
    (mk : List Judgment → Facts) : String :=
  let rec go : List JudgmentCall → List Judgment → String → List String
    | [], branch, id =>
      let e := r.explain (mk branch)
      let verdict := if e.conclusion then s!"{r.name} applies" else s!"{r.name} does not apply"
      [s!"  {id}([\"{esc verdict.capitalize}<br/>risk: {findingRisk branch e}\"]):::{if e.conclusion then "yes" else "no"}"]
    | c :: cs, branch, id =>
      [s!"  {id}{"{"}\"{esc c.id}<br/>{esc (wrap c.question 36)}\"{"}"}:::judgment",
       s!"  {id} -->|\"yes (risk {c.riskIfYes})\"| {id}y",
       s!"  {id} -->|\"no (risk {c.riskIfNo})\"| {id}n"] ++
        go cs (branch ++ [c.assume true]) (id ++ "y") ++ go cs (branch ++ [c.assume false]) (id ++ "n")
  "\n".intercalate (["flowchart LR"] ++ go calls [] "B" ++ classDefs.map ("  " ++ ·))

/-- The states a series passes through, each with whether each rule applies. -/
def seriesGraph {State : Type} (rules : List (Rule State)) (steps : List (TxStep State))
    (start : State) (describe : State → String) : String := Id.run do
  let reports := reportSeries rules 1 steps start
  let mut out := ["flowchart LR", s!"  s0[\"<b>Start</b><br/>{esc (describe start)}\"]:::start"]
  for sr in reports do
    let verdicts := (rules.zip sr.findings).map fun (r, f) =>
      s!"{r.name}: {if f.conclusion then "applies" else "does not apply"}"
    let any := sr.findings.any (·.conclusion)
    out := out ++ [s!"  s{sr.index}[\"<b>After step {sr.index}</b><br/>{esc (describe sr.after)}<br/>{esc ("<br/>".intercalate verdicts)}\"]:::{if any then "yes" else "fact"}",
                   s!"  s{sr.index - 1} -->|\"{esc (wrap sr.description 24)}\"| s{sr.index}"]
  return "\n".intercalate (out ++ classDefs.map ("  " ++ ·))

end Canteen.Graphs

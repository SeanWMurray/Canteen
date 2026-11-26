import Lean
import Canteen.Core.Finding
import Canteen.Core.Audit

/-!
# Blueprints: memos linked to Lean

Design §5, level 3, and roadmap Phase 5. A blueprint is a memo-style English document
whose statements (nodes) each name the Lean declarations behind them and the earlier
statements they use.

* **Links can't go stale.** Declarations are written as ``` ``Name ``` literals, which Lean
  resolves when the blueprint is compiled: a misspelled or deleted theorem is a build error.
* **Status comes from Lean, not from the author.** A node backed by a theorem is *proven*
  (if the theorem uses only standard axioms), by definitions only *encoded*, and by nothing
  *not formalized*. Facts and judgment calls are shown as such. A gap (`sorry`) makes a node
  *unproven*, and `check` refuses to publish such a blueprint.
* **Every assumption is visible** (design principle 6). Each node lists the facts, judgment
  calls and unformalized statements it rests on, directly or through other nodes.
* **The dependency graph** is rendered as Mermaid, which GitHub draws, coloured by status.

A node may use only nodes that come before it, so the graph has no cycles.
-/

namespace Canteen.Blueprint

open Lean

/-- What a statement in a blueprint is. -/
inductive Kind where
  /-- A fact of the transaction: an input, not proven. -/
  | fact
  /-- A judgment call: an answer assumed, not proven. -/
  | judgment
  /-- The law: a provision as encoded, or a proven truth about it. -/
  | law
  /-- A step of the analysis. -/
  | step
  /-- A conclusion. -/
  | conclusion
  deriving Repr, DecidableEq, BEq, Inhabited

/-- One statement in a blueprint. -/
structure Node where
  /-- Short, unique identifier, e.g. `"A3"`. -/
  id : String
  kind : Kind
  /-- A short title, used in the graph and as the heading. -/
  title : String
  /-- The statement, in plain English. -/
  statement : String
  /-- Statutory reference, if any. -/
  citation : String := ""
  /-- The Lean declarations behind the statement. -/
  lean : List Name := []
  /-- Ids of earlier statements this one uses. -/
  uses : List String := []
  deriving Repr, Inhabited

/-- A section of the memo. -/
structure Section where
  heading : String
  text : List String := []
  nodes : List Node := []
  deriving Repr, Inhabited

/-- A memo-style document linked to Lean. -/
structure Blueprint where
  title : String
  /-- Opening paragraphs. -/
  summary : List String := []
  sections : List Section
  /-- Arguments rendered by Lean (title, text), shown at the end. -/
  appendix : List (String × String) := []
  /-- Further diagrams (title, Mermaid source), shown after the dependency graph. -/
  diagrams : List (String × String) := []
  deriving Inhabited

/-! ## Structure (pure, checkable with `#guard`) -/

namespace Blueprint

/-- Every node, in document order. -/
def nodes (bp : Blueprint) : List Node :=
  bp.sections.flatMap (·.nodes)

/-- Structural problems: duplicate ids, and uses of unknown or later nodes. -/
def problems (bp : Blueprint) : List String :=
  let all := bp.nodes.map (·.id)
  let step (acc : List String × List String) (n : Node) : List String × List String :=
    let (seen, errs) := acc
    let errs := if seen.contains n.id then errs ++ [s!"duplicate id {n.id}"] else errs
    let errs := n.uses.foldl (fun errs u =>
      if seen.contains u then errs
      else if all.contains u then errs ++ [s!"{n.id} uses {u}, which comes later"]
      else errs ++ [s!"{n.id} uses unknown {u}"]) errs
    (seen ++ [n.id], errs)
  (bp.nodes.foldl step ([], [])).2

/-- For each node, every node it rests on, directly or indirectly, in document order of
first use. -/
def closures (bp : Blueprint) : List (String × List String) :=
  bp.nodes.foldl (fun acc n =>
    let deps := n.uses.foldl (fun ds u =>
      mergeIds ds (mergeIds [u] (((acc.find? (·.1 == u)).map (·.2)).getD []))) []
    acc ++ [(n.id, deps)]) []

/-- Every node `id` rests on, directly or indirectly. -/
def restsOn (bp : Blueprint) (id : String) : List String :=
  ((bp.closures.find? (·.1 == id)).map (·.2)).getD []

end Blueprint

/-! ## Status (from the Lean environment) -/

/-- A node's status. -/
inductive Status where
  /-- Backed by at least one theorem; everything behind it uses only standard axioms. -/
  | proven
  /-- Backed by definitions only: the law or facts as encoded. -/
  | encoded
  /-- A fact of the transaction. -/
  | fact
  /-- A judgment call. -/
  | judgment
  /-- No Lean behind it yet. -/
  | notFormalized
  /-- Backed by Lean with a gap (`sorry` or a non-standard axiom). -/
  | unproven
  deriving Repr, DecidableEq, BEq, Inhabited

def Status.label : Status → String
  | .proven => "proven"
  | .encoded => "encoded"
  | .fact => "fact"
  | .judgment => "judgment call"
  | .notFormalized => "not formalized"
  | .unproven => "unproven"

/-- Mermaid class name. -/
def Status.cls : Status → String
  | .proven => "proven"
  | .encoded => "encoded"
  | .fact => "fact"
  | .judgment => "judgment"
  | .notFormalized => "notFormalized"
  | .unproven => "unproven"

/-- Whether a declaration is a theorem, and whether it is free of gaps. -/
def declStatus (n : Name) : CoreM Status := do
  let some ci := (← getEnv).find? n | throwError "blueprint refers to unknown declaration {n}"
  let axs ← collectAxioms n
  if axs.any (fun a => !Audit.standardAxioms.contains a) then return .unproven
  match ci with
  | .thmInfo _ => return .proven
  | .axiomInfo _ => return .unproven
  | _ => return .encoded

/-- A node's status: facts and judgment calls by kind, everything else by its Lean. -/
def nodeStatus (n : Node) : CoreM Status := do
  let ss ← n.lean.mapM declStatus
  if ss.contains .unproven then return .unproven
  match n.kind with
  | .fact => return .fact
  | .judgment => return .judgment
  | _ =>
    if ss.isEmpty then return .notFormalized
    else if ss.contains .proven then return .proven
    else return .encoded

/-- Each node's id and status, in document order. -/
def statuses (bp : Blueprint) : CoreM (List (String × Status)) :=
  bp.nodes.mapM fun n => return (n.id, ← nodeStatus n)

/-- One line per node: `id: status`. -/
def statusTable (bp : Blueprint) : CoreM String := do
  return "\n".intercalate ((← statuses bp).map fun (id, s) => s!"{id}: {s.label}")

/-! ## What the proofs really use -/

/-- Types, their constructors and recursors: mentioning a type is not relying on a
statement, so they are neither dependencies nor followed. -/
def isType (env : Environment) (n : Name) : Bool :=
  match env.find? n with
  | some (.inductInfo _) | some (.ctorInfo _) | some (.recInfo _) => true
  | _ => false

/-- The declarations in `targets` that `n`'s type or value uses, directly or through other
declarations of this package (those under `pkg`). -/
partial def leanDeps (pkg : Name) (targets : NameSet) (n : Name) : CoreM NameSet := do
  let env ← getEnv
  let rec visit (todo : List Name) (seen : NameSet) (found : NameSet) : NameSet :=
    match todo with
    | [] => found
    | m :: rest =>
      if seen.contains m then visit rest seen found
      else
        let seen := seen.insert m
        if isType env m then visit rest seen found
        else if targets.contains m && m != n then visit rest seen (found.insert m)
        else if m != n && !Audit.inScope env pkg m then visit rest seen found
        else
          match env.find? m with
          | some ci => visit (ci.getUsedConstantsAsSet.toList ++ rest) seen found
          | none => visit rest seen found
  return visit [n] {} {}

/-- For each node, the other nodes whose Lean its Lean uses. -/
def leanEdges (bp : Blueprint) (pkg : Name := `Canteen) : CoreM (List (String × List String)) := do
  let owners : List (Name × String) := bp.nodes.flatMap fun nd => nd.lean.map (·, nd.id)
  bp.nodes.mapM fun nd => do
    let targets := owners.foldl (fun s (d, o) => if o == nd.id || nd.lean.contains d then s else s.insert d) ({} : NameSet)
    let mut used : List String := []
    for d in nd.lean do
      let deps ← leanDeps pkg targets d
      for t in deps.toList do
        for (d', o) in owners do
          if d' == t && o != nd.id && !used.contains o then used := used ++ [o]
    return (nd.id, used)

/-- Dependencies the proofs have but the memo does not state: node `N`'s Lean uses a
declaration of node `M`, yet `N` does not rest on `M` (or on any other node with that
declaration). A memo may not understate what its conclusions depend on. -/
def hiddenDependencies (bp : Blueprint) (pkg : Name := `Canteen) : CoreM (List (String × Name)) := do
  let owners : List (Name × String) := bp.nodes.flatMap fun nd => nd.lean.map (·, nd.id)
  let mut out := []
  for nd in bp.nodes do
    let targets := owners.foldl (fun s (d, o) => if o == nd.id || nd.lean.contains d then s else s.insert d) ({} : NameSet)
    let rests := bp.restsOn nd.id
    for d in nd.lean do
      for t in (← leanDeps pkg targets d).toList do
        let ownersOfT := owners.filterMap fun (d', o) => if d' == t then some o else none
        unless ownersOfT.any rests.contains do
          out := out ++ [(nd.id, t)]
  return out

/-- Refuse a blueprint with structural problems, any unproven node, or a dependency its
proofs have that it does not state. -/
def check (bp : Blueprint) : CoreM Unit := do
  unless bp.problems.isEmpty do
    throwError "blueprint '{bp.title}' has problems: {bp.problems}"
  let bad := (← statuses bp).filter (·.2 == .unproven)
  unless bad.isEmpty do
    throwError "blueprint '{bp.title}' has unproven statements: {bad.map (·.1)}"
  let hidden ← hiddenDependencies bp
  unless hidden.isEmpty do
    let lines := hidden.map fun (id, t) => s!"{id} uses {t}"
    throwError "blueprint '{bp.title}' has hidden dependencies: {lines}"

/-! ## Rendering to Markdown -/

/-- A Markdown link to a declaration's source, relative to the document. -/
def declLink (root : String) (n : Name) : CoreM String := do
  let env ← getEnv
  let some idx := env.getModuleIdxFor? n | return s!"`{n}`"
  let mod := env.header.moduleNames[idx.toNat]!
  let path := "/".intercalate (mod.components.map toString) ++ ".lean"
  let line := match ← findDeclarationRanges? n with
    | some r => s!"#L{r.range.pos.line}"
    | none => ""
  return s!"[`{n}`]({root}{path}{line})"

private def mermaidLabel (s : String) : String :=
  s.replace "\"" "#quot;"

/-- The memo, with its dependency graph, as Markdown. `root` is the path from the document
to the repository root, for source links. -/
def render (bp : Blueprint) (root : String := "../../") : CoreM String := do
  check bp
  let sts ← statuses bp
  let statusOf (id : String) : Status := ((sts.find? (·.1 == id)).map (·.2)).getD .notFormalized
  let idx := bp.nodes.zipIdx
  let mid (id : String) : String := s!"n{((idx.find? (·.1.id == id)).map (·.2)).getD 0}"
  let mut out := s!"# {bp.title}\n\n"
  out := out ++ "> Generated from the Lean sources by `scripts/blueprint.sh`. Do not edit by hand.\n\n"
  for p in bp.summary do out := out ++ p ++ "\n\n"
  -- Status counts
  let count (s : Status) := (sts.filter (·.2 == s)).length
  let counts := [Status.proven, .encoded, .fact, .judgment, .notFormalized].filterMap fun s =>
    if count s = 0 then none else some s!"{count s} {s.label}"
  out := out ++ s!"**Status of the {sts.length} statements:** {", ".intercalate counts}.\n\n"
  -- Graph
  out := out ++ "## Dependency graph\n\n```mermaid\ngraph TD\n"
  for (n, i) in idx do
    out := out ++ s!"  n{i}[\"{n.id} · {mermaidLabel n.title}\"]:::{(statusOf n.id).cls}\n"
  for n in bp.nodes do
    for u in n.uses do
      out := out ++ s!"  {mid u} --> {mid n.id}\n"
  out := out ++ "  classDef proven fill:#c8e6c9,stroke:#2e7d32,color:#1b5e20\n"
  out := out ++ "  classDef encoded fill:#bbdefb,stroke:#1565c0,color:#0d47a1\n"
  out := out ++ "  classDef fact fill:#eeeeee,stroke:#616161,color:#212121\n"
  out := out ++ "  classDef judgment fill:#ffe0b2,stroke:#ef6c00,color:#e65100\n"
  out := out ++ "  classDef notFormalized fill:#ffffff,stroke:#c62828,color:#b71c1c,stroke-dasharray:5 5\n"
  out := out ++ "  classDef unproven fill:#ffcdd2,stroke:#c62828,color:#b71c1c\n"
  out := out ++ "```\n\n"
  out := out ++ "Green: proven in Lean. Blue: encoded (definitions). Grey: facts. Orange: judgment calls. " ++
    "Dashed red: not yet formalized. An arrow points from a statement to the statements that use it.\n\n"
  -- What the proofs use
  let edges ← leanEdges bp
  out := out ++ "### What the Lean proofs use\n\n" ++
    "The same statements, with the dependencies Lean finds in the proofs themselves (solid) and those stated " ++
    "only in the memo's reasoning (dotted). Every dependency a proof has is also stated in the memo: " ++
    "`Blueprint.check` refuses a memo that hides one.\n\n```mermaid\ngraph TD\n"
  for (n, i) in idx do
    out := out ++ s!"  n{i}[\"{n.id}\"]:::{(statusOf n.id).cls}\n"
  for n in bp.nodes do
    let viaLean := ((edges.find? (·.1 == n.id)).map (·.2)).getD []
    for u in viaLean do
      out := out ++ s!"  {mid u} --> {mid n.id}\n"
    for u in n.uses do
      unless viaLean.contains u do
        out := out ++ s!"  {mid u} -.-> {mid n.id}\n"
  out := out ++ "  classDef proven fill:#c8e6c9,stroke:#2e7d32,color:#1b5e20\n"
  out := out ++ "  classDef encoded fill:#bbdefb,stroke:#1565c0,color:#0d47a1\n"
  out := out ++ "  classDef fact fill:#eeeeee,stroke:#616161,color:#212121\n"
  out := out ++ "  classDef judgment fill:#ffe0b2,stroke:#ef6c00,color:#e65100\n"
  out := out ++ "  classDef notFormalized fill:#ffffff,stroke:#c62828,color:#b71c1c,stroke-dasharray:5 5\n"
  out := out ++ "```\n\n"
  -- Further diagrams
  for (t, src) in bp.diagrams do
    out := out ++ s!"### {t}\n\n```mermaid\n{src}\n```\n\n"
  -- Sections
  for sec in bp.sections do
    out := out ++ s!"## {sec.heading}\n\n"
    for p in sec.text do out := out ++ p ++ "\n\n"
    for n in sec.nodes do
      let s := statusOf n.id
      out := out ++ s!"### {n.id}. {n.title}\n\n"
      let mut info := [s!"**Status:** {s.label}"]
      unless n.citation.isEmpty do info := info ++ [s!"**Citation:** {n.citation}"]
      unless n.uses.isEmpty do info := info ++ [s!"**Uses:** {", ".intercalate n.uses}"]
      out := out ++ " · ".intercalate info ++ "\n\n"
      out := out ++ n.statement ++ "\n\n"
      unless n.lean.isEmpty do
        let links ← n.lean.mapM (declLink root)
        out := out ++ s!"**Lean:** {", ".intercalate links}\n\n"
      let deps := bp.restsOn n.id
      let pick (st : Status) := deps.filter (statusOf · == st)
      let rests := [("judgment calls", pick .judgment), ("facts", pick .fact),
                    ("not yet formalized", pick .notFormalized)].filterMap fun (label, ids) =>
        if ids.isEmpty then none else some s!"{label} {", ".intercalate ids}"
      unless rests.isEmpty do
        out := out ++ s!"**Rests on:** {"; ".intercalate rests}.\n\n"
  -- Appendix
  unless bp.appendix.isEmpty do
    out := out ++ "## Appendix: the argument as Lean renders it\n\n"
    for (t, body) in bp.appendix do
      out := out ++ s!"### {t}\n\n```\n{body}\n```\n\n"
  return out

end Canteen.Blueprint

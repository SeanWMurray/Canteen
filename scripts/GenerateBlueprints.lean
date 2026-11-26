import Canteen

/-!
Renders every blueprint in `Canteen.Blueprints.all` to `docs/blueprint/<file>.md`, every
graph page in `Canteen.Graphs.pages` to `docs/graphs/<file>.md`, the architecture page, and
an index for each folder. Run through `scripts/blueprint.sh` from the repository root.
-/

open Lean Elab Command Canteen

def generated : String := "> Generated from the Lean sources by `scripts/blueprint.sh`. Do not edit by hand.\n\n"

#eval show CommandElabM Unit from do
  -- Blueprints
  IO.FS.createDirAll "docs/blueprint"
  let mut index := "# Blueprints\n\n" ++ generated ++
    "Memo-style documents whose statements link to the Lean that proves or encodes them, with a dependency graph " ++
    "coloured by status, and a second graph of what the proofs themselves use.\n\n"
  for (file, bp) in Canteen.Blueprints.all do
    let md ← liftCoreM (Blueprint.render bp)
    IO.FS.writeFile s!"docs/blueprint/{file}.md" md
    let sts ← liftCoreM (Blueprint.statuses bp)
    let proven := (sts.filter (·.2 == .proven)).length
    let open_ := (sts.filter (·.2 == .notFormalized)).length
    index := index ++ s!"- [{bp.title}]({file}.md): {sts.length} statements, {proven} proven, {open_} not yet formalized\n"
    logInfo m!"wrote docs/blueprint/{file}.md"
  index := index ++ "\nMore diagrams: [`docs/graphs/`](../graphs/README.md).\n"
  IO.FS.writeFile "docs/blueprint/README.md" index
  -- Graph pages
  IO.FS.createDirAll "docs/graphs"
  let mut gindex := "# Graphs\n\n" ++ generated ++
    "Diagrams drawn from the Lean definitions, so they always show the rules as encoded.\n\n"
  for p in Canteen.Graphs.pages do
    let mut md := s!"# {p.title}\n\n{generated}{p.intro}\n\n"
    for (h, src) in p.diagrams do
      md := md ++ s!"## {h}\n\n```mermaid\n{src}\n```\n\n"
    IO.FS.writeFile s!"docs/graphs/{p.file}.md" md
    gindex := gindex ++ s!"- [{p.title}]({p.file}.md): {", ".intercalate (p.diagrams.map (·.1))}\n"
    logInfo m!"wrote docs/graphs/{p.file}.md"
  -- Architecture
  let isTest (m : Name) := (m.components.drop 1).head? == some `Tests
  let arch ← liftCoreM (LeanGraph.architecture `Canteen isTest)
  IO.FS.writeFile "docs/graphs/architecture.md" <|
    "# Architecture\n\n" ++ generated ++
    "Every module of the library (tests left out), grouped by layer, with an arrow from a module to each module " ++
    "that builds on it. Imports already implied by others are left out. Read from the compiled modules.\n\n" ++
    s!"```mermaid\n{arch}\n```\n"
  let pmap ← liftCoreM (LeanGraph.provisionMap Canteen.Graphs.provisions)
  IO.FS.writeFile "docs/graphs/provisions.md" <|
    "# Provision map\n\n" ++ generated ++
    "Every encoded provision, with an arrow from a provision to each one whose encoding builds on it, read from the " ++
    "compiled modules (arrows already implied by others are left out). For example, 40(3.3) to (3.5) builds on the " ++
    "superficial loss definition (its period and exceptions), and section 251 on section 251.1 (its world of persons and " ++
    "the 251(6) connections).\n\n" ++
    s!"```mermaid\n{pmap}\n```\n"
  gindex := gindex ++ "- [Provision map](provisions.md): which encoded provisions rely on which, read from the Lean\n"
  -- Dashboard
  let mut counts : List (Blueprint.Status × Nat) := []
  for (_, bp) in Canteen.Blueprints.all do
    for (_, st) in ← liftCoreM (Blueprint.statuses bp) do
      counts := match counts.find? (·.1 == st) with
        | some _ => counts.map fun (s, n) => if s == st then (s, n + 1) else (s, n)
        | none => counts ++ [(st, 1)]
  let total := counts.foldl (· + ·.2) 0
  let pie := "pie showData title All " ++ toString total ++ " statements in the memos and blueprints, by status\n" ++
    "\n".intercalate (counts.map fun (st, n) => s!"    \"{st.label}\" : {n}")
  IO.FS.writeFile "docs/graphs/dashboard.md" <|
    "# Dashboard\n\n" ++ generated ++
    "An overview of the project, drawn from the Lean.\n\n" ++
    "## Statements by status\n\nEvery statement in every blueprint, by the status Lean computes for it.\n\n" ++
    s!"```mermaid\n{pie}\n```\n\n" ++
    "## Judgment calls by risk\n\nEvery judgment call in the transactions and examples, placed by the risk of " ++
    "answering \"yes\" (across) and \"no\" (up). Calls in the same place are spread out a little.\n\n" ++
    s!"```mermaid\n{Canteen.Graphs.judgmentQuadrant}\n```\n\n" ++
    "## The transactions, by date\n\nThe key dates, read from each transaction's facts.\n\n" ++
    s!"```mermaid\n{Canteen.Graphs.transactionTimeline}\n```\n\n" ++
    "## The Act, as encoded\n\n" ++
    s!"```mermaid\n{Canteen.Graphs.actMindmap}\n```\n"
  gindex := gindex ++ "- [Dashboard](dashboard.md): statements by status, judgment calls by risk, the transactions by date, and the Act as encoded\n"
  gindex := gindex ++ "- [Architecture](architecture.md): every module, by layer, and how they build on each other\n" ++
    "\nEach blueprint in [`docs/blueprint/`](../blueprint/README.md) also has its own dependency graphs.\n"
  IO.FS.writeFile "docs/graphs/README.md" gindex

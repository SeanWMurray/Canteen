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
  gindex := gindex ++ "- [Architecture](architecture.md): every module, by layer, and how they build on each other\n" ++
    "\nEach blueprint in [`docs/blueprint/`](../blueprint/README.md) also has its own dependency graphs.\n"
  IO.FS.writeFile "docs/graphs/README.md" gindex

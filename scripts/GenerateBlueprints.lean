import Canteen

/-!
Renders every blueprint in `Canteen.Blueprints.all` to `docs/blueprint/<file>.md`, plus an
index. Run through `scripts/blueprint.sh` from the repository root.
-/

open Lean Elab Command Canteen

#eval show CommandElabM Unit from do
  IO.FS.createDirAll "docs/blueprint"
  let mut index := "# Blueprints\n\n> Generated from the Lean sources by `scripts/blueprint.sh`. Do not edit by hand.\n\n" ++
    "Memo-style documents whose statements link to the Lean that proves or encodes them, with a dependency graph " ++
    "coloured by status.\n\n"
  for (file, bp) in Canteen.Blueprints.all do
    let md ← liftCoreM (Blueprint.render bp)
    IO.FS.writeFile s!"docs/blueprint/{file}.md" md
    let sts ← liftCoreM (Blueprint.statuses bp)
    let proven := (sts.filter (·.2 == .proven)).length
    let open_ := (sts.filter (·.2 == .notFormalized)).length
    index := index ++ s!"- [{bp.title}]({file}.md): {sts.length} statements, {proven} proven, {open_} not yet formalized\n"
    logInfo m!"wrote docs/blueprint/{file}.md"
  IO.FS.writeFile "docs/blueprint/README.md" index

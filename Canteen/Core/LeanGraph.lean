import Lean
import Canteen.Core.Graphs

/-!
# The project's architecture, from its imports

`architecture` draws every module of the package and the imports between them, grouped by
layer (design §3), with redundant imports (those implied by others) left out. It is read
from the compiled environment, so it is always current.
-/

namespace Canteen.LeanGraph

open Lean

/-- Modules of the package `pkg`, and for each the package modules it imports directly. -/
def moduleImports (pkg : Name) (skip : Name → Bool) : CoreM (List (Name × List Name)) := do
  let env ← getEnv
  let mods := env.header.moduleNames.toList.zipIdx.filter fun (m, _) => pkg.isPrefixOf m && !skip m
  return mods.map fun (m, i) =>
    let imps := env.header.moduleData[i]!.imports.toList.map (·.module)
    (m, imps.filter fun i => pkg.isPrefixOf i && !skip i)

/-- Drop each import that is already implied through another import. -/
def transitiveReduction (g : List (Name × List Name)) : List (Name × List Name) :=
  let succ (m : Name) : List Name := ((g.find? (·.1 == m)).map (·.2)).getD []
  let rec reach (fuel : Nat) (todo : List Name) (seen : List Name) : List Name :=
    match fuel, todo with
    | 0, _ => seen
    | _, [] => seen
    | fuel + 1, m :: rest =>
      if seen.contains m then reach fuel rest seen else reach fuel (succ m ++ rest) (m :: seen)
  let fuel := g.length * g.length + 10
  g.map fun (m, imps) =>
    (m, imps.filter fun i =>
      !(imps.any fun j => j != i && (reach fuel [j] []).contains i))

/-- The layer of a module, from its second name component, e.g. `Core` or `ITA`. -/
def layerOf (m : Name) : String :=
  match m.components with
  | _ :: l :: _ :: _ => l.toString
  | _ => "Root"

def layerTitle : String → String
  | "Core" => "Layer 0: core language"
  | "ITA" => "Layer 1: statute encoding"
  | "Lemmas" => "Layer 2: reusable lemmas"
  | "Transactions" => "Layer 3: transactions"
  | "Blueprints" => "Blueprints"
  | "Examples" => "Examples"
  | "Graphs" => "Graphs"
  | "Tests" => "Tests"
  | l => l

/-- The architecture as a Mermaid flowchart: an arrow from a module to each module that
builds on it. -/
def architecture (pkg : Name := `Canteen) (skip : Name → Bool := fun _ => false) : CoreM String := do
  let g := transitiveReduction (← moduleImports pkg skip)
  let ids := g.zipIdx.map fun ((m, _), i) => (m, s!"m{i}")
  let idOf (m : Name) := ((ids.find? (·.1 == m)).map (·.2)).getD "m"
  let short (m : Name) := ".".intercalate ((m.components.drop 1).map toString)
  let layers := ["Core", "ITA", "Lemmas", "Transactions", "Blueprints", "Examples", "Graphs", "Tests", "Root"]
  let mut out := ["flowchart BT"]
  for l in layers do
    let ms := g.filter fun (m, _) => layerOf m == l
    unless ms.isEmpty do
      out := out ++ [s!"  subgraph {l}[\"{layerTitle l}\"]"]
      for (m, _) in ms do
        out := out ++ [s!"    {idOf m}[\"{if short m == "" then m.toString else short m}\"]"]
      out := out ++ ["  end"]
  for (m, imps) in g do
    for i in imps do
      out := out ++ [s!"  {idOf i} --> {idOf m}"]
  return "\n".intercalate out

end Canteen.LeanGraph

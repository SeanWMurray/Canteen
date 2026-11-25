import Canteen.Blueprints.All

/-!
# Tests: blueprints
-/

namespace Canteen.Tests.Blueprint

open Lean Canteen Canteen.Blueprint

/-! ## Structure -/

-- Every published blueprint is well formed.
#guard Canteen.Blueprints.all.all fun (_, bp) => bp.problems.isEmpty

def toy : Blueprint where
  title := "Toy"
  sections := [
    { heading := "S", nodes := [
      { id := "A", kind := .fact, title := "a", statement := "a" },
      { id := "B", kind := .step, title := "b", statement := "b", uses := ["A", "C"] },
      { id := "A", kind := .step, title := "a again", statement := "a", uses := ["Z"] },
      { id := "C", kind := .step, title := "c", statement := "c", uses := ["B"] } ] } ]

#guard toy.problems ==
  ["B uses C, which comes later", "duplicate id A", "A uses unknown Z"]

def chain : Blueprint where
  title := "Chain"
  sections := [
    { heading := "S", nodes := [
      { id := "F", kind := .fact, title := "f", statement := "f" },
      { id := "J", kind := .judgment, title := "j", statement := "j" },
      { id := "X", kind := .step, title := "x", statement := "x", uses := ["F"] },
      { id := "Y", kind := .step, title := "y", statement := "y", uses := ["X", "J"] },
      { id := "Z", kind := .step, title := "z", statement := "z", uses := ["Y", "F"] } ] } ]

#guard chain.problems.isEmpty
#guard chain.restsOn "Z" == ["Y", "X", "F", "J"]
#guard chain.restsOn "F" == []

/-! ## Status, computed from Lean -/

/-- info: F1: fact
F2: fact
F3: fact
F4: fact
F5: fact
J-ID: judgment call
L1: proven
L2: encoded
A1: proven
A2: proven
A3: proven
A4: proven
A5: proven
A6: proven
A7: proven
A8: proven
C1: not formalized
K: proven -/
#guard_msgs in
#eval show CoreM Unit from do
  IO.println (← statusTable Canteen.Blueprints.SpouseRepurchase.memo)

/-- info: P0: encoded
Pa: encoded
Pb: encoded
Pc: encoded
Pd: encoded
Pe: encoded
Pf: encoded
Pg: encoded
Ph: encoded
Pi: encoded
Pj: encoded
D: encoded
E: proven
L1: proven
L2: proven
L3: proven
L4: proven
L5: proven
L6: proven
L7: proven
L8: proven
L9: proven
L10: proven
L11: proven
L12: proven
G0: encoded
G1: encoded
N1: not formalized
N2: not formalized
N3: not formalized
N4: not formalized -/
#guard_msgs in
#eval show CoreM Unit from do
  IO.println (← statusTable Canteen.Blueprints.SuperficialLoss.blueprint)

-- Both blueprints pass `check`: well formed, and nothing unproven.
#eval show CoreM Unit from do
  for (_, bp) in Canteen.Blueprints.all do check bp

end Canteen.Tests.Blueprint

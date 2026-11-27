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

/-- info: L0: proven
L1: proven
L2: encoded
L3: encoded
F1: fact
F2: fact
F3: fact
F4: fact
F5: fact
F6: fact
J-ID: judgment call
A0: proven
A1: proven
A2: proven
A3: proven
A4: proven
A5: proven
A6: proven
A7: proven
A8: proven
C1: proven
C2: proven
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
Pa+: encoded
D: encoded
E: proven
S: proven
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
L13: proven
L14: proven
G0: encoded
G1: encoded
GS: proven
G2: proven
PUP: encoded
G3: proven
G4: proven
G5: proven
R1: proven
R3: proven
R4: proven
R7: proven
R10: proven
R5: proven
R6: proven
R8: proven
R9: proven
R12: proven
R13: proven
R14: proven
R15: proven
R16: proven
R17: proven
R18: proven
R19: proven
R20: proven
R21: proven
R22: proven
R23: proven
R24: proven
R25: proven
R26: proven
R27: proven
R28: proven
R29: proven
R30: proven
R31: proven
R32: proven
R33: proven
R34: proven
R36: proven
R37: proven
R38: proven
R39: proven
R40: proven
R41: proven
R42: proven
R43: proven
R44: proven
R45: proven
R46: proven
R47: proven
R49: proven
R50: proven
R51: proven
R52: proven
R53: proven
R54: proven
R55: proven
R56: proven
R57: proven
R58: proven
R59: proven
R60: proven
R61: proven
R62: proven
R63: proven
R64: proven
R65: proven
R66: proven
R67: proven
R68: proven
R69: proven
R71: proven
R72: proven
R73: proven
R74: proven
R75: proven
R76: proven
R77: proven
R78: proven
R79: proven
R80: proven
R81: proven
R82: proven
R83: proven
R84: proven
R85: proven
R70: proven
R35: proven
R48: proven
R11: proven
R2: proven
N1: not formalized
N2: not formalized
N4: not formalized -/
#guard_msgs in
#eval show CoreM Unit from do
  IO.println (← statusTable Canteen.Blueprints.SuperficialLoss.blueprint)

/-- info: L0: proven
L1: proven
L2: encoded
F1: fact
F2: fact
F3: fact
F4: fact
F5: fact
J-SIB: judgment call
J-LATE: judgment call
A1: proven
A2: proven
A3: proven
A4: proven
A5: proven
A6: proven
K: proven -/
#guard_msgs in
#eval show CoreM Unit from do
  IO.println (← statusTable Canteen.Blueprints.SiblingAndLateRepurchase.memo)

-- The sibling memo's conclusion rests on no judgment call.
#guard (Canteen.Blueprints.SiblingAndLateRepurchase.memo.restsOn "K").all
  fun id => !["J-SIB", "J-LATE"].contains id

-- The TFSA memo's conclusion rests on no judgment call, though a step along the way does.
#guard (Canteen.Blueprints.TfsaContribution.memo.restsOn "K").all (· != "J-AFF")
#guard (Canteen.Blueprints.TfsaContribution.memo.restsOn "A3").contains "J-AFF"

-- Every blueprint passes `check`: well formed, and nothing unproven.
#eval show CoreM Unit from do
  for (_, bp) in Canteen.Blueprints.all do check bp

end Canteen.Tests.Blueprint

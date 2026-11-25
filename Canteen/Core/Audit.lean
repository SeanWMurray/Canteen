import Lean

/-!
# Audit: no hidden gaps

Validation tooling (design §6, "No hidden gaps"). `#audit_axioms Pkg` checks every
declaration defined in a module whose name starts with `Pkg` (plus the current
file) and fails if any of them:

* is itself an `axiom`, or
* depends, directly or transitively, on an axiom other than Lean's three standard
  ones (`propext`, `Classical.choice`, `Quot.sound`). This catches `sorry`
  (`sorryAx`) and `native_decide` (which adds an axiom trusting the compiler
  rather than Lean's kernel).

`#print axioms thm` still works for inspecting a single theorem.
-/

namespace Canteen.Audit

open Lean Elab Command

/-- The axioms a Canteen proof may rely on: Lean's standard foundations. -/
def standardAxioms : List Name := [``propext, ``Classical.choice, ``Quot.sound]

/-- Is `n` declared in a module under `pkg`, or in the file being elaborated? -/
def inScope (env : Environment) (pkg : Name) (n : Name) : Bool :=
  match env.getModuleIdxFor? n with
  | some idx => pkg.isPrefixOf (env.header.moduleNames[idx.toNat]!)
  | none => true

/-- Audit every declaration in scope; return the number audited and the offending
`(declaration, axiom)` pairs. -/
def run (pkg : Name) : CommandElabM (Nat × Array (Name × Name)) := do
  let env ← getEnv
  let mut count := 0
  let mut bad : Array (Name × Name) := #[]
  for (n, ci) in env.constants.toList do
    unless inScope env pkg n do continue
    count := count + 1
    if ci matches .axiomInfo _ then
      bad := bad.push (n, n)
      continue
    let axs ← liftCoreM (collectAxioms n)
    for a in axs do
      unless standardAxioms.contains a do
        bad := bad.push (n, a)
  return (count, bad)

/-- `#audit_axioms Pkg`: fail if any declaration under `Pkg` is an axiom or relies on
`sorry` or any non-standard axiom. -/
elab "#audit_axioms " pkg:ident : command => do
  let (count, bad) ← run pkg.getId
  if bad.isEmpty then
    logInfo m!"Audit passed: {count} declarations under {pkg.getId} use only standard axioms."
  else
    let lines := bad.toList.map fun (d, a) => m!"\n  {d} relies on {a}"
    throwError m!"Audit failed: {bad.size} problem(s) found:{MessageData.joinSep lines ""}"

end Canteen.Audit

import TaxLean

/-!
Runs on every `lake build` (it is a default target). Fails the build if any
declaration in the `TaxLean` package is an axiom or depends on `sorry`
or any axiom beyond Lean's standard three (design §6, "No hidden gaps").
-/

#audit_axioms TaxLean

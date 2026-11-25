-- expect: sorryAx
/-
Phase 2 check: a proof left open with `sorry` must fail the audit,
even though Lean itself only warns about it.
-/
import TaxLean.Core.Audit

namespace TaxLean.ShouldFail

theorem unfinished : 1 + 1 = 3 := by
  sorry

end TaxLean.ShouldFail

#audit_axioms TaxLean

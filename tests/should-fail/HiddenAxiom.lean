-- expect: TaxLean.ShouldFail.conditionBAlwaysHolds
/-
Phase 2 check: an `axiom` that quietly assumes away a judgment call must fail
the audit, whether or not anything uses it.
-/
import TaxLean.Core.Audit

namespace TaxLean.ShouldFail

axiom conditionBAlwaysHolds : ∀ b : Bool, b = true

end TaxLean.ShouldFail

#audit_axioms TaxLean

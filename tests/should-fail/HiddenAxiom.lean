-- expect: Canteen.ShouldFail.conditionBAlwaysHolds
/-
Phase 2 check: an `axiom` that quietly assumes away a judgment call must fail
the audit, whether or not anything uses it.
-/
import Canteen.Core.Audit

namespace Canteen.ShouldFail

axiom conditionBAlwaysHolds : ∀ b : Bool, b = true

end Canteen.ShouldFail

#audit_axioms Canteen

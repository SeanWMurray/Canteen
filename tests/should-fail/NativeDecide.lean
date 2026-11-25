-- expect: viaCompiler relies on
/-
Phase 2 check: `native_decide` trusts the compiler rather than Lean's kernel,
so a proof that uses it must fail the audit.
-/
import Canteen.Core.Audit

namespace Canteen.ShouldFail

theorem viaCompiler : 2 + 2 = 4 := by
  native_decide

end Canteen.ShouldFail

#audit_axioms Canteen

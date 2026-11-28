import Canteen.ITA.S75.ReversionaryTrust

/-!
# Tests: 75(2), reversionary trusts

A parent settles a family trust with $500,000 of shares, and is a trustee whose consent every sale needs.
Constructed examples.
-/

namespace Canteen.Tests.ReversionaryTrust

open Canteen Canteen.ITA Canteen.ITA.ReversionaryTrust

def family : Facts := { conditions := [(.contributorConsent, .fact true)], income := 2000000, taxableCapitalGains := 2 * 3000000 }
-- $20,000 of dividends and a $30,000 taxable gain: the parent's, not the trust's or the beneficiaries'.
example : applies family = true ∧ toContributor family family.income = 2000000 ∧ toTrust family family.income = 0 := by decide
-- The trust deed lets the property revert to the parent: (a)(i).
example : applies { family with conditions := [(.revert, .fact true)] } = true := by decide
-- No condition: the trust's income.
example : applies { family with conditions := [] } = false := by decide
-- After the parent dies, or emigrates: no longer attributed.
example : applies { family with contributorAlive := false } = false ∧ applies { family with contributorResident := false } = false := by decide
-- A TFSA trust (75(3)(a)): excluded.
example : applies { family with excluded := true } = false := by decide
-- Whether the deed gives the parent the power to determine later beneficiaries is often a judgment call.
example : (explain { family with conditions := [(.contributorDetermines, .judged "J-75" true)] }).reliesOn = ["J-75"] := by decide

end Canteen.Tests.ReversionaryTrust

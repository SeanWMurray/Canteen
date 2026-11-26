import Canteen.ITA.S50.BadDebtOrShare
import Canteen.ITA.S3.Income

/-!
# Tests: bad debts and worthless shares (50(1))

An individual lent Opco, a small business corporation, $50,000, and holds shares of it costing
$20,000. Opco fails. Constructed examples.
-/

namespace Canteen.Tests.BadDebtOrShare

open Canteen Canteen.ITA Canteen.ITA.BadDebtOrShare

def loan : Facts :=
  { description := "the loan to Opco", kind := .debt (.judged "J-BAD" true), adjustedCostBase := 5000000, businessInvestment := true,
    taxationYearEnd := ⟨2025, 12, 31⟩ }

-- The loan is deemed disposed of for nil: a $50,000 business investment loss.
example : applies.holds loan = true ∧ ((disposition loan).map (·.businessInvestmentLoss)) = some 5000000 := by decide
#guard (applies.explain loan).reliesOn == ["J-BAD"]
-- The allowable business investment loss, $25,000, is deducted against any income under 3(d).
example : Income.income { incomeFromSources := 8000000, capital := ⟨(disposition loan).toList, 0, {}⟩ } = 2 * 5500000 := by decide
-- Reacquired at nil.
example : costAfter loan = 0 := by decide
-- Not yet established as bad, or no election: nothing.
example : disposition { loan with kind := .debt (.judged "J-BAD" false) } = none := by decide
example : disposition { loan with elected := false } = none := by decide
-- From a sale of personal-use property: 50(2), not 50(1).
example : applies.holds { loan with fromPersonalUse := true } = false := by decide

-- The shares, once Opco is bankrupt.
def shares : Facts := { loan with description := "the shares of Opco", kind := .shareBankrupt, adjustedCostBase := 2000000 }
example : ((disposition shares).map (·.loss)) = some 2000000 := by decide
-- Insolvent and dormant: only if its dissolution is reasonably expected (often judged).
example : applies.holds { shares with kind := .shareDormant true (.judged "J-DISSOLVE" true) } = true := by decide
example : applies.holds { shares with kind := .shareDormant false (.judged "J-DISSOLVE" true) } = false := by decide
#guard (applies.explain { shares with kind := .shareDormant false (.judged "J-DISSOLVE" true) }).reliesOn == []

-- Never a superficial loss, even if the shares are reacquired.
example : SuperficialLoss.superficialLoss ⟨slDisposition shares, []⟩ = false := by decide

end Canteen.Tests.BadDebtOrShare

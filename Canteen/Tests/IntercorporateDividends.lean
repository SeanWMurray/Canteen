import Canteen.ITA.S55.IntercorporateDividends

/-!
# Tests: intercorporate dividends (112(1), 55(2))

Holdco owns Opco, which has $300,000 of safe income. Before Holdco sells Opco to an unrelated
buyer, Opco pays Holdco a $1,000,000 dividend to reduce the gain on the sale. Constructed examples.
-/

namespace Canteen.Tests.IntercorporateDividends

open Canteen Canteen.ITA Canteen.ITA.IntercorporateDividends

def preSale : Facts :=
  { description := "the dividend from Opco before the sale", amount := 100000000, reducesGain := .judged "J-55" true,
    safeIncome := 30000000, unrelatedEvents := [.dispositionOfPayerShares] }

-- The $700,000 over safe income is a capital gain, not a dividend; $300,000 is deducted.
example : subsection55_2.holds preSale = true := by decide
example : caught preSale = 70000000 ∧ gain preSale = 70000000 ∧ deduction preSale = 30000000 := by decide
#guard (rule.explain preSale).reliesOn == ["J-55"]
-- Within safe income: none of it.
example : caught { preSale with amount := 20000000 } = 0 ∧ deduction { preSale with amount := 20000000 } = 20000000 := by decide
-- If reducing the gain was not one of the purposes, none of it; but that rests on J-55.
example : caught { preSale with reducesGain := .judged "J-55" false } = 0 := by decide
#guard (rule.explain { preSale with reducesGain := .judged "J-55" false }).reliesOn == ["J-55"]
-- (b)(ii): a purpose to reduce a share's value, on a share held as capital property.
example : caught { preSale with reducesGain := .fact false, reducesValueOrIncreasesCost := .judged "J-COST" true } = 70000000 := by
  decide
-- (b)(ii) does not reach a redemption dividend.
example : caught { preSale with onRedemption := true, reducesGain := .fact false, reducesValueOrIncreasesCost := .fact true } = 0 := by
  decide

-- A redemption: on its own, within the related-party exception (55(3)(a)).
def redemption : Facts := { preSale with onRedemption := true, unrelatedEvents := [] }
example : caught redemption = 0 := by decide
-- With an unrelated buyer of Opco's shares in the series, caught: added to the proceeds of the redeemed shares.
example : proceedsAddition { redemption with unrelatedEvents := [.dispositionOfPayerShares] } = 70000000 ∧
    gain { redemption with unrelatedEvents := [.dispositionOfPayerShares] } = 0 := by decide
-- A butterfly (55(3)(b)).
example : caught { preSale with butterfly := true } = 0 := by decide
-- From a non-resident corporation: no 112(1) deduction, so 55(2) does not apply either.
example : caught { preSale with payer := .other } = 0 ∧ deduction { preSale with payer := .other } = 0 := by decide
-- From a resident corporation the recipient controls (112(1)(b)).
example : deduction { preSale with payer := .residentControlled, amount := 20000000 } = 20000000 := by decide

/-! ## Read-back -/

#guard ((rule.explain preSale).render.splitOn "\n" |>.drop 6) ==
  ["7. Therefore subsection 55(2) applies. [ITA 55(2)]",
   "8. So $700,000.00, the excess over safe income of $300,000.00, is deemed not to be a dividend, but a gain from the disposition of a capital property. [ITA 55(2)(a), (c)]",
   "9. The recipient deducts the remaining $300,000.00 under subsection 112(1). [ITA 112(1)]"]

end Canteen.Tests.IntercorporateDividends

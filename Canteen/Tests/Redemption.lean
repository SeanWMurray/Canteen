import Canteen.ITA.S84.Redemption

/-!
# Tests: redemptions (84(3), 54 "proceeds of disposition" (j), 55(2)(b))

Opco redeems 1,000 preferred shares with $1,000 of paid-up capital for $500,000. Constructed examples.
-/

namespace Canteen.Tests.Redemption

open Canteen Canteen.ITA Canteen.ITA.Redemption

def prefs : Facts :=
  { description := "the preferred shares of Opco", amountPaid := 50000000, paidUpCapital := 100000, sharesRedeemed := 1000,
    sharesHeld := 1000, adjustedCostBase := 100000 }

-- A $499,000 dividend; proceeds of $1,000, the paid-up capital: no gain.
example : dividend prefs = 49900000 ∧ proceeds prefs = 100000 ∧ (disposition prefs).gain = 0 := by decide
-- An individual includes $573,850 (the 15% gross-up).
example : Dividends.inclusion { taxationYear := 2025, dividends := [asDividend prefs] } = 57385000 := by decide
-- Two holders: one with 600 of the 1,000 shares receives 60% of the dividend.
example : dividend { prefs with sharesHeld := 600 } = 29940000 ∧ proceeds { prefs with sharesHeld := 600 } = 60000 := by decide
-- Paid less than paid-up capital: no dividend, and the shortfall is a capital loss.
def underwater : Facts := { prefs with amountPaid := 50000, adjustedCostBase := 100000 }
example : dividend underwater = 0 ∧ (disposition underwater).capitalLoss = 50000 := by decide
-- A non-resident corporation's redemption is not under 84(3).
example : dividend { prefs with corporationResident := false } = 0 := by decide

-- A corporate holder, Holdco, with Opco to be sold to an unrelated buyer: Opco has $100,000 of
-- safe income. 55(2) catches $399,000, which 55(2)(b) makes proceeds: a $399,000 capital gain.
def holdcoDividend : IntercorporateDividends.Facts := asIntercorporate prefs (.judged "J-55" true) 10000000 [.dispositionOfPayerShares]
example : IntercorporateDividends.caught holdcoDividend = 39900000 ∧ IntercorporateDividends.deduction holdcoDividend = 10000000 := by
  decide
example : (corporateDisposition prefs holdcoDividend).proceeds = 40000000 ∧ (corporateDisposition prefs holdcoDividend).gain = 39900000 := by
  decide
-- With no unrelated person in the series, the related-party exception: the dividend stands.
example : (corporateDisposition prefs (asIntercorporate prefs (.judged "J-55" true) 10000000)).gain = 0 := by decide

/-! ## Read-back -/

#guard (explain prefs).render.splitOn "\n" ==
  ["1. On the redemption of the preferred shares of Opco, the corporation paid $500,000.00 for shares with paid-up capital of $1,000.00, so it is deemed to pay a dividend of $499,000.00. [ITA 84(3)(a)]",
   "2. The holder held 1000 of the 1000 shares, so it is deemed to receive a dividend of $499,000.00. [ITA 84(3)(b)]",
   "3. The holder's proceeds of disposition are $1,000.00: the $500,000.00 received, less the dividend. [ITA 54 \"proceeds of disposition\" (j)]"]

end Canteen.Tests.Redemption

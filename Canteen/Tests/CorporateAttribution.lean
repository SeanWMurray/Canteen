import Canteen.ITA.S74.CorporateAttribution

/-!
# Tests: corporate attribution (74.4(2))

A parent freezes: Holdco issues preferred shares for the parent's $1,000,000 investment portfolio,
and the parent's minor children subscribe for the common shares. Holdco holds only investments,
so it is not a small business corporation. The prescribed rate is 3%. Constructed examples.
-/

namespace Canteen.Tests.CorporateAttribution

open Canteen Canteen.ITA Canteen.ITA.CorporateAttribution

def freeze : Facts :=
  { taxationYear := 2025, mainPurpose := .judged "J-74.4" true, outstanding := 100000000, prescribedRate := 300 }

-- 3% of $1,000,000: $30,000 deemed interest.
example : prescribedInterest freeze = 3000000 ∧ deemedInterest freeze = 3000000 := by decide
#guard (rule.explain freeze).reliesOn == ["J-74.4"]
-- For half the year: $15,000.
example : deemedInterest { freeze with months := 6 } = 1500000 := by decide
-- Dividends of $26,087 on the preferred shares: $30,000.05 included with the gross-up, so nothing is deemed.
def withDividends : Facts := { freeze with dividendsOnConsideration := [{ description := "preferred share dividends", amount := 2608700 }] }
example : dividendsIncluded withDividends = 3000005 ∧ deemedInterest withDividends = 0 := by decide
-- Dividends of $20,000: $23,000 included, $7,000 deemed.
example : deemedInterest { freeze with dividendsOnConsideration := [{ description := "dividends", amount := 2000000 }] } = 700000 := by
  decide
-- Interest actually paid counts too.
example : deemedInterest { freeze with interestReceived := 3000000 } = 0 := by decide
-- A small business corporation, or no main purpose to benefit the children: nothing.
example : deemedInterest { freeze with smallBusinessCorporation := .judged "J-SBC" true } = 0 := by decide
example : deemedInterest { freeze with mainPurpose := .judged "J-74.4" false } = 0 := by decide
-- The children are adults (not designated persons): nothing.
example : deemedInterest { freeze with designatedShareholder := false } = 0 := by decide

end Canteen.Tests.CorporateAttribution

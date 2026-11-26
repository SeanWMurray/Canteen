import Canteen.ITA.S89.CapitalDividendAccount

/-!
# Tests: the capital dividend account (89(1)) and capital dividends (83(2))

Holdco, a private corporation, sells shares at a $100,000 gain. Amounts in the account are in
half-cents: $50,000 is `2 * 5000000`. Constructed examples.
-/

namespace Canteen.Tests.CapitalDividendAccount

open Canteen Canteen.ITA Canteen.ITA.CapitalDividendAccount

def gainSale : CapitalGains.Disposition := { description := "shares of XYZ Ltd.", proceeds := 15000000, adjustedCostBase := 5000000 }
def holdco : Facts := { dispositions := [gainSale] }

-- The untaxed half, $50,000, goes into the account.
example : account holdco = 2 * 5000000 := by decide
-- A $50,000 dividend, elected on, is all a capital dividend; a $60,000 one exceeds the account by $10,000.
example : capitalDividend holdco 5000000 = 2 * 5000000 := by decide
example : capitalDividend holdco 6000000 = 2 * 5000000 ∧ excessElection holdco 6000000 = 2 * 1000000 := by decide
-- A $20,000 capital loss takes away its unallowed half.
def lossSale : CapitalGains.Disposition := { description := "shares of ABC Ltd.", proceeds := 0, adjustedCostBase := 2000000 }
example : account { holdco with dispositions := [gainSale, lossSale] } = 2 * 4000000 := by decide
-- A gift of listed securities to a charity: taxed at nil (38(a.1)(i)), so the whole gain goes in.
example : account { holdco with dispositions := [{ gainSale with giftToQualifiedDonee := true }] } = 2 * 10000000 := by decide
-- Life insurance proceeds, less the policy's adjusted cost basis, and capital dividends received.
example : account { holdco with lifeInsurance := 50000000, capitalDividendsReceived := 1000000 } = 2 * 56000000 := by decide
-- Capital dividends already paid come off.
example : account { holdco with capitalDividendsPaid := 3000000 } = 2 * 2000000 := by decide
-- The part of the gain that accrued while a public corporation held the property is left out.
example : account { holdco with accruedOutside := 2 * 1000000 } = 2 * 4000000 := by decide
-- An odd number of cents: the half-cent is kept.
example : account { holdco with dispositions := [{ gainSale with proceeds := 5000001 }] } = 1 := by decide
-- A public corporation cannot pay capital dividends.
example : capitalDividend { holdco with privateCorporation := false } 5000000 = 0 := by decide

/-! ## Read-back -/

#guard (explain holdco 6000000).render.splitOn "\n" ==
  ["1. The untaxed part of the corporation's capital gains, less the unallowed part of its capital losses, is $50,000.00. [ITA 89(1) \"capital dividend account\" (a)]",
   "2. With capital dividends received, life insurance proceeds and other additions, less capital dividends paid, the capital dividend account is $50,000.00. [ITA 89(1) \"capital dividend account\"]",
   "3. Of the $60,000.00 dividend elected on, $50,000.00 is a capital dividend, and $10,000.00 exceeds the account. [ITA 83(2)(a)]",
   "4. No part of it is included in computing any shareholder's income. [ITA 83(2)(b)]"]

end Canteen.Tests.CapitalDividendAccount

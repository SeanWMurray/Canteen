import Canteen.ITA.S74.IncomeAttribution

/-!
# Tests: income attribution (74.1, 74.5(2), (3)(a))

Ann gives Bob, her spouse, $100,000, which he invests at 4%: $4,000 of interest in the year.
Constructed examples.
-/

namespace Canteen.Tests.IncomeAttribution

open Canteen Canteen.ITA Canteen.ITA.IncomeAttribution

def interest : Amount := { description := "interest on the bonds", income := 400000 }
def gift : Facts := { recipient := .spouse, amounts := [interest] }

-- All of it is Ann's, and none of it Bob's.
example : attributedIncome gift = 400000 ∧ recipientIncome gift = 0 := by decide
-- Lent instead, at the prescribed rate with interest paid by January 30: nothing (74.5(2)).
example : attributedIncome { gift with loan := some { adequateRate := true, paidOnTime := true } } = 0 := by decide
-- Interest paid late, or too low: attributed.
example : attributedIncome { gift with loan := some { adequateRate := true, paidOnTime := false } } = 400000 := by decide
-- Sold to Bob for fair market value, with an election out of 73(1): nothing (74.5(1)).
example : attributedIncome { gift with transfer := { fairMarketValueConsideration := true, electedOutOf73_1 := true } } = 0 := by decide
-- Without the election, 74.5(1)(c) is not met.
example : attributedIncome { gift with transfer := { fairMarketValueConsideration := true } } = 400000 := by decide
-- Income for the months they lived apart after a breakdown is Bob's (74.5(3)(a)).
def split : Facts := { gift with amounts := [{ interest with income := 300000 }, { interest with income := 100000, separated := true }] }
example : attributedIncome split = 300000 ∧ recipientIncome split = 100000 := by decide
-- Income outside the period (say, before Ann became resident) is Bob's.
example : attributedIncome { gift with amounts := [{ interest with inPeriod := false }] } = 0 := by decide

-- A gift to Ann's 12-year-old child: dividends of $1,000 are attributed (74.1(2)).
def toChild : Facts := { recipient := .minor, amounts := [{ description := "dividends", income := 100000 }] }
example : attributedIncome toChild = 100000 := by decide
-- Not in the year the child turns 18, nor to an adult child.
example : attributedIncome { toChild with recipient := .minor true } = 0 := by decide
example : attributedIncome { toChild with recipient := .other } = 0 := by decide
-- A separation does not matter for a minor.
example : attributedIncome { toChild with amounts := [{ description := "dividends", income := 100000, separated := true }] } = 100000 := by
  decide

-- 74.1(3): Bob uses $50,000 of the gift to pay down the mortgage on a $200,000 rental property
-- earning $10,000: a quarter of the rent is income from the gift.
def paydown : Facts := { gift with amounts := [], repayment := some { usedValue := 5000000, otherCost := 20000000, otherIncome := 1000000 } }
example : attributedIncome paydown = 250000 := by decide
-- A rental loss is shared the same way.
example : attributedLoss { paydown with repayment := some { usedValue := 5000000, otherCost := 20000000, otherLoss := 400000 } } = 100000 := by
  decide

/-! ## Read-back -/

#guard (rule.explain gift).render.splitOn "\n" ==
  ["1. The property was transferred or lent to the individual's spouse or common-law partner, or to a minor not at arm's length with the individual or a niece or nephew. [ITA 74.1(1), (2) recipient]",
   "2. The recipient is not a minor who attained 18 before the end of the year. [ITA 74.1(1), (2) turned 18]",
   "3. The property was not transferred on the terms of 74.5(1). [ITA 74.5(1)]",
   "4. The property was not lent at an adequate rate with interest paid on time. [ITA 74.5(2)]",
   "5. Therefore subsection 74.1(1) or (2) applies. [ITA 74.1(1), (2)]",
   "6. So $4,000.00 of income from the property (or property substituted for it) in the period is the individual's, and not the recipient's. [ITA 74.1(1)]"]

end Canteen.Tests.IncomeAttribution

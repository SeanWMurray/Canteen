import Canteen.ITA.S212.Withholding
import Canteen.ITA.S18.ThinCapitalization

/-!
# Tests: Part XIII on dividends and interest (212(1)(b), 212(2))

Constructed examples. Treaty rates are given, not looked up.
-/

namespace Canteen.Tests.Withholding

open Canteen Canteen.ITA Canteen.ITA.Withholding

-- A $100,000 dividend to a non-resident individual: 25%, or 15% under a treaty.
def dividend : Payment := { description := "a dividend to a shareholder in France", kind := .dividend, amount := 10000000 }
example : dividend.tax = 2500000 ∧ ({ dividend with treatyRate := some 15 } : Payment).tax = 1500000 := by decide
-- A treaty rate above 25% does not raise the tax.
example : ({ dividend with treatyRate := some 30 } : Payment).tax = 2500000 := by decide
-- Interest on a bank loan from an arm's length non-resident lender: none.
example : ({ description := "interest to a foreign bank", kind := .interest, amount := 5000000 } : Payment).tax = 0 := by decide
-- Interest to the foreign parent (not at arm's length): 25%, or nil at a 0% treaty rate.
def toParent : Payment := { description := "interest to the parent", kind := .interest, amount := 5000000, nonArmsLength := true }
example : toParent.tax = 1250000 ∧ ({ toParent with treatyRate := some 0 } : Payment).tax = 0 := by decide
-- Interest computed by reference to profit, to an arm's length lender: participating, 25%.
example : ({ description := "profit-linked interest", kind := .interest, amount := 5000000, participating := true } : Payment).tax = 1250000 := by decide
-- Interest on a Government of Canada bond held by a related non-resident: fully exempt.
example : ({ toParent with fullyExempt := true } : Payment).tax = 0 := by decide

-- 212(1)(a): a $40,000 management fee to the foreign parent: 25%, $10,000.
def fee : Payment := { description := "the head office management fee", kind := .managementFee, amount := 4000000, nonArmsLength := true }
example : fee.tax = 1000000 := by decide
-- $15,000 of it reimburses specific travel costs for work done for Canco (212(4)(b)): $25,000 taxed.
example : ({ fee with reimbursement := true, reasonable := some 1500000 } : Payment).tax = 625000 := by decide
-- Consulting fees to an arm's length foreign firm, in the ordinary course of its business (212(4)(a)): none.
example : ({ fee with nonArmsLength := false, ordinaryCourse := true } : Payment).tax = 0 := by decide
-- The same from the parent: not at arm's length, so (a) does not apply.
example : ({ fee with ordinaryCourse := true } : Payment).tax = 1000000 := by decide
-- An arm's length firm charging $40,000 where $30,000 is reasonable: the $10,000 excess is taxed.
example : ({ fee with nonArmsLength := false, ordinaryCourse := true, reasonable := some 3000000 } : Payment).tax = 250000 := by decide

-- With thin capitalization: Canco's $300,000 of interest to its parent, $120,000 of it denied and deemed a
-- dividend (5% treaty rate), the $180,000 rest interest (0% treaty rate): $6,000 in all.
def canco : ThinCapitalization.Facts := { interest := 30000000, retainedEarnings := 100000000, months := List.replicate 12 { maxDebt := 500000000, paidUpCapital := 100000000 }, dividendRate := 5 }
def payments : List Payment :=
  [{ description := "the interest denied, deemed a dividend", kind := .dividend, amount := ThinCapitalization.deemedDividend canco, treatyRate := some 5 },
   { description := "the rest of the interest", kind := .interest, amount := ThinCapitalization.deductible canco, nonArmsLength := true, treatyRate := some 0 }]
example : tax payments = 600000 := by decide

end Canteen.Tests.Withholding

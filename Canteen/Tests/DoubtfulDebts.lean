import Canteen.ITA.S20.DoubtfulDebts

/-!
# Tests: doubtful and bad debts (20(1)(l), (p); 12(1)(d), (i))

Constructed examples.
-/

namespace Canteen.Tests.DoubtfulDebts

open Canteen Canteen.ITA Canteen.ITA.DoubtfulDebts

-- Year 1: a $10,000 invoice to a customer in difficulty, 40% reserved; a $3,000 invoice written off.
def acme : Receivable := { description := "Acme's invoice", amount := 1000000, reserve := 400000 }
def bolt : Receivable := { description := "Bolt's invoice", amount := 300000, bad := .fact true }
def year1 : Facts := { receivables := [acme, bolt] }
example : reserve year1 = 400000 ∧ badDebts year1 = 300000 ∧ net year1 = 700000 := by decide
-- Year 2: the reserve comes back into income; Acme goes bankrupt, written off in full; $1,000 of Bolt's recovered.
def year2 : Facts := { receivables := [{ acme with reserve := 0, bad := .fact true }], priorReserve := reserve year1, recoveries := 100000 }
example : inclusions year2 = 500000 ∧ deductions year2 = 1000000 ∧ net year2 = 500000 := by decide
-- Over the two years, the $13,000 of bad debts, less the $1,000 recovered.
example : net year1 + net year2 = 1200000 := by decide
-- A reserve over the debt is limited to it.
example : reserve { receivables := [{ acme with reserve := 2000000 }] } = 1000000 := by decide
-- A loan to a supplier, never included in income: no reserve, no 20(1)(p) deduction.
example : deductions { receivables := [{ description := "a loan to a supplier", amount := 500000, includedInIncome := false, bad := .fact true }] } = 0 := by decide
-- Whether a debt is bad is often a judgment call.
example : (explain { receivables := [{ bolt with bad := .judged "J-BAD" true }] }).reliesOn = ["J-BAD"] := by decide

end Canteen.Tests.DoubtfulDebts

import Canteen.ITA.S55.IntercorporateDividends
import Canteen.ITA.S89.CapitalDividendAccount
import Canteen.ITA.S38.CapitalGains
import Canteen.Core.Branch

/-!
# Layer 3: selling Opco through Holdco, with dividends first

A constructed transaction under 83(2), 89(1), 112(1), 55(2) and the capital gains computation.

* Holdco owns all the shares of Opco (adjusted cost base $100), worth $3,000,000. Opco has $200,000
  in its capital dividend account and $300,000 of safe income on its shares.
* 2025-09-01: Opco pays Holdco a $200,000 capital dividend (elected under 83(2)), then a
  $1,000,000 taxable dividend, to reduce the gain on the sale.
* 2025-09-15: Holdco sells the Opco shares, now worth $1,800,000, to an unrelated buyer.
* 2025-12-01: Holdco elects to pay its individual shareholder a capital dividend of its whole
  capital dividend account.
* Judgment call `J-55`: is one of the purposes of the $1,000,000 dividend to effect a significant
  reduction in the capital gain on the Opco shares?
-/

namespace Canteen.Transactions.SaleThroughHoldco

open Canteen Canteen.ITA

/-! ## Facts -/

def calls : List JudgmentCall :=
  [{ id := "J-55", question := "Is one of the purposes of Opco's $1,000,000 dividend to effect a significant reduction in the capital gain on the Opco shares?",
     riskIfYes := .low, riskIfNo := .high }]

def position : List Judgment := [(calls.head!).assume true]

/-- Opco's capital dividend account before it pays. -/
def opcoAccount : CapitalDividendAccount.Facts := { lifeInsurance := 20000000 }

/-- The $1,000,000 taxable dividend, for 112(1) and 55(2). -/
def taxableDividend (branch : List Judgment) : IntercorporateDividends.Facts :=
  { description := "Opco's $1,000,000 dividend", amount := 100000000, reducesGain := Answer.ofBranch "J-55" branch,
    safeIncome := 30000000, unrelatedEvents := [.dispositionOfPayerShares] }

/-- The sale of the Opco shares. -/
def sale : CapitalGains.Disposition := { description := "the Opco shares", proceeds := 180000000, adjustedCostBase := 10000 }

/-- 55(2)(c): the part of the dividend deemed a gain from the disposition of a capital property. -/
def deemedGain (branch : List Judgment) : CapitalGains.Disposition :=
  { description := "the gain deemed by 55(2)(c)", proceeds := IntercorporateDividends.gain (taxableDividend branch), adjustedCostBase := 0 }

/-- Holdco's capital dividend account after the sale. -/
def holdcoAccount (branch : List Judgment) : CapitalDividendAccount.Facts :=
  { dispositions := [sale, deemedGain branch],
    capitalDividendsReceived := CapitalDividendAccount.capitalDividend opcoAccount 20000000 / 2 }

/-- Holdco's 2025 capital gains. -/
def holdcoYear (branch : List Judgment) : CapitalGains.Year := ⟨[sale, deemedGain branch], 0, {}⟩

/-! ## Analysis -/

/-- Opco's $200,000 dividend is all a capital dividend (83(2)(a)): Holdco includes none of it. -/
theorem capital_dividend : CapitalDividendAccount.capitalDividend opcoAccount 20000000 = 2 * 20000000 := by decide

/-- On the position taken, 55(2) applies to the $700,000 over safe income: a capital gain to Holdco.
Holdco deducts the other $300,000 under 112(1). -/
theorem dividend_recharacterized :
    IntercorporateDividends.subsection55_2.holds (taxableDividend position) = true ∧
    IntercorporateDividends.gain (taxableDividend position) = 70000000 ∧
    IntercorporateDividends.deduction (taxableDividend position) = 30000000 := by decide

/-- The sale: a $1,799,900 capital gain. -/
theorem sale_gain : sale.gain = 179990000 := by decide

/-- Holdco's taxable capital gains: half of $2,499,900. -/
theorem holdco_taxable : (holdcoYear position).paragraph3b = 249990000 := by decide

/-- Holdco's capital dividend account: the untaxed half of both gains, $1,249,950, plus the
$200,000 capital dividend received: $1,449,950. -/
theorem holdco_account : CapitalDividendAccount.account (holdcoAccount position) = 2 * 144995000 := by decide

/-- Holdco can pay its shareholder all $1,449,950 as a capital dividend, tax-free. -/
theorem holdco_capital_dividend :
    CapitalDividendAccount.capitalDividend (holdcoAccount position) 144995000 = 2 * 144995000 ∧
    CapitalDividendAccount.excessElection (holdcoAccount position) 144995000 = 0 := by decide

/-- If reducing the gain were not one of the purposes, the whole $1,000,000 would be deducted under
112(1), and Holdco's capital dividend account would be $350,000 smaller. -/
theorem without_55_2 :
    IntercorporateDividends.deduction (taxableDividend [(calls.head!).assume false]) = 100000000 ∧
    CapitalDividendAccount.account (holdcoAccount [(calls.head!).assume false]) = 2 * 109995000 := by decide

/-- The answer matters: the explanation rests on J-55 either way. -/
theorem relies_on_purpose :
    (IntercorporateDividends.rule.explain (taxableDividend position)).reliesOn = ["J-55"] ∧
    (IntercorporateDividends.rule.explain (taxableDividend [(calls.head!).assume false])).reliesOn = ["J-55"] := by decide

end Canteen.Transactions.SaleThroughHoldco

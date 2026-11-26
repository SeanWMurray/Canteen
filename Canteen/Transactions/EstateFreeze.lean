import Canteen.ITA.S86.ShareExchange
import Canteen.ITA.S74.CorporateAttribution
import Canteen.Core.Branch

/-!
# Layer 3: an estate freeze in favour of minor children

A constructed transaction under section 86 and subsection 74.4(2).

* A parent owns all the common shares of Opco: cost and paid-up capital $100, worth $2,000,000.
* 2025-01-15: in a reorganization of Opco's capital, the parent exchanges them for preferred shares
  redeemable for $2,000,000 (with a price adjustment clause, so worth that), and the parent's minor
  children subscribe $10 for new common shares. Future growth accrues to the children.
* The prescribed rate is 3%.
* Judgment call `J-SBC`: is Opco a small business corporation (all or substantially all of its
  assets' value in an active business carried on in Canada) throughout 2025?

One of the main purposes of a freeze in favour of minor children is taken to be to benefit them,
so 74.4(2) turns on whether Opco is a small business corporation.
-/

namespace Canteen.Transactions.EstateFreeze

open Canteen Canteen.ITA

def calls : List JudgmentCall :=
  [{ id := "J-SBC", question := "Is all or substantially all of the fair market value of Opco's assets attributable to assets used principally in an active business carried on primarily in Canada, throughout 2025?",
     riskIfYes := .low, riskIfNo := .high }]

def position : List Judgment := [(calls.head!).assume true]

def prefs : TransferToCorporation.ShareClass := { name := "freeze preferred shares", fairMarketValue := 200000000, paidUpCapitalIncrease := 10000 }

/-- The exchange, under 86(1). -/
def exchange : ShareExchange.Facts :=
  { description := "the common shares of Opco", adjustedCostBase := 10000, paidUpCapital := 10000, fairMarketValue := 200000000,
    newShares := [prefs] }

/-- 2025, under 74.4(2): the exchange is a transfer of the common shares to Opco. -/
def attribution (branch : List Judgment) (prefDividends : Cents := 0) : CorporateAttribution.Facts :=
  { taxationYear := 2025, mainPurpose := .fact true, smallBusinessCorporation := Answer.ofBranch "J-SBC" branch,
    outstanding := 200000000, prescribedRate := 300,
    dividendsOnConsideration := if prefDividends = 0 then [] else [{ description := "preferred share dividends", amount := prefDividends }] }

/-! ## Analysis -/

/-- 86(1): no gain; the preferred shares take over the $100 cost and $100 of paid-up capital. -/
theorem freeze_no_gain :
    ShareExchange.applies.holds exchange = true ∧ (ShareExchange.disposition exchange).gain = 0 ∧
    ShareExchange.newCost exchange prefs = 10000 ∧ ShareExchange.paidUpCapital exchange prefs = 10000 := by decide

/-- 86(2) does not apply: the preferred shares are worth what the common shares were. -/
theorem no_benefit : ShareExchange.excess exchange = 0 := by decide

/-- On the position that Opco is a small business corporation, 74.4(2) deems nothing. -/
theorem no_attribution : CorporateAttribution.deemedInterest (attribution position) = 0 := by decide

/-- If it is not, the parent is deemed to receive $60,000 of interest a year (3% of $2,000,000)... -/
theorem attribution_if_not_sbc : CorporateAttribution.deemedInterest (attribution [(calls.head!).assume false]) = 6000000 := by decide

/-- ...unless Opco pays the parent dividends on the preferred shares of at least $52,174 a year
($60,000.10 included with the gross-up). -/
theorem dividends_avoid_it : CorporateAttribution.deemedInterest (attribution [(calls.head!).assume false] 5217400) = 0 := by decide

/-- The answer matters, and the explanation says so. -/
theorem relies_on_sbc :
    (CorporateAttribution.rule.explain (attribution position)).reliesOn = ["J-SBC"] := by decide

end Canteen.Transactions.EstateFreeze

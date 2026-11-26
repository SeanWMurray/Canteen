import Canteen.ITA.S87.Amalgamation

/-!
# Tests: amalgamations (87(1), (2)(e), (4))

Aco and Bco amalgamate to form Newco. A shareholder of Aco (cost $40,000, worth $100,000)
receives Newco common and preferred shares. Constructed examples.
-/

namespace Canteen.Tests.Amalgamation87

open Canteen Canteen.ITA Canteen.ITA.Amalgamation87

def merger : Merger := {}
def common (v : Cents) : TransferToCorporation.ShareClass := { name := "Newco common shares", fairMarketValue := v }
def prefs (v : Cents) : TransferToCorporation.ShareClass := { name := "Newco preferred shares", fairMarketValue := v }

def holder : Shareholder :=
  { merger, adjustedCostBase := 4000000, fairMarketValue := 10000000, newShares := [common 6000000, prefs 4000000] }

example : amalgamation.holds merger = true := by decide
-- No gain or loss; the $40,000 cost is shared by value: $24,000 and $16,000.
example : holder.disposition.gain = 0 ∧ holder.newCost (common 6000000) = 2400000 ∧ holder.newCost (prefs 4000000) = 1600000 := by
  decide
-- 87(2)(e): Newco's cost of Aco's land is Aco's adjusted cost base.
example : newCorporationCost merger 30000000 90000000 = 30000000 := by decide
-- A purchase of the assets is not an amalgamation, and 87(4) does not apply: the old shares go at value.
example : amalgamation.holds { merger with notPurchaseOrWindingUp := false } = false := by decide
example : ({ holder with merger := { merger with notPurchaseOrWindingUp := false } } : Shareholder).disposition.gain = 6000000 := by
  decide
-- Cash as well as shares: 87(4) does not apply.
example : ({ holder with onlyNewShares := false } : Shareholder).proceeds = 10000000 := by decide

-- New shares worth only $70,000, the $30,000 a benefit to the shareholder's children: the proceeds are
-- $70,000 ($40,000 plus $30,000), a $30,000 gain; the new shares cost $40,000.
def gifting : Shareholder := { holder with newShares := [common 7000000], benefit := .judged "J-87-4" true }
example : gifting.gift = 3000000 ∧ gifting.proceeds = 7000000 ∧ gifting.disposition.gain = 3000000 ∧ gifting.newCostTotal = 4000000 := by
  decide
-- With a $120,000 cost (a loss position), the loss is nil, and the new shares cost their $70,000 value plus the loss denied.
def lossGift : Shareholder := { gifting with adjustedCostBase := 12000000 }
example : lossGift.proceeds = 10000000 ∧ lossGift.disposition.capitalLoss = 0 ∧ lossGift.newCostTotal = 9000000 := by decide

end Canteen.Tests.Amalgamation87

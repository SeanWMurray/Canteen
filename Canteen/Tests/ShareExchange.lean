import Canteen.ITA.S86.ShareExchange

/-!
# Tests: share exchanges in a reorganization of capital (86(1) to (3))

An estate freeze: a parent exchanges common shares of Opco (cost and paid-up capital $100, worth
$1,000,000) for fixed-value preferred shares, and the children then subscribe for new common
shares. Constructed examples.
-/

namespace Canteen.Tests.ShareExchange

open Canteen Canteen.ITA Canteen.ITA.ShareExchange

def prefs (v : Cents) : TransferToCorporation.ShareClass :=
  { name := "preferred shares", fairMarketValue := v, paidUpCapitalIncrease := 10000 }

def freeze : Facts :=
  { description := "the common shares of Opco", adjustedCostBase := 10000, paidUpCapital := 10000, fairMarketValue := 100000000,
    newShares := [prefs 100000000] }

-- No gain; the preferred shares take over the $100 cost and $100 of paid-up capital.
example : applies.holds freeze = true ∧ proceeds freeze = 10000 ∧ (disposition freeze).gain = 0 := by decide
example : newCost freeze (prefs 100000000) = 10000 ∧ paidUpCapital freeze (prefs 100000000) = 10000 := by decide

-- A $250,000 note as well: boot over the cost is a gain (and an 84(3) dividend issue, not here).
def withNote : Facts := { freeze with boot := [{ description := "a note", fairMarketValue := 25000000 }], newShares := [prefs 75000000] }
example : proceeds withNote = 25000000 ∧ (disposition withNote).gain = 24990000 ∧ newCost withNote (prefs 75000000) = 0 := by decide

-- The preferred shares are worth only $600,000 (no price adjustment clause); the $400,000 benefits
-- the children, who are related. 86(2): proceeds of $400,000, a $399,900 gain, and the preferred
-- shares cost nothing.
def underpriced : Facts := { freeze with newShares := [prefs 60000000], benefit := .judged "J-86-2" true }
example : excess underpriced = 40000000 ∧ proceeds underpriced = 40000000 ∧ (disposition underpriced).gain = 39990000 := by decide
example : newCost underpriced (prefs 60000000) = 0 := by decide
#guard (rule.explain underpriced).reliesOn == ["J-86-2"]
-- If it is not a benefit the taxpayer desired to confer, 86(1) alone: no gain, still resting on the call.
example : (disposition { underpriced with benefit := .judged "J-86-2" false }).gain = 0 := by decide
-- 86(2)(d): a loss is nil. Old shares with a $1,500,000 cost, worth $1,000,000, exchanged for preferred shares worth $600,000.
def lossy : Facts := { underpriced with adjustedCostBase := 150000000 }
example : (disposition lossy).capitalLoss = 0 := by decide
-- Without 86(2), the same exchange has no loss either: proceeds equal cost.
example : (disposition { lossy with benefit := .fact false }).capitalLoss = 0 := by decide

-- 86(2.1): stated capital of $1,000,000 on the preferred shares is ground to the old $100.
def stepUp : Facts := { freeze with newShares := [{ prefs 100000000 with paidUpCapitalIncrease := 100000000 }] }
example : paidUpCapital stepUp { prefs 100000000 with paidUpCapitalIncrease := 100000000 } = 10000 := by decide

-- 86(3): not where 85(1) applies.
example : applies.holds { freeze with section85Applies := true } = false := by decide
-- Not without a reorganization of capital, or without new shares.
example : applies.holds { freeze with reorganization := false } = false := by decide
example : applies.holds { freeze with newShares := [] } = false := by decide

/-! ## Read-back -/

#guard ((rule.explain freeze).render.splitOn "\n" |>.drop 4) ==
  ["5. Therefore subsection 86(1) applies. [ITA 86(1)]",
   "6. The new shares cost the old shares' adjusted cost base of $100.00 less the boot of $0.00: $100.00. [ITA 86(1)(a), (b)]",
   "7. So the proceeds for the old shares are $100.00. [ITA 86(1)(c)]"]

end Canteen.Tests.ShareExchange

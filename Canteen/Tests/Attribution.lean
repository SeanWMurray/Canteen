import Canteen.ITA.S74.Attribution
import Canteen.ITA.S73.SpousalRollover
import Canteen.ITA.S3.Income

/-!
# Tests: attribution of capital gains to the transferor (74.2(1), 74.5)

Ann gives Bob, her spouse, shares worth $300,000 with a $50,000 adjusted cost base. The 73(1)
rollover gives Bob a $50,000 cost. Bob later sells them for $350,000.
-/

namespace Canteen.Tests.Attribution

open Canteen Canteen.ITA Canteen.ITA.Attribution CapitalGains

def gift : SpousalRollover.Facts :=
  { transfer := { description := "shares of ABC Ltd.", price := 0, fairMarketValue := 30000000,
                  armsLength := .fact false, gift := true },
    transferee := .spouse, adjustedCostBase := 5000000 }

-- Bob's cost, by 73(1)(b).
example : SpousalRollover.transfereeCost gift = 5000000 := by decide

def bobsSale : RecipientDisposition :=
  { disposition := { description := "Bob's sale of the shares", proceeds := 35000000,
                     adjustedCostBase := SpousalRollover.transfereeCost gift } }

def giftTransfer : Transfer := {}

-- The $300,000 gain, a $150,000 taxable capital gain, is Ann's.
example : (toIndividual giftTransfer [bobsSale]).taxableCapitalGains = 2 * 15000000 := by decide
example : Income.paraB { capital := { dispositions := [], attribution := toIndividual giftTransfer [bobsSale] } } = 2 * 15000000 := by
  decide
-- And not Bob's (74.2(1)(e)).
example : Income.paraB { capital := recipientYear giftTransfer [bobsSale] } = 0 := by decide
-- A loss on other transferred property nets against it.
def bobsLossSale : RecipientDisposition :=
  { disposition := { description := "Bob's sale of other gifted shares", proceeds := 1000000, adjustedCostBase := 5000000 } }
example : (toIndividual giftTransfer [bobsSale, bobsLossSale]).taxableCapitalGains = 2 * 13000000 := by decide
-- A net loss is Ann's allowable capital loss.
example : (toIndividual giftTransfer [bobsLossSale]).allowableCapitalLosses = 2 * 2000000 := by decide
-- Listed personal property is attributed as gains and losses, into Ann's section 41 pool.
def bobsPainting : RecipientDisposition :=
  { disposition := { description := "a painting", proceeds := 500000, adjustedCostBase := 100000, propertyClass := .listedPersonal } }
example : (toIndividual giftTransfer [bobsPainting]).lppGains = 400000 := by decide

/-! ## 74.5(1): a sale for fair market value -/

def fairSale : Transfer :=
  { fairMarketValueConsideration := true, indebtedness := some ⟨true, true⟩, electedOutOf73_1 := true }
example : (toIndividual fairSale [bobsSale]) = {} := by decide
-- Each condition matters: no election out of 73(1), interest too low, or less than fair market value.
example : (toIndividual { fairSale with electedOutOf73_1 := false } [bobsSale]).taxableCapitalGains = 2 * 15000000 := by decide
example : (toIndividual { fairSale with indebtedness := some ⟨false, true⟩ } [bobsSale]).taxableCapitalGains = 2 * 15000000 := by
  decide
example : (toIndividual { fairSale with fairMarketValueConsideration := false } [bobsSale]).taxableCapitalGains = 2 * 15000000 := by
  decide

/-! ## The attribution period, and 74.5(3)(b) -/

-- After divorce, or after Ann ceases to be resident, nothing is attributed.
example : (toIndividual giftTransfer [{ bobsSale with inAttributionPeriod := false }]) = {} := by decide
-- Separated, with a joint election: nothing is attributed.
example : (toIndividual giftTransfer [{ bobsSale with separatedWithJointElection := true }]) = {} := by decide
-- Not a spouse: 74.2 does not apply.
example : (toIndividual { toSpouse := false } [bobsSale]) = {} := by decide

end Canteen.Tests.Attribution

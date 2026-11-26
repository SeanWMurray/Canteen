import Canteen.ITA.S69.NonArmsLength
import Canteen.ITA.S251.RelatedPersons
import Canteen.ITA.S3.Income

/-!
# Tests: subsection 69(1)

Ann (0) sells to her child Kid (1) and to a friend, Fay (2). Arm's length is decided by section 251.
-/

namespace Canteen.Tests.NonArmsLength

open Canteen Canteen.ITA Canteen.ITA.AffiliatedPersons Canteen.ITA.NonArmsLength

def family : World :=
  { persons := [⟨0, "Ann", .individual⟩, ⟨1, "Kid", .individual⟩, ⟨2, "Fay", .individual⟩], children := [(0, 1)] }

def armsLengthWith (buyer : Nat) : Answer :=
  RelatedPersons.armsLengthAnswer { world := family, first := 0, second := buyer, questionOfFact := .judged "J-ARM" true }

/-- Cottage shares worth $300,000, sold for `price`. -/
def toKid (price : Cents) : Transfer :=
  { description := "shares of Cottage Co.", price, fairMarketValue := 30000000, armsLength := armsLengthWith 1 }
def toFay (price : Cents) : Transfer :=
  { description := "shares of Cottage Co.", price, fairMarketValue := 30000000, armsLength := armsLengthWith 2 }

-- Ann and Kid are related, so not at arm's length, on the facts alone.
example : armsLengthWith 1 = .fact false := by decide +kernel
-- Ann and Fay are not related: arm's length is a question of fact.
example : armsLengthWith 2 = .judged "J-ARM" true := by decide +kernel

-- Sold to Kid for $100,000: Ann is deemed to receive $300,000; Kid's cost is $100,000.
example : sellerProceeds (toKid 10000000) = 30000000 ∧ buyerCost (toKid 10000000) = 10000000 := by decide +kernel
-- Sold to Fay for $100,000, at arm's length: the price stands.
example : sellerProceeds (toFay 10000000) = 10000000 := by decide +kernel
-- Sold to Kid for $400,000: Ann's proceeds are $400,000; Kid's cost is cut to $300,000 (69(1)(a)).
example : sellerProceeds (toKid 40000000) = 40000000 ∧ buyerCost (toKid 40000000) = 30000000 := by decide +kernel
-- A gift, to anyone: $300,000 on both sides.
example : sellerProceeds { toFay 0 with gift := true } = 30000000 ∧ buyerCost { toFay 0 with gift := true } = 30000000 := by
  decide +kernel
-- A transfer to a bare trust, with no change in beneficial ownership: fair market value.
example : sellerProceeds { toFay 0 with noChangeInBeneficialOwnership := true } = 30000000 := by decide +kernel

-- The asymmetry, in the year's income: Ann's adjusted cost base was $50,000. Selling to Kid for
-- $100,000, she is taxed on a $250,000 gain; when Kid later sells for $300,000, Kid is taxed on
-- $200,000 more. $450,000 of gain is taxed, on $250,000 of growth.
example : Income.paraB { capital := ⟨[sellerDisposition (toKid 10000000) 5000000], 0⟩ } = 2 * 12500000 := by decide +kernel
def kidsLaterSale : CapitalGains.Disposition :=
  { description := "Kid's later sale", proceeds := 30000000, adjustedCostBase := buyerCost (toKid 10000000) }
example : Income.paraB { capital := ⟨[kidsLaterSale], 0⟩ } = 2 * 10000000 := by decide +kernel

-- The explanation relies on the arm's length judgment call only where it matters.
#guard (sellerAtFairMarketValue.explain (toFay 10000000)).reliesOn == ["J-ARM"]
#guard (sellerAtFairMarketValue.explain (toKid 10000000)).reliesOn == []
#guard (sellerAtFairMarketValue.explain { toFay 0 with gift := true }).reliesOn == []

end Canteen.Tests.NonArmsLength

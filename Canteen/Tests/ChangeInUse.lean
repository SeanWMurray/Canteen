import Canteen.ITA.S45.ChangeInUse
import Canteen.ITA.S40.PrincipalResidence
import Canteen.ITA.S3.Income

/-!
# Tests: change in use (45(1) to (4))

A house bought for $400,000 is lived in, then rented out when it is worth $600,000, then sold for
$700,000. Constructed examples.
-/

namespace Canteen.Tests.ChangeInUse

open Canteen Canteen.ITA Canteen.ITA.ChangeInUse

def renting : Facts :=
  { description := "the house", otherBefore := 100, otherAfter := 0, fairMarketValue := 60000000, adjustedCostBase := 40000000 }

-- 45(1)(a)(i): a deemed disposition of the whole at fair market value.
example : change renting = some .aI := by decide
example : deemedDisposition.holds renting = true := by decide
example : proceeds renting = 60000000 ∧ portionCost renting = 40000000 ∧ costAfter renting = 60000000 := by decide
-- The $200,000 gain on the deemed disposition, then $100,000 on the sale: $300,000 in all.
example : ((disposition renting).map (·.gain)) = some 20000000 := by decide
example : (CapitalGains.Disposition.gain { description := "sale", proceeds := 70000000, adjustedCostBase := costAfter renting }) = 10000000 := by
  decide

-- 45(2): with the election, no disposition; the cost stays $400,000.
def electing : Facts := { renting with elected45_2 := true }
example : deemedDisposition.holds electing = false ∧ disposition electing = none ∧ costAfter electing = 40000000 := by decide
-- The election covers the years from the change until it is rescinded, for the principal
-- residence definition's paragraph (b)(i).
example : covers45_2 { electedYear := 2016, rescindedYear := some 2021 } 2020 = true := by decide
example : covers45_2 { electedYear := 2016, rescindedYear := some 2021 } 2021 = false := by decide
example : covers45_2 { electedYear := 2016 } 2015 = false := by decide

-- 45(1)(c)(ii): renting out the basement, 30% of the house; the 45(2) election reaches (c)(ii) too.
def basement : Facts := { renting with otherAfter := 70 }
example : change basement = some .cII := by decide
example : proceeds basement = 18000000 ∧ portionCost basement = 12000000 ∧ costAfter basement = 46000000 := by decide
example : deemedDisposition.holds { basement with elected45_2 := true } = false := by decide

-- 45(1)(a)(ii) and 45(3): moving into a former rental; the election stops the disposition, unless
-- capital cost allowance was claimed (45(4)).
def movingIn : Facts :=
  { renting with otherBefore := 0, otherAfter := 100, becomesPrincipalResidence := true, elected45_3 := true }
example : change movingIn = some .aII := by decide
example : deemedDisposition.holds movingIn = false := by decide
example : deemedDisposition.holds { movingIn with capitalCostAllowanceClaimed := true } = true := by decide
example : deemedDisposition.holds { movingIn with becomesPrincipalResidence := false } = true := by decide
-- 45(2) does not reach a change away from income; 45(3) does not reach a change toward it.
example : deemedDisposition.holds { movingIn with elected45_3 := false, elected45_2 := true } = true := by decide
example : deemedDisposition.holds { renting with becomesPrincipalResidence := true, elected45_3 := true } = true := by decide
-- 45(1)(c)(i): taking back half of a rental duplex.
example : change { movingIn with otherAfter := 50, elected45_3 := false } = some .cI := by decide
-- 45(3) covers the years before the change, for (b)(ii).
example : covers45_3 2024 2020 = true ∧ covers45_3 2024 2024 = false := by decide

-- No change in the relation: nothing.
example : disposition { renting with otherAfter := 100 } = none := by decide

-- A loss on a personal-use part moving to income use is nil (40(2)(g)(iii)).
def cottage : Facts := { renting with fairMarketValue := 30000000, personalUse := true }
example : ((disposition { cottage with personalUse := false }).map (·.capitalLoss)) = some 10000000 := by decide
example : ((disposition cottage).map (·.capitalLoss)) = some 0 := by decide

-- Into the year's income: the deemed gain is half taxable.
example : Income.paraB { capital := ⟨(disposition renting).toList, 0, {}⟩ } = 2 * 10000000 := by decide

-- Never a superficial loss.
example : SuperficialLoss.superficialLoss ⟨slDisposition cottage ⟨2025, 6, 1⟩, []⟩ = false := by decide

/-! ## Read-back -/

#guard (rule.explain basement).render.splitOn "\n" ==
  ["1. The use regularly made of the property changed between gaining or producing income and other purposes. [ITA 45(1)(a), (c)]",
   "2. The taxpayer does not elect under subsection 45(2) for a change toward gaining or producing income. [ITA 45(2)(a), (b)]",
   "3. No effective election under subsection 45(3) covers a change from gaining or producing income to the taxpayer's principal residence. [ITA 45(3), (4)]",
   "4. Therefore subsection 45(1) applies. [ITA 45(1)]",
   "5. So the taxpayer is deemed to have disposed of 30 of 100 parts of the house for $180,000.00 (that proportion of its fair market value of $600,000.00), with a cost of $120,000.00, and to have reacquired it at that amount: the property's cost is now $460,000.00. [ITA 45(1)(c)(ii)]"]
#guard (rule.explain movingIn).render.splitOn "\n" ==
  ["1. The property ceased to be used for gaining or producing income and became the taxpayer's principal residence, and the taxpayer elects under subsection 45(3), with no capital cost allowance claimed after 1984 (45(4)). [ITA 45(3), (4)]",
   "2. Therefore subsection 45(1) does not apply. [ITA 45(1)]",
   "3. So there is no deemed disposition, and the cost of the house stays $400,000.00. [ITA 45(1)(a)(ii)]"]

end Canteen.Tests.ChangeInUse

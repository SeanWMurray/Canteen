import Canteen.ITA.S73.SpousalRollover

/-!
# Tests: the spousal rollover (73(1), (1.01)), with 69(1)
-/

namespace Canteen.Tests.SpousalRollover

open Canteen Canteen.ITA Canteen.ITA.SpousalRollover

/-- A gift of shares worth $300,000, with an adjusted cost base of $50,000. Gifts to family are not
at arm's length. -/
def gift : NonArmsLength.Transfer :=
  { description := "shares of Cottage Co.", price := 0, fairMarketValue := 30000000, armsLength := .fact false, gift := true }

def toSpouse : Facts := { transfer := gift, transferee := .spouse, adjustedCostBase := 5000000 }

-- The rollover: proceeds and the spouse's cost are $50,000, so no gain.
example : proceeds toSpouse = 5000000 ∧ transfereeCost toSpouse = 5000000 := by decide
example : (disposition toSpouse).gain = 0 := by decide
-- Each kind of transferee in 73(1.01).
example : [Transferee.spouse, .formerSpouseInSettlement, .spousalTrust, .alterEgoTrust, .jointTrust].all
    (fun t => rollover.holds { toSpouse with transferee := t }) = true := by decide
-- Electing out: 69(1) puts both sides at $300,000, and the gain is $250,000.
example : proceeds { toSpouse with electedOut := true } = 30000000 ∧ transfereeCost { toSpouse with electedOut := true } = 30000000 := by
  decide
example : (disposition { toSpouse with electedOut := true }).gain = 25000000 := by decide
-- To a child: no rollover; 69(1) applies.
example : proceeds { toSpouse with transferee := .other } = 30000000 := by decide
-- A non-resident spouse: no rollover.
example : proceeds { toSpouse with bothResident := false } = 30000000 := by decide
-- From a trust: no rollover.
example : rollover.holds { toSpouse with individual := false } = false := by decide
-- Depreciable property of a prescribed class: proceeds are the class share of UCC.
example : proceeds { toSpouse with prescribedClassShare := some 4000000 } = 4000000 := by decide

#guard (rollover.explain toSpouse).render ==
  "1. The property is capital property of an individual who is not a trust. [ITA 73(1) capital property of an individual]\n" ++
  "2. It was transferred to the individual's spouse or common-law partner, a former one in settlement of rights arising out of the relationship, or a qualifying spousal, alter ego or joint trust. [ITA 73(1.01)]\n" ++
  "3. Both the individual and the transferee are resident in Canada at the time. [ITA 73(1) resident]\n" ++
  "4. The individual does not elect out of subsection 73(1). [ITA 73(1) election]\n" ++
  "5. Therefore subsection 73(1) applies. [ITA 73(1)]"

end Canteen.Tests.SpousalRollover

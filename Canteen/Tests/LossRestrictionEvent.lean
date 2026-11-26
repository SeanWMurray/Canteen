import Canteen.ITA.S251_2.LossRestrictionEvent
import Canteen.ITA.S54.SuperficialLoss

/-!
# Tests: loss restriction events (251.2(2)(a), 256(7)(a))

Ann (0) controls Opco (10). Bob (1) is her spouse, Kid (2) her child, Fay (3) a stranger, and
Holdco (11) is controlled by Ann. Constructed examples, checked by the kernel.
-/

namespace Canteen.Tests.LossRestrictionEvent

open Canteen Canteen.ITA Canteen.ITA.AffiliatedPersons Canteen.ITA.LossRestrictionEvent

def ind (i : Nat) (n : String) : Person := ⟨i, n, .individual⟩
def corp (i : Nat) (n : String) : Person := ⟨i, n, .corporation⟩

def people : List Person := [ind 0 "Ann", ind 1 "Bob", ind 2 "Kid", ind 3 "Fay", corp 10 "Opco", corp 11 "Holdco"]
def world (opco : List Control) : World :=
  { persons := people, spouses := [(0, 1)], children := [(0, 2)], controls := opco ++ [{ corporation := 11, controller := .person 0 }] }

def byAnn : World := world [{ corporation := 10, controller := .person 0 }]
def by_ (c : Controller) : World := world [{ corporation := 10, controller := c }]

def lre (after : World) (e : Event) (before : World := byAnn) : Bool :=
  lossRestrictionEvent.holds { corporation := 10, before, after, event := e }

-- A sale of control to a stranger.
example : lre (by_ (.person 3)) (.purchase 3 0) = true := by decide +kernel
-- To her child: (i)(A), bought from a related person.
example : lre (by_ (.person 2)) (.purchase 2 0) = false := by decide +kernel
-- To her holding company: related to Ann, and to Opco (both controlled by her).
example : lre (by_ (.person 11)) (.purchase 11 0) = false := by decide +kernel
example : acquirerRelated { corporation := 10, before := byAnn, after := by_ (.person 11), event := .purchase 11 0 } = true := by
  decide +kernel
-- Fay buys from Ann's estate: not related to the deceased.
example : lre (by_ (.person 3)) (.fromEstate 3 false) = true := by decide +kernel
example : lre (by_ (.person 2)) (.fromEstate 2 true) = false := by decide +kernel
example : lre (by_ (.person 1)) .toEstate = false := by decide +kernel

-- Redemptions (ii): Ann's shares redeemed, leaving Fay in control, is an event; leaving Bob
-- (related to Opco through Ann) is not.
example : lre (by_ (.person 3)) .redemption = true := by decide +kernel
example : lre (by_ (.person 1)) .redemption = false := by decide +kernel

-- (iii): Bob and Kid, a related group each related to Opco, take control.
def groupFacts : Facts := { corporation := 10, before := byAnn, after := by_ (.group [1, 2]), event := .purchase 2 3 }
example : relatedGroup groupFacts = true := by decide +kernel
example : lossRestrictionEvent.holds groupFacts = false := by decide +kernel
-- From a stranger's control, they are not related to Opco: an event.
example : lre (by_ (.group [1, 2])) (.purchase 2 3) (by_ (.person 3)) = true := by decide +kernel

-- No change in control, or de facto control only: no event.
example : lre byAnn (.purchase 3 0) = false := by decide +kernel
example : lre (world [{ corporation := 10, controller := .person 0 }, { corporation := 10, controller := .person 3, deFactoOnly := true }])
    (.purchase 3 0) = false := by decide +kernel
-- Not a corporation.
example : lossRestrictionEvent.holds { corporation := 0, before := byAnn, after := byAnn, event := .redemption } = false := by
  decide +kernel

-- Whether Fay controls after may be a judgment call; then it is relied on.
def judgedAfter : World := world [{ corporation := 10, controller := .person 3, answer := .judged "J-CONTROL" true }]
#guard (lossRestrictionEvent.explain { corporation := 10, before := byAnn, after := judgedAfter, event := .purchase 3 0 }).reliesOn == ["J-CONTROL"]

/-! ## Into the superficial loss definition (f) -/

def stranger : Facts := { corporation := 10, before := byAnn, after := by_ (.person 3), event := .purchase 3 0 }
-- Opco sells shares at a loss on 2025-06-01; control is acquired on 2025-06-20, within 30 days after.
def opcoSale : SuperficialLoss.Disposition :=
  { description := "shares of XYZ Ltd.", date := ⟨2025, 6, 1⟩, proceeds := 100000, adjustedCostBase := 200000, outlaysAndExpenses := 0, lossRestrictionEvent := eventDate stranger ⟨2025, 6, 20⟩ }
example : SuperficialLoss.paraF opcoSale = true := by decide +kernel
example : SuperficialLoss.paraF { opcoSale with lossRestrictionEvent := eventDate stranger ⟨2025, 8, 1⟩ } = false := by decide +kernel

/-! ## Read-back -/

#guard ((lossRestrictionEvent.explain stranger).render.splitOn "\n" |>.take 3) ==
  ["1. The taxpayer is a corporation. [ITA 251.2(2)(a) corporation]",
   "2. Control of the corporation is acquired by a person or group of persons: one controls it immediately after who did not immediately before. [ITA 251.2(2)(a) control acquired]",
   "3. The acquirer did not acquire the shares from a person to whom it was related. [ITA 256(7)(a)(i)(A)]"]

end Canteen.Tests.LossRestrictionEvent

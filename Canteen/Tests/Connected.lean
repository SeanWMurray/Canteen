import Canteen.ITA.S186.Connected
import Canteen.ITA.S84_1.SurplusStripping

/-!
# Tests: connected corporations (186(2), (4))

Ann (0) controls Holdco (10). Kid (1) is Ann's child; Fay (2) is a stranger. Is Opco (11) connected
with Holdco? Constructed examples, checked by the kernel.
-/

namespace Canteen.Tests.Connected

open Canteen Canteen.ITA Canteen.ITA.AffiliatedPersons Canteen.ITA.Connected

def world : World :=
  { persons := [⟨0, "Ann", .individual⟩, ⟨1, "Kid", .individual⟩, ⟨2, "Fay", .individual⟩, ⟨10, "Holdco", .corporation⟩,
                ⟨11, "Opco", .corporation⟩],
    children := [(0, 1)], controls := [{ corporation := 10, controller := .person 0 }] }

def facts (hs : List Holding) (nal : List Nat := []) : Facts := { world, payer := 11, particular := 10, holdings := hs, nonArmsLength := nal }
def c? (hs : List Holding) (nal : List Nat := []) : Bool := connected.holds (facts hs nal)

-- Wholly owned.
example : c? [⟨10, 100, 100000⟩] = true := by decide +kernel
-- (b): more than 10% of the votes and of the value.
example : c? [⟨10, 15, 15000⟩, ⟨2, 85, 85000⟩] = true := by decide +kernel
-- 15% of the votes but only 5% of the value: not (b).
example : c? [⟨10, 15, 5000⟩, ⟨2, 85, 95000⟩] = false := by decide +kernel
-- Exactly 10%: not "more than".
example : c? [⟨10, 10, 10000⟩, ⟨2, 90, 90000⟩] = false := by decide +kernel
-- 186(2), by 186(7): Holdco holds 5%, and Ann and Kid (related to Holdco through Ann) 46%: 51%, controlled.
example : c? [⟨10, 5, 5000⟩, ⟨0, 26, 26000⟩, ⟨1, 20, 20000⟩, ⟨2, 49, 49000⟩] = true := by decide +kernel
-- With Fay instead, unrelated: not, unless Holdco and Fay in fact do not deal at arm's length.
example : c? [⟨10, 5, 5000⟩, ⟨2, 60, 60000⟩, ⟨1, 35, 35000⟩] = false := by decide +kernel
example : c? [⟨10, 5, 5000⟩, ⟨2, 60, 60000⟩, ⟨1, 35, 35000⟩] [2] = true := by decide +kernel
-- De jure control given in the world.
example : connected.holds { facts [] with world := { world with controls := world.controls ++ [{ corporation := 11, controller := .person 10 }] } } = true := by
  decide +kernel

-- Into 84.1: Ann sells her Opco shares to Holdco, which then holds all of them.
def strip : SurplusStripping.Facts :=
  { description := "the Opco shares", subjectPaidUpCapital := 10000, adjustedCostBase := 10000, boot := 10000000,
    proceedsOtherwise := 10000000, connected := c? [⟨10, 100, 100000⟩] }
example : SurplusStripping.dividend strip = 9990000 := by decide +kernel

end Canteen.Tests.Connected

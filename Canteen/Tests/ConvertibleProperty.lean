import Canteen.ITA.S51.ConvertibleProperty

/-!
# Tests: convertible property (51(1), (2), (4))

A shareholder converts class A shares of Opco (cost $50,000, worth $200,000) into class B shares.
Constructed examples.
-/

namespace Canteen.Tests.ConvertibleProperty

open Canteen Canteen.ITA Canteen.ITA.ConvertibleProperty

def classB (v : Cents) : TransferToCorporation.ShareClass := { name := "class B shares", fairMarketValue := v }
def conversion : Facts :=
  { description := "the class A shares of Opco", adjustedCostBase := 5000000, fairMarketValue := 20000000, newShares := [classB 20000000] }

-- Not a disposition; the class B shares cost $50,000.
example : disposition conversion = none ∧ cost conversion (classB 20000000) = 5000000 := by decide
-- A convertible debenture converted into shares: the same.
example : disposition { conversion with description := "the convertible debenture" } = none := by decide
-- Cash as well: not 51(1), a disposition at value.
example : ((disposition { conversion with onlyShares := false }).map (·.gain)) = some 15000000 := by decide
-- 51(4): not where section 86 applies.
example : applies { conversion with otherRollover := true } = false := by decide
-- Class B shares worth only $150,000, the $50,000 a benefit to related persons: proceeds of $100,000, a $50,000 gain.
def gifting : Facts := { conversion with newShares := [classB 15000000], benefit := .judged "J-51-2" true }
example : gift gifting = 5000000 ∧ ((disposition gifting).map (·.gain)) = some 5000000 ∧ costTotal gifting = 5000000 := by decide

end Canteen.Tests.ConvertibleProperty

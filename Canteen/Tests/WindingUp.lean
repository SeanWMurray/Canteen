import Canteen.ITA.S88.WindingUp

/-!
# Tests: winding up a subsidiary into its parent (88(1))

Parent buys all the shares of Target for $10,000,000 and winds it up. Target has land (cost
$1,000,000, worth $6,000,000 when Parent acquired control), equipment (cost amount $2,000,000),
$500,000 of cash and $500,000 of debts. Constructed examples.
-/

namespace Canteen.Tests.WindingUp

open Canteen Canteen.ITA Canteen.ITA.WindingUp

def land : Property :=
  { description := "the land", costAmount := 100000000, eligible := true, valueAtControl := 600000000,
    costAmountAtControl := 100000000, designated := 500000000 }
def equipment : Property := { description := "the equipment", costAmount := 200000000 }

def target : Facts :=
  { properties := [land, equipment], money := 50000000, liabilities := 50000000, adjustedCostBase := 1000000000,
    paidUpCapital := 10000 }

-- Net tax cost $3,000,000; room for $7,000,000 of bump.
example : netTaxCost target = 300000000 ∧ bumpRoom target = 700000000 := by decide
-- The land is bumped by $5,000,000 to $6,000,000; the equipment (depreciable, ineligible) is not.
example : bumpOf target = [500000000, 0] ∧ parentCosts target = [600000000, 200000000] := by decide
-- Parent's shares: proceeds of $10,000,000, their cost: no gain or loss. Target: none either.
example : (parentDisposition target).gain = 0 ∧ (parentDisposition target).loss = 0 := by decide
example : (subsidiaryDispositions target).map (·.gain) = [0, 0] := by decide
-- Designating more than the land's (d)(ii) limit ($6,000,000 less $1,000,000) does not help.
example : bumpOf { target with properties := [{ land with designated := 700000000 }, equipment] } = [500000000, 0] := by decide
-- Dividends Parent received on the shares reduce the room: $3,000,000 of them leave $4,000,000.
example : bumpOf { target with dividendsReceived := 300000000 } = [400000000, 0] := by decide
-- Two eligible properties share the room, in the order designated.
def shares : Property :=
  { description := "shares of Subco", costAmount := 0, eligible := true, valueAtControl := 400000000, designated := 400000000 }
example : bumpOf { target with properties := [land, equipment, shares] } = [500000000, 0, 200000000] := by decide
-- Paid-up capital above cost: the parent's proceeds are the lesser of paid-up capital and net tax cost.
example : shareProceeds { target with adjustedCostBase := 100000000, paidUpCapital := 500000000 } = 300000000 := by decide
-- Only 85% owned: 88(1) does not apply, and there is no bump.
example : applies.holds { target with ninetyPercent := false } = false ∧ bumpOf { target with ninetyPercent := false } = [0, 0] := by
  decide

end Canteen.Tests.WindingUp

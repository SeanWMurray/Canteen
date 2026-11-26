import Canteen.ITA.S70.Death
import Canteen.ITA.S3.Income
import Canteen.Lemmas.SuperficialLoss

/-!
# Tests: death, 70(5) and (6)

An estate: shares for the spouse, a cottage for a child, and shares at a loss.
-/

namespace Canteen.Tests.Death

open Canteen Canteen.ITA Canteen.ITA.Death

def shares : Property :=
  { description := "shares of ABC Ltd.", fairMarketValue := 50000000, adjustedCostBase := 20000000, recipient := .spouse true }
def cottage : Property :=
  { description := "the cottage", fairMarketValue := 80000000, adjustedCostBase := 30000000, recipient := .other "a child" }
def loser : Property :=
  { description := "shares of XYZ Ltd.", fairMarketValue := 1000000, adjustedCostBase := 6000000, recipient := .spouse true }

def q (p : Property) : Query := ⟨true, p⟩

-- To the spouse: rolled over at cost. To the child: at fair market value.
example : proceeds (q shares) = 20000000 ∧ recipientCost (q shares) = 20000000 := by decide
example : proceeds (q cottage) = 80000000 ∧ recipientCost (q cottage) = 80000000 := by decide
-- A qualifying spousal trust also rolls over; a non-resident spouse does not.
example : proceeds (q { shares with recipient := .spousalTrust true }) = 20000000 := by decide
example : proceeds (q { shares with recipient := .spouse false }) = 50000000 := by decide
-- Not vested within 36 months, or the deceased not resident: no rollover.
example : proceeds (q { shares with vestedWithin36Months := false }) = 50000000 := by decide
example : proceeds ⟨false, shares⟩ = 50000000 := by decide
-- 70(6.2): electing out for the loser realizes its $50,000 loss.
example : (disposition (q { loser with electedOut := true })).loss = 5000000 := by decide
example : (disposition (q loser)).loss = 0 := by decide

-- The terminal year: the cottage's $500,000 gain is a $250,000 taxable capital gain; electing out
-- on the loser brings a $25,000 allowable capital loss against it.
def terminal (electOut : Bool) : Income.Facts :=
  { incomeFromSources := 4000000,
    capital := ⟨terminalDispositions true [shares, cottage, { loser with electedOut := electOut }], 0⟩ }
example : Income.paraB (terminal false) = 2 * 25000000 := by decide
example : Income.paraB (terminal true) = 2 * 22500000 := by decide
example : Income.income (terminal true) = 2 * (4000000 + 22500000) := by decide

-- A deemed disposition on death is never a superficial loss (paragraph (c) of that definition).
example : SuperficialLoss.superficialLoss ⟨slDisposition (q { loser with electedOut := true }) ⟨2025, 6, 1⟩, []⟩ = false := by
  decide
example (as : List SuperficialLoss.Acquisition) :
    SuperficialLoss.superficialLoss ⟨slDisposition (q { loser with electedOut := true }) ⟨2025, 6, 1⟩, as⟩ = false :=
  SuperficialLoss.not_of_death _ rfl

#guard (rule.explain (q cottage)).render ==
  "1. The property did not pass to a resident spouse or common-law partner or a qualifying resident spousal trust. [ITA 70(6)(a), (b)]\n" ++
  "2. Therefore subsection 70(6) does not apply. [ITA 70(6)]\n" ++
  "3. So the cottage is deemed disposed of immediately before death for its fair market value, $800,000.00, and acquired at that cost. [ITA 70(5)(a), (b)]"

end Canteen.Tests.Death

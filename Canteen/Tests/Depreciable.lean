import Canteen.ITA.S13.Depreciable
import Canteen.ITA.S85.TransferToCorporation

/-!
# Tests: depreciable property (13(21), 13(1), 20(16))

Equipment bought for $10,000, with $3,600 of capital cost allowance claimed over the years, is sold.
Constructed examples.
-/

namespace Canteen.Tests.Depreciable

open Canteen Canteen.ITA Canteen.ITA.Depreciable Canteen.ITA.Depreciable.ClassFacts

def sold (p : Cents) (left : Bool := false) : ClassFacts :=
  { name := "Class 8", acquisitions := [1000000], depreciation := 360000,
    dispositions := [{ description := "the equipment", proceeds := p, capitalCost := 1000000 }], ownsPropertyAtYearEnd := left }

-- Sold for $5,000, the last property of the class: a $1,400 terminal loss.
example : (sold 500000).ucc = 140000 ∧ (sold 500000).terminalLoss = 140000 ∧ (sold 500000).recapture = 0 := by decide
-- If other property of the class is left, the $1,400 stays in the pool.
example : (sold 500000 true).terminalLoss = 0 ∧ (sold 500000 true).ucc = 140000 := by decide
-- Sold for $8,000: $1,600 of recapture.
example : (sold 800000).recapture = 160000 ∧ (sold 800000).ucc = 0 := by decide
-- Sold for $12,000: F is capped at the $10,000 capital cost, so all $3,600 is recaptured, and $2,000 is a capital gain.
example : (sold 1200000).recapture = 360000 := by decide
example : (capitalGainsDisposition { description := "the equipment", proceeds := 1200000, capitalCost := 1000000 }).gain = 200000 := by
  decide
-- No capital loss on depreciable property (39(1)(b)(i)): the $5,000 shortfall is the terminal loss instead.
example : (capitalGainsDisposition { description := "the equipment", proceeds := 500000, capitalCost := 1000000 }).capitalLoss = 0 := by
  decide
-- Outlays reduce F.
def withOutlays : Disposition := { description := "the equipment", proceeds := 800000, outlaysAndExpenses := 50000, capitalCost := 1000000 }
example : ({ sold 800000 with dispositions := [withOutlays] } : ClassFacts).recapture = 110000 := by decide
-- Earlier recapture (B) restores the pool.
example : ({ sold 800000 with priorRecapture := 160000, ownsPropertyAtYearEnd := true } : ClassFacts).ucc = 0 := by decide
-- No capital cost allowance in a year with a terminal loss (20(16)(d)).
example : (sold 500000).ccaAllowed = false ∧ (sold 500000 true).ccaAllowed = true := by decide

-- The class's undepreciated capital cost is the 85(1)(e) floor on a transfer to a corporation.
def unsold : ClassFacts := { name := "Class 10", acquisitions := [2000000], depreciation := 900000 }
def truck : TransferToCorporation.Facts :=
  { description := "the truck", kind := .depreciable unsold.ucc, fairMarketValue := 1500000, costAmount := 2000000, agreed := 0, preferred := [{ name := "preferred shares", fairMarketValue := 1500000 }] }
example : TransferToCorporation.electedAmount truck = 1100000 := by decide

/-! ## Read-back -/

#guard (rule.explain (sold 800000)).render.splitOn "\n" ==
  ["1. Class 8: A to D.1 total $10,000.00 (capital cost of property acquired $10,000.00). [ITA 13(21) \"undepreciated capital cost\"]",
   "2. E to K total $11,600.00 (capital cost allowance $3,600.00; for dispositions, the lesser of net proceeds and capital cost, $8,000.00). [ITA 13(21) \"undepreciated capital cost\"]",
   "3. E to K exceed A to D.1 by $1,600.00, which is included in income as recapture. [ITA 13(1)]"]

end Canteen.Tests.Depreciable

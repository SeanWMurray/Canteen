import Canteen.ITA.S112.StopLoss

/-!
# Tests: the stop-loss on shares (112(3), (3.01), (6.1))

Shares that cost $100,000, sold for $40,000: a $60,000 loss before 112(3). Constructed examples.
-/

namespace Canteen.Tests.StopLoss

open Canteen Canteen.ITA Canteen.ITA.StopLoss

def sale : CapitalGains.Disposition := { description := "shares of Opco", proceeds := 4000000, adjustedCostBase := 10000000 }

def capitalDiv : Dividend := { amount := 3000000, kind := .capital }

-- An individual who received $30,000 of capital dividends: the loss falls to $30,000.
def individual : Facts := { individual := true, dividends := [capitalDiv] }
example : reduction individual sale.loss = 3000000 ∧ (apply individual sale).loss = 3000000 := by decide
-- With $40,000 of taxable dividends too: only down to the loss less them, $20,000.
example : reduction { individual with dividends := [capitalDiv, { amount := 4000000, kind := .taxable }] } sale.loss = 2000000 := by decide
-- Taxable dividends alone do not reduce an individual's loss.
example : reduction { individual with dividends := [{ amount := 4000000, kind := .taxable }] } sale.loss = 0 := by decide
-- A small holding owned for 365 days: the capital dividends are excluded (112(3.01)).
example : reduction { individual := true, dividends := [{ capitalDiv with smallHolding := true }], held365 := true } sale.loss = 0 := by decide
-- Not owned for 365 days: they count.
example : reduction { individual := true, dividends := [{ capitalDiv with smallHolding := true }] } sale.loss = 3000000 := by decide

-- A corporation: $50,000 of taxable dividends deducted under 112, and $10,000 of capital dividends: the whole loss.
def corporation : Facts := { individual := false, dividends := [{ amount := 5000000, kind := .taxable 5000000 }, { amount := 1000000, kind := .capital }] }
example : reduction corporation sale.loss = 6000000 ∧ (apply corporation sale).loss = 0 := by decide
-- Only the deducted part of a taxable dividend counts.
example : reduction { corporation with dividends := [{ amount := 5000000, kind := .taxable 2000000 }] } sale.loss = 2000000 := by decide
-- A redemption dividend from a public company is not qualified (112(6.1)): it counts even for a small holding held 365 days.
example : reduction { individual := false, held365 := true,
    dividends := [{ amount := 5000000, kind := .taxable 5000000, onRedemption := true, smallHolding := true }] } sale.loss = 5000000 := by decide
-- Between private corporations, it is qualified, and excluded.
example : reduction { individual := false, held365 := true,
    dividends := [{ amount := 5000000, kind := .taxable 5000000, onRedemption := true, privateToPrivate := true, smallHolding := true }] }
    sale.loss = 0 := by decide
-- A gain is untouched.
example : (apply corporation { sale with proceeds := 12000000 }).gain = 2000000 := by decide

end Canteen.Tests.StopLoss

import Canteen.ITA.S85.TransferToCorporation

/-!
# Subsections 51(1), (2) and (4): convertible property

*Income Tax Act*, as consolidated to 2026-10-29 (verbatim in `statute/ITA-51-1-2-4.txt`):

**51(1)** Where a share of a corporation is acquired by a taxpayer from the corporation in exchange
for (a) another share of the corporation, or (b) a bond, debenture or note of the corporation whose
terms confer the right to make the exchange, each capital property of the taxpayer (a "convertible
property"), and no consideration other than the share is received, (c) the exchange is deemed not to
be a disposition of the convertible property, and (d) the shares of each class acquired cost
A × B / C: the convertible property's adjusted cost base, times their value over the value of all
the shares acquired.

**51(2)** Where the convertible property was worth more than the shares and part of the excess (the
gift portion) is a benefit the taxpayer desired to confer on a related person, (d) the taxpayer is
deemed to have disposed of it for the lesser of its adjusted cost base plus the gift portion and its
value, (e) any capital loss is nil, and (f) the shares cost the lesser of the adjusted cost base and
their value plus the loss denied, shared by value.

**51(4)** Neither applies to an exchange to which 85(1), 85(2) or section 86 applies.

Whether the exchange meets 51(1) is a fact; whether part of an excess is a benefit to a related
person is a fact or a judgment call. Proportions are rounded down to the cent. Not encoded: 51(1)(d.1),
(d.2), (e), (f), and 51(3).
-/

namespace Canteen.ITA.ConvertibleProperty

open TransferToCorporation (ShareClass)

structure Facts where
  /-- The convertible property, e.g. `"the class A shares of Opco"`. -/
  description : String
  /-- (a), (b): capital property that is a share of the corporation, or its convertible debt. -/
  convertible : Bool := true
  /-- Only shares of the corporation are received for it. -/
  onlyShares : Bool := true
  /-- 51(4): 85(1), 85(2) or section 86 applies. -/
  otherRollover : Bool := false
  adjustedCostBase : Cents
  fairMarketValue : Cents
  newShares : List ShareClass
  benefit : Answer := .fact false
  deriving Repr, Inhabited

def applies (f : Facts) : Bool := f.convertible && f.onlyShares && !f.otherRollover

def newTotal (f : Facts) : Cents := (f.newShares.map (·.fairMarketValue)).sum

/-- 51(2): the gift portion, where the benefit test is met. -/
def gift (f : Facts) : Cents := if applies f && f.benefit.value then f.fairMarketValue - newTotal f else 0

/-- 51(1)(c), 51(2)(d): the disposition, if any. None where 51(1) applies with no gift portion. -/
def disposition (f : Facts) : Option CapitalGains.Disposition :=
  if !applies f then
    some { description := f.description, proceeds := f.fairMarketValue, adjustedCostBase := f.adjustedCostBase }
  else if gift f > 0 then
    some { description := f.description, proceeds := min (f.adjustedCostBase + gift f) f.fairMarketValue,
           adjustedCostBase := f.adjustedCostBase, lossNil := true }
  else none

/-- 51(1)(d), 51(2)(f): the total cost of the shares acquired. -/
def costTotal (f : Facts) : Cents :=
  if !applies f then newTotal f
  else if gift f > 0 then min f.adjustedCostBase (newTotal f + (f.adjustedCostBase - min (f.adjustedCostBase + gift f) f.fairMarketValue))
  else f.adjustedCostBase

/-- The cost of the shares of one class, by value. -/
def cost (f : Facts) (c : ShareClass) : Cents := if newTotal f = 0 then 0 else costTotal f * c.fairMarketValue / newTotal f

/-! ## Truths about convertible property -/

/-- **No disposition.** A conversion with no gift portion is not a disposition, and the new shares
take over the cost. -/
theorem no_disposition (f : Facts) (ha : applies f = true) (h : f.benefit.value = false) :
    disposition f = none ∧ costTotal f = f.adjustedCostBase := by
  have hg : gift f = 0 := by simp [gift, h]
  simp [disposition, costTotal, ha, hg]

/-- 51(4): never with 85(1), 85(2) or 86. -/
theorem not_with_rollover (f : Facts) (h : f.otherRollover = true) : applies f = false := by
  simp [applies, h]

end Canteen.ITA.ConvertibleProperty

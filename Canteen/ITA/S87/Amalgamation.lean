import Canteen.ITA.S85.TransferToCorporation

/-!
# Section 87: amalgamations

*Income Tax Act*, as consolidated to 2026-10-29 (verbatim in `statute/ITA-87-1-2-4.txt`):

**87(1)** An amalgamation is a merger of two or more taxable Canadian corporations (the predecessor
corporations) to form one corporate entity (the new corporation) such that (a) all their property
(except amounts receivable from, or shares of, another predecessor) becomes the new corporation's,
(b) all their liabilities (except amounts payable to another predecessor) become its liabilities,
and (c) all their shareholders (except a predecessor) receive shares of it, otherwise than by a
purchase or a winding-up.

**87(2)(a)** The new corporation is deemed a new corporation, its first year beginning at the
amalgamation, and each predecessor's year ends immediately before it. **(e)** Capital property
(other than depreciable property or a partnership interest) acquired from a predecessor costs the new
corporation its adjusted cost base to the predecessor.

**87(4)** A shareholder (other than a predecessor) whose old shares were capital property and who
receives only new shares is deemed (a) to have disposed of them for their adjusted cost base, and
(b) to have acquired the new shares of each class at that amount, shared by value; except that where
the old shares were worth more than the new and part of the excess is a benefit the shareholder
desired to confer on a related person (the gift portion), (c) the proceeds are the lesser of the
adjusted cost base plus the gift portion and the old shares' value, (d) any capital loss is nil, and
(e) the new shares' cost is the lesser of the adjusted cost base and the new shares' value plus the
loss denied, shared by value.

Whether a merger meets 87(1)(a) to (c) is a fact. Proportions are rounded down to the cent. Not
encoded: the rest of 87(2) (depreciable property, reserves, inventory and the many continuity
rules), 87(1.1) to (3), and 87(4.1) onward.
-/

namespace Canteen.ITA.Amalgamation87

open TransferToCorporation (ShareClass)

/-- 87(1): the conditions for an amalgamation. -/
structure Merger where
  /-- Each predecessor was a taxable Canadian corporation immediately before. -/
  allTaxableCanadian : Bool := true
  /-- (a) all the predecessors' property (with the exceptions) becomes the new corporation's. -/
  allProperty : Bool := true
  /-- (b) all their liabilities (with the exceptions) become its liabilities. -/
  allLiabilities : Bool := true
  /-- (c) all their shareholders (except predecessors) receive shares of it. -/
  allShareholdersGetShares : Bool := true
  /-- Not by a purchase of property or a distribution on a winding-up. -/
  notPurchaseOrWindingUp : Bool := true
  deriving Repr, DecidableEq, Inhabited

/-- Subsection 87(1). -/
statute amalgamation (m : Merger) named "subsection 87(1)" cites "ITA 87(1)"
  applies where
    | "predecessors" m.allTaxableCanadian
        => "Each merging corporation was a taxable Canadian corporation immediately before the merger."
        else "A merging corporation was not a taxable Canadian corporation immediately before the merger."
    | (a) m.allProperty
        => "All of the predecessors' property (other than intercompany receivables and shares) becomes the new corporation's."
        else "Not all of the predecessors' property becomes the new corporation's."
    | (b) m.allLiabilities
        => "All of their liabilities (other than intercompany payables) become the new corporation's."
        else "Not all of their liabilities become the new corporation's."
    | (c) m.allShareholdersGetShares
        => "All of their shareholders (other than predecessors) receive shares of the new corporation."
        else "Not all of their shareholders receive shares of the new corporation."
    | "not a purchase or winding-up" m.notPurchaseOrWindingUp
        => "The property is not acquired by a purchase or on a winding-up."
        else "The property is acquired by a purchase or on a winding-up."

/-- 87(2)(e): the new corporation's cost of a non-depreciable capital property: its adjusted cost
base to the predecessor. -/
def newCorporationCost (m : Merger) (predecessorAdjustedCostBase costOtherwise : Cents) : Cents :=
  if amalgamation.holds m then predecessorAdjustedCostBase else costOtherwise

/-- A shareholder's old shares, for 87(4). -/
structure Shareholder where
  merger : Merger
  /-- The old shares are capital property, and only new shares are received for them. -/
  onlyNewShares : Bool := true
  adjustedCostBase : Cents
  /-- The old shares' value immediately before. -/
  fairMarketValue : Cents
  newShares : List ShareClass
  /-- Part of the excess of value is a benefit the shareholder desired to confer on a related person. -/
  benefit : Answer := .fact false
  deriving Repr, Inhabited

def Shareholder.applies (s : Shareholder) : Bool := amalgamation.holds s.merger && s.onlyNewShares

def Shareholder.newTotal (s : Shareholder) : Cents := (s.newShares.map (·.fairMarketValue)).sum

/-- The gift portion: the excess of the old shares' value over the new, where it is a benefit. -/
def Shareholder.gift (s : Shareholder) : Cents := if s.benefit.value then s.fairMarketValue - s.newTotal else 0

/-- 87(4)(a), (c): the proceeds for the old shares (at fair market value where 87(4) does not apply). -/
def Shareholder.proceeds (s : Shareholder) : Cents :=
  if !s.applies then s.fairMarketValue else
  if s.gift > 0 then min (s.adjustedCostBase + s.gift) s.fairMarketValue else s.adjustedCostBase

/-- 87(4)(b), (e): the total cost of the new shares. -/
def Shareholder.newCostTotal (s : Shareholder) : Cents :=
  if !s.applies then s.newTotal else
  if s.gift > 0 then min s.adjustedCostBase (s.newTotal + (s.adjustedCostBase - s.proceeds)) else s.adjustedCostBase

/-- The cost of one class of the new shares, by value. -/
def Shareholder.newCost (s : Shareholder) (c : ShareClass) : Cents :=
  if s.newTotal = 0 then 0 else s.newCostTotal * c.fairMarketValue / s.newTotal

/-- The shareholder's disposition of the old shares (87(4)(d): any capital loss is nil where a gift
portion is conferred). -/
def Shareholder.disposition (s : Shareholder) : CapitalGains.Disposition :=
  { description := "the old shares", proceeds := s.proceeds, adjustedCostBase := s.adjustedCostBase,
    lossNil := s.applies && s.gift > 0 }

/-! ## Truths about amalgamations -/

/-- **The rollover.** With no benefit conferred, the shareholder has no gain or loss, and the new
shares take over the old shares' cost. -/
theorem shareholder_rollover (s : Shareholder) (ha : s.applies = true) (h : s.benefit.value = false) :
    s.disposition.gain = 0 ∧ s.disposition.loss = 0 ∧ s.newCostTotal = s.adjustedCostBase := by
  have hg : s.gift = 0 := by simp [Shareholder.gift, h]
  simp [Shareholder.disposition, Shareholder.proceeds, Shareholder.newCostTotal, ha, hg, CapitalGains.Disposition.gain,
    CapitalGains.Disposition.loss, CapitalGains.Disposition.excess, CapitalGains.Disposition.reserveLimit]

/-- A gift portion never produces a capital loss. -/
theorem no_loss_on_gift (s : Shareholder) (ha : s.applies = true) (h : 0 < s.gift) : s.disposition.capitalLoss = 0 := by
  simp [Shareholder.disposition, ha, h, CapitalGains.Disposition.capitalLoss, CapitalGains.Disposition.loss]

end Canteen.ITA.Amalgamation87

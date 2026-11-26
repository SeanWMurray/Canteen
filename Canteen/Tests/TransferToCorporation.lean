import Canteen.ITA.S85.TransferToCorporation
import Canteen.ITA.S3.Income

/-!
# Tests: transfer of property to a corporation (85(1), (2.1))

An individual transfers shares of Opco (adjusted cost base $200,000, worth $1,000,000) to Holdco
for a $150,000 note and preferred shares worth $850,000, electing at $200,000. Constructed examples.
-/

namespace Canteen.Tests.TransferToCorporation

open Canteen Canteen.ITA Canteen.ITA.TransferToCorporation

def note : Boot := { description := "the note", fairMarketValue := 15000000 }
def prefs : ShareClass := { name := "preferred shares", fairMarketValue := 85000000, paidUpCapitalIncrease := 85000000 }

def opco : Facts :=
  { description := "shares of Opco", fairMarketValue := 100000000, costAmount := 20000000, agreed := 20000000,
    boot := [note], preferred := [prefs] }

example : rollover.holds opco = true := by decide
-- The elected amount is the agreed $200,000: no gain.
example : electedAmount opco = 20000000 ∧ (disposition opco).gain = 0 := by decide
-- The note costs $150,000 (f); the preferred shares $50,000 (g).
example : bootCost opco note = 15000000 ∧ preferredCost opco prefs = 5000000 := by decide
-- 85(2.1): their paid-up capital is ground from $850,000 to $50,000.
example : pucReduction opco prefs = 80000000 ∧ paidUpCapital opco prefs = 5000000 := by decide

-- (b): a $300,000 note raises the elected amount to $300,000, and a $100,000 gain.
def bigNote : Facts := { opco with boot := [{ note with fairMarketValue := 30000000 }], preferred := [{ prefs with fairMarketValue := 70000000, paidUpCapitalIncrease := 70000000 }] }
example : electedAmount bigNote = 30000000 ∧ (disposition bigNote).gain = 10000000 := by decide
example : Income.paraB { capital := ⟨[disposition bigNote], 0, {}⟩ } = 2 * 5000000 := by decide
-- The preferred shares then cost nothing.
example : preferredCostTotal bigNote = 0 := by decide

-- (c): agreed above fair market value, the elected amount is fair market value.
example : electedAmount { opco with agreed := 120000000 } = 100000000 := by decide
-- (c.1): agreed below the lesser of fair market value and cost, it is raised to that.
example : electedAmount { opco with agreed := 5000000, boot := [] } = 20000000 := by decide
-- A property with an accrued loss: the floor is fair market value, so the loss is realized.
def lossy : Facts := { opco with fairMarketValue := 15000000, agreed := 10000000, boot := [], preferred := [{ prefs with fairMarketValue := 15000000 }] }
example : electedAmount lossy = 15000000 ∧ (disposition lossy).loss = 5000000 := by decide
-- (e): depreciable property, the least of the class's UCC, cost and fair market value.
def truck : Facts := { opco with kind := .depreciable 8000000, costAmount := 12000000, fairMarketValue := 20000000, agreed := 0, boot := [], preferred := [{ prefs with fairMarketValue := 20000000 }] }
example : electedAmount truck = 8000000 := by decide
-- (e.3): the boot wins over a lower floor.
example : electedAmount { truck with boot := [{ note with fairMarketValue := 10000000 }] } = 10000000 := by decide

-- Common shares in two classes split what is left by value (h).
def classA : ShareClass := { name := "class A common shares", fairMarketValue := 60000000 }
def classB : ShareClass := { name := "class B common shares", fairMarketValue := 25000000 }
def twoClasses : Facts := { opco with preferred := [], common := [classA, classB] }
example : commonCost twoClasses classA = 3529411 ∧ commonCost twoClasses classB = 1470588 := by decide

-- (e.2): shares worth only $600,000 for a $1,000,000 property, the rest a benefit to the
-- taxpayer's children who hold the common shares: $400,000 is added to the proceeds,
-- but the preferred shares still cost only $200,000.
def gifting : Facts := { opco with boot := [], preferred := [{ prefs with fairMarketValue := 60000000 }], benefit := .judged "J-BENEFIT" true }
example : excess gifting = 40000000 ∧ electedAmount gifting = 60000000 := by decide
example : (disposition gifting).gain = 40000000 := by decide
example : preferredCost gifting { prefs with fairMarketValue := 60000000 } = 20000000 := by decide
#guard (rule.explain gifting).reliesOn == ["J-BENEFIT"]
-- No excess, no judgment call relied on.
#guard (rule.explain { opco with benefit := .judged "J-BENEFIT" true }).reliesOn == []

-- No shares in the consideration: 85(1) does not apply, and the disposition is at fair market value.
example : rollover.holds { opco with preferred := [] } = false := by decide
example : (disposition { opco with preferred := [], boot := [{ note with fairMarketValue := 100000000 }] }).gain = 80000000 := by
  decide
-- Inventory: the gain is not on capital account.
example : (disposition { opco with kind := .inventory }).capitalAccount = .fact false := by decide

/-! ## Read-back -/

#guard (rule.explain opco).render.splitOn "\n" ==
  ["1. The property is eligible property (85(1.1)). [ITA 85(1) eligible property]",
   "2. It was disposed of to a taxable Canadian corporation. [ITA 85(1) taxable Canadian corporation]",
   "3. The consideration includes shares of the capital stock of the corporation. [ITA 85(1) shares]",
   "4. The taxpayer and the corporation jointly elected in prescribed form and in time (85(6)). [ITA 85(1) election]",
   "5. Therefore subsection 85(1) applies. [ITA 85(1)]",
   "6. The elected amount is the amount agreed on, $200,000.00. [ITA 85(1)(b), (c), (c.1), (e), (e.3)]",
   "7. So the taxpayer's proceeds, and the corporation's cost, are $200,000.00. [ITA 85(1)(a)]",
   "8. The taxpayer's cost of the note is $150,000.00. [ITA 85(1)(f)]",
   "9. The taxpayer's cost of the preferred shares is $50,000.00. [ITA 85(1)(g)]"]

end Canteen.Tests.TransferToCorporation

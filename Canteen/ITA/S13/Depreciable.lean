import Canteen.Core.Finding
import Canteen.Core.Rule
import Canteen.ITA.S38.CapitalGains

/-!
# Depreciable property: 13(21) "undepreciated capital cost", 13(1) recapture, 20(16) terminal loss

*Income Tax Act*, as consolidated to 2026-10-29 (verbatim in `statute/ITA-13-1-13-21-20-16.txt`):

**13(21) "undepreciated capital cost"** of a prescribed class at any time is (A + B + C + D + D.1)
− (E + E.1 + E.2 + F + G + H + I + J + K), where A is the capital cost of property of the class
acquired before that time, B the amounts included in income under section 13 for the class for
earlier years, E the total depreciation allowed for the class before that time, F for each
disposition before that time the lesser of (a) the proceeds less outlays and expenses and (b) the
capital cost of the property, and the other terms are assistance, debt forgiveness, mining,
investment tax credit and duty adjustments.

**13(1)** If at the end of a year E to K exceed A to D.1 for a class, the excess is included in
income (recapture). **20(16)** If at the end of a year A to D.1 exceed E to K and the taxpayer no
longer owns any property of the class, the excess is deducted (a terminal loss), and no capital
cost allowance is claimed for the class. **20(1)(a)** Capital cost allowance is as allowed by
regulation.

C, D, D.1 are given as one total of other additions, and E.1, E.2, G, H, I, J, K as one total of
other deductions. Capital cost allowance (E) for each year is given: its rates and the half-year
rule are in the Income Tax Regulations (Part XI, Schedule II), which are not encoded. A disposition's
capital gain is computed as for any capital property, with the capital cost as its adjusted cost
base; depreciable property never has a capital loss (39(1)(b)(i)).
-/

namespace Canteen.ITA.Depreciable

/-- A disposition of property of the class. -/
structure Disposition where
  description : String
  proceeds : Cents
  outlaysAndExpenses : Cents := 0
  /-- The capital cost of the property disposed of. -/
  capitalCost : Cents
  deriving Repr, DecidableEq, Inhabited

/-- A prescribed class, at the end of a taxation year. -/
structure ClassFacts where
  /-- The class, e.g. `"Class 8"`. -/
  name : String
  /-- A: the capital cost of each property of the class acquired. -/
  acquisitions : List Cents
  /-- B: recapture included in income for earlier years. -/
  priorRecapture : Cents := 0
  /-- C, D, D.1: other additions. -/
  otherAdditions : Cents := 0
  /-- E: capital cost allowance allowed for the class in all years before. -/
  depreciation : Cents := 0
  /-- F: the dispositions. -/
  dispositions : List Disposition := []
  /-- E.1, E.2, G to K: other deductions. -/
  otherDeductions : Cents := 0
  /-- 20(16)(b): the taxpayer still owns property of the class at the end of the year. -/
  ownsPropertyAtYearEnd : Bool := true
  deriving Repr, DecidableEq, Inhabited

namespace ClassFacts

/-- F for one disposition: the lesser of net proceeds and capital cost. -/
def fAmount (d : Disposition) : Cents := min (d.proceeds - d.outlaysAndExpenses) d.capitalCost

def a (c : ClassFacts) : Cents := c.acquisitions.sum
def f (c : ClassFacts) : Cents := (c.dispositions.map fAmount).sum

/-- A to D.1. -/
def additions (c : ClassFacts) : Cents := c.a + c.priorRecapture + c.otherAdditions
/-- E to K. -/
def deductions (c : ClassFacts) : Cents := c.depreciation + c.f + c.otherDeductions

/-- 13(21): undepreciated capital cost, if positive. -/
def ucc (c : ClassFacts) : Cents := c.additions - c.deductions

/-- 13(1): recapture. -/
def recapture (c : ClassFacts) : Cents := c.deductions - c.additions

/-- 20(16): a terminal loss, if no property of the class is left. -/
def terminalLoss (c : ClassFacts) : Cents := if c.ownsPropertyAtYearEnd then 0 else c.ucc

/-- 20(16)(d): no capital cost allowance for a class with a terminal loss. -/
def ccaAllowed (c : ClassFacts) : Bool := c.ownsPropertyAtYearEnd || c.ucc == 0

/-- A disposition, for the capital gains computation: capital cost as its adjusted cost base. -/
def capitalGainsDisposition (d : Disposition) : CapitalGains.Disposition :=
  { description := d.description, proceeds := d.proceeds, adjustedCostBase := d.capitalCost,
    outlaysAndExpenses := d.outlaysAndExpenses, propertyClass := .depreciable }

def explain (c : ClassFacts) : Finding :=
  let m := formatCents
  ⟨c.recapture > 0 || c.terminalLoss > 0,
    [⟨s!"{c.name}: A to D.1 total {m c.additions} (capital cost of property acquired {m c.a}" ++
        (if c.priorRecapture > 0 then s!", earlier recapture {m c.priorRecapture}" else "") ++ ").", "ITA 13(21) \"undepreciated capital cost\""⟩,
     ⟨s!"E to K total {m c.deductions} (capital cost allowance {m c.depreciation}; for dispositions, the lesser of net " ++
        s!"proceeds and capital cost, {m c.f}).", "ITA 13(21) \"undepreciated capital cost\""⟩] ++
    (if c.recapture > 0 then
      [⟨s!"E to K exceed A to D.1 by {m c.recapture}, which is included in income as recapture.", "ITA 13(1)"⟩]
    else if c.terminalLoss > 0 then
      [⟨s!"No property of the class is left, so the undepreciated capital cost of {m c.ucc} is deducted as a terminal loss, " ++
        "and no capital cost allowance is claimed for the class.", "ITA 20(16)"⟩]
    else
      [⟨s!"The undepreciated capital cost is {m c.ucc}.", "ITA 13(21) \"undepreciated capital cost\""⟩]), []⟩

/-- 13(1) and 20(16), as a rule: an amount is included or deducted. -/
def rule : Rule ClassFacts where
  name := "subsection 13(1) or 20(16)"
  citation := "ITA 13(1); 20(16)"
  holds := fun c => c.recapture > 0 || c.terminalLoss > 0
  explain := explain
  sound := fun _ => rfl

end ClassFacts

/-! ## Truths about depreciable property -/

open ClassFacts

private theorem sub_zero_or (x y : Nat) : x - y = 0 ∨ y - x = 0 := by omega

/-- Recapture and undepreciated capital cost are never both positive. -/
theorem recapture_or_ucc (c : ClassFacts) : c.recapture = 0 ∨ c.ucc = 0 := by
  rcases sub_zero_or c.deductions c.additions with h | h
  · exact Or.inl h
  · exact Or.inr h

/-- F never exceeds the capital cost of what was disposed of. -/
theorem f_le_cost (d : Disposition) : fAmount d ≤ d.capitalCost := Nat.min_le_right _ _

private theorem recap_le (e f a : Nat) (h : f ≤ a) : (e + f + 0) - (a + 0 + 0) ≤ e := by omega

/-- **Recapture never exceeds the depreciation claimed**, where everything disposed of was acquired
(the capital cost of the dispositions is within A) and there are no other terms. -/
theorem recapture_le_depreciation (c : ClassFacts)
    (hc : (c.dispositions.map (·.capitalCost)).sum ≤ c.a) (hb : c.priorRecapture = 0) (ha : c.otherAdditions = 0)
    (hd : c.otherDeductions = 0) : c.recapture ≤ c.depreciation := by
  have hf : c.f ≤ (c.dispositions.map (·.capitalCost)).sum := by
    unfold ClassFacts.f
    induction c.dispositions with
    | nil => simp
    | cons d ds ih => simp only [List.map_cons, List.sum_cons]; exact Nat.add_le_add (f_le_cost d) ih
  unfold recapture deductions additions
  rw [hb, ha, hd]
  exact recap_le _ _ _ (Nat.le_trans hf hc)

private theorem single (cost cca p : Nat) (hp : cost ≤ p) :
    (cca + min (p - 0) cost + 0) - (cost + 0 + 0) = cca := by
  rw [Nat.sub_zero, Nat.min_eq_right hp]; omega

/-- A class with one property, sold in the year for `p`, `cca` having been claimed. -/
def oneProperty (desc : String) (cost cca p : Cents) : ClassFacts :=
  { name := "the class", acquisitions := [cost], depreciation := cca, dispositions := [⟨desc, p, 0, cost⟩], ownsPropertyAtYearEnd := false }

/-- **One property, sold above its capital cost:** all the depreciation claimed comes back as
recapture, and the rest is a capital gain. -/
theorem sold_above_cost (desc : String) (cost cca p : Cents) (hp : cost ≤ p) :
    (oneProperty desc cost cca p).recapture = cca ∧ (capitalGainsDisposition ⟨desc, p, 0, cost⟩).gain = p - cost := by
  constructor
  · simp only [oneProperty, recapture, deductions, additions, ClassFacts.a, ClassFacts.f, fAmount, List.sum_cons, List.sum_nil,
      List.map_cons, List.map_nil, Nat.add_zero]
    have := single cost cca p hp
    simpa using this
  · simp [capitalGainsDisposition, CapitalGains.Disposition.gain, CapitalGains.Disposition.excess,
      CapitalGains.Disposition.reserveLimit]

end Canteen.ITA.Depreciable

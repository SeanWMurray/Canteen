import Canteen.Core.Money
import Canteen.Core.Date
import Canteen.Core.Finding

/-!
# Employee stock options: 7(1)(a), 7(1.1), and the deductions in 110(1)(d) and (d.1)

*Income Tax Act*, as consolidated to 2026-10-29 (verbatim in `statute/ITA-7-1-a-7-1.1-110-1-d-d.1.txt`):

* **7(1)(a)** an employee who acquires securities under an agreement is deemed to receive, because of
  employment, the value of the securities when acquired less what was paid for them and for the right, in
  the year acquired.
* **7(1.1)** for a share of a Canadian-controlled private corporation, the employee dealing at arm's length
  with it, the benefit is received in the year the share is disposed of or exchanged instead.
* **110(1)(d)** the employee deducts half the benefit if the security is not a non-qualified security, is a
  prescribed share (or mutual fund unit), and (among other conditions) the amount payable for it is at
  least its value when the agreement was made and the employee dealt at arm's length with the employer.
* **110(1)(d.1)** for a benefit deferred by 7(1.1), half the benefit if the share was kept at least two
  years after it was acquired and 110(1)(d) is not claimed.

The 110(1)(d) conditions are facts, as is whether the security is a non-qualified security (the $200,000
vesting limit of 110(1.31) and the employer's designation). The 53(1)(j) addition of the benefit to the
share's cost is computed. Not encoded: 7(1)(b) to (e), 7(1.4) (exchanges), 110(1)(d.01) (donated shares),
110(1.1) (cash-out elections), and the security option rules for mutual fund units.
-/

namespace Canteen.ITA.StockOptions

structure Facts where
  /-- Acquired (the option exercised), and disposed of, if it has been. -/
  acquired : Date
  disposed : Option Date := none
  /-- 7(1)(a): the value when acquired, and what was paid for the securities and for the option. -/
  valueAtAcquisition : Cents
  exercisePrice : Cents
  optionCost : Cents := 0
  /-- 7(1.1): a share of a Canadian-controlled private corporation, the employee at arm's length with it. -/
  ccpcArmsLength : Bool := false
  /-- 110(1)(d): a prescribed share, not a non-qualified security, exercise price at least the value at grant,
  and the employee at arm's length with the employer. -/
  prescribedShare : Bool := true
  nonQualified : Bool := false
  priceAtLeastValueAtGrant : Bool := true
  armsLength : Bool := true
  deriving Repr, DecidableEq, Inhabited

/-- 7(1)(a): the benefit. -/
def benefit (f : Facts) : Cents := f.valueAtAcquisition - (f.exercisePrice + f.optionCost)

/-- The taxation year it is received: the year acquired, or, under 7(1.1), the year disposed of. -/
def inclusionYear (f : Facts) : Option Nat :=
  if f.ccpcArmsLength then f.disposed.map (·.year) else some f.acquired.year

/-- 110(1)(d). -/
def qualifiesD (f : Facts) : Bool :=
  f.prescribedShare && !f.nonQualified && f.priceAtLeastValueAtGrant && f.armsLength

/-- 110(1)(d.1): deferred under 7(1.1), and kept two years after it was acquired. -/
def qualifiesD1 (f : Facts) : Bool :=
  f.ccpcArmsLength && f.disposed.any (fun d => f.acquired.toDays + 730 ≤ d.toDays)

/-- The 110(1)(d) or (d.1) deduction: half the benefit, if either applies. -/
def deduction (f : Facts) : Cents := if qualifiesD f || qualifiesD1 f then benefit f / 2 else 0

/-- 53(1)(j): the share's adjusted cost base: the price, the option's cost, and the benefit. -/
def adjustedCostBase (f : Facts) : Cents := f.exercisePrice + f.optionCost + benefit f

def explain (f : Facts) : Finding :=
  let c := formatCents
  ⟨benefit f > 0, [
    ⟨s!"Shares worth {c f.valueAtAcquisition} were acquired for {c (f.exercisePrice + f.optionCost)}: a benefit of {c (benefit f)}, " ++
      (match inclusionYear f with
       | some y => s!"received in {y}" ++ (if f.ccpcArmsLength then " (the year disposed of, 7(1.1))" else "")
       | none => "not yet received: the shares, of a Canadian-controlled private corporation, have not been disposed of (7(1.1))") ++ ".",
      "ITA 7(1)(a); 7(1.1)"⟩,
    ⟨s!"Half of it, {c (deduction f)}, is deducted" ++
      (if qualifiesD f then " under 110(1)(d)." else if qualifiesD1 f then " under 110(1)(d.1)." else ": no, neither 110(1)(d) nor (d.1) applies."),
      "ITA 110(1)(d), (d.1)"⟩], []⟩

/-! ## Truths -/

/-- The deduction is never more than half the benefit. -/
theorem deduction_le (f : Facts) : deduction f ≤ benefit f / 2 := by
  unfold deduction; split
  · exact Nat.le_refl _
  · exact Nat.zero_le _

/-- The share's cost is its value when acquired (when the benefit is not nil). -/
theorem cost_is_value (f : Facts) (h : f.exercisePrice + f.optionCost ≤ f.valueAtAcquisition) :
    adjustedCostBase f = f.valueAtAcquisition := by
  simp only [adjustedCostBase, benefit]; exact Nat.add_sub_of_le h

end Canteen.ITA.StockOptions

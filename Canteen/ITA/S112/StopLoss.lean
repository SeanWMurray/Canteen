import Canteen.ITA.S38.CapitalGains

/-!
# Subsections 112(3), (3.01) and (6.1): the stop-loss on shares

*Income Tax Act*, as consolidated to 2026-10-29 (verbatim in `statute/ITA-112-3-3.01-6.1.txt`):

* **112(3)** a loss (of a taxpayer other than a trust) on a share that is capital property is reduced by
  (a) for an individual, the lesser of the capital dividends received on the share (83(2), not deemed
  taxable by 83(2.1)) and the loss less all taxable dividends received on it; (b) for a corporation, the
  taxable dividends received on it to the extent deducted under section 112 (or 115(1), 138(6)), the
  capital dividends and the life insurance capital dividends.
* **112(3.01)** a qualified dividend is not counted if the taxpayer establishes it was received while the
  taxpayer and non-arm's length persons held no more than 5% of any class of the payer's shares, on a
  share owned throughout the 365 days before the disposition.
* **112(6.1)** a dividend is qualified unless received under 84(3), in which case only if received by an
  individual, or by a private corporation from another private corporation (the trust and partnership
  cases are not encoded).

The reduction is applied as a lower adjusted cost base, which reduces the loss by the same amount and
leaves a gain unchanged. Not encoded: 112(3.1) to (3.32) (partnerships and trusts), 112(4) to (4.22)
(shares that are not capital property), 112(5.5), (5.6).
-/

namespace Canteen.ITA.StopLoss

inductive Kind where
  /-- A taxable dividend; for a corporation, the part deducted under 112 (or 115(1), 138(6)). -/
  | taxable (deducted : Cents := 0)
  /-- A capital dividend (83(2)) not deemed taxable by 83(2.1). -/
  | capital
  /-- A life insurance capital dividend. -/
  | lifeInsuranceCapital
  deriving Repr, DecidableEq, Inhabited

structure Dividend where
  amount : Cents
  kind : Kind
  /-- Received under 84(3) (a redemption). -/
  onRedemption : Bool := false
  /-- 112(6.1)(b)(ii): received by a private corporation from another private corporation. -/
  privateToPrivate : Bool := false
  /-- 112(3.01)(a): the holder and non-arm's length persons held no more than 5% of any class. -/
  smallHolding : Bool := false
  deriving Repr, DecidableEq, Inhabited

structure Facts where
  /-- The holder is an individual (`false`: a corporation). -/
  individual : Bool
  dividends : List Dividend
  /-- 112(3.01)(b): the share was owned throughout the 365 days before the disposition. -/
  held365 : Bool := false
  deriving Repr, DecidableEq, Inhabited

/-- 112(6.1). -/
def qualified (f : Facts) (d : Dividend) : Bool :=
  !d.onRedemption || f.individual || d.privateToPrivate

/-- 112(3.01): excluded from the reduction. -/
def excluded (f : Facts) (d : Dividend) : Bool := qualified f d && d.smallHolding && f.held365

/-- What a dividend counts for in 112(3)(a)(i) or (b). -/
def counted (f : Facts) (d : Dividend) : Cents :=
  if excluded f d then 0
  else match d.kind, f.individual with
    | .capital, _ => d.amount
    | .taxable deducted, false => min deducted d.amount
    | .lifeInsuranceCapital, false => d.amount
    | _, true => 0

def taxableReceived (f : Facts) : Cents :=
  ((f.dividends.filter fun d => match d.kind with | .taxable _ => true | _ => false).map (·.amount)).sum

/-- 112(3): the amount the loss is reduced by. -/
def reduction (f : Facts) (loss : Cents) : Cents :=
  let total := (f.dividends.map (counted f)).sum
  if f.individual then min total (loss - taxableReceived f) else min total loss

/-- The disposition, with the reduction applied to the adjusted cost base where there is a loss. -/
def apply (f : Facts) (d : CapitalGains.Disposition) : CapitalGains.Disposition :=
  { d with adjustedCostBase := d.adjustedCostBase - reduction f d.loss }

/-! ## Truths -/

/-- The reduction never exceeds the loss. -/
theorem reduction_le (f : Facts) (loss : Cents) : reduction f loss ≤ loss := by
  unfold reduction; simp only; split
  · exact Nat.le_trans (Nat.min_le_right _ _) (Nat.sub_le _ _)
  · exact Nat.min_le_right _ _

private theorem sum_zeros {α : Type} (l : List α) : (l.map fun _ => (0 : Nat)).sum = 0 := by
  induction l with
  | nil => rfl
  | cons _ _ ih => simp [ih]

/-- An individual who received no capital dividends on the share keeps the whole loss. -/
theorem individual_taxable_only (f : Facts) (h : f.individual = true)
    (hd : ∀ d ∈ f.dividends, d.kind ≠ .capital) (loss : Cents) : reduction f loss = 0 := by
  have hz : (f.dividends.map (counted f)) = f.dividends.map (fun _ => 0) := by
    apply List.map_congr_left
    intro d hm
    have := hd d hm
    unfold counted; split
    · rfl
    · split <;> simp_all
  unfold reduction; simp only [h, hz, ite_true, sum_zeros, Nat.zero_min]

end Canteen.ITA.StopLoss

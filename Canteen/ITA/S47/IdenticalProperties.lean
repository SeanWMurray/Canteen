import Canteen.ITA.S38.CapitalGains

/-!
# Subsection 47(1): identical properties, and the average cost

*Income Tax Act*, as consolidated to 2026-10-29 (verbatim in `statute/ITA-47-1.txt`):

> (1) Where … a taxpayer who owns one property … or two or more identical properties … acquires
> one or more other properties … each of which is identical to each such previously-acquired
> property, for the purposes of computing … the adjusted cost base … of each such identical
> property, (a) the taxpayer shall be deemed to have disposed of each such previously-acquired
> property immediately before the particular time for proceeds equal to its adjusted cost base …;
> (b) the taxpayer shall be deemed to have acquired the identical property at the particular time at
> a cost equal to the quotient obtained when (i) the total of the adjusted cost bases … of the
> previously-acquired properties, and the cost … of the newly-acquired properties is divided by
> (ii) the number of the identical properties owned by the taxpayer immediately after the
> particular time; …

So identical properties (for example, shares of one class of one corporation) form a pool: each
has the average cost. The pool keeps its count and total cost; a sale of some of them takes their
share of the total, rounded down to the cent, and the rest stays in the pool, so the average is
kept exactly and no cent is lost. Additions to the cost of the pool (for example, a superficial
loss added under 53(1)(f)) are spread the same way. Whether properties are identical is for the
caller (often a judgment call, as in the superficial loss definition). A sale of more than the
pool holds is read as a sale of all of it. Not encoded: 47(1)(c), (d) (53(2)(g.1) amounts), 47(2)
and (3), and properties acquired before 1972.
-/

namespace Canteen.ITA.IdenticalProperties

/-- The pool: how many identical properties are owned, and their total adjusted cost base. -/
structure Pool where
  count : Nat := 0
  total : Cents := 0
  deriving Repr, DecidableEq, Inhabited

/-- One event in the life of the pool. -/
inductive Event where
  /-- Acquire `n` more identical properties for `cost` in all. -/
  | buy (n : Nat) (cost : Cents)
  /-- Dispose of `n` of them for `proceeds` in all, with `outlays`. -/
  | sell (n : Nat) (proceeds : Cents) (outlays : Cents := 0)
  /-- An amount added to the cost of all of them (for example, under 53(1)(f)). -/
  | addToCost (amount : Cents)
  deriving Repr, DecidableEq, Inhabited

/-- 47(1)(b): the average cost, rounded down to the cent. -/
def Pool.average (p : Pool) : Cents := if p.count = 0 then 0 else p.total / p.count

/-- The cost of `n` of the pool's properties: their share of the total, rounded down. -/
def Pool.costOf (p : Pool) (n : Nat) : Cents := if p.count = 0 then 0 else p.total * min n p.count / p.count

/-- The pool after the events, and the dispositions they made. -/
def run (description : String) : Pool → List Event → Pool × List CapitalGains.Disposition
  | p, [] => (p, [])
  | p, .buy n cost :: es => run description ⟨p.count + n, p.total + cost⟩ es
  | p, .addToCost amount :: es => run description ⟨p.count, p.total + amount⟩ es
  | p, .sell n proceeds outlays :: es =>
    let d : CapitalGains.Disposition :=
      { description := s!"{min n p.count} {description}", proceeds, adjustedCostBase := p.costOf n, outlaysAndExpenses := outlays }
    let (q, ds) := run description ⟨p.count - min n p.count, p.total - p.costOf n⟩ es
    (q, d :: ds)

/-- What went into the pool: the costs of the properties bought, and additions to cost. -/
def inflow : List Event → Cents
  | [] => 0
  | .buy _ cost :: es => cost + inflow es
  | .addToCost amount :: es => amount + inflow es
  | .sell .. :: es => inflow es

/-! ## Truths about the pool -/

theorem costOf_le (p : Pool) (n : Nat) : p.costOf n ≤ p.total := by
  unfold Pool.costOf; split
  · exact Nat.zero_le _
  · rename_i h
    exact Nat.div_le_of_le_mul (by rw [Nat.mul_comm p.count]; exact Nat.mul_le_mul_left _ (Nat.min_le_right _ _))

private theorem rebalance (t c r i s : Nat) (hc : c ≤ t) (h : r + s = t - c + i) : r + (c + s) = t + i := by omega

/-- **No cost is lost or counted twice.** The adjusted cost bases of everything sold, plus what is
left in the pool, equal what the pool started with plus everything that went in. -/
theorem conserved (description : String) (p : Pool) (es : List Event) :
    (run description p es).1.total + ((run description p es).2.map (·.adjustedCostBase)).sum = p.total + inflow es := by
  induction es generalizing p with
  | nil => simp [run, inflow]
  | cons e es ih =>
    cases e with
    | buy n cost =>
      simp only [run, inflow]
      rw [ih]; exact Nat.add_assoc _ _ _
    | addToCost amount =>
      simp only [run, inflow]
      rw [ih]; exact Nat.add_assoc _ _ _
    | sell n proceeds outlays =>
      have h := ih ⟨p.count - min n p.count, p.total - p.costOf n⟩
      simp only [run, inflow, List.map_cons, List.sum_cons] at h ⊢
      exact rebalance _ _ _ _ _ (costOf_le p n) h

/-- Selling the whole pool leaves nothing in it. -/
theorem sell_all (p : Pool) (hp : 0 < p.count) : p.costOf p.count = p.total := by
  simp [Pool.costOf, Nat.pos_iff_ne_zero.mp hp, Nat.mul_div_cancel _ hp]

end Canteen.ITA.IdenticalProperties

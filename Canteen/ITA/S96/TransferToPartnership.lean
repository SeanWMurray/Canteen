import Canteen.ITA.S85.TransferToCorporation

/-!
# Subsection 97(2): transferring property to a Canadian partnership

*Income Tax Act*, as consolidated to 2026-10-29 (verbatim in `statute/ITA-97-2.txt`):

**97(2)** Where a taxpayer disposes of capital property, Canadian or foreign resource property or
inventory to a partnership that is immediately after a Canadian partnership of which the taxpayer is a
member, and the taxpayer and all the other members jointly elect, (a) 85(1)(a) to (f) apply, with the
partnership in place of the corporation and an interest in the partnership in place of shares: the
amount agreed on is the taxpayer's proceeds and the partnership's cost, at least the non-interest
consideration and the lesser of the property's value and cost amount, and at most its value; (b) the
adjusted cost base of the taxpayer's interest goes up by the proceeds over the value of the
consideration other than an interest, and down by any such consideration over the property's value;
(c) if the property was taxable Canadian property, the interest is taxable Canadian property for 60 months.

Unlike 85(1), no partnership interest need be received. The (e.2) benefit rule, 97(3), 13(21.2) and
the eligible derivative exclusion are not encoded; whether the partnership is a Canadian partnership
(102(1)) and the election are facts.
-/

namespace Canteen.ITA.TransferToPartnership

open TransferToCorporation (PropertyKind)

structure Facts where
  description : String
  kind : PropertyKind := .capital
  /-- A Canadian partnership immediately after, of which the taxpayer is a member. -/
  canadianPartnership : Bool := true
  member : Bool := true
  /-- The taxpayer and all the other members jointly elected, in time (96(4)). -/
  jointElection : Bool := true
  fairMarketValue : Cents
  costAmount : Cents
  agreed : Cents
  /-- The fair market value of the consideration other than an interest in the partnership. -/
  boot : Cents := 0
  /-- The property was taxable Canadian property. -/
  taxableCanadian : Bool := false
  deriving Repr, DecidableEq, Inhabited

def applies (f : Facts) : Bool := f.canadianPartnership && f.member && f.jointElection

/-- The floor of 85(1)(c.1) or (e). -/
def floor (f : Facts) : Cents :=
  match f.kind with
  | .capital | .inventory => min f.fairMarketValue f.costAmount
  | .depreciable ucc => min (min ucc f.costAmount) f.fairMarketValue

/-- 97(2)(a), with 85(1)(b), (c), (c.1), (e): the elected amount. Without the election, the value. -/
def proceeds (f : Facts) : Cents :=
  if applies f then min f.fairMarketValue (max f.agreed (max f.boot (floor f))) else f.fairMarketValue

/-- The taxpayer's gain (income, for inventory). -/
def gain (f : Facts) : Cents := proceeds f - f.costAmount

/-- 97(2)(b): the change in the adjusted cost base of the taxpayer's interest. -/
def interestCostChange (f : Facts) : Int := ((proceeds f - f.boot : Nat) : Int) - ((f.boot - f.fairMarketValue : Nat) : Int)

/-- 97(2)(c): the interest is taxable Canadian property for 60 months. -/
def interestTCP (f : Facts) : Bool := applies f && f.taxableCanadian

def explain (f : Facts) : Finding :=
  let c := formatCents
  ⟨applies f, [
    if applies f then ⟨s!"{f.description}: transferred to a Canadian partnership of which the taxpayer is a member, by joint election, " ++
        s!"at {c (proceeds f)} (the agreed {c f.agreed}, within the non-interest consideration {c f.boot} and the value {c f.fairMarketValue}): " ++
        s!"a gain of {c (gain f)}; the interest's cost changes by {interestCostChange f} cents.", "ITA 97(2)(a), (b); 85(1)(a) to (f)"⟩
    else ⟨s!"{f.description}: 97(2) does not apply; proceeds are the value, {c f.fairMarketValue}.", "ITA 97(2)"⟩], []⟩

/-! ## Truths -/

theorem proceeds_le_value (f : Facts) : proceeds f ≤ f.fairMarketValue := by
  unfold proceeds; split
  · exact Nat.min_le_left _ _
  · exact Nat.le_refl _

/-- Electing the cost, with no other consideration: no gain. -/
theorem rollover (f : Facts) (h : applies f = true) (hk : f.kind = .capital) (hb : f.boot = 0) (hc : f.costAmount ≤ f.fairMarketValue)
    (ha : f.agreed = f.costAmount) : gain f = 0 := by
  simp [gain, proceeds, h, floor, hk, hb, ha, Nat.min_eq_right hc]

end Canteen.ITA.TransferToPartnership

import Canteen.Core.Money
import Canteen.Core.Finding

/-!
# Amounts received in advance: 12(1)(a), the 20(1)(m) reserve, and 12(1)(e)

*Income Tax Act*, as consolidated to 2026-10-29 (verbatim in `statute/ITA-12-1-a-e-20-1-m.txt`):

**12(1)(a)** Amounts received in the year in the course of a business (i) on account of services not
rendered or goods not delivered by the end of the year, or otherwise not earned, or (ii) repayable on the
return of containers, are included in income.

**20(1)(m)** Where such amounts have been included for the year or an earlier year, a reasonable reserve
for (i) goods to be delivered, (ii) services to be rendered, (iii) rent and other amounts paid in advance
for periods, and (iv) container deposits to be repaid (other than for bottles), after the end of the year.

**12(1)(e)(i)** Last year's 20(1)(m) reserve is included this year.

The reasonable reserve for each advance is given and capped at the advance. 20(6) (reserves for
transportation tickets and the like), 20(1)(m.1) and 20(7) are not encoded; 20(1)(n) is in `InstalmentSales`.
-/

namespace Canteen.ITA.AdvancePayments

inductive Kind where
  | goods
  | services
  | rent
  /-- 12(1)(a)(ii), 20(1)(m)(iv): deposits repayable on the return of containers. -/
  | containers
  /-- Container deposits for bottles: no reserve (20(1)(m)(iv)). -/
  | bottles
  deriving Repr, DecidableEq, Inhabited

structure Advance where
  description : String
  kind : Kind
  amount : Cents
  /-- Received in this year (and so included now), or in an earlier year (already included). -/
  receivedThisYear : Bool := true
  /-- A reasonable reserve for what remains to be delivered, rendered, rented or repaid after the year. -/
  reserve : Cents := 0
  deriving Repr, DecidableEq, Inhabited

structure Facts where
  advances : List Advance := []
  /-- 12(1)(e)(i): last year's 20(1)(m) reserve. -/
  priorReserve : Cents := 0
  deriving Repr, DecidableEq, Inhabited

def Advance.reserveAllowed (a : Advance) : Cents := if a.kind == .bottles then 0 else min a.reserve a.amount

def included (f : Facts) : Cents := ((f.advances.filter (·.receivedThisYear)).map (·.amount)).sum
def inclusions (f : Facts) : Cents := included f + f.priorReserve
def reserve (f : Facts) : Cents := (f.advances.map Advance.reserveAllowed).sum

/-- The net effect on income. -/
def net (f : Facts) : Int := (inclusions f : Int) - (reserve f : Int)

def explain (f : Facts) : Finding :=
  let c := formatCents
  ⟨reserve f > 0, [
    ⟨s!"Received in advance in the year: {c (included f)}, included in income; last year's reserve, {c f.priorReserve}, included too.",
      "ITA 12(1)(a), (e)(i)"⟩,
    ⟨s!"A reserve of {c (reserve f)} for what remains to be delivered, rendered or repaid after the year.", "ITA 20(1)(m)"⟩,
    ⟨s!"Net: {net f} cents added to income.", "ITA 12(1)(a), (e); 20(1)(m)"⟩], []⟩

/-! ## Truths -/

theorem Advance.reserve_le (a : Advance) : a.reserveAllowed ≤ a.amount := by
  unfold Advance.reserveAllowed; split
  · exact Nat.zero_le _
  · exact Nat.min_le_right _ _

/-- The reserve never exceeds the advances. -/
theorem reserve_le (f : Facts) : reserve f ≤ (f.advances.map (·.amount)).sum := by
  unfold reserve
  induction f.advances with
  | nil => simp
  | cons a t ih => simp only [List.map_cons, List.sum_cons]; exact Nat.add_le_add (Advance.reserve_le a) ih

/-- Over the year received and the next, an advance fully delivered by then is income once. -/
theorem two_years (a : Advance) (h : a.receivedThisYear = true) :
    net { advances := [a] } + net { advances := [], priorReserve := reserve { advances := [a] } } = a.amount := by
  simp [net, inclusions, included, reserve, h]

end Canteen.ITA.AdvancePayments

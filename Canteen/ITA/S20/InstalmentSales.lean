import Canteen.Core.Money
import Canteen.Core.Finding
import Canteen.Core.Date

/-!
# The reserve for unpaid amounts on property sold in the course of a business: 20(1)(n), 20(8)

*Income Tax Act*, as consolidated to 2026-10-29 (verbatim in `statute/ITA-20-1-n-20-8.txt`):

**20(1)(n)** Where an amount included in income from the business, for property sold in the course of
it, is payable after the end of the year, and (except for real or immovable property) all or part of
it was, at the time of the sale, not due until at least two years after: a reasonable reserve for the
part that can reasonably be regarded as a portion of the profit from the sale.

**20(8)** No reserve if (a) the taxpayer, at the end of the year or in the next, was exempt or was a
non-resident not carrying on the business in Canada; (b) the sale was more than 36 months before the
end of the year; (c) the purchaser was a corporation controlled by the taxpayer, by a person or group
controlling the taxpayer, or controlling the taxpayer; or (d) a partnership of which the taxpayer was a
majority-interest partner. **12(1)(e)(ii)** Last year's reserve is included this year.

The reasonable reserve is taken, unless another amount is given, as the profit times the part unpaid
at the end of the year over the price. 20(8)(c) and (d), and exempt or non-resident status, are facts.
-/

namespace Canteen.ITA.InstalmentSales

structure Sale where
  description : String
  saleDate : Date
  price : Cents
  profit : Cents
  /-- Payable after the end of the year. -/
  unpaid : Cents
  /-- The latest date on which any part was due, as agreed at the time of the sale. -/
  latestDue : Date
  realProperty : Bool := false
  /-- 20(8)(c), (d): to a controlled or controlling corporation, or a partnership of which the taxpayer is a majority-interest partner. -/
  relatedPurchaser : Bool := false
  /-- A reasonable reserve, if not the proportional one. -/
  reasonable : Option Cents := none
  deriving Repr, DecidableEq, Inhabited

structure Facts where
  yearEnd : Date
  sales : List Sale := []
  /-- 20(8)(a): exempt, or a non-resident not carrying on the business in Canada. -/
  exemptOrNonResident : Bool := false
  /-- 12(1)(e)(ii): last year's 20(1)(n) reserve. -/
  priorReserve : Cents := 0
  deriving Repr, DecidableEq, Inhabited

def plusYears (d : Date) (n : Nat) : Date := { d with year := d.year + n }

/-- Part not due until at least two years after the sale (not needed for real property). -/
def Sale.longTerm (s : Sale) : Bool := s.realProperty || !s.latestDue.before (plusYears s.saleDate 2)

/-- 20(8)(b): more than 36 months before the end of the year. -/
def Sale.tooOld (s : Sale) (yearEnd : Date) : Bool := (plusYears s.saleDate 3).before yearEnd

def Sale.qualifies (s : Sale) (f : Facts) : Bool :=
  s.unpaid > 0 && s.longTerm && !s.tooOld f.yearEnd && !s.relatedPurchaser && !f.exemptOrNonResident

/-- The profit's share of the unpaid amount. -/
def Sale.proportional (s : Sale) : Cents := if s.price = 0 then 0 else s.profit * s.unpaid / s.price

def Sale.reserve (s : Sale) (f : Facts) : Cents :=
  if s.qualifies f then min (s.reasonable.getD s.proportional) s.profit else 0

def reserve (f : Facts) : Cents := (f.sales.map (·.reserve f)).sum

def net (f : Facts) : Int := (f.priorReserve : Int) - (reserve f : Int)

def explain (f : Facts) : Finding :=
  let c := formatCents
  let steps : List Step := f.sales.map fun s =>
    if f.exemptOrNonResident then ⟨s!"{s.description}: exempt or non-resident, no reserve.", "ITA 20(8)(a)"⟩
    else if s.unpaid = 0 then ⟨s!"{s.description}: nothing payable after the year.", "ITA 20(1)(n)"⟩
    else if !s.longTerm then ⟨s!"{s.description}: nothing was due two years or more after the sale.", "ITA 20(1)(n)"⟩
    else if s.tooOld f.yearEnd then ⟨s!"{s.description}: sold more than 36 months before the end of the year.", "ITA 20(8)(b)"⟩
    else if s.relatedPurchaser then ⟨s!"{s.description}: sold to a related corporation or partnership.", "ITA 20(8)(c), (d)"⟩
    else ⟨s!"{s.description}: {c s.unpaid} of {c s.price} unpaid; a reserve of {c (s.reserve f)} of the {c s.profit} profit.", "ITA 20(1)(n)"⟩
  ⟨reserve f > 0, steps ++ [⟨s!"Last year's reserve, {c f.priorReserve}, is included; this year's, {c (reserve f)}, is deducted.",
    "ITA 12(1)(e)(ii); 20(1)(n)"⟩], []⟩

/-! ## Truths -/

theorem Sale.reserve_le_profit (s : Sale) (f : Facts) : s.reserve f ≤ s.profit := by
  unfold Sale.reserve; split
  · exact Nat.min_le_right _ _
  · exact Nat.zero_le _

/-- 20(8)(b): after 36 months, none. -/
theorem Sale.none_after_three_years (s : Sale) (f : Facts) (h : s.tooOld f.yearEnd = true) : s.reserve f = 0 := by
  simp [Sale.reserve, Sale.qualifies, h]

end Canteen.ITA.InstalmentSales

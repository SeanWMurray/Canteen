import Canteen.Core.Money
import Canteen.Core.Finding

/-!
# The business limit: sharing it (125(2), (3)), short years (125(5)(b)) and the grinds (125(5.1))

*Income Tax Act*, as consolidated to 2026-10-29 (verbatim in `statute/ITA-125-2-3-5-5.1-business-limit.txt`):

**125(2)** A corporation's business limit for a year is $500,000, unless it is associated in the year
with another Canadian-controlled private corporation, in which case it is nil except as provided.

**125(3)** If all the associated CCPCs file an agreement assigning percentages, each one's business
limit is $500,000 times its percentage if the total is no more than 100%, and nil otherwise.

**125(5)(b)** A taxation year of less than 51 weeks: the limit times the days in the year over 365.

**125(5.1)** The limit is reduced by the greater of (a) A × B ÷ $90,000, where A is the limit otherwise
and B is 0.225% × (C − $10 million), C the taxable capital employed in Canada of the corporation (and,
if associated, of the associated corporations) for the preceding year; and (b) D/$500,000 × 5(E −
$50,000), where D is A and E is the adjusted aggregate investment income of the corporation and of the
corporations associated with it, for their taxation years ending in the preceding calendar year.

**125(7) "adjusted aggregate investment income"**: the 129(4) aggregate investment income, but without
gains and losses on active assets or the 111(1)(b) deduction, excluding only dividends from connected
corporations (not every deductible dividend), and counting a specified investment business's income
from outside Canada and life insurance policy amounts. Computed for a corporation's year in
`CorporateYear.adjustedAggregateInvestmentIncome`.

Whether the corporation is associated (256), C (taxable capital employed in Canada, 181.2 to 181.4,
chosen by the 125(5.1)(a)(i) to (iii) cases) and E (the group's adjusted aggregate investment income)
are given. The Minister's allocation (125(4)) and 125(5)(a) (more than one year ending in a calendar
year) are not encoded. Each formula is computed in cents with a single rounding down.
-/

namespace Canteen.ITA.BusinessLimit

/-- $500,000, in cents. -/
def fullLimit : Cents := 50000000

structure Facts where
  /-- Associated in the year with another CCPC (256). -/
  associated : Bool := false
  /-- 125(3): the percentage assigned to the corporation, and the total assigned, in basis points
  (10,000 is 100%). None if no agreement was filed. -/
  assigned : Option Nat := none
  totalAssigned : Nat := 10000
  /-- The days in the taxation year. -/
  days : Nat := 365
  /-- 125(5.1)(a): C, taxable capital employed in Canada, in cents. -/
  taxableCapital : Cents := 0
  /-- 125(5.1)(b): E, the adjusted aggregate investment income of the corporation and the corporations
  associated with it, for the preceding calendar year, in cents. -/
  groupInvestmentIncome : Cents := 0
  deriving Repr, DecidableEq, Inhabited

/-- 125(2), (3). -/
def shared (f : Facts) : Cents :=
  if !f.associated then fullLimit
  else match f.assigned with
    | none => 0
    | some p => if f.totalAssigned ≤ 10000 then fullLimit * p / 10000 else 0

/-- 125(5)(b): less than 51 weeks. -/
def prorated (f : Facts) : Cents := if f.days < 357 then shared f * f.days / 365 else shared f

/-- 125(5.1)(a): A × 0.225% × (C − $10 million) ÷ $90,000. -/
def capitalReduction (f : Facts) : Cents := prorated f * ((f.taxableCapital - 1000000000) * 225) / 900000000000

/-- 125(5.1)(b): D/$500,000 × 5(E − $50,000). -/
def investmentReduction (f : Facts) : Cents := prorated f * (5 * (f.groupInvestmentIncome - 5000000)) / 50000000

/-- 125(5.1): the business limit. -/
def limit (f : Facts) : Cents := prorated f - max (capitalReduction f) (investmentReduction f)

def explain (f : Facts) : Finding :=
  let c := formatCents
  ⟨limit f > 0, [
    ⟨(if !f.associated then "The corporation is not associated with another CCPC: the business limit is $500,000."
      else match f.assigned with
        | none => "The corporation is associated, and no agreement assigns it a percentage: its business limit is nil."
        | some _ => s!"The corporation is associated; its assigned percentage gives a business limit of {c (shared f)}."),
      "ITA 125(2), (3)"⟩,
    ⟨s!"Taxable capital employed in Canada of {c f.taxableCapital} reduces it by {c (capitalReduction f)}; adjusted aggregate " ++
      s!"investment income of {c f.groupInvestmentIncome} by {c (investmentReduction f)}. The greater applies: the business limit is " ++
      s!"{c (limit f)}.", "ITA 125(5.1)"⟩], []⟩

/-! ## Truths -/

theorem shared_le (f : Facts) (h : ∀ p, f.assigned = some p → p ≤ 10000) : shared f ≤ fullLimit := by
  unfold shared
  split
  · exact Nat.le_refl _
  · split
    · exact Nat.zero_le _
    · rename_i p hp
      split
      · have := h p hp
        calc fullLimit * p / 10000 ≤ fullLimit * 10000 / 10000 := Nat.div_le_div_right (Nat.mul_le_mul_left _ this)
          _ = fullLimit := by decide
      · exact Nat.zero_le _

/-- Never more than the shared limit. -/
theorem limit_le (f : Facts) : limit f ≤ shared f := by
  unfold limit prorated
  split
  · rename_i hd
    have h365 : f.days ≤ 365 := Nat.le_of_lt (Nat.lt_trans hd (by decide))
    calc shared f * f.days / 365 - _ ≤ shared f * f.days / 365 := Nat.sub_le _ _
      _ ≤ shared f * 365 / 365 := Nat.div_le_div_right (Nat.mul_le_mul_left _ h365)
      _ = shared f := Nat.mul_div_cancel _ (by decide)
  · exact Nat.sub_le _ _

private theorem sub_ge (x a b : Nat) (h : a + b ≤ x) : a ≤ x - b := by omega

private theorem ground (a x k : Nat) (hk : 0 < k) (h : a * k ≤ x) (y : Nat) : a - max y (x / k) = 0 := by
  have : a ≤ x / k := (Nat.le_div_iff_mul_le hk).mpr h
  omega

/-- $150,000 or more of adjusted aggregate investment income: no business limit. -/
theorem investment_grind_full (f : Facts) (h : 15000000 ≤ f.groupInvestmentIncome) : limit f = 0 := by
  unfold limit investmentReduction
  apply ground _ _ _ (by decide)
  have : 10000000 ≤ f.groupInvestmentIncome - 5000000 := sub_ge _ _ _ h
  calc prorated f * 50000000 = prorated f * (5 * 10000000) := by rw [show (5 : Nat) * 10000000 = 50000000 from by decide]
    _ ≤ prorated f * (5 * (f.groupInvestmentIncome - 5000000)) := Nat.mul_le_mul_left _ (Nat.mul_le_mul_left _ this)

/-- $50 million or more of taxable capital: no business limit. -/
theorem capital_grind_full (f : Facts) (h : 5000000000 ≤ f.taxableCapital) : limit f = 0 := by
  unfold limit capitalReduction
  rw [Nat.max_comm]
  apply ground _ _ _ (by decide)
  have : 4000000000 ≤ f.taxableCapital - 1000000000 := sub_ge _ _ _ h
  calc prorated f * 900000000000 = prorated f * (4000000000 * 225) := by rw [show (4000000000 : Nat) * 225 = 900000000000 from by decide]
    _ ≤ prorated f * ((f.taxableCapital - 1000000000) * 225) := Nat.mul_le_mul_left _ (Nat.mul_le_mul_right _ this)

/-- Under $10 million of capital and $50,000 of investment income: no reduction. -/
theorem no_grind (f : Facts) (h1 : f.taxableCapital ≤ 1000000000) (h2 : f.groupInvestmentIncome ≤ 5000000) :
    limit f = prorated f := by
  have e1 : f.taxableCapital - 1000000000 = 0 := Nat.sub_eq_zero_of_le h1
  have e2 : f.groupInvestmentIncome - 5000000 = 0 := Nat.sub_eq_zero_of_le h2
  simp [limit, capitalReduction, investmentReduction, e1, e2]

end Canteen.ITA.BusinessLimit

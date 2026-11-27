import Canteen.ITA.S123.CorporateRates
import Canteen.Core.Answer

/-!
# The general rate income pool (89(1)) and excessive eligible dividends (185.1(1))

*Income Tax Act*, as consolidated to 2026-10-29 (verbatim in `statute/ITA-89-1-grip-185.1.txt`):

* **"general rate income pool"** of a CCPC at the end of a year: last year's pool (C), plus the general
  rate factor (0.72 for days after 2011) times its adjusted taxable income (D), plus eligible dividends
  received (E), less the eligible dividends it paid in the preceding year in excess of its excessive
  eligible dividend designations that year (G). It can be negative.
* **"adjusted taxable income"** of a corporation: taxable income, less the income on which the small
  business deduction was claimed, less (for a CCPC) the lesser of its aggregate investment income and
  taxable income.
* **"excessive eligible dividend designation"** of a CCPC: (a) for each eligible dividend, its share of
  the amount by which the eligible dividends paid in the year exceed the pool at year end; or (c) the
  whole dividend, if one of the main purposes of the transaction or series was to artificially maintain
  or increase the pool.
* **185.1(1)** Part III.1 tax: 20% of the excessive designation, plus 10% more where (c) applies.
* **185.1(2), (3)** where (c) does not apply, the corporation may elect, with the concurrence of the
  shareholders who received the dividend, to treat an amount up to the excessive designation as a
  separate non-eligible dividend paid just before; the eligible dividend is reduced by it.

Foreign affiliate dividends (E (b)), F (amalgamations and the like, 89(4) to (6)), and the specified
future tax consequences (B) are not encoded; the 185.1(2) election to treat the excess as an ordinary
dividend is taken to be made on time (its 90-day and 30-month limits are not checked), and 185.1(4)
is not encoded. Amounts are rounded down to the cent.
-/

namespace Canteen.ITA.GeneralRateIncomePool

structure Facts where
  /-- C: the pool at the end of the preceding year (may be negative). -/
  priorPool : Int := 0
  /-- The year's Part I facts: taxable income, active business income, investment income, business limit. -/
  rates : CorporateRates.Facts
  /-- E (a): eligible dividends received in the year. -/
  eligibleReceived : Cents := 0
  /-- G: eligible dividends paid in the preceding year, and the excessive designations among them. -/
  eligiblePaidLastYear : Cents := 0
  excessiveLastYear : Cents := 0
  /-- Eligible dividends paid in the year. -/
  eligiblePaid : Cents := 0
  /-- (c): one of the main purposes was to artificially maintain or increase the pool. Usually a judgment call. -/
  artificial : Answer := .fact false
  deriving Repr, Inhabited

/-- "adjusted taxable income". -/
def adjustedTaxableIncome (f : Facts) : Cents :=
  f.rates.taxableIncome - CorporateRates.smallBusinessAmount f.rates -
    (if f.rates.ccpc then min f.rates.aggregateInvestmentIncome f.rates.taxableIncome else 0)

/-- "general rate income pool" at the end of the year. -/
def pool (f : Facts) : Int :=
  f.priorPool + ((adjustedTaxableIncome f * 72 / 100 : Nat) : Int) + (f.eligibleReceived : Int) -
    ((f.eligiblePaidLastYear - f.excessiveLastYear : Nat) : Int)

/-- "excessive eligible dividend designation", for all the year's eligible dividends together. -/
def excessive (f : Facts) : Cents :=
  if f.artificial.value then f.eligiblePaid else f.eligiblePaid - (pool f).toNat

/-- 185.1(1): Part III.1 tax. -/
def partIII1 (f : Facts) : Cents := excessive f * (if f.artificial.value then 30 else 20) / 100

/-- A 185.1(2) election: the amount claimed, and whether every shareholder who received the
dividend (and whose address the corporation knew) concurred (185.1(3)(a)). -/
structure Election where
  claimed : Cents
  concurrence : Bool := true
  deriving Repr, Inhabited

/-- The election is valid: not a (c) designation, and with the shareholders' concurrence. -/
def Election.valid (f : Facts) (e : Election) : Bool := !f.artificial.value && e.concurrence

/-- 185.1(2)(a), (b): the amount treated as a separate non-eligible dividend. -/
def elected (f : Facts) (e : Election) : Cents := if e.valid f then min e.claimed (excessive f) else 0

/-- 185.1(2)(a): the eligible dividends left after the election. -/
def eligibleAfter (f : Facts) (e : Election) : Cents := f.eligiblePaid - elected f e

/-- 185.1(1) after the election: the designation is excessive only by what was not elected. -/
def partIII1After (f : Facts) (e : Election) : Cents := partIII1 { f with eligiblePaid := eligibleAfter f e }

def explain (f : Facts) : Finding :=
  let c := formatCents
  let p := pool f
  ⟨excessive f > 0, [
    ⟨s!"Adjusted taxable income is {c (adjustedTaxableIncome f)}; 72% of it is added to the pool.", "ITA 89(1) \"adjusted taxable income\", \"general rate factor\""⟩,
    ⟨s!"The general rate income pool at year end is {if p < 0 then "−" else ""}{c p.natAbs}.", "ITA 89(1) \"general rate income pool\""⟩,
    ⟨s!"Eligible dividends of {c f.eligiblePaid} are paid; the excessive designation is {c (excessive f)}, and Part III.1 tax {c (partIII1 f)}.",
      "ITA 89(1) \"excessive eligible dividend designation\"; 185.1(1)"⟩], f.artificial.judgments⟩

/-! ## Truths about the pool -/

private theorem sub_sub_eq_min (a b : Nat) : a - (a - b) = min a b := by omega

/-- Eligible dividends within the pool are never excessive (absent an artificial purpose). -/
theorem within_pool (f : Facts) (ha : f.artificial.value = false) (h : (f.eligiblePaid : Int) ≤ pool f) : excessive f = 0 := by
  have h2 : f.eligiblePaid ≤ (pool f).toNat := (Int.le_toNat (Int.le_trans (Int.natCast_nonneg _) h)).mpr h
  unfold excessive
  simp only [ha, Bool.false_eq_true, ite_false]
  exact Nat.sub_eq_zero_of_le h2

/-- The excessive designation never exceeds the eligible dividends paid. -/
theorem excessive_le (f : Facts) : excessive f ≤ f.eligiblePaid := by
  unfold excessive; split
  · exact Nat.le_refl _
  · exact Nat.sub_le _ _

/-- Electing the whole excess leaves no Part III.1 tax, and exactly the pool designated eligible. -/
theorem full_election (f : Facts) (e : Election) (hv : e.valid f = true) (hc : excessive f ≤ e.claimed) :
    partIII1After f e = 0 ∧ eligibleAfter f e = min f.eligiblePaid (pool f).toNat := by
  have ha : f.artificial.value = false := by
    unfold Election.valid at hv; cases h : f.artificial.value <;> simp_all
  have hx : excessive f = f.eligiblePaid - (pool f).toNat := by
    unfold excessive; simp only [ha, Bool.false_eq_true, ite_false]
  have he : elected f e = excessive f := by
    unfold elected; simp only [hv, ite_true]; exact Nat.min_eq_right hc
  have hafter : eligibleAfter f e = min f.eligiblePaid (pool f).toNat := by
    unfold eligibleAfter; rw [he, hx]; exact sub_sub_eq_min _ _
  refine ⟨?_, hafter⟩
  unfold partIII1After
  have hz : excessive { f with eligiblePaid := eligibleAfter f e } = 0 := by
    unfold excessive
    simp only [ha, Bool.false_eq_true, ite_false]
    show eligibleAfter f e - (pool f).toNat = 0
    rw [hafter]; exact Nat.sub_eq_zero_of_le (Nat.min_le_right _ _)
  unfold partIII1; rw [hz]; simp

end Canteen.ITA.GeneralRateIncomePool

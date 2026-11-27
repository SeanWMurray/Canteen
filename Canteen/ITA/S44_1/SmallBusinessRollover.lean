import Canteen.Core.StatuteSyntax
import Canteen.Core.Answer
import Canteen.Core.Money
import Canteen.Core.Date

/-!
# Section 44.1: the small business investment rollover

*Income Tax Act*, as consolidated to 2026-10-29 (verbatim in `statute/ITA-44.1-1-2.txt`):

* **44.1(1) "qualifying disposition"** of an individual (not a trust): a disposition of shares each of
  which was (a) an eligible small business corporation share of the individual (a common share issued to
  the individual by an eligible small business corporation, its group's assets carried at no more than
  $100 million before and after), (b) throughout the individual's ownership, a share of an active business
  corporation, and (c) owned throughout the 185 days before the disposition.
* **"replacement share"** an eligible small business corporation share acquired in the year or the next
  calendar year, and designated in the return.
* **"permitted deferral"** (G/H) × I: G the lesser of the proceeds and the cost of the replacement shares,
  H the proceeds, I the capital gain. **"ACB reduction"** D × E/F: the permitted deferral, times the cost
  of a replacement share over the cost of all of them.
* **44.1(2)** (a) the capital gain is reduced by the permitted deferral; (b) the adjusted cost base of
  each replacement share is reduced by its ACB reduction.

Whether the shares were eligible small business corporation shares when issued, and the designation, are
facts; whether the corporation was an active business corporation throughout is often a judgment call.
Amounts are rounded down to the cent. Not encoded: 44.1(3) to (12) (deemed holdings, 44.1(9)'s
exclusions, and the related anti-avoidance), 44.1(2)(c).
-/

namespace Canteen.ITA.SmallBusinessRollover

structure Replacement where
  description : String
  cost : Cents
  /-- The calendar year it was acquired. -/
  acquiredIn : Nat
  /-- Designated in the return as a replacement share for this disposition. -/
  designated : Bool := true
  deriving Repr, DecidableEq, Inhabited

structure Facts where
  /-- (a): an eligible small business corporation share of the individual. -/
  eligibleShare : Bool := true
  /-- (b): throughout the individual's ownership, a share of an active business corporation. -/
  activeThroughout : Answer := .fact true
  /-- (c): when acquired and disposed of. -/
  acquired : Date
  disposed : Date
  /-- The individual is not a trust. -/
  notTrust : Bool := true
  proceeds : Cents
  /-- I: the capital gain, before 44.1(2). -/
  capitalGain : Cents
  replacements : List Replacement := []
  deriving Repr, Inhabited

/-- (c): owned throughout the 185 days before the disposition. -/
def held185 (f : Facts) : Bool := f.acquired.toDays + 185 ≤ f.disposed.toDays

/-- 44.1(1) "qualifying disposition". -/
statute qualifying (f : Facts) named "\"qualifying disposition\" (44.1(1))" cites "ITA 44.1(1)"
  applies where
    | "individual" f.notTrust
        => "The individual is not a trust."
        else "The taxpayer is a trust."
    | (a) f.eligibleShare
        => "Each share was an eligible small business corporation share of the individual."
        else "A share was not an eligible small business corporation share of the individual."
    | (b) judgments f.activeThroughout.judgments f.activeThroughout.value
        => "Throughout the individual's ownership, it was a share of an active business corporation."
        else "At some time while the individual owned it, it was not a share of an active business corporation."
    | (c) (held185 f)
        => "The individual owned it throughout the 185 days before the disposition."
        else "The individual did not own it throughout the 185 days before the disposition."

/-- The replacement shares: acquired in the year of the disposition or the next, and designated. -/
def replacementShares (f : Facts) : List Replacement :=
  f.replacements.filter fun r => r.designated && f.disposed.year ≤ r.acquiredIn && r.acquiredIn ≤ f.disposed.year + 1

def replacementCost (f : Facts) : Cents := ((replacementShares f).map (·.cost)).sum

/-- "permitted deferral": (G/H) × I. -/
def permittedDeferral (f : Facts) : Cents :=
  if qualifying.holds f && f.proceeds > 0 then min f.proceeds (replacementCost f) * f.capitalGain / f.proceeds else 0

/-- 44.1(2)(a): the capital gain after the deferral. -/
def capitalGainAfter (f : Facts) : Cents := f.capitalGain - permittedDeferral f

/-- "ACB reduction": D × E/F, for a replacement share. -/
def acbReduction (f : Facts) (r : Replacement) : Cents :=
  if replacementCost f = 0 then 0 else permittedDeferral f * r.cost / replacementCost f

def explain (f : Facts) : Finding :=
  let e := qualifying.explain f
  let c := formatCents
  ⟨e.conclusion, e.steps ++
    (if qualifying.holds f then
      [⟨s!"Of {c f.proceeds} of proceeds, {c (min f.proceeds (replacementCost f))} was reinvested in replacement shares: " ++
        s!"{c (permittedDeferral f)} of the {c f.capitalGain} gain is deferred, {c (capitalGainAfter f)} is taxed now.", "ITA 44.1(1), (2)"⟩]
     else []), e.reliesOn⟩

/-! ## Truths -/

/-- The deferral never exceeds the gain. -/
theorem deferral_le (f : Facts) : permittedDeferral f ≤ f.capitalGain := by
  unfold permittedDeferral; split
  · rename_i h
    have hp : 0 < f.proceeds := by simp at h; exact h.2
    exact Nat.div_le_of_le_mul (Nat.mul_le_mul_right _ (Nat.min_le_left _ _))
  · exact Nat.zero_le _

/-- Reinvesting all the proceeds defers all the gain. -/
theorem full_reinvestment (f : Facts) (h : qualifying.holds f = true) (hp : 0 < f.proceeds)
    (hr : f.proceeds ≤ replacementCost f) : permittedDeferral f = f.capitalGain := by
  simp [permittedDeferral, h, hp, Nat.min_eq_left hr, Nat.mul_div_cancel_left _ hp]

end Canteen.ITA.SmallBusinessRollover

import Canteen.ITA.S38.CapitalGains
import Canteen.Core.Date

/-!
# Subsection 104(4): the 21-year deemed disposition

*Income Tax Act*, as consolidated to 2026-10-29 (verbatim in `statute/ITA-104-4.txt`):

**104(4)** Every trust is deemed, at the end of each of certain days, to dispose of each capital property
(other than depreciable property and exempt property) and each land in the inventory of a business, for
its fair market value, and to reacquire it at that value. The days are (a) for a spousal or common-law
partner trust, an alter ego trust or a joint spousal or common-law partner trust, the day the spouse,
partner or taxpayer (the later of them, for a joint trust) dies; (b) for any other trust, the day 21 years
after the later of January 1, 1972 and the day the trust was created (with special rules for pre-1972
spousal trusts, (a.1), and for 1972 to 1991 transitional cases); and (c) every day 21 years after a day
under (a) to (c).

The trust's kind and dates are given. (a.1), (a.2) to (a.4) and the transitional parts of (b), the
104(5) rule for depreciable property, 104(5.8) (transfers between trusts), 70(5.3) and the 107(2)
distributions that avoid the rule (`TrustDistribution`) are not encoded here.
-/

namespace Canteen.ITA.TwentyOneYear

open CapitalGains (Disposition Year HalfCents)

inductive Kind where
  /-- (b): a trust created on the given day. -/
  | ordinary (created : Date)
  /-- (a): a spousal, alter ego or joint trust, with the day the (last) life beneficiary died, if they have. -/
  | lifeInterest (death : Option Date)
  deriving Repr, DecidableEq, Inhabited

def plusYears (d : Date) (n : Nat) : Date := { d with year := d.year + n }

/-- The first day under (a) or (b). -/
def firstDay : Kind → Option Date
  | .ordinary created => some (plusYears (if created.before ⟨1972, 1, 1⟩ then ⟨1972, 1, 1⟩ else created) 21)
  | .lifeInterest death => death

/-- The days in a given calendar year: the first day, or one 21, 42, ... years after it ((c)). -/
def dayIn (k : Kind) (year : Nat) : Option Date :=
  match firstDay k with
  | none => none
  | some d => if d.year ≤ year && (year - d.year) % 21 == 0 then some { d with year := year } else none

structure Holding where
  description : String
  fairMarketValue : Cents
  adjustedCostBase : Cents
  /-- Capital property other than depreciable property, or land in the inventory of a business. -/
  covered : Bool := true
  /-- Exempt property (property whose gain would be exempt for a non-resident beneficiary trust, 108(1)). -/
  exempt : Bool := false
  deriving Repr, DecidableEq, Inhabited

/-- The year's deemed dispositions. -/
def dispositions (k : Kind) (year : Nat) (hs : List Holding) : List Disposition :=
  match dayIn k year with
  | none => []
  | some d => (hs.filter fun h => h.covered && !h.exempt).map fun h =>
      { description := s!"{h.description} (deemed disposed of on {d}, 104(4))", proceeds := h.fairMarketValue, adjustedCostBase := h.adjustedCostBase }

def netTaxableGains (k : Kind) (year : Nat) (hs : List Holding) : HalfCents := (⟨dispositions k year hs, 0, {}⟩ : Year).paragraph3b

def explain (k : Kind) (year : Nat) (hs : List Holding) : Finding :=
  ⟨(dayIn k year).isSome, [match dayIn k year with
    | none => ⟨s!"No 104(4) day falls in {year}.", "ITA 104(4)"⟩
    | some d => ⟨s!"On {d} the trust is deemed to dispose of its capital property at its value and reacquire it: net taxable " ++
        s!"capital gains of {CapitalGains.formatHalfCents (netTaxableGains k year hs)}.", "ITA 104(4)"⟩], []⟩

/-! ## Truths -/

/-- An ordinary trust created after 1971 has its first day 21 years on, and no day before. -/
theorem ordinary_first (created : Date) (h : created.before ⟨1972, 1, 1⟩ = false) :
    firstDay (.ordinary created) = some (plusYears created 21) := by
  simp [firstDay, h]

theorem none_before (k : Kind) (d : Date) (year : Nat) (h : firstDay k = some d) (hy : year < d.year) : dayIn k year = none := by
  simp [dayIn, h, Nat.not_le.mpr hy]

/-- A spousal trust whose spouse is alive has no day. -/
theorem life_interest_alive (year : Nat) : dayIn (.lifeInterest none) year = none := rfl

end Canteen.ITA.TwentyOneYear

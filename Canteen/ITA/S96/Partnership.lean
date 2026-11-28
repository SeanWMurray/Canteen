import Canteen.Core.Money
import Canteen.Core.Finding

/-!
# Partnerships: 96(1) allocation, 53(1)(e) and 53(2)(c) cost adjustments, 40(3.1) and (3.12)

*Income Tax Act*, as consolidated to 2026-10-29 (verbatim in `statute/ITA-96-1-40-3.1-3.12.txt`):

**96(1)** A member's income is computed as if the partnership were a separate person resident in Canada,
its fiscal period its taxation year, each income, loss, taxable capital gain and allowable capital loss
computed for it, and (f), (g) the member's share of each included or deducted by the member.
**53(1)(e)** The adjusted cost base of the interest goes up by the member's share of income (with the
whole of capital gains, 53(1)(e)(i), (ii)) and contributions of capital (iv); **53(2)(c)** down by the share
of losses (with the whole of capital losses, (i), (ii)) and amounts received as drawings or distributions
of income or capital (v).

**40(3.1)** A limited partner, or a member who has been a specified member since becoming a member, with
a negative adjusted cost base (40(3.11)) at the end of a fiscal period has a gain of that amount; the
gain is added back to the cost (53(1)(a)). **40(3.12)** Later, a loss may be elected up to the earlier
40(3.1) gains not yet reversed, and the adjusted cost base then.

The partnership's incomes and losses by kind, and each member's share (by the agreement; 103 is not
encoded) are given; so are contributions, drawings, and whether the member is a limited or specified
member. The 1994 excluded-interest exception, 96(1.1) to (9), and the at-risk rules (96(2.1) to (2.7))
are not encoded.
-/

namespace Canteen.ITA.Partnership

structure Year where
  /-- Business and property income, and losses. -/
  income : Cents := 0
  losses : Cents := 0
  /-- Capital gains and losses (whole amounts; half of each is taxable or allowable). -/
  capitalGains : Cents := 0
  capitalLosses : Cents := 0
  deriving Repr, DecidableEq, Inhabited

structure Member where
  name : String
  /-- The member's share, in basis points of each amount. -/
  shareBp : Nat
  /-- Limited partner (or specified member since becoming a member). -/
  limited : Bool := false
  /-- The adjusted cost base at the start of the fiscal period (may be negative for a general partner). -/
  openingACB : Int := 0
  contributions : Cents := 0
  drawings : Cents := 0
  /-- 40(3.12): earlier 40(3.1) gains not yet reversed by a 40(3.12) loss. -/
  priorDeemedGains : Cents := 0
  deriving Repr, DecidableEq, Inhabited

def share (m : Member) (x : Cents) : Cents := x * m.shareBp / 10000

/-- 96(1)(f), (g): the member's income and losses, and taxable capital gains and allowable losses. -/
def Member.income (m : Member) (y : Year) : Cents := share m y.income
def Member.losses (m : Member) (y : Year) : Cents := share m y.losses
def Member.taxableCapitalGains (m : Member) (y : Year) : Cents := share m y.capitalGains / 2
def Member.allowableCapitalLosses (m : Member) (y : Year) : Cents := share m y.capitalLosses / 2

/-- 53(1)(e), 53(2)(c): the adjusted cost base at the end of the fiscal period, before 40(3.1). -/
def Member.acbBefore (m : Member) (y : Year) : Int :=
  m.openingACB + share m y.income + share m y.capitalGains + m.contributions - share m y.losses - share m y.capitalLosses - m.drawings

/-- 40(3.1): the deemed gain. -/
def Member.deemedGain (m : Member) (y : Year) : Cents := if m.limited then (-(m.acbBefore y)).toNat else 0

/-- The adjusted cost base after the 40(3.1) gain (53(1)(a)). -/
def Member.acbAfter (m : Member) (y : Year) : Int := m.acbBefore y + m.deemedGain y

/-- 40(3.12): the most that may be elected as a loss. -/
def Member.electableLoss (m : Member) (y : Year) : Cents := min m.priorDeemedGains (m.acbAfter y).toNat

def explain (m : Member) (y : Year) : Finding :=
  let c := formatCents
  ⟨m.deemedGain y > 0, [
    ⟨s!"{m.name}: a share of income {c (m.income y)}, losses {c (m.losses y)}, taxable capital gains {c (m.taxableCapitalGains y)} and " ++
      s!"allowable capital losses {c (m.allowableCapitalLosses y)}.", "ITA 96(1)(f), (g)"⟩,
    ⟨s!"The adjusted cost base of the interest at the end of the period: {m.acbBefore y} cents.", "ITA 53(1)(e); 53(2)(c)"⟩,
    ⟨if m.deemedGain y > 0 then s!"A limited partner with a negative cost: a gain of {c (m.deemedGain y)}, and the cost is reset to nil."
      else "No 40(3.1) gain.", "ITA 40(3.1), (3.11)"⟩], []⟩

/-! ## Truths -/

/-- A limited partner's adjusted cost base is never negative after 40(3.1). -/
theorem Member.limited_nonneg (m : Member) (y : Year) (h : m.limited = true) : 0 ≤ m.acbAfter y := by
  unfold Member.acbAfter Member.deemedGain; rw [h]; simp only [ite_true]; omega

/-- A general partner has no 40(3.1) gain. -/
theorem Member.general_no_gain (m : Member) (y : Year) (h : m.limited = false) : m.deemedGain y = 0 := by
  simp [Member.deemedGain, h]

end Canteen.ITA.Partnership

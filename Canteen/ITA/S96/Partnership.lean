import Canteen.Core.Money
import Canteen.Core.Finding

/-!
# Partnerships: 96(1) allocation, 53(1)(e) and 53(2)(c) cost adjustments, 40(3.1) and (3.12)

*Income Tax Act*, as consolidated to 2026-10-29 (verbatim in `statute/ITA-96-1-40-3.1-3.12.txt` and
`statute/ITA-96-2.1-2.3.txt`):

**96(1)** A member's income is computed as if the partnership were a separate person resident in Canada,
its fiscal period its taxation year, each income, loss, taxable capital gain and allowable capital loss
computed for it, and (f), (g) the member's share of each included or deducted by the member.
**53(1)(e)** The adjusted cost base of the interest goes up by the member's share of income (with the
whole of capital gains, 53(1)(e)(i), (ii)) and contributions of capital (iv); **53(2)(c)** down by the share
of losses (with the whole of capital losses, (i), (ii)) and amounts received as drawings or distributions
of income or capital (v).

**40(3.1)** A limited partner, or a member who has been a specified member since becoming a member, with
a negative adjusted cost base (40(3.11)) at the end of a fiscal period has a gain of that amount; the
gain is added back to the cost (53(1)(a)). At that time the period's own income and losses are not yet
in the cost (53(1)(e)(i), 53(2)(c)(i) count periods "ending before that time"), except for a professional
partnership (40(3.11) A(b), B(c)). **96(2.1), (2.2)** A limited partner's share of losses from business or
property is deductible only up to its at-risk amount (the cost, plus the period's income, less amounts
owing to the partnership and protections against loss); the rest is a limited partnership loss, carried
forward and kept out of the cost (53(2)(c)(i)) until deducted. **111(1)(e)** It is deductible in a later year
to the extent the at-risk amount at the end of that year's fiscal period exceeds the share of that
period's losses; then it comes off the cost (53(2)(c)(i.1)). **40(3.12)** Later, a loss may be elected up to the earlier
40(3.1) gains not yet reversed, and the adjusted cost base then.

The partnership's incomes and losses by kind, and each member's share (by the agreement; 103 is not
encoded) are given; so are contributions, drawings, and whether the member is a limited or specified
member. The 1994 excluded-interest exception, 96(1.1), (1.3) to (9), 96(2.3) (cost from a transferor), (2.4) to
(2.7), and the investment tax
credit and resource expense terms of 96(2.1)(b) are not encoded.
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
  /-- A member of a professional partnership (40(3.11) A(b), B(c): the period's income and losses count at its end). -/
  professional : Bool := false
  /-- The adjusted cost base at the start of the fiscal period (may be negative for a general partner). -/
  openingACB : Int := 0
  contributions : Cents := 0
  drawings : Cents := 0
  /-- 96(2.2)(c), (d): amounts owing to the partnership (or non-arm's length persons), and protections against loss. -/
  amountsOwing : Cents := 0
  protections : Cents := 0
  /-- 40(3.12): earlier 40(3.1) gains not yet reversed by a 40(3.12) loss. -/
  priorDeemedGains : Cents := 0
  /-- 111(1)(e): limited partnership losses of earlier years not yet deducted. -/
  lossesCarried : Cents := 0
  deriving Repr, DecidableEq, Inhabited

def share (m : Member) (x : Cents) : Cents := x * m.shareBp / 10000

/-- 96(1)(f), (g): the member's shares. -/
def Member.income (m : Member) (y : Year) : Cents := share m y.income
def Member.losses (m : Member) (y : Year) : Cents := share m y.losses
def Member.taxableCapitalGains (m : Member) (y : Year) : Cents := share m y.capitalGains / 2
def Member.allowableCapitalLosses (m : Member) (y : Year) : Cents := share m y.capitalLosses / 2

/-- The adjusted cost base at the end of the fiscal period, before 40(3.1): the period's income and losses
are not yet in it (53(1)(e)(i), 53(2)(c)(i) count periods ending before that time), except for a
professional partnership (40(3.11)); the period's contributions and drawings are. -/
def Member.acbBefore (m : Member) (y : Year) : Int :=
  m.openingACB + m.contributions - m.drawings +
    (if m.professional then (share m y.income : Int) + share m y.capitalGains - share m y.losses - share m y.capitalLosses else 0)

/-- 40(3.1): the deemed gain. -/
def Member.deemedGain (m : Member) (y : Year) : Cents := if m.limited then (-(m.acbBefore y)).toNat else 0

/-- The adjusted cost base after the 40(3.1) gain (53(1)(a)). -/
def Member.acbAfter (m : Member) (y : Year) : Int := m.acbBefore y + m.deemedGain y

/-- 96(2.2): the at-risk amount at the end of the period: the cost (without the period's income, which (b)
adds) plus the share of income, less amounts owing and protections. -/
def Member.atRisk (m : Member) (y : Year) : Cents :=
  ((if m.professional then m.acbAfter y - share m y.income else m.acbAfter y) + share m y.income - m.amountsOwing - m.protections).toNat

/-- 96(2.1): for a limited partner, losses (from business or property) deductible only up to the at-risk amount. -/
def Member.deductibleLoss (m : Member) (y : Year) : Cents := if m.limited then min (m.losses y) (m.atRisk y) else m.losses y

/-- 96(2.1)(e): the limited partnership loss, carried forward (111(1)(e)). -/
def Member.limitedPartnershipLoss (m : Member) (y : Year) : Cents := m.losses y - m.deductibleLoss y

/-- 111(1)(e): earlier limited partnership losses deductible this year: to the extent the at-risk amount
exceeds the share of the period's losses from business or property. -/
def Member.lplDeduction (m : Member) (y : Year) : Cents := min m.lossesCarried (m.atRisk y - m.losses y)

/-- The adjusted cost base at the start of the next period: with the period's income, whole capital gains,
the deductible part of its losses (53(2)(c)(i) excludes the limited partnership loss), whole capital
losses, and the earlier limited partnership losses deducted (53(2)(c)(i.1)). -/
def Member.nextOpening (m : Member) (y : Year) : Int :=
  (if m.professional then m.acbAfter y
   else m.acbAfter y + share m y.income + share m y.capitalGains - m.deductibleLoss y - share m y.capitalLosses) - m.lplDeduction y

/-- 40(3.12): the most that may be elected as a loss. -/
def Member.electableLoss (m : Member) (y : Year) : Cents := min m.priorDeemedGains (m.acbAfter y).toNat

def explain (m : Member) (y : Year) : Finding :=
  let c := formatCents
  ⟨m.deemedGain y > 0 || m.limitedPartnershipLoss y > 0, [
    ⟨s!"{m.name}: a share of income {c (m.income y)}, losses {c (m.losses y)}, taxable capital gains {c (m.taxableCapitalGains y)} and " ++
      s!"allowable capital losses {c (m.allowableCapitalLosses y)}.", "ITA 96(1)(f), (g)"⟩,
    ⟨s!"The adjusted cost base at the end of the period: {m.acbBefore y} cents" ++
      (if m.deemedGain y > 0 then s!"; negative, so a gain of {c (m.deemedGain y)} and the cost is reset to nil." else "."),
      "ITA 40(3.1), (3.11); 53(1)(e); 53(2)(c)"⟩,
    ⟨if m.limited then s!"At risk: {c (m.atRisk y)}; {c (m.deductibleLoss y)} of the losses deductible, {c (m.limitedPartnershipLoss y)} a limited partnership loss carried forward."
      else "Not a limited partner: the losses are deductible.", "ITA 96(2.1), (2.2)"⟩], []⟩

/-! ## Truths -/

/-- A limited partner's adjusted cost base is never negative after 40(3.1). -/
theorem Member.limited_nonneg (m : Member) (y : Year) (h : m.limited = true) : 0 ≤ m.acbAfter y := by
  unfold Member.acbAfter Member.deemedGain; rw [h]; simp only [ite_true]; omega

/-- A general partner has no 40(3.1) gain, and its losses are all deductible. -/
theorem Member.general_no_gain (m : Member) (y : Year) (h : m.limited = false) : m.deemedGain y = 0 := by
  simp [Member.deemedGain, h]

/-- A limited partner deducts no more than its at-risk amount; the rest carries forward. -/
theorem Member.at_risk_limit (m : Member) (y : Year) : m.deductibleLoss y + m.limitedPartnershipLoss y = m.losses y := by
  unfold Member.limitedPartnershipLoss
  exact Nat.add_sub_cancel' (by unfold Member.deductibleLoss; split <;> simp [Nat.min_le_left])

theorem Member.lplDeduction_le (m : Member) (y : Year) : m.lplDeduction y ≤ m.lossesCarried := Nat.min_le_left _ _

end Canteen.ITA.Partnership

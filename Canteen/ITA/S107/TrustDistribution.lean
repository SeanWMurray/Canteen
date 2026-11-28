import Canteen.Core.Money
import Canteen.Core.Finding

/-!
# Distributions of trust property: the rollover (107(2)), at value (107(2.1)), and 107(4.1)

*Income Tax Act*, as consolidated to 2026-10-29 (verbatim in `statute/ITA-107-2-2.1-4.1.txt`):

**107(2)** When a personal trust distributes property to a beneficiary in satisfaction of a capital
interest, (a) the trust is deemed to dispose of it for its cost amount; (b) the beneficiary acquires it
at that cost amount plus the specified percentage ((b.1): 100% for capital property other than
depreciable property, otherwise 50%) of the excess of the adjusted cost base of the capital interest over
its cost amount; (c) the beneficiary's proceeds for the interest are that cost (at 100%) less eligible
offsets.

**107(2.1)** Otherwise, the trust is deemed to dispose of the property at fair market value, and the
beneficiary to acquire it at that value.

**107(4.1)** (2.1) applies instead of (2) where (b) 75(2) applied at any time to property of the trust
(not since sold for fair market value), (c) the beneficiary is neither the person from whom the trust
received the property nor that person's spouse (to whom 73(1) would apply), and (d) that person is in
existence.

The cost amounts, values and the 75(2) history are given; 107(2.001), (2.002), (2.2), (4), (5) and
the depreciable property rules in 107(2)(d) to (f) are not encoded.
-/

namespace Canteen.ITA.TrustDistribution

structure Distribution where
  description : String
  /-- The property's cost amount to the trust, and its fair market value. -/
  trustCost : Cents
  fairMarketValue : Cents
  /-- Capital property other than depreciable property (the 100% specified percentage). -/
  nonDepreciableCapital : Bool := true
  /-- The capital interest given up: its adjusted cost base and cost amount to the beneficiary. -/
  interestACB : Cents := 0
  interestCostAmount : Cents := 0
  /-- 107(2)(c): eligible offsets (debts the beneficiary assumes, and the like). -/
  eligibleOffset : Cents := 0
  personalTrust : Bool := true
  /-- 107(4.1)(b): 75(2) applied at some time to the trust's property, not since disposed of at fair market value. -/
  section75_2Applied : Bool := false
  /-- 107(4.1)(c): the beneficiary is the contributor, or the contributor's spouse or common-law partner. -/
  toContributorOrSpouse : Bool := false
  /-- 107(4.1)(d): the contributor is in existence. -/
  contributorExists : Bool := true
  deriving Repr, DecidableEq, Inhabited

/-- 107(4.1). -/
def Distribution.tainted (d : Distribution) : Bool := d.section75_2Applied && !d.toContributorOrSpouse && d.contributorExists

/-- 107(2) applies. -/
def Distribution.rollover (d : Distribution) : Bool := d.personalTrust && !d.tainted

def Distribution.specifiedPercentage (d : Distribution) : Nat := if d.nonDepreciableCapital then 100 else 50

/-- The trust's proceeds. -/
def Distribution.trustProceeds (d : Distribution) : Cents := if d.rollover then d.trustCost else d.fairMarketValue

/-- The trust's gain (or nothing on a loss). -/
def Distribution.trustGain (d : Distribution) : Cents := d.trustProceeds - d.trustCost

/-- The beneficiary's cost of the property. -/
def Distribution.beneficiaryCost (d : Distribution) : Cents :=
  if d.rollover then d.trustCost + (d.interestACB - d.interestCostAmount) * d.specifiedPercentage / 100 else d.fairMarketValue

/-- 107(2)(c): the beneficiary's proceeds for the capital interest. -/
def Distribution.interestProceeds (d : Distribution) : Cents :=
  if d.rollover then (d.trustCost + (d.interestACB - d.interestCostAmount)) - d.eligibleOffset else d.fairMarketValue

def explain (d : Distribution) : Finding :=
  let c := formatCents
  ⟨d.rollover,
    [if d.rollover then ⟨s!"{d.description}: distributed at its cost amount to the trust, {c d.trustCost}; the beneficiary's cost is " ++
        s!"{c d.beneficiaryCost}. The trust has no gain.", "ITA 107(2)(a), (b)"⟩
     else if d.tainted then ⟨s!"{d.description}: 75(2) applied to the trust's property and the beneficiary is not the contributor or " ++
        s!"the contributor's spouse, so there is no rollover: the trust disposes of it at its value, {c d.fairMarketValue}, " ++
        s!"a gain of {c d.trustGain}.", "ITA 107(4.1); 107(2.1)"⟩
     else ⟨s!"{d.description}: not a personal trust; distributed at its value, {c d.fairMarketValue}.", "ITA 107(2.1)"⟩], []⟩

/-! ## Truths -/

theorem Distribution.no_gain_on_rollover (d : Distribution) (h : d.rollover = true) : d.trustGain = 0 := by
  simp [Distribution.trustGain, Distribution.trustProceeds, h]

theorem Distribution.tainted_at_value (d : Distribution) (h : d.tainted = true) :
    d.trustProceeds = d.fairMarketValue ∧ d.beneficiaryCost = d.fairMarketValue := by
  simp [Distribution.trustProceeds, Distribution.beneficiaryCost, Distribution.rollover, h]

/-- Back to the contributor: 107(4.1) never applies. -/
theorem Distribution.to_contributor (d : Distribution) (h : d.toContributorOrSpouse = true) : d.tainted = false := by
  simp [Distribution.tainted, h]

end Canteen.ITA.TrustDistribution

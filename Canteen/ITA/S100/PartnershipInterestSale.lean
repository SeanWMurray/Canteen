import Canteen.Core.Money
import Canteen.Core.Finding

/-!
# Subsection 100(1): selling a partnership interest to a tax-exempt or non-resident person

*Income Tax Act*, as consolidated to 2026-10-29 (verbatim in `statute/ITA-100-1-1.1.txt`):

**100(1)** If, as part of a transaction or series, a taxpayer disposes of a partnership interest and an
interest is acquired by a person or partnership in (1.1)(a) to (d), the taxable capital gain is (a) ½ of
the part of the capital gain reasonably attributable to increases in value of the partnership's capital
property other than depreciable property (directly or through other partnerships), plus (b) the whole of
the rest. **100(1.1)** The acquirers: (a) a person exempt under 149; (b) a non-resident; (c) a partnership,
and (d) a trust (other than a mutual fund trust), to the extent of such persons behind it.

Whether the acquirer is such a person, the 100(1.2) exceptions (for a non-resident, where the
partnership's property is used in a business carried on in Canada, and the 10% thresholds), and the part
of the gain attributable to non-depreciable capital property are given. 100(2) to (5) are not encoded.
-/

namespace Canteen.ITA.PartnershipInterestSale

structure Facts where
  /-- The capital gain on the disposition of the interest. -/
  gain : Cents
  /-- (a): the part reasonably attributable to increases in value of non-depreciable capital property. -/
  attributableToCapitalProperty : Cents
  /-- 100(1.1): an interest is acquired, as part of the series, by such a person or partnership. -/
  exemptOrNonResidentAcquirer : Bool
  /-- 100(1.2): an exception applies. -/
  exception : Bool := false
  deriving Repr, DecidableEq, Inhabited

def applies (f : Facts) : Bool := f.exemptOrNonResidentAcquirer && !f.exception

/-- The capital property part, at most the gain. -/
def capitalPart (f : Facts) : Cents := min f.attributableToCapitalProperty f.gain

/-- The taxable capital gain: 100(1) where it applies, otherwise half (38(a)). -/
def taxableGain (f : Facts) : Cents := if applies f then capitalPart f / 2 + (f.gain - capitalPart f) else f.gain / 2

def explain (f : Facts) : Finding :=
  let c := formatCents
  ⟨applies f, [if applies f then
      ⟨s!"The interest goes to a tax-exempt or non-resident person: half of the {c (capitalPart f)} attributable to capital property, " ++
        s!"and all of the other {c (f.gain - capitalPart f)}: a taxable capital gain of {c (taxableGain f)}.", "ITA 100(1), (1.1)"⟩
    else ⟨s!"A taxable capital gain of half the {c f.gain} gain, {c (taxableGain f)}.", "ITA 38(a)"⟩], []⟩

/-! ## Truths -/

private theorem lower (g c : Nat) (h : c ≤ g) : g / 2 ≤ c / 2 + (g - c) := by omega
private theorem upper (g c : Nat) (h : c ≤ g) : c / 2 + (g - c) ≤ g := by omega

/-- Never less than the ordinary half, nor more than the whole gain. -/
theorem half_le (f : Facts) : f.gain / 2 ≤ taxableGain f := by
  unfold taxableGain; split
  · exact lower _ _ (Nat.min_le_right _ _)
  · exact Nat.le_refl _

theorem le_gain (f : Facts) : taxableGain f ≤ f.gain := by
  unfold taxableGain; split
  · exact upper _ _ (Nat.min_le_right _ _)
  · exact Nat.div_le_self _ _

/-- All of the gain from capital property: no difference. -/
theorem all_capital (f : Facts) (h : f.gain ≤ f.attributableToCapitalProperty) : taxableGain f = f.gain / 2 := by
  have : capitalPart f = f.gain := Nat.min_eq_right h
  unfold taxableGain; split <;> simp [this]

end Canteen.ITA.PartnershipInterestSale

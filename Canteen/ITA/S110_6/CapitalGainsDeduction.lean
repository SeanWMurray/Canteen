import Canteen.Core.StatuteSyntax
import Canteen.Core.Answer
import Canteen.ITA.S38.CapitalGains

/-!
# Subsections 110.6(2) and (2.1): the capital gains deduction

*Income Tax Act*, as consolidated to 2026-10-29 (verbatim in
`statute/ITA-110.6-capital-gains-deduction.txt`):

**110.6(1) "qualified small business corporation share"** of an individual at the determination
time: a share that (a) at that time is a share of a small business corporation owned by the
individual, the individual's spouse or common-law partner or a partnership related to the
individual, (b) throughout the 24 months before was not owned by anyone other than the individual
or a person or partnership related to the individual, and (c) throughout the part of those 24
months it was so owned, was a share of a Canadian-controlled private corporation more than 50% of
the fair market value of whose assets was attributable to (i) assets used principally in an active
business carried on primarily in Canada by it or a related corporation, (ii) shares or debt of
connected corporations meeting (A) and (B), or (iii) both; with (d) to (f) for tiers and
substituted shares.

**"annual gains limit"** for a year: A − B, A the lesser of (a) the 3(b) amount and (b) the 3(b)
amount if the only properties were qualified farm or fishing property and qualified small business
corporation shares; B (a) the net capital losses deducted under 111(1)(b) for the year, less the
excess of the 3(b) amount over A, plus (b) the year's allowable business investment losses.

**"cumulative gains limit"** at the end of a year: the A amounts for the year and preceding years
ending after 1984, less (b) the B amounts for them, (c) the 3(e) deduction for 1985, (d) amounts
deducted under 110.6 for preceding years, and (e) the cumulative net investment loss at year end.

**110.6(2.1)** an individual (not a trust) resident in Canada throughout the year who disposed of
qualified small business corporation shares in the year or a preceding year (after June 17, 1987)
may deduct up to the least of (a) the amount under the formula in (2)(a), [$625,000 − (A + B + C +
D)] × E (E being 1 for a current year), (b) the cumulative gains limit less the year's 110.6(2)
deduction, (c) the annual gains limit less that deduction, and (d) the 3(b) amount if the only
properties were the individual's qualified small business corporation shares.

The $625,000 is indexed for years beginning after 2025 (117.1(2)(c)); the indexed amount is given.
A + B + C + D (earlier deductions, with the pre-2000 weights) is given, as are the earlier years'
A and B amounts, the 1985 3(e) amount and the cumulative net investment loss. The "small business
corporation" test (248(1): all or substantially all of the assets' value attributable to active
business assets and the like) is a fact or a judgment call.

**"qualified farm or fishing property"** and **110.6(1.3)**: real property or a fishing vessel used
in a farming or fishing business in Canada by the family (or its farm or fishing corporation or
partnership), a share of a family farm or fishing corporation, an interest in a family farm or
fishing partnership, or Class 14.1 property so used; real property and Class 14.1 property must
also have been owned by the family for 24 months and either used principally in a business in which
a family member was actively engaged, with farming or fishing gross revenue exceeding other income
in two years, or used by the family corporation or partnership for 24 months. **110.6(2)** allows the
same deduction for those gains. (2.1)(a) is read as what is left of the one lifetime limit after the
year's 110.6(2) deduction, as the prescribed form computes it.

Not encoded: (d) to (f) of the share definition, the definitions of family farm or fishing
corporation and partnership (facts), 110.6(1.3)(c) (property acquired before June 18, 1987), the
2024 additional deduction (110.6(2.2), (2.3)), 110.6(7) to (11) (denials), and the alternative
minimum tax.
-/

namespace Canteen.ITA.CapitalGainsDeduction

open CapitalGains (HalfCents Year Disposition formatHalfCents)

/-! ## Qualified small business corporation shares -/

/-- The corporation's assets for part of the 24 months the share was held by the individual or a
related person or partnership. -/
structure AssetPeriod where
  /-- A label, e.g. `"2024"`. -/
  label : String
  canadianControlledPrivate : Bool := true
  /-- (c)(i)–(iii): the fair market value of active business assets and qualifying connected shares and debt. -/
  qualifyingAssets : Cents
  totalAssets : Cents
  deriving Repr, DecidableEq, Inhabited

/-- (c): a Canadian-controlled private corporation, more than 50% of its asset value qualifying. -/
def AssetPeriod.meets (p : AssetPeriod) : Bool := p.canadianControlledPrivate && p.totalAssets < 2 * p.qualifyingAssets

structure ShareFacts where
  /-- The share, e.g. `"common shares of Opco"`. -/
  description : String
  /-- (a): a share of a small business corporation (248(1)) at the determination time. Often a
  judgment call ("all or substantially all"). -/
  smallBusinessCorporation : Answer
  /-- (a): owned by the individual, the individual's spouse or common-law partner, or a partnership related to the individual. -/
  ownedByFamily : Bool := true
  /-- (b): throughout the 24 months before, owned by no one other than the individual or a related person or partnership. -/
  relatedOwnership24Months : Bool := true
  /-- (c): the corporation's assets for each part of the 24 months the share was so held. -/
  periods : List AssetPeriod
  /-- (e): any share it was substituted for in the 24 months met (b) and (c) until the substitution. -/
  substitutionMet : Bool := true
  deriving Repr, Inhabited

/-- Section 110.6(1) "qualified small business corporation share". -/
statute qualifiedShare (s : ShareFacts) named "the definition \"qualified small business corporation share\""
    cites "ITA 110.6(1) \"qualified small business corporation share\""
  applies where
    | (a) judgments s.smallBusinessCorporation.judgments (s.smallBusinessCorporation.value && s.ownedByFamily)
        => "At the determination time it is a share of a small business corporation owned by the individual, the individual's spouse or common-law partner, or a related partnership."
        else "At the determination time it is not a share of a small business corporation owned by the individual, a spouse or common-law partner, or a related partnership."
    | (b) s.relatedOwnership24Months
        => "Throughout the 24 months before, no one but the individual or a related person or partnership owned it."
        else "In the 24 months before, someone other than the individual or a related person or partnership owned it."
    | (c) (s.periods.all AssetPeriod.meets)
        => "Throughout the part of the 24 months it was so owned, the corporation was a Canadian-controlled private corporation more than 50% of whose assets' value was in active business assets or qualifying connected shares and debt."
        else "For part of the 24 months, the corporation was not a Canadian-controlled private corporation with more than 50% of its assets' value in active business assets or qualifying connected shares and debt."
    | (e) s.substitutionMet
        => "Any share it was substituted for met paragraphs (b) and (c) up to the substitution."
        else "A share it was substituted for did not meet paragraphs (b) and (c) up to the substitution."

/-! ## Qualified farm or fishing property -/

/-- What the property is, for the definition "qualified farm or fishing property". -/
inductive FarmPropertyKind where
  /-- (a): real or immovable property, or a fishing vessel, used in a farming or fishing business in
  Canada by the individual, a spouse, child or parent, a family farm or fishing corporation or partnership. -/
  | realPropertyOrVessel
  /-- (b): a share of a family farm or fishing corporation of the individual or spouse. -/
  | familyCorporationShare
  /-- (c): an interest in a family farm or fishing partnership of the individual or spouse. -/
  | familyPartnershipInterest
  /-- (d): Class 14.1 property (goodwill, quotas) so used. -/
  | class14_1
  | other
  deriving Repr, DecidableEq, Inhabited

structure FarmPropertyFacts where
  description : String
  kind : FarmPropertyKind
  /-- Owned by the individual, the spouse, or a family farm or fishing partnership. -/
  ownedByFamily : Bool := true
  /-- (a), (d): used in a farming or fishing business carried on in Canada by one of the persons in (a)(i) to (v). -/
  usedInCanadianFarmingOrFishing : Bool := true
  /-- (1.3)(a)(i): owned by the family for the 24 months before. -/
  owned24Months : Bool := true
  /-- (1.3)(a)(ii)(A): in at least two years, the operator's farming or fishing gross revenue exceeded its other
  income, and the property was used principally in a business in which a family member was actively engaged
  on a regular and continuous basis (often a judgment call). -/
  grossRevenueTest : Answer := .fact false
  /-- (1.3)(a)(ii)(B): used for 24 months by a family farm or fishing corporation or partnership, a family
  member actively engaged. -/
  corporateUse24Months : Bool := false
  deriving Repr, Inhabited

/-- (1.3) applies to real property, vessels and Class 14.1 property, not shares or partnership interests. -/
def FarmPropertyFacts.needs1_3 (p : FarmPropertyFacts) : Bool :=
  p.kind == .realPropertyOrVessel || p.kind == .class14_1

/-- Section 110.6(1) "qualified farm or fishing property", with 110.6(1.3). -/
statute qualifiedFarmProperty (p : FarmPropertyFacts) named "the definition \"qualified farm or fishing property\""
    cites "ITA 110.6(1) \"qualified farm or fishing property\""
  applies where
    | "owned" p.ownedByFamily
        => "It is owned by the individual, the individual's spouse or common-law partner, or a family farm or fishing partnership."
        else "It is not owned by the individual, a spouse or common-law partner, or a family farm or fishing partnership."
    | "(a) to (d)" (p.kind != .other && (!p.needs1_3 || p.usedInCanadianFarmingOrFishing))
        => "It is farm or fishing real property or a vessel, a family farm or fishing corporation share, a family partnership interest, or Class 14.1 property, used as the definition requires."
        else "It is not property of a kind in paragraphs (a) to (d), used as they require."
    | "(1.3)" judgments (if p.needs1_3 && p.owned24Months && !p.corporateUse24Months then p.grossRevenueTest.judgments else [])
        (!p.needs1_3 || (p.owned24Months && (p.grossRevenueTest.value || p.corporateUse24Months)))
        => "It was owned by the family for 24 months, and used principally in a farming or fishing business with a family member actively engaged (or used by a family corporation or partnership) as 110.6(1.3) requires."
        else "It does not meet the ownership and use conditions of 110.6(1.3)."

/-! ## The deduction -/

structure Facts where
  taxationYear : Nat
  /-- An individual other than a trust, resident in Canada throughout the year. -/
  residentIndividual : Bool := true
  /-- The year's capital gains computation (all dispositions). -/
  year : Year
  /-- The year's dispositions of qualified small business corporation shares (part of `year`). -/
  qualifying : List Disposition
  /-- The year's dispositions of qualified farm or fishing property (part of `year`). -/
  farmOrFishing : List Disposition := []
  /-- The indexed amount for 110.6(2)(a), in cents ($625,000 for years beginning before 2026). -/
  limit : Cents := 62500000
  /-- 110.6(2)(a) A + B + C + D: earlier 110.6 deductions, with the pre-2000 weights. -/
  priorWeighted : HalfCents := 0
  /-- "cumulative gains limit" (d): all amounts deducted under 110.6 for preceding years. -/
  priorDeductions : HalfCents := 0
  /-- "annual gains limit" A and B for preceding years ending after 1984. -/
  priorA : HalfCents := 0
  priorB : HalfCents := 0
  /-- "cumulative gains limit" (c): the 3(e) deduction for 1985. -/
  deduction1985 : HalfCents := 0
  /-- "cumulative gains limit" (e): the cumulative net investment loss at the end of the year. -/
  cumulativeNetInvestmentLoss : HalfCents := 0
  /-- Net capital losses of other years deducted under 111(1)(b) for the year. -/
  netCapitalLossesDeducted : HalfCents := 0
  deriving Repr, Inhabited

/-- The 3(b) amount if the only properties were those given. -/
def paragraph3bOf (ds : List Disposition) : HalfCents := Year.paragraph3b ⟨ds, 0, {}⟩

/-- "annual gains limit" A. -/
def annualA (f : Facts) : HalfCents := min f.year.paragraph3b (paragraph3bOf (f.qualifying ++ f.farmOrFishing))

/-- "annual gains limit" B. -/
def annualB (f : Facts) : HalfCents :=
  (f.netCapitalLossesDeducted - (f.year.paragraph3b - annualA f)) + f.year.allowableBusinessInvestmentLosses

def annualGainsLimit (f : Facts) : HalfCents := annualA f - annualB f

def cumulativeGainsLimit (f : Facts) : HalfCents :=
  (f.priorA + annualA f) - (f.priorB + annualB f + f.deduction1985 + f.priorDeductions + f.cumulativeNetInvestmentLoss)

/-- (2.1)(a): the formula in (2)(a), what is left of the lifetime limit. -/
def remainingLimit (f : Facts) : HalfCents := 2 * f.limit - f.priorWeighted

/-- (2.1)(d): the 3(b) amount from qualified small business corporation shares alone. -/
def sharesAmount (f : Facts) : HalfCents := paragraph3bOf f.qualifying

/-- (2)(d): the 3(b) amount from qualified farm or fishing property alone. -/
def farmAmount (f : Facts) : HalfCents := paragraph3bOf f.farmOrFishing

/-- Subsection 110.6(2): the most the individual may deduct for qualified farm or fishing property. -/
def farmFishingDeduction (f : Facts) : HalfCents :=
  if f.residentIndividual && !f.farmOrFishing.isEmpty then
    min (remainingLimit f) (min (cumulativeGainsLimit f) (min (annualGainsLimit f) (farmAmount f)))
  else 0

/-- Subsection 110.6(2.1): the most the individual may deduct for qualified small business
corporation shares, after the 110.6(2) deduction. -/
def deduction (f : Facts) : HalfCents :=
  if f.residentIndividual && !f.qualifying.isEmpty then
    min (remainingLimit f - farmFishingDeduction f) (min (cumulativeGainsLimit f - farmFishingDeduction f)
      (min (annualGainsLimit f - farmFishingDeduction f) (sharesAmount f)))
  else 0

/-- The year's whole capital gains deduction: 110.6(2) and (2.1). -/
def total (f : Facts) : HalfCents := farmFishingDeduction f + deduction f

def explain (f : Facts) : Finding :=
  let h := formatHalfCents
  if !(f.residentIndividual && !f.qualifying.isEmpty) then
    ⟨deduction f > 0, [⟨"The individual was not resident in Canada throughout the year, is a trust, or disposed of no qualified " ++
      "small business corporation shares, so nothing may be deducted under subsection 110.6(2.1).", "ITA 110.6(2.1)"⟩], []⟩
  else
  ⟨deduction f > 0, [
    ⟨s!"(a) What is left of the lifetime limit: {h (2 * f.limit)} less earlier deductions of {h f.priorWeighted}, {h (remainingLimit f)}" ++
      (if farmFishingDeduction f > 0 then s!", less this year's 110.6(2) deduction." else "."),
      "ITA 110.6(2.1)(a), (2)(a)"⟩,
    ⟨s!"(b) The cumulative gains limit, {h (cumulativeGainsLimit f)}" ++
      (if farmFishingDeduction f > 0 then s!", less the 110.6(2) deduction of {h (farmFishingDeduction f)}." else "."),
      "ITA 110.6(2.1)(b); 110.6(1) \"cumulative gains limit\""⟩,
    ⟨s!"(c) The annual gains limit, {h (annualA f)} less {h (annualB f)}, {h (annualGainsLimit f)}" ++
      (if farmFishingDeduction f > 0 then s!", less the 110.6(2) deduction." else "."),
      "ITA 110.6(2.1)(c); 110.6(1) \"annual gains limit\""⟩,
    ⟨s!"(d) The 3(b) amount from qualified small business corporation shares alone, {h (sharesAmount f)}.", "ITA 110.6(2.1)(d)"⟩,
    ⟨s!"So the individual may deduct up to {h (deduction f)}, the least of these.", "ITA 110.6(2.1)"⟩], []⟩

/-- Subsection 110.6(2.1), as a rule: something may be deducted. -/
def rule : Rule Facts where
  name := "subsection 110.6(2.1)"
  citation := "ITA 110.6(2.1)"
  holds := fun f => deduction f > 0
  explain := explain
  sound := fun f => by unfold explain; split <;> rfl

/-! ## Truths about the deduction -/

theorem deduction_le_shares (f : Facts) : deduction f ≤ sharesAmount f := by
  unfold deduction; split
  · exact Nat.le_trans (Nat.min_le_right _ _) (Nat.le_trans (Nat.min_le_right _ _) (Nat.min_le_right _ _))
  · exact Nat.zero_le _

private theorem stack (p a b L : Nat) (ha : a ≤ L - p) (hb : b ≤ (L - p) - a) (h : p ≤ L) : p + (a + b) ≤ L := by omega

/-- **One lifetime limit.** The 110.6(2) and (2.1) deductions together never take the lifetime total
past the limit. -/
theorem lifetime_limit (f : Facts) (h : f.priorWeighted ≤ 2 * f.limit) :
    f.priorWeighted + total f ≤ 2 * f.limit := by
  have ha : farmFishingDeduction f ≤ remainingLimit f := by
    unfold farmFishingDeduction; split
    · exact Nat.min_le_left _ _
    · exact Nat.zero_le _
  have hb : deduction f ≤ remainingLimit f - farmFishingDeduction f := by
    unfold deduction; split
    · exact Nat.min_le_left _ _
    · exact Nat.zero_le _
  unfold remainingLimit at ha hb
  exact stack _ _ _ _ ha hb h

/-- The deduction never exceeds the annual gains limit: losses and ABILs of the year come first. -/
theorem deduction_le_annual (f : Facts) : deduction f ≤ annualGainsLimit f := by
  unfold deduction; split
  · exact Nat.le_trans (Nat.min_le_right _ _) (Nat.le_trans (Nat.min_le_right _ _)
      (Nat.le_trans (Nat.min_le_left _ _) (Nat.sub_le _ _)))
  · exact Nat.zero_le _

private theorem sub_add_le (a d g : Nat) (h1 : d ≤ g) (h2 : a ≤ g - d) : d + a ≤ g := by omega

/-- Both deductions together never exceed the annual gains limit. -/
theorem total_le_annual (f : Facts) : total f ≤ annualGainsLimit f := by
  have h1 : farmFishingDeduction f ≤ annualGainsLimit f := by
    unfold farmFishingDeduction; split
    · exact Nat.le_trans (Nat.min_le_right _ _) (Nat.le_trans (Nat.min_le_right _ _) (Nat.min_le_left _ _))
    · exact Nat.zero_le _
  have h2 : deduction f ≤ annualGainsLimit f - farmFishingDeduction f := by
    unfold deduction; split
    · exact Nat.le_trans (Nat.min_le_right _ _) (Nat.le_trans (Nat.min_le_right _ _) (Nat.min_le_left _ _))
    · exact Nat.zero_le _
  exact sub_add_le _ _ _ h1 h2

private theorem min_mono_right (a b c : Nat) (h : b ≤ c) : min a b ≤ min a c :=
  Nat.le_min.mpr ⟨Nat.min_le_left _ _, Nat.le_trans (Nat.min_le_right _ _) h⟩

/-- A cumulative net investment loss reduces the deduction for shares, never increases it, in a
year with no qualified farm or fishing property. (With one, a smaller 110.6(2) deduction can leave
more room for 110.6(2.1).) -/
theorem cnil_never_helps (f : Facts) (c : HalfCents) (h : f.cumulativeNetInvestmentLoss ≤ c) (hf : f.farmOrFishing = []) :
    deduction { f with cumulativeNetInvestmentLoss := c } ≤ deduction f := by
  have hc : cumulativeGainsLimit { f with cumulativeNetInvestmentLoss := c } ≤ cumulativeGainsLimit f := by
    unfold cumulativeGainsLimit annualB annualA; simp only
    exact Nat.sub_le_sub_left (Nat.add_le_add_left h _) _
  have h0 : farmFishingDeduction f = 0 := by simp [farmFishingDeduction, hf]
  have h0' : farmFishingDeduction { f with cumulativeNetInvestmentLoss := c } = 0 := by simp [farmFishingDeduction, hf]
  unfold deduction; simp only [h0, h0', Nat.sub_zero]
  split
  · refine min_mono_right _ _ _ ?_
    exact Nat.le_min.mpr ⟨Nat.le_trans (Nat.min_le_left _ _) hc, Nat.min_le_right _ _⟩
  · exact Nat.le_refl _

end Canteen.ITA.CapitalGainsDeduction

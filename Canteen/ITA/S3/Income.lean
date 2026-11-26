import Canteen.ITA.S38.CapitalGains
import Canteen.Core.Argument

/-!
# Section 3: income for the year

*Income Tax Act*, section 3, as consolidated to 2026-10-29 (verbatim in `statute/ITA-3-38-41.txt`):

> (a) determine the total of all amounts each of which is the taxpayer's income for the year
> (other than a taxable capital gain from the disposition of a property) from a source …,
> (b) determine the amount, if any, by which (i) the total of (A) all of the taxpayer's taxable
> capital gains for the year from dispositions of property other than listed personal property,
> and (B) the taxpayer's taxable net gain for the year from dispositions of listed personal
> property, exceeds (ii) the amount, if any, by which the taxpayer's allowable capital losses for
> the year from dispositions of property other than listed personal property exceed the
> taxpayer's allowable business investment losses for the year,
> (c) … plus the amount determined under paragraph (b) exceeds the total of the deductions
> permitted by Subdivision E …,
> (d) … exceeds the total of all amounts each of which is the taxpayer's loss for the year from
> an office, employment, business or property or the taxpayer's allowable business investment
> loss for the year, …
> (e) where an amount is determined under paragraph (d) … the taxpayer's income for the year is
> the amount so determined, and (f) in any other case, … zero.

Paragraph (b) is computed from the year's dispositions (`CapitalGains`). Income from other
sources, Subdivision E deductions, and losses from sources are given as amounts. All amounts are
kept in half-cents, so nothing is rounded.
-/

namespace Canteen.ITA.Income

open CapitalGains

/-- A taxpayer's year, for section 3. Amounts other than capital gains and losses are in cents. -/
structure Facts where
  /-- 3(a): income from each office, employment, business, property and other source. -/
  incomeFromSources : Cents := 0
  /-- 3(b): the dispositions. -/
  capital : Year := ⟨[], 0, {}⟩
  /-- 3(c): deductions permitted by Subdivision E. -/
  subdivisionE : Cents := 0
  /-- 3(d): losses from an office, employment, business or property. -/
  sourceLosses : Cents := 0
  deriving Repr, Inhabited

def paraA (f : Facts) : HalfCents := 2 * f.incomeFromSources
def paraB (f : Facts) : HalfCents := f.capital.paragraph3b
def paraC (f : Facts) : HalfCents := paraA f + paraB f - 2 * f.subdivisionE
def paraD (f : Facts) : HalfCents :=
  paraC f - (2 * f.sourceLosses + f.capital.allowableBusinessInvestmentLosses)

/-- 3(e), (f): the taxpayer's income for the year, in half-cents (never below zero). -/
def income (f : Facts) : HalfCents := paraD f

/-- The computation, step by step, as a numbered argument. -/
def report (f : Facts) : Argument :=
  let y := f.capital
  let h := formatHalfCents
  let perDisposition := y.dispositions.flatMap fun d =>
    let head := if d.lossNil then s!"{d.description}: the loss is nil (paragraph 40(2)(g) or (e.1), or subsection 40(3.4) or (3.6))"
      else if d.gain > 0 then s!"{d.description}: a gain of {formatCents d.gain}"
      else if d.loss > 0 then s!"{d.description}: a loss of {formatCents d.loss}"
      else s!"{d.description}: no gain or loss"
    let cls :=
      if d.lossNil then "so there is no capital loss"
      else if d.isListed then "listed personal property, pooled under section 41"
      else if !d.capitalAccount.value then "not on capital account, so not a capital gain or loss"
      else if d.propertyClass == .excluded then "a kind excluded by 39(1)(a)(i.1) to (v)"
      else if d.gain > 0 then
        if d.giftToQualifiedDonee then s!"a capital gain; a gift to a qualified donee, so the taxable capital gain is nil"
        else s!"a capital gain, of which ½, {h d.taxableCapitalGain}, is a taxable capital gain"
      else if d.capitalLoss > 0 then
        s!"a capital loss, of which ½, {h d.allowableCapitalLoss}, is an allowable capital loss" ++
          (if d.businessInvestment then s!" (and {h d.allowableBusinessInvestmentLoss} an allowable business investment loss)" else "")
      else if d.propertyClass == .depreciable && d.loss > 0 then "depreciable property, so no capital loss"
      else "nothing to include"
    let judgment := if d.capitalAccount.judgments.isEmpty then "" else
      s!" (capital account: judgment call {", ".intercalate d.capitalAccount.judgments})"
    let reserve := if d.reserveClaimed > 0 then
      [(⟨s!"A reserve of {formatCents (min d.reserveClaimed d.reserveLimit)} is claimed (at most " ++
        s!"{formatCents d.reserveLimit}).", "ITA 40(1)(a)(iii)"⟩ : Step)] else []
    [(⟨s!"{head}: {cls}{judgment}.", "ITA 40(1); 39(1); 38"⟩ : Step)] ++ reserve
  let lpp : List Step := if y.listed.isEmpty then [] else
    [⟨s!"Listed personal property: gains less losses {formatCents y.lppExcess}; after losses of other years claimed, a " ++
      s!"net gain of {formatCents y.lppNetGain}, of which ½, {h y.lppTaxableNetGain}, is the taxable net gain" ++
      (if y.lppLoss > 0 then s!"; and a listed-personal-property loss of {formatCents y.lppLoss}, which can be claimed " ++
        "only against listed-personal-property gains of the 3 preceding and 7 following years." else "."), "ITA 41"⟩]
  let steps : List Step := perDisposition ++ lpp ++ [
    ⟨s!"Paragraph 3(a), income from sources other than taxable capital gains: {h (paraA f)}.", "ITA 3(a)"⟩,
    ⟨s!"Paragraph 3(b): taxable capital gains {h y.taxableCapitalGains} and taxable net gain from listed personal " ++
      s!"property {h y.lppTaxableNetGain}, less allowable capital losses {h y.allowableCapitalLosses} in excess of " ++
      s!"allowable business investment losses {h y.allowableBusinessInvestmentLosses}: {h (paraB f)}.", "ITA 3(b)"⟩,
    ⟨s!"Paragraph 3(c), less Subdivision E deductions of {formatCents f.subdivisionE}: {h (paraC f)}.", "ITA 3(c)"⟩,
    ⟨s!"Paragraph 3(d), less losses from sources of {formatCents f.sourceLosses} and allowable business investment " ++
      s!"losses of {h y.allowableBusinessInvestmentLosses}: {h (paraD f)}.", "ITA 3(d)"⟩,
    ⟨s!"So the taxpayer's income for the year is {h (income f)}.", "ITA 3(e), (f)"⟩] ++
    (if y.unusedAllowableCapitalLosses > 0 then
      [⟨s!"Allowable capital losses of {h y.unusedAllowableCapitalLosses} could not be used this year: they are part of " ++
        "the year's net capital loss, deductible against taxable capital gains of other years.", "ITA 3(b); 111(8), (1)(b)"⟩] else [])
  let js := y.dispositions.foldl (fun ids d => mergeIds ids d.capitalAccount.judgments) []
  ⟨steps, js⟩

/-! ## Truths about section 3 -/

/-- Paragraph 3(b) never makes income negative: capital losses reduce only capital gains. With
no business investment losses, income is at least what it would be with no dispositions. -/
theorem capital_losses_only_offset_gains (f : Facts) (h : f.capital.allowableBusinessInvestmentLosses = 0) :
    income { f with capital := ⟨[], 0, {}⟩ } ≤ income f := by
  have hb : Year.paragraph3b ⟨[], 0, {}⟩ = 0 := rfl
  have habil : Year.allowableBusinessInvestmentLosses ⟨[], 0, {}⟩ = 0 := rfl
  simp only [income, paraD, paraC, paraB, paraA, hb, habil, h]
  exact Nat.sub_le_sub_right (Nat.sub_le_sub_right (Nat.add_le_add_left (Nat.zero_le _) _) _) _

/-- An allowable business investment loss is deducted against any income, under 3(d). -/
theorem abil_reduces_income (f : Facts) :
    income f ≤ paraC f - f.capital.allowableBusinessInvestmentLosses := by
  simp only [income, paraD]
  exact Nat.sub_le_sub_left (Nat.le_add_left _ _) _

end Canteen.ITA.Income

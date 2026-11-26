import Canteen.ITA.S117.Rates

/-!
# Subsections 118(1) and (1.1): the basic personal and spouse amounts

*Income Tax Act*, as consolidated to 2026-10-29 (verbatim in `statute/ITA-118-1-1.1.txt`):

**118(1)** An individual may deduct from tax A × B: A the appropriate percentage (the lowest rate in
117(2), 14%), and B the total of (a) for a married individual (or one in a common-law partnership)
supporting a spouse not living apart because of a breakdown, the basic personal amount plus C + C.01
− C.1 (C $2,150 if the spouse is dependent because of infirmity, C.01 the basic personal amount, C.1
the spouse's income), or (c) otherwise, the basic personal amount; and the other amounts.

**118(1.1)** The basic personal amount is A + B: A $12,298; B = C − C × E, C being F − A with F
$15,000 for 2023 and later; E nil if the individual's income is at most the 117(2)(d) threshold,
otherwise the lesser of 1 and (H − I) / J (H the income, I that threshold, J the 117(2)(e) threshold
less I).

The dollar amounts are indexed under 117.1(1) (and the 2020 to 2022 values of F are in the text); the
indexed amounts for the year are given, defaulting to the text's. The enhancement is rounded down to
the cent. Not encoded: 118(1)(b), (b.1), (d), (e) and the rest of 118.
-/

namespace Canteen.ITA.PersonalCredits

structure Amounts where
  /-- 118(1.1) A (indexed). -/
  base : Cents := 1229800
  /-- 118(1.1) F (indexed). -/
  enhanced : Cents := 1500000
  /-- 118(1)(a) C: the infirm spouse amount (indexed). -/
  infirm : Cents := 215000
  deriving Repr, DecidableEq, Inhabited

structure Facts where
  /-- The individual's income for the year, in cents. -/
  income : Cents
  /-- 118(1)(a): married or in a common-law partnership, supporting the spouse, not living apart. -/
  supportsSpouse : Bool := false
  spouseIncome : Cents := 0
  spouseInfirm : Bool := false
  amounts : Amounts := {}
  brackets : Rates.Brackets := {}
  deriving Repr, DecidableEq, Inhabited

/-- 118(1.1) C: the enhancement at its fullest. -/
def enhancement (f : Facts) : Cents := f.amounts.enhanced - f.amounts.base

/-- 118(1.1) B: the enhancement, phased out between the 117(2)(d) and (e) thresholds. -/
def enhancementAllowed (f : Facts) : Cents :=
  let j := f.brackets.fourth - f.brackets.third
  if j = 0 then 0 else enhancement f * (j - min (f.income - f.brackets.third) j) / j

/-- 118(1.1): the basic personal amount. -/
def basicPersonalAmount (f : Facts) : Cents := f.amounts.base + enhancementAllowed f

/-- 118(1) B: (a) for a supporting spouse, or (c) the basic personal amount. -/
def amountB (f : Facts) : Cents :=
  if f.supportsSpouse then
    basicPersonalAmount f + ((if f.spouseInfirm then f.amounts.infirm else 0) + basicPersonalAmount f - f.spouseIncome)
  else basicPersonalAmount f

/-- 118(1): the credit, A × B, at the lowest rate (14%). -/
def credit (f : Facts) : Cents := amountB f * 1400 / 10000

def explain (f : Facts) : Finding :=
  let c := formatCents
  ⟨true, [
    ⟨s!"The basic personal amount is {c f.amounts.base} plus {c (enhancementAllowed f)} of the {c (enhancement f)} enhancement " ++
      s!"(on income of {c f.income}): {c (basicPersonalAmount f)}.", "ITA 118(1.1)"⟩] ++
    (if f.supportsSpouse then
      [⟨s!"A spouse or common-law partner with income of {c f.spouseIncome} adds {c (amountB f - basicPersonalAmount f)}.", "ITA 118(1)(a)"⟩]
    else []) ++
    [⟨s!"The credit is 14% of {c (amountB f)}: {c (credit f)}.", "ITA 118(1); 248(1) \"appropriate percentage\""⟩], []⟩

/-! ## Truths about the credits -/

private theorem add_le_of (a e E : Nat) (h : a ≤ E) (he : e ≤ E - a) : a + e ≤ E := by omega

theorem enhancementAllowed_le (f : Facts) : enhancementAllowed f ≤ enhancement f := by
  unfold enhancementAllowed; simp only
  split
  · exact Nat.zero_le _
  · exact Nat.div_le_of_le_mul (by rw [Nat.mul_comm (f.brackets.fourth - f.brackets.third)]; exact Nat.mul_le_mul_left _ (Nat.sub_le _ _))

/-- The basic personal amount is never below the base amount, nor above the enhanced amount. -/
theorem bpa_between (f : Facts) (h : f.amounts.base ≤ f.amounts.enhanced) :
    f.amounts.base ≤ basicPersonalAmount f ∧ basicPersonalAmount f ≤ f.amounts.enhanced :=
  ⟨Nat.le_add_right _ _, add_le_of _ _ _ h (enhancementAllowed_le f)⟩

/-- At or below the 117(2)(d) threshold, the whole enhancement. -/
theorem full_below (f : Facts) (h : f.income ≤ f.brackets.third) (hj : f.brackets.third < f.brackets.fourth) :
    basicPersonalAmount f = f.amounts.base + enhancement f := by
  have hz : f.income - f.brackets.third = 0 := Nat.sub_eq_zero_of_le h
  have hpos : 0 < f.brackets.fourth - f.brackets.third := Nat.sub_pos_of_lt hj
  simp only [basicPersonalAmount, enhancementAllowed, hz, Nat.zero_min, Nat.sub_zero, Nat.pos_iff_ne_zero.mp hpos, ite_false,
    Nat.mul_div_cancel _ hpos]

end Canteen.ITA.PersonalCredits

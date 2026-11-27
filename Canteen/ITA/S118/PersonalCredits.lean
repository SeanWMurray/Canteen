import Canteen.ITA.S117.Rates
import Canteen.Core.StatuteSyntax

/-!
# Subsections 118(1) and (1.1): the basic personal and spouse amounts

*Income Tax Act*, as consolidated to 2026-10-29 (verbatim in `statute/ITA-118-1-1.1.txt`):

**118(1)** An individual may deduct from tax A × B: A the appropriate percentage (the lowest rate in
117(2), 14%), and B the total of (a) for a married individual (or one in a common-law partnership)
supporting a spouse not living apart because of a breakdown, the basic personal amount plus C + C.01
− C.1 (C $2,150 if the spouse is dependent because of infirmity, C.01 the basic personal amount, C.1
the spouse's income), (b) for an individual not claiming (a), (i) unmarried (or married but neither
supporting, living with nor supported by the spouse), (ii) maintaining a self-contained domestic
establishment in which they live and actually support a person who is (A) resident in Canada (unless
the individual's child), (B) wholly dependent on them, (C) related to them, and (D) under 18 or
dependent because of infirmity (unless a parent or grandparent): the basic personal amount plus
D + D.01 − D.1 (D $2,150 if the dependant is infirm, D.01 the basic personal amount, D.1 the
dependant's income), or (c) otherwise, the basic personal amount; and the other amounts.

**118(1.1)** The basic personal amount is A + B: A $12,298; B = C − C × E, C being F − A with F
$15,000 for 2023 and later; E nil if the individual's income is at most the 117(2)(d) threshold,
otherwise the lesser of 1 and (H − I) / J (H the income, I that threshold, J the 117(2)(e) threshold
less I).

The dollar amounts are indexed under 117.1(1) (and the 2020 to 2022 values of F are in the text); the
indexed amounts for the year are given, defaulting to the text's. The enhancement is rounded down to
the cent. 118(4)(a), (b) (one claim, one claimant) are left to the facts. (b.1)'s
conditions (living with both parents, or (b) claimable) are one fact per child: the count given. (d)'s
dependants are given apart from the (a) or (b) person, for whom (e) applies (118(4)(c)). Not encoded:
the rest of 118.
-/

namespace Canteen.ITA.PersonalCredits

structure Amounts where
  /-- 118(1.1) A (indexed). -/
  base : Cents := 1229800
  /-- 118(1.1) F (indexed). -/
  enhanced : Cents := 1500000
  /-- 118(1)(a) C, (b) D, (b.1): the infirmity amount (indexed). -/
  infirm : Cents := 215000
  /-- 118(1)(d): the Canada caregiver amount, and the income threshold (indexed). -/
  caregiver : Cents := 688300
  caregiverThreshold : Cents := 1616300
  deriving Repr, DecidableEq, Inhabited

/-- 118(1)(b): the person the individual supports, and the individual's circumstances. -/
structure Dependant where
  /-- (i): unmarried and not in a common-law partnership, or neither supporting, living with nor
  supported by the spouse. -/
  single : Bool := true
  /-- (ii): maintains a self-contained domestic establishment, lives in it, and actually supports the person there. -/
  maintainsHome : Bool := true
  /-- (A): resident in Canada, or the individual's child. -/
  residentOrChild : Bool := true
  /-- (B): wholly dependent for support on the individual (alone or with others). -/
  whollyDependent : Bool := true
  /-- (C): related to the individual. -/
  related : Bool := true
  /-- (D): under 18, dependent because of infirmity, or a parent or grandparent. -/
  minorInfirmOrParent : Bool := true
  /-- D: dependent because of mental or physical infirmity ($2,150 more). -/
  infirm : Bool := false
  /-- 18 or over at the end of the year (for (d) and (e)). -/
  adult : Bool := false
  income : Cents := 0
  deriving Repr, DecidableEq, Inhabited

/-- Paragraph 118(1)(b). -/
statute eligibleDependant (d : Dependant) named "paragraph 118(1)(b)" cites "ITA 118(1)(b)"
  applies where
    | (i) d.single
        => "The individual is unmarried, or neither supports, lives with nor is supported by their spouse."
        else "The individual is married and supports, lives with or is supported by their spouse."
    | (ii) d.maintainsHome
        => "The individual maintains a self-contained domestic establishment, lives in it and supports the person there."
        else "The individual does not maintain a home in which they live and support the person."
    | "(A)" d.residentOrChild
        => "The person is resident in Canada, or is the individual's child."
        else "The person is neither resident in Canada nor the individual's child."
    | "(B)" d.whollyDependent
        => "The person is wholly dependent for support on the individual."
        else "The person is not wholly dependent for support on the individual."
    | "(C)" d.related
        => "The person is related to the individual."
        else "The person is not related to the individual."
    | "(D)" d.minorInfirmOrParent
        => "The person is under 18, dependent because of infirmity, or a parent or grandparent."
        else "The person is 18 or over, not infirm, and not a parent or grandparent."

structure Facts where
  /-- The individual's income for the year, in cents. -/
  income : Cents
  /-- 118(1)(a): married or in a common-law partnership, supporting the spouse, not living apart. -/
  supportsSpouse : Bool := false
  spouseIncome : Cents := 0
  spouseInfirm : Bool := false
  /-- 118(1)(b): a person the individual supports, if no (a) claim is made. -/
  dependant : Option Dependant := none
  /-- 118(1)(b.1): the individual's infirm children under 18 who qualify (living with both parents, or
  for whom (b) is or could be claimed). -/
  infirmChildren : Nat := 0
  /-- 118(1)(d): the incomes of other persons dependent on the individual because of infirmity, 18 or
  over (not the spouse or eligible dependant, for whom (e) applies; 118(4)(c)). -/
  caregiverDependants : List Cents := []
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

/-- 118(1)(b) applies to the year. -/
def dependantClaim (f : Facts) : Bool := !f.supportsSpouse && f.dependant.any eligibleDependant.holds

/-- 118(1) B: (a) for a supporting spouse, (b) for an eligible dependant, or (c) the basic personal amount. -/
def amountCore (f : Facts) : Cents :=
  if f.supportsSpouse then
    basicPersonalAmount f + ((if f.spouseInfirm then f.amounts.infirm else 0) + basicPersonalAmount f - f.spouseIncome)
  else match f.dependant with
    | some d => if eligibleDependant.holds d then
        basicPersonalAmount f + ((if d.infirm then f.amounts.infirm else 0) + basicPersonalAmount f - d.income)
      else basicPersonalAmount f
    | none => basicPersonalAmount f

/-- 118(1)(d): $6,883 (indexed) less the dependant's income over $16,163 (indexed). -/
def caregiverAmount (f : Facts) (income : Cents) : Cents := f.amounts.caregiver - (income - f.amounts.caregiverThreshold)

/-- 118(1)(e): where the person in (a) or (b) is also an infirm adult dependant, what (d) would give
over what (a) or (b) gives. -/
def topUp (f : Facts) : Cents :=
  if f.supportsSpouse then
    (if f.spouseInfirm then caregiverAmount f f.spouseIncome - (amountCore f - basicPersonalAmount f) else 0)
  else match f.dependant with
    | some d => if eligibleDependant.holds d && d.infirm && d.adult then
        caregiverAmount f d.income - (amountCore f - basicPersonalAmount f) else 0
    | none => 0

/-- (b.1), (d) and (e). -/
def caregiverAmounts (f : Facts) : Cents :=
  f.infirmChildren * f.amounts.infirm + (f.caregiverDependants.map (caregiverAmount f)).sum + topUp f

/-- 118(1) B: the total. -/
def amountB (f : Facts) : Cents := amountCore f + caregiverAmounts f

/-- 118(1): the credit, A × B, at the lowest rate (14%). -/
def credit (f : Facts) : Cents := amountB f * 1400 / 10000

def explain (f : Facts) : Finding :=
  let c := formatCents
  ⟨true, [
    ⟨s!"The basic personal amount is {c f.amounts.base} plus {c (enhancementAllowed f)} of the {c (enhancement f)} enhancement " ++
      s!"(on income of {c f.income}): {c (basicPersonalAmount f)}.", "ITA 118(1.1)"⟩] ++
    (if f.supportsSpouse then
      [⟨s!"A spouse or common-law partner with income of {c f.spouseIncome} adds {c (amountB f - basicPersonalAmount f)}.", "ITA 118(1)(a)"⟩]
    else if dependantClaim f then
      [⟨s!"An eligible dependant adds {c (amountCore f - basicPersonalAmount f)}.", "ITA 118(1)(b)"⟩]
    else []) ++
    (if caregiverAmounts f > 0 then
      [⟨s!"Infirm children and dependants (and any top-up for an infirm spouse or dependant) add {c (caregiverAmounts f)}.",
        "ITA 118(1)(b.1), (d), (e)"⟩] else []) ++
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

/-- 118(1)(b) never gives more than twice the basic personal amount plus the infirmity amount. -/
theorem dependant_le (f : Facts) (d : Dependant) (h : f.supportsSpouse = false) (hd : f.dependant = some d) :
    amountCore f ≤ basicPersonalAmount f + (f.amounts.infirm + basicPersonalAmount f) := by
  simp only [amountCore, h, hd, Bool.false_eq_true, ite_false]
  split
  · refine Nat.add_le_add_left (Nat.le_trans (Nat.sub_le _ _) (Nat.add_le_add_right ?_ _)) _
    split
    · exact Nat.le_refl _
    · exact Nat.zero_le _
  · exact Nat.le_add_right _ _

/-- The (d) amount never exceeds the caregiver amount, and is nil once the dependant's income passes the
threshold by the full amount. -/
theorem caregiver_le (f : Facts) (i : Cents) : caregiverAmount f i ≤ f.amounts.caregiver := Nat.sub_le _ _

end Canteen.ITA.PersonalCredits

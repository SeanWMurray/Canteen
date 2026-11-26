import Canteen.Core.StatuteSyntax
import Canteen.Core.Answer
import Canteen.Core.Date
import Canteen.Core.Money

/-!
# The principal residence exemption: 40(2)(b) and section 54 "principal residence"

*Income Tax Act*, as consolidated to 2026-10-29 (verbatim in
`statute/ITA-40-2-b-54-principal-residence.txt`), for an individual other than a personal trust.

**Section 54 "principal residence"** of a taxpayer for a taxation year: a housing unit (or a
leasehold interest in one, or a qualifying co-operative housing share) owned in the year by the
taxpayer, if (a) it was ordinarily inhabited in the year by the taxpayer, the taxpayer's spouse or
common-law partner or former one, or a child of the taxpayer, or (b) the taxpayer elected under
45(2) or 45(3); except that (c) it is not the principal residence for the year unless the taxpayer
designated it for the year and no other property was designated for the year (i) before 1982, by
the taxpayer, or (ii) after 1981, by the taxpayer, a spouse or common-law partner throughout the
year (unless living apart under a judicial separation or written separation agreement), an
unmarried minor child, or, where the taxpayer was an unmarried minor, a mother or father or an
unmarried minor brother or sister; nor (d) because of paragraph (b), if solely because of (b) it
would have been the principal residence for 4 or more preceding taxation years.

**40(2)(b)** the gain is A − A × B / C − D: A the gain otherwise; B one plus (if resident in Canada
in the acquisition year) the number of taxation years ending after the acquisition date for which
the property is the principal residence and the taxpayer was resident in Canada; C the number of
taxation years ending after the acquisition date during which the taxpayer owned it; D for the
1994 election under 110.6(19) (given).

Not encoded: personal trusts ((a.1), (c.1)); 40(2)(c) (farm land); section 54.1. A × B / C is
rounded down to the cent (so the gain is rounded up).
-/

namespace Canteen.ITA.PrincipalResidence

/-- Who else designated another property as principal residence for a year. -/
inductive Designator where
  /-- The taxpayer, for another property. -/
  | taxpayer
  /-- A spouse or common-law partner throughout the year; `separated` if living apart under a
  judicial separation or written separation agreement throughout the year. -/
  | spouse (separated : Bool)
  /-- A child; `marriedOr18` if at any time in the year married, in a common-law partnership, or 18 or older. -/
  | child (marriedOr18 : Bool)
  | parent
  /-- A brother or sister; `marriedOr18` as for a child. -/
  | sibling (marriedOr18 : Bool)
  deriving Repr, DecidableEq, Inhabited

/-- One taxation year ending after the acquisition date. -/
structure YearFacts where
  year : Nat
  /-- The taxpayer owned the property in the year (alone or jointly). -/
  owned : Bool := true
  residentInCanada : Bool := true
  /-- (a) Ordinarily inhabited in the year by the taxpayer, the taxpayer's spouse or common-law
  partner or former one, or a child of the taxpayer. Often a judgment call (for example, a cottage). -/
  inhabited : Answer := .fact true
  /-- (b) An election under 45(2) or 45(3) (change in use) covers the year. -/
  changeInUseElection : Bool := false
  /-- (c) The taxpayer designated the property for the year. -/
  designated : Bool := false
  /-- Other properties designated for the year, and by whom. -/
  otherDesignations : List Designator := []
  /-- The taxpayer was at any time in the year married, in a common-law partnership, or 18 or older. -/
  taxpayerMarriedOr18 : Bool := true
  deriving Repr, DecidableEq, Inhabited

structure Facts where
  description : String
  /-- A housing unit, a leasehold interest in one, or a share of a co-operative housing
  corporation acquired for the sole purpose of acquiring the right to inhabit a unit it owns. -/
  housingUnit : Bool := true
  acquisitionDate : Date
  /-- Resident in Canada during the year that includes the acquisition date. -/
  residentInAcquisitionYear : Bool := true
  /-- Each taxation year ending after the acquisition date, to the year of disposition. -/
  years : List YearFacts
  /-- A: the gain, but for 40(2)(b). -/
  gain : Nat
  /-- D: the amount for a 1994 election under 110.6(19). -/
  election1994 : Nat := 0
  deriving Repr, DecidableEq, Inhabited

/-- (c): another designation for the year that blocks this one. -/
def blocks (y : YearFacts) (d : Designator) : Bool :=
  if y.year ≤ 1981 then d == .taxpayer
  else match d with
    | .taxpayer => true
    | .spouse separated => !separated
    | .child marriedOr18 => !marriedOr18
    | .parent => !y.taxpayerMarriedOr18
    | .sibling marriedOr18 => !y.taxpayerMarriedOr18 && !marriedOr18

/-- A property and one of its years, for the definition. -/
structure Query where
  facts : Facts
  year : YearFacts
  deriving Inhabited

/-- (d): the preceding years in which the property would have been the principal residence (but
for paragraph (d)) with an election under 45(2) or (3) covering the year, and designated and not
blocked; `solely` keeps only those not ordinarily inhabited, so that (b) alone made them one. -/
def electionYearsBefore (q : Query) (solely : Bool) : List YearFacts :=
  q.facts.years.filter fun y => y.year < q.year.year && q.facts.housingUnit && y.owned && y.changeInUseElection &&
    y.designated && !(y.otherDesignations.any (blocks y)) && (!solely || !y.inhabited.value)

/-- (d) applies to the year: it would be the principal residence solely because of (b), and it would
have been solely because of (b) for 4 or more preceding years. -/
def paraD (q : Query) : Bool :=
  q.year.changeInUseElection && !q.year.inhabited.value && 4 ≤ (electionYearsBefore q true).length

/-- The judgment calls (d) turns on: whether the year and the preceding election years were
ordinarily inhabited, once there are enough election years for (d) to matter. -/
def paraDJudgments (q : Query) : List String :=
  if q.year.changeInUseElection && 4 ≤ (electionYearsBefore q false).length then
    (q.year :: electionYearsBefore q false).foldl (fun ids y => mergeIds ids y.inhabited.judgments) []
  else []

/-- Section 54 "principal residence", for an individual and a taxation year. -/
statute principalResidence (q : Query) named "the definition \"principal residence\"" cites "ITA 54 \"principal residence\""
  applies where
    | "housing unit" q.facts.housingUnit
        => "The property is a housing unit, a leasehold interest in one, or a qualifying co-operative housing share."
        else "The property is not a housing unit, a leasehold interest in one, or a qualifying co-operative housing share."
    | "owned" q.year.owned
        => "The taxpayer owned it in the year."
        else "The taxpayer did not own it in the year."
    | "(a), (b)" judgments (if q.year.changeInUseElection then [] else q.year.inhabited.judgments)
        (q.year.inhabited.value || q.year.changeInUseElection)
        => "It was ordinarily inhabited in the year by the taxpayer, the taxpayer's spouse or common-law partner or former one, or a child of the taxpayer, or an election under 45(2) or 45(3) covers the year."
        else "It was not ordinarily inhabited in the year by the taxpayer, a spouse or common-law partner or former one, or a child, and no election under 45(2) or 45(3) covers the year."
    | "(c) designation" q.year.designated
        => "The taxpayer designated it as principal residence for the year."
        else "The taxpayer did not designate it for the year."
  except where
    | "(c) other designations" (q.year.otherDesignations.any (blocks q.year))
        => "Another property was designated for the year by the taxpayer or a member of the taxpayer's family unit."
        else "No other property was designated for the year by the taxpayer or a member of the taxpayer's family unit."
    | "(d)" judgments (paraDJudgments q) (paraD q)
        => "It was not ordinarily inhabited in the year, and it would be the principal residence for the year solely because of a 45(2) or 45(3) election, as it would have been for 4 or more preceding years."
        else "Paragraph (d) does not apply: the year is not a fifth or later year that only a 45(2) or 45(3) election would make the principal residence."

/-- Whether the property is the principal residence for a year. -/
def isPR (f : Facts) (y : YearFacts) : Bool := principalResidence.holds ⟨f, y⟩

/-- B: one plus (if resident in the acquisition year) the principal residence years while resident. -/
def b (f : Facts) : Nat :=
  (if f.residentInAcquisitionYear then 1 else 0) + (f.years.filter fun y => isPR f y && y.residentInCanada).length

/-- C: the years owned. -/
def c (f : Facts) : Nat := (f.years.filter (·.owned)).length

/-- The exempt portion, A × B / C (all of A once B ≥ C), rounded down. -/
def exempt (f : Facts) : Nat :=
  if c f = 0 then 0 else min f.gain (f.gain * b f / c f)

/-- 40(2)(b): the gain, A − A × B / C − D. -/
def gain (f : Facts) : Nat := f.gain - exempt f - f.election1994

def explain (f : Facts) : Finding :=
  let yearSteps := f.years.map fun y =>
    let e := principalResidence.explain ⟨f, y⟩
    let why := (e.steps.filter (·.claim.startsWith "The taxpayer did not") ++ e.steps.filter (·.claim.startsWith "Another") ++
      e.steps.filter (·.claim.startsWith "It was not")).head?.map (·.claim) |>.getD ""
    (⟨if e.conclusion then s!"{y.year}: the principal residence" ++ (if y.residentInCanada then "." else ", but the taxpayer was not resident in Canada.")
      else s!"{y.year}: not the principal residence. {why}", "ITA 54 \"principal residence\""⟩ : Step)
  let js := f.years.foldl (fun ids y => mergeIds ids (principalResidence.explain ⟨f, y⟩).reliesOn) []
  ⟨gain f == 0, yearSteps ++ [
    ⟨s!"B is {b f} ({if f.residentInAcquisitionYear then "one, plus " else ""}the principal residence years while resident); " ++
      s!"C is {c f}, the years owned.", "ITA 40(2)(b)"⟩,
    ⟨s!"Of the gain of {formatCents f.gain}, A × B / C = {formatCents (exempt f)} is exempt" ++
      (if f.election1994 > 0 then s!", and D is {formatCents f.election1994}" else "") ++
      s!", so the gain is {formatCents (gain f)}.", "ITA 40(2)(b)"⟩], js⟩

/-- Paragraph 40(2)(b), as a rule: the whole gain is exempt. -/
def rule : Rule Facts where
  name := "the principal residence exemption"
  citation := "ITA 40(2)(b)"
  holds := fun f => gain f == 0
  explain := explain
  sound := fun _ => rfl

/-! ## Truths about the exemption -/

/-- The exemption never exceeds the gain. -/
theorem exempt_le (f : Facts) : exempt f ≤ f.gain := by
  unfold exempt; split
  · exact Nat.zero_le _
  · exact Nat.min_le_left _ _

/-- **The "plus one" rule.** If B is at least C (for example, every year but one is the principal
residence, and the taxpayer was resident in the acquisition year), the whole gain is exempt. -/
theorem exempt_of_b_ge_c (f : Facts) (hc : 0 < c f) (h : c f ≤ b f) (hd : f.election1994 = 0) : gain f = 0 := by
  have : f.gain ≤ f.gain * b f / c f := by
    apply (Nat.le_div_iff_mul_le hc).mpr
    exact Nat.mul_le_mul_left _ h
  simp only [gain, exempt, Nat.pos_iff_ne_zero.mp hc, ite_false, Nat.min_eq_left this, Nat.sub_self, hd]

/-- Never designated, never exempt (beyond the "plus one" year). -/
theorem b_le_one_of_none_designated (f : Facts) (h : ∀ y ∈ f.years, y.designated = false) : b f ≤ 1 := by
  have : (f.years.filter fun y => isPR f y && y.residentInCanada) = [] := by
    rw [List.filter_eq_nil_iff]
    intro y hy
    simp [isPR, principalResidence, h y hy]
  simp only [b, this, List.length_nil, Nat.add_zero]
  split <;> omega

end Canteen.ITA.PrincipalResidence

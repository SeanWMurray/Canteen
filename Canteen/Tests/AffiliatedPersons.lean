import Canteen.ITA.S251_1.AffiliatedPersons
import Canteen.ITA.S251_1.Affiliation

/-!
# Tests: section 251.1, paragraphs (a) to (g)

One small world per paragraph or subparagraph, with the expected answer from the statute
text. Every answer is checked by Lean's kernel (`decide +kernel`, which adds no axioms), and
every world's relation is checked to be closed: one more round of the paragraphs adds nothing.
These are constructed examples, not published CRA examples or decided cases.
-/

namespace Canteen.Tests.AffiliatedPersons

open Canteen Canteen.ITA Canteen.ITA.AffiliatedPersons

def ind (i : Nat) (n : String) : Person := ⟨i, n, .individual⟩
def corp (i : Nat) (n : String) : Person := ⟨i, n, .corporation⟩
def pship (i : Nat) (n : String) : Person := ⟨i, n, .partnership⟩
def trust (i : Nat) (n : String) : Person := ⟨i, n, .trust⟩

/-- Ann (0) and Bob (1) are spouses; Cy (2) is a friend; Dee (3) is Cy's spouse. -/
def people : List Person := [ind 0 "Ann", ind 1 "Bob", ind 2 "Cy", ind 3 "Dee"]

def aff? (w : World) (p q : Nat) : Bool := affiliated ⟨w, p, q⟩

/-! ## (a) and 251.1(4)(a) -/

def wA : World := { persons := people, spouses := [(0, 1), (2, 3)] }
example : aff? wA 0 1 = true := by decide +kernel
example : aff? wA 1 0 = true := by decide +kernel          -- symmetric
example : aff? wA 0 2 = false := by decide +kernel         -- friends are not affiliated
example : aff? wA 2 2 = true := by decide +kernel          -- (4)(a)
-- The two-person encoding of paragraph (a) agrees.
example : Affiliation.affiliated.holds { individual := true, spouseOrCommonLawPartner := true } = aff? wA 0 1 := by
  decide +kernel

/-! ## (b) a corporation and its controllers -/

-- (b)(i): Annco is controlled by Ann.
def wBi : World := { persons := people ++ [corp 10 "Annco"], spouses := [(0, 1)], controls := [⟨10, .person 0, .fact true, false⟩] }
example : aff? wBi 10 0 = true := by decide +kernel
-- (b)(iii): and so with Ann's spouse.
example : aff? wBi 10 1 = true := by decide +kernel
example : aff? wBi 10 2 = false := by decide +kernel

-- (b)(ii): Famco is controlled by Ann and Bob together, an affiliated group.
def wBii : World := { persons := people ++ [corp 11 "Famco"], spouses := [(0, 1)], controls := [⟨11, .group [0, 1], .fact true, false⟩] }
example : aff? wBii 11 0 = true ∧ aff? wBii 11 1 = true := by decide +kernel

-- Not (b)(ii): Pals Inc. is controlled by Ann and Cy together, who are not an affiliated group.
def wNotBii : World := { persons := people ++ [corp 12 "Pals Inc."], spouses := [(0, 1)], controls := [⟨12, .group [0, 2], .fact true, false⟩] }
example : aff? wNotBii 12 0 = false ∧ aff? wNotBii 12 2 = false := by decide +kernel

-- (b)(iii) through a group: Dee's spouse Cy is a member of an affiliated group controlling Cyco.
def wBiii : World := { persons := people ++ [corp 13 "Cyco"], spouses := [(2, 3)], controls := [⟨13, .group [2, 3], .fact true, false⟩] }
example : aff? wBiii 13 3 = true := by decide +kernel

/-! ## (c) two corporations -/

-- (c)(i): both controlled by Ann; and one by Ann, the other by her spouse Bob.
def wCi : World :=
  { persons := people ++ [corp 10 "Annco", corp 14 "Annco 2", corp 15 "Bobco", corp 16 "Cyco"], spouses := [(0, 1)],
    controls := [⟨10, .person 0, .fact true, false⟩, ⟨14, .person 0, .fact true, false⟩, ⟨15, .person 1, .fact true, false⟩, ⟨16, .person 2, .fact true, false⟩] }
example : aff? wCi 10 14 = true := by decide +kernel
example : aff? wCi 10 15 = true := by decide +kernel
example : aff? wCi 10 16 = false := by decide +kernel     -- Cy is not affiliated with Ann

-- (c)(ii): Annco controlled by Ann; Famco by the group Ann and Bob, each affiliated with Ann.
def wCii : World :=
  { persons := people ++ [corp 10 "Annco", corp 11 "Famco"], spouses := [(0, 1)],
    controls := [⟨10, .person 0, .fact true, false⟩, ⟨11, .group [0, 1], .fact true, false⟩] }
example : aff? wCii 10 11 = true := by decide +kernel

-- (c)(iii): two corporations each controlled by a group; each member of each group is
-- affiliated with a member of the other (Ann and Cy; Bob and Dee).
def wCiii : World :=
  { persons := people ++ [corp 17 "AC Ltd.", corp 18 "BD Ltd."], spouses := [(0, 1), (2, 3)],
    controls := [⟨17, .group [0, 2], .fact true, false⟩, ⟨18, .group [1, 3], .fact true, false⟩] }
example : aff? wCiii 17 18 = true := by decide +kernel
example : aff? wCiii 17 0 = false := by decide +kernel    -- Ann and Cy are not an affiliated group

/-! ## (d), (e), (f) partnerships -/

-- (e): Ann holds 30% and Bob 30% of the partnership; with her spouse's share, Ann's is 60%.
def wE : World :=
  { persons := people ++ [pship 20 "AB Partners"], spouses := [(0, 1)],
    partnershipInterests := [⟨20, 0, 30, 30⟩, ⟨20, 1, 30, 30⟩, ⟨20, 2, 40, 40⟩] }
example : aff? wE 20 0 = true ∧ aff? wE 20 1 = true := by decide +kernel
example : aff? wE 20 2 = false := by decide +kernel       -- Cy's 40% is not a majority
example : majorityInterestGroups wE 20 = [[0, 1], [0, 2], [1, 2]] := by decide +kernel

-- (d): Famco is controlled by Ann and Bob; {Ann, Bob} is a majority-interest group of partners.
def wD : World := { wE with persons := wE.persons ++ [corp 11 "Famco"], controls := [⟨11, .group [0, 1], .fact true, false⟩] }
example : aff? wD 11 20 = true := by decide +kernel
-- Not (d) when the controlling group is Ann and Cy (Cy is affiliated with no member of
-- {Ann, Bob}, and Bob with no member of {Ann, Cy} other than Ann… so check the definition).
def wNotD : World := { wE with persons := wE.persons ++ [corp 12 "Pals Inc."], controls := [⟨12, .group [0, 2], .fact true, false⟩] }
example : aff? wNotD 12 20 = true := by decide +kernel    -- {Ann, Cy} is itself a majority-interest group

-- (f)(i): Ann is a majority-interest partner of two partnerships.
def wFi : World :=
  { persons := people ++ [pship 20 "P1", pship 21 "P2"],
    partnershipInterests := [⟨20, 0, 60, 60⟩, ⟨20, 2, 40, 40⟩, ⟨21, 0, 51, 51⟩, ⟨21, 3, 49, 49⟩] }
example : aff? wFi 20 21 = true := by decide +kernel

-- (f)(ii): Ann is a majority-interest partner of P1, and affiliated with each member of
-- {Ann, Bob}, a majority-interest group of partners of P2. Because the definition of
-- majority-interest partner counts affiliates' interests, that also makes Ann a majority-interest
-- partner of P2, so the pair is reached through (f)(i): (f)(ii) adds nothing on these facts.
def wFii : World :=
  { persons := people ++ [pship 20 "P1", pship 21 "P2"], spouses := [(0, 1)],
    partnershipInterests := [⟨20, 0, 60, 60⟩, ⟨20, 2, 40, 40⟩, ⟨21, 0, 30, 30⟩, ⟨21, 1, 30, 30⟩, ⟨21, 2, 40, 40⟩] }
example : aff? wFii 20 21 = true := by decide +kernel
example : [0, 1] ∈ majorityInterestGroups wFii 21 := by decide +kernel
#guard ((relation wFii).find? fun d => d.x == 20 && d.y == 21).map (·.para) == some .fi

-- (f)(iii): the majority-interest groups {Ann, Cy} of P1 and {Bob, Dee} of P2, member by member
-- affiliated as spouses, with no majority-interest partner common to both.
def wFiii : World :=
  { persons := people ++ [pship 20 "P1", pship 21 "P2"], spouses := [(0, 1), (2, 3)],
    partnershipInterests := [⟨20, 0, 26, 26⟩, ⟨20, 2, 26, 26⟩, ⟨20, 5, 48, 48⟩,
                             ⟨21, 1, 26, 26⟩, ⟨21, 3, 26, 26⟩, ⟨21, 6, 48, 48⟩] }
example : aff? wFiii 20 21 = true := by decide +kernel

-- Two partnerships with unrelated majority partners are not affiliated.
def wNotF : World :=
  { persons := people ++ [pship 20 "P1", pship 21 "P2"],
    partnershipInterests := [⟨20, 0, 60, 60⟩, ⟨20, 2, 40, 40⟩, ⟨21, 2, 60, 60⟩, ⟨21, 0, 40, 40⟩] }
example : aff? wNotF 20 21 = false := by decide +kernel

/-! ## (g) trusts -/

-- (g)(i): Ann's interest in the income is 70%. (g)(ii): Bob, Ann's spouse, would be affiliated
-- with Ann without (g). Cy is neither.
def wG : World :=
  { persons := people ++ [trust 30 "The Family Trust"], spouses := [(0, 1)],
    beneficialInterests := [⟨30, 0, 70, 50⟩, ⟨30, 2, 30, 50⟩] }
example : aff? wG 0 30 = true := by decide +kernel
example : aff? wG 1 30 = true := by decide +kernel
example : aff? wG 2 30 = false := by decide +kernel      -- 30% of income and 50% (not more) of capital

-- 251.1(4)(d)(iii): a trust with no interest in another trust is not its majority-interest
-- beneficiary, even if affiliated with one.
def wTrusts : World :=
  { persons := people ++ [trust 30 "Trust A", trust 31 "Trust B"],
    beneficialInterests := [⟨30, 0, 100, 100⟩, ⟨31, 0, 100, 100⟩] }
example : majorityInterestBeneficiary? wTrusts (relation wTrusts) 30 31 = none := by decide +kernel
-- Nor are the two trusts affiliated under (g)(ii): Trust A is affiliated with Ann only through
-- paragraph (g) itself. Two trusts are a matter for paragraph (h), which is not encoded.
example : aff? wTrusts 30 31 = false := by decide +kernel
example : aff? wTrusts 0 30 = true ∧ aff? wTrusts 0 31 = true := by decide +kernel

/-! ## (h) two trusts -/

/-- Ann (0) and her brother Ed (4) each settle a trust. Bob (1) is Ann's spouse. -/
def family : List Person := people ++ [ind 4 "Ed (Ann's brother)", trust 30 "Bob's Trust", trust 31 "Ann's Trust"]

-- (h)(i): the contributors are siblings, deemed affiliated by 251.1(4)(d)(iv); the
-- majority-interest beneficiaries (Bob of one, Ann of the other) are spouses.
def wHi : World :=
  { persons := family, spouses := [(0, 1)], siblings := [(0, 4)],
    contributors := [(30, 0), (31, 4)],
    beneficialInterests := [⟨30, 1, 100, 100⟩, ⟨31, 0, 100, 100⟩] }
example : aff? wHi 30 31 = true := by decide +kernel
#guard ((relation wHi).find? fun d => d.x == 30 && d.y == 31).map (·.para) == some .hi

-- Without the blood relationship, the contributors are not affiliated, and neither are the trusts.
example : aff? { wHi with siblings := [] } 30 31 = false := by decide +kernel
-- Siblings are not affiliated outside the contributor test.
example : aff? wHi 0 4 = false := by decide +kernel

-- (h)(ii): Bob is a majority-interest beneficiary of Bob's Trust; Ann's Trust has no single
-- majority beneficiary, but {Ann, Bob} is a majority-interest group of its beneficiaries.
-- (Ann, with her spouse, is also a majority-interest beneficiary there, so (h)(i) is met first.)
def wHii : World :=
  { persons := family ++ [ind 5 "Fay"], spouses := [(0, 1)], connected := [(0, 4)],
    contributors := [(30, 0), (31, 4)],
    beneficialInterests := [⟨30, 1, 100, 100⟩, ⟨31, 0, 30, 30⟩, ⟨31, 1, 30, 30⟩, ⟨31, 5, 40, 40⟩] }
example : aff? wHii 30 31 = true := by decide +kernel
example : [0, 1] ∈ majorityInterestGroupsB wHii 31 := by decide +kernel

-- (h)(iii): each trust's majority-interest group of beneficiaries is matched, member by member,
-- by spouses in the other's: {Ann, Cy} and {Bob, Dee}.
def wHiii : World :=
  { persons := family ++ [ind 5 "Fay", ind 6 "Gus"], spouses := [(0, 1), (2, 3)], connected := [(0, 4)],
    contributors := [(30, 0), (31, 4)],
    beneficialInterests := [⟨30, 0, 26, 26⟩, ⟨30, 2, 26, 26⟩, ⟨30, 5, 48, 48⟩,
                            ⟨31, 1, 26, 26⟩, ⟨31, 3, 26, 26⟩, ⟨31, 6, 48, 48⟩] }
example : aff? wHiii 30 31 = true := by decide +kernel
#guard ((relation wHiii).find? fun d => d.x == 30 && d.y == 31).map (·.para) == some .hiii

-- Ann holds no interest in Bob's Trust, but with her spouse Bob's interest she is a
-- majority-interest beneficiary of it too (251.1(3)), so she is one of both trusts.
#guard (rule.explain ⟨wHi, 30, 31⟩).renderWithJudgments [] ==
  "1. Ann and Bob are an individual and a spouse or common-law partner of the individual. [ITA 251.1(1)(a)]\n" ++
  "2. Bob is a majority-interest beneficiary of Bob's Trust: its interest in the income or capital, together with those of the persons affiliated with it, exceeds half by fair market value. [ITA 251.1(1)(g)(i)]\n" ++
  "3. Ann would, if subsection 251.1(1) were read without reference to paragraph (g), be affiliated with Bob, a majority-interest beneficiary of Bob's Trust. [ITA 251.1(1)(g)(ii)]\n" ++
  "4. Ann is a majority-interest beneficiary of Ann's Trust: its interest in the income or capital, together with those of the persons affiliated with it, exceeds half by fair market value. [ITA 251.1(1)(g)(i)]\n" ++
  "5. Ann, a contributor to Bob's Trust, and Ed (Ann's brother), a contributor to Ann's Trust, are individuals connected by blood relationship (brother or sister), so are deemed affiliated (251.1(4)(d)(iv)); and Ann is a majority-interest beneficiary of both trusts. [ITA 251.1(1)(h)(i)]\n" ++
  "6. So Bob's Trust and Ann's Trust are affiliated persons. [ITA 251.1(1)]\n" ++
  "Relies on no judgment calls."

/-! ## (h), as an input, and judgment calls -/

def wH : World := { persons := [trust 30 "Trust A", trust 31 "Trust B"], paragraphH := [(30, 31, .fact true)] }
example : aff? wH 30 31 = true := by decide +kernel

/-- De facto control of Annco by Cy is a judgment call. -/
def wJ (b : Bool) : World :=
  { persons := people ++ [corp 10 "Annco"], spouses := [(2, 3)], controls := [⟨10, .person 2, .judged "J-CTL" b, false⟩] }
example : aff? (wJ true) 10 3 = true ∧ aff? (wJ false) 10 3 = false := by decide +kernel
#guard (rule.explain ⟨wJ true, 10, 3⟩).reliesOn == ["J-CTL"]
#guard (rule.explain ⟨wJ false, 10, 3⟩).reliesOn == ["J-CTL"]   -- the "no" answer is relied on too
#guard (rule.explain ⟨wA, 0, 1⟩).reliesOn == []

-- Facts first: when a pair follows from the facts and from a judgment call, it is explained by the facts.
def wBoth : World :=
  { persons := people ++ [corp 10 "Annco"], spouses := [(0, 1)],
    controls := [⟨10, .person 2, .judged "J-CTL" true, false⟩, ⟨10, .person 0, .fact true, false⟩] }
#guard (rule.explain ⟨wBoth, 10, 1⟩).reliesOn == []

/-! ## Every world's relation is closed -/

example : [wA, wBi, wBii, wNotBii, wBiii, wCi, wCii, wCiii, wE, wD, wNotD, wFi, wFii, wFiii, wNotF, wG, wTrusts, wH, wHi, wHii, wHiii,
    wJ true, wJ false, wBoth].all isClosed = true := by decide +kernel

/-! ## Read-back -/

#guard (rule.explain ⟨wBii, 11, 0⟩).renderWithJudgments [] ==
  "1. Ann and Bob are an individual and a spouse or common-law partner of the individual. [ITA 251.1(1)(a)]\n" ++
  "2. Famco is a corporation controlled by the group made up of Ann and Bob, an affiliated group of persons, of which Ann is a member. [ITA 251.1(1)(b)(ii)]\n" ++
  "3. So Famco and Ann are affiliated persons. [ITA 251.1(1)]\n" ++
  "Relies on no judgment calls."

#guard (rule.explain ⟨wG, 1, 30⟩).renderWithJudgments [] ==
  "1. Ann and Bob are an individual and a spouse or common-law partner of the individual. [ITA 251.1(1)(a)]\n" ++
  "2. Ann is a majority-interest beneficiary of The Family Trust: its interest in the income or capital, together with those of the persons affiliated with it, exceeds half by fair market value. [ITA 251.1(1)(g)(i)]\n" ++
  "3. Bob would, if subsection 251.1(1) were read without reference to paragraph (g), be affiliated with Ann, a majority-interest beneficiary of The Family Trust. [ITA 251.1(1)(g)(ii)]\n" ++
  "4. So Bob and The Family Trust are affiliated persons. [ITA 251.1(1)]\n" ++
  "Relies on no judgment calls."

#guard (rule.explain ⟨wNotBii, 12, 0⟩).renderWithJudgments [] ==
  "1. No paragraph of subsection 251.1(1), from (a) to (h), alone or through other affiliated persons, makes Pals Inc. and Ann affiliated persons. [ITA 251.1(1)]\n" ++
  "Relies on no judgment calls."

end Canteen.Tests.AffiliatedPersons

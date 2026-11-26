import Canteen.ITA.S251.RelatedPersons
import Canteen.ITA.S40.DebtLoss

/-!
# Tests: section 251, related persons and arm's length

Constructed examples, one fact pattern per paragraph, checked by the kernel.
-/

namespace Canteen.Tests.RelatedPersons

open Canteen Canteen.ITA Canteen.ITA.AffiliatedPersons Canteen.ITA.RelatedPersons

def ind (i : Nat) (n : String) : Person := ⟨i, n, .individual⟩
def corp (i : Nat) (n : String) : Person := ⟨i, n, .corporation⟩

/-- A family: Gran (0) is the mother of Ann (1) and Uncle (2); Ann is married to Bob (3);
Ann's child is Kid (4); Uncle's child is Cousin (5); Ann adopted Ward (6) in fact; Fay (7) is
a friend. -/
def family : World :=
  { persons := [ind 0 "Gran", ind 1 "Ann", ind 2 "Uncle", ind 3 "Bob", ind 4 "Kid", ind 5 "Cousin",
                ind 6 "Ward", ind 7 "Fay"],
    spouses := [(1, 3)], children := [(0, 1), (0, 2), (1, 4), (2, 5)], adoptions := [(1, 6)] }

def rel? (w : World) (p q : Nat) : Bool := related ⟨w, p, q⟩

/-! ## 251(6) and 251(2)(a) -/

example : rel? family 0 1 = true := by decide +kernel     -- child
example : rel? family 0 4 = true := by decide +kernel     -- grandchild: "other descendant"
example : rel? family 1 2 = true := by decide +kernel     -- brother or sister, through a common parent
example : rel? family 1 3 = true := by decide +kernel     -- married
example : rel? family 3 0 = true := by decide +kernel     -- married to Gran's child
example : rel? family 3 2 = true := by decide +kernel     -- married to Uncle's sister
example : rel? family 1 6 = true := by decide +kernel     -- adopted in fact
example : rel? family 0 6 = true := by decide +kernel     -- adopted as the child of Gran's descendant
-- Not related: an uncle and his niece's child, cousins, and a friend.
example : rel? family 2 4 = false := by decide +kernel
example : rel? family 4 5 = false := by decide +kernel
example : rel? family 1 7 = false := by decide +kernel
-- Siblings by adoption are not connected through (c): adoption by a sibling is excluded.
example : rel? family 2 6 = false := by decide +kernel

/-! ## 251(2)(b) -/

def withCorps (cs : List Control) (extra : List Person := []) : World :=
  { family with persons := family.persons ++ [corp 10 "Annco", corp 11 "Famco", corp 12 "Fayco", corp 13 "Mixco"] ++ extra,
                controls := cs }

-- (b)(i), and (b)(iii): anyone related to Ann.
def wB : World := withCorps [⟨10, .person 1, .fact true, false⟩]
example : rel? wB 10 1 = true := by decide +kernel
example : rel? wB 10 4 = true ∧ rel? wB 10 0 = true ∧ rel? wB 10 3 = true := by decide +kernel
example : rel? wB 10 5 = false := by decide +kernel      -- Cousin is not related to Ann

-- (b)(ii): Gran and Ann together, a related group, control Famco.
def wBii : World := withCorps [⟨11, .group [0, 1], .fact true, false⟩]
example : rel? wBii 11 0 = true ∧ rel? wBii 11 1 = true := by decide +kernel
-- Ann and Fay, an unrelated group: neither is related to Mixco under (b).
def wNotBii : World := withCorps [⟨13, .group [1, 7], .fact true, false⟩]
example : rel? wNotBii 13 1 = false ∧ rel? wNotBii 13 7 = false := by decide +kernel

-- De facto control alone does not count for 251(2).
def wDeFacto : World := withCorps [⟨10, .person 1, .fact true, true⟩]
example : rel? wDeFacto 10 1 = false := by decide +kernel
example : affiliated ⟨wDeFacto, 10, 1⟩ = true := by decide +kernel   -- but it does for 251.1

/-! ## 251(2)(c) and 251(3) -/

-- (c)(i) the same person; (c)(ii) related persons.
def wCi : World := withCorps [⟨10, .person 1, .fact true, false⟩, ⟨11, .person 1, .fact true, false⟩,
  ⟨12, .person 4, .fact true, false⟩, ⟨13, .person 7, .fact true, false⟩]
example : rel? wCi 10 11 = true := by decide +kernel
example : rel? wCi 10 12 = true := by decide +kernel    -- Ann and her child Kid
example : rel? wCi 10 13 = false := by decide +kernel   -- Fay is not related to Ann

-- (c)(iii): Annco controlled by Ann; Famco by the related group Gran and Uncle, and Ann is Gran's child.
def wCiii : World := withCorps [⟨10, .person 1, .fact true, false⟩, ⟨11, .group [0, 2], .fact true, false⟩]
example : rel? wCiii 10 11 = true := by decide +kernel

-- A step-parent is related: Bob is married to Kid's parent, Ann, "a person connected by blood
-- relationship to the other" (251(6)(b)).
example : rel? family 3 4 = true := by decide +kernel

-- (c)(iv): Annco controlled by Ann; Mixco by Uncle and Kid, an unrelated group (an uncle and
-- his nephew are not connected under 251(6)); Ann is related to each of them.
def wCiv : World := withCorps [⟨10, .person 1, .fact true, false⟩, ⟨13, .group [2, 4], .fact true, false⟩]
example : rel? wCiv 2 4 = false := by decide +kernel
example : rel? wCiv 10 13 = true := by decide +kernel

-- (c)(v): Famco by the related group Gran and Ann; Mixco by the unrelated group Uncle and Kid;
-- Ann is related to each of them.
def wCv : World := withCorps [⟨11, .group [0, 1], .fact true, false⟩, ⟨13, .group [2, 4], .fact true, false⟩]
example : rel? wCv 11 13 = true := by decide +kernel

-- (c)(vi): two unrelated groups, {Ann, Fay} and {Bob, Fay}: each member of one is related to a
-- member of the other (Ann to Bob, Fay to... Fay herself, as 251(5)(c) allows).
def wCvi : World := withCorps [⟨13, .group [1, 7], .fact true, false⟩, ⟨12, .group [3, 7], .fact true, false⟩]
example : rel? wCvi 12 13 = true := by decide +kernel

-- 251(3): two corporations related to the same corporation are related to each other.
def wThree : World :=
  withCorps [⟨10, .person 1, .fact true, false⟩, ⟨11, .person 1, .fact true, false⟩, ⟨14, .person 7, .fact true, false⟩]
    [corp 14 "Fayco 2"]
example : rel? wThree 10 11 = true := by decide +kernel

example : [family, wB, wBii, wNotBii, wDeFacto, wCi, wCiii, wCiv, wCv, wCvi, wThree].all RelatedPersons.isClosed = true := by
  decide +kernel

/-! ## Arm's length (251(1)) -/

example : armsLength { world := family, first := 1, second := 4 } = false := by decide +kernel   -- related: deemed not
example : armsLength { world := family, first := 1, second := 7, questionOfFact := .judged "J-ARM" true } = true := by
  decide +kernel
example : armsLengthAnswer { world := family, first := 1, second := 4, questionOfFact := .judged "J-ARM" true } = .fact false := by
  decide +kernel
example : armsLengthAnswer { world := family, first := 1, second := 7, questionOfFact := .judged "J-ARM" true } =
    .judged "J-ARM" true := by decide +kernel

-- 40(2)(g)(ii): a debt taken as the price of capital property sold to a child is never within the
-- arm's length exception, so the loss on it is denied, with no judgment call needed.
def saleToChild : ArmsLengthQuery :=
  { world := family, first := 1, second := 4, questionOfFact := .judged "J-ARM" true }

def note : SuperficialLoss.Disposition :=
  { description := "a note from Kid", date := ⟨2025, 5, 1⟩, proceeds := 100, adjustedCostBase := 1000,
    outlaysAndExpenses := 0 }

def debtToChild : Paragraph40_2_g.Facts :=
  { sl := ⟨note, []⟩,
    debt := { isDebtOrRight := true, considerationForCapitalProperty := true, armsLength := armsLengthAnswer saleToChild } }
example : Paragraph40_2_g.debtLoss.holds debtToChild = true := by decide +kernel
#guard (Paragraph40_2_g.debtLoss.explain debtToChild).reliesOn == []

/-! ## Read-back -/

#guard (RelatedPersons.rule.explain ⟨family, 3, 0⟩).renderWithJudgments [] ==
  "1. Gran and Bob are individuals connected by marriage or common-law partnership (one is married to a person connected by blood relationship to the other). [ITA 251(2)(a), (6)]\n" ++
  "2. So Bob and Gran are related persons. [ITA 251(2)]\n" ++
  "Relies on no judgment calls."

#guard (armsLengthRule.explain { world := wB, first := 10, second := 4 }).renderWithJudgments [] ==
  "1. Annco is a corporation controlled by one person, Ann. [ITA 251(2)(b)(i)]\n" ++
  "2. Ann and Kid are individuals connected by blood relationship (one is a child or other descendant of the other). [ITA 251(2)(a), (6)]\n" ++
  "3. Kid is related to Ann, a person described in subparagraph 251(2)(b)(i) or (ii) in respect of Annco. [ITA 251(2)(b)(iii)]\n" ++
  "4. So Annco and Kid are related persons. [ITA 251(2)]\n" ++
  "5. Related persons are deemed not to deal with each other at arm's length. [ITA 251(1)(a)]\n" ++
  "Relies on no judgment calls."

end Canteen.Tests.RelatedPersons

import Canteen.ITA.S256.Associated

/-!
# Tests: associated corporations (256(1))

Ann (0) and Bob (1) are spouses; Carl (2) and Dee (3) are their children; Eve (4) is unrelated.
Aco (10) and Bco (11) are corporations. Constructed examples.
-/

namespace Canteen.Tests.Associated

open Canteen Canteen.ITA Canteen.ITA.AffiliatedPersons Canteen.ITA.Associated

def people : List Person := [⟨0, "Ann", .individual⟩, ⟨1, "Bob", .individual⟩, ⟨2, "Carl", .individual⟩,
  ⟨3, "Dee", .individual⟩, ⟨4, "Eve", .individual⟩, ⟨10, "Aco", .corporation⟩, ⟨11, "Bco", .corporation⟩]

def world (controls : List Control) : World :=
  { persons := people, spouses := [(0, 1)], children := [(0, 2), (0, 3), (1, 2), (1, 3)], controls }

def q (controls : List Control) (holdings : List Holding := []) : Facts := { world := world controls, holdings, first := 10, second := 11 }

def common (c p n : Nat) : Holding := { corporation := c, holder := p, shareClass := "common", percent := n }

-- (a) Aco controls Bco.
example : associated (q [⟨11, .person 10, .fact true, false⟩]) = true := by decide
-- (b) Ann controls both.
example : paraB (q [⟨10, .person 0, .fact true, false⟩, ⟨11, .person 0, .fact true, false⟩]) = true := by decide
-- (c) Ann controls Aco, her husband Bob controls Bco, and Ann owns 30% of Bco's common shares (and all of Aco's).
def spouses (h : List Holding) : Facts := q [⟨10, .person 0, .fact true, false⟩, ⟨11, .person 1, .fact true, false⟩] h
example : paraC (spouses [common 10 0 100, common 11 0 30, common 11 1 70]) = true := by decide
-- Without Ann's 30%, they are not associated.
example : associated (spouses [common 10 0 100, common 11 1 100]) = false := by decide
-- 24% is not enough.
example : associated (spouses [common 10 0 100, common 11 0 24, common 11 1 76]) = false := by decide
-- Nor are shares of a specified class (fixed-rate, non-voting preferred).
example : associated (spouses [common 10 0 100, common 11 1 100, { corporation := 11, holder := 0, shareClass := "preferred", percent := 100, specified := true }]) = false := by decide
-- (d) Ann controls Aco; her children Carl and Dee together control Bco; Ann owns 25% of Bco.
def parentAndChildren : Facts := q [⟨10, .person 0, .fact true, false⟩, ⟨11, .group [2, 3], .fact true, false⟩] [common 10 0 100, common 11 0 25, common 11 2 40, common 11 3 35]
example : paraD parentAndChildren = true ∧ paraB parentAndChildren = false := by decide
-- (e) Carl and Dee control Aco; Ann and Carl control Bco; Carl owns 25% of each.
def twoGroups : Facts := q [⟨10, .group [2, 3], .fact true, false⟩, ⟨11, .group [0, 2], .fact true, false⟩] [common 10 2 50, common 10 3 50, common 11 0 70, common 11 2 30]
example : paraE twoGroups = true ∧ paraB twoGroups = false ∧ associated twoGroups = true := by decide
-- Unrelated: Ann owns Aco and Eve owns Bco: not associated.
example : associated (q [⟨10, .person 0, .fact true, false⟩, ⟨11, .person 4, .fact true, false⟩] [common 10 0 100, common 11 4 100]) = false := by decide
-- Ann owns 51% of Aco and 49% of Bco, Eve the reverse. Each corporation is controlled by a member of
-- the group of its shareholders {Ann, Eve}, so by 256(1.2)(b)(i) by that group: associated under (b),
-- though Ann and Eve are unrelated (review note 112).
def crossHeld : Facts := q [⟨10, .person 0, .fact true, false⟩, ⟨11, .person 4, .fact true, false⟩] [common 10 0 51, common 10 4 49, common 11 0 49, common 11 4 51]
example : paraB crossHeld = true ∧ paraC crossHeld = false := by decide
-- But if Ann and Eve together control both, as shareholders of both, they are the same group (256(1.2)(b)(i)).
example : paraB (q [⟨10, .group [0, 4], .fact true, false⟩, ⟨11, .group [0, 4], .fact true, false⟩] [common 10 0 50, common 10 4 50, common 11 0 50, common 11 4 50]) = true := by decide
-- Ann controls Aco; Ann and Eve control Bco, both shareholders of both: still the same group.
example : paraB (q [⟨10, .person 0, .fact true, false⟩, ⟨11, .group [0, 4], .fact true, false⟩] [common 10 0 90, common 10 4 10, common 11 0 50, common 11 4 50]) = true := by decide
-- Eve owns no shares of Aco: not the same group.
example : associated (q [⟨10, .person 0, .fact true, false⟩, ⟨11, .group [0, 4], .fact true, false⟩] [common 10 0 100, common 11 0 50, common 11 4 50]) = false := by decide
-- De facto control counts (256(5.1)).
example : associated (q [⟨10, .person 0, .fact true, false⟩, ⟨11, .person 0, .fact true, true⟩]) = true := by decide
-- Control judged: the judgment call is on the record.
example : (explain (q [⟨10, .person 0, .fact true, false⟩, ⟨11, .person 0, .judged "J-DF" true, true⟩])).reliesOn = ["J-DF"] := by decide
-- For the business limit: Aco is associated with one of Bco and Aco itself; not with itself alone.
example : associatedWithAny parentAndChildren.world parentAndChildren.holdings 10 [10, 11] = true := by decide
example : associatedWithAny parentAndChildren.world parentAndChildren.holdings 10 [10] = false := by decide

-- 256(2): Ann controls Tco (12); her children Carl and Dee control Aco and Bco, and Ann owns 25% of
-- each. Aco and Bco are each associated with Tco (256(1)(c)), but not with each other directly.
def family3 : World :=
  { persons := people ++ [⟨12, "Tco", .corporation⟩], spouses := [(0, 1)], children := [(0, 2), (0, 3), (1, 2), (1, 3)],
    controls := [⟨12, .person 0, .fact true, false⟩, ⟨10, .person 2, .fact true, false⟩, ⟨11, .person 3, .fact true, false⟩] }
def group3 : Group := { world := family3, holdings := [common 12 0 100, common 10 2 75, common 10 0 25, common 11 3 75, common 11 0 25], corporations := [10, 11, 12], ccpcs := [10, 11, 12] }
example : group3.direct 10 12 = true ∧ group3.direct 11 12 = true ∧ group3.direct 10 11 = false := by decide +kernel
-- Through Tco they are deemed associated, for the Act and for section 125.
example : group3.associatedWith false 10 11 = true ∧ group3.associatedWith true 10 11 = true := by decide +kernel
-- If Tco elects (256(2)(b)(ii)), not for section 125, and Tco's business limit is nil; still for the rest of the Act.
def elected : Group := { group3 with electing := [12] }
example : elected.associatedWith true 10 11 = false ∧ elected.associatedWith false 10 11 = true := by decide +kernel
example : elected.electedNil 12 = true ∧ elected.electedNil 10 = false := by decide +kernel
-- If Tco is not a CCPC, not for section 125.
example : ({ group3 with ccpcs := [10, 11] } : Group).associatedWith true 10 11 = false := by decide +kernel
-- A corporation is not associated with itself.
example : group3.associatedWith false 10 10 = false := by decide +kernel

-- 256(1.2)(d): Ann's 30% of Bco is held through her Holdco (13), which she owns.
def withHoldco : World :=
  { persons := people ++ [⟨13, "Holdco", .corporation⟩, ⟨14, "Midco", .corporation⟩], spouses := [(0, 1)], children := [(0, 2), (0, 3), (1, 2), (1, 3)],
    controls := [⟨10, .person 0, .fact true, false⟩, ⟨11, .person 1, .fact true, false⟩] }
def viaHoldco (equity : List Equity) : Facts :=
  { world := withHoldco, holdings := [common 10 0 100, common 11 1 70, common 11 13 30], equity, first := 10, second := 11 }
example : paraC (viaHoldco [⟨13, 0, 100⟩]) = true := by decide +kernel
-- Without the look-through facts, Holdco's shares are not Ann's.
example : associated (viaHoldco []) = false := by decide +kernel
-- Ann owns 80% of Holdco: 24% of Bco, not enough.
example : associated (viaHoldco [⟨13, 0, 80⟩, ⟨13, 4, 20⟩]) = false := by decide +kernel
-- Two levels: Ann owns all of Midco (14), which owns 60% of Holdco: 18%, not enough; with Ann's own 40%
-- of Holdco as well, 30%.
example : associated (viaHoldco [⟨13, 14, 60⟩, ⟨13, 4, 40⟩, ⟨14, 0, 100⟩]) = false := by decide +kernel
example : associated (viaHoldco [⟨13, 14, 60⟩, ⟨13, 0, 40⟩, ⟨14, 0, 100⟩]) = true := by decide +kernel

-- 256(1.3): Carl, Ann's son, under 18, owns 30% of Bco. Ann controls Aco, so she is deemed to own them.
def minorFacts (minors : List Minor) : Facts :=
  { world := withHoldco, holdings := [common 10 0 100, common 11 1 70, common 11 2 30], minors, first := 10, second := 11 }
example : paraC (minorFacts [⟨2, .fact false⟩]) = true := by decide +kernel
-- Not if he is 18 or over, nor if he runs Bco without significant influence from Ann.
example : associated (minorFacts []) = false := by decide +kernel
example : associated (minorFacts [⟨2, .fact true⟩]) = false := by decide +kernel
-- Usually a judgment call, which is then on the record.
example : (explain (minorFacts [⟨2, .judged "J-MINOR" false⟩])).reliesOn = ["J-MINOR"] := by decide +kernel

-- 256(1.4)(a): Ann controls Aco; Bob owns Bco. Ann holds an option on new Bco shares.
def withEntities : World :=
  { withHoldco with persons := withHoldco.persons ++ [⟨15, "the partnership", .partnership⟩, ⟨16, "the family trust", .trust⟩] }
def option (r : Right) : Facts := { world := withEntities, holdings := [common 10 0 100, common 11 1 100], rights := [r], first := 10, second := 11 }
-- New shares equal to 40% of those issued: 40/140, over 25%.
example : paraC (option ⟨11, 0, "common", 40, true, false⟩) = true := by decide +kernel
-- 30% of new shares: 30/130, under 25%.
example : associated (option ⟨11, 0, "common", 30, true, false⟩) = false := by decide +kernel
-- An option on 30% of Bob's existing shares: 30%.
example : associated (option ⟨11, 0, "common", 30, false, false⟩) = true := by decide +kernel
-- Exercisable only on Bob's death: it does not count.
example : associated (option ⟨11, 0, "common", 40, true, true⟩) = false := by decide +kernel

-- 256(1.2)(e): a partnership owns 30% of Bco; Ann's share of its income is 100%, then 50%.
def viaEntity (holder : Nat) (equity : List Equity) : Facts :=
  { world := withEntities, holdings := [common 10 0 100, common 11 1 70, common 11 holder 30], equity, first := 10, second := 11 }
example : associated (viaEntity 15 [⟨15, 0, 100⟩]) = true := by decide +kernel
example : associated (viaEntity 15 [⟨15, 0, 50⟩, ⟨15, 4, 50⟩]) = false := by decide +kernel
-- 256(1.2)(f)(ii): a discretionary trust owns 30%; Ann is a discretionary beneficiary, deemed to own all of it,
-- as is Eve.
example : associated (viaEntity 16 [⟨16, 0, 100⟩, ⟨16, 4, 100⟩]) = true := by decide +kernel

-- 256(1.4)(b): Ann controls Aco and owns 20% of Bco; Bob owns 80%. Ann can have 30% of Bob's shares
-- redeemed: as if they were, she would own 20/70, over 25%.
def redeemable (rs : List RedemptionRight) : Facts :=
  { world := withEntities, holdings := [common 10 0 100, common 11 0 20, common 11 1 80], redemptionRights := rs, first := 10, second := 11 }
example : associated (redeemable []) = false := by decide +kernel
example : paraC (redeemable [⟨11, 0, "common", 1, 30, false⟩]) = true := by decide +kernel
example : associated (redeemable [⟨11, 0, "common", 1, 30, true⟩]) = false := by decide +kernel

-- 256(2.1): corporations kept separate mainly to multiply the small business deduction.
example : associated { q [] with separateExistence := .judged "J-2.1" true } = true := by decide
example : (explain { q [] with separateExistence := .judged "J-2.1" true }).reliesOn = ["J-2.1"] := by decide

end Canteen.Tests.Associated

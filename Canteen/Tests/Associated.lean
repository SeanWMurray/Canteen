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

end Canteen.Tests.Associated

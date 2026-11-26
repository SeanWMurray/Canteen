import Canteen.ITA.S251.Amalgamation

/-!
# Tests: amalgamations (251.1(2), 251(3.1), 251(3.2))

Constructed examples, checked by the kernel.
-/

namespace Canteen.Tests.Amalgamation

open Canteen Canteen.ITA Canteen.ITA.AffiliatedPersons Canteen.ITA.Amalgamation

def ann : Person := ⟨0, "Ann", .individual⟩
def fay : Person := ⟨1, "Fay", .individual⟩
def aco : Person := ⟨10, "Aco", .corporation⟩
def bco : Person := ⟨11, "Bco", .corporation⟩
def newco : Person := ⟨20, "Newco", .corporation⟩

def ctl (c : Nat) (k : Controller) : Control := ⟨c, k, .fact true, false⟩

/-! ## Sister corporations, both controlled by Ann -/

def sisters : Facts :=
  { before := { persons := [ann, fay, aco, bco], controls := [ctl 10 (.person 0), ctl 11 (.person 0)] },
    predecessors := [10, 11], newCorp := newco, controlAfter := [ctl 20 (.person 0)] }

example : affiliatedHolds ⟨sisters, 10⟩ = true ∧ affiliatedHolds ⟨sisters, 11⟩ = true := by decide +kernel
example : relatedHolds ⟨sisters, 10⟩ = true := by decide +kernel
example : relatedHypothetical ⟨sisters, 10⟩ = true ∧ predecessorsRelated sisters = true := by decide +kernel
-- Fay is not a predecessor.
example : affiliatedHolds ⟨sisters, 1⟩ = false := by decide +kernel

/-! ## A parent and its subsidiary -/

-- Pco (Aco) is controlled by Ann and controls Sco (Bco). After, Ann controls Newco.
def parentSub : Facts :=
  { before := { persons := [ann, aco, bco], controls := [ctl 10 (.person 0), ctl 11 (.person 10)] },
    predecessors := [10, 11], newCorp := newco, controlAfter := [ctl 20 (.person 0)] }

-- Newco and the subsidiary: Newco would be controlled by Ann, the subsidiary by Aco, and Ann is
-- affiliated with Aco (251.1(1)(c)(i)).
example : affiliatedHolds ⟨parentSub, 11⟩ = true := by decide +kernel
example : relatedHolds ⟨parentSub, 11⟩ = true := by decide +kernel

/-! ## Unrelated owners, 50/50 -/

-- Ann controls Aco and Fay controls Bco; after, the two together control Newco.
def strangers : Facts :=
  { before := { persons := [ann, fay, aco, bco], controls := [ctl 10 (.person 0), ctl 11 (.person 1)] },
    predecessors := [10, 11], newCorp := newco, controlAfter := [ctl 20 (.group [0, 1])] }

-- Not affiliated: Ann and Fay are not an affiliated group, and Fay is not affiliated with Ann.
example : affiliatedHolds ⟨strangers, 10⟩ = false := by decide +kernel
-- Not related: Ann is not related to each member of the unrelated group {Ann, Fay}, and the
-- predecessors were not related.
example : relatedHolds ⟨strangers, 10⟩ = false := by decide +kernel
-- Had Ann alone controlled Newco after, it would be affiliated and related with Aco, but not Bco.
example : affiliatedHolds ⟨{ strangers with controlAfter := [ctl 20 (.person 0)] }, 10⟩ = true := by decide +kernel
example : affiliatedHolds ⟨{ strangers with controlAfter := [ctl 20 (.person 0)] }, 11⟩ = false := by decide +kernel

/-! ## 251(3.2) and rights under 251(5)(b) -/

-- Ann controls Aco outright, and controls Bco only because of an option (a 251(5)(b) right).
-- After, Fay controls Newco.
def viaOption : Facts :=
  { before := { persons := [ann, fay, aco, bco], controls := [ctl 10 (.person 0), ctl 11 (.person 0)] },
    beforeWithoutRights := some { persons := [ann, fay, aco, bco], controls := [ctl 10 (.person 0)] },
    predecessors := [10, 11], newCorp := newco, controlAfter := [ctl 20 (.person 1)] }

-- 251(3.2) does not apply: without the option, the predecessors were not related.
example : predecessorsRelated viaOption = false := by decide +kernel
example : relatedHolds ⟨viaOption, 10⟩ = false := by decide +kernel
-- Without the 251(5)(b) qualification they would have been, and 251(3.2) would apply even
-- though Fay controls Newco.
example : relatedHolds ⟨{ viaOption with beforeWithoutRights := none }, 10⟩ = true := by decide +kernel
example : relatedHypothetical ⟨{ viaOption with beforeWithoutRights := none }, 10⟩ = false := by decide +kernel

/-! ## An amalgamation needs two predecessors -/

example : affiliatedHolds ⟨{ sisters with predecessors := [10] }, 10⟩ = false := by decide +kernel

/-! ## Read-back -/

/-! ## Read-back -/

#guard (affiliatedRule.explain ⟨parentSub, 11⟩).renderWithJudgments [] ==
  "1. Aco and Bco amalgamated to form Newco. Suppose Newco had existed immediately before the amalgamation, with the shareholders it had immediately after it. [ITA 251.1(2)(a), (b); 251(3.1)]\n" ++
  "2. Aco is a corporation controlled by Ann. [ITA 251.1(1)(b)(i)]\n" ++
  "3. Bco is controlled by Aco and Newco by Ann, and Aco is affiliated with Ann. [ITA 251.1(1)(c)(i)]\n" ++
  "4. So Newco and Bco are affiliated persons. [ITA 251.1(1)]\n" ++
  "5. So Newco and Bco are deemed to have been affiliated with each other. [ITA 251.1(2)]\n" ++
  "Relies on no judgment calls."

#guard (relatedRule.explain ⟨{ viaOption with beforeWithoutRights := none }, 10⟩).renderWithJudgments [] ==
  "1. Aco and Bco are controlled by the same person, Ann. [ITA 251(2)(c)(i)]\n" ++
  "2. So Aco and Bco are related persons. [ITA 251(2)]\n" ++
  "3. Each of the predecessor corporations was related to each other immediately before the amalgamation, otherwise than because of a right referred to in paragraph 251(5)(b). [ITA 251(3.2)]\n" ++
  "4. So Newco and Aco are deemed to have been related to each other. [ITA 251(3.2)]\n" ++
  "Relies on no judgment calls."

#guard (relatedRule.explain ⟨strangers, 10⟩).renderWithJudgments [] ==
  "1. Aco and Bco amalgamated to form Newco. Suppose Newco had existed immediately before the amalgamation, with the shareholders it had immediately after it. [ITA 251.1(2)(a), (b); 251(3.1)]\n" ++
  "2. Newco and Aco are not related persons: no paragraph of subsection 251(2), alone or through other related persons, and not subsection 251(3), makes them so. [ITA 251(2), (3)]\n" ++
  "3. And the predecessor corporations were not each related to each other immediately before the amalgamation (otherwise than because of a right referred to in paragraph 251(5)(b)). [ITA 251(3.2)]\n" ++
  "4. So neither subsection 251(3.1) nor 251(3.2) deems Newco and Aco to have been related. [ITA 251(3.1), (3.2)]\n" ++
  "Relies on no judgment calls."

end Canteen.Tests.Amalgamation

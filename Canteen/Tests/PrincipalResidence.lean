import Canteen.ITA.S40.PrincipalResidence
import Canteen.ITA.S3.Income

/-!
# Tests: the principal residence exemption

A house bought on 2015-03-01 and sold in 2025 at a $110,000 gain: eleven taxation years end after
the acquisition date (2015 to 2025). Constructed examples.
-/

namespace Canteen.Tests.PrincipalResidence

open Canteen Canteen.ITA Canteen.ITA.PrincipalResidence

def yearsWith (designated : Nat → Bool) (extra : Nat → List Designator := fun _ => []) : List YearFacts :=
  (List.range 11).map fun i =>
    let y := 2015 + i
    { year := y, designated := designated y, otherDesignations := extra y }

def house (ys : List YearFacts) : Facts :=
  { description := "the house", acquisitionDate := ⟨2015, 3, 1⟩, years := ys, gain := 11000000 }

-- Every year designated: fully exempt.
example : gain (house (yearsWith fun _ => true)) = 0 := by decide
-- Every year but 2025 (the cottage is designated for 2025): still fully exempt, by the "plus one".
example : gain (house (yearsWith (· != 2025) (fun y => if y == 2025 then [.taxpayer] else []))) = 0 := by decide
-- 2015 to 2019 only: B = 1 + 5 = 6 of C = 11, so 6/11 of the gain is exempt.
def fiveYears : Facts := house (yearsWith (· ≤ 2019))
example : b fiveYears = 6 ∧ c fiveYears = 11 ∧ gain fiveYears = 5000000 := by decide
-- No "plus one" if not resident in Canada in the acquisition year.
example : b { fiveYears with residentInAcquisitionYear := false } = 5 := by decide
-- Years of non-residence do not count.
example : b (house ((yearsWith fun _ => true).map fun y => if y.year ≤ 2016 then { y with residentInCanada := false } else y)) = 10 := by
  decide

/-! ## (c): one principal residence per family unit per year -/

def one (y : Nat) (others : List Designator) (married : Bool := true) : YearFacts :=
  { year := y, designated := true, otherDesignations := others, taxpayerMarriedOr18 := married }
def pr (y : YearFacts) : Bool := isPR (house [y]) y

example : pr (one 2020 []) = true := by decide
example : pr (one 2020 [.spouse false]) = false := by decide          -- a spouse's other property
example : pr (one 2020 [.spouse true]) = true := by decide            -- a separated spouse's does not block
example : pr (one 2020 [.child false]) = false := by decide           -- an unmarried minor child's
example : pr (one 2020 [.child true]) = true := by decide             -- an adult or married child's does not
example : pr (one 2020 [.parent]) = true := by decide                 -- a parent's, if the taxpayer is an adult
example : pr (one 2020 [.parent] false) = false := by decide          -- but does, if the taxpayer is an unmarried minor
example : pr (one 2020 [.sibling false] false) = false := by decide
example : pr (one 2020 [.sibling true] false) = true := by decide
example : pr (one 1980 [.spouse false]) = true := by decide           -- before 1982, only the taxpayer's own
example : pr (one 1980 [.taxpayer]) = false := by decide

/-! ## (a), (b), and the property -/

example : pr { one 2020 [] with inhabited := .judged "J-INHABIT" false } = false := by decide
example : pr { one 2020 [] with inhabited := .fact false, changeInUseElection := true } = true := by decide   -- 45(2)
example : isPR { house [one 2020 []] with housingUnit := false } (one 2020 []) = false := by decide
#guard (principalResidence.explain ⟨house [], { one 2020 [] with inhabited := .judged "J-INHABIT" true }⟩).reliesOn == ["J-INHABIT"]

/-! ## Read-back -/

def lines : List String := (((rule.explain fiveYears).render).splitOn "\n").drop 9 |>.take 4

#guard lines ==
  ["10. 2024: not the principal residence. The taxpayer did not designate it for the year. [ITA 54 \"principal residence\"]",
   "11. 2025: not the principal residence. The taxpayer did not designate it for the year. [ITA 54 \"principal residence\"]",
   "12. B is 6 (one, plus the principal residence years while resident); C is 11, the years owned. [ITA 40(2)(b)]",
   "13. Of the gain of $110,000.00, A × B / C = $60,000.00 is exempt, so the gain is $50,000.00. [ITA 40(2)(b)]"]

/-! ## Into the year's income -/

-- Sold for $610,000 after buying for $500,000: designated 2015 to 2019, a $50,000 gain remains,
-- a $25,000 taxable capital gain.
example : Income.paraB { capital := ⟨[CapitalGains.ofPrincipalResidence fiveYears 61000000 50000000], 0, {}⟩ } = 2 * 2500000 := by
  decide
-- Fully designated: nothing.
example : Income.paraB { capital := ⟨[CapitalGains.ofPrincipalResidence (house (yearsWith fun _ => true)) 61000000 50000000], 0, {}⟩ } = 0 := by
  decide

end Canteen.Tests.PrincipalResidence

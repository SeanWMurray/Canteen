import Canteen.ITA.S38.CapitalGains

/-!
# Subsection 75(2): property held by a trust that may revert to the contributor

*Income Tax Act*, as consolidated to 2026-10-29 (verbatim in `statute/ITA-75-2-3.txt`):

**75(2)** Where a trust resident in Canada (created since 1934) holds property on condition (a) that it
(or substituted property) may (i) revert to the person from whom it was received, or (ii) pass to
persons the person determines after the trust's creation, or (b) that it is not to be disposed of during
the person's existence except with the person's consent or as directed, then the income or loss from
it, and the taxable capital gains and allowable capital losses from disposing of it, are the person's,
during the person's existence and while the person is resident in Canada. **75(3)** Not for property
held by registered plans (RRSPs, TFSAs, RESPs and the others listed), employee trusts and the like,
qualifying environmental trusts, or a trust of Canada child benefit amounts for the children.

The conditions, the contributor's existence and residence, and the 75(3) exclusions are facts (the
conditions often a judgment call). The amounts are the trust's for the year from the property. 107(4.1)
(no rollover on distributing such property to others), 75(2)'s effect on the contributor's cost, and
the Sommerer reading of "received" (a sale for fair market value is not a contribution) are the caller's.
-/

namespace Canteen.ITA.ReversionaryTrust

open CapitalGains (HalfCents formatHalfCents)

inductive Condition where
  /-- (a)(i): the property may revert to the contributor. -/
  | revert
  /-- (a)(ii): it may pass to persons the contributor determines later. -/
  | contributorDetermines
  /-- (b): it may not be disposed of without the contributor's consent or direction. -/
  | contributorConsent
  deriving Repr, DecidableEq, Inhabited

structure Facts where
  trustResident : Bool := true
  createdAfter1934 : Bool := true
  /-- The conditions on which the trust holds the property (each a fact or judgment call). -/
  conditions : List (Condition × Answer) := []
  contributorAlive : Bool := true
  contributorResident : Bool := true
  /-- 75(3): an excluded trust. -/
  excluded : Bool := false
  /-- From the property and substituted property, for the year. -/
  income : Cents := 0
  loss : Cents := 0
  taxableCapitalGains : HalfCents := 0
  allowableCapitalLosses : HalfCents := 0
  deriving Repr, Inhabited

def conditionMet (f : Facts) : Bool := f.conditions.any (·.2.value)

def applies (f : Facts) : Bool :=
  f.trustResident && f.createdAfter1934 && conditionMet f && f.contributorAlive && f.contributorResident && !f.excluded

/-- The contributor's share: all of it, if 75(2) applies. -/
def toContributor (f : Facts) (x : Nat) : Nat := if applies f then x else 0
def toTrust (f : Facts) (x : Nat) : Nat := if applies f then 0 else x

def judgments (f : Facts) : List String := f.conditions.foldl (fun ids c => mergeIds ids c.2.judgments) []

def explain (f : Facts) : Finding :=
  let c := formatCents
  let h := formatHalfCents
  ⟨applies f,
    [if !f.trustResident then ⟨"The trust is not resident in Canada.", "ITA 75(2)"⟩
     else if f.excluded then ⟨"The trust is one 75(3) excludes.", "ITA 75(3)"⟩
     else if !conditionMet f then ⟨"The trust does not hold the property on any condition in 75(2)(a) or (b).", "ITA 75(2)"⟩
     else if !(f.contributorAlive && f.contributorResident) then ⟨"The contributor is no longer living, or not resident in Canada.", "ITA 75(2)"⟩
     else ⟨s!"The trust holds the property on condition that it may revert to the contributor, pass as the contributor determines, " ++
       s!"or not be disposed of without the contributor's consent: income of {c f.income}, losses of {c f.loss}, taxable capital gains of " ++
       s!"{h f.taxableCapitalGains} and allowable capital losses of {h f.allowableCapitalLosses} from it are the contributor's.", "ITA 75(2)"⟩],
    judgments f⟩

/-! ## Truths -/

/-- Each amount is the contributor's or the trust's, never both, never lost. -/
theorem split (f : Facts) (x : Nat) : toContributor f x + toTrust f x = x := by
  unfold toContributor toTrust; split <;> simp

/-- An RRSP trust is excluded. -/
theorem excluded_trust (f : Facts) (h : f.excluded = true) : applies f = false := by
  simp [applies, h]

end Canteen.ITA.ReversionaryTrust

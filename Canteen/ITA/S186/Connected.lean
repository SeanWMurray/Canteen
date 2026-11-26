import Canteen.Core.StatuteSyntax
import Canteen.ITA.S251.RelatedPersons

/-!
# Subsections 186(2), (4) and (7): connected corporations

*Income Tax Act*, as consolidated to 2026-10-29 (verbatim in `statute/ITA-186-2-4-7.txt`):

> (2) … one corporation is controlled by another corporation if more than 50% of its issued share
> capital (having full voting rights under all circumstances) belongs to the other corporation, to
> persons with whom the other corporation does not deal at arm's length, or to the other
> corporation and persons with whom the other corporation does not deal at arm's length.
>
> (4) … a payer corporation is connected with a particular corporation at any time … if (a) the
> payer corporation is controlled (otherwise than by virtue of a right referred to in paragraph
> 251(5)(b)) by the particular corporation at that time; or (b) the particular corporation owned,
> at that time, (i) more than 10% of the issued share capital (having full voting rights under all
> circumstances) of the payer corporation, and (ii) shares of the capital stock of the payer
> corporation having a fair market value of more than 10% of the fair market value of all of the
> issued shares of the capital stock of the payer corporation.
>
> (7) … where a provision … indicates that the term connected has the meaning assigned by
> subsection 186(4), that meaning shall be determined by taking into account the application of
> subsection 186(2) …

Shareholdings are given by holder: the number of fully voting shares and the fair market value of
all the holder's shares. Control in (4)(a) is de jure control as given in the world (not
`deFactoOnly`), or 186(2). Persons not at arm's length with the particular corporation are those
related to it under section 251, and any others given (251(1)(c), a question of fact).
-/

namespace Canteen.ITA.Connected

open AffiliatedPersons

/-- One holder's shares of the payer corporation. -/
structure Holding where
  holder : Nat
  /-- Issued shares having full voting rights under all circumstances. -/
  votingShares : Nat := 0
  /-- Fair market value of all the holder's shares. -/
  value : Cents := 0
  deriving Repr, DecidableEq, Inhabited

structure Facts where
  world : World
  payer : Nat
  particular : Nat
  /-- All the issued shares of the payer, by holder. -/
  holdings : List Holding
  /-- Persons not related to the particular corporation who in fact do not deal at arm's length with it. -/
  nonArmsLength : List Nat := []
  deriving Inhabited

def totalVotes (f : Facts) : Nat := (f.holdings.map (·.votingShares)).sum
def totalValue (f : Facts) : Cents := (f.holdings.map (·.value)).sum

/-- The particular corporation, or a person not dealing at arm's length with it. -/
def withNonArmsLength (f : Facts) (p : Nat) : Bool :=
  p == f.particular || f.nonArmsLength.contains p || RelatedPersons.related ⟨f.world, p, f.particular⟩

/-- 186(2): more than 50% of the voting shares belong to the particular corporation and persons not
at arm's length with it. -/
def controlled186_2 (f : Facts) : Bool :=
  totalVotes f < 2 * ((f.holdings.filter (withNonArmsLength f ·.holder)).map (·.votingShares)).sum

/-- De jure control as given in the world. -/
def controlledInWorld (f : Facts) : Bool :=
  f.world.controls.any fun k => k.corporation == f.payer && !k.deFactoOnly && k.answer.value && k.controller == .person f.particular

def ownVotes (f : Facts) : Nat := ((f.holdings.filter (·.holder == f.particular)).map (·.votingShares)).sum
def ownValue (f : Facts) : Cents := ((f.holdings.filter (·.holder == f.particular)).map (·.value)).sum

/-- (4)(b): more than 10% of the voting shares and of the value. -/
def tenPercent (f : Facts) : Bool := totalVotes f < 10 * ownVotes f && totalValue f < 10 * ownValue f

/-- Subsection 186(4). -/
statute connected (f : Facts) named "subsection 186(4)" cites "ITA 186(4)"
  applies where
    | "(a) or (b)" (controlledInWorld f || controlled186_2 f || tenPercent f)
        => "The payer is controlled by the particular corporation (de jure, or by 186(2) with persons not at arm's length with it), or the particular corporation owns more than 10% of its voting shares and more than 10% of the value of all its shares."
        else "The payer is not controlled by the particular corporation (de jure or by 186(2)), and the particular corporation does not own more than 10% of both its voting shares and the value of its shares."

/-! ## Truths about connected corporations -/

private theorem ten (x : Nat) (hx : 0 < x) : x < 10 * x := by omega

/-- A wholly-owned subsidiary is connected. -/
theorem wholly_owned (f : Facts) (v : Nat) (x : Cents) (h : f.holdings = [⟨f.particular, v, x⟩]) (hv : 0 < v) (hx : 0 < x) :
    connected.holds f = true := by
  have ta : totalVotes f = v := by simp [totalVotes, h]
  have oa : ownVotes f = v := by simp [ownVotes, h]
  have tb : totalValue f = x := by simp [totalValue, h]
  have ob : ownValue f = x := by simp [ownValue, h]
  have h1 : totalVotes f < 10 * ownVotes f := by rw [ta, oa]; omega
  have h2 : totalValue f < 10 * ownValue f := by rw [tb, ob]; exact ten x hx
  simp [connected, tenPercent, h1, h2]

/-- Owning 10% or less of the votes, with no control, is never enough. -/
theorem not_of_ten_percent (f : Facts) (hc : controlledInWorld f = false) (h2 : controlled186_2 f = false)
    (h : 10 * ownVotes f ≤ totalVotes f) : connected.holds f = false := by
  have : ¬ (totalVotes f < 10 * ownVotes f) := Nat.not_lt.mpr h
  simp [connected, tenPercent, hc, h2, this]

end Canteen.ITA.Connected

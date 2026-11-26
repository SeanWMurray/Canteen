import Canteen.Core.StatuteSyntax
import Canteen.ITA.S251.RelatedPersons

/-!
# Paragraph 251.2(2)(a), with 256(7)(a): a corporation's loss restriction event

*Income Tax Act*, as consolidated to 2026-10-29 (verbatim in `statute/ITA-251.2-2-256-7-a.txt`):

> 251.2(2) For the purposes of this Act, a taxpayer is at any time subject to a loss restriction
> event if (a) the taxpayer is a corporation and at that time control of the corporation is
> acquired by a person or group of persons; or (b) [a trust …]
>
> 256(7) For the purposes of … paragraph 251.2(2)(a) …, (a) control of a particular corporation
> shall be deemed not to have been acquired solely because of (i) the acquisition at any time of
> shares of any corporation by (A) a particular person who acquired the shares from a person to
> whom the particular person was related (otherwise than because of a right referred to in
> paragraph 251(5)(b)) immediately before that time, (B) a particular person who was related to
> the particular corporation (otherwise than because of [such] a right …) immediately before that
> time, (C) an estate that acquired the shares because of the death of a person, (D) a particular
> person who acquired the shares from an estate that arose on and as a consequence of the death of
> an individual, if the estate acquired the shares from the individual as a consequence of the
> death and the individual was related to the particular person immediately before the death, …
> (ii) the redemption or cancellation at any particular time of, or a change at any particular
> time in the rights, privileges, restrictions or conditions attaching to, shares of the
> particular corporation or of a corporation controlling [it], where each person and each member
> of each group of persons that controls the particular corporation immediately after the
> particular time was related (otherwise than because of [such] a right …) to the corporation
> (A) immediately before the particular time, …, or (iii) the acquisition at any time of shares of
> the particular corporation if (A) the acquisition of those shares would otherwise result in the
> acquisition of control of the particular corporation at that time by a related group of
> persons, and (B) each member of each group of persons that controls the particular corporation
> at that time was related (otherwise than because of [such] a right …) to the particular
> corporation immediately before that time; …

One event is described by the world immediately before and immediately after it. Control here is
de jure: a control given as `deFactoOnly` does not count. Control is acquired when a person or
group controls the corporation after and did not before. Related persons are decided by section
251 in the world before; rights under 251(5)(b) are reflected in the controls given, so "otherwise
than because of a right referred to in paragraph 251(5)(b)" is read as relatedness on the controls
given. Not encoded: 251.2(2)(b) and (3) (trusts), 256(7)(a)(i)(E) (55(3)(b) reorganizations),
256(7)(a)(ii)(B), 256(7)(b) to (g) (amalgamations, share exchanges and the rest), 256(8), and the
consequences in 111(4) to (5.5) beyond the event's date, which `SuperficialLoss`, `SuspendedLoss`
and `NetCapitalLoss` take.
-/

namespace Canteen.ITA.LossRestrictionEvent

open AffiliatedPersons

/-- The event, for 256(7)(a). -/
inductive Event where
  /-- Shares acquired by `acquirer` from `transferor`. -/
  | purchase (acquirer transferor : Nat)
  /-- (ii): a redemption or cancellation of shares, or a change in their rights. -/
  | redemption
  /-- (i)(C): shares acquired by an estate because of a death. -/
  | toEstate
  /-- (i)(D): shares acquired by `acquirer` from an estate, the deceased `related` to the acquirer
  immediately before the death. -/
  | fromEstate (acquirer : Nat) (related : Bool)
  deriving Repr, DecidableEq, Inhabited

structure Facts where
  corporation : Nat
  /-- The world immediately before the event. -/
  before : World
  /-- The world immediately after it. -/
  after : World
  event : Event
  deriving Inhabited

/-- De jure controllers of the corporation in a world, as given or assumed. -/
def controllers (w : World) (c : Nat) : List Controller :=
  (w.controls.filter fun k => k.corporation == c && !k.deFactoOnly && k.answer.value).map (·.controller)

def controlJudgments (w : World) (c : Nat) : List String :=
  (w.controls.filter fun k => k.corporation == c && !k.deFactoOnly).foldl (fun ids k => mergeIds ids k.answer.judgments) []

/-- Those who control the corporation after and did not before. -/
def newControllers (f : Facts) : List Controller :=
  (controllers f.after f.corporation).filter fun k => !(controllers f.before f.corporation).contains k

def acquired (f : Facts) : Bool := !(newControllers f).isEmpty

def members : Controller → List Nat
  | .person p => [p]
  | .group ms => ms

def isCorporation (f : Facts) : Bool :=
  ((f.before.person? f.corporation).map (·.kind == .corporation)).getD false

/-- Related immediately before, under section 251. -/
def relatedBefore (f : Facts) (p q : Nat) : Bool := RelatedPersons.related ⟨f.before, p, q⟩

def relatedJudgments (f : Facts) (p q : Nat) : List String := (RelatedPersons.explain ⟨f.before, p, q⟩).reliesOn

/-- Each new controller's members were related to the corporation immediately before. -/
def allRelatedToCorporation (f : Facts) : Bool :=
  (newControllers f).all fun k => (members k).all fun m => relatedBefore f m f.corporation

def allRelatedJudgments (f : Facts) : List String :=
  (newControllers f).foldl (fun ids k => (members k).foldl (fun ids m => mergeIds ids (relatedJudgments f m f.corporation)) ids) []

/-- (i)(A): the acquirer bought from a person related to it. -/
def fromRelated (f : Facts) : Bool :=
  match f.event with
  | .purchase a t => relatedBefore f a t
  | _ => false

/-- (i)(B): the acquirer was related to the corporation. -/
def acquirerRelated (f : Facts) : Bool :=
  match f.event with
  | .purchase a _ => relatedBefore f a f.corporation
  | _ => false

def eventJudgments (f : Facts) (which : Nat → Nat → Nat × Nat) : List String :=
  match f.event with
  | .purchase a t => let (p, q) := which a t; relatedJudgments f p q
  | _ => []

/-- (i)(C), (D): death. -/
def death (f : Facts) : Bool :=
  match f.event with
  | .toEstate => true
  | .fromEstate _ r => r
  | _ => false

/-- (ii): a redemption or change in rights, the new controllers all related to the corporation before. -/
def redemption (f : Facts) : Bool := f.event == .redemption && allRelatedToCorporation f

/-- (iii): a related group acquires control, each member related to the corporation before. -/
def relatedGroup (f : Facts) : Bool :=
  (match f.event with | .purchase _ _ => true | _ => false) &&
  (newControllers f).all (fun k => match k with
    | .group ms => RelatedPersons.relatedGroup (RelatedPersons.relation f.after) ms
    | .person _ => false) &&
  allRelatedToCorporation f

/-- Paragraph 251.2(2)(a), read with 256(7)(a). -/
statute lossRestrictionEvent (f : Facts) named "paragraph 251.2(2)(a)" cites "ITA 251.2(2)(a)"
  applies where
    | "corporation" (isCorporation f)
        => "The taxpayer is a corporation."
        else "The taxpayer is not a corporation."
    | "control acquired" judgments (controlJudgments f.after f.corporation ++ controlJudgments f.before f.corporation) (acquired f)
        => "Control of the corporation is acquired by a person or group of persons: one controls it immediately after who did not immediately before."
        else "No person or group of persons controls the corporation immediately after who did not immediately before."
  except where
    | "256(7)(a)(i)(A)" := (Rule.clause "256(7)(a)(i)(A)" "ITA 256(7)(a)(i)(A)" fromRelated
        "The acquirer acquired the shares from a person to whom it was related immediately before."
        "The acquirer did not acquire the shares from a person to whom it was related."
        (fun f => eventJudgments f fun a t => (a, t)))
    | "256(7)(a)(i)(B)" := (Rule.clause "256(7)(a)(i)(B)" "ITA 256(7)(a)(i)(B)" acquirerRelated
        "The acquirer was related to the corporation immediately before."
        "The acquirer was not related to the corporation immediately before."
        (fun f => eventJudgments f fun a _ => (a, f.corporation)))
    | "256(7)(a)(i)(C), (D)" := (Rule.clause "256(7)(a)(i)(C), (D)" "ITA 256(7)(a)(i)(C), (D)" death
        "The shares were acquired by an estate because of a death, or from such an estate by a person to whom the deceased was related."
        "The shares were not acquired by an estate on a death, or from one by a person to whom the deceased was related.")
    | "256(7)(a)(ii)" := (Rule.clause "256(7)(a)(ii)" "ITA 256(7)(a)(ii)" redemption
        "On a redemption, cancellation or change in the rights of shares, everyone who controls the corporation after was related to it immediately before."
        "The event is not a redemption, cancellation or change in rights after which only persons related to the corporation before control it."
        (fun f => if f.event == .redemption then allRelatedJudgments f else []))
    | "256(7)(a)(iii)" := (Rule.clause "256(7)(a)(iii)" "ITA 256(7)(a)(iii)" relatedGroup
        "Control is acquired by a related group, each member of which was related to the corporation immediately before."
        "Control is not acquired by a related group each member of which was related to the corporation before."
        (fun f => match f.event with | .purchase _ _ => allRelatedJudgments f | _ => []))

/-- The date of the event, if it is one, for the superficial loss definition (f), 40(3.4)(b)(iii)
and the net capital loss C term. -/
def eventDate (f : Facts) (date : Date) : Option Date :=
  if lossRestrictionEvent.holds f then some date else none

/-! ## Truths about loss restriction events -/

/-- Nobody new in control, no event. -/
theorem no_new_controller (f : Facts) (h : newControllers f = []) : lossRestrictionEvent.holds f = false := by
  simp [lossRestrictionEvent, acquired, h]

/-- A sale between related persons is never a loss restriction event. -/
theorem related_sale (f : Facts) (a t : Nat) (he : f.event = .purchase a t) (h : relatedBefore f a t = true) :
    lossRestrictionEvent.holds f = false := by
  simp [lossRestrictionEvent, fromRelated, he, h]

/-- Shares passing to an estate on death never cause one. -/
theorem to_estate (f : Facts) (he : f.event = .toEstate) : lossRestrictionEvent.holds f = false := by
  simp [lossRestrictionEvent, death, he]

end Canteen.ITA.LossRestrictionEvent

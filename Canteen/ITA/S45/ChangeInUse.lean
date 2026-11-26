import Canteen.Core.StatuteSyntax
import Canteen.ITA.S38.CapitalGains
import Canteen.ITA.S54.SuperficialLoss

/-!
# Subsections 45(1) to (4): change in use

*Income Tax Act*, as consolidated to 2026-10-29 (verbatim in `statute/ITA-45-1-4.txt`):

> (1) … (a) where a taxpayer, (i) having acquired property for some other purpose, has commenced
> at a later time to use it for the purpose of gaining or producing income, or (ii) having
> acquired property for the purpose of gaining or producing income, has commenced at a later time
> to use it for some other purpose, the taxpayer shall be deemed to have (iii) disposed of it at
> that later time for proceeds equal to its fair market value at that later time, and (iv)
> immediately thereafter reacquired it at a cost equal to that fair market value; (b) [property
> regularly used in part for each: the cost and proceeds are split in proportion to the use];
> (c) where … there has been a change in the relation between the use regularly made … for gaining
> or producing income and the use regularly made of the property for other purposes, (i) if the
> use … for those other purposes has increased, [or] (ii) … decreased, the taxpayer shall be
> deemed to have (A) disposed of the property at that time for proceeds equal to the proportion
> of the fair market value … that the amount of the increase [or decrease] … is of the whole use
> regularly made of the property, and (B) immediately thereafter reacquired the property so
> disposed of at a cost equal to [those] proceeds …
>
> (2) … if a taxpayer elects … (a) if subparagraph (1)(a)(i) … would otherwise apply …, the
> taxpayer is deemed not to have begun to use the property for the purpose of gaining or
> producing income; (b) if subparagraph (1)(c)(ii) … would otherwise apply …, the taxpayer is
> deemed not to have increased the use regularly made of the property for [that] purpose …
>
> (3) If … a property that was acquired by a taxpayer for the purpose of gaining or producing
> income, or … in part for that purpose, ceases in whole or in part to be used for that purpose
> and becomes, or becomes part of, the principal residence of the taxpayer, paragraphs (1)(a) and
> (c) shall not apply … if the taxpayer so elects …
>
> (4) Notwithstanding subsection 45(3), an election described in that subsection shall be deemed
> not to have been made … if any deduction in respect of the property has been allowed for any
> taxation year ending after 1984 and on or before the change in use under regulations made under
> paragraph 20(1)(a) [capital cost allowance] to the taxpayer, the taxpayer's spouse or
> common-law partner or a trust under which [either] is a beneficiary.

Use is measured in parts of a whole (for example, square metres of a house, or percent), with the
parts used for purposes other than gaining or producing income given before and after the change.
A change from wholly one purpose to wholly the other is paragraph (a); any other change in the
relation is paragraph (c). The deemed disposition is of the proportion of the property that the
change in use is of the whole use, at that proportion of its fair market value and (by 45(1)(b))
of its adjusted cost base; both are rounded down to the cent.

A deemed disposition under 45(1) is excepted from the superficial loss definition by its
paragraph (c), and an election under 45(2) or (3) feeds paragraph (b) of the principal residence
definition (`covers45_2`, `covers45_3`). Not encoded: section 13 (depreciable property: 13(7));
45(1)(d) (non-residents); the timing rules of 45(3)(a), (b) for the election; and rescission of
a 45(2) election under 45(2)(c), beyond ending its coverage.
-/

namespace Canteen.ITA.ChangeInUse

open SuperficialLoss (DeemingProvision)

/-- One change in the use regularly made of a property. -/
structure Facts where
  /-- The property, e.g. `"the house at 12 Elm St."`. -/
  description : String
  /-- The whole use regularly made of the property, in parts (for example, 100 for percent). -/
  whole : Nat := 100
  /-- The parts used for purposes other than gaining or producing income, before the change. -/
  otherBefore : Nat
  /-- The parts used for purposes other than gaining or producing income, after the change. -/
  otherAfter : Nat
  /-- The property's fair market value at the time of the change. -/
  fairMarketValue : Cents
  /-- The adjusted cost base of the whole property immediately before the change. -/
  adjustedCostBase : Cents
  /-- 45(2): the taxpayer elects in the return for the year. -/
  elected45_2 : Bool := false
  /-- 45(3): the property becomes, or becomes part of, the taxpayer's principal residence. -/
  becomesPrincipalResidence : Bool := false
  /-- 45(3): the taxpayer elects by notifying the Minister in writing in time. -/
  elected45_3 : Bool := false
  /-- 45(4): a capital cost allowance deduction was allowed in respect of the property, for a
  taxation year ending after 1984 and on or before the change, to the taxpayer, the taxpayer's
  spouse or common-law partner, or a trust under which either is a beneficiary. -/
  capitalCostAllowanceClaimed : Bool := false
  /-- The part of the property whose use for other purposes changes is personal-use property
  (section 54), so that a loss on its deemed disposition is nil under 40(2)(g)(iii). -/
  personalUse : Bool := false
  deriving Repr, DecidableEq, Inhabited

/-- Which paragraph of 45(1) describes the change. -/
inductive Change where
  /-- (a)(i): from wholly other purposes to wholly gaining or producing income. -/
  | aI
  /-- (a)(ii): from wholly gaining or producing income to wholly other purposes. -/
  | aII
  /-- (c)(i): the use for other purposes increased. -/
  | cI
  /-- (c)(ii): the use for other purposes decreased. -/
  | cII
  deriving Repr, DecidableEq, Inhabited

namespace Change

/-- The use for gaining or producing income increased: (a)(i) or (c)(ii), the cases 45(2) reaches. -/
def towardIncome : Change → Bool
  | .aI | .cII => true
  | _ => false

def cite : Change → String
  | .aI => "ITA 45(1)(a)(i)"
  | .aII => "ITA 45(1)(a)(ii)"
  | .cI => "ITA 45(1)(c)(i)"
  | .cII => "ITA 45(1)(c)(ii)"

end Change

/-- The change, if the relation between the two uses changed. -/
def change (f : Facts) : Option Change :=
  if f.otherBefore < f.otherAfter then
    some (if f.otherBefore = 0 ∧ f.otherAfter = f.whole then .aII else .cI)
  else if f.otherAfter < f.otherBefore then
    some (if f.otherBefore = f.whole ∧ f.otherAfter = 0 then .aI else .cII)
  else none

def towardIncome (f : Facts) : Bool := (change f).any Change.towardIncome

/-- 45(3), with 45(4). -/
def election45_3 (f : Facts) : Bool :=
  f.elected45_3 && f.becomesPrincipalResidence && !f.capitalCostAllowanceClaimed

/-- Subsection 45(1), with the elections in 45(2) and (3). -/
statute deemedDisposition (f : Facts) named "subsection 45(1)" cites "ITA 45(1)"
  applies where
    | "(a), (c)" (change f).isSome
        => "The use regularly made of the property changed between gaining or producing income and other purposes."
        else "The relation between the use regularly made of the property for gaining or producing income and for other purposes did not change."
  except where
    | "45(2)" := (Rule.clause "45(2)" "ITA 45(2)(a), (b)" (fun f : Facts => towardIncome f && f.elected45_2)
        "The taxpayer elects under subsection 45(2), so is deemed not to have begun, or increased, the use for gaining or producing income."
        "The taxpayer does not elect under subsection 45(2) for a change toward gaining or producing income.")
    | "45(3)" := (Rule.clause "45(3)" "ITA 45(3), (4)" (fun f : Facts => !towardIncome f && election45_3 f)
        "The property ceased to be used for gaining or producing income and became the taxpayer's principal residence, and the taxpayer elects under subsection 45(3), with no capital cost allowance claimed after 1984 (45(4))."
        "No effective election under subsection 45(3) covers a change from gaining or producing income to the taxpayer's principal residence.")

/-- The parts of the whole use that changed. -/
def changedParts (f : Facts) : Nat :=
  if f.otherBefore ≤ f.otherAfter then f.otherAfter - f.otherBefore else f.otherBefore - f.otherAfter

/-- 45(1)(a)(iii), (c)(i)(A), (c)(ii)(A): the proportion of fair market value, rounded down. -/
def proceeds (f : Facts) : Cents :=
  if f.whole = 0 then 0 else f.fairMarketValue * changedParts f / f.whole

/-- 45(1)(b): the same proportion of the adjusted cost base, rounded down. -/
def portionCost (f : Facts) : Cents :=
  if f.whole = 0 then 0 else f.adjustedCostBase * changedParts f / f.whole

/-- The deemed disposition, for the capital gains computation, where 45(1) deems one. -/
def disposition (f : Facts) : Option CapitalGains.Disposition :=
  if deemedDisposition.holds f then
    some { description := s!"{f.description} (change in use)", proceeds := proceeds f, adjustedCostBase := portionCost f,
           lossNil := f.personalUse && towardIncome f }
  else none

/-- The adjusted cost base of the whole property after the change: the part not disposed of keeps
its cost, and the part reacquired costs its deemed proceeds (45(1)(a)(iv), (c)(i)(B), (c)(ii)(B)). -/
def costAfter (f : Facts) : Cents :=
  if deemedDisposition.holds f then f.adjustedCostBase - portionCost f + proceeds f else f.adjustedCostBase

/-- The deemed disposition, for the superficial loss definition: deemed by 45(1), so excepted by
its paragraph (c). -/
def slDisposition (f : Facts) (date : Date) : SuperficialLoss.Disposition :=
  { description := f.description, date, proceeds := proceeds f, adjustedCostBase := portionCost f,
    outlaysAndExpenses := 0, deemedBy := some .s45_1 }

/-! ## Elections and the principal residence definition -/

/-- An election under 45(2) in respect of a change in `electedYear`, rescinded (45(2)(c)) in the
return for `rescindedYear` if it was. -/
structure Election45_2 where
  electedYear : Nat
  rescindedYear : Option Nat := none
  deriving Repr, DecidableEq, Inhabited

/-- Paragraph (b)(i) of the principal residence definition: the election relates to a change in
use in the year or a preceding year, and was not rescinded in the return for the year or a
preceding year. -/
def covers45_2 (e : Election45_2) (year : Nat) : Bool :=
  e.electedYear ≤ year && e.rescindedYear.all (year < ·)

/-- Paragraph (b)(ii) of the principal residence definition: an election under 45(3) relating to
a change in use in `changeYear` covers the years before it. -/
def covers45_3 (changeYear year : Nat) : Bool := year < changeYear

def explain (f : Facts) : Finding :=
  let e := deemedDisposition.explain f
  let which := (change f).map Change.cite |>.getD "ITA 45(1)"
  let tail : List Step :=
    if deemedDisposition.holds f then
      [⟨s!"So the taxpayer is deemed to have disposed of {changedParts f} of {f.whole} parts of {f.description} for " ++
        s!"{formatCents (proceeds f)} (that proportion of its fair market value of {formatCents f.fairMarketValue}), " ++
        s!"with a cost of {formatCents (portionCost f)}, and to have reacquired it at that amount: the property's " ++
        s!"cost is now {formatCents (costAfter f)}.", which⟩]
    else if (change f).isSome then
      [⟨s!"So there is no deemed disposition, and the cost of {f.description} stays {formatCents f.adjustedCostBase}.", which⟩]
    else []
  ⟨deemedDisposition.holds f, e.steps ++ tail, e.reliesOn⟩

/-- Subsection 45(1), as a rule, with its consequence. -/
def rule : Rule Facts where
  name := "subsection 45(1)"
  citation := "ITA 45(1)"
  holds := deemedDisposition.holds
  explain := explain
  sound := fun _ => rfl

/-! ## Truths about a change in use -/

/-- No change in the relation between the uses, no deemed disposition. -/
theorem no_change (f : Facts) (h : f.otherBefore = f.otherAfter) : disposition f = none := by
  simp [disposition, deemedDisposition, change, h]

/-- A change wholly from one purpose to the other (paragraph (a)) is a disposition of the whole
property at fair market value, with its whole cost. -/
theorem whole_at_fair_market_value (f : Facts) (hw : 0 < f.whole)
    (h : (f.otherBefore = 0 ∧ f.otherAfter = f.whole) ∨ (f.otherBefore = f.whole ∧ f.otherAfter = 0)) :
    proceeds f = f.fairMarketValue ∧ portionCost f = f.adjustedCostBase := by
  have hc : changedParts f = f.whole := by
    rcases h with ⟨h1, h2⟩ | ⟨h1, h2⟩ <;> simp [changedParts, h1, h2] <;> omega
  have hne : f.whole ≠ 0 := Nat.pos_iff_ne_zero.mp hw
  simp [proceeds, portionCost, hc, hne, Nat.mul_div_cancel _ hw]

/-- The disposed-of portion's cost never exceeds the property's cost, so the cost after the
change is the cost of the rest plus the deemed proceeds. -/
theorem portionCost_le (f : Facts) (h1 : f.otherBefore ≤ f.whole) (h2 : f.otherAfter ≤ f.whole) :
    portionCost f ≤ f.adjustedCostBase := by
  unfold portionCost; split
  · exact Nat.zero_le _
  · have hp : changedParts f ≤ f.whole := by unfold changedParts; split <;> omega
    exact Nat.div_le_of_le_mul (by rw [Nat.mul_comm f.whole]; exact Nat.mul_le_mul_left _ hp)

/-- **The 45(2) election.** Starting to rent out a home, with the election, is not a disposition:
the cost is unchanged. -/
theorem elect_45_2 (f : Facts) (h : towardIncome f = true) (he : f.elected45_2 = true) :
    disposition f = none ∧ costAfter f = f.adjustedCostBase := by
  simp [disposition, costAfter, deemedDisposition, h, he]

/-- **45(4).** Once capital cost allowance has been claimed, a 45(3) election has no effect: moving
into a former rental property is a disposition at fair market value. -/
theorem cca_defeats_45_3 (f : Facts) (hc : (change f).isSome = true) (h : towardIncome f = false)
    (hcca : f.capitalCostAllowanceClaimed = true) : deemedDisposition.holds f = true := by
  simp [deemedDisposition, hc, h, election45_3, hcca]

/-- **No gain is taxed twice or escapes.** For a whole change in use followed by a sale, the gain
on the deemed disposition and the gain on the sale add up to the whole gain. -/
theorem gains_add_up (f : Facts) (sale : Cents) (hw : 0 < f.whole)
    (h : (f.otherBefore = 0 ∧ f.otherAfter = f.whole) ∨ (f.otherBefore = f.whole ∧ f.otherAfter = 0))
    (hd : deemedDisposition.holds f = true) (h1 : f.adjustedCostBase ≤ f.fairMarketValue) (h2 : f.fairMarketValue ≤ sale) :
    (f.fairMarketValue - f.adjustedCostBase) + (sale - costAfter f) = sale - f.adjustedCostBase := by
  obtain ⟨hp, hc⟩ := whole_at_fair_market_value f hw h
  simp only [costAfter, hd, ite_true, hp, hc, Nat.sub_self, Nat.zero_add]
  rw [Nat.add_comm]
  exact Nat.sub_add_sub_cancel h2 h1

/-- A deemed disposition under 45(1) is never a superficial loss (paragraph (c) of the definition). -/
theorem not_superficial (f : Facts) (date : Date) (as : List SuperficialLoss.Acquisition) :
    SuperficialLoss.superficialLoss ⟨slDisposition f date, as⟩ = false := by
  simp [SuperficialLoss.superficialLoss, SuperficialLoss.excepted, SuperficialLoss.paraC, slDisposition,
    DeemingProvision.listedInC]

end Canteen.ITA.ChangeInUse

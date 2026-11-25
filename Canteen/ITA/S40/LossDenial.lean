import Canteen.ITA.S54.SuperficialLoss
import Canteen.Core.Combine

/-!
# Subparagraph 40(2)(g)(i)

*Income Tax Act*, subparagraph 40(2)(g)(i), as consolidated to 2026-10-29
(verbatim in `statute/ITA-40-2-g.txt`):

> (2) Notwithstanding subsection 40(1), …
> (g) a taxpayer's loss, if any, from the disposition of a property (other than, for the
> purposes of computing the exempt surplus or exempt deficit, hybrid surplus or hybrid
> deficit, and taxable surplus or taxable deficit of the taxpayer in respect of another
> taxpayer, where the taxpayer or, if the taxpayer is a partnership, a member of the
> taxpayer is a foreign affiliate of the other taxpayer, a property that is, or would be,
> if the taxpayer were a foreign affiliate of the other taxpayer, excluded property
> (within the meaning assigned by subsection 95(1)) of the taxpayer), to the extent that
> it is
> (i) a superficial loss, …
> is nil;

Encoded as: the carve-out in the opening words does not apply, **and** the loss is a
superficial loss (section 54). Built with `Rule.and`, so it is sound by construction.

Not encoded: subparagraphs (ii) to (iv), and the *amount* denied where only part of a
loss is a superficial loss ("to the extent that"); the Act does not give a formula for
that, so it is left for a later phase.
-/

namespace Canteen.ITA.LossDenial

/-- The facts subparagraph 40(2)(g)(i) needs. -/
structure Facts where
  /-- The facts for the superficial loss definition. -/
  sl : SuperficialLoss.Facts
  /-- The carve-out in the opening words of 40(2)(g): the loss is being computed for the
  purposes of the exempt, hybrid or taxable surplus or deficit of the taxpayer in respect
  of another taxpayer of which the taxpayer (or, for a partnership, a member of it) is a
  foreign affiliate, and the property is, or would be if the taxpayer were a foreign
  affiliate of the other taxpayer, excluded property of the taxpayer (subsection 95(1)). -/
  surplusExcludedProperty : Bool := false
  deriving Repr, DecidableEq

/-- Opening words of 40(2)(g): the property is not carved out. -/
def notCarvedOut (f : Facts) : Bool := !f.surplusExcludedProperty

def notCarvedOutExplain (f : Facts) : Finding :=
  if f.surplusExcludedProperty then
    ⟨false, [⟨"The loss is being computed for the surplus or deficit of the taxpayer in respect of another " ++
      "taxpayer of which it is a foreign affiliate, and the property is excluded property, so paragraph " ++
      "40(2)(g) does not apply to it.", "ITA 40(2)(g)"⟩], []⟩
  else
    ⟨true, [⟨"The property is not excluded property being considered in computing a foreign affiliate's " ++
      "surplus or deficit, so the opening words of paragraph 40(2)(g) apply to it.", "ITA 40(2)(g)"⟩], []⟩

/-- The opening words of paragraph 40(2)(g). -/
def openingWords : Rule Facts where
  name := "the opening words of paragraph 40(2)(g)"
  citation := "ITA 40(2)(g)"
  holds := notCarvedOut
  explain := notCarvedOutExplain
  sound := fun f => by cases h : f.surplusExcludedProperty <;> simp [notCarvedOutExplain, notCarvedOut, h]

/-- The opening words and subparagraph (i), combined with `Rule.and`. -/
def combined : Rule Facts :=
  Rule.and "subparagraph 40(2)(g)(i)" "ITA 40(2)(g)(i)"
    openingWords (SuperficialLoss.rule.comap Facts.sl)

/-- The statutory result, in place of the generic "Therefore … applies". -/
def consequence (applies : Bool) : Step :=
  if applies then
    ⟨"Therefore, under subparagraph 40(2)(g)(i), the taxpayer's loss from the disposition is nil to the " ++
      "extent that it is a superficial loss.", "ITA 40(2)(g)(i)"⟩
  else
    ⟨"Therefore subparagraph 40(2)(g)(i) does not reduce the taxpayer's loss from the disposition.",
      "ITA 40(2)(g)(i)"⟩

/-- Subparagraph 40(2)(g)(i): the loss, to the extent it is a superficial loss, is nil.
The explanation is `combined`'s with its last step stating the statutory result; the
conclusion is unchanged, so soundness carries over. -/
def rule : Rule Facts where
  name := "subparagraph 40(2)(g)(i)"
  citation := "ITA 40(2)(g)(i)"
  holds := combined.holds
  explain := fun f =>
    let e := combined.explain f
    { e with steps := e.steps.dropLast ++ [consequence e.conclusion] }
  sound := fun f => combined.sound f

@[simp] theorem rule_holds (f : Facts) :
    rule.holds f = (!f.surplusExcludedProperty && SuperficialLoss.superficialLoss f.sl) := rfl

/-- The loss denied, where the whole loss is a superficial loss. -/
def deniedLoss (f : Facts) : Cents :=
  if rule.holds f then SuperficialLoss.lossAmount f.sl.disposition else 0

end Canteen.ITA.LossDenial

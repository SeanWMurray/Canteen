import Canteen.ITA.S54.SuperficialLoss

/-!
# Paragraph 53(1)(f)

*Income Tax Act*, paragraph 53(1)(f), as consolidated to 2026-10-29 (verbatim in
`statute/ITA-53-1-f.txt`):

> (1) In computing the adjusted cost base to a taxpayer of property at any time, there
> shall be added to the cost to the taxpayer of the property such of the following
> amounts in respect of the property as are applicable: …
> (f) where the property is substituted property (within the meaning assigned by
> paragraph (a) of the definition superficial loss in section 54) of the taxpayer, the
> amount, if any, by which
> (i) the amount of the loss that was, because of the acquisition by the taxpayer of the
> property, a superficial loss of any taxpayer from a disposition of a property
> exceeds
> (ii) where the property disposed of was a share of the capital stock of a corporation,
> the amount that would, but for paragraph 40(2)(g), be deducted under subsection
> 112(3), 112(3.1) or 112(3.2) in computing the loss of any taxpayer in respect of the
> disposition of the share;

"The amount, if any, by which (i) exceeds (ii)" is the truncated difference `(i) - (ii)`
on natural numbers. The amount in (ii) is taken as a fact: subsections 112(3) to (3.2)
are not encoded.
-/

namespace Canteen.ITA.CostAddition

/-- The facts paragraph 53(1)(f) needs, for one property of one taxpayer. -/
structure Facts where
  /-- Who owns the property, e.g. `"the taxpayer's spouse"`. -/
  owner : String
  /-- The property, e.g. `"100 common shares of ABC Ltd."`. -/
  property : String
  /-- The cost of the property to its owner. -/
  cost : Cents
  /-- The property is substituted property of its owner, within the meaning of paragraph (a)
  of the definition "superficial loss" in section 54. -/
  substitutedProperty : Bool
  /-- (i) The loss that was, because of the owner's acquisition of the property, a
  superficial loss of any taxpayer. -/
  superficialLoss : Cents
  /-- (ii) Where the property disposed of was a share, the amount that would, but for
  paragraph 40(2)(g), be deducted under subsection 112(3), (3.1) or (3.2). -/
  stopLossAmount : Cents := 0
  deriving Repr, DecidableEq

/-- The amount added under 53(1)(f): the amount, if any, by which (i) exceeds (ii). -/
def addition (f : Facts) : Cents :=
  if f.substitutedProperty then f.superficialLoss - f.stopLossAmount else 0

/-- The adjusted cost base: the cost, plus the amount added under 53(1)(f). -/
def adjustedCostBase (f : Facts) : Cents :=
  f.cost + addition f

/-- Paragraph 53(1)(f) adds an amount. -/
def adds (f : Facts) : Bool :=
  f.substitutedProperty && f.stopLossAmount < f.superficialLoss

def explain (f : Facts) : Finding :=
  let sub : Step :=
    if f.substitutedProperty then
      ⟨s!"The {f.property} owned by {f.owner} are substituted property of {f.owner}, within the meaning of " ++
        "paragraph (a) of the definition \"superficial loss\" in section 54.", "ITA 53(1)(f)"⟩
    else
      ⟨s!"The {f.property} owned by {f.owner} are not substituted property of {f.owner}, so paragraph 53(1)(f) " ++
        "adds nothing to their cost.", "ITA 53(1)(f)"⟩
  if !f.substitutedProperty then ⟨false, [sub], []⟩
  else
    let amounts : Step :=
      ⟨s!"The loss that was a superficial loss because of the acquisition by {f.owner} is {formatCents f.superficialLoss}; " ++
        s!"the amount described in subparagraph (ii) is {formatCents f.stopLossAmount}.", "ITA 53(1)(f)(i), (ii)"⟩
    let result : Step :=
      if adds f then
        ⟨s!"So {formatCents (addition f)} is added to the cost of the property: its adjusted cost base to {f.owner} " ++
          s!"is {formatCents f.cost} + {formatCents (addition f)} = {formatCents (adjustedCostBase f)}.", "ITA 53(1)(f)"⟩
      else
        ⟨"The amount in (i) does not exceed the amount in (ii), so nothing is added.", "ITA 53(1)(f)"⟩
    ⟨adds f, [sub, amounts, result], []⟩

theorem explain_sound (f : Facts) : (explain f).conclusion = adds f := by
  unfold explain adds
  cases h : f.substitutedProperty <;> simp

/-- Paragraph 53(1)(f), as a rule: it applies when it adds an amount to the cost. -/
def rule : Rule Facts where
  name := "paragraph 53(1)(f)"
  citation := "ITA 53(1)(f)"
  holds := adds
  explain := explain
  sound := explain_sound

/-! ## Facts about the addition -/

/-- The adjusted cost base is never less than the cost. -/
theorem cost_le_adjustedCostBase (f : Facts) : f.cost ≤ adjustedCostBase f :=
  Nat.le_add_right _ _

/-- Nothing is added to property that is not substituted property. -/
theorem addition_of_not_substituted (f : Facts) (h : f.substitutedProperty = false) : addition f = 0 := by
  simp [addition, h]

/-- With no amount under (ii), the whole superficial loss is added. -/
theorem addition_of_no_stop_loss (f : Facts) (h : f.substitutedProperty = true) (h0 : f.stopLossAmount = 0) :
    addition f = f.superficialLoss := by
  simp [addition, h, h0]

/-- `rule` applies exactly when something is added. -/
theorem adds_iff (f : Facts) : adds f = true ↔ 0 < addition f := by
  unfold adds addition
  by_cases h : f.substitutedProperty = true
  · simp only [h, Bool.true_and, decide_eq_true_eq, ↓reduceIte]
    exact ⟨fun hl => Nat.sub_pos_of_lt hl, fun hp => Nat.lt_of_sub_pos hp⟩
  · simp [h]

end Canteen.ITA.CostAddition

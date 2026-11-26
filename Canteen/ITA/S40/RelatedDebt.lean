import Canteen.Core.StatuteSyntax
import Canteen.ITA.S251.RelatedPersons

/-!
# Paragraph 40(2)(e.1) and 53(1)(f.1): a debt disposed of within a related group

*Income Tax Act*, as consolidated to 2026-10-29 (verbatim in `statute/ITA-40-3.6-2-e.1.txt`):

> (e.1) a particular taxpayer's loss, if any, from the disposition at any time to a particular
> person or partnership of an obligation — other than … excluded property … — that was,
> immediately after that time, payable by another person or partnership to the particular person
> or partnership is nil if the particular taxpayer, the particular person or partnership and the
> other person or partnership are related to each other at that time or would be related to each
> other at that time if paragraph 80(2)(j) applied for the purpose of this paragraph;

"Related to each other" is read as each pair of the three being related (section 251). Whether
they would be related with 80(2)(j) is a fact. 53(1)(f.1) adds the denied loss to the transferee's
cost where both are taxable Canadian corporations and 53(1)(f.2) does not apply (facts).
-/

namespace Canteen.ITA.RelatedDebt

open SuperficialLoss AffiliatedPersons

structure Facts where
  /-- The world at the time of the disposition. -/
  world : World
  taxpayer : Nat
  /-- The person or partnership the obligation is disposed of to. -/
  transferee : Nat
  /-- The person or partnership that owes it. -/
  debtor : Nat
  disposition : Disposition
  /-- The property is an obligation that, immediately after, was payable by the debtor to the transferee. -/
  obligationPayableToTransferee : Bool
  /-- They would be related to each other if 80(2)(j) applied. -/
  relatedBy80_2_j : Bool := false
  surplusExcludedProperty : Bool := false

def pair (a b : Facts → Nat) : Rule Facts :=
  RelatedPersons.rule.comap fun f => ⟨f.world, a f, b f⟩

/-- The three are related to each other: each pair related, or so with 80(2)(j). -/
def relatedToEachOther : Rule Facts :=
  Rule.or "the three related to each other" "ITA 40(2)(e.1); 251(2)"
    (Rule.and "each pair related" "ITA 251(2)" (pair (·.taxpayer) (·.transferee))
      (Rule.and "the other pairs related" "ITA 251(2)" (pair (·.taxpayer) (·.debtor)) (pair (·.transferee) (·.debtor))))
    (Rule.clause "80(2)(j)" "ITA 40(2)(e.1); 80(2)(j)" (·.relatedBy80_2_j)
      "They would be related to each other if paragraph 80(2)(j) applied."
      "They would not be related to each other if paragraph 80(2)(j) applied.")

/-- Paragraph 40(2)(e.1). -/
statute applies (f : Facts) named "paragraph 40(2)(e.1)" cites "ITA 40(2)(e.1)"
  applies where
    | "obligation" f.obligationPayableToTransferee
        => "The taxpayer disposed of an obligation that, immediately after, was payable by another person or partnership to the person or partnership it was disposed of to."
        else "The property is not an obligation payable, immediately after the disposition, by another person or partnership to the transferee."
    | "related" := (relatedToEachOther)
  except where
    | "surplus carve-out" f.surplusExcludedProperty
        => "For the purposes of computing a foreign affiliate's surplus or deficit, the obligation is excluded property."
        else "The obligation is not excluded property being considered in computing a foreign affiliate's surplus or deficit."

/-- The loss is nil. -/
def denied (f : Facts) : Bool := applies.holds f && isLoss f.disposition

/-- 53(1)(f.1): the amount added to the transferee's cost, where both are taxable Canadian
corporations and 53(1)(f.2) does not apply. -/
def transfereeCostAddition (f : Facts) (taxableCanadianCorporations : Bool) : Cents :=
  if denied f && taxableCanadianCorporations then lossAmount f.disposition else 0

/-- The disposition, for the superficial loss definition, with its paragraph (e) decided here. -/
def withRelatedDebt (f : Facts) : Disposition :=
  { f.disposition with applies40_2_e1 := f.disposition.applies40_2_e1 || applies.holds f }

/-- Where 40(2)(e.1) applies, the loss is not also a superficial loss (paragraph (e) of that definition). -/
theorem not_superficial (f : Facts) (as : List Acquisition) (h : applies.holds f = true) :
    superficialLoss ⟨withRelatedDebt f, as⟩ = false := by
  simp [superficialLoss, excepted, paraE, withRelatedDebt, h]

/-- An unrelated debtor or transferee means no denial, unless 80(2)(j) would make them related. -/
theorem not_of_unrelated_transferee (f : Facts) (h : RelatedPersons.related ⟨f.world, f.taxpayer, f.transferee⟩ = false)
    (hj : f.relatedBy80_2_j = false) : denied f = false := by
  simp [denied, applies, relatedToEachOther, pair, RelatedPersons.rule, h, hj]

end Canteen.ITA.RelatedDebt

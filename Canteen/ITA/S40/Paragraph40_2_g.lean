import Canteen.ITA.S40.DebtLoss
import Canteen.ITA.S40.PersonalUseLoss
import Canteen.ITA.S40.PlanTransferLoss
import Canteen.ITA.S40.LossDenial

/-!
# Paragraph 40(2)(g), as a whole

> (g) a taxpayer's loss, if any, from the disposition of a property (other than, for the
> purposes of computing the exempt surplus …, excluded property …), to the extent that it is
> (i) a superficial loss, (ii) …, (iii) …, or (iv) …, is nil;

The four subparagraphs, joined with `Rule.anyOf`, under the carve-out in the opening words.
Subparagraph (i) uses the paragraph-by-paragraph superficial loss rule, for its detailed
explanation. Where the paragraph applies, the whole loss is treated as nil; "to the extent
that" is quantified only for whole losses (see the review notes).
-/

namespace Canteen.ITA.Paragraph40_2_g

open SuperficialLoss

/-- Subparagraph (i), over the paragraph's facts. -/
def superficialLossLoss : Rule Facts :=
  SuperficialLoss.rule.comap Facts.sl

/-- Subparagraphs (i) to (iv): the loss is one of them. -/
def anySubparagraph : Rule Facts :=
  Rule.anyOf "one of subparagraphs 40(2)(g)(i) to (iv)" "ITA 40(2)(g)"
    [superficialLossLoss, debtLoss, personalUseLoss, planTransferLoss]

/-- Paragraph 40(2)(g): the loss is nil. -/
statute paragraph (f : Facts) named "paragraph 40(2)(g)" cites "ITA 40(2)(g)"
  applies where
    | "(i) to (iv)" := (anySubparagraph)
  except where
    | "opening words" f.surplusExcludedProperty
        => "For the purposes of computing the surplus or deficit of the taxpayer in respect of another taxpayer of which it is a foreign affiliate, the property is excluded property."
        else "The property is not excluded property being considered in computing a foreign affiliate's surplus or deficit."

/-- The loss made nil by paragraph 40(2)(g), where the whole loss falls within it. -/
def deniedLoss (f : Facts) : Cents :=
  if paragraph.holds f then lossAmount f.disposition else 0

theorem paragraph_holds (f : Facts) :
    paragraph.holds f = (!f.surplusExcludedProperty &&
      (superficialLoss f.sl || debtLoss.holds f || personalUseLoss.holds f || planTransferLoss.holds f)) := by
  simp only [paragraph, anySubparagraph, superficialLossLoss, Rule.statute_holds, Rule.clause_holds,
    Rule.anyOf_holds, Rule.comap_holds, List.all_cons, List.all_nil, List.any_cons, List.any_nil]
  simp [SuperficialLoss.rule, Bool.and_comm, Bool.or_assoc]

/-- Where none of (ii) to (iv) applies, the paragraph is exactly the superficial loss
denial already encoded in `LossDenial.rule`. -/
theorem paragraph_eq_lossDenial (f : Facts) (h2 : debtLoss.holds f = false)
    (h3 : personalUseLoss.holds f = false) (h4 : planTransferLoss.holds f = false) :
    paragraph.holds f = LossDenial.rule.holds ⟨f.sl, f.surplusExcludedProperty⟩ := by
  rw [paragraph_holds, h2, h3, h4]
  simp

/-- Whatever `LossDenial.rule` denies, the paragraph denies. -/
theorem paragraph_of_lossDenial (f : Facts) (h : LossDenial.rule.holds ⟨f.sl, f.surplusExcludedProperty⟩ = true) :
    paragraph.holds f = true := by
  rw [paragraph_holds]
  simp only [LossDenial.rule_holds, Bool.and_eq_true, Bool.not_eq_true'] at h
  simp [h.1, h.2]

/-- The carve-out in the opening words takes the property outside all four subparagraphs. -/
theorem paragraph_of_carve_out (f : Facts) (h : f.surplusExcludedProperty = true) :
    paragraph.holds f = false := by
  simp [paragraph_holds, h]

/-- Without a loss, nothing is denied. -/
theorem paragraph_of_no_loss (f : Facts) (h : isLoss f.disposition = false) :
    paragraph.holds f = false := by
  have h' : isLoss f.sl.disposition = false := h
  simp [paragraph_holds, superficialLoss, h, h']

end Canteen.ITA.Paragraph40_2_g

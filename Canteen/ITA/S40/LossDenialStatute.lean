import Canteen.Core.StatuteSyntax
import Canteen.ITA.S40.LossDenial
import Canteen.ITA.S54.SuperficialLossStatute

/-!
# Subparagraph 40(2)(g)(i), in statute form

*A taxpayer's loss from the disposition of a property (other than … excluded property …),
to the extent that it is (i) a superficial loss, is nil.* Written with the `statute`
command; subparagraph (i) is the statute-form superficial loss rule, used as a clause.
`lossDenialStatute_eq` proves it is the same rule as `LossDenial.rule`.
-/

namespace Canteen.ITA.LossDenial

/-- Paragraph 40(2)(g), subparagraph (i): the loss is nil to the extent it is a superficial
loss, other than for excluded property in computing a foreign affiliate's surplus. -/
statute lossDenialStatute (f : Facts) named "subparagraph 40(2)(g)(i)" cites "ITA 40(2)(g)"
  applies where
    | (i) := (SuperficialLoss.superficialLossStatute.comap Facts.sl)
  except where
    | "opening words" f.surplusExcludedProperty
        => "For the purposes of computing the surplus or deficit of the taxpayer in respect of another taxpayer of which it is a foreign affiliate, the property is excluded property."
        else "The property is not excluded property being considered in computing a foreign affiliate's surplus or deficit."

/-- The statute form is the same rule as `LossDenial.rule`. -/
theorem lossDenialStatute_eq (f : Facts) : lossDenialStatute.holds f = rule.holds f := by
  simp [lossDenialStatute, SuperficialLoss.superficialLossStatute_eq, Bool.and_comm]

end Canteen.ITA.LossDenial

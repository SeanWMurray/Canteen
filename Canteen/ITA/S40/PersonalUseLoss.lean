import Canteen.Core.StatuteSyntax
import Canteen.ITA.S40.Paragraph40_2_g_Facts

/-!
# Subparagraph 40(2)(g)(iii): losses on personal-use property

*Income Tax Act*, subparagraph 40(2)(g)(iii), as consolidated to 2026-10-29:

> (iii) a loss from the disposition of any personal-use property of the taxpayer (other than
> listed personal property or a debt referred to in subsection 50(2)), or

with the definitions "personal-use property" and "listed personal property" in section 54
(verbatim in `statute/ITA-54-personal-use-property.txt`). The definition of personal-use
property says "includes": the three listed categories are encoded, and the ordinary meaning
beyond them is left to the judgment call in paragraph (a).
-/

namespace Canteen.ITA.Paragraph40_2_g

open SuperficialLoss

/-- Section 54 "personal-use property": paragraphs (a), (b) and (c) of the definition. -/
statute personalUseProperty (f : Facts) named "personal-use property" cites "ITA 54 \"personal-use property\""
  applies where
    | "(a) to (c)" judgments (f.personalUse.primarilyPersonalUse.judgments)
        (f.personalUse.primarilyPersonalUse.value || f.personalUse.debtForPersonalUseProperty ||
          f.personalUse.optionOnPersonalUseProperty)
        => "The property is personal-use property of the taxpayer: property used primarily for the personal use or enjoyment of the taxpayer or related individuals, a debt owing in respect of the disposition of personal-use property, or an option to acquire personal-use property."
        else "The property is not personal-use property of the taxpayer: it is not used primarily for the personal use or enjoyment of the taxpayer or related individuals, a debt owing in respect of the disposition of personal-use property, or an option to acquire personal-use property."

/-- Section 54 "listed personal property": personal-use property of a listed kind. -/
def isListed (f : Facts) : Bool :=
  personalUseProperty.holds f && f.personalUse.listedKind.isSome

/-- Subparagraph 40(2)(g)(iii). -/
statute personalUseLoss (f : Facts) named "subparagraph 40(2)(g)(iii)" cites "ITA 40(2)(g)(iii)"
  applies where
    | "loss" isLoss f.disposition
        => "The taxpayer has a loss from the disposition."
        else "The taxpayer has no loss from the disposition."
    | "personal-use property" := (personalUseProperty)
  except where
    | "listed personal property" f.personalUse.listedKind.isSome
        => "The property is listed personal property: personal-use property that is, or is a portion of or an interest in or right to, a print, etching, drawing, painting, sculpture or other similar work of art, jewellery, a rare folio, rare manuscript or rare book, a stamp, or a coin."
        else "The property is not of a kind listed in the definition \"listed personal property\" in section 54."
    | "debt under 50(2)" f.personalUse.debtReferredTo50_2
        => "The property is a debt referred to in subsection 50(2)."
        else "The property is not a debt referred to in subsection 50(2)."

@[simp] theorem personalUseLoss_holds (f : Facts) :
    personalUseLoss.holds f = (isLoss f.disposition &&
      (f.personalUse.primarilyPersonalUse.value || f.personalUse.debtForPersonalUseProperty ||
        f.personalUse.optionOnPersonalUseProperty) &&
      !(f.personalUse.listedKind.isSome || f.personalUse.debtReferredTo50_2)) := by
  simp [personalUseLoss, personalUseProperty, Bool.and_assoc]

/-- A loss on listed personal property is never denied by (iii). -/
theorem personalUseLoss_of_listed (f : Facts) (h : f.personalUse.listedKind.isSome = true) :
    personalUseLoss.holds f = false := by
  simp [h]

end Canteen.ITA.Paragraph40_2_g

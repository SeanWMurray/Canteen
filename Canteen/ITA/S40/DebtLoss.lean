import Canteen.Core.StatuteSyntax
import Canteen.ITA.S40.Paragraph40_2_g_Facts

/-!
# Subparagraph 40(2)(g)(ii): losses on debts

*Income Tax Act*, subparagraph 40(2)(g)(ii), as consolidated to 2026-10-29 (verbatim in
`statute/ITA-40-2-g.txt`):

> (ii) a loss from the disposition of a debt or other right to receive an amount, unless the
> debt or right, as the case may be, was acquired by the taxpayer for the purpose of gaining
> or producing income from a business or property (other than exempt income) or as
> consideration for the disposition of capital property to a person with whom the taxpayer
> was dealing at arm's length,

The "unless" is encoded as two exceptions. The income purpose is usually a judgment call, and
so is arm's length dealing between unrelated persons.
-/

namespace Canteen.ITA.Paragraph40_2_g

open SuperficialLoss

/-- Subparagraph 40(2)(g)(ii). -/
statute debtLoss (f : Facts) named "subparagraph 40(2)(g)(ii)" cites "ITA 40(2)(g)(ii)"
  applies where
    | "loss" isLoss f.disposition
        => "The taxpayer has a loss from the disposition."
        else "The taxpayer has no loss from the disposition."
    | "debt" f.debt.isDebtOrRight
        => "The property disposed of is a debt or other right to receive an amount."
        else "The property disposed of is not a debt or other right to receive an amount."
  except where
    | "income purpose" judgments (f.debt.incomePurpose.judgments) f.debt.incomePurpose.value
        => "The taxpayer acquired the debt or right for the purpose of gaining or producing income from a business or property (other than exempt income)."
        else "The taxpayer did not acquire the debt or right for the purpose of gaining or producing income from a business or property (other than exempt income)."
    | "arm's length sale" judgments (if f.debt.considerationForCapitalProperty then f.debt.armsLength.judgments else [])
        (f.debt.considerationForCapitalProperty && f.debt.armsLength.value)
        => "The taxpayer acquired the debt or right as consideration for the disposition of capital property to a person with whom the taxpayer was dealing at arm's length."
        else "The taxpayer did not acquire the debt or right as consideration for the disposition of capital property to a person with whom the taxpayer was dealing at arm's length."

@[simp] theorem debtLoss_holds (f : Facts) :
    debtLoss.holds f = (isLoss f.disposition && f.debt.isDebtOrRight &&
      !(f.debt.incomePurpose.value || (f.debt.considerationForCapitalProperty && f.debt.armsLength.value))) := by
  simp [debtLoss, Bool.and_assoc]

/-- A debt acquired to earn income never falls under (ii), whatever else is true. -/
theorem debtLoss_of_income_purpose (f : Facts) (h : f.debt.incomePurpose.value = true) :
    debtLoss.holds f = false := by
  simp [h]

/-- A debt taken as the price of capital property sold at arm's length never falls under (ii). -/
theorem debtLoss_of_arms_length_sale (f : Facts) (hc : f.debt.considerationForCapitalProperty = true)
    (ha : f.debt.armsLength.value = true) : debtLoss.holds f = false := by
  simp [hc, ha]

end Canteen.ITA.Paragraph40_2_g

import Canteen.Core.StatuteSyntax
import Canteen.ITA.S40.Paragraph40_2_g_Facts

/-!
# Subparagraph 40(2)(g)(iv): losses on transfers to registered plans

*Income Tax Act*, subparagraph 40(2)(g)(iv), as consolidated to 2026-10-29:

> (iv) a loss from the disposition of property to
> (A) a trust governed by a deferred profit sharing plan, an employees profit sharing plan, a
> FHSA, a registered disability savings plan, a registered retirement income fund or a TFSA,
> under which the taxpayer is a beneficiary or immediately after the disposition becomes a
> beneficiary, or
> (B) a trust governed by a registered retirement savings plan under which the taxpayer or the
> taxpayer's spouse or common-law partner is an annuitant or becomes, within 60 days after the
> end of the taxation year, an annuitant,
-/

namespace Canteen.ITA.Paragraph40_2_g

open SuperficialLoss

private def transferPlan (f : Facts) : Option PlanTrust := f.transfer.map (·.plan)

/-- Clause 40(2)(g)(iv)(A). -/
statute planTransferA (f : Facts) named "clause 40(2)(g)(iv)(A)" cites "ITA 40(2)(g)(iv)(A)"
  applies where
    | "trust" ((transferPlan f).map (·.inA) == some true)
        => "The property was disposed of to a trust governed by a deferred profit sharing plan, an employees profit sharing plan, a FHSA, a registered disability savings plan, a registered retirement income fund or a TFSA."
        else "The property was not disposed of to a trust governed by a deferred profit sharing plan, an employees profit sharing plan, a FHSA, a registered disability savings plan, a registered retirement income fund or a TFSA."
    | "beneficiary" ((f.transfer.map (·.taxpayerBeneficiary)) == some true)
        => "The taxpayer is, or immediately after the disposition becomes, a beneficiary under it."
        else "The taxpayer is not, and does not immediately after the disposition become, a beneficiary under it."

/-- Clause 40(2)(g)(iv)(B). -/
statute planTransferB (f : Facts) named "clause 40(2)(g)(iv)(B)" cites "ITA 40(2)(g)(iv)(B)"
  applies where
    | "trust" ((transferPlan f) == some .rrsp)
        => "The property was disposed of to a trust governed by a registered retirement savings plan."
        else "The property was not disposed of to a trust governed by a registered retirement savings plan."
    | "annuitant" ((f.transfer.map (·.annuitant)) == some true)
        => "The taxpayer or the taxpayer's spouse or common-law partner is an annuitant under it, or becomes one within 60 days after the end of the taxation year."
        else "Neither the taxpayer nor the taxpayer's spouse or common-law partner is, or within 60 days after the end of the taxation year becomes, an annuitant under it."

/-- Subparagraph 40(2)(g)(iv). -/
statute planTransferLoss (f : Facts) named "subparagraph 40(2)(g)(iv)" cites "ITA 40(2)(g)(iv)"
  applies where
    | "loss" isLoss f.disposition
        => "The taxpayer has a loss from the disposition."
        else "The taxpayer has no loss from the disposition."
    | "(A) or (B)" := (Rule.or "clause (A) or (B)" "ITA 40(2)(g)(iv)" planTransferA planTransferB)

@[simp] theorem planTransferLoss_holds (f : Facts) :
    planTransferLoss.holds f = (isLoss f.disposition &&
      ((((transferPlan f).map (·.inA) == some true) && ((f.transfer.map (·.taxpayerBeneficiary)) == some true)) ||
       (((transferPlan f) == some .rrsp) && ((f.transfer.map (·.annuitant)) == some true)))) := by
  simp [planTransferLoss, planTransferA, planTransferB]

/-- A loss on property given to one's own TFSA is always denied by (iv). -/
theorem planTransferLoss_tfsa (f : Facts) (hl : isLoss f.disposition = true) (t : TransferFacts)
    (ht : f.transfer = some t) (hp : t.plan = .tfsa) (hb : t.taxpayerBeneficiary = true) :
    planTransferLoss.holds f = true := by
  simp [hl, ht, hp, hb, transferPlan, PlanTrust.inA]

end Canteen.ITA.Paragraph40_2_g

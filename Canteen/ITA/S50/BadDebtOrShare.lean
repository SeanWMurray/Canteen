import Canteen.Core.StatuteSyntax
import Canteen.ITA.S38.CapitalGains
import Canteen.ITA.S54.SuperficialLoss

/-!
# Subsection 50(1): bad debts, and shares of bankrupt or insolvent corporations

*Income Tax Act*, as consolidated to 2026-10-29 (verbatim in `statute/ITA-50-1.txt`):

> (1) … where (a) a debt owing to a taxpayer at the end of a taxation year (other than a debt
> owing … in respect of the disposition of personal-use property) is established by the taxpayer to
> have become a bad debt in the year, or (b) a share (other than a share received … as
> consideration in respect of the disposition of personal-use property) of the capital stock of a
> corporation is owned by the taxpayer at the end of a taxation year and (i) the corporation has
> during the year become a bankrupt, (ii) [it] is … insolvent … and … a winding-up order … has been
> made in the year, or (iii) at the end of the year, (A) the corporation is insolvent, (B) neither
> the corporation nor a corporation controlled by it carries on business, (C) the fair market value
> of the share is nil, and (D) it is reasonable to expect that the corporation will be dissolved or
> wound up and will not commence to carry on business and the taxpayer elects in the taxpayer's
> return of income for the year to have this subsection apply …, the taxpayer shall be deemed to
> have disposed of the debt or the share … at the end of the year for proceeds equal to nil and to
> have reacquired it immediately after the end of the year at a cost equal to nil.

Whether a debt has become bad, and whether dissolution is reasonable to expect ((b)(iii)(D)), are
facts or judgment calls. Where the debt or share is of a small business corporation, the loss is a
business investment loss (39(1)(c)(ii)), given here as a fact. A disposition deemed by section 50
is excepted from the superficial loss definition by its paragraph (c).
-/

namespace Canteen.ITA.BadDebtOrShare

/-- What the property is, and why 50(1) may apply. -/
inductive Kind where
  /-- (a): a debt; whether it was established to have become bad in the year. -/
  | debt (bad : Answer)
  /-- (b)(i): a share of a corporation that became a bankrupt in the year. -/
  | shareBankrupt
  /-- (b)(ii): a share of an insolvent corporation wound up under the Winding-up and Restructuring Act in the year. -/
  | shareWoundUp
  /-- (b)(iii): a share of a corporation that, at year end, is insolvent, carries on no business (nor does
  a corporation it controls), whose share is worth nil, and which is reasonably expected to be dissolved. -/
  | shareDormant (insolventNoBusinessNil : Bool) (dissolutionExpected : Answer)
  deriving Repr, DecidableEq, Inhabited

structure Facts where
  /-- The debt or share, e.g. `"the loan to Opco"`. -/
  description : String
  kind : Kind
  /-- Owing to, or owned by, the taxpayer at the end of the year. -/
  heldAtYearEnd : Bool := true
  /-- Arose from (or was received for) a disposition of personal-use property: 50(2) instead. -/
  fromPersonalUse : Bool := false
  elected : Bool := true
  adjustedCostBase : Cents
  /-- The debt or share is of a small business corporation, disposed of to which 39(1)(c) applies. -/
  businessInvestment : Bool := false
  taxationYearEnd : Date
  deriving Repr, Inhabited

def qualifies : Kind → Bool
  | .debt bad => bad.value
  | .shareBankrupt | .shareWoundUp => true
  | .shareDormant a b => a && b.value

def kindJudgments : Kind → List String
  | .debt bad => bad.judgments
  | .shareDormant a b => if a then b.judgments else []
  | _ => []

/-- Subsection 50(1). -/
statute applies (f : Facts) named "subsection 50(1)" cites "ITA 50(1)"
  applies where
    | "(a), (b)" judgments (kindJudgments f.kind) (qualifies f.kind)
        => "The debt is established to have become bad in the year, or the corporation became bankrupt, was wound up insolvent, or is insolvent, dormant, its shares worthless and its dissolution expected."
        else "The debt has not become bad, or the corporation is not bankrupt, wound up, or insolvent and dormant with its dissolution expected."
    | "held" f.heldAtYearEnd
        => "The taxpayer held it at the end of the year."
        else "The taxpayer did not hold it at the end of the year."
    | "not personal-use" (!f.fromPersonalUse)
        => "It did not arise from a disposition of personal-use property."
        else "It arose from a disposition of personal-use property (subsection 50(2) deals with it)."
    | "election" f.elected
        => "The taxpayer elects to have subsection 50(1) apply."
        else "The taxpayer does not elect."

/-- The deemed disposition at year end, for nil. -/
def disposition (f : Facts) : Option CapitalGains.Disposition :=
  if applies.holds f then
    some { description := f.description, proceeds := 0, adjustedCostBase := f.adjustedCostBase,
           businessInvestment := f.businessInvestment }
  else none

/-- The deemed disposition, for the superficial loss definition: deemed by section 50, so excepted
by its paragraph (c). -/
def slDisposition (f : Facts) : SuperficialLoss.Disposition :=
  { description := f.description, date := f.taxationYearEnd, proceeds := 0, adjustedCostBase := f.adjustedCostBase,
    outlaysAndExpenses := 0, deemedBy := some .s50 }

/-- The cost after: reacquired at nil. -/
def costAfter (f : Facts) : Cents := if applies.holds f then 0 else f.adjustedCostBase

/-! ## Truths about 50(1) -/

/-- The whole cost is a capital loss (or a business investment loss). -/
theorem loss_is_cost (f : Facts) (h : applies.holds f = true) :
    (disposition f).map (·.loss) = some f.adjustedCostBase := by
  simp [disposition, h, CapitalGains.Disposition.loss]

/-- Never a superficial loss. -/
theorem not_superficial (f : Facts) (as : List SuperficialLoss.Acquisition) :
    SuperficialLoss.superficialLoss ⟨slDisposition f, as⟩ = false := by
  simp [SuperficialLoss.superficialLoss, SuperficialLoss.excepted, SuperficialLoss.paraC, slDisposition,
    SuperficialLoss.DeemingProvision.listedInC]

end Canteen.ITA.BadDebtOrShare

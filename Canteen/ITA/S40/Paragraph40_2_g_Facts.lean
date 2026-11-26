import Canteen.Core.Answer
import Canteen.ITA.S54.SuperficialLoss

/-!
# The facts paragraph 40(2)(g) needs

One record for the whole paragraph, so that each subparagraph can be a rule over the same
facts, and the paragraph can be built from them (`Paragraph40_2_g.lean`).
-/

namespace Canteen.ITA.Paragraph40_2_g

/-- Subparagraph (ii): a debt or other right to receive an amount. -/
structure DebtFacts where
  /-- The property disposed of is a debt or other right to receive an amount. -/
  isDebtOrRight : Bool := false
  /-- It was acquired by the taxpayer for the purpose of gaining or producing income from a
  business or property (other than exempt income). Usually a judgment call. -/
  incomePurpose : Answer := .fact false
  /-- It was acquired as consideration for the disposition of capital property. -/
  considerationForCapitalProperty : Bool := false
  /-- The taxpayer was dealing at arm's length with the person to whom the capital property
  was disposed of. A fact for related persons (section 251); otherwise usually a judgment call. -/
  armsLength : Answer := .fact false
  deriving Repr, DecidableEq, Inhabited

/-- The kinds of property listed in the definition "listed personal property" (section 54). -/
inductive ListedKind where
  /-- (a) print, etching, drawing, painting, sculpture, or other similar work of art -/
  | artwork
  /-- (b) jewellery -/
  | jewellery
  /-- (c) rare folio, rare manuscript, or rare book -/
  | rareBook
  /-- (d) stamp -/
  | stamp
  /-- (e) coin -/
  | coin
  deriving Repr, DecidableEq, Inhabited

def ListedKind.describe : ListedKind → String
  | .artwork => "a print, etching, drawing, painting, sculpture, or other similar work of art"
  | .jewellery => "jewellery"
  | .rareBook => "a rare folio, rare manuscript, or rare book"
  | .stamp => "a stamp"
  | .coin => "a coin"

/-- Subparagraph (iii): personal-use property, as defined in section 54. -/
structure PersonalUseFacts where
  /-- Paragraph (a) of the definition: owned by the taxpayer and used primarily for the
  personal use or enjoyment of the taxpayer or of individuals each of whom is the taxpayer, a
  person related to the taxpayer, or (for a trust) a beneficiary or a person related to one.
  "Primarily" is usually a judgment call. -/
  primarilyPersonalUse : Answer := .fact false
  /-- Paragraph (b): a debt owing to the taxpayer in respect of the disposition of property
  that was the taxpayer's personal-use property. -/
  debtForPersonalUseProperty : Bool := false
  /-- Paragraph (c): an option to acquire property that would be the taxpayer's personal-use
  property if acquired. -/
  optionOnPersonalUseProperty : Bool := false
  /-- The property is, or is a portion of or an interest in or right to, a kind listed in the
  definition "listed personal property", if any. -/
  listedKind : Option ListedKind := none
  /-- The property is a debt referred to in subsection 50(2) (an input: not yet encoded). -/
  debtReferredTo50_2 : Bool := false
  deriving Repr, DecidableEq, Inhabited

/-- The trusts listed in subparagraph (iv). -/
inductive PlanTrust where
  /-- (A) a deferred profit sharing plan -/
  | dpsp
  /-- (A) an employees profit sharing plan -/
  | epsp
  /-- (A) a FHSA -/
  | fhsa
  /-- (A) a registered disability savings plan -/
  | rdsp
  /-- (A) a registered retirement income fund -/
  | rrif
  /-- (A) a TFSA -/
  | tfsa
  /-- (B) a registered retirement savings plan -/
  | rrsp
  /-- Any other trust. -/
  | other (description : String)
  deriving Repr, DecidableEq, Inhabited

def PlanTrust.describe : PlanTrust → String
  | .dpsp => "a deferred profit sharing plan"
  | .epsp => "an employees profit sharing plan"
  | .fhsa => "a FHSA"
  | .rdsp => "a registered disability savings plan"
  | .rrif => "a registered retirement income fund"
  | .tfsa => "a TFSA"
  | .rrsp => "a registered retirement savings plan"
  | .other d => d

/-- Listed in clause (iv)(A). -/
def PlanTrust.inA : PlanTrust → Bool
  | .dpsp | .epsp | .fhsa | .rdsp | .rrif | .tfsa => true
  | _ => false

/-- Subparagraph (iv): the property was disposed of to a trust. -/
structure TransferFacts where
  /-- The plan or fund that governs the trust. -/
  plan : PlanTrust
  /-- (A) The taxpayer is a beneficiary under it, or becomes one immediately after the disposition. -/
  taxpayerBeneficiary : Bool := false
  /-- (B) The taxpayer or the taxpayer's spouse or common-law partner is an annuitant under it,
  or becomes one within 60 days after the end of the taxation year. -/
  annuitant : Bool := false
  deriving Repr, DecidableEq, Inhabited

/-- Everything paragraph 40(2)(g) needs. -/
structure Facts where
  /-- The disposition and acquisitions, for subparagraph (i) (the superficial loss definition). -/
  sl : SuperficialLoss.Facts
  /-- The carve-out in the opening words (see `LossDenial.Facts.surplusExcludedProperty`). -/
  surplusExcludedProperty : Bool := false
  debt : DebtFacts := {}
  personalUse : PersonalUseFacts := {}
  /-- The trust the property was disposed of to, if any. -/
  transfer : Option TransferFacts := none
  deriving Repr, DecidableEq

/-- The disposition. -/
def Facts.disposition (f : Facts) : SuperficialLoss.Disposition := f.sl.disposition

end Canteen.ITA.Paragraph40_2_g

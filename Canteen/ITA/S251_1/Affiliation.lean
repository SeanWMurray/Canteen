import Canteen.Core.StatuteSyntax
import Canteen.ITA.S54.SuperficialLoss

/-!
# Subsection 251.1(1), paragraph (a): affiliated persons

*Income Tax Act*, subsection 251.1(1), as consolidated to 2026-10-29 (verbatim in
`statute/ITA-251-1-1-a.txt`):

> (1) For the purposes of this Act, affiliated persons, or persons affiliated with each
> other, are
> (a) an individual and a spouse or common-law partner of the individual; …

Paragraph (a) is encoded. Paragraphs (b) to (g) (corporations, partnerships and trusts) are
not: whether one of them applies is taken as a fact. Who is a spouse or common-law partner
(subsection 248(1), "common-law partner") is also a fact.
-/

namespace Canteen.ITA.Affiliation

/-- The facts subsection 251.1(1) needs about two persons. -/
structure Facts where
  /-- The first person is an individual. -/
  individual : Bool
  /-- The second person is a spouse or common-law partner of the first. -/
  spouseOrCommonLawPartner : Bool
  /-- One of paragraphs 251.1(1)(b) to (g) applies (an input: not yet encoded). -/
  otherParagraph : Bool := false
  deriving Repr, DecidableEq

/-- Paragraph 251.1(1)(a): an individual and a spouse or common-law partner of the individual. -/
statute paragraphA (f : Facts) named "paragraph 251.1(1)(a)" cites "ITA 251.1(1)(a)"
  applies where
    | "" f.individual
        => "The first person is an individual."
        else "The first person is not an individual."
    | "" f.spouseOrCommonLawPartner
        => "The second person is a spouse or common-law partner of the individual."
        else "The second person is not a spouse or common-law partner of the individual."

/-- Paragraphs 251.1(1)(b) to (g), taken as a fact. -/
def otherParagraphs : Rule Facts :=
  Rule.clause "(b) to (g)" "ITA 251.1(1)(b)-(g)" Facts.otherParagraph
    "One of paragraphs 251.1(1)(b) to (g) applies to the two persons."
    "None of paragraphs 251.1(1)(b) to (g) applies to the two persons."

/-- Subsection 251.1(1): the two persons are affiliated. -/
def affiliated : Rule Facts :=
  Rule.or "affiliation under subsection 251.1(1)" "ITA 251.1(1)" paragraphA otherParagraphs

@[simp] theorem affiliated_holds (f : Facts) :
    affiliated.holds f = ((f.individual && f.spouseOrCommonLawPartner) || f.otherParagraph) := by
  simp [affiliated, paragraphA, otherParagraphs]

/-- An individual and their spouse or common-law partner are always affiliated. -/
theorem spouses_affiliated (f : Facts) (hi : f.individual = true) (hs : f.spouseOrCommonLawPartner = true) :
    affiliated.holds f = true := by
  simp [hi, hs]

/-- Two individuals who are not spouses or common-law partners are affiliated only through
paragraphs (b) to (g). -/
theorem individuals_not_spouses (f : Facts) (hs : f.spouseOrCommonLawPartner = false) :
    affiliated.holds f = f.otherParagraph := by
  simp [hs]

/-- Who acquired a property, for the superficial loss definition, decided by subsection
251.1(1) rather than taken as a fact. -/
def acquirer (who : String) (f : Facts) : SuperficialLoss.Acquirer :=
  if affiliated.holds f then .affiliated who else .notAffiliated who

theorem acquirer_isTaxpayerOrAffiliated (who : String) (f : Facts) :
    (acquirer who f).isTaxpayerOrAffiliated = affiliated.holds f := by
  unfold acquirer
  cases affiliated.holds f <;> rfl

end Canteen.ITA.Affiliation

import Canteen.Core.Blueprint
import Canteen.ITA.S54.SuperficialLoss
import Canteen.ITA.S40.LossDenial
import Canteen.Lemmas.SuperficialLoss
import Canteen.ITA.S40.LossDenialStatute
import Canteen.ITA.S53.CostAddition
import Canteen.ITA.S251_1.Affiliation
import Canteen.ITA.S251_1.AffiliatedPersons
import Canteen.ITA.S251.RelatedPersons
import Canteen.ITA.S40.Paragraph40_2_g

/-!
# Blueprint: section 54 "superficial loss" and subparagraph 40(2)(g)(i)

Each paragraph of the statute, quoted, linked to the Lean that encodes it; the truths
proven about it; and what is not yet formalized.
-/

namespace Canteen.Blueprints.SuperficialLoss

open Canteen.Blueprint Canteen.ITA Canteen.ITA.SuperficialLoss

def cite (p : String) : String := s!"ITA 54 \"superficial loss\" {p}"

def blueprint : Blueprint where
  title := "Section 54 \"superficial loss\", paragraph 40(2)(g), and related provisions"
  summary := [
    "Each paragraph of the definition is quoted from the *Income Tax Act* (consolidation current to " ++
      "2026-10-29; verbatim in `statute/`) and linked to the Lean definition that encodes it. " ++
      "Lean cannot check that an encoding matches the statute; that is what " ++
      "[`docs/review/superficial-loss.md`](../review/superficial-loss.md) is for. " ++
      "Everything built on the encoding is proven."]
  sections := [
    { heading := "The definition, paragraph by paragraph"
      nodes := [
        { id := "P0", kind := .law, title := "Opening words: a loss", citation := "ITA 54 \"superficial loss\"; 40(1)(b)"
          statement := "“superficial loss of a taxpayer means the taxpayer’s loss from the disposition of a particular property where”. " ++
            "The loss is the amount by which the adjusted cost base plus outlays and expenses exceeds the proceeds (paragraph 40(1)(b))."
          lean := [``isLoss, ``lossAmount] },
        { id := "Pa", kind := .law, title := "(a) acquisition in the 61-day period", citation := cite "(a)"
          statement := "“(a) during the period that begins 30 days before and ends 30 days after the disposition, the taxpayer or a " ++
            "person affiliated with the taxpayer acquires a property (in this definition referred to as the “substituted property”) " ++
            "that is, or is identical to, the particular property, and”"
          lean := [``inPeriod, ``Acquirer.isTaxpayerOrAffiliated, ``Acquirer] },
        { id := "Pb", kind := .law, title := "(b) held at the end of the period", citation := cite "(b)"
          statement := "“(b) at the end of that period, the taxpayer or a person affiliated with the taxpayer owns or had a right to " ++
            "acquire the substituted property,”"
          lean := [``paraB] },
        { id := "Pc", kind := .law, title := "(c) listed deemed dispositions", citation := cite "(c)"
          statement := "“except where the disposition was (c) a disposition deemed to have been made by subsection 45(1), section 48 as " ++
            "it read in its application before 1993, section 50 or 70, subsection 104(4), section 128.1, paragraph 132.2(3)(a) or (c), " ++
            "subsection 138(11.3) or 138.2(4) or 142.5(2), section 142.6 or any of subsections 144(4.1) and (4.2) and 149(10),”"
          lean := [``DeemingProvision, ``DeemingProvision.listedInC, ``paraC] },
        { id := "Pd", kind := .law, title := "(d) expiry of an option", citation := cite "(d)"
          statement := "“(d) the expiry of an option,”", lean := [``paraD] },
        { id := "Pe", kind := .law, title := "(e) paragraph 40(2)(e.1) applies", citation := cite "(e)"
          statement := "“(e) a disposition to which paragraph 40(2)(e.1) applies,”", lean := [``paraE] },
        { id := "Pf", kind := .law, title := "(f) loss restriction event", citation := cite "(f)"
          statement := "“(f) a disposition by a taxpayer that was subject to a loss restriction event within 30 days after the disposition,”"
          lean := [``paraF] },
        { id := "Pg", kind := .law, title := "(g) change in exempt status", citation := cite "(g)"
          statement := "“(g) a disposition by a person that, within 30 days after the disposition, became or ceased to be exempt from " ++
            "tax under this Part on its taxable income, or”"
          lean := [``paraG] },
        { id := "Ph", kind := .law, title := "(h) 40(3.4) or 69(5) applies", citation := cite "(h)"
          statement := "“(h) a disposition to which subsection 40(3.4) or 69(5) applies,”", lean := [``paraH] },
        { id := "Pi", kind := .law, title := "(i) rights to acquire are identical", citation := cite "(i)"
          statement := "“and, for the purpose of this definition, (i) a right to acquire a property (other than a right, as security " ++
            "only, derived from a mortgage, hypothec, agreement for sale or similar obligation) is deemed to be a property that is " ++
            "identical to the property, and”"
          lean := [``Identity] },
        { id := "Pj", kind := .law, title := "(j) SIFT wind-up shares before 2013", citation := cite "(j)"
          statement := "“(j) a share of the capital stock of a SIFT wind-up corporation in respect of a SIFT wind-up entity is, if the " ++
            "share was acquired before 2013, deemed to be a property that is identical to equity in the SIFT wind-up entity.”"
          lean := [``acquiredBefore2013] },
        { id := "Pa+", kind := .law, title := "(a) with the deeming rules", citation := cite "(a), (i), (j)"
          statement := "Whether an acquired property “is, or is identical to, the particular property”, with paragraphs (i) " ++
            "and (j) applied, and paragraph (a) as a whole."
          lean := [``isOrIsIdentical, ``paraA], uses := ["Pa", "Pi", "Pj"] },
        { id := "D", kind := .law, title := "The definition as a whole", citation := cite ""
          statement := "A loss is a superficial loss if there is a loss, some acquired property meets both (a) and (b), and none of " ++
            "(c) to (h) applies."
          lean := [``superficialLoss, ``qualifies, ``excepted]
          uses := ["P0", "Pa", "Pb", "Pc", "Pd", "Pe", "Pf", "Pg", "Ph", "Pi", "Pj", "Pa+"] },
        { id := "E", kind := .law, title := "The English explanation agrees", citation := cite ""
          statement := "For every set of facts, the English explanation reaches the same conclusion as the definition. It gives " ++
            "factual reasons before reasons that rest on a judgment call."
          lean := [``explain_sound, ``SuperficialLoss.rule], uses := ["D"] },
        { id := "S", kind := .law, title := "The definition in statute form", citation := cite ""
          statement := "The definition written with the `statute` command, in the Act's own shape: a loss where (a) and (b), " ++
            "except where (c) to (h). Proven to be the same rule as the paragraph-by-paragraph encoding."
          lean := [``superficialLossStatute, ``superficialLossStatute_eq], uses := ["D"] } ] },
    { heading := "Truths proven about the definition"
      text := ["Proven once, for every set of facts, and reusable in any transaction (Layer 2)."]
      nodes := [
        { id := "L1", kind := .law, title := "Restatement", statement :=
            "A loss is superficial exactly when there is a loss, some acquisition meets (a) and (b), and the disposition is not excepted."
          lean := [``superficialLoss_iff], uses := ["D"] },
        { id := "L2", kind := .law, title := "No loss, no superficial loss",
          statement := "Without a loss there is never a superficial loss.", lean := [``not_of_no_loss], uses := ["P0", "D"] },
        { id := "L3", kind := .law, title := "Exceptions always win",
          statement := "If any of (c) to (h) applies, the loss is not superficial, whatever was acquired and however the identity " ++
            "judgment calls are answered."
          lean := [``not_of_excepted], uses := ["Pc", "Pd", "Pe", "Pf", "Pg", "Ph", "D"] },
        { id := "L4", kind := .law, title := "Option expiry",
          statement := "The expiry of an option never gives a superficial loss.", lean := [``not_of_option_expiry], uses := ["L3"] },
        { id := "L5", kind := .law, title := "Death",
          statement := "A disposition deemed by section 70 never gives a superficial loss.", lean := [``not_of_death], uses := ["L3"] },
        { id := "L6", kind := .law, title := "Nothing acquired",
          statement := "If nothing was acquired, there is no superficial loss.", lean := [``not_of_no_acquisitions], uses := ["D"] },
        { id := "L7", kind := .law, title := "Outside the period never matters",
          statement := "An acquisition outside the 61-day period never affects the result.",
          lean := [``outside_period_irrelevant], uses := ["Pa+", "D"] },
        { id := "L8", kind := .law, title := "Not held at the end never matters",
          statement := "An acquisition not held at the end of the period never affects the result, so its identity judgment call " ++
            "makes no difference."
          lean := [``not_held_irrelevant], uses := ["Pb", "D"] },
        { id := "L9", kind := .law, title := "Unaffiliated buyers never matter",
          statement := "An acquisition by a person not affiliated with the taxpayer never affects the result.",
          lean := [``not_affiliated_irrelevant], uses := ["Pa+", "D"] },
        { id := "L10", kind := .law, title := "More acquisitions only add",
          statement := "Adding acquisitions can make a loss superficial, never the reverse.",
          lean := [``mono_acquisitions], uses := ["D"] },
        { id := "L11", kind := .law, title := "Rights to acquire",
          statement := "A right to acquire the particular property, other than a security-only right, counts as identical to it.",
          lean := [``right_to_acquire_identical], uses := ["Pa+"] },
        { id := "L12", kind := .law, title := "SIFT shares from 2013",
          statement := "Paragraph (j) does not apply to a SIFT wind-up share acquired in 2013 or later.",
          lean := [``sift_share_after_2012], uses := ["Pa+"] } ] },
    { heading := "Subparagraph 40(2)(g)(i)"
      nodes := [
        { id := "G0", kind := .law, title := "Opening words: the foreign affiliate carve-out", citation := "ITA 40(2)(g)"
          statement := "Paragraph 40(2)(g) does not reach a property that, for the purposes of computing the exempt, hybrid or " ++
            "taxable surplus or deficit of the taxpayer in respect of another taxpayer of which it is a foreign affiliate, is " ++
            "excluded property (subsection 95(1))."
          lean := [``LossDenial.notCarvedOut, ``LossDenial.openingWords] },
        { id := "G1", kind := .law, title := "The loss is nil", citation := "ITA 40(2)(g)(i)"
          statement := "“a taxpayer’s loss, if any, from the disposition of a property …, to the extent that it is (i) a superficial " ++
            "loss, … is nil”. Built from the definition and the carve-out with `Rule.and`, so its explanation is sound by construction."
          lean := [``LossDenial.rule, ``LossDenial.deniedLoss], uses := ["G0", "E"] },
        { id := "GS", kind := .law, title := "40(2)(g)(i) in statute form", citation := "ITA 40(2)(g)(i)"
          statement := "Subparagraph 40(2)(g)(i) written with the `statute` command, with the statute-form definition as " ++
            "subparagraph (i) and the carve-out as the exception. Proven to be the same rule as `LossDenial.rule`."
          lean := [``LossDenial.lossDenialStatute, ``LossDenial.lossDenialStatute_eq], uses := ["G1", "S"] } ] },
    { heading := "Subparagraphs 40(2)(g)(ii) to (iv), and the paragraph as a whole"
      nodes := [
        { id := "G2", kind := .law, title := "(ii) losses on debts", citation := "ITA 40(2)(g)(ii)"
          statement := "“a loss from the disposition of a debt or other right to receive an amount, unless the debt or right, " ++
            "as the case may be, was acquired by the taxpayer for the purpose of gaining or producing income from a business " ++
            "or property (other than exempt income) or as consideration for the disposition of capital property to a person " ++
            "with whom the taxpayer was dealing at arm’s length,”"
          lean := [``Paragraph40_2_g.debtLoss, ``Paragraph40_2_g.debtLoss_holds], uses := ["P0"] },
        { id := "PUP", kind := .law, title := "Personal-use and listed personal property", citation := "ITA 54"
          statement := "Personal-use property includes (a) property used primarily for the personal use or enjoyment of the " ++
            "taxpayer or related individuals, (b) a debt owing in respect of the disposition of personal-use property, and " ++
            "(c) an option to acquire personal-use property. Listed personal property is personal-use property that is, or " ++
            "is a portion of or an interest in or right to, a work of art, jewellery, a rare folio, manuscript or book, a " ++
            "stamp, or a coin."
          lean := [``Paragraph40_2_g.personalUseProperty, ``Paragraph40_2_g.isListed] },
        { id := "G3", kind := .law, title := "(iii) losses on personal-use property", citation := "ITA 40(2)(g)(iii)"
          statement := "“a loss from the disposition of any personal-use property of the taxpayer (other than listed personal " ++
            "property or a debt referred to in subsection 50(2)),”"
          lean := [``Paragraph40_2_g.personalUseLoss, ``Paragraph40_2_g.personalUseLoss_holds], uses := ["P0", "PUP"] },
        { id := "G4", kind := .law, title := "(iv) transfers to registered plans", citation := "ITA 40(2)(g)(iv)"
          statement := "A loss from the disposition of property to (A) a trust governed by a DPSP, EPSP, FHSA, RDSP, RRIF or " ++
            "TFSA under which the taxpayer is, or immediately after becomes, a beneficiary, or (B) a trust governed by an RRSP " ++
            "under which the taxpayer or the taxpayer's spouse or common-law partner is, or within 60 days after the end of " ++
            "the year becomes, an annuitant."
          lean := [``Paragraph40_2_g.planTransferLoss, ``Paragraph40_2_g.planTransferA, ``Paragraph40_2_g.planTransferB,
            ``Paragraph40_2_g.planTransferLoss_holds], uses := ["P0"] },
        { id := "G5", kind := .law, title := "Paragraph 40(2)(g) as a whole", citation := "ITA 40(2)(g)"
          statement := "The loss is nil if it is within any of subparagraphs (i) to (iv), unless the carve-out in the opening " ++
            "words applies. Proven to deny exactly what subparagraph (i) denies when (ii) to (iv) don't apply."
          lean := [``Paragraph40_2_g.paragraph, ``Paragraph40_2_g.paragraph_holds, ``Paragraph40_2_g.paragraph_eq_lossDenial,
            ``Paragraph40_2_g.paragraph_of_lossDenial, ``Paragraph40_2_g.deniedLoss],
          uses := ["G0", "G1", "E", "G2", "G3", "G4"] } ] },
    { heading := "Related provisions"
      nodes := [
        { id := "R1", kind := .law, title := "Spouses are affiliated", citation := "ITA 251.1(1)(a)"
          statement := "“an individual and a spouse or common-law partner of the individual” are affiliated persons. Used " ++
            "to decide who is \"a person affiliated with the taxpayer\" in paragraphs (a) and (b)."
          lean := [``Affiliation.paragraphA, ``Affiliation.affiliated, ``Affiliation.spouses_affiliated] },
        { id := "R3", kind := .law, title := "Affiliated persons, paragraphs (a) to (h)", citation := "ITA 251.1(1)–(4)"
          statement := "Corporations and their controllers (b), two corporations (c), a corporation and a partnership (d), a " ++
            "partnership and a majority-interest partner (e), two partnerships (f), a person and a trust (g), and two trusts (h), with the " ++
            "definitions in 251.1(3), the rules in 251.1(4), and \"majority-interest partner\" in 248(1). Computed for a " ++
            "whole world of persons as the smallest relation closed under the paragraphs; reflexive and symmetric (proven)."
          lean := [``AffiliatedPersons.rule, ``AffiliatedPersons.affiliated_self, ``AffiliatedPersons.affiliated_symm,
            ``AffiliatedPersons.acquirer_isTaxpayerOrAffiliated], uses := ["R1", "Pa"] },
        { id := "R4", kind := .law, title := "Related persons and arm's length", citation := "ITA 251(1)–(6)"
          statement := "Related persons (251(2), (3), with 251(6) for blood relationship, marriage, common-law partnership " ++
            "and adoption) are deemed not to deal at arm's length (251(1)(a)); otherwise it is a question of fact (c). Used " ++
            "for the arm's length exception in subparagraph 40(2)(g)(ii), and 251(6) also decides who is connected for " ++
            "251.1(4)(d)(iv)."
          lean := [``RelatedPersons.rule, ``RelatedPersons.armsLengthRule, ``RelatedPersons.armsLengthAnswer,
            ``RelatedPersons.not_armsLength_of_related, ``RelatedPersons.related_symm] },
        { id := "R2", kind := .law, title := "Cost of the substituted property", citation := "ITA 53(1)(f)"
          statement := "The superficial loss, less any amount described in subparagraph 53(1)(f)(ii), is added to the cost " ++
            "of the substituted property in computing its adjusted cost base."
          lean := [``CostAddition.rule, ``CostAddition.addition, ``CostAddition.cost_le_adjustedCostBase],
          uses := ["Pa+"] } ] },
    { heading := "Not yet formalized"
      text := ["These statements are part of the analysis but have no Lean behind them yet. Anything resting on them says so."]
      nodes := [
        { id := "N1", kind := .law, title := "Inputs decided by other provisions",
          statement := "Affiliation under subsection 251.1(2) (amalgamations), who is a contributor to a trust, a loss " ++
            "restriction event (section 251.2), and whether paragraph 40(2)(e.1) or subsection 40(3.4) or 69(5) applies " ++
            "are taken as facts. So is the amount in subparagraph 53(1)(f)(ii) (subsections 112(3) to (3.2))."
          uses := ["Pa", "Pe", "Pf", "Ph", "R1", "R2", "R3"] },
        { id := "N2", kind := .law, title := "How much is \"to the extent that\"", citation := "ITA 40(2)(g)(i)"
          statement := "Where only part of a loss is a superficial loss (for example, fewer shares acquired than sold), the amount " ++
            "made nil is not computed. The Act gives no formula."
          uses := ["G1"] },
        { id := "N4", kind := .law, title := "Inputs for subparagraphs (ii) to (iv)", citation := "ITA 40(2)(g)"
          statement := "Debts referred to in subsection 50(2), arm's length dealing between unrelated persons (a question of fact " ++
            "under 251(1)(c)), and the ordinary meaning of " ++
            "personal-use property beyond the three categories its definition includes are taken as facts or judgment calls."
          uses := ["G2", "G3", "R4"] } ] } ]

end Canteen.Blueprints.SuperficialLoss

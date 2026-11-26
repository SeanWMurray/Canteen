import Canteen.Core.Blueprint
import Canteen.ITA.S54.SuperficialLoss
import Canteen.ITA.S40.LossDenial
import Canteen.Lemmas.SuperficialLoss
import Canteen.ITA.S40.LossDenialStatute
import Canteen.ITA.S53.CostAddition
import Canteen.ITA.S251_1.Affiliation
import Canteen.ITA.S251_1.AffiliatedPersons
import Canteen.ITA.S251.RelatedPersons
import Canteen.ITA.S251.Amalgamation
import Canteen.ITA.S3.Income
import Canteen.ITA.S111.NetCapitalLoss
import Canteen.ITA.S40.ShareToAffiliate
import Canteen.ITA.S40.RelatedDebt
import Canteen.ITA.S40.PrincipalResidence
import Canteen.ITA.S69.NonArmsLength
import Canteen.ITA.S73.SpousalRollover
import Canteen.ITA.S70.Death
import Canteen.ITA.S74.Attribution
import Canteen.ITA.S45.ChangeInUse
import Canteen.ITA.S85.TransferToCorporation
import Canteen.ITA.S84_1.SurplusStripping
import Canteen.ITA.S50.BadDebtPersonalUse
import Canteen.ITA.S40.SuspendedLoss
import Canteen.Lemmas.SuspendedLoss
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
          lean := [``sift_share_after_2012], uses := ["Pa+"] },
        { id := "L13", kind := .law, title := "When nothing qualifies", statement :=
            "If every acquisition is outside the period, by someone not affiliated with the taxpayer, or not held at the " ++
            "end of the period, the loss is not superficial, however any judgment calls are answered."
          lean := [``not_of_all_fail], uses := ["Pa+", "Pb", "D"] },
        { id := "L14", kind := .law, title := "The 31-day safe harbour", statement :=
            "If every acquisition, by anyone, is more than 30 days after the disposition, the loss is not superficial."
          lean := [``safe_harbour], uses := ["L13"] } ] },
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
        { id := "R7", kind := .law, title := "Amalgamations", citation := "ITA 251.1(2), 251(3.1), (3.2)"
          statement := "The new corporation and a predecessor are deemed affiliated (251.1(2)) or related (251(3.1)) if they " ++
            "would have been, had the new corporation existed immediately before with the shareholders it had immediately " ++
            "after; and related if the predecessors were each related to each other, otherwise than because of a 251(5)(b) " ++
            "right (251(3.2)). The counterfactual is a hypothetical world given to the affiliation and related-persons rules."
          lean := [``Amalgamation.hypothetical, ``Amalgamation.affiliatedRule, ``Amalgamation.relatedRule,
            ``Amalgamation.related_of_predecessorsRelated], uses := ["R3", "R4"] },
        { id := "R10", kind := .law, title := "Shares to an affiliated corporation; debts within a related group", citation := "ITA 40(3.6), (2)(e.1); 53(1)(f.1), (f.2)"
          statement := "A loss on a share disposed of to the issuing corporation, affiliated immediately after, is nil and spread " ++
            "over the taxpayer's remaining shares of it (40(3.6), 53(1)(f.2)). A loss on an obligation disposed of within a " ++
            "group of three related persons is nil (40(2)(e.1)), and paragraph (e) of the superficial loss definition " ++
            "then excludes it."
          lean := [``ShareToAffiliate.rule, ``ShareToAffiliate.addition_le_loss, ``ShareToAffiliate.not_of_not_affiliated,
            ``RelatedDebt.applies, ``RelatedDebt.denied, ``RelatedDebt.not_superficial, ``RelatedDebt.not_of_unrelated_transferee],
          uses := ["Pe", "D", "R3", "R4"] },
        { id := "R5", kind := .law, title := "A personal-use debt that goes bad", citation := "ITA 50(2)"
          statement := "A debt that is personal-use property, owing by an arm's length person and established to be bad, is " ++
            "deemed disposed of for its cost less the gain on the sale that gave rise to it; so the loss never exceeds that " ++
            "gain. Subparagraph 40(2)(g)(iii) excludes such a debt."
          lean := [``BadDebtPersonalUse.rule, ``BadDebtPersonalUse.deemedProceeds, ``BadDebtPersonalUse.loss_eq_min,
            ``BadDebtPersonalUse.loss_le_gain] },
        { id := "R6", kind := .law, title := "Suspended losses of corporations, trusts and partnerships", citation := "ITA 40(3.3)–(3.5)"
          statement := "The counterpart of the superficial loss rule for corporations, trusts and partnerships: the loss is " ++
            "nil but suspended until the first of the times in 40(3.4)(b). Paragraph (h) of the superficial loss definition " ++
            "defers to it, and it uses that definition's period and exceptions (c) to (g)."
          lean := [``SuspendedLoss.applies, ``SuspendedLoss.rule, ``SuspendedLoss.releaseDate,
            ``SuspendedLoss.not_superficial_of_applies, ``SuspendedLoss.not_individual, ``SuspendedLoss.not_of_excepted,
            ``SuspendedLoss.not_of_all_fail, ``SuspendedLoss.safe_harbour],
          uses := ["Pc", "Pd", "Pe", "Pf", "Pg", "Ph", "D", "R3"] },
        { id := "R8", kind := .law, title := "The tax result: capital gains and income", citation := "ITA 3, 38–41"
          statement := "A loss made nil by 40(2)(g) or 40(3.4) is no capital loss (39(1)(b)), so no allowable capital loss " ++
            "(38(b)) reduces the year's taxable capital gains in 3(b). Capital losses reduce only capital gains; an " ++
            "allowable business investment loss reduces any income (3(d)). Amounts are exact, in half-cents."
          lean := [``CapitalGains.ofParagraph40_2_g, ``CapitalGains.ofSuspendedLoss, ``CapitalGains.capitalLoss_of_lossNil,
            ``Income.income, ``Income.capital_losses_only_offset_gains, ``Income.abil_reduces_income],
          uses := ["G5", "R6"] },
        { id := "R9", kind := .law, title := "Net capital losses and taxable income", citation := "ITA 111(8), (1)(b), (1.1); 2(2)"
          statement := "Allowable capital losses that 3(b) cannot use are a net capital loss (111(8)), deductible against " ++
            "taxable capital gains of preceding years and the three following years (111(1)(b)), adjusted for the loss " ++
            "year's inclusion rate (111(1.1)(a)). A loss denied as superficial never becomes one."
          lean := [``NetCapitalLoss.netCapitalLoss, ``NetCapitalLoss.deduction, ``NetCapitalLoss.taxableIncome,
            ``NetCapitalLoss.deduction_le_para3b, ``NetCapitalLoss.not_allowed_far_future], uses := ["R8"] },
        { id := "R12", kind := .law, title := "Transfers not at arm's length, and gifts", citation := "ITA 69(1)"
          statement := "A sale below fair market value to a person not at arm's length, a gift, or a transfer to a trust without " ++
            "a change in beneficial ownership is at fair market value for the seller (b); an overpayment to such a person, " ++
            "or a gift received, is at fair market value for the buyer (a), (c). Proven: an undervalue sale is taxed twice."
          lean := [``NonArmsLength.sellerAtFairMarketValue, ``NonArmsLength.buyerAtFairMarketValue,
            ``NonArmsLength.undervalue_sale_double_counted, ``NonArmsLength.gift_at_fair_market_value,
            ``NonArmsLength.sellerDisposition], uses := ["R4", "R8"] },
        { id := "R13", kind := .law, title := "The spousal rollover", citation := "ITA 73(1), (1.01)"
          statement := "Capital property of an individual transferred to a spouse or common-law partner, a former one in " ++
            "settlement, or a qualifying spousal, alter ego or joint trust, both resident, passes at its adjusted cost base " ++
            "unless the individual elects out; then 69(1) governs. Proven: no gain, and the cost carries over."
          lean := [``SpousalRollover.rollover, ``SpousalRollover.proceeds, ``SpousalRollover.transfereeCost,
            ``SpousalRollover.no_gain_on_rollover, ``SpousalRollover.elect_out], uses := ["R12"] },
        { id := "R14", kind := .law, title := "Death", citation := "ITA 70(5), (6), (6.2)"
          statement := "On death, each capital property is deemed disposed of at fair market value (70(5)); property passing " ++
            "to a resident spouse or a qualifying spousal trust, vested within 36 months, rolls over at its adjusted cost " ++
            "base (70(6)), unless the representative elects out (70(6.2)). The deemed disposition is excepted from the " ++
            "superficial loss definition by its paragraph (c)."
          lean := [``Death.rollover, ``Death.proceeds, ``Death.terminalDispositions, ``Death.rollover_no_gain,
            ``Death.to_child_at_fair_market_value, ``Death.slDisposition], uses := ["R8", "Pc"] },
        { id := "R15", kind := .law, title := "Attribution of capital gains to the transferor", citation := "ITA 74.2(1); 74.5(1), (3)"
          statement := "After property is lent or transferred to a spouse or common-law partner, the net taxable capital " ++
            "gains (or allowable capital losses) on the spouse's dispositions of it in the attribution period are the " ++
            "transferor's, and not the spouse's; unless the transfer was for fair market value with the 74.5(1) conditions, " ++
            "or the two are separated and jointly elect."
          lean := [``Attribution.toIndividual, ``Attribution.recipientYear, ``Attribution.fairMarketValueException,
            ``Attribution.net_one_way, ``Attribution.nothing_on_fair_market_value], uses := ["R8", "R13"] },
        { id := "R16", kind := .law, title := "Change in use", citation := "ITA 45(1)–(4)"
          statement := "A change in the use regularly made of a property between gaining or producing income and other " ++
            "purposes is a deemed disposition, at fair market value, of the proportion that changed, and a reacquisition at " ++
            "that amount; unless the taxpayer elects under 45(2) (toward income) or 45(3) (back to a principal residence, " ++
            "with no capital cost allowance claimed: 45(4)). Proven: the gains add up, and the deemed disposition is never " ++
            "a superficial loss (paragraph (c))."
          lean := [``ChangeInUse.deemedDisposition, ``ChangeInUse.proceeds, ``ChangeInUse.costAfter, ``ChangeInUse.elect_45_2,
            ``ChangeInUse.cca_defeats_45_3, ``ChangeInUse.gains_add_up, ``ChangeInUse.not_superficial],
          uses := ["R8", "D"] },
        { id := "R17", kind := .law, title := "Transfer of property to a corporation", citation := "ITA 85(1), (2.1)"
          statement := "Eligible property transferred to a taxable Canadian corporation for consideration including its " ++
            "shares, with a joint election, is disposed of at the elected amount: the amount agreed, but at least the boot " ++
            "and the lesser of cost and value (or, for depreciable property, the least of UCC, cost and value), and at most " ++
            "fair market value; plus any benefit conferred on a related person (e.2). The boot, preferred and common shares " ++
            "take their costs in that order, and the shares' paid-up capital is ground down to the cost less the boot."
          lean := [``TransferToCorporation.rollover, ``TransferToCorporation.electedAmount, ``TransferToCorporation.commonCost,
            ``TransferToCorporation.at_cost_no_gain, ``TransferToCorporation.boot_le_elected,
            ``TransferToCorporation.puc_single_class], uses := ["R8"] },
        { id := "R18", kind := .law, title := "Shares sold to a non-arm's length corporation", citation := "ITA 84.1(1), (2); 54 \"proceeds of disposition\" (k)"
          statement := "An individual resident in Canada who disposes of shares to a corporation not at arm's length, connected " ++
            "with the subject corporation after, has the new shares' paid-up capital ground down, and is deemed to receive " ++
            "a dividend for what comes out above the greater of the shares' paid-up capital and their hard adjusted cost base; " ++
            "the dividend is not proceeds. Proven: boot above that amount is a dividend, dollar for dollar."
          lean := [``SurplusStripping.applies, ``SurplusStripping.dividend, ``SurplusStripping.proceeds,
            ``SurplusStripping.boot_over_e_is_dividend, ``SurplusStripping.no_dividend_within_e,
            ``SurplusStripping.ofTransfer], uses := ["R8", "R17"] },
        { id := "R11", kind := .law, title := "The principal residence exemption", citation := "ITA 40(2)(b); 54 \"principal residence\""
          statement := "A home is the principal residence for a year if owned, ordinarily inhabited by the family (or covered by " ++
            "a 45(2) or (3) election, for at most four years: (d)), designated, and not blocked by another family-unit " ++
            "designation; the gain is A − A × B / C " ++
            "− D, so with the \"plus one\" a home designated for all but one of its years is fully exempt (proven)."
          lean := [``PrincipalResidence.principalResidence, ``PrincipalResidence.gain, ``PrincipalResidence.exempt_of_b_ge_c,
            ``PrincipalResidence.exempt_le, ``PrincipalResidence.paraD, ``CapitalGains.ofPrincipalResidence],
          uses := ["R8", "R16"] },
        { id := "R2", kind := .law, title := "Cost of the substituted property", citation := "ITA 53(1)(f)"
          statement := "The superficial loss, less any amount described in subparagraph 53(1)(f)(ii), is added to the cost " ++
            "of the substituted property in computing its adjusted cost base."
          lean := [``CostAddition.rule, ``CostAddition.addition, ``CostAddition.cost_le_adjustedCostBase],
          uses := ["Pa+"] } ] },
    { heading := "Not yet formalized"
      text := ["These statements are part of the analysis but have no Lean behind them yet. Anything resting on them says so."]
      nodes := [
        { id := "N1", kind := .law, title := "Inputs decided by other provisions",
          statement := "Who is a contributor to a trust, a loss " ++
            "restriction event (section 251.2), and whether paragraph 40(2)(e.1) or subsection 40(3.4) or 69(5) applies " ++
            "are taken as facts. So is the amount in subparagraph 53(1)(f)(ii) (subsections 112(3) to (3.2))."
          uses := ["Pa", "Pe", "Pf", "Ph", "R1", "R2", "R3"] },
        { id := "N2", kind := .law, title := "How much is \"to the extent that\"", citation := "ITA 40(2)(g)(i)"
          statement := "Where only part of a loss is a superficial loss (for example, fewer shares acquired than sold), the amount " ++
            "made nil is not computed. The Act gives no formula."
          uses := ["G1"] },
        { id := "N4", kind := .law, title := "Inputs for subparagraphs (ii) to (iv)", citation := "ITA 40(2)(g)"
          statement := "Whether subsection 50(2) applies to a debt (computed by R5 where its facts are given), arm's length " ++
            "dealing between unrelated persons (a question of fact " ++
            "under 251(1)(c)), and the ordinary meaning of " ++
            "personal-use property beyond the three categories its definition includes are taken as facts or judgment calls."
          uses := ["G2", "G3", "R4", "R5"] } ] } ]

end Canteen.Blueprints.SuperficialLoss

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
import Canteen.ITA.S110_6.CapitalGainsDeduction
import Canteen.ITA.S251_2.LossRestrictionEvent
import Canteen.ITA.S74.IncomeAttribution
import Canteen.ITA.S82.Dividends
import Canteen.ITA.S55.IntercorporateDividends
import Canteen.ITA.S13.Depreciable
import Canteen.ITA.S84.Redemption
import Canteen.ITA.S89.CapitalDividendAccount
import Canteen.ITA.S86.ShareExchange
import Canteen.ITA.S44.ReplacementProperty
import Canteen.ITA.S47.IdenticalProperties
import Canteen.ITA.S186.Connected
import Canteen.ITA.S84.ReturnOfCapital
import Canteen.ITA.S88.WindingUp
import Canteen.ITA.S87.Amalgamation
import Canteen.ITA.S51.ConvertibleProperty
import Canteen.ITA.S3.IndividualYear
import Canteen.ITA.S39.CanadianSecurities
import Canteen.ITA.S50.BadDebtOrShare
import Canteen.ITA.S43.PartialDisposition
import Canteen.ITA.S74.CorporateAttribution
import Canteen.ITA.S120_4.SplitIncome
import Canteen.ITA.S117.Rates
import Canteen.ITA.S118.PersonalCredits
import Canteen.ITA.S118_1.Donations
import Canteen.ITA.S123.CorporateRates
import Canteen.ITA.S129.RefundableTax
import Canteen.ITA.S15.ShareholderLoans
import Canteen.ITA.S89.GeneralRateIncomePool
import Canteen.ITA.S127_5.MinimumTax
import Canteen.ITA.S20.InterestDeductibility
import Canteen.ITA.S118_2.MedicalExpenses
import Canteen.ITA.S118_3.Disability
import Canteen.ITA.S60_03.PensionSplitting
import Canteen.ITA.S180_2.OasRecovery
import Canteen.ITA.S84.PaidUpCapitalIncrease
import Canteen.ITA.S118_7.EmploymentCredits
import Canteen.ITA.S117_1.YearAmounts
import Canteen.ITA.S118_01.SmallCredits
import Canteen.ITA.S118_5.Tuition
import Canteen.ITA.S56.Support
import Canteen.ITA.S63.ChildCare
import Canteen.ITA.S62.MovingExpenses
import Canteen.ITA.S6.StandbyCharge
import Canteen.ITA.S112.StopLoss
import Canteen.ITA.S84.WindingUpDividend
import Canteen.ITA.S15.ShareholderBenefit
import Canteen.ITA.S44_1.SmallBusinessRollover
import Canteen.ITA.S46.PersonalUse
import Canteen.ITA.S7.StockOptions
import Canteen.ITA.S110_1.CorporateDonations
import Canteen.ITA.S111.NonCapitalLoss
import Canteen.ITA.S125.BusinessLimit
import Canteen.ITA.S256.Associated
import Canteen.ITA.S67_1.MealsEntertainment
import Canteen.ITA.S20.FinancingExpenses
import Canteen.ITA.S18.WorkSpace
import Canteen.ITA.S3.CorporateYear
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
            "defers to it, and it uses that definition's period and exceptions (c) to (g). After a merger, an 88(1) " ++
            "winding-up or a redemption, 40(3.5)(c) and (d) deem the share still owned while the new owner is affiliated."
          lean := [``SuspendedLoss.applies, ``SuspendedLoss.rule, ``SuspendedLoss.releaseDate, ``SuspendedLoss.deemed_owner_no_release,
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
        { id := "R19", kind := .law, title := "The capital gains deduction", citation := "ITA 110.6(1), (1.3), (2), (2.1)"
          statement := "A resident individual who disposes of qualified small business corporation shares (a small business " ++
            "corporation share, held only by related persons for 24 months, in a CCPC with more than half its assets' value " ++
            "in active business assets) may deduct the least of what is left of the lifetime limit, the cumulative gains " ++
            "limit, the annual gains limit, and the 3(b) amount from those shares. Proven: never past the lifetime limit or " ++
            "the annual gains limit, and a cumulative net investment loss never helps."
          lean := [``CapitalGainsDeduction.qualifiedShare, ``CapitalGainsDeduction.deduction,
            ``CapitalGainsDeduction.annualGainsLimit, ``CapitalGainsDeduction.cumulativeGainsLimit,
            ``CapitalGainsDeduction.lifetime_limit, ``CapitalGainsDeduction.deduction_le_annual,
            ``CapitalGainsDeduction.cnil_never_helps, ``CapitalGainsDeduction.qualifiedFarmProperty,
            ``CapitalGainsDeduction.farmFishingDeduction, ``CapitalGainsDeduction.total_le_annual], uses := ["R8"] },
        { id := "R20", kind := .law, title := "Loss restriction events", citation := "ITA 251.2(2)(a); 256(7)(a)"
          statement := "A corporation is subject to a loss restriction event when a person or group acquires control of it " ++
            "(de jure); but not solely because shares are acquired from a related person, by a person related to the " ++
            "corporation, by or from an estate on a death, on a redemption leaving only related persons in control, or by " ++
            "a related group each related to the corporation. The event's date feeds paragraph (f) of the definition."
          lean := [``LossRestrictionEvent.lossRestrictionEvent, ``LossRestrictionEvent.eventDate,
            ``LossRestrictionEvent.related_sale, ``LossRestrictionEvent.no_new_controller, ``LossRestrictionEvent.to_estate],
          uses := ["R4", "Pf"] },
        { id := "R21", kind := .law, title := "Attribution of income to the transferor or lender", citation := "ITA 74.1(1)–(3); 74.5(2), (3)(a)"
          statement := "Income or loss from property transferred or lent to a spouse or common-law partner (in the period of " ++
            "residence and marriage), or to a minor not at arm's length or a niece or nephew (until the year the minor " ++
            "turns 18), is the individual's and not the recipient's; including a share of the income of other property " ++
            "whose debt the property paid down. Not for a transfer at fair market value (74.5(1)), a loan at the " ++
            "prescribed rate with interest paid on time (74.5(2)), or a period of separation (74.5(3)(a))."
          lean := [``IncomeAttribution.applies, ``IncomeAttribution.attributedIncome, ``IncomeAttribution.prescribed_rate_loan,
            ``IncomeAttribution.adult_by_year_end, ``IncomeAttribution.income_split, ``IncomeAttribution.repayment_share_le],
          uses := ["R15"] },
        { id := "R22", kind := .law, title := "Taxable dividends: the gross-up and credit", citation := "ITA 82(1); 121"
          statement := "Taxable dividends from corporations resident in Canada are included in income; an individual adds a " ++
            "gross-up (15% for non-eligible dividends after 2018, 38% for eligible dividends after 2011) and deducts a credit " ++
            "from tax (9/13 and 6/11 of the gross-up). Proven: the credit never exceeds the gross-up."
          lean := [``Dividends.inclusion, ``Dividends.credit, ``Dividends.credit_le_grossUp, ``Dividends.non_eligible_2025] },
        { id := "R23", kind := .law, title := "Intercorporate dividends, and when they are gains", citation := "ITA 112(1); 55(2), (2.1), (3), (5)(f)"
          statement := "A corporation deducts taxable dividends from taxable Canadian corporations (112(1)); but the part of a " ++
            "dividend over safe income, paid with a purpose of reducing a capital gain (or a share's value, or increasing " ++
            "cost), is a capital gain or proceeds of disposition instead (55(2)), unless it is a redemption in a series " ++
            "with no unrelated person (55(3)(a)) or a butterfly. Proven: nothing within safe income is caught, and what is " ++
            "caught moves from the deduction to proceeds or a gain."
          lean := [``IntercorporateDividends.subsection55_2, ``IntercorporateDividends.caught, ``IntercorporateDividends.deduction,
            ``IntercorporateDividends.within_safe_income, ``IntercorporateDividends.related_redemption,
            ``IntercorporateDividends.conserved] },
        { id := "R24", kind := .law, title := "Depreciable property: recapture and terminal losses", citation := "ITA 13(1), (21); 20(16)"
          statement := "A class's undepreciated capital cost is its capital cost (plus earlier recapture) less the capital cost " ++
            "allowance claimed and, for each disposition, the lesser of net proceeds and capital cost. If negative at year " ++
            "end it is recaptured into income; if positive with no property left, it is a terminal loss. Proven: recapture " ++
            "and UCC are never both positive, and recapture never exceeds the allowance claimed."
          lean := [``Depreciable.ClassFacts.ucc, ``Depreciable.ClassFacts.recapture, ``Depreciable.ClassFacts.terminalLoss,
            ``Depreciable.recapture_or_ucc, ``Depreciable.recapture_le_depreciation, ``Depreciable.sold_above_cost],
          uses := ["R8"] },
        { id := "R25", kind := .law, title := "Redemptions of shares", citation := "ITA 84(3); 54 \"proceeds of disposition\" (j)"
          statement := "A resident corporation that redeems its shares is deemed to pay a dividend of the amount paid over their " ++
            "paid-up capital, shared among the holders by number of shares; the dividend is not proceeds, except to the extent " ++
            "55(2)(b) makes it so. Proven: a sole holder's dividend and proceeds add up to the amount paid, the proceeds " ++
            "being the paid-up capital."
          lean := [``Redemption.dividend, ``Redemption.proceeds, ``Redemption.sole_holder, ``Redemption.no_dividend_within_puc,
            ``Redemption.corporateDisposition], uses := ["R8", "R22", "R23"] },
        { id := "R26", kind := .law, title := "The capital dividend account", citation := "ITA 83(2); 89(1) \"capital dividend account\""
          statement := "A private corporation's untaxed half of its capital gains (less the unallowed half of its losses), " ++
            "capital dividends received and life insurance proceeds, less capital dividends paid, can be paid out as capital " ++
            "dividends, which no shareholder includes in income. Proven: a capital dividend never exceeds the account, and " ++
            "one ordinary gain puts exactly its untaxed half in it."
          lean := [``CapitalDividendAccount.account, ``CapitalDividendAccount.capitalDividend,
            ``CapitalDividendAccount.capitalDividend_le_account, ``CapitalDividendAccount.untaxed_half], uses := ["R8"] },
        { id := "R27", kind := .law, title := "Share exchanges in a reorganization of capital", citation := "ITA 86(1)–(3)"
          statement := "All of a taxpayer's shares of a class exchanged in a reorganization of capital for other shares (and " ++
            "boot) are disposed of for the cost of what is received: the boot at its value, the new shares at the old cost less " ++
            "the boot. If the old shares are worth more than what is received and the excess benefits a related person, the " ++
            "proceeds include it and no loss is allowed (86(2)). Proven: an estate freeze has no gain."
          lean := [``ShareExchange.applies, ``ShareExchange.proceeds, ``ShareExchange.newCost, ``ShareExchange.freeze_no_gain,
            ``ShareExchange.benefit_taxed, ``ShareExchange.not_with_85], uses := ["R8", "R17"] },
        { id := "R28", kind := .law, title := "Replacement property", citation := "ITA 44(1)"
          statement := "Where property (not a share) is expropriated, destroyed or stolen, or a former business property is " ++
            "sold, and a replacement is acquired within two (or one) taxation years after, the taxpayer may elect to recognize " ++
            "only the proceeds not reinvested; the rest of the gain reduces the replacement's cost. Proven: the gain recognized " ++
            "and deferred add up to the gain otherwise, and full reinvestment defers all of it."
          lean := [``ReplacementProperty.applies, ``ReplacementProperty.gain, ``ReplacementProperty.replacementCostAfter,
            ``ReplacementProperty.gain_add_deferred, ``ReplacementProperty.fully_reinvested], uses := ["R8"] },
        { id := "R29", kind := .law, title := "Identical properties: the average cost", citation := "ITA 47(1)"
          statement := "Identical properties (such as shares of one class) form a pool, each at the average cost; a sale takes " ++
            "its share of the pool's total cost, and additions to cost (such as a 53(1)(f) superficial loss) are averaged in. " ++
            "Proven: the costs of everything sold plus what is left equal everything that went in, to the cent."
          lean := [``IdenticalProperties.run, ``IdenticalProperties.Pool.average, ``IdenticalProperties.conserved,
            ``IdenticalProperties.sell_all], uses := ["R8"] },
        { id := "R30", kind := .law, title := "Connected corporations", citation := "ITA 186(2), (4), (7)"
          statement := "A payer corporation is connected with a particular corporation if controlled by it (de jure, or by " ++
            "186(2): more than half the voting shares held by it and persons not at arm's length with it), or if it owns more " ++
            "than 10% of both the voting shares and the value of the payer's shares. Used by 84.1 and the qualified small " ++
            "business corporation share definition."
          lean := [``Connected.connected, ``Connected.controlled186_2, ``Connected.wholly_owned, ``Connected.not_of_ten_percent],
          uses := ["R4"] },
        { id := "R31", kind := .law, title := "Returns of capital, and negative adjusted cost base", citation := "ITA 84(4), (4.1); 53(2)(a)(ii); 40(3); 53(1)(a)"
          statement := "A reduction of paid-up capital paid out by a private corporation is a dividend only to the extent it " ++
            "exceeds the reduction; the rest reduces the shareholder's adjusted cost base, and any excess below nil is a gain " ++
            "(40(3)), added back to bring it to nil. A public corporation's is all dividend unless it distributes recent " ++
            "extraordinary proceeds. Proven: the adjusted cost base never goes below nil."
          lean := [``ReturnOfCapital.dividend, ``ReturnOfCapital.returnOfCapital, ``ReturnOfCapital.deemedGain,
            ``ReturnOfCapital.acb_after, ``ReturnOfCapital.no_dividend_at_puc], uses := ["R8"] },
        { id := "R32", kind := .law, title := "Winding up a subsidiary, and the bump", citation := "ITA 88(1)(a)–(d)"
          statement := "When a 90%-owned taxable Canadian subsidiary is wound up into its parent, its property passes at cost " ++
            "amount; the parent's shares are disposed of for at least their cost; and the excess of that cost over the " ++
            "subsidiary's net tax cost (and dividends received) may be added to the cost of eligible capital property, each up " ++
            "to its value when control was acquired. Proven: no gain to the subsidiary, no loss on the shares, and the bump " ++
            "never exceeds the room."
          lean := [``WindingUp.applies, ``WindingUp.shareProceeds, ``WindingUp.bumpOf, ``WindingUp.bump_le_room,
            ``WindingUp.no_share_loss, ``WindingUp.no_subsidiary_gain], uses := ["R8"] },
        { id := "R33", kind := .law, title := "Amalgamations", citation := "ITA 87(1), (2)(a), (e), (4)"
          statement := "In an amalgamation of taxable Canadian corporations, the new corporation takes the predecessors' " ++
            "capital property at their adjusted cost base (87(2)(e)); a shareholder receiving only new shares disposes of the " ++
            "old shares at their cost and takes the new shares at that cost, unless a benefit is conferred on a related " ++
            "person (87(4)). Proven: the shareholder rolls over with no gain or loss, and a gift portion never makes a loss."
          lean := [``Amalgamation87.amalgamation, ``Amalgamation87.newCorporationCost, ``Amalgamation87.Shareholder.proceeds,
            ``Amalgamation87.shareholder_rollover, ``Amalgamation87.no_loss_on_gift], uses := ["R8", "R17"] },
        { id := "R34", kind := .law, title := "Convertible property", citation := "ITA 51(1), (2), (4)"
          statement := "Shares or convertible debt of a corporation exchanged for its shares, with nothing else received, are " ++
            "not disposed of; the new shares take over the cost. If a benefit is conferred on a related person, the gift " ++
            "portion is taxed and any loss is nil. Not where 85 or 86 applies. Proven: a plain conversion is no disposition."
          lean := [``ConvertibleProperty.disposition, ``ConvertibleProperty.costTotal, ``ConvertibleProperty.no_disposition,
            ``ConvertibleProperty.not_with_rollover], uses := ["R8", "R17"] },
        { id := "R36", kind := .law, title := "The election for Canadian securities", citation := "ITA 39(4)–(6)"
          statement := "A taxpayer who elects has every Canadian security (shares of resident corporations, mutual fund trust " ++
            "units, and debt of residents) treated as capital property in the election year and after, unless a trader or " ++
            "dealer, financial institution, money-lender or non-resident. The election turns a capital-account judgment call " ++
            "into a fact (proven)."
          lean := [``CanadianSecurities.deemedCapital, ``CanadianSecurities.withElection,
            ``CanadianSecurities.settles_capital_account, ``CanadianSecurities.not_for_non_resident], uses := ["R8"] },
        { id := "R37", kind := .law, title := "Bad debts and worthless shares", citation := "ITA 50(1)"
          statement := "A debt established to have become bad, or a share of a corporation that became bankrupt, was wound up " ++
            "insolvent, or is insolvent and dormant with its dissolution expected, is on election deemed disposed of at year " ++
            "end for nil and reacquired at nil: the whole cost is a capital loss (or business investment loss), never a " ++
            "superficial loss (paragraph (c))."
          lean := [``BadDebtOrShare.applies, ``BadDebtOrShare.disposition, ``BadDebtOrShare.loss_is_cost,
            ``BadDebtOrShare.not_superficial], uses := ["R8", "D"] },
        { id := "R38", kind := .law, title := "Disposing of part of a property", citation := "ITA 43(1)"
          statement := "The cost of a part disposed of is the portion of the whole's adjusted cost base reasonably attributable " ++
            "to it (usually by value, which can be a judgment call); the rest stays with the part kept. Proven: the two add up."
          lean := [``PartialDisposition.partCost, ``PartialDisposition.costs_add_up], uses := ["R8"] },
        { id := "R39", kind := .law, title := "Corporate attribution", citation := "ITA 74.4(2); 74.5(5)"
          statement := "An individual who transfers or lends property to a corporation, with a main purpose of reducing their " ++
            "income and benefiting a spouse or minor child, niece or nephew who is a specified shareholder, is deemed to " ++
            "receive interest at the prescribed rate on the amount outstanding, less interest received and dividends included " ++
            "on the shares taken back; not while the corporation is a small business corporation. Proven: dividends on the " ++
            "freeze shares at least equal to the prescribed interest leave nothing deemed."
          lean := [``CorporateAttribution.applies, ``CorporateAttribution.deemedInterest, ``CorporateAttribution.dividends_cover,
            ``CorporateAttribution.not_for_small_business], uses := ["R21", "R22"] },
        { id := "R40", kind := .law, title := "Tax on split income", citation := "ITA 120.4(1)–(3); 20(1)(ww)"
          statement := "A specified individual's private-company dividends and related-business income, other than excluded " ++
            "amounts (by age: inherited property, exempt gains, no related business or an excluded business, a reasonable " ++
            "return, excluded shares), are split income: deducted from income and taxed at the highest rate, less dividend " ++
            "credits. Proven: excluded shares exclude an adult's dividends; a minor has no age-based exclusion."
          lean := [``SplitIncome.splitIncome, ``SplitIncome.excluded, ``SplitIncome.tax, ``SplitIncome.minimumTax,
            ``SplitIncome.excluded_shares, ``SplitIncome.minor_no_reasonable_return], uses := ["R22"] },
        { id := "R41", kind := .law, title := "The federal rates", citation := "ITA 117(2)"
          statement := "An individual's tax is 14% to $57,375, 20.5% to $114,750, 26% to $177,882, 29% to $253,414, and 33% " ++
            "above (2025 amounts, indexed after). Proven: more income never means less tax."
          lean := [``Rates.tax, ``Rates.tax_mono] },
        { id := "R42", kind := .law, title := "The basic personal, spouse, eligible dependant and caregiver amounts",
          citation := "ITA 118(1)(a), (b), (b.1), (c), (d), (e), (1.1)"
          statement := "An individual deducts 14% of the basic personal amount ($12,298 plus an enhancement up to $15,000, " ++
            "phased out between the 117(2)(d) and (e) thresholds), plus, if supporting a spouse, the basic personal amount " ++
            "less the spouse's income, or else, for a single individual supporting a related, wholly dependent person at " ++
            "home, the same less that person's income; plus the infirmity amount for each infirm child, and the caregiver " ++
            "amount for each infirm adult dependant (less income over a threshold, with a top-up where the spouse or " ++
            "dependant is one). Proven: the basic personal amount is always between the base and the enhanced amount, " ++
            "the dependant amount never more than twice it plus the infirmity amount, and the caregiver amount never more " ++
            "than its maximum."
          lean := [``PersonalCredits.basicPersonalAmount, ``PersonalCredits.eligibleDependant, ``PersonalCredits.credit,
            ``PersonalCredits.bpa_between, ``PersonalCredits.full_below, ``PersonalCredits.dependant_le,
            ``PersonalCredits.caregiverAmounts, ``PersonalCredits.caregiver_le], uses := ["R41"] },
        { id := "R43", kind := .law, title := "The charitable donation credit", citation := "ITA 118.1(1), (3)"
          statement := "Gifts to qualified donees (of the year and five before) count up to 75% of income plus 25% of the gains " ++
            "on gifted property (all of income in the year of death); the credit is 14% of the first $200, 33% of gifts matched " ++
            "by income in the top bracket, and 29% of the rest. Proven: total gifts never exceed income."
          lean := [``Donations.totalGifts, ``Donations.credit, ``Donations.totalGifts_le_income, ``Donations.death_year],
          uses := ["R41"] },
        { id := "R44", kind := .law, title := "Corporate rates", citation := "ITA 123(1); 124(1); 123.4(2); 125(1)"
          statement := "A corporation pays 38%, less the 10% provincial abatement, less 13% of its full rate taxable income, less " ++
            "(for a CCPC) 19% of the least of its active business income, taxable income and business limit. Proven: a CCPC's " ++
            "active business income within the limit is taxed at 9%, and a corporation that is not a CCPC pays 15%."
          lean := [``CorporateRates.tax, ``CorporateRates.smallBusinessAmount, ``CorporateRates.fullRateTaxableIncome,
            ``CorporateRates.small_business_rate, ``CorporateRates.general_rate] },
        { id := "R45", kind := .law, title := "Refundable taxes and the dividend refund", citation := "ITA 123.3; 129(1), (4); 186(1)(a) to (d)"
          statement := "A CCPC pays an extra 10⅔% on investment income and Part IV tax of 38⅓% on portfolio dividends; 30⅔% of " ++
            "the investment income and the Part IV tax go into two refundable accounts, refunded at 38⅓% of dividends paid " ++
            "(eligible dividends only from the eligible account); non-capital losses claimed take 38⅓% of themselves off " ++
            "Part IV tax. Proven: the refund never exceeds the accounts, a portfolio dividend paid straight out gets all " ++
            "its Part IV tax back, and losses claimed never raise Part IV tax."
          lean := [``RefundableTax.additionalTax, ``RefundableTax.partIV, ``RefundableTax.lossReduction, ``RefundableTax.nonEligibleAccount,
            ``RefundableTax.dividendRefund, ``RefundableTax.refund_le_accounts, ``RefundableTax.flow_through, ``RefundableTax.partIV_le_gross], uses := ["R44"] },
        { id := "R46", kind := .law, title := "Shareholder loans", citation := "ITA 15(2), (2.6); 80.4(2), (3); 20(1)(j)"
          statement := "A loan from a corporation to a shareholder (or a person connected with one) is income, unless repaid " ++
            "within a year after the corporation's year end, not as part of a series; if it is not income, interest at the " ++
            "prescribed rate (less interest paid) is a benefit; a loan taxed under 15(2) is deducted when repaid. Proven: " ++
            "never both, and a repayment restores what was included."
          lean := [``ShareholderLoans.included, ``ShareholderLoans.inclusion, ``ShareholderLoans.deemedInterest,
            ``ShareholderLoans.not_both, ``ShareholderLoans.repaid_in_time, ``ShareholderLoans.repayment_restores] },
        { id := "R47", kind := .law, title := "The general rate income pool", citation := "ITA 89(1); 185.1(1), (2)"
          statement := "A CCPC's pool grows by 72% of its income taxed at the general rate (taxable income less the small " ++
            "business amount and investment income) and by eligible dividends received, and shrinks by last year's eligible " ++
            "dividends; eligible dividends beyond it are excessive and bear Part III.1 tax of 20% (30%, and the whole dividend, " ++
            "where the pool was artificially increased), unless the excess is elected to be a separate non-eligible dividend. " ++
            "Proven: dividends within the pool are never excessive, and electing the whole excess leaves no Part III.1 tax."
          lean := [``GeneralRateIncomePool.adjustedTaxableIncome, ``GeneralRateIncomePool.pool, ``GeneralRateIncomePool.excessive,
            ``GeneralRateIncomePool.partIII1, ``GeneralRateIncomePool.partIII1After, ``GeneralRateIncomePool.within_pool,
            ``GeneralRateIncomePool.excessive_le, ``GeneralRateIncomePool.full_election],
          uses := ["R44"] },
        { id := "R49", kind := .law, title := "Interest on borrowed money", citation := "ITA 20(1)(c)(i); 20(3)"
          statement := "Interest under a legal obligation on money borrowed and used for the purpose of earning income from a " ++
            "business or property is deductible, apportioned to the part traced to that use and capped at a reasonable " ++
            "amount; not for property with exempt income or life insurance; money borrowed to repay a borrowing takes its " ++
            "use. Proven: never more than the interest, nil for a personal use, and a refinancing inherits the original use."
          lean := [``InterestDeductibility.deductible, ``InterestDeductibility.deduction, ``InterestDeductibility.deduction_le,
            ``InterestDeductibility.personal_nil, ``InterestDeductibility.refinancing_inherits] },
        { id := "R50", kind := .law, title := "The medical expense credit", citation := "ITA 118.2(1)"
          statement := "14% of medical expenses for the individual, spouse and minor children over the lesser of $2,834 (2025) " ++
            "and 3% of income, plus each other dependant's over the lesser of $2,834 and 3% of the dependant's income; only " ++
            "receipted expenses, paid in a 12-month period ending in the year, not claimed elsewhere. Proven: nothing below " ++
            "the floor."
          lean := [``MedicalExpenses.amount, ``MedicalExpenses.credit, ``MedicalExpenses.reduction_le, ``MedicalExpenses.below_floor] },
        { id := "R51", kind := .law, title := "The disability tax credit", citation := "ITA 118.3(1), (2)"
          statement := "14% of $10,138 (2025), plus for a minor $5,914 less care expenses over $3,464, for a severe and " ++
            "prolonged impairment markedly restricting a basic activity of daily living, certified and filed, where no " ++
            "attendant or nursing home care for the individual is claimed as a medical expense; what the person cannot use " ++
            "transfers to a supporting relative. Proven: the supplement never exceeds its amount, claiming attendant care " ++
            "rules the credit out, and the person and supporter never use more than the credit between them."
          lean := [``Disability.eligible, ``Disability.amount, ``Disability.credit, ``Disability.supplement_le,
            ``Disability.not_with_attendant_care, ``Disability.transfer, ``Disability.transfer_le] },
        { id := "R52", kind := .law, title := "Pension income, the age and pension credits, and pension splitting",
          citation := "ITA 118(2), (3), (7), (8); 60.03; 60(c); 56(1)(a.2)"
          statement := "Eligible pension income (pension income at 65, qualified pension income before; never OAS or CPP); the " ++
            "age credit, 14% of $9,028 less 15% of income over $45,522; the pension credit, 14% of up to $2,000; and the " ++
            "joint election to move up to half of eligible pension income to a spouse. Proven: government benefits are " ++
            "never eligible, the split is at most half, and the pension credit at most $280."
          lean := [``PensionSplitting.eligiblePensionIncome, ``PensionSplitting.splitLimit, ``PensionSplitting.ageCredit,
            ``PensionSplitting.pensionCredit, ``PensionSplitting.government_not_eligible, ``PensionSplitting.split_le_half,
            ``PensionSplitting.pension_credit_le] },
        { id := "R53", kind := .law, title := "The OAS recovery tax", citation := "ITA 180.2(1), (2); 60(w)"
          statement := "Part I.2 tax of 15% of adjusted income (income before the 60(w) deduction) over $93,454 (2025), up to " ++
            "the Old Age Security received, and deducted in computing income. Proven: never more than the benefits, and " ++
            "nothing at or below the threshold."
          lean := [``OasRecovery.tax, ``OasRecovery.tax_le_oas, ``OasRecovery.below_threshold] },
        { id := "R54", kind := .law, title := "An increase in paid-up capital", citation := "ITA 84(1); 53(1)(b)"
          statement := "A corporation resident in Canada that increases the paid-up capital of a class, other than by a stock " ++
            "dividend or for net assets, a reduction of other classes or qualifying surplus, is deemed to pay a dividend of " ++
            "the rest, shared by the holders, who add it to their cost. Proven: never more than the increase, nil when paid " ++
            "for in full, and a sole holder's cost rises by the whole dividend."
          lean := [``PaidUpCapitalIncrease.dividendPaid, ``PaidUpCapitalIncrease.dividend, ``PaidUpCapitalIncrease.costAddition,
            ``PaidUpCapitalIncrease.dividendPaid_le, ``PaidUpCapitalIncrease.paid_for, ``PaidUpCapitalIncrease.sole_holder] },
        { id := "R55", kind := .law, title := "The employment, CPP and EI credits", citation := "ITA 118(10); 118.7; 60(e.1)"
          statement := "14% of the lesser of $1,471 (2025) and employment income; 14% of EI premiums and base CPP " ++
            "contributions, each up to its maximum; the enhanced CPP contributions deducted from income. Proven: the " ++
            "employment credit is at most 14% of the indexed amount, and nil without employment income."
          lean := [``EmploymentCredits.employmentCredit, ``EmploymentCredits.contributionCredit, ``EmploymentCredits.enhancedDeduction,
            ``EmploymentCredits.employmentCredit_le, ``EmploymentCredits.no_employment] },
        { id := "R56", kind := .law, title := "Indexing the dollar amounts", citation := "ITA 117.1(1) to (4)"
          statement := "Each specified amount is last year's (unrounded) amount increased by the change in the 12-month " ++
            "average CPI to September 30, rounded to a thousandth, and rounded to the dollar for use. The factors are " ++
            "computed from Statistics Canada's monthly CPI. Proven: every factor from 1999 to 2027 is the one the formula " ++
            "gives from the data; the Act's figures reproduce the 2025 amounts the CRA published; and each year's table row " ++
            "is the computation."
          lean := [``Indexation.computedFactor, ``Indexation.factorTable_correct, ``Indexation.Specified.forYear,
            ``Indexation.published_2025, ``YearAmounts.computed, ``YearAmounts.table_correct] },
        { id := "R57", kind := .law, title := "The adoption, home accessibility, home buyers' and volunteer credits",
          citation := "ITA 118.01(2), (3); 118.041(3); 118.05(3), (4); 118.06(2); 118.07(2)"
          statement := "14% of: adoption expenses less assistance, up to the indexed limit ($19,580 for 2025); home " ++
            "accessibility expenditures up to $20,000; $10,000 in the year a first home is bought; and $6,000 for 200 hours " ++
            "of volunteer firefighting or search and rescue, once. Shared credits take the agreed share. Proven: the " ++
            "adoption amount never exceeds the limit, and the volunteer amount never exceeds $6,000."
          lean := [``SmallCredits.adoptionAmount, ``SmallCredits.accessibilityAmount, ``SmallCredits.homeBuyerAmount,
            ``SmallCredits.volunteerAmount, ``SmallCredits.adoption_le, ``SmallCredits.volunteer_le] },
        { id := "R58", kind := .law, title := "The tuition credit, its carryforward and its transfer",
          citation := "ITA 118.5(1)(a); 118.61; 118.81; 118.9"
          statement := "14% of qualifying tuition fees; unused credits carried forward and used first in later years; up " ++
            "to $700 (14% of $5,000) of the year's credit not needed against the student's own tax transferred, as " ++
            "designated, to a parent or grandparent. Proven: the transfer never exceeds $700, and what is carried in plus " ++
            "the year's credit always equals what is used, transferred and carried out."
          lean := [``Tuition.credit, ``Tuition.carryforwardUsed, ``Tuition.transferred, ``Tuition.unused,
            ``Tuition.transferred_le, ``Tuition.conservation] },
        { id := "R59", kind := .law, title := "Support payments", citation := "ITA 56(1)(b); 56.1(4); 60(b)"
          statement := "A periodic allowance for maintenance, at the recipient's discretion, to a spouse living apart under " ++
            "an order or written agreement (or by a legal parent under a provincial order) is deducted by the payer and " ++
            "included by the recipient, less child support payable since the commencement day and amounts deducted before. " ++
            "Proven: nothing until child support payable is paid, and never more than what was paid."
          lean := [``Support.supportAmount, ``Support.amount, ``Support.child_support_first, ``Support.amount_le] },
        { id := "R60", kind := .law, title := "Child care expenses", citation := "ITA 63(1), (2), (3)"
          statement := "Child care expenses paid for eligible children are deducted, up to $8,000 for each child under 7, " ++
            "$5,000 for older children and $11,000 for a child eligible for the disability credit, and up to two-thirds of " ++
            "earned income; the higher-income supporting person deducts only 1/40 of those amounts a week while the other is " ++
            "a student, incapacitated, in prison or separated. Proven: never more than paid or two-thirds of earned income, " ++
            "and nothing for the higher-income spouse while the other is at home."
          lean := [``ChildCare.Child.annual, ``ChildCare.deduction, ``ChildCare.deduction_le, ``ChildCare.higher_income_nil] },
        { id := "R61", kind := .law, title := "Moving expenses", citation := "ITA 62(1); 248(1) \"eligible relocation\""
          statement := "Moving expenses for a relocation to work (or study full time) in Canada that brings the taxpayer at " ++
            "least 40 km closer to the new work location are deducted, up to the year's income from the new location (or " ++
            "scholarships), the rest in later years, if reimbursements are included in income. Proven: never more than that " ++
            "income or the expenses, and what is deducted plus what is carried is what was paid."
          lean := [``MovingExpenses.eligible, ``MovingExpenses.deduction, ``MovingExpenses.unused, ``MovingExpenses.deduction_le,
            ``MovingExpenses.deducted_plus_unused] },
        { id := "R62", kind := .law, title := "The automobile standby charge", citation := "ITA 6(1)(e); 6(2)"
          statement := "An employee includes 2% a month of the cost of an employer's car (or 2/3 of the lease cost, less " ++
            "insurance), reduced in proportion to personal kilometres under 1,667 a month where the car must be used and is " ++
            "used primarily for work, less what the employee pays for its use. Proven: an owned car available all year " ++
            "gives 24% of its cost."
          lean := [``StandbyCharge.months, ``StandbyCharge.charge, ``StandbyCharge.benefit, ``StandbyCharge.full_year] },
        { id := "R63", kind := .law, title := "The stop-loss on shares", citation := "ITA 112(3), (3.01), (6.1)"
          statement := "A loss on a share is reduced: for an individual, by the capital dividends received on it, but only " ++
            "down to the loss less the taxable dividends; for a corporation, by the taxable dividends it deducted under " ++
            "section 112, the capital dividends and the life insurance capital dividends; except qualified dividends on a " ++
            "holding of 5% or less owned 365 days. Proven: never more than the loss, and an individual with no capital " ++
            "dividends keeps it all."
          lean := [``StopLoss.qualified, ``StopLoss.reduction, ``StopLoss.apply, ``StopLoss.reduction_le,
            ``StopLoss.individual_taxable_only] },
        { id := "R64", kind := .law, title := "A distribution on winding-up", citation := "ITA 84(2); 54 \"proceeds of disposition\" (j)"
          statement := "Funds or property a Canadian corporation distributes to shareholders on the winding-up, discontinuance " ++
            "or reorganization of its business are a dividend to the extent they exceed the paid-up capital reduction; the " ++
            "holders' proceeds exclude it. Proven: never more than what was distributed, and a sole shareholder's proceeds " ++
            "are the paid-up capital returned."
          lean := [``WindingUpDividend.applies, ``WindingUpDividend.dividendPaid, ``WindingUpDividend.proceeds,
            ``WindingUpDividend.dividendPaid_le, ``WindingUpDividend.sole_proceeds] },
        { id := "R65", kind := .law, title := "Shareholder benefits", citation := "ITA 15(1)"
          statement := "The value of a benefit a corporation confers on a shareholder as shareholder, less what was paid for " ++
            "it and any part section 84 deems a dividend, is income, unless conferred by a return of capital, a redemption, " ++
            "a winding-up, a dividend, a rights offering to all common shareholders and the like. Proven: nothing when paid " ++
            "for in full, and a dividend is never also a 15(1) benefit."
          lean := [``ShareholderBenefit.applies, ``ShareholderBenefit.inclusion, ``ShareholderBenefit.paid_in_full,
            ``ShareholderBenefit.not_dividend] },
        { id := "R66", kind := .law, title := "The small business investment rollover", citation := "ITA 44.1(1), (2)"
          statement := "An individual's gain on eligible small business corporation shares, of an active business corporation " ++
            "throughout and held 185 days, is deferred in the proportion of the proceeds reinvested in replacement shares " ++
            "in the year or the next, whose cost is reduced by the deferral. Proven: never more than the gain, and all of it " ++
            "when all the proceeds are reinvested."
          lean := [``SmallBusinessRollover.qualifying, ``SmallBusinessRollover.permittedDeferral, ``SmallBusinessRollover.acbReduction,
            ``SmallBusinessRollover.deferral_le, ``SmallBusinessRollover.full_reinvestment] },
        { id := "R67", kind := .law, title := "Personal-use property: the $1,000 rule", citation := "ITA 46(1), (2), (3), (5)"
          statement := "On a disposition of personal-use property, its cost and the proceeds are each at least $1,000 (a part " ++
            "takes its share of the $1,000), and properties ordinarily sold as a set, sold piecemeal to one buyer or group, " ++
            "are one property; not for excluded property given to a charity. Proven: no gain or loss below the floor, and " ++
            "the floor never lowers the cost or the proceeds."
          lean := [``PersonalUse.apply, ``PersonalUse.applyPart, ``PersonalUse.set, ``PersonalUse.applyPiece,
            ``PersonalUse.below_floor, ``PersonalUse.never_lower] },
        { id := "R68", kind := .law, title := "Employee stock options", citation := "ITA 7(1)(a), (1.1); 110(1)(d), (d.1); 53(1)(j)"
          statement := "Securities acquired under an employee option are a benefit of their value less what was paid, in the " ++
            "year acquired (or, for an arm's length employee of a CCPC, the year sold); half is deducted if the share is a " ++
            "prescribed, qualified share priced at no less than its value at grant, or (for a CCPC share) kept two years; " ++
            "the benefit is added to the share's cost. Proven: never more than half deducted, and the share costs its value."
          lean := [``StockOptions.benefit, ``StockOptions.inclusionYear, ``StockOptions.deduction, ``StockOptions.adjustedCostBase,
            ``StockOptions.deduction_le, ``StockOptions.cost_is_value] },
        { id := "R69", kind := .law, title := "A corporation's charitable gifts", citation := "ITA 110.1(1)(a)"
          statement := "A corporation deducts its gifts of the year and the five before, up to the lesser of its income and " ++
            "75% of it plus 25% of the gains on gifts (and recapture on gifted property); the rest carries forward. Proven: " ++
            "never more than income, no more than 75% of it without gains on gifts, and deducted plus carried is what was available."
          lean := [``CorporateDonations.limit, ``CorporateDonations.deduction, ``CorporateDonations.carriedForward,
            ``CorporateDonations.deduction_le_income, ``CorporateDonations.three_quarters, ``CorporateDonations.deducted_plus_carried] },
        { id := "R71", kind := .law, title := "Non-capital losses", citation := "ITA 111(1)(a), (3), (8)"
          statement := "A year's non-capital loss is its losses from business and property, the 112(1) and other listed " ++
            "deductions and (until the eleventh year after) its allowable business investment loss, over its 3(c) amount. " ++
            "It is deducted in the 20 following years or the 3 before, oldest losses first. Proven: a claim takes the " ++
            "lesser of itself and the losses available, a later loss is used only once an earlier one is used up, and a " ++
            "loss of the same year or more than 20 years old cannot be deducted."
          lean := [``NonCapitalLoss.amount, ``NonCapitalLoss.amountAt, ``NonCapitalLoss.queue, ``NonCapitalLoss.deduction,
            ``NonCapitalLoss.remaining, ``NonCapitalLoss.deduction_eq, ``NonCapitalLoss.deduction_le_claim,
            ``NonCapitalLoss.deduction_le_available, ``NonCapitalLoss.earlier_first, ``NonCapitalLoss.not_same_year,
            ``NonCapitalLoss.expired, ``NonCapitalLoss.no_losses] },
        { id := "R72", kind := .law, title := "The business limit", citation := "ITA 125(2), (3), (5)(b), (5.1)"
          statement := "The business limit is $500,000, shared by agreement among associated CCPCs (nil without one, or " ++
            "if the shares exceed 100%, or for a third corporation electing under 256(2)), prorated for a year under 51 weeks, and reduced by the greater of the grind for " ++
            "taxable capital over $10 million and 5 times the group's adjusted aggregate investment income over $50,000. " ++
            "Proven: never more than the shared limit, nil from $150,000 of investment income or $50 million of capital, and " ++
            "no reduction below both thresholds."
          lean := [``BusinessLimit.shared, ``BusinessLimit.prorated, ``BusinessLimit.capitalReduction, ``BusinessLimit.investmentReduction,
            ``BusinessLimit.limit, ``BusinessLimit.shared_le, ``BusinessLimit.limit_le, ``BusinessLimit.investment_grind_full,
            ``BusinessLimit.capital_grind_full, ``BusinessLimit.no_grind] },
        { id := "R73", kind := .law, title := "Associated corporations", citation := "ITA 256(1), (1.1), (1.2), (1.3), (1.4), (1.5), (2), (2.1), (5.1)"
          statement := "Two corporations are associated if one controls the other, the same person or group controls both " ++
            "(a group including any group of shareholders of both whose members control them), or they are controlled by " ++
            "related persons or related groups one of whom owns at least 25% of a class (not a specified class) of the " ++
            "other or of each, counting shares held through corporations, partnerships and trusts, rights to acquire " ++
            "shares (and to have others' redeemed), and a minor child's shares; or if kept separate mainly to reduce tax. De facto " ++
            "control counts. Two corporations each associated with a third are associated (for " ++
            "section 125, only through a CCPC that has not elected; an electing third has no business limit). Proven: a corporation that controls another is associated with it, " ++
            "two corporations with the same controller are associated, and uncontrolled corporations are not (but for 256(2.1))."
          lean := [``Associated.paraA, ``Associated.paraB, ``Associated.paraC, ``Associated.paraD, ``Associated.paraE,
            ``Associated.associated, ``Associated.associatedWithAny, ``Associated.controls_other, ``Associated.same_controller,
            ``Associated.uncontrolled, ``Associated.shareOf, ``Associated.classBp, ``Associated.ownedBp, ``Associated.minorsOf, ``Associated.Group.associatedWith, ``Associated.Group.electedNil,
            ``Associated.Group.direct_associated],
          uses := ["R4"] },
        { id := "R74", kind := .law, title := "Meals and entertainment", citation := "ITA 67.1"
          statement := "An amount for food, beverages or entertainment is deemed to be 50% of the lesser of what was paid " ++
            "and a reasonable amount (a long-haul truck driver's road meals, 80%), except where the business sells them, " ++
            "for a charity fundraiser, when billed to a client, as a taxable benefit, at a remote site or camp, or for up " ++
            "to six staff events a year; a conference fee that does not identify its food part includes $50 of food a day. " ++
            "Proven: never more than was paid, half without an exception, and a seventh staff event loses the exception."
          lean := [``MealsEntertainment.specifiedPercentage, ``MealsEntertainment.Expense.deemed, ``MealsEntertainment.Conference.deemed,
            ``MealsEntertainment.deductible, ``MealsEntertainment.Expense.deemed_le, ``MealsEntertainment.Expense.half,
            ``MealsEntertainment.Expense.seventh_event] },
        { id := "R75", kind := .law, title := "Financing expenses", citation := "ITA 20(1)(e), (e.1)"
          statement := "The costs of issuing shares or of borrowing for a business or property are deducted at 20% a year " ++
            "(prorated for a short year), up to what is left; when the debt is repaid at arm's length, the rest. Annual " ++
            "standby and similar fees are deducted in their year. Principal, interest and profit-based amounts are " ++
            "excluded. Proven: never more than what is left, and a fifth in a full year."
          lean := [``FinancingExpenses.Expense.deduction, ``FinancingExpenses.Expense.schedule, ``FinancingExpenses.Fee.deduction,
            ``FinancingExpenses.deduction, ``FinancingExpenses.Expense.deduction_le_remaining, ``FinancingExpenses.Expense.full_year] },
        { id := "R76", kind := .law, title := "Work space in the home", citation := "ITA 18(12); 8(13)"
          statement := "A home work space is deductible only if it is the principal place of business (or where an employee " ++
            "principally works), or used exclusively and regularly for meeting clients; then at most the income from the " ++
            "business or employment, the rest carried forward. Proven: it never creates a loss, nothing is lost while the " ++
            "space qualifies, and an unqualified space gives nothing."
          lean := [``WorkSpace.eligible, ``WorkSpace.deduction, ``WorkSpace.carriedForward, ``WorkSpace.deduction_le_income,
            ``WorkSpace.nothing_lost, ``WorkSpace.not_eligible] },
        { id := "R70", kind := .law, title := "A corporation's year, to taxable income and tax", citation := "ITA 2(2); 3; 110.1; 111(1), (8); 112(1); 125(7); 129(4)"
          statement := "A corporation's income from active business, personal services business, property and dividends " ++
            "received, with its net taxable capital gains (a 55(2) dividend as a gain); taxable income after gifts, the " ++
            "112(1) deduction and losses (other years' non-capital losses oldest first); the year's own non-capital loss; " ++
            "aggregate investment income, leaving out the deducted dividends, and adjusted aggregate investment income for " ++
            "the business limit; then Part I, Part IV (less losses claimed) and Part III.1 tax, the dividend refund, the " ++
            "pool and the capital dividend account. Proven: taxable income never exceeds income; 112(1) never deducts more " ++
            "than income includes; a deductible dividend 55(2) does not reach is not investment income; a year with a " ++
            "non-capital loss has no taxable income; and a loss claimed against Part IV tax plus what carries forward is the loss."
          lean := [``CorporateYear.income, ``CorporateYear.taxableIncome, ``CorporateYear.aggregateInvestmentIncome,
            ``CorporateYear.ratesFacts, ``CorporateYear.refundableFacts, ``CorporateYear.gripFacts, ``CorporateYear.cdaFacts,
            ``CorporateYear.netTax, ``CorporateYear.taxableIncome_le_income, ``CorporateYear.dividendDeduction_le,
            ``CorporateYear.deductible_dividend_not_investment_income, ``CorporateYear.nonCapitalLossDeduction,
            ``CorporateYear.nonCapitalLoss, ``CorporateYear.nonCapitalLossesForward, ``CorporateYear.loss_year_no_taxable_income,
            ``CorporateYear.partIVOwnClaim, ``CorporateYear.partIVCarriedClaim, ``CorporateYear.own_loss_conserved,
            ``CorporateYear.adjustedAggregateInvestmentIncome, ``CorporateYear.businessLimit],
          uses := ["R8", "R9", "R23", "R26", "R44", "R45", "R47", "R69", "R71", "R72"] },
        { id := "R35", kind := .law, title := "An individual's year, to taxable income and tax", citation := "ITA 2(2); 3; 111(1)(b); 110.6; 117(2)"
          statement := "Income from sources (employment and business, dividends with the gross-up, recapture, attributed " ++
            "income), net taxable capital gains, less terminal and other losses; then taxable income, after the net capital " ++
            "loss deduction and the capital gains deduction (which the former reduces). Proven: taxable income never exceeds " ++
            "income, and the capital gains deduction never exceeds the net taxable capital gains."
          lean := [``IndividualYear.incomeFacts, ``IndividualYear.taxableIncome, ``IndividualYear.capitalGainsDeduction,
            ``IndividualYear.federalTax, ``IndividualYear.personalCredit, ``IndividualYear.donationCredit, ``IndividualYear.interestDeduction, ``IndividualYear.medicalCredit, ``IndividualYear.disabilityCredit, ``IndividualYear.ageAndPensionCredits, ``IndividualYear.oasRecovery, ``IndividualYear.employmentCredits, ``IndividualYear.amounts, ``IndividualYear.smallCredits, ``IndividualYear.tuitionCredits, ``IndividualYear.supportDeducted, ``IndividualYear.childCareDeduction, ``IndividualYear.movingDeduction, ``IndividualYear.standbyBenefits, ``IndividualYear.shareholderBenefitIncome, ``IndividualYear.stockOptionDeduction,
            ``IndividualYear.taxable_le_income, ``IndividualYear.capital_gains_deduction_le],
          uses := ["R8", "R9", "R19", "R21", "R22", "R24", "R40", "R41", "R42", "R43", "R49", "R50", "R51", "R52", "R53", "R55", "R56", "R57", "R58", "R59", "R60", "R61", "R62", "R65", "R68"] },
        { id := "R48", kind := .law, title := "The minimum tax", citation := "ITA 127.5; 127.51; 127.52(1); 127.531; 120.2"
          statement := "An individual pays at least 20.5% of adjusted taxable income over the 117(2)(d) threshold, less half " ++
            "the personal credits and 4/5 of the donation credit; adjusted taxable income counts capital gains in full (3/10 " ++
            "on gifts of listed securities), drops the dividend gross-up and allows 7/5 of the capital gains deduction. " ++
            "Minimum tax paid is recovered over the next seven years (120.2). Proven: it never lowers tax, does not apply " ++
            "within the exemption, and recovery never takes tax below the minimum amount."
          lean := [``MinimumTax.adjustedTaxableIncome, ``MinimumTax.minimumAmount, ``MinimumTax.taxPayable,
            ``MinimumTax.recovery, ``MinimumTax.regular_le, ``MinimumTax.within_exemption, ``MinimumTax.split,
            ``MinimumTax.recovery_floor], uses := ["R35"] },
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

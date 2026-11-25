import Canteen.Core.Blueprint
import Canteen.ITA.S54.SuperficialLoss
import Canteen.ITA.S40.LossDenial
import Canteen.Lemmas.SuperficialLoss
import Canteen.ITA.S40.LossDenialStatute

/-!
# Blueprint: section 54 "superficial loss" and subparagraph 40(2)(g)(i)

Each paragraph of the statute, quoted, linked to the Lean that encodes it; the truths
proven about it; and what is not yet formalized.
-/

namespace Canteen.Blueprints.SuperficialLoss

open Canteen.Blueprint Canteen.ITA Canteen.ITA.SuperficialLoss

def cite (p : String) : String := s!"ITA 54 \"superficial loss\" {p}"

def blueprint : Blueprint where
  title := "Section 54 \"superficial loss\" and subparagraph 40(2)(g)(i)"
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
          lean := [``inPeriod, ``Acquirer.isTaxpayerOrAffiliated, ``isOrIsIdentical, ``paraA] },
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
          lean := [``isOrIsIdentical, ``Identity] },
        { id := "Pj", kind := .law, title := "(j) SIFT wind-up shares before 2013", citation := cite "(j)"
          statement := "“(j) a share of the capital stock of a SIFT wind-up corporation in respect of a SIFT wind-up entity is, if the " ++
            "share was acquired before 2013, deemed to be a property that is identical to equity in the SIFT wind-up entity.”"
          lean := [``isOrIsIdentical, ``acquiredBefore2013] },
        { id := "D", kind := .law, title := "The definition as a whole", citation := cite ""
          statement := "A loss is a superficial loss if there is a loss, some acquired property meets both (a) and (b), and none of " ++
            "(c) to (h) applies."
          lean := [``superficialLoss, ``qualifies, ``excepted]
          uses := ["P0", "Pa", "Pb", "Pc", "Pd", "Pe", "Pf", "Pg", "Ph", "Pi", "Pj"] },
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
          lean := [``outside_period_irrelevant], uses := ["Pa", "D"] },
        { id := "L8", kind := .law, title := "Not held at the end never matters",
          statement := "An acquisition not held at the end of the period never affects the result, so its identity judgment call " ++
            "makes no difference."
          lean := [``not_held_irrelevant], uses := ["Pb", "D"] },
        { id := "L9", kind := .law, title := "Unaffiliated buyers never matter",
          statement := "An acquisition by a person not affiliated with the taxpayer never affects the result.",
          lean := [``not_affiliated_irrelevant], uses := ["Pa", "D"] },
        { id := "L10", kind := .law, title := "More acquisitions only add",
          statement := "Adding acquisitions can make a loss superficial, never the reverse.",
          lean := [``mono_acquisitions], uses := ["D"] },
        { id := "L11", kind := .law, title := "Rights to acquire",
          statement := "A right to acquire the particular property, other than a security-only right, counts as identical to it.",
          lean := [``right_to_acquire_identical], uses := ["Pi"] },
        { id := "L12", kind := .law, title := "SIFT shares from 2013",
          statement := "Paragraph (j) does not apply to a SIFT wind-up share acquired in 2013 or later.",
          lean := [``sift_share_after_2012], uses := ["Pj"] } ] },
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
    { heading := "Not yet formalized"
      text := ["These statements are part of the analysis but have no Lean behind them yet. Anything resting on them says so."]
      nodes := [
        { id := "N1", kind := .law, title := "Inputs decided by other provisions",
          statement := "Affiliation (section 251.1), a loss restriction event (section 251.2), and whether paragraph 40(2)(e.1) or " ++
            "subsection 40(3.4) or 69(5) applies are taken as facts."
          uses := ["Pa", "Pe", "Pf", "Ph"] },
        { id := "N2", kind := .law, title := "How much is \"to the extent that\"", citation := "ITA 40(2)(g)(i)"
          statement := "Where only part of a loss is a superficial loss (for example, fewer shares acquired than sold), the amount " ++
            "made nil is not computed. The Act gives no formula."
          uses := ["G1"] },
        { id := "N3", kind := .law, title := "Cost of the substituted property", citation := "ITA 53(1)(f)"
          statement := "The superficial loss, less any amount described in subparagraph 53(1)(f)(ii), is added to the adjusted cost " ++
            "base of the substituted property (text in `statute/ITA-53-1-f.txt`)."
          uses := ["G1"] },
        { id := "N4", kind := .law, title := "Subparagraphs 40(2)(g)(ii) to (iv)", citation := "ITA 40(2)(g)"
          statement := "Debts, personal-use property and dispositions to listed plans are not encoded.", uses := ["G0"] } ] } ]

end Canteen.Blueprints.SuperficialLoss

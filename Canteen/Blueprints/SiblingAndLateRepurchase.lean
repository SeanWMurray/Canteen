import Canteen.Core.Blueprint
import Canteen.Core.Graphs
import Canteen.Transactions.SiblingAndLateRepurchase
import Canteen.ITA.S54.Timeline

/-!
# Memo: a sibling buys in the period, and the taxpayer buys back on day 31
-/

namespace Canteen.Blueprints.SiblingAndLateRepurchase

open Canteen Canteen.Blueprint Canteen.ITA Canteen.ITA.SuperficialLoss Canteen.Transactions.SiblingAndLateRepurchase

def sl : String := "ITA 54 \"superficial loss\""

def memo : Blueprint where
  title := "Memo: a sibling buys in the period, and the taxpayer buys back on day 31"
  summary := [
    "**Issue.** The taxpayer sold 50 common shares of DEF Inc. at a $1,000.00 loss on 2025-03-03. The taxpayer's sibling " ++
      "bought the same shares a week later, and the taxpayer bought them back on 2025-04-03. Can the taxpayer use the loss?",
    "**Conclusion.** Yes. Siblings are not affiliated, and the repurchase is one day outside the period, so the loss is not " ++
      "a superficial loss (A4). This holds however the two identity judgment calls are answered: the conclusion rests on no " ++
      "judgment call at all (A5).",
    "This is a constructed example, not advice on a real transaction."]
  sections := [
    { heading := "The law"
      nodes := [
        { id := "L0", kind := .law, title := "Affiliation of individuals", citation := "ITA 251.1(1)"
          statement := "Two individuals who are not spouses or common-law partners are affiliated only if one of paragraphs " ++
            "251.1(1)(b) to (g) applies."
          lean := [``Affiliation.affiliated, ``Affiliation.individuals_not_spouses] },
        { id := "L1", kind := .law, title := "Acquisitions that never matter", citation := sl
          statement := "An acquisition by a person not affiliated with the taxpayer, or outside the period, never affects " ++
            "whether a loss is superficial; and with no acquisitions left, there is no superficial loss. (Proven once, in " ++
            "the provision's blueprint.)"
          lean := [``not_affiliated_irrelevant, ``outside_period_irrelevant, ``not_of_no_acquisitions] },
        { id := "L2", kind := .law, title := "The loss is nil", citation := "ITA 40(2)(g)(i)"
          statement := "A loss, to the extent that it is a superficial loss, is nil."
          lean := [``LossDenial.rule] } ] },
    { heading := "Facts"
      nodes := [
        { id := "F1", kind := .fact, title := "The sale"
          statement := "On 2025-03-03 the taxpayer sold 50 common shares of DEF Inc. for $2,000.00. Their adjusted cost base " ++
            "was $3,000.00."
          lean := [``sale] },
        { id := "F2", kind := .fact, title := "The buyer is the taxpayer's sibling"
          statement := "The taxpayer and the buyer are individuals and siblings: not spouses or common-law partners, and no " ++
            "other paragraph of subsection 251.1(1) applies to them."
          lean := [``siblingRelation] },
        { id := "F3", kind := .fact, title := "The sibling's purchase"
          statement := "On 2025-03-10 the sibling bought 50 common shares of DEF Inc., and still held them at the end of the period."
          lean := [``siblingPurchase], uses := ["F2", "L0"] },
        { id := "F4", kind := .fact, title := "The taxpayer's repurchase"
          statement := "On 2025-04-03 the taxpayer bought 50 common shares of DEF Inc."
          lean := [``lateRepurchase] },
        { id := "F5", kind := .fact, title := "An individual taxpayer"
          statement := "The taxpayer is an individual, so the foreign affiliate carve-out in paragraph 40(2)(g) is not engaged."
          lean := [``surplusCarveOut] } ] },
    { heading := "Judgment calls (not needed)"
      text := ["Both judgment calls are listed for completeness. The conclusion does not rest on either: it is proven for " ++
        "every answer."]
      nodes := [
        { id := "J-SIB", kind := .judgment, title := "The sibling's shares are identical"
          statement := "Whether the sibling's shares are identical to the shares sold." },
        { id := "J-LATE", kind := .judgment, title := "The shares bought back are identical"
          statement := "Whether the shares bought back are identical to the shares sold." } ] },
    { heading := "Analysis"
      nodes := [
        { id := "A1", kind := .step, title := "A loss of $1,000.00", citation := "ITA 40(1)(b)"
          statement := "The adjusted cost base ($3,000.00) exceeds the proceeds ($2,000.00) by $1,000.00."
          lean := [``loss_amount], uses := ["F1"] },
        { id := "A2", kind := .step, title := "The sibling is not affiliated", citation := "ITA 251.1(1)"
          statement := "Siblings are not spouses or common-law partners, and no other paragraph applies, so the sibling is " ++
            "not affiliated with the taxpayer."
          lean := [``sibling_not_affiliated, ``sibling_acquirer], uses := ["F2", "F3", "L0"] },
        { id := "A3", kind := .step, title := "The repurchase is on day 31", citation := s!"{sl} (a)"
          statement := "The period runs from 2025-02-01 to 2025-04-02. The repurchase on 2025-04-03 is outside it."
          lean := [``repurchase_outside_period], uses := ["F1", "F4"] },
        { id := "A4", kind := .step, title := "Not a superficial loss", citation := sl
          statement := "The sibling's purchase and the repurchase both never matter, leaving no acquisition, so the loss is " ++
            "not a superficial loss, whether or not either purchase is of identical shares."
          lean := [``not_superficial], uses := ["A2", "A3", "L1"] },
        { id := "A5", kind := .step, title := "The judgment calls don't matter"
          statement := "The result is the same on all four branches of J-SIB and J-LATE."
          lean := [``same_on_every_branch], uses := ["A4"] },
        { id := "A6", kind := .step, title := "The loss stands", citation := "ITA 40(2)(g)(i)"
          statement := "Subparagraph 40(2)(g)(i) denies nothing: the $1,000.00 loss stands."
          lean := [``loss_stands], uses := ["A4", "F5", "L2"] },
        { id := "K", kind := .conclusion, title := "Conclusion"
          statement := "The taxpayer can use the $1,000.00 loss. The conclusion rests on facts alone: no judgment call is needed."
          lean := [``loss_stands], uses := ["A1", "A5", "A6"] } ] } ]
  diagrams := [
    ("Timeline of the period", timeline (facts [])),
    ("Decision tree: both judgment calls", Graphs.branchTree SuperficialLoss.rule calls facts)]

end Canteen.Blueprints.SiblingAndLateRepurchase

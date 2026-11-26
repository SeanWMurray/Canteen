import Canteen.Core.Blueprint
import Canteen.Core.Graphs
import Canteen.Transactions.HoldcoRepurchase
import Canteen.ITA.S54.Timeline

/-!
# Memo: shares sold at a loss and bought by a family holding company
-/

namespace Canteen.Blueprints.HoldcoRepurchase

open Canteen Canteen.Blueprint Canteen.ITA Canteen.ITA.SuperficialLoss Canteen.Transactions.HoldcoRepurchase

def sl : String := "ITA 54 \"superficial loss\""

def memo : Blueprint where
  title := "Memo: shares sold at a loss and bought by a family holding company"
  summary := [
    "**Issue.** The taxpayer sold 500 common shares of MNO Ltd. at a $4,000.00 loss on 2025-11-03. Holdco, which the " ++
      "taxpayer and the taxpayer's spouse own half and half, bought the same shares 17 days later. Can the taxpayer use the loss?",
    "**Conclusion.** No, on the low-risk position that Holdco's shares are identical. The spouses are an affiliated group " ++
      "and together control Holdco, so Holdco is affiliated with the taxpayer (A0), on the facts alone. The loss is a " ++
      "superficial loss and paragraph 40(2)(g) makes it nil (A7). Paragraph 53(1)(f) adds it to Holdco's cost (C1).",
    "**What if.** Had the taxpayer owned Holdco half and half with an unrelated friend, the two would not be an affiliated " ++
      "group, and the result would turn on whether the taxpayer controls Holdco de facto (W1).",
    "This is a constructed example, not advice on a real transaction."]
  sections := [
    { heading := "The law"
      nodes := [
        { id := "L0", kind := .law, title := "Affiliated persons", citation := "ITA 251.1(1)(a)–(g)"
          statement := "Spouses are affiliated (a); a corporation is affiliated with each member of an affiliated group of " ++
            "persons by which it is controlled (b)(ii); and so on, through paragraphs (c) to (g). Computed as the smallest " ++
            "relation closed under the paragraphs."
          lean := [``AffiliatedPersons.rule, ``AffiliatedPersons.affiliated_symm] },
        { id := "L1", kind := .law, title := "Superficial loss", citation := sl
          statement := "The definition, as in the provision's blueprint."
          lean := [``superficialLoss] },
        { id := "L2", kind := .law, title := "Paragraph 40(2)(g)", citation := "ITA 40(2)(g)"
          statement := "A loss within any of subparagraphs (i) to (iv) is nil, unless the carve-out applies."
          lean := [``Paragraph40_2_g.paragraph, ``Paragraph40_2_g.deniedLoss], uses := ["L1"] },
        { id := "L3", kind := .law, title := "The loss is added to the cost", citation := "ITA 53(1)(f)"
          statement := "The superficial loss, less any amount in subparagraph 53(1)(f)(ii), is added to the cost of the " ++
            "substituted property."
          lean := [``CostAddition.addition, ``CostAddition.adjustedCostBase] } ] },
    { heading := "Facts"
      nodes := [
        { id := "F1", kind := .fact, title := "The sale"
          statement := "On 2025-11-03 the taxpayer sold 500 common shares of MNO Ltd. for $10,000.00; adjusted cost base $14,000.00."
          lean := [``sale] },
        { id := "F2", kind := .fact, title := "The family and Holdco"
          statement := "The taxpayer and the taxpayer's spouse are married, and each owns half of Holdco's voting shares, so " ++
            "together they control it."
          lean := [``world] },
        { id := "F3", kind := .fact, title := "Holdco's purchase"
          statement := "On 2025-11-20 Holdco bought 500 common shares of MNO Ltd., and still held them at the end of the period."
          lean := [``holdcoPurchase], uses := ["F2", "L0"] },
        { id := "F4", kind := .fact, title := "An individual taxpayer"
          statement := "The taxpayer is an individual, so the foreign affiliate carve-out is not engaged."
          lean := [``surplusCarveOut] },
        { id := "F5", kind := .fact, title := "Holdco paid $10,100.00"
          statement := "Holdco's shares cost $10,100.00."
          lean := [``holdcoCost] } ] },
    { heading := "Judgment call"
      nodes := [
        { id := "J-ID", kind := .judgment, title := "The shares are identical"
          statement := "Holdco's shares are of the same class of the same corporation as the shares sold. Risk: low."
          lean := [``calls, ``position] } ] },
    { heading := "Analysis"
      nodes := [
        { id := "A0", kind := .step, title := "Holdco is affiliated with the taxpayer", citation := "ITA 251.1(1)(a), (b)(ii)"
          statement := "The spouses are affiliated with each other, so they are an affiliated group of persons; Holdco is " ++
            "controlled by that group, so it is affiliated with each of them. This rests on the facts alone."
          lean := [``holdco_affiliated], uses := ["F2", "L0"] },
        { id := "A1", kind := .step, title := "A loss of $4,000.00", citation := "ITA 40(1)(b)"
          statement := "The adjusted cost base ($14,000.00) exceeds the proceeds ($10,000.00) by $4,000.00."
          lean := [``loss_amount], uses := ["F1"] },
        { id := "A2", kind := .step, title := "Bought in the period by an affiliated person", citation := s!"{sl} (a)"
          statement := "The period runs from 2025-10-04 to 2025-12-03. Holdco's purchase on 2025-11-20 falls in it."
          lean := [``purchase_in_period], uses := ["F1", "F3", "A0", "L1"] },
        { id := "A5", kind := .step, title := "No exception applies", citation := s!"{sl} (c)–(h)"
          statement := "None of paragraphs (c) to (h) applies to the sale."
          lean := [``no_exception], uses := ["F1", "L1"] },
        { id := "A6", kind := .step, title := "The loss is a superficial loss", citation := sl
          statement := "There is a loss; Holdco's purchase meets (a), as the shares are identical, and (b); and no exception applies."
          lean := [``superficial_on_position], uses := ["A1", "A2", "A5", "J-ID"] },
        { id := "A7", kind := .step, title := "The loss is nil", citation := "ITA 40(2)(g)"
          statement := "The carve-out is not engaged, so paragraph 40(2)(g) makes the $4,000.00 loss nil."
          lean := [``loss_nil_on_position], uses := ["A6", "F4", "L2"] },
        { id := "A8", kind := .step, title := "The result turns on J-ID"
          statement := "If Holdco's shares were not identical, the loss would stand."
          lean := [``turns_on_identity], uses := ["A6", "F4", "L2"] } ] },
    { heading := "Consequence and conclusion"
      nodes := [
        { id := "C1", kind := .step, title := "Holdco's adjusted cost base is $14,100.00", citation := "ITA 53(1)(f)"
          statement := "Holdco's shares are substituted property of Holdco; the $4,000.00 is added to its $10,100.00 cost."
          lean := [``holdco_adjusted_cost_base], uses := ["A7", "F5", "L3"] },
        { id := "K", kind := .conclusion, title := "Conclusion"
          statement := "The taxpayer cannot use the $4,000.00 loss: Holdco is affiliated with the taxpayer, so the loss is a " ++
            "superficial loss, nil under paragraph 40(2)(g). It is added to Holdco's adjusted cost base, which becomes $14,100.00."
          lean := [``loss_nil_on_position, ``holdco_adjusted_cost_base], uses := ["A7", "A8", "C1"] } ] },
    { heading := "What if Holdco were owned with an unrelated friend"
      nodes := [
        { id := "W1", kind := .step, title := "It would turn on de facto control", citation := "ITA 251.1(1)(b), (3) \"controlled\""
          statement := "The taxpayer and a friend would control Holdco together, but they are not an affiliated group, so " ++
            "(b)(ii) would not apply. Holdco would be affiliated with the taxpayer, and the loss superficial, only if the " ++
            "taxpayer alone controlled Holdco \"directly or indirectly in any manner whatever\" (J-DEFACTO)."
          lean := [``friend_turns_on_defacto, ``friend_relies_on_defacto], uses := ["F1", "F3", "L0", "L1"] } ] } ]
  diagrams := [
    ("Who is affiliated with whom", AffiliatedPersons.diagram world),
    ("What if: owned with a friend, if the taxpayer controls Holdco de facto",
      AffiliatedPersons.diagram (friendWorld [(friendCalls.head!).assume true])),
    ("What if: and if not", AffiliatedPersons.diagram (friendWorld [(friendCalls.head!).assume false])),
    ("Timeline of the period", timeline (slFacts position)),
    ("Decision tree: J-ID", Graphs.branchTree Paragraph40_2_g.paragraph calls facts),
    ("Decision tree for the what-if: J-DEFACTO", Graphs.branchTree SuperficialLoss.rule friendCalls friendFacts)]
  appendix := [
    ("Why Holdco is affiliated with the taxpayer",
      (AffiliatedPersons.rule.explain ⟨world, taxpayer, holdco⟩).renderWithJudgments []),
    ("Paragraph 40(2)(g), on the position taken",
      (Paragraph40_2_g.paragraph.explain (facts position)).renderWithJudgments position),
    ("Paragraph 53(1)(f), for Holdco's shares", CostAddition.rule.explainText holdcoCostFacts)]

end Canteen.Blueprints.HoldcoRepurchase

import Canteen.Core.Blueprint
import Canteen.Transactions.SpouseRepurchase

/-!
# Memo: shares sold at a loss and bought by the spouse

A memo-style blueprint for `Canteen/Transactions/SpouseRepurchase.lean`. Every statement
of the analysis links to the theorem that proves it.
-/

namespace Canteen.Blueprints.SpouseRepurchase

open Canteen Canteen.Blueprint Canteen.ITA Canteen.ITA.SuperficialLoss Canteen.Transactions.SpouseRepurchase

def sl : String := "ITA 54 \"superficial loss\""

def memo : Blueprint where
  title := "Memo: shares sold at a loss and bought by the spouse"
  summary := [
    "**Issue.** The taxpayer sold 100 common shares of ABC Ltd. at a loss on 2025-06-15, and the taxpayer's spouse bought " ++
      "100 common shares of ABC Ltd. five days later. Can the taxpayer use the loss?",
    "**Conclusion.** No, on the position that the spouse's shares are identical to the shares sold (low risk). The loss of " ++
      "$509.99 is a superficial loss, and subparagraph 40(2)(g)(i) makes it nil (A7). If the shares were not identical, the " ++
      "loss would stand (A8). The amount moves to the cost of the spouse's shares under paragraph 53(1)(f), which is not yet " ++
      "formalized (C1).",
    "This is a constructed example, not advice on a real transaction."]
  sections := [
    { heading := "Facts"
      nodes := [
        { id := "F1", kind := .fact, title := "The sale"
          statement := "On 2025-06-15 the taxpayer sold 100 common shares of ABC Ltd. for $1,000.00. Their adjusted cost base " ++
            "was $1,500.00, and the taxpayer paid a $9.99 commission."
          lean := [``sale] },
        { id := "F2", kind := .fact, title := "The spouse's purchase"
          statement := "On 2025-06-20 the taxpayer's spouse bought 100 common shares of ABC Ltd., and still held them on 2025-07-15."
          lean := [``spousePurchase] },
        { id := "F3", kind := .fact, title := "Spouses are affiliated", citation := "ITA 251.1(1)(a)"
          statement := "“an individual and a spouse or common-law partner of the individual” are affiliated persons. Section 251.1 " ++
            "is not yet encoded, so this is taken as a fact."
          lean := [``Acquirer] },
        { id := "F4", kind := .fact, title := "An ordinary sale"
          statement := "The sale was not a deemed disposition or the expiry of an option. Paragraph 40(2)(e.1) and subsections " ++
            "40(3.4) and 69(5) do not apply, and the taxpayer had no loss restriction event or change in exempt status."
          lean := [``sale] },
        { id := "F5", kind := .fact, title := "An individual taxpayer"
          statement := "The taxpayer is an individual, so the foreign affiliate carve-out in paragraph 40(2)(g) is not engaged."
          lean := [``denialFacts] } ] },
    { heading := "Judgment call"
      nodes := [
        { id := "J-ID", kind := .judgment, title := "The shares are identical"
          statement := "The spouse's shares are identical to the shares sold: they are shares of the same class of the same " ++
            "corporation. Risk of this position: low. Risk of the opposite position: high."
          lean := [``calls, ``position] } ] },
    { heading := "The law"
      nodes := [
        { id := "L1", kind := .law, title := "Superficial loss", citation := sl
          statement := "A loss is a superficial loss if there is a loss, some property acquired by the taxpayer or an affiliated " ++
            "person in the period from 30 days before to 30 days after the disposition is, or is identical to, the property sold " ++
            "and is held at the end of the period, and no exception in (c) to (h) applies. See the provision's blueprint."
          lean := [``superficialLoss, ``superficialLoss_iff] },
        { id := "L2", kind := .law, title := "The loss is nil", citation := "ITA 40(2)(g)(i)"
          statement := "A loss, to the extent that it is a superficial loss, is nil."
          lean := [``LossDenial.rule], uses := ["L1"] } ] },
    { heading := "Analysis"
      nodes := [
        { id := "A1", kind := .step, title := "A loss of $509.99", citation := "ITA 40(1)(b)"
          statement := "The adjusted cost base plus outlays and expenses ($1,509.99) exceeds the proceeds ($1,000.00) by $509.99."
          lean := [``loss_amount], uses := ["F1", "L1"] },
        { id := "A2", kind := .step, title := "Bought in the period by an affiliated person", citation := s!"{sl} (a)"
          statement := "The spouse's purchase on 2025-06-20 falls in the period from 2025-05-16 to 2025-07-15, and the spouse is " ++
            "affiliated with the taxpayer."
          lean := [``purchase_in_period], uses := ["F2", "F3", "L1"] },
        { id := "A3", kind := .step, title := "Paragraph (a) is met", citation := s!"{sl} (a)"
          statement := "The spouse's shares are identical to the shares sold, so the purchase meets paragraph (a)."
          lean := [``purchase_meets_a], uses := ["A2", "J-ID"] },
        { id := "A4", kind := .step, title := "Paragraph (b) is met", citation := s!"{sl} (b)"
          statement := "The spouse still held the shares at the end of the period on 2025-07-15."
          lean := [``purchase_meets_b], uses := ["F2", "F3"] },
        { id := "A5", kind := .step, title := "No exception applies", citation := s!"{sl} (c)–(h)"
          statement := "None of paragraphs (c) to (h) applies to the sale."
          lean := [``no_exception], uses := ["F4", "L1"] },
        { id := "A6", kind := .step, title := "The loss is a superficial loss", citation := sl
          statement := "There is a loss, the spouse's purchase meets (a) and (b), and no exception applies."
          lean := [``superficial_on_position], uses := ["A1", "A3", "A4", "A5"] },
        { id := "A7", kind := .step, title := "The loss is nil", citation := "ITA 40(2)(g)(i)"
          statement := "The foreign affiliate carve-out is not engaged, so subparagraph 40(2)(g)(i) makes the $509.99 loss nil."
          lean := [``loss_nil_on_position], uses := ["A6", "F5", "L2"] },
        { id := "A8", kind := .step, title := "The result turns on the judgment call"
          statement := "If the shares were not identical, the loss would not be a superficial loss. The conclusion depends on J-ID."
          lean := [``turns_on_identity, ``not_superficial_on_alternative], uses := ["J-ID", "A6"] } ] },
    { heading := "Consequence and conclusion"
      nodes := [
        { id := "C1", kind := .conclusion, title := "The loss moves to the spouse's cost", citation := "ITA 53(1)(f)"
          statement := "The superficial loss, less any amount described in subparagraph 53(1)(f)(ii), is added to the adjusted " ++
            "cost base of the spouse's shares. Not yet formalized."
          uses := ["A7"] },
        { id := "K", kind := .conclusion, title := "Conclusion"
          statement := "The taxpayer cannot use the $509.99 loss: it is nil under subparagraph 40(2)(g)(i), on the low-risk " ++
            "position that the spouse's shares are identical. It is instead added to the spouse's cost of the shares."
          lean := [``loss_nil_on_position], uses := ["A7", "A8", "C1"] } ] } ]
  appendix := [
    ("Subparagraph 40(2)(g)(i), on the position taken",
      (LossDenial.rule.explain (denialFacts position)).renderWithJudgments position),
    ("Section 54, on both answers to J-ID", SuperficialLoss.rule.renderBranches calls facts)]

end Canteen.Blueprints.SpouseRepurchase

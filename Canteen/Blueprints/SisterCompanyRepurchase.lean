import Canteen.Core.Blueprint
import Canteen.Core.Graphs
import Canteen.Transactions.SisterCompanyRepurchase

/-!
# Memo: a company's loss suspended when its sister company buys the shares
-/

namespace Canteen.Blueprints.SisterCompanyRepurchase

open Canteen Canteen.Blueprint Canteen.ITA Canteen.Transactions.SisterCompanyRepurchase

def memo : Blueprint where
  title := "Memo: a company's loss suspended when its sister company buys the shares"
  summary := [
    "**Issue.** Opco sold 1,000 common shares of PQR Ltd. at a $15,000.00 loss on 2025-08-01. Sisterco, controlled like " ++
      "Opco by Ann, bought the same shares two weeks later and sold them on 2026-02-02. When can Opco use the loss?",
    "**Conclusion.** Not on 2025-08-01: Opco and Sisterco are affiliated (A0), so subsection 40(3.3) applies and the loss " ++
      "is nil (A3). It is suspended, not lost: it is deemed to be Opco's loss immediately before 2026-02-02, when " ++
      "Sisterco's sale starts a 30-day period in which neither company owns the shares (A4). It is not also a " ++
      "superficial loss (A5). The conclusion rests on no judgment call.",
    "This is a constructed example, not advice on a real transaction."]
  sections := [
    { heading := "The law"
      nodes := [
        { id := "L0", kind := .law, title := "Affiliated persons", citation := "ITA 251.1(1)"
          statement := "Two corporations are affiliated if each is controlled by a person and those persons are affiliated; " ++
            "a person is affiliated with itself (251.1(1)(c)(i), (4)(a))."
          lean := [``AffiliatedPersons.rule] },
        { id := "L1", kind := .law, title := "Suspended losses", citation := "ITA 40(3.3), (3.4)"
          statement := "When a corporation disposes of capital property and, within 30 days before or after, it or an " ++
            "affiliated person acquires identical property and owns it at the end of that period, the loss is nil, and " ++
            "deemed to arise immediately before the first of the times in 40(3.4)(b)."
          lean := [``SuspendedLoss.applies, ``SuspendedLoss.rule, ``SuspendedLoss.releaseDate,
            ``SuspendedLoss.releaseDate_after] },
        { id := "L2", kind := .law, title := "Superficial loss, paragraph (h)", citation := "ITA 54 \"superficial loss\" (h)"
          statement := "A disposition to which subsection 40(3.4) applies is not a superficial loss."
          lean := [``SuspendedLoss.not_superficial_of_applies], uses := ["L1"] } ] },
    { heading := "Facts"
      nodes := [
        { id := "F1", kind := .fact, title := "Ann controls both companies"
          statement := "Ann controls Opco and Sisterco."
          lean := [``world] },
        { id := "F2", kind := .fact, title := "Opco's sale"
          statement := "On 2025-08-01 Opco sold 1,000 common shares of PQR Ltd., capital property, for $20,000.00; adjusted " ++
            "cost base $35,000.00. It was an ordinary sale: none of paragraphs (c) to (g) of the superficial loss " ++
            "definition applies."
          lean := [``sale] },
        { id := "F3", kind := .fact, title := "Sisterco's purchase"
          statement := "On 2025-08-15 Sisterco bought 1,000 common shares of PQR Ltd., and owned them at the end of the period."
          lean := [``sisterPurchase], uses := ["F1", "L0"] },
        { id := "F4", kind := .fact, title := "Sisterco's sale"
          statement := "On 2026-02-02 Sisterco sold the shares to an unrelated buyer; neither company owned any for 30 days after."
          lean := [``facts, ``factsBeforeRelease], uses := ["F2", "F3"] } ] },
    { heading := "Analysis"
      nodes := [
        { id := "A0", kind := .step, title := "The companies are affiliated", citation := "ITA 251.1(1)(c)(i)"
          statement := "Each company is controlled by Ann, and Ann is affiliated with herself, so the two are affiliated."
          lean := [``companies_affiliated], uses := ["F1", "L0"] },
        { id := "A1", kind := .step, title := "A loss of $15,000.00", citation := "ITA 40(1)(b)"
          statement := "The adjusted cost base ($35,000.00) exceeds the proceeds ($20,000.00) by $15,000.00."
          lean := [``loss_amount], uses := ["F2"] },
        { id := "A2", kind := .step, title := "Subsection 40(3.3) applies", citation := "ITA 40(3.3)"
          statement := "Opco is a corporation; it disposed of capital property; Sisterco, an affiliated person, bought the same " ++
            "shares within 30 days and owned them at the end of the period; and no exception applies."
          lean := [``applies], uses := ["A0", "F2", "F3", "F4", "L1"] },
        { id := "A3", kind := .step, title := "The loss is nil, and suspended", citation := "ITA 40(3.4)(a)"
          statement := "Opco's $15,000.00 loss from the sale is deemed to be nil."
          lean := [``suspended], uses := ["A1", "A2"] },
        { id := "A4", kind := .step, title := "Released immediately before 2026-02-02", citation := "ITA 40(3.4)(b)(i)"
          statement := "Sisterco's sale starts a 30-day period throughout which neither Opco nor Sisterco owns the shares. The " ++
            "loss is deemed to be Opco's loss immediately before then. Before that sale, nothing had released it."
          lean := [``released, ``not_yet_released], uses := ["A3", "F4"] },
        { id := "A5", kind := .step, title := "Not also a superficial loss", citation := "ITA 54 \"superficial loss\" (h)"
          statement := "Because 40(3.4) applies, paragraph (h) of the superficial loss definition excludes the disposition."
          lean := [``not_superficial], uses := ["A2", "L2"] },
        { id := "K", kind := .conclusion, title := "Conclusion"
          statement := "Opco cannot use the $15,000.00 loss in 2025; it can use it immediately before 2026-02-02."
          lean := [``suspended, ``released], uses := ["A3", "A4", "A5"] } ] } ]
  diagrams := [
    ("Who is affiliated with whom", AffiliatedPersons.diagram world),
    ("Timeline: the period, the suspension and the release", SuspendedLoss.timeline facts),
    ("Subsection 40(3.3) as a flowchart", Graphs.flowchart SuspendedLoss.applies.outline)]
  appendix := [("Subsection 40(3.4)", (SuspendedLoss.rule.explain facts).renderWithJudgments [])]

end Canteen.Blueprints.SisterCompanyRepurchase

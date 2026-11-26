import Canteen.Core.Blueprint
import Canteen.Core.Graphs
import Canteen.Transactions.EstateFreeze

/-!
# Memo: an estate freeze in favour of minor children
-/

namespace Canteen.Blueprints.EstateFreeze

open Canteen Canteen.Blueprint Canteen.ITA Canteen.Transactions.EstateFreeze

def memo : Blueprint where
  title := "Memo: an estate freeze in favour of minor children"
  summary := [
    "**Issue.** A parent exchanges Opco common shares (cost $100, worth $2,000,000) for $2,000,000 of preferred shares, and " ++
      "the parent's minor children take new common shares. Is there tax now, or each year after?",
    "**Conclusion.** No gain on the exchange: 86(1) carries the $100 cost over to the preferred shares, and with a price " ++
      "adjustment clause there is no benefit for 86(2) (A1, A2). Corporate attribution under 74.4(2) does not apply on the " ++
      "low-risk position that Opco is a small business corporation (A3). If it is not, the parent is deemed to receive " ++
      "$60,000 of interest a year, unless Opco pays at least $52,174 of dividends on the preferred shares (W1).",
    "This is a constructed example, not advice on a real transaction."]
  sections := [
    { heading := "The law"
      nodes := [
        { id := "L1", kind := .law, title := "Share exchanges", citation := "ITA 86(1), (2)"
          statement := "In a reorganization of capital, old shares exchanged for new shares go at their cost; a benefit to a " ++
            "related person is taxed."
          lean := [``ShareExchange.applies, ``ShareExchange.proceeds, ``ShareExchange.newCost, ``ShareExchange.excess] },
        { id := "L2", kind := .law, title := "Corporate attribution", citation := "ITA 74.4(2)"
          statement := "A transfer to a corporation to benefit a spouse or minor child is taxed as prescribed-rate interest, less " ++
            "dividends on the shares taken back, unless the corporation is a small business corporation."
          lean := [``CorporateAttribution.applies, ``CorporateAttribution.deemedInterest] } ] },
    { heading := "Facts"
      nodes := [
        { id := "F1", kind := .fact, title := "The exchange"
          statement := "Opco common shares (cost and paid-up capital $100, worth $2,000,000) for preferred shares worth $2,000,000."
          lean := [``exchange, ``prefs] },
        { id := "F2", kind := .fact, title := "The children's shares, and the rate"
          statement := "The minor children subscribe for new common shares; the prescribed rate is 3%."
          lean := [``attribution] } ] },
    { heading := "Judgment call"
      nodes := [
        { id := "J-SBC", kind := .judgment, title := "Opco is a small business corporation"
          statement := "All or substantially all of Opco's assets' value is in an active business carried on in Canada. Risk: low."
          lean := [``calls, ``position] } ] },
    { heading := "Analysis"
      nodes := [
        { id := "A1", kind := .step, title := "No gain on the exchange", citation := "ITA 86(1)"
          statement := "The preferred shares take over the $100 cost and $100 of paid-up capital; the proceeds are $100."
          lean := [``freeze_no_gain], uses := ["F1", "L1"] },
        { id := "A2", kind := .step, title := "No benefit", citation := "ITA 86(2)"
          statement := "The preferred shares are worth what the common shares were, so there is no excess to tax."
          lean := [``no_benefit], uses := ["F1", "L1"] },
        { id := "A3", kind := .step, title := "No corporate attribution", citation := "ITA 74.4(2)(c)"
          statement := "Opco is a small business corporation, so 74.4(2) deems nothing; this rests on J-SBC."
          lean := [``no_attribution, ``relies_on_sbc], uses := ["F2", "J-SBC", "L2"] } ] },
    { heading := "Conclusion"
      nodes := [
        { id := "K", kind := .conclusion, title := "Conclusion"
          statement := "The freeze is tax-free now, and, while Opco stays a small business corporation, each year after."
          lean := [``freeze_no_gain, ``no_attribution], uses := ["A1", "A2", "A3"] } ] },
    { heading := "If Opco is not a small business corporation"
      nodes := [
        { id := "W1", kind := .step, title := "$60,000 a year, unless dividends are paid", citation := "ITA 74.4(2)(d), (f)"
          statement := "The parent would be deemed to receive $60,000 of interest a year, but not if Opco pays at least $52,174 " ++
            "of dividends on the preferred shares ($60,000.10 included with the gross-up)."
          lean := [``attribution_if_not_sbc, ``dividends_avoid_it], uses := ["F2", "J-SBC", "L2"] } ] } ]
  diagrams := [
    ("Flowchart: subsection 74.4(2)", Graphs.flowchart CorporateAttribution.applies.outline),
    ("Decision tree: J-SBC", Graphs.branchTree CorporateAttribution.rule calls fun b => attribution b)]
  appendix := [
    ("Subsection 86(1)", (ShareExchange.rule.explain exchange).renderWithJudgments []),
    ("Subsection 74.4(2), if Opco is not a small business corporation",
      (CorporateAttribution.rule.explain (attribution [(calls.head!).assume false])).renderWithJudgments [(calls.head!).assume false])]

end Canteen.Blueprints.EstateFreeze

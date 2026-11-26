import Canteen.Core.Blueprint
import Canteen.Core.Graphs
import Canteen.Transactions.SaleThroughHoldco

/-!
# Memo: selling Opco through Holdco, with dividends first
-/

namespace Canteen.Blueprints.SaleThroughHoldco

open Canteen Canteen.Blueprint Canteen.ITA Canteen.Transactions.SaleThroughHoldco

def memo : Blueprint where
  title := "Memo: selling Opco through Holdco, with dividends first"
  summary := [
    "**Issue.** Before Holdco sold Opco to an unrelated buyer, Opco paid Holdco a $200,000 capital dividend and a " ++
      "$1,000,000 taxable dividend, though Opco had only $300,000 of safe income. What does Holdco include, and what can " ++
      "it pay its shareholder tax-free?",
    "**Conclusion.** The capital dividend is tax-free (A1). On the position that reducing the gain was one of the " ++
      "dividend's purposes, 55(2) makes $700,000 of the taxable dividend a capital gain; Holdco deducts the other $300,000 " ++
      "(A2). With the $1,799,900 gain on the sale, Holdco's taxable capital gains are $1,249,950 (A4), and its capital " ++
      "dividend account is $1,449,950, all of which it can pay out tax-free (A5, A6).",
    "**If reducing the gain were not a purpose**, the whole dividend would be deducted, and the account would be $350,000 " ++
      "smaller (W1). The result turns on J-55.",
    "This is a constructed example, not advice on a real transaction."]
  sections := [
    { heading := "The law"
      nodes := [
        { id := "L1", kind := .law, title := "Capital dividends", citation := "ITA 83(2); 89(1) \"capital dividend account\""
          statement := "A private corporation's elected dividend is a capital dividend to the extent of its account, which " ++
            "holds the untaxed half of its capital gains and capital dividends received; no shareholder includes it."
          lean := [``CapitalDividendAccount.account, ``CapitalDividendAccount.capitalDividend] },
        { id := "L2", kind := .law, title := "Intercorporate dividends", citation := "ITA 112(1); 55(2), (2.1), (5)(f)"
          statement := "A corporation deducts taxable dividends from taxable Canadian corporations, but the part over safe " ++
            "income, paid with a purpose of reducing a capital gain, is a capital gain instead."
          lean := [``IntercorporateDividends.subsection55_2, ``IntercorporateDividends.gain, ``IntercorporateDividends.deduction] },
        { id := "L3", kind := .law, title := "Capital gains", citation := "ITA 3(b); 38; 39(1); 40(1)"
          statement := "Half of a capital gain is a taxable capital gain."
          lean := [``CapitalGains.Year.paragraph3b] } ] },
    { heading := "Facts"
      nodes := [
        { id := "F1", kind := .fact, title := "Opco's capital dividend account"
          statement := "Opco has $200,000 in its capital dividend account (from life insurance proceeds)."
          lean := [``opcoAccount] },
        { id := "F2", kind := .fact, title := "The $1,000,000 dividend"
          statement := "Opco pays Holdco a $1,000,000 taxable dividend; the safe income on the Opco shares is $300,000; the " ++
            "shares are then sold to an unrelated buyer."
          lean := [``taxableDividend] },
        { id := "F3", kind := .fact, title := "The sale"
          statement := "Holdco sells the Opco shares (cost $100) for $1,800,000."
          lean := [``sale] } ] },
    { heading := "Judgment call"
      nodes := [
        { id := "J-55", kind := .judgment, title := "A purpose was to reduce the gain"
          statement := "One of the purposes of the $1,000,000 dividend, paid just before the sale, was to effect a significant " ++
            "reduction in the capital gain on the Opco shares. Risk: low."
          lean := [``calls, ``position] } ] },
    { heading := "Analysis"
      nodes := [
        { id := "A1", kind := .step, title := "The capital dividend is tax-free", citation := "ITA 83(2)"
          statement := "Opco elects; the whole $200,000 is within its account, so it is a capital dividend."
          lean := [``capital_dividend], uses := ["F1", "L1"] },
        { id := "A2", kind := .step, title := "$700,000 of the dividend is a capital gain", citation := "ITA 55(2)(c); 112(1)"
          statement := "Holdco could deduct the dividend under 112(1); a purpose was to reduce the gain; it exceeds safe income " ++
            "by $700,000; and the sale to an unrelated buyer takes it out of 55(3)(a). So $700,000 is a capital gain, and " ++
            "Holdco deducts $300,000."
          lean := [``dividend_recharacterized, ``deemedGain], uses := ["F2", "J-55", "L2"] },
        { id := "A3", kind := .step, title := "A $1,799,900 gain on the sale", citation := "ITA 40(1)(a)"
          statement := "Proceeds of $1,800,000 less the $100 cost."
          lean := [``sale_gain], uses := ["F3", "L3"] },
        { id := "A4", kind := .step, title := "Taxable capital gains of $1,249,950", citation := "ITA 3(b); 38(a)"
          statement := "Half of the $2,499,900 of capital gains."
          lean := [``holdcoYear, ``holdco_taxable], uses := ["A2", "A3", "L3"] },
        { id := "A5", kind := .step, title := "A capital dividend account of $1,449,950", citation := "ITA 89(1) \"capital dividend account\" (a), (b)"
          statement := "The untaxed half of the two gains, $1,249,950, and the $200,000 capital dividend received."
          lean := [``holdcoAccount, ``holdco_account], uses := ["A1", "A2", "A3", "L1"] },
        { id := "A6", kind := .step, title := "All of it can be paid out tax-free", citation := "ITA 83(2)"
          statement := "Holdco elects on a $1,449,950 dividend: all of it is a capital dividend, and nothing exceeds the account."
          lean := [``holdco_capital_dividend], uses := ["A5", "L1"] } ] },
    { heading := "Conclusion"
      nodes := [
        { id := "K", kind := .conclusion, title := "Conclusion"
          statement := "Holdco pays tax on $1,249,950 of taxable capital gains, deducts $300,000 of the dividend, and can pay " ++
            "its shareholder $1,449,950 tax-free as a capital dividend."
          lean := [``dividend_recharacterized, ``holdco_taxable, ``holdco_capital_dividend], uses := ["A2", "A4", "A6"] } ] },
    { heading := "If reducing the gain were not a purpose"
      nodes := [
        { id := "W1", kind := .step, title := "The whole dividend deducted, a smaller account", citation := "ITA 55(2.1)(b)"
          statement := "55(2) would not apply: Holdco would deduct the whole $1,000,000, and its capital dividend account " ++
            "would be $1,099,950. Either way, the explanation rests on J-55."
          lean := [``without_55_2, ``relies_on_purpose], uses := ["A2", "A5"] } ] } ]
  diagrams := [
    ("Flowchart: subsection 55(2)", Graphs.flowchart IntercorporateDividends.subsection55_2.outline),
    ("Decision tree: J-55", Graphs.branchTree IntercorporateDividends.rule calls taxableDividend)]
  appendix := [
    ("Subsection 55(2), on the position taken",
      (IntercorporateDividends.rule.explain (taxableDividend position)).renderWithJudgments position),
    ("Holdco's capital dividend account", (CapitalDividendAccount.explain (holdcoAccount position) 144995000).renderWithJudgments [])]

end Canteen.Blueprints.SaleThroughHoldco

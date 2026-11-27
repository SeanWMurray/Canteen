import Canteen.Core.Blueprint
import Canteen.Transactions.InvestmentIncomeIntegration

/-!
# Memo: investment income earned personally, or through a holding company
-/

namespace Canteen.Blueprints.InvestmentIncomeIntegration

open Canteen Canteen.Blueprint Canteen.ITA Canteen.Transactions.InvestmentIncomeIntegration

def memo : Blueprint where
  title := "Memo: investment income earned personally, or through a holding company"
  summary := [
    "**Issue.** An individual with a $200,000 salary earns $100,000 of interest a year. Is the federal tax different if a " ++
      "holding company earns it and pays it out as dividends?",
    "**Conclusion.** Barely. Personally, the interest adds $31,130.94 of federal tax (A3). Through Holdco, Holdco pays " ++
      "$38,666.66 but gets $30,666.66 back as a dividend refund when it pays out $92,000 (A1, A2), and the dividend adds " ++
      "$23,491.10 to the individual's tax (A4): $31,491.10 in all, $360.16 more (K). The refundable tax and the dividend " ++
      "gross-up and credit are designed to make the two routes nearly equal. Provincial tax is not computed.",
    "This is a constructed example, not advice."]
  sections := [
    { heading := "The law"
      nodes := [
        { id := "L1", kind := .law, title := "Corporate tax on investment income, and the refund", citation := "ITA 123–125; 123.3; 129"
          statement := "28% plus 10⅔% on a CCPC's investment income; 30⅔% of it is refunded at 38⅓% of dividends paid."
          lean := [``RefundableTax.partITax, ``RefundableTax.dividendRefund] },
        { id := "L2", kind := .law, title := "The individual's tax", citation := "ITA 3; 82(1); 117(2); 118; 121"
          statement := "Income, with non-eligible dividends grossed up by 15%; tax at the 117(2) rates, less the personal and " ++
            "dividend tax credits."
          lean := [``IndividualYear.federalTax] } ] },
    { heading := "Facts"
      nodes := [
        { id := "F1", kind := .fact, title := "The individual and the interest"
          statement := "A $200,000 salary in 2025; $100,000 of interest, earned personally or by Holdco, a CCPC."
          lean := [``salary, ``interest, ``personal, ``holdco, ``dividend, ``throughHoldco, ``baseline] } ] },
    { heading := "Analysis"
      nodes := [
        { id := "A1", kind := .step, title := "Holdco's tax: $8,000 after the refund", citation := "ITA 123.3; 129(1)"
          statement := "Part I tax of $38,666.66, less a $30,666.66 dividend refund."
          lean := [``holdco_tax], uses := ["F1", "L1"] },
        { id := "A2", kind := .step, title := "A $92,000 dividend", citation := "ITA 129(1)"
          statement := "The interest less the tax, plus the refund that the dividend earns."
          lean := [``dividend_is_whats_left], uses := ["A1"] },
        { id := "A3", kind := .step, title := "Personally: $31,130.94", citation := "ITA 117(2)"
          statement := "The federal tax the interest adds to a $200,000 salary."
          lean := [``personal_tax], uses := ["F1", "L2"] },
        { id := "A4", kind := .step, title := "The dividend: $23,491.10", citation := "ITA 82(1); 121"
          statement := "$105,800 of income after the gross-up, less the dividend tax credit."
          lean := [``dividend_tax], uses := ["A2", "L2"] } ] },
    { heading := "Conclusion"
      nodes := [
        { id := "K", kind := .conclusion, title := "Within $360.16"
          statement := "Through Holdco, $31,491.10 of federal tax in all, against $31,130.94 personally."
          lean := [``integration], uses := ["A1", "A3", "A4"] } ] } ]
  diagrams := []
  appendix := [
    ("Holdco", (RefundableTax.explain (holdco dividend)).renderWithJudgments []),
    ("The individual, through Holdco", (IndividualYear.explain throughHoldco).renderWithJudgments []),
    ("The individual, personally", (IndividualYear.explain personal).renderWithJudgments [])]

end Canteen.Blueprints.InvestmentIncomeIntegration

import Canteen.Core.Blueprint
import Canteen.Core.Graphs
import Canteen.Transactions.DebtSwap

/-!
# Memo: a debt swap, making mortgage interest deductible
-/

namespace Canteen.Blueprints.DebtSwap

open Canteen Canteen.Blueprint Canteen.ITA Canteen.Transactions.DebtSwap

def memo : Blueprint where
  title := "Memo: a debt swap, making mortgage interest deductible"
  summary := [
    "**Issue.** An individual with a $150,000 salary has a $200,000 mortgage at 5% and a $200,000 share portfolio that " ++
      "cost $150,000. If they sell the portfolio, pay off the mortgage and borrow to buy the portfolio back, is the interest " ++
      "deductible, and is it worth it?",
    "**Conclusion.** Yes, on the position that the new loan is used to earn income from the shares (J-INC): its $10,000 " ++
      "of interest is deductible, where the mortgage's was not (A1, A2). The sale realizes a $50,000 gain, so 2025 costs " ++
      "$3,900 more (A3); from 2026 the swap saves $2,600 a year (A4), and is ahead by the end of 2027 (K). The minimum tax " ++
      "does not apply (A5). Refinancing the loan later keeps the interest deductible (W2); if part of it buys a car, only " ++
      "the part that buys shares counts (W3). Had the portfolio stood at a loss, buying it back at once would make the " ++
      "loss superficial, added to the new cost (W4). Provincial tax is not computed.",
    "This is a constructed example, not advice."]
  sections := [
    { heading := "The law"
      nodes := [
        { id := "L1", kind := .law, title := "Interest on borrowed money", citation := "ITA 20(1)(c)(i); 20(3)"
          statement := "Interest under a legal obligation on money borrowed and used for the purpose of earning income from a " ++
            "business or property is deductible (not for exempt income or life insurance); money borrowed to repay a " ++
            "borrowing takes its use. Proven: never more than the interest, and nil for a personal use."
          lean := [``InterestDeductibility.deductible, ``InterestDeductibility.deduction, ``InterestDeductibility.deduction_le,
            ``InterestDeductibility.personal_nil, ``InterestDeductibility.refinancing_inherits] },
        { id := "L2", kind := .law, title := "The individual's year", citation := "ITA 3; 38; 82(1); 117(2); 118(1); 121"
          statement := "Income with the gain and dividends, less the interest; tax less the personal and dividend credits."
          lean := [``IndividualYear.interestDeduction, ``IndividualYear.federalTax], uses := ["L1"] },
        { id := "L3", kind := .law, title := "The minimum tax", citation := "ITA 127.5; 127.52(1)(j)(ii)"
          statement := "For the minimum tax, only half the interest on money borrowed to earn property income is deducted."
          lean := [``MinimumTax.adjustedTaxableIncome, ``MinimumTax.taxPayable], uses := ["L2"] } ] },
    { heading := "Facts"
      nodes := [
        { id := "F1", kind := .fact, title := "The individual, the mortgage and the portfolio"
          statement := "A $150,000 salary; a $200,000 home mortgage at 5%; a $200,000 portfolio costing $150,000 that pays " ++
            "$6,000 of eligible dividends; sold, the mortgage repaid, $200,000 borrowed at 5% and the portfolio bought back."
          lean := [``dividends, ``mortgage, ``loan, ``sale, ``year] },
        { id := "J-INC", kind := .judgment, title := "The loan is used to earn income"
          statement := "The borrowed money is used directly to buy dividend-paying shares, with a reasonable expectation of " ++
            "income. Risk: low."
          lean := [``calls, ``position] } ] },
    { heading := "Analysis"
      nodes := [
        { id := "A1", kind := .step, title := "The mortgage interest is not deductible", citation := "ITA 20(1)(c)(i)"
          statement := "The mortgage money bought a home."
          lean := [``mortgage_not_deductible], uses := ["F1", "L1"] },
        { id := "A2", kind := .step, title := "The investment loan's $10,000 is", citation := "ITA 20(1)(c)(i)"
          statement := "Its money bought the shares, for the purpose of earning dividends."
          lean := [``loan_deductible, ``relies_on_purpose], uses := ["F1", "J-INC", "L1"] },
        { id := "A3", kind := .step, title := "2025: $3,900 more", citation := "ITA 38(a); 117(2)"
          statement := "The $25,000 taxable gain costs $6,500; the deduction saves $2,600."
          lean := [``without_swap, ``swap_year], uses := ["A2", "F1", "L2"] },
        { id := "A4", kind := .step, title := "From 2026: $2,600 a year", citation := "ITA 117(2)"
          statement := "The $10,000 deduction at the 26% rate."
          lean := [``yearly_saving], uses := ["A2", "F1", "L2"] },
        { id := "A5", kind := .step, title := "No minimum tax", citation := "ITA 127.5"
          statement := "Adjusted taxable income is $151,000, below the $177,882 exemption."
          lean := [``no_minimum_tax], uses := ["A2", "F1", "L3"] } ] },
    { heading := "Conclusion"
      nodes := [
        { id := "K", kind := .conclusion, title := "Ahead by the end of 2027"
          statement := "−$3,900 in 2025, then $2,600 a year: $1,300 ahead after three years, and $2,600 a year after that."
          lean := [``payback], uses := ["A3", "A4"] } ] },
    { heading := "What if"
      nodes := [
        { id := "W1", kind := .step, title := "No income purpose", citation := "ITA 20(1)(c)(i)"
          statement := "If the loan was not used to earn income, nothing is deductible, and the swap only costs the tax on the gain."
          lean := [``if_no_purpose], uses := ["F1", "J-INC", "L1"] },
        { id := "W2", kind := .step, title := "Refinancing", citation := "ITA 20(3)"
          statement := "A new loan that repays the investment loan is taken to be used as that loan was: still deductible."
          lean := [``refinanced], uses := ["A2", "L1"] },
        { id := "W3", kind := .step, title := "Part of the loan buys a car", citation := "ITA 20(1)(c)(i)"
          statement := "With only $150,000 traced to the shares, 75% of the interest is deductible: $1,950 a year saved."
          lean := [``partly_traced], uses := ["F1", "J-INC", "L1", "L2"] },
        { id := "L4", kind := .law, title := "Superficial losses", citation := "ITA 54 \"superficial loss\"; 40(2)(g)(i); 53(1)(f)"
          statement := "A loss is nil where the taxpayer acquires identical property within 30 days and holds it at the end; " ++
            "the loss is added to the cost of that property."
          lean := [``LossDenial.rule, ``LossDenial.deniedLoss, ``CostAddition.adjustedCostBase] },
        { id := "J-ID", kind := .judgment, title := "The shares bought back are identical"
          statement := "The same shares of the same companies, bought back the same day. Risk: low."
          lean := [``lossCalls, ``lossPosition] },
        { id := "W4", kind := .step, title := "A portfolio at a loss", citation := "ITA 40(2)(g)(i); 53(1)(f)"
          statement := "A $250,000 portfolio sold for $200,000 and bought back the same day: the $50,000 loss is superficial, " ++
            "and the new shares cost $250,000 again. The swap neither uses nor loses the loss."
          lean := [``lossSale, ``buyBack, ``lossFacts, ``buyBackCost, ``loss_superficial], uses := ["J-ID", "L4"] } ] } ]
  diagrams := [("Flowchart: subparagraph 20(1)(c)(i)", Graphs.flowchart InterestDeductibility.deductible.outline)]
  appendix := [
    ("The investment loan", (InterestDeductibility.explain (loan position)).renderWithJudgments position),
    ("The mortgage", (InterestDeductibility.explain mortgage).renderWithJudgments []),
    ("2026, with the swap", (IndividualYear.explain (year 2026 [loan position])).renderWithJudgments [])]

end Canteen.Blueprints.DebtSwap

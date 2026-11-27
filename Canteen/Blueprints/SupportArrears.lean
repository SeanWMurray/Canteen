import Canteen.Core.Blueprint
import Canteen.Core.Graphs
import Canteen.Transactions.SupportArrears

/-!
# Memo: support in arrears, and child support first
-/

namespace Canteen.Blueprints.SupportArrears

open Canteen Canteen.Blueprint Canteen.ITA Canteen.Transactions.SupportArrears

def memo : Blueprint where
  title := "Memo: support in arrears, and child support first"
  summary := [
    "**Issue.** A 2025 court order requires $1,000 a month of child support and $1,500 of spousal support. The payer " ++
      "pays $24,000 of the $30,000 in 2025 and catches up in 2026. How much is deductible (and included) each year?",
    "**Conclusion.** $12,000 in 2025, not $18,000: payments go to child support first, because 60(b) subtracts the " ++
      "child support payable, not the child support paid (A2). In 2026, $24,000: the year's $18,000 of spousal support " ++
      "and the $6,000 in arrears (A3). Over the two years, all $36,000 of spousal support is deducted, once paid (K). " ++
      "Had only $12,000 been paid in 2025, nothing would have been (W1). Provincial tax is not computed.",
    "This is a constructed example, not advice."]
  sections := [
    { heading := "The law"
      nodes := [
        { id := "L1", kind := .law, title := "Support amounts", citation := "ITA 56.1(4)"
          statement := "A periodic allowance for maintenance, at the recipient's discretion, to a spouse living apart under " ++
            "an order or written agreement (or by a legal parent under a provincial order); child support is what is not " ++
            "identified as solely for the recipient."
          lean := [``Support.supportAmount] },
        { id := "L2", kind := .law, title := "Deducted and included", citation := "ITA 60(b); 56(1)(b)"
          statement := "The support paid since 1997, less the child support payable since the commencement day and the " ++
            "amounts deducted before. Proven: nothing until child support payable is paid."
          lean := [``Support.amount, ``Support.child_support_first], uses := ["L1"] },
        { id := "L3", kind := .law, title := "Each spouse's tax", citation := "ITA 3; 117(2); 118(1)"
          statement := "The deduction in the payer's income, the inclusion in the recipient's."
          lean := [``IndividualYear.supportDeducted, ``IndividualYear.supportIncluded, ``IndividualYear.federalTax], uses := ["L2"] } ] },
    { heading := "Facts"
      nodes := [
        { id := "F1", kind := .fact, title := "The order and the payments"
          statement := "An order made 1 January 2025: $12,000 a year of child support and $18,000 of spousal support. $24,000 " ++
            "paid in 2025, $36,000 in 2026. The payer earns $120,000, the recipient $40,000."
          lean := [``support2025, ``support2026, ``payer, ``recipient] } ] },
    { heading := "Analysis"
      nodes := [
        { id := "A1", kind := .step, title := "They are support amounts", citation := "ITA 56.1(4)"
          statement := "Periodic, at the recipient's discretion, under a court order to a spouse living apart."
          lean := [``is_support], uses := ["F1", "L1"] },
        { id := "A2", kind := .step, title := "2025: $12,000", citation := "ITA 60(b)"
          statement := "$24,000 paid less the $12,000 of child support payable. The payer's tax falls by $2,748.75, the " ++
            "recipient's rises by $1,680."
          lean := [``deductible_2025, ``tax_2025], uses := ["A1", "L2", "L3"] },
        { id := "A3", kind := .step, title := "2026: $24,000", citation := "ITA 60(b)"
          statement := "$60,000 paid in all, less $24,000 of child support payable and the $12,000 deducted in 2025."
          lean := [``deductible_2026], uses := ["A1", "L2"] } ] },
    { heading := "Conclusion"
      nodes := [
        { id := "K", kind := .conclusion, title := "All the spousal support, once paid"
          statement := "$36,000 over the two years: the spousal support ordered, deducted in the year it is caught up."
          lean := [``two_years], uses := ["A2", "A3"] } ] },
    { heading := "What if"
      nodes := [
        { id := "W1", kind := .step, title := "Only $12,000 paid in 2025", citation := "ITA 60(b)"
          statement := "All of it child support: nothing deductible."
          lean := [``nothing_until_caught_up], uses := ["F1", "L2"] },
        { id := "W2", kind := .step, title := "A lump sum", citation := "ITA 56.1(4)"
          statement := "Not an allowance on a periodic basis: not deductible."
          lean := [``lump_sum], uses := ["F1", "L1", "L2"] } ] } ]
  diagrams := [("Flowchart: \"support amount\" (56.1(4))", Graphs.flowchart Support.supportAmount.outline)]
  appendix := [
    ("2025", (Support.explain support2025).renderWithJudgments []),
    ("2026", (Support.explain support2026).renderWithJudgments [])]

end Canteen.Blueprints.SupportArrears

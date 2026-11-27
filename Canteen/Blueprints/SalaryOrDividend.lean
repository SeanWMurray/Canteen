import Canteen.Core.Blueprint
import Canteen.Transactions.SalaryOrDividend

/-!
# Memo: paying the owner-manager a salary or dividends
-/

namespace Canteen.Blueprints.SalaryOrDividend

open Canteen Canteen.Blueprint Canteen.ITA Canteen.Transactions.SalaryOrDividend

def memo : Blueprint where
  title := "Memo: paying the owner-manager a salary or dividends"
  summary := [
    "**Issue.** Opco, a CCPC, has $100,000 of active business income in 2025, within its business limit, before paying " ++
      "its owner, who has no other income. Should it pay a salary or dividends?",
    "**Conclusion.** Federally, dividends leave the owner $6,552.82 more: $84,826.13 against $78,273.31 (K). Most of the " ++
      "difference is Canada Pension Plan contributions, $8,860.20 between the owner and Opco (A1), which buy a pension " ++
      "not valued here; on tax alone the salary costs $2,307.38 less (W1). A salary also creates RRSP room. Provincial " ++
      "tax, which changes the balance, is not computed.",
    "This is a constructed example, not advice."]
  sections := [
    { heading := "The law"
      nodes := [
        { id := "L1", kind := .law, title := "Corporate tax", citation := "ITA 123–125"
          statement := "9% federally on active business income within the business limit; a salary and the employer's CPP are " ++
            "deductible, leaving no taxable income."
          lean := [``CorporateRates.tax] },
        { id := "L2", kind := .law, title := "Employment credits and the CPP deduction", citation := "ITA 118(10); 118.7; 60(e.1)"
          statement := "14% of up to $1,471 of employment income, and of base CPP contributions (and EI premiums); the " ++
            "enhanced CPP contributions are deducted from income."
          lean := [``EmploymentCredits.employmentCredit, ``EmploymentCredits.contributionCredit, ``EmploymentCredits.enhancedDeduction] },
        { id := "L3", kind := .law, title := "The owner's tax", citation := "ITA 3; 82(1); 117(2); 118(1); 121"
          statement := "Tax at the 117(2) rates on income (non-eligible dividends grossed up by 15%), less the personal, " ++
            "employment and dividend tax credits."
          lean := [``IndividualYear.federalTax, ``IndividualYear.employmentCredits, ``IndividualYear.enhancedCpp], uses := ["L2"] } ] },
    { heading := "Facts"
      nodes := [
        { id := "F1", kind := .fact, title := "Opco and its owner"
          statement := "$100,000 of active business income; the owner has no other income and, holding over 40% of the votes, " ++
            "pays no EI premiums. CPP contributions under the Canada Pension Plan for 2025."
          lean := [``available, ``cppBase, ``cppEnhanced, ``cpp, ``salary, ``opco] } ] },
    { heading := "Analysis"
      nodes := [
        { id := "A1", kind := .step, title := "A $95,569.90 salary", citation := "CPP 8(1), (1.1), (1.2); ITA 9(1)"
          statement := "With Opco's matching $4,430.10 of CPP, it uses up the $100,000; the owner contributes the same."
          lean := [``salary_uses_it_all], uses := ["F1"] },
        { id := "A2", kind := .step, title := "The owner's tax on the salary: $12,866.49", citation := "ITA 117(2); 118(10); 118.7; 60(e.1)"
          statement := "After $675.79 of employment and CPP credits and the $1,074 deduction of enhanced contributions."
          lean := [``withSalary, ``salary_tax], uses := ["A1", "L3"] },
        { id := "A3", kind := .step, title := "Or $9,000 at Opco and $6,173.87 on a $91,000 dividend", citation := "ITA 125(1); 82(1); 121"
          statement := "Opco pays the small business rate and the rest out as a non-eligible dividend."
          lean := [``dividend, ``withDividend, ``dividend_tax], uses := ["F1", "L1", "L3"] } ] },
    { heading := "Conclusion"
      nodes := [
        { id := "K", kind := .conclusion, title := "Dividends leave $6,552.82 more, federally"
          statement := "$84,826.13 against $78,273.31; neither pays minimum tax."
          lean := [``what_the_owner_keeps, ``no_minimum_tax], uses := ["A1", "A2", "A3"] } ] },
    { heading := "What if"
      nodes := [
        { id := "W1", kind := .step, title := "Tax alone", citation := "ITA 117(2); 121; 125(1)"
          statement := "Leaving CPP aside, the salary route's tax is $2,307.38 less: the dividend tax credit does not quite " ++
            "integrate at the small business rate."
          lean := [``tax_alone], uses := ["A2", "A3"] } ] } ]
  diagrams := []
  appendix := [
    ("The owner, with the salary", (IndividualYear.explain withSalary).renderWithJudgments []),
    ("The owner, with the dividend", (IndividualYear.explain withDividend).renderWithJudgments [])]

end Canteen.Blueprints.SalaryOrDividend

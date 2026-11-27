import Canteen.Core.Blueprint
import Canteen.Transactions.CrystallizationMinimumTax

/-!
# Memo: the minimum tax on crystallizing the capital gains exemption
-/

namespace Canteen.Blueprints.CrystallizationMinimumTax

open Canteen Canteen.Blueprint Canteen.ITA Canteen.Transactions.CrystallizationMinimumTax

def memo : Blueprint where
  title := "Memo: the minimum tax on crystallizing the capital gains exemption"
  summary := [
    "**Issue.** An individual with no other income in 2025 realizes a $1,250,000 gain on qualified small business " ++
      "corporation shares and shelters all of it with the capital gains deduction. Is any federal tax payable?",
    "**Conclusion.** No regular tax (A1), but $39,548.33 of minimum tax (K): for the minimum tax the gain counts in full " ++
      "and only 7/5 of the deduction comes off, leaving $375,000 of adjusted taxable income (A2). A gain of $600,000 stays " ++
      "within the exemption; $620,000 does not (W1). The 120.2 carryforward, which lets the minimum tax be recovered " ++
      "against regular tax in the next seven years, is not computed, nor is provincial tax.",
    "This is a constructed example, not advice."]
  sections := [
    { heading := "The law"
      nodes := [
        { id := "L1", kind := .law, title := "Taxable income and tax", citation := "ITA 2(2); 3; 38; 110.6(2.1); 117(2); 118(1)"
          statement := "Half the gain is a taxable capital gain, which the capital gains deduction shelters; tax at the 117(2) " ++
            "rates, less the personal credit."
          lean := [``IndividualYear.taxableIncome, ``IndividualYear.federalTax] },
        { id := "L2", kind := .law, title := "The minimum tax", citation := "ITA 127.5; 127.51; 127.52(1); 127.531"
          statement := "Tax payable is at least 20.5% of adjusted taxable income over $177,882, less the basic minimum tax " ++
            "credit (half the personal credit). Adjusted taxable income counts capital gains in full and allows 7/5 of the " ++
            "capital gains deduction."
          lean := [``MinimumTax.adjustedTaxableIncome, ``MinimumTax.minimumAmount, ``MinimumTax.taxPayable],
          uses := ["L1"] } ] },
    { heading := "Facts"
      nodes := [
        { id := "F1", kind := .fact, title := "The gain"
          statement := "Qualified small business corporation shares with a $100 cost, sold in 2025 at a gain; the deduction " ++
            "claimed for all of it; no other income."
          lean := [``shares, ``year] } ] },
    { heading := "Analysis"
      nodes := [
        { id := "A1", kind := .step, title := "No regular tax", citation := "ITA 110.6(2.1)"
          statement := "The $625,000 taxable gain is fully deducted: taxable income is nil."
          lean := [``no_regular_tax], uses := ["F1", "L1"] },
        { id := "A2", kind := .step, title := "$375,000 of adjusted taxable income", citation := "ITA 127.52(1)(d), (h)(ii)"
          statement := "The $1,250,000 gain in full, less 7/5 of the $625,000 deduction."
          lean := [``adjusted], uses := ["F1", "L2"] } ] },
    { heading := "Conclusion"
      nodes := [
        { id := "K", kind := .conclusion, title := "$39,548.33 of minimum tax"
          statement := "20.5% of the $197,118 over the exemption is $40,409.19; less half the $1,721.72 personal credit."
          lean := [``minimum_tax], uses := ["A1", "A2", "F1", "L2"] } ] },
    { heading := "What if"
      nodes := [
        { id := "W1", kind := .step, title := "A smaller gain", citation := "ITA 127.51"
          statement := "A $600,000 gain gives $180,000 of adjusted taxable income, within what the exemption and credit cover: " ++
            "no tax. A $620,000 gain gives $803.33."
          lean := [``smaller_gain, ``slightly_larger], uses := ["F1", "L2"] } ] } ]
  diagrams := []
  appendix := [
    ("The minimum tax, on $1,250,000", (MinimumTax.explain (year 125000000)).renderWithJudgments []),
    ("The year", (IndividualYear.explain (year 125000000)).renderWithJudgments [])]

end Canteen.Blueprints.CrystallizationMinimumTax

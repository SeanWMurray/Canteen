import Canteen.Core.Blueprint
import Canteen.Transactions.PensionSplit

/-!
# Memo: splitting pension income between spouses
-/

namespace Canteen.Blueprints.PensionSplit

open Canteen Canteen.Blueprint Canteen.ITA Canteen.Transactions.PensionSplit

def memo : Blueprint where
  title := "Memo: splitting pension income between spouses"
  summary := [
    "**Issue.** Spouses over 65: one receives a $90,000 pension plan annuity in 2025, the other $10,000 of RRIF payments. " ++
      "How much of the pension should they elect to split?",
    "**Conclusion.** $40,000, which leaves each with $50,000 of income: their federal tax falls from $12,010.74 to " ++
      "$6,900.24, a saving of $5,110.50 (K). Besides the lower rates, the pensioner's age credit, mostly clawed back at " ++
      "$90,000, comes back (A2, A3). No split in $1,000 steps up to the $45,000 limit does better, and splitting the whole " ++
      "$45,000 costs $10.96 more (W1). With Old Age Security as well, splitting also avoids $786.90 of OAS recovery tax " ++
      "and saves $4,712.13 (W2). Provincial tax is not computed.",
    "This is a constructed example, not advice."]
  sections := [
    { heading := "The law"
      nodes := [
        { id := "L1", kind := .law, title := "Pension splitting", citation := "ITA 60.03; 60(c); 56(1)(a.2)"
          statement := "Spouses may jointly elect to move up to half the pensioner's eligible pension income to the other: " ++
            "deducted by the pensioner, included by the transferee, and treated as the transferee's pension income for the " ++
            "pension credit. Proven: never more than half."
          lean := [``PensionSplitting.splitLimit, ``PensionSplitting.split_le_half, ``IndividualYear.splitOutAllowed] },
        { id := "L4", kind := .law, title := "The OAS recovery tax", citation := "ITA 180.2(2); 60(w)"
          statement := "15% of adjusted income over $93,454 (2025), up to the OAS received; deducted in computing income."
          lean := [``OasRecovery.tax, ``IndividualYear.oasRecovery], uses := ["L1"] },
        { id := "L2", kind := .law, title := "The age and pension credits", citation := "ITA 118(2), (3), (7)"
          statement := "14% of $9,028 less 15% of income over $45,522, for those 65 or over; 14% of up to $2,000 of eligible " ++
            "pension income."
          lean := [``PensionSplitting.ageCredit, ``PensionSplitting.pensionCredit, ``IndividualYear.ageAndPensionCredits],
          uses := ["L1", "L4"] },
        { id := "L3", kind := .law, title := "Federal tax", citation := "ITA 117(2); 118(1)"
          statement := "Tax at the 117(2) rates, less the personal, age and pension credits."
          lean := [``IndividualYear.federalTax], uses := ["L1", "L2"] } ] },
    { heading := "Facts"
      nodes := [
        { id := "F1", kind := .fact, title := "The spouses"
          statement := "Both over 65 in 2025; a $90,000 pension plan annuity and $10,000 of RRIF payments; both claim the basic " ++
            "personal amount."
          lean := [``pensioner, ``transferee] } ] },
    { heading := "Analysis"
      nodes := [
        { id := "A1", kind := .step, title := "Up to $45,000 may be split", citation := "ITA 60.03(1)"
          statement := "Half the pensioner's $90,000 of eligible pension income."
          lean := [``limit], uses := ["F1", "L1"] },
        { id := "A2", kind := .step, title := "Without splitting: $12,010.74", citation := "ITA 117(2); 118(2)"
          statement := "All of it the pensioner's, whose age credit is down to $329.88."
          lean := [``no_split], uses := ["F1", "L3"] },
        { id := "A3", kind := .step, title := "Splitting $40,000: $3,450.12 each", citation := "ITA 60(c); 56(1)(a.2)"
          statement := "$50,000 of income each; the pensioner's age credit back to $1,169.88, plus the $280 pension credit."
          lean := [``split_40000], uses := ["A1", "F1", "L3"] } ] },
    { heading := "Conclusion"
      nodes := [
        { id := "K", kind := .conclusion, title := "Split $40,000: $5,110.50 saved"
          statement := "$6,900.24 between them, against $12,010.74; no split in $1,000 steps up to the limit does better."
          lean := [``total, ``saving, ``best], uses := ["A2", "A3", "F1", "L3"] } ] },
    { heading := "What if"
      nodes := [
        { id := "W1", kind := .step, title := "Splitting the whole $45,000", citation := "ITA 60.03(1)"
          statement := "The transferee's income then exceeds the pensioner's: $10.96 more than at $40,000."
          lean := [``overshoot], uses := ["A1", "F1", "K", "L3"] },
        { id := "W2", kind := .step, title := "With $8,700 of OAS each", citation := "ITA 180.2(2)"
          statement := "Unsplit, $786.90 of the pensioner's OAS is recovered; split $40,000 and none is: $9,873.88 in all " ++
            "against $14,586.01, still the best split in $1,000 steps."
          lean := [``oas, ``pensionerOas, ``transfereeOas, ``totalOas, ``with_oas, ``best_with_oas], uses := ["F1", "L1", "L3", "L4"] } ] } ]
  diagrams := []
  appendix := [
    ("The pensioner, splitting $40,000", (IndividualYear.explain (pensioner 4000000)).renderWithJudgments []),
    ("The transferee, receiving $40,000", (IndividualYear.explain (transferee 4000000)).renderWithJudgments [])]

end Canteen.Blueprints.PensionSplit

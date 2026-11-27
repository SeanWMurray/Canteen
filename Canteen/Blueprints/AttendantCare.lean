import Canteen.Core.Blueprint
import Canteen.Transactions.AttendantCare

/-!
# Memo: attendant care, as a medical expense or with the disability credit
-/

namespace Canteen.Blueprints.AttendantCare

open Canteen Canteen.Blueprint Canteen.ITA Canteen.Transactions.AttendantCare

def memo : Blueprint where
  title := "Memo: attendant care, as a medical expense or with the disability credit"
  summary := [
    "**Issue.** An individual eligible for the disability credit earns $60,000 in 2025 and pays for full-time attendant " ++
      "care. Should they claim all of it as a medical expense, losing the disability credit, or $10,000 of it with the " ++
      "disability credit?",
    "**Conclusion.** It depends on the cost, and the break-even is $20,138: $10,000 plus the $10,138 disability amount " ++
      "(K). At $25,000 of care, claiming it all saves $680.68 (A2); at $12,000, claiming $10,000 with the disability credit " ++
      "saves $1,139.32 (A3). Both options take the same 3% of income off the medical expenses, so the break-even does not " ++
      "depend on income while the credits can be used. Provincial tax is not computed.",
    "This is a constructed example, not advice."]
  sections := [
    { heading := "The law"
      nodes := [
        { id := "L1", kind := .law, title := "The medical expense credit", citation := "ITA 118.2(1), (2)(b), (b.1)"
          statement := "14% of medical expenses over the lesser of $2,834 and 3% of income. Full-time attendant care is a " ++
            "medical expense under (b); up to $10,000 of attendant care can be claimed under (b.1) instead."
          lean := [``MedicalExpenses.credit, ``IndividualYear.medicalCredit] },
        { id := "L2", kind := .law, title := "The disability credit", citation := "ITA 118.3(1)"
          statement := "14% of $10,138, unless attendant care for the individual is claimed as a medical expense other than " ++
            "under 118.2(2)(b.1)."
          lean := [``Disability.eligible, ``Disability.credit, ``IndividualYear.disabilityCredit] },
        { id := "L3", kind := .law, title := "Federal tax", citation := "ITA 117(2); 118(1)"
          statement := "Tax at the 117(2) rates, less the personal, medical and disability credits."
          lean := [``IndividualYear.federalTax], uses := ["L1", "L2"] } ] },
    { heading := "Facts"
      nodes := [
        { id := "F1", kind := .fact, title := "The individual and the care"
          statement := "A certified, severe and prolonged impairment; $60,000 of income in 2025; full-time attendant care."
          lean := [``impairment, ``attendant, ``optionA, ``optionB] } ] },
    { heading := "Analysis"
      nodes := [
        { id := "A1", kind := .step, title := "The credits at $25,000 of care", citation := "ITA 118.2(1); 118.3(1)"
          statement := "All of it: a $3,248 medical credit and no disability credit. $10,000 of it: a $1,148 medical credit " ++
            "and a $1,419.32 disability credit."
          lean := [``credits_25000], uses := ["F1", "L1", "L2"] },
        { id := "A2", kind := .step, title := "At $25,000, claim it all", citation := "ITA 118.2(2)(b)"
          statement := "$680.68 less federal tax."
          lean := [``a_better_at_25000], uses := ["A1", "L3"] },
        { id := "A3", kind := .step, title := "At $12,000, claim $10,000 and the disability credit", citation := "ITA 118.2(2)(b.1)"
          statement := "$1,139.32 less federal tax."
          lean := [``b_better_at_12000], uses := ["F1", "L3"] } ] },
    { heading := "Conclusion"
      nodes := [
        { id := "K", kind := .conclusion, title := "Break-even at $20,138"
          statement := "At $20,138 of care the two are equal; above it, claim it all; below it, claim $10,000 and the " ++
            "disability credit."
          lean := [``break_even, ``either_side], uses := ["A2", "A3", "F1", "L3"] } ] } ]
  diagrams := []
  appendix := [
    ("The disability credit", (Disability.explain impairment).renderWithJudgments []),
    ("Option A, at $25,000", (IndividualYear.explain (optionA 2500000)).renderWithJudgments []),
    ("Option B, at $25,000", (IndividualYear.explain (optionB 2500000)).renderWithJudgments [])]

end Canteen.Blueprints.AttendantCare

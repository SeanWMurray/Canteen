import Canteen.Core.Blueprint
import Canteen.Core.Graphs
import Canteen.Transactions.Crystallization

/-!
# Memo: crystallizing the capital gains exemption, then stripping the cost
-/

namespace Canteen.Blueprints.Crystallization

open Canteen Canteen.Blueprint Canteen.ITA Canteen.Transactions.Crystallization

def memo : Blueprint where
  title := "Memo: crystallizing the capital gains exemption, then stripping the cost"
  summary := [
    "**Issue.** The taxpayer transferred Opco shares worth $2,000,000 (cost $100) to Holdco under 85(1), electing " ++
      "$1,250,100 to use the capital gains deduction. Eight months later the taxpayer sold the Holdco preferred shares, " ++
      "now costing $1,250,100, to Newco for a $1,250,100 note. Is the note a tax-free return of the crystallized cost?",
    "**Conclusion.** No. The 2025 gain of $1,250,000 is sheltered by the capital gains deduction, on the low-risk " ++
      "position that Opco is a small business corporation (A3). But on the 2026 sale, section 84.1 takes the sheltered " ++
      "gain off the cost (84.1(2)(a.1)(ii)), so $1,250,000 of the note is a deemed dividend (A5). The dividend is not " ++
      "proceeds, so the sale shows a $1,250,000 capital loss; Newco is affiliated with the taxpayer, so it is a " ++
      "superficial loss, nil, and moves to Newco's cost (A6, A7).",
    "**If Opco is not a small business corporation**, the 2025 gain is fully taxed, but the note then comes out " ++
      "without a dividend (W1).",
    "This is a constructed example, not advice on a real transaction."]
  sections := [
    { heading := "The law"
      nodes := [
        { id := "L1", kind := .law, title := "Transfer to a corporation", citation := "ITA 85(1)"
          statement := "The elected amount is the transferor's proceeds and the corporation's cost; the preferred shares " ++
            "take the elected amount less any boot as their cost."
          lean := [``TransferToCorporation.rollover, ``TransferToCorporation.electedAmount,
            ``TransferToCorporation.preferredCost] },
        { id := "L2", kind := .law, title := "Shares sold to a non-arm's length corporation", citation := "ITA 84.1"
          statement := "Paid-up capital is ground down, and what comes out above the greater of paid-up capital and hard " ++
            "cost is a dividend, not proceeds."
          lean := [``SurplusStripping.applies, ``SurplusStripping.dividend, ``SurplusStripping.proceeds,
            ``SurplusStripping.paidUpCapital] },
        { id := "L3", kind := .law, title := "The capital gains deduction", citation := "ITA 110.6(1), (2.1)"
          statement := "Gains on qualified small business corporation shares may be deducted, up to the lifetime limit."
          lean := [``CapitalGainsDeduction.qualifiedShare, ``CapitalGainsDeduction.deduction] },
        { id := "L4", kind := .law, title := "Superficial losses, and the cost addition", citation := "ITA 54; 40(2)(g)(i); 53(1)(f)"
          statement := "A loss on shares an affiliated person holds at the end of the period is nil, and is added to that " ++
            "person's cost."
          lean := [``Paragraph40_2_g.paragraph, ``Paragraph40_2_g.deniedLoss, ``CostAddition.adjustedCostBase] } ] },
    { heading := "Facts"
      nodes := [
        { id := "F1", kind := .fact, title := "The taxpayer and the companies"
          statement := "The taxpayer controls Opco, Holdco and Newco."
          lean := [``world] },
        { id := "F2", kind := .fact, title := "The Opco shares"
          statement := "Paid-up capital and cost $100, worth $2,000,000, held by the taxpayer alone for over two years; " ++
            "85% and 90% of Opco's assets' value in active business assets over the two years."
          lean := [``opcoShares] },
        { id := "F3", kind := .fact, title := "Step 1, 2025-06-30"
          statement := "The Opco shares are transferred to Holdco for preferred shares worth $2,000,000 with $1,250,100 of " ++
            "stated capital, jointly electing $1,250,100."
          lean := [``transfer, ``holdcoPreferred] },
        { id := "F4", kind := .fact, title := "Step 2, 2026-03-02"
          statement := "The taxpayer sells the Holdco preferred shares to Newco for a $1,250,100 note; Newco keeps them."
          lean := [``newcoPurchase], uses := ["F1"] } ] },
    { heading := "Judgment call"
      nodes := [
        { id := "J-SBC", kind := .judgment, title := "Opco is a small business corporation"
          statement := "All or substantially all of the value of Opco's assets is in assets used principally in an active " ++
            "business carried on primarily in Canada. Risk: low."
          lean := [``calls, ``position] } ] },
    { heading := "Analysis"
      nodes := [
        { id := "A1", kind := .step, title := "The elected amount is $1,250,100", citation := "ITA 85(1)(a), (g)"
          statement := "85(1) applies; the elected amount is between the floor and fair market value, so it stands, and the " ++
            "preferred shares cost $1,250,100."
          lean := [``step1_elected], uses := ["F3", "L1"] },
        { id := "A2", kind := .step, title := "84.1 grinds the paid-up capital, but there is no dividend", citation := "ITA 84.1(1)"
          statement := "The taxpayer and Holdco are related, so 84.1 applies. With no boot, there is no dividend; the " ++
            "preferred shares' paid-up capital is ground from $1,250,100 to $100."
          lean := [``step1, ``step1_paid_up_capital], uses := ["F1", "F3", "L1", "L2"] },
        { id := "A3", kind := .step, title := "The $1,250,000 gain is sheltered", citation := "ITA 110.6(2.1)"
          statement := "The Opco shares are qualified small business corporation shares, so the $625,000 taxable capital " ++
            "gain is deducted in full."
          lean := [``disposition1, ``deduction, ``shelteredGain, ``opco_qualified, ``step1_gain, ``step1_sheltered],
          uses := ["F2", "F3", "J-SBC", "L2", "L3", "A1", "A2"] },
        { id := "A4", kind := .step, title := "Hard cost of $100", citation := "ITA 84.1(2)(a.1)(ii)"
          statement := "The preferred shares were acquired from Holdco, not at arm's length, in substitution for the Opco " ++
            "shares, so their $1,250,100 cost is reduced by the $1,250,000 gain sheltered on the Opco shares."
          lean := [``step2, ``step2_dividend], uses := ["A1", "A2", "A3", "F1", "F4", "L1", "L2"] },
        { id := "A5", kind := .step, title := "A $1,250,000 dividend", citation := "ITA 84.1(1)(b)"
          statement := "The note exceeds the greater of the $100 paid-up capital and the $100 hard cost by $1,250,000, a " ++
            "deemed dividend."
          lean := [``step2_dividend], uses := ["A4"] },
        { id := "A6", kind := .step, title := "A $1,250,000 capital loss, made nil", citation := "ITA 54 \"proceeds of disposition\" (k); 40(2)(g)(i)"
          statement := "The dividend is not proceeds, so the taxpayer's proceeds are $100 against a $1,250,100 cost. Newco, " ++
            "which the taxpayer controls, is affiliated with the taxpayer and holds the very shares, so the loss is a " ++
            "superficial loss, nil."
          lean := [``sale2, ``slFacts, ``step2_loss, ``step2_loss_nil], uses := ["A4", "A5", "F4", "L2", "L4"] },
        { id := "A7", kind := .step, title := "Newco's cost is $2,500,100", citation := "ITA 53(1)(f)"
          statement := "The denied $1,250,000 is added to Newco's $1,250,100 cost of the preferred shares."
          lean := [``newcoCostFacts, ``newco_cost], uses := ["A6", "L4"] } ] },
    { heading := "Conclusion"
      nodes := [
        { id := "K", kind := .conclusion, title := "Conclusion"
          statement := "The crystallization works: the 2025 gain is sheltered. The strip does not: $1,250,000 of the note is " ++
            "a dividend in 2026, and the matching capital loss is denied and moves to Newco's cost."
          lean := [``step1_sheltered, ``step2_dividend, ``step2_loss_nil], uses := ["A3", "A5", "A6", "A7"] } ] },
    { heading := "If Opco is not a small business corporation"
      nodes := [
        { id := "W1", kind := .step, title := "Taxed in 2025, but no dividend in 2026", citation := "ITA 110.6(2.1); 84.1(2)(a.1)"
          statement := "The shares would not qualify, so nothing is deducted and the gain is taxed. Nothing then comes off " ++
            "the cost under 84.1(2)(a.1)(ii), and the note is within it: no dividend."
          lean := [``not_sbc_no_deduction, ``not_sbc_no_dividend], uses := ["A3", "A4", "F2", "F3", "F4", "L2", "L3"] } ] } ]
  diagrams := [
    ("Who is related to whom", RelatedPersons.diagram world),
    ("Decision tree: J-SBC", Graphs.branchTree CapitalGainsDeduction.qualifiedShare calls opcoShares)]
  appendix := [
    ("Subsection 85(1), step 1", (TransferToCorporation.rule.explain transfer).renderWithJudgments []),
    ("Section 84.1, step 1", (SurplusStripping.rule.explain step1).renderWithJudgments []),
    ("The capital gains deduction for 2025, on the position taken",
      (CapitalGainsDeduction.qualifiedShare.explain (opcoShares position)).renderWithJudgments position),
    ("Section 84.1, step 2", (SurplusStripping.rule.explain (step2 position)).renderWithJudgments []),
    ("Paragraph 40(2)(g), step 2", (Paragraph40_2_g.paragraph.explain (slFacts position)).renderWithJudgments position)]

end Canteen.Blueprints.Crystallization

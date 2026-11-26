import Canteen.Core.Blueprint
import Canteen.Core.Graphs
import Canteen.Transactions.TfsaContribution
import Canteen.ITA.S54.Timeline

/-!
# Memo: shares contributed in kind to a TFSA at a loss
-/

namespace Canteen.Blueprints.TfsaContribution

open Canteen Canteen.Blueprint Canteen.ITA Canteen.ITA.SuperficialLoss Canteen.ITA.Paragraph40_2_g
  Canteen.Transactions.TfsaContribution

def memo : Blueprint where
  title := "Memo: shares contributed in kind to a TFSA at a loss"
  summary := [
    "**Issue.** On 2025-09-02 the taxpayer contributed 80 common shares of JKL Corp., worth $4,000.00 and with an adjusted " ++
      "cost base of $5,000.00, to the taxpayer's TFSA. Can the taxpayer use the $1,000.00 loss?",
    "**Conclusion.** No. Clause 40(2)(g)(iv)(A) makes a loss on property disposed of to a TFSA trust under which the " ++
      "taxpayer is a beneficiary nil (A2, A5). Whether the trust is affiliated with the taxpayer is a judgment call (J-AFF) " ++
      "that decides whether the loss is also a superficial loss (A3), but not the outcome: the loss is nil either way (A4), " ++
      "and the conclusion rests on no judgment call.",
    "This is a constructed example, not advice on a real transaction."]
  sections := [
    { heading := "The law"
      nodes := [
        { id := "L0", kind := .law, title := "Transfers to registered plans", citation := "ITA 40(2)(g)(iv)"
          statement := "A loss from the disposition of property to a trust governed by a DPSP, EPSP, FHSA, RDSP, RRIF or TFSA " ++
            "under which the taxpayer is (or immediately after becomes) a beneficiary, or to an RRSP trust under which the " ++
            "taxpayer or spouse or common-law partner is (or within 60 days after the year becomes) an annuitant, is nil."
          lean := [``planTransferLoss, ``planTransferLoss_tfsa] },
        { id := "L3", kind := .law, title := "Superficial loss", citation := "ITA 54 \"superficial loss\""
          statement := "The definition, as in the provision's blueprint."
          lean := [``superficialLoss] },
        { id := "L2", kind := .law, title := "Affiliation", citation := "ITA 251.1(1)"
          statement := "Paragraph 251.1(1)(a) covers an individual and a spouse or common-law partner; paragraphs (b) to (g) " ++
            "are not encoded, so whether one applies is taken as given."
          lean := [``Affiliation.affiliated] },
        { id := "L1", kind := .law, title := "Paragraph 40(2)(g)", citation := "ITA 40(2)(g)"
          statement := "A loss is nil to the extent it is within any of subparagraphs (i) to (iv), unless the carve-out in the " ++
            "opening words applies."
          lean := [``paragraph, ``paragraph_holds], uses := ["L0", "L3"] } ] },
    { heading := "Facts"
      nodes := [
        { id := "F1", kind := .fact, title := "The contribution"
          statement := "On 2025-09-02 the taxpayer contributed 80 common shares of JKL Corp. to the TFSA: proceeds $4,000.00 " ++
            "(their value), adjusted cost base $5,000.00."
          lean := [``contribution] },
        { id := "F2", kind := .fact, title := "The taxpayer's own TFSA"
          statement := "The shares went to the trust governed by the taxpayer's TFSA. The taxpayer is its holder, so a " ++
            "beneficiary under it."
          lean := [``transferFacts] },
        { id := "F3", kind := .fact, title := "The trust holds the shares"
          statement := "The trust acquired the same shares that day and still held them at the end of the period. It is an " ++
            "individual (subsection 104(2)) but not the taxpayer's spouse."
          lean := [``trustAcquisition, ``trustRelation], uses := ["L2"] },
        { id := "F4", kind := .fact, title := "An individual taxpayer"
          statement := "The taxpayer is an individual, so the foreign affiliate carve-out is not engaged."
          lean := [``surplusCarveOut] } ] },
    { heading := "Judgment call"
      nodes := [
        { id := "J-AFF", kind := .judgment, title := "Is the trust affiliated?"
          statement := "Whether the TFSA trust is affiliated with the taxpayer under one of paragraphs 251.1(1)(b) to (g). " ++
            "Risk: medium either way." } ] },
    { heading := "Analysis"
      nodes := [
        { id := "A1", kind := .step, title := "A loss of $1,000.00", citation := "ITA 40(1)(b)"
          statement := "The adjusted cost base ($5,000.00) exceeds the proceeds ($4,000.00) by $1,000.00."
          lean := [``loss_amount], uses := ["F1"] },
        { id := "A2", kind := .step, title := "Clause (iv)(A) applies", citation := "ITA 40(2)(g)(iv)(A)"
          statement := "The loss is from the disposition of property to a trust governed by a TFSA under which the taxpayer " ++
            "is a beneficiary."
          lean := [``iv_applies], uses := ["A1", "F2", "F3", "F4", "L0"] },
        { id := "A3", kind := .step, title := "Superficial only if the trust is affiliated", citation := "ITA 54 \"superficial loss\""
          statement := "The trust acquired the same shares in the period and held them at its end. So the loss is also a " ++
            "superficial loss if the trust is affiliated with the taxpayer, and not otherwise."
          lean := [``superficial_iff_affiliated], uses := ["F1", "F2", "F3", "F4", "J-AFF", "L3"] },
        { id := "A4", kind := .step, title := "Nil on every branch", citation := "ITA 40(2)(g)"
          statement := "Clause (iv)(A) applies whatever the answer to J-AFF, and the carve-out is not engaged, so paragraph " ++
            "40(2)(g) makes the loss nil on every branch."
          lean := [``nil_on_every_branch, ``denied_loss], uses := ["A2", "F4", "L1"] },
        { id := "A5", kind := .step, title := "The reasons rest on facts"
          statement := "On either answer, the explanation cites clause (iv)(A), which rests on facts, rather than subparagraph " ++
            "(i), which would rest on J-AFF."
          lean := [``explanation_factual], uses := ["A4"] },
        { id := "K", kind := .conclusion, title := "Conclusion"
          statement := "The taxpayer cannot use the $1,000.00 loss: paragraph 40(2)(g) makes it nil, under clause (iv)(A), " ++
            "on the facts alone."
          lean := [``denied_loss], uses := ["A4", "A5"] } ] } ]
  diagrams := [
    ("Decision tree: J-AFF doesn't matter", Graphs.branchTree paragraph calls facts),
    ("Subparagraph (i) alone does turn on J-AFF", Graphs.branchTree SuperficialLoss.rule calls (fun b => (facts b).sl)),
    ("Paragraph 40(2)(g) as a flowchart", Graphs.flowchart paragraph.outline),
    ("Subparagraph (iv) as a flowchart", Graphs.flowchart planTransferLoss.outline),
    ("Timeline of the superficial loss period", timeline (facts affiliatedBranch).sl)]
  appendix := [
    ("Paragraph 40(2)(g), if the trust is affiliated",
      (paragraph.explain (facts affiliatedBranch)).renderWithJudgments affiliatedBranch),
    ("Paragraph 40(2)(g), if it is not",
      (paragraph.explain (facts notAffiliatedBranch)).renderWithJudgments notAffiliatedBranch)]

end Canteen.Blueprints.TfsaContribution

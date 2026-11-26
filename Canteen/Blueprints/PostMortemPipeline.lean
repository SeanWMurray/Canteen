import Canteen.Core.Blueprint
import Canteen.Core.Graphs
import Canteen.Transactions.PostMortemPipeline

/-!
# Memo: a post-mortem pipeline
-/

namespace Canteen.Blueprints.PostMortemPipeline

open Canteen Canteen.Blueprint Canteen.ITA Canteen.Transactions.PostMortemPipeline

def memo : Blueprint where
  title := "Memo: a post-mortem pipeline"
  summary := [
    "**Issue.** The deceased's Opco shares (cost $100, worth $1,000,000) pass to the estate. The gain is taxed at death. " ++
      "Can the estate take Opco's $1,000,000 out without it being taxed again as a dividend?",
    "**Conclusion.** Yes, through a pipeline. 70(5) taxes the $999,900 gain at death and gives the estate a $1,000,000 cost " ++
      "(A1). When the estate sells the shares to its new corporation for a $1,000,000 note, 84.1 applies, but its hard cost " ++
      "is the full $1,000,000, so there is no dividend and no gain (A2, A3): the gain at death is taxed once (K). Without " ++
      "the pipeline, a dividend would add $1,150,000 of income (W1). Had the capital gains deduction been claimed at death, " ++
      "the sheltered part would come back as a dividend (W2).",
    "The CRA's conditions for not applying 84(2) or 245(2) to the later repayment of the note are not encoded.",
    "This is a constructed example, not advice on a real transaction."]
  sections := [
    { heading := "The law"
      nodes := [
        { id := "L1", kind := .law, title := "Deemed disposition on death", citation := "ITA 70(5)"
          statement := "Capital property is deemed disposed of at fair market value immediately before death, and acquired at " ++
            "that cost by whoever receives it."
          lean := [``Death.proceeds, ``Death.recipientCost, ``Death.disposition] },
        { id := "L2", kind := .law, title := "Shares sold to a non-arm's length corporation", citation := "ITA 84.1; 84.1(2)(a.1)"
          statement := "Boot above the greater of paid-up capital and hard cost is a dividend; hard cost excludes earlier gains " ++
            "of non-arm's length individuals only to the extent the capital gains deduction sheltered them."
          lean := [``SurplusStripping.applies, ``SurplusStripping.hardCost, ``SurplusStripping.dividend] },
        { id := "L3", kind := .law, title := "Taxable dividends", citation := "ITA 82(1)"
          statement := "A non-eligible dividend is included with a 15% gross-up."
          lean := [``Dividends.inclusion] } ] },
    { heading := "Facts"
      nodes := [
        { id := "F1", kind := .fact, title := "The Opco shares"
          statement := "Paid-up capital and cost $100, worth $1,000,000, passing to the estate; no capital gains deduction claimed."
          lean := [``opcoShares, ``death] },
        { id := "F2", kind := .fact, title := "The sale to Newco"
          statement := "The estate sells the shares to Newco, which it controls, for a $1,000,000 note."
          lean := [``sale], uses := ["F1", "L1"] } ] },
    { heading := "Analysis"
      nodes := [
        { id := "A1", kind := .step, title := "A $999,900 gain at death; the estate's cost is $1,000,000", citation := "ITA 70(5)(a), (b)"
          statement := "The shares are deemed disposed of at $1,000,000 and acquired by the estate at that cost."
          lean := [``gain_at_death], uses := ["F1", "L1"] },
        { id := "A2", kind := .step, title := "84.1 applies, but there is no dividend", citation := "ITA 84.1(1), (2)(a.1)"
          statement := "The estate and Newco are not at arm's length and connected, so 84.1 applies. No capital gains deduction " ++
            "was claimed at death, so nothing comes off the estate's $1,000,000 cost; the $1,000,000 note does not exceed it."
          lean := [``pipeline_no_dividend], uses := ["A1", "F2", "L2"] },
        { id := "A3", kind := .step, title := "No gain on the sale", citation := "ITA 40(1)(a)"
          statement := "Proceeds of $1,000,000 against a $1,000,000 cost."
          lean := [``pipeline_no_gain], uses := ["A2"] } ] },
    { heading := "Conclusion"
      nodes := [
        { id := "K", kind := .conclusion, title := "Taxed once"
          statement := "The $999,900 gain at death is the only amount taxed; the estate takes the $1,000,000 out as repayment of " ++
            "the note."
          lean := [``taxed_once], uses := ["A1", "A3"] } ] },
    { heading := "What if"
      nodes := [
        { id := "W1", kind := .step, title := "Without the pipeline: a dividend on top", citation := "ITA 82(1)"
          statement := "Paid out as a dividend, the $1,000,000 would add $1,150,000 of income, on top of the gain at death."
          lean := [``without_pipeline], uses := ["L3"] },
        { id := "W2", kind := .step, title := "With the capital gains deduction claimed at death", citation := "ITA 84.1(2)(a.1)(ii)"
          statement := "Had $500,000 of the gain been sheltered, the estate's hard cost would be $500,000, and $500,000 of the " ++
            "note would be a dividend."
          lean := [``sheltered_part_is_dividend], uses := ["A1", "F2", "L2"] } ] } ]
  diagrams := [("Flowchart: subsection 84.1(1)", Graphs.flowchart SurplusStripping.applies.outline)]
  appendix := [
    ("Subsection 70(5), at death", (Death.rule.explain death).renderWithJudgments []),
    ("Section 84.1, the sale to Newco", (SurplusStripping.rule.explain (sale 0)).renderWithJudgments [])]

end Canteen.Blueprints.PostMortemPipeline

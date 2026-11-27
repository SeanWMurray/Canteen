import Canteen.Core.Blueprint
import Canteen.Transactions.EligibleDesignation

/-!
# Memo: how much of a dividend to designate eligible
-/

namespace Canteen.Blueprints.EligibleDesignation

open Canteen Canteen.Blueprint Canteen.ITA Canteen.Transactions.EligibleDesignation

def memo : Blueprint where
  title := "Memo: how much of a dividend to designate eligible"
  summary := [
    "**Issue.** Opco, a CCPC, earns $1,000,000 of active business income in 2025, half of it over its business limit, and " ++
      "pays the $880,000 left after tax to its shareholder. How much should it designate as eligible dividends?",
    "**Conclusion.** Exactly its general rate income pool, $360,000 (A2): the total federal tax is then $325,116.85, " ++
      "$9,909.57 less than designating nothing (K). Designating the $425,000 it kept from income taxed at the general rate " ++
      "goes $65,000 over the pool: that saves the shareholder $1,789.22 but costs $13,000 of Part III.1 tax (A3, A4). " ++
      "Electing under 185.1(2) to treat the excess as a separate non-eligible dividend undoes it (W1). The minimum tax " ++
      "and provincial tax are not computed.",
    "This is a constructed example, not advice."]
  sections := [
    { heading := "The law"
      nodes := [
        { id := "L1", kind := .law, title := "Corporate tax", citation := "ITA 123–125"
          statement := "9% federally on active business income within the business limit, 15% on the rest."
          lean := [``CorporateRates.tax] },
        { id := "L2", kind := .law, title := "The general rate income pool, and excessive designations", citation := "ITA 89(1); 185.1(1)"
          statement := "72% of income taxed at the general rate goes into the pool; eligible dividends beyond it are excessive " ++
            "and bear 20% Part III.1 tax."
          lean := [``GeneralRateIncomePool.pool, ``GeneralRateIncomePool.excessive, ``GeneralRateIncomePool.partIII1],
          uses := ["L1"] },
        { id := "L3", kind := .law, title := "The shareholder's tax", citation := "ITA 82(1); 117(2); 118; 121"
          statement := "Eligible dividends are grossed up by 38% and carry a credit of 6/11 of the gross-up; other dividends 15% " ++
            "and 9/13."
          lean := [``IndividualYear.federalTax] } ] },
    { heading := "Facts"
      nodes := [
        { id := "F1", kind := .fact, title := "Opco and its shareholder"
          statement := "$1,000,000 of active business income in 2025, a $500,000 business limit, no pool from earlier years; " ++
            "$880,000 paid to a shareholder with no other income."
          lean := [``opcoRates, ``opco, ``paidOut, ``shareholder] } ] },
    { heading := "Analysis"
      nodes := [
        { id := "A1", kind := .step, title := "Opco's tax is $120,000; its pool is $360,000", citation := "ITA 123–125; 89(1)"
          statement := "$45,000 on the first $500,000 and $75,000 on the rest; 72% of the $500,000 taxed at the general rate."
          lean := [``opco_tax], uses := ["F1", "L1", "L2"] },
        { id := "A2", kind := .step, title := "Designating $360,000: nothing excessive", citation := "ITA 89(1)"
          statement := "The eligible dividends equal the pool."
          lean := [``designate_pool], uses := ["A1"] },
        { id := "A3", kind := .step, title := "Designating $425,000: $13,000 of Part III.1 tax", citation := "ITA 185.1(1)"
          statement := "$65,000 over the pool is excessive, taxed at 20%."
          lean := [``over_designate], uses := ["A1"] },
        { id := "A4", kind := .step, title := "The shareholder's tax under each", citation := "ITA 117(2); 121"
          statement := "$205,116.85 designating $360,000; $215,026.42 designating nothing; $203,327.63 designating $425,000."
          lean := [``shareholder_tax], uses := ["F1", "L3"] } ] },
    { heading := "Conclusion"
      nodes := [
        { id := "K", kind := .conclusion, title := "Designate the pool"
          statement := "$325,116.85 in all, against $335,026.42 designating nothing and $336,327.63 designating $425,000."
          lean := [``total, ``designate_the_pool], uses := ["F1", "L1", "L2", "L3", "A1", "A2", "A3", "A4"] } ] },
    { heading := "What if"
      nodes := [
        { id := "L4", kind := .law, title := "The election", citation := "ITA 185.1(2), (3)"
          statement := "With the shareholders' concurrence, the corporation may treat up to the excessive designation as a " ++
            "separate non-eligible dividend; the eligible dividend is reduced by it. Proven: electing the whole excess leaves " ++
            "no Part III.1 tax and exactly the pool designated eligible."
          lean := [``GeneralRateIncomePool.elected, ``GeneralRateIncomePool.eligibleAfter, ``GeneralRateIncomePool.partIII1After,
            ``GeneralRateIncomePool.full_election], uses := ["L2"] },
        { id := "W1", kind := .step, title := "Over-designating, then electing: as if the pool had been designated", citation := "ITA 185.1(2)"
          statement := "Electing the $65,000 excess leaves $360,000 eligible and no Part III.1 tax: $325,116.85 in all."
          lean := [``election, ``totalElected, ``election_undoes], uses := ["F1", "L1", "L3", "L4", "A3", "K"] } ] } ]
  diagrams := []
  appendix := [
    ("Opco's pool", (GeneralRateIncomePool.explain (opco 36000000)).renderWithJudgments []),
    ("Opco, over-designating", (GeneralRateIncomePool.explain (opco 42500000)).renderWithJudgments []),
    ("The shareholder, designating the pool", (IndividualYear.explain (shareholder 36000000)).renderWithJudgments [])]

end Canteen.Blueprints.EligibleDesignation

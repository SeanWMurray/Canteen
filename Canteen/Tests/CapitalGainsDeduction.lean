import Canteen.ITA.S110_6.CapitalGainsDeduction

/-!
# Tests: the capital gains deduction (110.6(2.1))

An individual sells qualified small business corporation shares. Amounts deducted are in
half-cents, like the taxable capital gains they shelter: $625,000 is `2 * 62500000`.
Constructed examples.
-/

namespace Canteen.Tests.CapitalGainsDeduction

open Canteen Canteen.ITA Canteen.ITA.CapitalGainsDeduction CapitalGains

/-! ## The definition -/

def period (q t : Cents) : AssetPeriod := { label := "a period", qualifyingAssets := q, totalAssets := t }
def opcoShares : ShareFacts :=
  { description := "common shares of Opco", smallBusinessCorporation := .fact true,
    periods := [period 6000000 10000000, period 5100000 10000000] }

example : qualifiedShare.holds opcoShares = true := by decide
-- Exactly 50% in one period is not "more than 50%".
example : qualifiedShare.holds { opcoShares with periods := [period 5000000 10000000] } = false := by decide
-- Not a Canadian-controlled private corporation for a period.
example : qualifiedShare.holds { opcoShares with periods := [{ period 9000000 10000000 with canadianControlledPrivate := false }] } = false := by
  decide
-- Held by an unrelated person in the 24 months.
example : qualifiedShare.holds { opcoShares with relatedOwnership24Months := false } = false := by decide
-- Whether it is a small business corporation ("all or substantially all") may be judged.
#guard (qualifiedShare.explain { opcoShares with smallBusinessCorporation := .judged "J-SBC" true }).reliesOn == ["J-SBC"]

/-! ## The deduction -/

def sale (gain : Cents) : Disposition := { description := "Opco shares", proceeds := gain + 1000000, adjustedCostBase := 1000000 }
def facts (ds qs : List Disposition) : Facts := { taxationYear := 2025, year := ⟨ds, 0, {}⟩, qualifying := qs }

-- A $400,000 gain: a $200,000 taxable capital gain, all of it deductible.
def simple : Facts := facts [sale 40000000] [sale 40000000]
example : deduction simple = 40000000 := by decide
-- A $1,500,000 gain: the deduction stops at $625,000.
def large : Facts := facts [sale 150000000] [sale 150000000]
example : deduction large = 2 * 62500000 := by decide
-- Earlier deductions use up the limit.
example : deduction { large with priorWeighted := 100000000, priorDeductions := 100000000, priorA := 100000000 } = 25000000 := by decide
-- An indexed limit for a later year is given.
example : deduction { large with taxationYear := 2026, limit := 63500000 } = 2 * 63500000 := by decide

-- A $100,000 capital loss on other shares in the year comes first (annual gains limit A).
def otherLoss : Disposition := { description := "other shares", proceeds := 0, adjustedCostBase := 10000000 }
example : deduction (facts [sale 40000000, otherLoss] [sale 40000000]) = 30000000 := by decide
-- So do net capital losses of other years deducted in the year (B (a)).
example : deduction { simple with netCapitalLossesDeducted := 10000000 } = 30000000 := by decide
-- And allowable business investment losses (B (b)), which do not reduce 3(b) itself.
def bil : Disposition := { description := "a loan to a small business corporation", proceeds := 0, adjustedCostBase := 4000000, businessInvestment := true }
example : annualB (facts [sale 40000000, bil] [sale 40000000]) = 4000000 := by decide
example : deduction (facts [sale 40000000, bil] [sale 40000000]) = 36000000 := by decide
-- A cumulative net investment loss reduces the cumulative gains limit.
example : deduction { simple with cumulativeNetInvestmentLoss := 5000000 } = 35000000 := by decide
-- Gains on other property are not sheltered (d).
example : deduction (facts [sale 40000000, { sale 20000000 with description := "public shares" }] [sale 40000000]) = 40000000 := by decide
-- Not resident throughout the year, or no qualifying shares: nothing.
example : deduction { simple with residentIndividual := false } = 0 := by decide
example : deduction (facts [sale 40000000] []) = 0 := by decide

/-! ## Read-back -/

#guard (rule.explain { large with priorWeighted := 100000000, priorDeductions := 100000000, priorA := 100000000 }).render.splitOn "\n" ==
  ["1. (a) What is left of the lifetime limit: $625,000.00 less earlier deductions of $500,000.00, $125,000.00. [ITA 110.6(2.1)(a), (2)(a)]",
   "2. (b) The cumulative gains limit, $750,000.00. [ITA 110.6(2.1)(b); 110.6(1) \"cumulative gains limit\"]",
   "3. (c) The annual gains limit, $750,000.00 less $0.00, $750,000.00. [ITA 110.6(2.1)(c); 110.6(1) \"annual gains limit\"]",
   "4. (d) The 3(b) amount from qualified small business corporation shares alone, $750,000.00. [ITA 110.6(2.1)(d)]",
   "5. So the individual may deduct up to $125,000.00, the least of these. [ITA 110.6(2.1)]"]

end Canteen.Tests.CapitalGainsDeduction

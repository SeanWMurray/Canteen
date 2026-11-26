import Canteen.ITA.S3.Income
import Canteen.Transactions.SpouseRepurchase
import Canteen.Transactions.SisterCompanyRepurchase

/-!
# Tests: capital gains and losses, and section 3

Constructed examples. Amounts in half-cents are written as twice the dollars-and-cents figure.
-/

namespace Canteen.Tests.Income

open Canteen Canteen.ITA Canteen.ITA.CapitalGains Canteen.ITA.Income

def sale (desc : String) (proceeds acb : Cents) : Disposition :=
  { description := desc, proceeds, adjustedCostBase := acb }

def yr (ds : List Disposition) (other : Cents := 0) : Facts :=
  { incomeFromSources := other, capital := { dispositions := ds } }

/-! ## 40(1), 39(1), 38 -/

-- A $1,000 gain: a $500 taxable capital gain.
example : income (yr [sale "shares" 300000 200000] 5000000) = 2 * (5000000 + 50000) := by decide
-- A gain and a loss net: $1,000 − $400 = $600, half of which is $300.
example : paraB (yr [sale "A" 300000 200000, sale "B" 100000 140000]) = 2 * 30000 := by decide
-- Losses beyond gains: 3(b) is nil, and the excess is carried out of the year.
example : paraB (yr [sale "A" 300000 200000, sale "B" 0 300000]) = 0 := by decide
example : (yr [sale "A" 300000 200000, sale "B" 0 300000]).capital.unusedAllowableCapitalLosses = 2 * 100000 := by decide
-- Capital losses never reduce other income.
example : income (yr [sale "B" 0 300000] 5000000) = 2 * 5000000 := by decide
-- Half cents are kept: a $509.99 loss is a $254.995 allowable capital loss.
example : (sale "A" 100000 150999).allowableCapitalLoss = 50999 := by decide
#guard formatHalfCents 50999 == "$254.995"
-- Outlays and expenses count.
example : (({ sale "A" 300000 200000 with outlaysAndExpenses := 999 } : Disposition)).gain = 99001 := by decide
-- Depreciable property: a capital gain, but no capital loss.
example : ({ sale "truck" 100000 300000 with propertyClass := .depreciable } : Disposition).capitalLoss = 0 := by decide
example : ({ sale "truck" 400000 300000 with propertyClass := .depreciable } : Disposition).capitalGain = 100000 := by decide
-- Excluded kinds (39(1)(a)(i.1) to (v)): no capital gain.
example : ({ sale "a timber resource property" 400000 300000 with propertyClass := .excluded } : Disposition).capitalGain = 0 := by
  decide
-- Not on capital account (a judgment call answered "no"): not a capital gain.
example : ({ sale "flipped condo" 400000 300000 with capitalAccount := .judged "J-CAP" false } : Disposition).capitalGain = 0 := by
  decide
-- 38(a.1)(i): a gift of listed shares to a qualified donee is not taxed.
example : ({ sale "listed shares" 400000 100000 with giftToQualifiedDonee := true } : Disposition).taxableCapitalGain = 0 := by
  decide

/-! ## The reserve, 40(1)(a)(iii) -/

-- A $50,000 gain with $40,000 of proceeds not yet payable: at most ⅘ of the gain this year.
def withReserve (n : Nat) (claim : Cents) : Disposition :=
  { sale "land" 10000000 5000000 with reserveClaimed := claim, reasonableReserve := 4000000, precedingYears := n }
example : (withReserve 0 4000000).gain = 1000000 := by decide           -- $10,000 taxable this year
example : (withReserve 1 4000000).reserveLimit = 3000000 := by decide    -- then ⅗ …
example : (withReserve 3 4000000).reserveLimit = 1000000 := by decide    -- … then ⅕
example : (withReserve 4 4000000).reserveLimit = 0 := by decide          -- and none after four years
-- In a later year, the reserve brought back is the gain.
example : ({ withReserve 1 3000000 with priorYearReserve := some 4000000 } : Disposition).gain = 1000000 := by decide

/-! ## 41: listed personal property -/

def painting (p a : Cents) : Disposition := { sale "a painting" p a with propertyClass := .listedPersonal }
def ring (p a : Cents) : Disposition := { sale "a ring" p a with propertyClass := .listedPersonal }

-- Listed-personal-property gains and losses are pooled: $2,000 − $500, of which half is taxable.
example : (yr [painting 300000 100000, ring 50000 100000]).capital.lppTaxableNetGain = 2 * 75000 := by decide
-- A listed-personal-property loss cannot reduce other capital gains.
example : paraB (yr [sale "shares" 300000 200000, ring 0 200000]) = 2 * 50000 := by decide
example : (yr [ring 0 200000]).capital.lppLoss = 200000 := by decide
-- Losses of other years claimed, at most the year's excess.
example : ({ dispositions := [painting 300000 100000], lppLossesClaimed := 500000 } : Year).lppNetGain = 0 := by decide
example : ({ dispositions := [painting 300000 100000], lppLossesClaimed := 50000 } : Year).lppNetGain = 150000 := by decide

/-! ## Allowable business investment losses -/

-- A $10,000 loss on small business corporation shares sold at arm's length: half reduces
-- employment income of $60,000.
def sbcShares : Disposition := { sale "small business corporation shares" 0 1000000 with businessInvestment := true }
example : income (yr [sbcShares] 6000000) = 2 * 5500000 := by decide
example : paraB (yr [sbcShares]) = 0 := by decide

/-! ## From the loss rules -/

open Transactions in
-- The spouse repurchase: on the position taken, the loss is nil under 40(2)(g), so no
-- allowable capital loss; on the alternative, $254.995.
example : (ofParagraph40_2_g { sl := SpouseRepurchase.facts SpouseRepurchase.position }).allowableCapitalLoss = 0 := by
  decide +kernel
open Transactions in
example : (ofParagraph40_2_g { sl := SpouseRepurchase.facts SpouseRepurchase.alternative }).allowableCapitalLoss = 50999 := by
  decide +kernel
open Transactions in
-- The sister company: the loss is suspended under 40(3.4), so no allowable capital loss now.
example : (ofSuspendedLoss SisterCompanyRepurchase.facts).allowableCapitalLoss = 0 := by decide +kernel

/-! ## Read-back -/

#guard (report (yr [sale "100 shares of A" 300000 200000, sale "50 shares of B" 100000 150999, ring 0 50000] 5000000)).render [] ==
  "1. 100 shares of A: a gain of $1,000.00: a capital gain, of which ½, $500.00, is a taxable capital gain. [ITA 40(1); 39(1); 38]\n" ++
  "2. 50 shares of B: a loss of $509.99: a capital loss, of which ½, $254.995, is an allowable capital loss. [ITA 40(1); 39(1); 38]\n" ++
  "3. a ring: a loss of $500.00: listed personal property, pooled under section 41. [ITA 40(1); 39(1); 38]\n" ++
  "4. Listed personal property: gains less losses $0.00; after losses of other years claimed, a net gain of $0.00, of which ½, $0.00, is the taxable net gain; and a listed-personal-property loss of $500.00, which can be claimed only against listed-personal-property gains of the 3 preceding and 7 following years. [ITA 41]\n" ++
  "5. Paragraph 3(a), income from sources other than taxable capital gains: $50,000.00. [ITA 3(a)]\n" ++
  "6. Paragraph 3(b): taxable capital gains $500.00 and taxable net gain from listed personal property $0.00, less allowable capital losses $254.995 in excess of allowable business investment losses $0.00: $245.005. [ITA 3(b)]\n" ++
  "7. Paragraph 3(c), less Subdivision E deductions of $0.00: $50,245.005. [ITA 3(c)]\n" ++
  "8. Paragraph 3(d), less losses from sources of $0.00 and allowable business investment losses of $0.00: $50,245.005. [ITA 3(d)]\n" ++
  "9. So the taxpayer's income for the year is $50,245.005. [ITA 3(e), (f)]\n" ++
  "Relies on no judgment calls."

end Canteen.Tests.Income

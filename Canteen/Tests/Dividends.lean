import Canteen.ITA.S82.Dividends
import Canteen.Transactions.Crystallization

/-!
# Tests: taxable dividends, the gross-up and the dividend tax credit (82(1), 121)

Constructed examples.
-/

namespace Canteen.Tests.Dividends

open Canteen Canteen.ITA Canteen.ITA.Dividends

def nonEligible (a : Cents) : Dividend := { description := "dividend from Opco", amount := a }
def eligible (a : Cents) : Dividend := { description := "dividend from a public company", amount := a, eligible := true }

-- $1,000 non-eligible in 2025: $1,150 included; credit 9/13 of $150 = $103.84.
def y2025 : Facts := { taxationYear := 2025, dividends := [nonEligible 100000] }
example : inclusion y2025 = 115000 ∧ credit y2025 = 10384 := by decide
-- $1,000 eligible in 2025: $1,380 included; credit 6/11 of $380 = $207.27.
def e2025 : Facts := { taxationYear := 2025, dividends := [eligible 100000] }
example : inclusion e2025 = 138000 ∧ credit e2025 = 20727 := by decide
-- Earlier years' rates.
example : inclusion { y2025 with taxationYear := 2018 } = 116000 ∧ credit { y2025 with taxationYear := 2018 } = 11636 := by decide
example : inclusion { e2025 with taxationYear := 2010 } = 144000 ∧ credit { e2025 with taxationYear := 2010 } = 25882 := by decide
example : inclusion { e2025 with taxationYear := 2007 } = 145000 ∧ credit { e2025 with taxationYear := 2007 } = 0 := by decide
-- No rate in the consolidated text for a non-eligible dividend in 2015: none applied, and said so.
example : inclusion { y2025 with taxationYear := 2015 } = 100000 := by decide
#guard ((explain { y2025 with taxationYear := 2015 }).steps.map (·.citation)).contains "ITA 82(1)(b)(i)"
-- A corporation includes the dividend without gross-up (and deducts it under 112, not encoded).
example : inclusion { y2025 with individual := false } = 100000 ∧ credit { y2025 with individual := false } = 0 := by decide
-- (d): from a resident corporation that is not a taxable Canadian corporation, no gross-up.
example : inclusion { y2025 with dividends := [{ nonEligible 100000 with payerTaxableCanadian := false }] } = 100000 := by decide
-- A dividend rental arrangement (c): no gross-up.
example : inclusion { y2025 with dividends := [{ nonEligible 100000 with rental := true }] } = 100000 := by decide
-- From a non-resident corporation: not under 82(1).
example : inclusion { y2025 with dividends := [{ nonEligible 100000 with payerResident := false }] } = 0 := by decide

-- The 84.1 dividend in the crystallization transaction: $1,250,000, non-eligible, in 2026.
def stripped : Facts :=
  { taxationYear := 2026,
    dividends := [nonEligible (SurplusStripping.dividend (Transactions.Crystallization.step2 Transactions.Crystallization.position))] }
example : inclusion stripped = 143750000 ∧ credit stripped = 12980769 := by decide +kernel

/-! ## Read-back -/

#guard (rule.explain y2025).render.splitOn "\n" ==
  ["1. Taxable dividends (other than eligible dividends) from corporations resident in Canada: $1,000.00. [ITA 82(1)(a)]",
   "2. Eligible dividends from corporations resident in Canada: $0.00. [ITA 82(1)(a.1)]",
   "3. The gross-up is $150.00 on the non-eligible dividends and $0.00 on the eligible dividends. [ITA 82(1)(b)]",
   "4. So $1,150.00 is included in income. [ITA 82(1)]",
   "5. The dividend tax credit is $103.84. [ITA 121]"]

end Canteen.Tests.Dividends

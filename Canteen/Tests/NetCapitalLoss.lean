import Canteen.ITA.S111.NetCapitalLoss
import Canteen.Transactions.SpouseRepurchase

/-!
# Tests: net capital losses and taxable income
-/

namespace Canteen.Tests.NetCapitalLoss

open Canteen Canteen.ITA Canteen.ITA.CapitalGains Canteen.ITA.NetCapitalLoss

def sale (desc : String) (proceeds acb : Cents) : Disposition := { description := desc, proceeds, adjustedCostBase := acb }

-- 111(8): a $3,000 loss and a $1,000 gain: ½ × $2,000 = $1,000 of net capital loss.
def y2025 : Year := { dispositions := [sale "A" 0 300000, sale "B" 200000 100000] }
example : netCapitalLoss y2025 = 2 * 100000 := by decide
-- ABILs are not part of it (they are deducted under 3(d)).
example : netCapitalLoss { dispositions := [{ sale "SBC shares" 0 300000 with businessInvestment := true }] } = 0 := by decide
-- C: an expired ABIL of the tenth preceding year is added, unless there was a loss restriction event.
example : netCapitalLoss y2025 { abilTenthYear := 50000, unusedNonCapitalLoss := 30000 } = 2 * 100000 + 30000 := by decide
example : netCapitalLoss y2025 { abilTenthYear := 50000, unusedNonCapitalLoss := 30000, lossRestrictionEvent := true } =
    2 * 100000 := by decide
-- D: section 80 reductions.
example : netCapitalLoss y2025 {} 50000 = 2 * 100000 - 50000 := by decide

-- 111(1)(b): carried forward to 2026 against a $4,000 gain (a $2,000 taxable capital gain).
def t2026 (claims : List Claim) : TaxableIncomeFacts :=
  { taxationYear := 2026, claims,
    income := { incomeFromSources := 5000000, capital := { dispositions := [sale "C" 500000 100000] } } }
example : taxableIncome (t2026 [⟨2025, 2 * 100000, (1, 2)⟩]) = 2 * (5000000 + 200000 - 100000) := by decide
-- The deduction is at most the taxable capital gains: a larger claim is cut down.
example : ncld (t2026 [⟨2025, 2 * 900000, (1, 2)⟩]) = 2 * 200000 := by decide
-- Carried back up to three years: a 2029 loss can be deducted in 2026, a 2030 loss cannot.
example : ncld (t2026 [⟨2029, 2 * 100000, (1, 2)⟩]) = 2 * 100000 := by decide
example : ncld (t2026 [⟨2030, 2 * 100000, (1, 2)⟩]) = 0 := by decide
example : ncld (t2026 [⟨2026, 2 * 100000, (1, 2)⟩]) = 0 := by decide
-- 111(1.1)(a)(ii): a loss of a year with a ¾ fraction is worth ⅔ as much at ½.
example : (⟨1999, 2 * 300000, (3, 4)⟩ : Claim).adjusted = 2 * 200000 := by decide

-- The spouse repurchase, if the shares were not identical: a net capital loss of $254.995 for
-- 2025, which shelters $509.99 of a later capital gain.
open Transactions in
def spouseYear : Year :=
  { dispositions := [ofParagraph40_2_g { sl := SpouseRepurchase.facts SpouseRepurchase.alternative }] }
example : netCapitalLoss spouseYear = 50999 := by decide +kernel
example : ncld (t2026 [⟨2025, netCapitalLoss spouseYear, (1, 2)⟩]) = 50999 := by decide +kernel
-- On the position taken, the loss is nil under 40(2)(g): no net capital loss at all.
open Transactions in
example : netCapitalLoss { dispositions := [ofParagraph40_2_g { sl := SpouseRepurchase.facts SpouseRepurchase.position }] } = 0 := by
  decide +kernel

def lines : List String :=
  (((report (t2026 [⟨2025, 2 * 100000, (1, 2)⟩, ⟨1999, 2 * 30000, (3, 4)⟩, ⟨2030, 100, (1, 2)⟩])).render []).splitOn "\n").drop 6

#guard lines ==
  ["7. Claimed in respect of the net capital loss of 2025: $1,000.00. [ITA 111(1)(b)]",
   "8. Claimed in respect of the net capital loss of 1999: $300.00, which at that year's fraction of 3/4 becomes $200.00 at ½. [ITA 111(1)(b), (1.1)(a)(ii)]",
   "9. The net capital loss of 2030 cannot be deducted in 2026: only losses of preceding years and of the three following years can. [ITA 111(1)(b)]",
   "10. The net capital loss deduction is the lesser of the amount in 3(b), $2,000.00, and the claims: $1,200.00. [ITA 111(1.1)(a)]",
   "11. Taxable income: income of $52,000.00, less $1,200.00 and other deductions of $0.00: $50,800.00. [ITA 2(2); 111]",
   "Relies on no judgment calls."]

end Canteen.Tests.NetCapitalLoss

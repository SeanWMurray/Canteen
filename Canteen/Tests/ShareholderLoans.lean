import Canteen.ITA.S15.ShareholderLoans

/-!
# Tests: shareholder loans (15(2), (2.6), 80.4(2), (3), 20(1)(j))

Opco (year end December 31) lends its shareholder $50,000 on 2025-03-01. The prescribed rate is 4%.
Constructed examples.
-/

namespace Canteen.Tests.ShareholderLoans

open Canteen Canteen.ITA Canteen.ITA.ShareholderLoans

def loan : Facts := { amount := 5000000, lenderYearEnd := ⟨2025, 12, 31⟩, prescribedRate := 400 }

-- Repaid on 2026-11-30, within a year of Opco's 2025 year end: not income, but $2,000 of deemed interest.
def repaid : Facts := { loan with repaidOn := some ⟨2026, 11, 30⟩ }
example : inclusion repaid = 0 ∧ deemedInterest repaid = 200000 := by decide
-- Interest of $1,000 paid by 2026-01-30 halves the benefit.
example : deemedInterest { repaid with interestPaid := 100000 } = 100000 := by decide
-- At a commercial rate: no benefit.
example : deemedInterest { repaid with commercialRate := true } = 0 := by decide
-- The deadline is 2026-12-31: repaid 2027-01-15 is too late. The $50,000 is income, and there is no deemed interest.
def late : Facts := { loan with repaidOn := some ⟨2027, 1, 15⟩ }
example : inclusion late = 5000000 ∧ deemedInterest late = 0 := by decide
example : inclusion { loan with repaidOn := some ⟨2026, 12, 31⟩ } = 0 := by decide
-- Repaid in time, but as part of a series of loans and repayments: still income (often a judgment call).
def series : Facts := { repaid with series := .judged "J-SERIES" true }
example : inclusion series = 5000000 := by decide
#guard (included.explain series).reliesOn == ["J-SERIES"]
-- Never repaid: income; a later repayment is deducted in the year it is made (20(1)(j)).
example : inclusion loan = 5000000 ∧ repaymentDeduction loan 3000000 = 3000000 := by decide
-- A loan to a corporation resident in Canada: neither.
example : inclusion { loan with residentCorporation := true } = 0 ∧ deemedInterest { loan with residentCorporation := true } = 0 := by
  decide

end Canteen.Tests.ShareholderLoans

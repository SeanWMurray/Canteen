import Canteen.ITA.S20.InstalmentSales

/-!
# Tests: the reserve for unpaid amounts on property sold (20(1)(n), 20(8))

Constructed examples.
-/

namespace Canteen.Tests.InstalmentSales

open Canteen Canteen.ITA Canteen.ITA.InstalmentSales

-- Equipment from inventory sold 2025-03-01 for $300,000 ($90,000 profit), paid over three years to
-- 2028-03-01; $200,000 unpaid at the 2025-12-31 year end: a reserve of $60,000.
def press : Sale := { description := "the press sold to Dalco", saleDate := ⟨2025, 3, 1⟩, price := 30000000, profit := 9000000, unpaid := 20000000, latestDue := ⟨2028, 3, 1⟩ }
def y2025 : Facts := { yearEnd := ⟨2025, 12, 31⟩, sales := [press] }
example : reserve y2025 = 6000000 := by decide +kernel
-- 2026: $100,000 unpaid; last year's reserve comes back, $30,000 new: net $30,000 of profit.
def y2026 : Facts := { yearEnd := ⟨2026, 12, 31⟩, sales := [{ press with unpaid := 10000000 }], priorReserve := reserve y2025 }
example : reserve y2026 = 3000000 ∧ net y2026 = 3000000 := by decide +kernel
-- 2028 year end: more than 36 months after the sale, no reserve even if something is unpaid.
example : reserve { yearEnd := ⟨2028, 12, 31⟩, sales := [{ press with unpaid := 100000 }] } = 0 := by decide +kernel
-- All due within 18 months: no reserve; land: no two-year condition.
example : reserve { y2025 with sales := [{ press with latestDue := ⟨2026, 9, 1⟩ }] } = 0 := by decide +kernel
example : reserve { y2025 with sales := [{ press with latestDue := ⟨2026, 9, 1⟩, realProperty := true }] } = 6000000 := by decide +kernel
-- To a corporation the taxpayer controls: none (20(8)(c)). A non-resident: none (20(8)(a)).
example : reserve { y2025 with sales := [{ press with relatedPurchaser := true }] } = 0 := by decide +kernel
example : reserve { y2025 with exemptOrNonResident := true } = 0 := by decide +kernel
-- A smaller reasonable amount may be claimed; never more than the profit.
example : reserve { y2025 with sales := [{ press with reasonable := some 2000000 }] } = 2000000 := by decide +kernel
example : reserve { y2025 with sales := [{ press with reasonable := some 50000000 }] } = 9000000 := by decide +kernel

end Canteen.Tests.InstalmentSales

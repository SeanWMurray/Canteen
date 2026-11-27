import Canteen.ITA.S18.PrepaidExpenses

/-!
# Tests: prepaid expenses (18(9))

Constructed examples.
-/

namespace Canteen.Tests.PrepaidExpenses

open Canteen Canteen.ITA Canteen.ITA.PrepaidExpenses

def y2025 : TaxYear := ⟨⟨2025, 1, 1⟩, ⟨2025, 12, 31⟩⟩
def y2026 : TaxYear := ⟨⟨2026, 1, 1⟩, ⟨2026, 12, 31⟩⟩

-- A $36,500 insurance premium paid in 2025 for 2025-07-01 to 2026-06-30 (365 days): 184 days in 2025,
-- $18,400; the other 181 days' $18,100 in 2026.
def premium : Outlay := { description := "the liability insurance premium", kind := .insurance, amount := 3650000, periodStart := ⟨2025, 7, 1⟩, periodEnd := ⟨2026, 6, 30⟩ }
example : premium.deduction y2025 y2025 true = 1840000 := by decide +kernel
example : premium.deduction y2025 y2026 true = 1810000 := by decide +kernel
-- Nothing in a year before it was paid.
example : premium.deduction y2026 y2025 true = 0 := by decide +kernel
-- Two years of rent paid up front, $24,000 for 2025 and 2026 (730 days): half each year.
def rent : Outlay := { description := "two years' rent paid in advance", kind := .rent, amount := 2400000, periodStart := ⟨2025, 1, 1⟩, periodEnd := ⟨2026, 12, 31⟩ }
example : rent.deduction y2025 y2025 true = 1200000 ∧ rent.deduction y2025 y2026 true = 1200000 := by decide +kernel
-- Prepaid interest of a corporation: the 2026 part is not carried by 18(9)(b); an individual's is.
def interest : Outlay := { rent with description := "interest prepaid for 2025 and 2026", kind := .interest }
example : interest.deduction y2025 y2026 true = 0 ∧ interest.deduction y2025 y2026 false = 1200000 := by decide +kernel
-- Rent paid late, in 2025, for 2024 and the first half of 2025: all of it is deductible in 2025 (not prepaid).
def lateRent : Outlay := { description := "rent paid late", kind := .rent, amount := 1000000, periodStart := ⟨2024, 1, 1⟩, periodEnd := ⟨2025, 6, 30⟩ }
example : lateRent.deduction y2025 y2025 true = 1000000 := by decide +kernel

end Canteen.Tests.PrepaidExpenses

import Canteen.Core.Date
import Canteen.Core.Money

/-!
# Tests: dates and money
-/

namespace Canteen.Tests.Date

open Canteen

-- Day numbers round-trip for every day from 1900-03-01 to 2100-02-28.
#guard (List.range 73048).all fun i =>
  let n := (⟨1900, 3, 1⟩ : Date).toDays + i
  (Date.ofDays n).toDays == n && (Date.ofDays n).valid

-- Known dates.
#guard (Date.ofDays ((⟨2024, 2, 28⟩ : Date).toDays + 1)) == ⟨2024, 2, 29⟩   -- leap year
#guard (Date.ofDays ((⟨2025, 2, 28⟩ : Date).toDays + 1)) == ⟨2025, 3, 1⟩    -- not a leap year
#guard (Date.ofDays ((⟨2100, 2, 28⟩ : Date).toDays + 1)) == ⟨2100, 3, 1⟩    -- century, not leap
#guard (Date.ofDays ((⟨2000, 2, 28⟩ : Date).toDays + 1)) == ⟨2000, 2, 29⟩   -- 400-year leap
#guard (⟨2025, 12, 31⟩ : Date).addDays 1 == ⟨2026, 1, 1⟩
#guard (⟨2025, 6, 15⟩ : Date).subDays 30 == ⟨2025, 5, 16⟩
#guard (⟨2025, 6, 15⟩ : Date).addDays 30 == ⟨2025, 7, 15⟩
#guard (⟨2025, 1, 1⟩ : Date).toDays - (⟨2024, 1, 1⟩ : Date).toDays == 366
#guard (⟨2025, 6, 5⟩ : Date).toIso == "2025-06-05"

#guard !(⟨2025, 2, 29⟩ : Date).valid
#guard (⟨2024, 2, 29⟩ : Date).valid
#guard !(⟨2025, 13, 1⟩ : Date).valid

-- The 61-day period: 30 days either side, both ends included.
#guard (⟨2025, 6, 15⟩ : Date).withinDaysAround ⟨2025, 7, 15⟩ 30
#guard !(⟨2025, 6, 15⟩ : Date).withinDaysAround ⟨2025, 7, 16⟩ 30
#guard (⟨2025, 6, 15⟩ : Date).withinDaysAround ⟨2025, 5, 16⟩ 30
#guard !(⟨2025, 6, 15⟩ : Date).withinDaysAround ⟨2025, 5, 15⟩ 30
#guard ((List.range 200).filter fun i =>
  (⟨2025, 6, 15⟩ : Date).withinDaysAround (Date.ofDays ((⟨2025, 3, 1⟩ : Date).toDays + i)) 30).length == 61

-- Money.
#guard formatCents 0 == "$0.00"
#guard formatCents 5 == "$0.05"
#guard formatCents 50999 == "$509.99"
#guard formatCents 100000 == "$1,000.00"
#guard formatCents 123456789 == "$1,234,567.89"
#guard formatCents 100000000 == "$1,000,000.00"

end Canteen.Tests.Date

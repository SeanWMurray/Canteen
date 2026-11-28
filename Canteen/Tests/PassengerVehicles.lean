import Canteen.ITA.S13.PassengerVehicles

/-!
# Tests: passenger vehicles (13(7)(g), (i), 67.2, 67.3; Reg. 7307)

In Ontario, 13% HST. Constructed examples.
-/

namespace Canteen.Tests.PassengerVehicles

open Canteen Canteen.ITA Canteen.ITA.PassengerVehicles

-- A $70,000 car bought in 2025: capital cost $38,000 plus HST, $42,940 (Class 10.1).
example : capitalCost 7000000 2025 1300 = 4294000 := by decide
-- A $30,000 car: its cost.
example : capitalCost 3000000 2025 1300 = 3000000 := by decide
-- A $90,000 electric car: $61,000 plus HST, $68,930.
example : capitalCost 9000000 2025 1300 true = 6893000 := by decide
-- Bought in 2022: $34,000 plus HST.
example : capitalCost 7000000 2022 1300 = 3842000 := by decide
-- Interest of $5,000 for a year (365 days) on a 2025 car loan: at most $350/30 a day, $4,258.33.
example : interest 500000 2025 365 = 425833 := by decide
-- On a car bought in 2023: $300/30 a day, $3,650.
example : interest 500000 2023 365 = 365000 := by decide

-- A lease entered into in 2025 at $1,500 a month plus HST ($20,340 for the year), list price $80,000, for
-- the whole first year (365 days).
def lease : Lease := { year := 2025, taxBp := 1300, charges := 2034000, daysToDate := 365, listPrice := 8000000 }
-- (c): $1,100 plus HST, $1,243 a month: $15,123.16 for 365 days.
example : lease.paraC = 1512316 := by decide
-- (d): $20,340 × $42,940 / (0.85 × $80,000): $12,844.11.
example : lease.paraD = 1284411 := by decide
example : lease.deductible = 1284411 := by decide
-- A cheaper car (list price $40,000): (d) uses 100/85 of $42,940 instead, and (c) binds.
example : ({ lease with listPrice := 4000000 } : Lease).deductible = 1512316 := by decide

end Canteen.Tests.PassengerVehicles

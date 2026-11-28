import Canteen.ITA.S13.CapitalCostAllowance

/-!
# Tests: capital cost allowance (Reg. 1100(1)(a), (2))

Constructed examples.
-/

namespace Canteen.Tests.CapitalCostAllowance

open Canteen Canteen.ITA Canteen.ITA.CapitalCostAllowance

-- A $10,000 computer (Class 50, 55%) bought in a year with nothing else: the half-year rule, 55% of
-- $5,000, $2,750.
example : ({ cls := "50", ucc := 1000000, additions := 1000000 } : ClassYear).maximum = 275000 := by decide
-- The next year: 55% of the $7,250 left, $3,987.50.
example : ({ cls := "50", ucc := 725000 } : ClassYear).maximum = 398750 := by decide
-- As accelerated investment incentive property available in 2023: 1.5 times, 55% of $15,000, $8,250.
example : ({ cls := "50", ucc := 1000000, aiip := 1000000, availableYear := 2023 } : ClassYear).maximum = 825000 := by decide
-- AIIP available in 2025: no half-year rule, no enhancement: 55% of $10,000, $5,500.
example : ({ cls := "50", ucc := 1000000, aiip := 1000000, availableYear := 2025 } : ClassYear).maximum = 550000 := by decide
-- A $40,000 car (Class 10, 30%) bought and an $8,000 one sold, UCC $76,000 before the claim: less half the
-- $32,000 net addition, 30% of $60,000, $18,000.
example : ({ cls := "10", ucc := 7600000, additions := 4000000, dispositions := 800000 } : ClassYear).maximum = 1800000 := by decide
-- A building (Class 1, 4%) with $500,000 of UCC: $20,000.
example : ({ cls := "1", ucc := 50000000 } : ClassYear).maximum = 2000000 := by decide
-- Claiming less leaves more UCC.
example : ({ cls := "1", ucc := 50000000 } : ClassYear).closing 1000000 = 49000000 := by decide
-- A class not listed: no rate.
example : rate "13" = none := by decide

end Canteen.Tests.CapitalCostAllowance

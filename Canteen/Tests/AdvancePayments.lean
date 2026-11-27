import Canteen.ITA.S20.AdvancePayments

/-!
# Tests: amounts received in advance (12(1)(a), (e); 20(1)(m))

Constructed examples.
-/

namespace Canteen.Tests.AdvancePayments

open Canteen Canteen.ITA Canteen.ITA.AdvancePayments

-- A gym sells $12,000 of annual memberships in October: $9,000 of the service remains at year end.
def memberships : Advance := { description := "annual memberships sold in October", kind := .services, amount := 1200000, reserve := 900000 }
def year1 : Facts := { advances := [memberships] }
example : inclusions year1 = 1200000 ∧ reserve year1 = 900000 ∧ net year1 = 300000 := by decide
-- The next year the reserve comes back: the $9,000 is earned then.
def year2 : Facts := { priorReserve := reserve year1 }
example : net year2 = 900000 := by decide
-- A reserve over the advance is capped at it.
example : reserve { advances := [{ memberships with reserve := 5000000 }] } = 1200000 := by decide
-- Bottle deposits: included, no reserve; deposits on kegs: a reserve.
example : reserve { advances := [{ description := "bottle deposits", kind := .bottles, amount := 50000, reserve := 50000 }] } = 0 := by decide
example : reserve { advances := [{ description := "keg deposits", kind := .containers, amount := 50000, reserve := 40000 }] } = 40000 := by decide
-- A deposit received last year, still undelivered: no new inclusion, but the reserve continues.
def lastYear : Facts := { advances := [{ description := "a deposit on a custom order", kind := .goods, amount := 300000, receivedThisYear := false, reserve := 300000 }], priorReserve := 300000 }
example : net lastYear = 0 := by decide

end Canteen.Tests.AdvancePayments

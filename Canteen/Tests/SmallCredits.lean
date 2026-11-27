import Canteen.ITA.S127_5.MinimumTax

/-!
# Tests: the adoption, home accessibility, home buyers' and volunteer credits (118.01 to 118.07)

Constructed examples.
-/

namespace Canteen.Tests.SmallCredits

open Canteen Canteen.ITA Canteen.ITA.SmallCredits

-- Adoption: $25,000 of expenses less $3,000 of assistance, capped at the limit ($15,000 by default).
example : adoptionAmount { adoption := some { expenses := 2500000, assistance := 300000 } } = 1500000 := by decide
example : adoptionAmount { adoption := some { expenses := 1200000, assistance := 300000 } } = 900000 := by decide
-- Two adoptive parents share it: each takes the share agreed, never more than the amount.
example : adoptionAmount { adoption := some { expenses := 2500000, share := some 700000 } } = 700000 := by decide
-- Home accessibility: up to $20,000.
example : accessibilityAmount { accessibility := 3000000 } = 2000000 ∧ accessibilityAmount { accessibility := 500000 } = 500000 := by decide
-- First home: $10,000, or a share of it.
example : homeBuyerAmount { homeBuyer := true } = 1000000 ∧ homeBuyerAmount { homeBuyer := true, homeBuyerShare := some 500000 } = 500000 := by
  decide
-- Volunteers: 200 hours of either kind, once.
example : volunteerAmount { firefighterHours := 150, searchRescueHours := 60 } = 600000 ∧ volunteerAmount { firefighterHours := 199 } = 0 := by
  decide
-- All of them: $10,000 + $6,000 = $16,000; $2,240.
example : credit { homeBuyer := true, firefighterHours := 250 } = 224000 := by decide

/-! ## In the individual's year -/

def buyer : IndividualYear.Facts :=
  { taxationYear := 2025, employmentAndBusiness := 8000000, claimsPersonal := true,
    smallCredits := { homeBuyer := true, adoption := some { expenses := 2500000 } } }

-- The 2025 adoption limit is $19,580: $19,580 + $10,000, at 14%, $4,141.20 less tax.
example : IndividualYear.smallCredits buyer = 414120 := by decide
example : IndividualYear.federalTax { buyer with smallCredits := {} } - IndividualYear.federalTax buyer = 414120 := by decide
-- 2026's limit is $19,972.
example : IndividualYear.smallCredits { buyer with taxationYear := 2026 } = 419608 := by decide
-- Half counts toward the basic minimum tax credit.
example : MinimumTax.basicCredit buyer - MinimumTax.basicCredit { buyer with smallCredits := {} } = 207060 := by decide

end Canteen.Tests.SmallCredits

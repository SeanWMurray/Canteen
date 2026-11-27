import Canteen.ITA.S127_5.MinimumTax

/-!
# Tests: support payments (56(1)(b), 56.1(4), 60(b))

Constructed examples.
-/

namespace Canteen.Tests.Support

open Canteen Canteen.ITA Canteen.ITA.Support

def spousal : Facts := { paidSince1997 := 1800000 }

-- Spousal support only, from an order after April 1997: all of it.
example : amount spousal = 1800000 := by decide
-- Child support payable comes off first.
example : amount { spousal with childSupportPayable := 600000 } = 1200000 := by decide
-- Amounts deducted in earlier years come off too: the formula is cumulative.
example : amount { paidSince1997 := 3600000, deductedBefore := 1800000 } = 1800000 := by decide
-- An order made before May 1997 with no commencement day: no child support amount counts, all is deductible.
example : amount { paidSince1997 := 1200000, childSupportPayable := 0 } = 1200000 := by decide
-- Not periodic (judged), no discretion, or no order or written agreement: nothing.
def lump : Facts := { spousal with periodicAllowance := .judged "J-PER" false }
example : amount lump = 0 ∧ (explain lump).reliesOn = ["J-PER"] := by decide
example : amount { spousal with recipientDiscretion := .fact false } = 0 := by decide
example : amount { spousal with spouseApartUnderOrderOrAgreement := false } = 0 := by decide
-- A legal parent under a provincial order, not married: (b).
example : amount { spousal with spouseApartUnderOrderOrAgreement := false, parentUnderProvincialOrder := true } = 1800000 := by decide

/-! ## In the individual's year -/

def payer : IndividualYear.Facts := { taxationYear := 2025, employmentAndBusiness := 9000000, claimsPersonal := true, supportPaid := [spousal] }
def recipient : IndividualYear.Facts := { taxationYear := 2025, claimsPersonal := true, supportReceived := [spousal] }

-- Deducted by one, included by the other.
example : IndividualYear.income payer = 2 * (9000000 - 1800000) ∧ IndividualYear.income recipient = 2 * 1800000 := by decide
-- The minimum tax counts both.
example : MinimumTax.adjustedTaxableIncome payer = 2 * 7200000 ∧ MinimumTax.adjustedTaxableIncome recipient = 2 * 1800000 := by decide
-- A judged support amount carries into the year's explanation.
example : (IndividualYear.explain { payer with supportPaid := [lump] }).reliesOn = ["J-PER"] := by decide

end Canteen.Tests.Support

import Canteen.ITA.S100.PartnershipInterestSale

/-!
# Tests: selling a partnership interest to a tax-exempt or non-resident person (100(1))

A $1,000,000 gain on an interest in a partnership owning land ($600,000 of the gain) and equipment and
inventory (the rest). Constructed examples.
-/

namespace Canteen.Tests.PartnershipInterestSale

open Canteen Canteen.ITA Canteen.ITA.PartnershipInterestSale

def sale : Facts := { gain := 100000000, attributableToCapitalProperty := 60000000, exemptOrNonResidentAcquirer := true }
-- To a pension fund: half of $600,000 and all of $400,000: $700,000.
example : taxableGain sale = 70000000 := by decide
-- To a taxable Canadian buyer: half, $500,000.
example : taxableGain { sale with exemptOrNonResidentAcquirer := false } = 50000000 := by decide
-- To a non-resident, within the 100(1.2) exception: half.
example : taxableGain { sale with exception := true } = 50000000 := by decide
-- A partnership holding only land: half either way.
example : taxableGain { sale with attributableToCapitalProperty := 100000000 } = 50000000 := by decide

end Canteen.Tests.PartnershipInterestSale

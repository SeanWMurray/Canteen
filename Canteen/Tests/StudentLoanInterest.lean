import Canteen.ITA.S118_62.StudentLoanInterest
import Canteen.ITA.S3.IndividualYear

/-!
# Tests: the student loan interest credit (118.62)

Constructed examples.
-/

namespace Canteen.Tests.StudentLoanInterest

open Canteen Canteen.ITA Canteen.ITA.StudentLoanInterest

-- $600 of interest in 2025: a credit of $84.
def y2025 : Facts := { taxationYear := 2025, payments := [⟨2025, 60000, false⟩] }
example : credit y2025 = 8400 := by decide
-- Interest from 2020 not yet claimed is available in 2025; from 2019 it is not.
example : availableTotal { taxationYear := 2025, payments := [⟨2020, 50000, false⟩, ⟨2019, 50000, false⟩] } = 50000 := by decide
-- Interest paid under a judgment does not count.
example : availableTotal { taxationYear := 2025, payments := [⟨2025, 50000, true⟩] } = 0 := by decide
-- Claiming $200 of $600: $400 carries forward.
example : carriedForward { y2025 with claim := some 20000 } = 40000 := by decide

-- In an individual's year: a graduate with $40,000 of salary and $600 of interest.
def graduate : IndividualYear.Facts := { taxationYear := 2025, employmentAndBusiness := 4000000, claimsPersonal := true, studentLoanInterest := [⟨2025, 60000, false⟩] }
example : IndividualYear.studentLoanCredit graduate = 8400 := by decide
example : IndividualYear.federalTax { graduate with studentLoanInterest := [] } - IndividualYear.federalTax graduate = 8400 := by decide
-- With no tax to reduce, nothing is claimed, so it all carries forward.
def student : IndividualYear.Facts := { taxationYear := 2025, employmentAndBusiness := 1000000, claimsPersonal := true, studentLoanInterest := [⟨2025, 60000, false⟩] }
example : IndividualYear.studentLoanCredit student = 0 := by decide

end Canteen.Tests.StudentLoanInterest

import Canteen.ITA.S118_3.Disability
import Canteen.ITA.S127_5.MinimumTax

/-!
# Tests: the disability tax credit (118.3(1))

2025 amounts: $10,138, a $5,914 supplement for minors, and a $3,464 care threshold. Constructed examples.
-/

namespace Canteen.Tests.Disability

open Canteen Canteen.ITA Canteen.ITA.Disability

def adult : Facts := { impairment := .fact true }

-- An adult: 14% of $10,138, $1,419.32.
example : amount adult = 1013800 ∧ credit adult = 141932 := by decide
-- A minor with no care expenses: $16,052, so $2,247.28.
example : credit { adult with minor := true } = 224728 := by decide
-- A minor with $5,000 of child care: the supplement falls by $1,536 to $4,378.
example : supplement { adult with minor := true, careExpenses := 500000 } = 437800 := by decide
-- Care expenses over $9,378 use up the supplement.
example : supplement { adult with minor := true, careExpenses := 1000000 } = 0 := by decide
-- No certificate, not filed, or attendant care claimed under 118.2: nothing.
example : credit { adult with certified := false } = 0 ∧ credit { adult with filed := false } = 0 ∧
    credit { adult with attendantCareClaimed := true } = 0 := by decide
-- The impairment judged not severe and prolonged: nothing, and the explanation rests on the call.
def judged : Facts := { impairment := .judged "J-DTC" false }
example : credit judged = 0 ∧ (explain judged).reliesOn = ["J-DTC"] := by decide

/-! ## In the individual's year -/

def year : IndividualYear.Facts :=
  { taxationYear := 2025, employmentAndBusiness := 5000000, personalAmounts := some {}, disability := some adult }

example : IndividualYear.federalTax { year with disability := none } - IndividualYear.federalTax year = 141932 := by decide
-- Half counts toward the basic minimum tax credit.
example : MinimumTax.basicCredit year - MinimumTax.basicCredit { year with disability := none } = 70966 := by decide
-- A judged impairment carries into the year's explanation.
example : (IndividualYear.explain { year with disability := some judged }).reliesOn = ["J-DTC"] := by decide


/-! ## The transfer (118.3(2)) -/

namespace Transfer

/-- An adult child with the credit and $8,000 of income: no tax to use it against. -/
def child (earnings : Cents) : IndividualYear.Facts :=
  { taxationYear := 2025, employmentAndBusiness := earnings, personalAmounts := some {}, disability := some adult }

example : IndividualYear.taxBeforeCredits (child 800000) = 0 ∧ IndividualYear.disabilityTransferFrom {} (child 800000) = 141932 := by decide
-- With $20,000: $2,800 of tax less the $2,100 personal credit leaves $700; $719.32 transfers.
example : IndividualYear.taxBeforeCredits (child 2000000) = 70000 ∧ IndividualYear.disabilityTransferFrom {} (child 2000000) = 71932 := by decide
-- Not a supporter, a non-resident, a spouse claiming, or attendant care claimed: nothing.
example : IndividualYear.disabilityTransferFrom { supports := false } (child 800000) = 0 ∧
    IndividualYear.disabilityTransferFrom { resident := false } (child 800000) = 0 ∧
    IndividualYear.disabilityTransferFrom { spouseClaims := true } (child 800000) = 0 ∧
    IndividualYear.disabilityTransferFrom {} { child 800000 with disability := some { adult with attendantCareClaimed := true } } = 0 := by decide
-- No credit, nothing to transfer.
example : IndividualYear.disabilityTransferFrom {} { child 800000 with disability := none } = 0 := by decide

/-- The parent, with the transfer. -/
def parent : IndividualYear.Facts :=
  { taxationYear := 2025, employmentAndBusiness := 12000000, personalAmounts := some {},
    disabilityTransferred := IndividualYear.disabilityTransferFrom {} (child 800000) }
example : IndividualYear.federalTax { parent with disabilityTransferred := 0 } - IndividualYear.federalTax parent = 141932 := by decide

end Transfer

end Canteen.Tests.Disability

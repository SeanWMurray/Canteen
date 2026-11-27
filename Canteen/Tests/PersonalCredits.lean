import Canteen.ITA.S118.PersonalCredits
import Canteen.ITA.S3.IndividualYear

/-!
# Tests: the basic personal and spouse amounts (118(1), (1.1))

The amounts in the text (unindexed): $12,298 base, $15,000 enhanced. Constructed examples.
-/

namespace Canteen.Tests.PersonalCredits

open Canteen Canteen.ITA Canteen.ITA.PersonalCredits

-- Income of $50,000: the whole $15,000, a $2,100 credit.
example : basicPersonalAmount { income := 5000000 } = 1500000 ∧ credit { income := 5000000 } = 210000 := by decide
-- Income of $210,000, part way through the phase-out: $1,553.04 of the $2,702 enhancement.
example : enhancementAllowed { income := 21000000 } = 155304 ∧ credit { income := 21000000 } = 193914 := by decide
-- Above the 117(2)(e) threshold: the base only.
example : basicPersonalAmount { income := 30000000 } = 1229800 := by decide
-- Supporting a spouse with $5,000 of income: $15,000 + $10,000, a $3,500 credit.
example : credit { income := 5000000, supportsSpouse := true, spouseIncome := 500000 } = 350000 := by decide
-- An infirm spouse adds $2,150.
example : amountB { income := 5000000, supportsSpouse := true, spouseIncome := 500000, spouseInfirm := true } = 2715000 := by decide
-- A spouse earning more than the basic personal amount adds nothing.
example : amountB { income := 5000000, supportsSpouse := true, spouseIncome := 3000000 } = 1500000 := by decide

end Canteen.Tests.PersonalCredits

/-! ## The eligible dependant amount (118(1)(b)) -/

namespace Canteen.Tests.PersonalCredits.EligibleDependant

open Canteen Canteen.ITA Canteen.ITA.PersonalCredits

def child : Dependant := {}

-- A single parent with $50,000 and a child with no income: $15,000 + $15,000 = $30,000, credit $4,200.
example : amountB { income := 5000000, dependant := some child } = 3000000 ∧ credit { income := 5000000, dependant := some child } = 420000 := by
  decide
-- The dependant's income reduces it; an infirm adult child adds $2,150.
example : amountB { income := 5000000, dependant := some { child with income := 400000 } } = 2600000 := by decide
example : amountB { income := 5000000, dependant := some { child with infirm := true } } = 3215000 := by decide
-- Each condition matters.
example : amountB { income := 5000000, dependant := some { child with single := false } } = 1500000 ∧
    amountB { income := 5000000, dependant := some { child with maintainsHome := false } } = 1500000 ∧
    amountB { income := 5000000, dependant := some { child with related := false } } = 1500000 ∧
    amountB { income := 5000000, dependant := some { child with whollyDependent := false } } = 1500000 ∧
    amountB { income := 5000000, dependant := some { child with minorInfirmOrParent := false } } = 1500000 ∧
    amountB { income := 5000000, dependant := some { child with residentOrChild := false } } = 1500000 := by decide
-- A spouse claim takes precedence.
example : dependantClaim { income := 5000000, supportsSpouse := true, dependant := some child } = false := by decide
-- The explanation says why it fails.
example : (eligibleDependant.explain { child with related := false }).conclusion = false := by decide

-- In the individual's year: $2,100 less federal tax.
def parent : IndividualYear.Facts :=
  { taxationYear := 2025, employmentAndBusiness := 5000000, personalAmounts := some {}, eligibleDependant := some child }
example : IndividualYear.federalTax { parent with eligibleDependant := none } - IndividualYear.federalTax parent = 210000 := by decide

end Canteen.Tests.PersonalCredits.EligibleDependant

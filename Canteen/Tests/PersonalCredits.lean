import Canteen.ITA.S118.PersonalCredits

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

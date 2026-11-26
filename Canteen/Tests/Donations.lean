import Canteen.ITA.S118_1.Donations

/-!
# Tests: the charitable donation credit (118.1)

Constructed examples (2025 brackets).
-/

namespace Canteen.Tests.Donations

open Canteen Canteen.ITA Canteen.ITA.Donations

-- $1,000 of gifts on $60,000 of income: 14% of $200 and 29% of $800, $260.
example : credit { charitableGifts := 100000, income := 6000000, amountTaxable := 6000000 } = 26000 := by decide
-- $50,000 of gifts on $300,000 of taxable income: $46,586 of it at 33%, the rest at 29%.
example : credit { charitableGifts := 5000000, income := 30000000, amountTaxable := 30000000 } = 1633344 := by decide
-- $100,000 of gifts on $100,000 of income: only 75% counts this year; $25,000 is carried forward.
def big : Facts := { charitableGifts := 10000000, income := 10000000, amountTaxable := 10000000 }
example : totalGifts big = 7500000 ∧ carriedForward big = 2500000 := by decide
-- A gift of other capital property with a $20,000 taxable capital gain raises the limit by $5,000.
example : totalGifts { big with giftGains := 2000000 } = 8000000 := by decide
-- In the year of death, up to all of the income.
example : totalGifts { big with deathYear := true } = 10000000 := by decide

end Canteen.Tests.Donations

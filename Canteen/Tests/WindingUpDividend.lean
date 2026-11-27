import Canteen.ITA.S84.WindingUpDividend

/-!
# Tests: a distribution on winding-up (84(2))

Opco is wound up and distributes $500,000; its shares' paid-up capital is $100. Constructed examples.
-/

namespace Canteen.Tests.WindingUpDividend

open Canteen Canteen.ITA Canteen.ITA.WindingUpDividend

def windUp : Facts :=
  { description := "the common shares of Opco", distributed := 50000000, pucReduction := 10000, sharesHeld := 100, sharesOutstanding := 100,
    adjustedCostBase := 10000 }

-- A $499,900 dividend; the shareholder's proceeds are the $100 of paid-up capital, so no gain.
example : dividendPaid windUp = 49990000 ∧ proceeds windUp = 10000 ∧ (disposition windUp).gain = 0 := by decide
-- With a $300,000 adjusted cost base (bought from a founder), the same dividend and a $299,900 capital loss.
example : (disposition { windUp with adjustedCostBase := 30000000 }).loss = 29990000 := by decide
-- A holder of 40 of the 100 shares: 40% of each.
example : dividend { windUp with sharesHeld := 40 } = 19996000 ∧ proceeds { windUp with sharesHeld := 40 } = 4000 := by decide
-- Not on a winding-up (judged): no dividend under 84(2), and the explanation rests on the call.
def notWindUp : Facts := { windUp with onWindingUp := .judged "J-WU" false }
example : dividendPaid notWindUp = 0 ∧ (explain notWindUp).reliesOn = ["J-WU"] := by decide
-- A non-resident corporation: not 84(2).
example : dividendPaid { windUp with corporationResident := false } = 0 := by decide
-- For an individual, a taxable dividend grossed up 15%.
example : Dividends.inclusion { taxationYear := 2025, dividends := [asDividend windUp] } = 57488500 := by decide

end Canteen.Tests.WindingUpDividend

import Canteen.ITA.S84.ReturnOfCapital

/-!
# Tests: returns of capital (84(4), (4.1), 53(2)(a)(ii), 40(3), 53(1)(a))

Opco reduces the paid-up capital of its common shares by $100,000 and pays it out. Constructed
examples.
-/

namespace Canteen.Tests.ReturnOfCapital

open Canteen Canteen.ITA Canteen.ITA.ReturnOfCapital

def roc : Facts :=
  { description := "the common shares of Opco", amountPaid := 10000000, pucReduction := 10000000, sharesHeld := 100,
    sharesOutstanding := 100, costAndAdditions := 15000000 }

-- No dividend; the $100,000 reduces the $150,000 cost to $50,000.
example : dividend roc = 0 ∧ returnOfCapital roc = 10000000 ∧ adjustedCostBase roc = 5000000 ∧ deemedGain roc = 0 := by decide
-- Paying $120,000 on a $100,000 reduction: a $20,000 dividend.
example : dividend { roc with amountPaid := 12000000 } = 2000000 ∧ returnOfCapital { roc with amountPaid := 12000000 } = 10000000 := by
  decide
-- A $60,000 cost: the adjusted cost base would be −$40,000, so $40,000 is a gain, and the ACB is nil.
def deep : Facts := { roc with costAndAdditions := 6000000 }
example : deemedGain deep = 4000000 ∧ adjustedCostBase deep = 0 ∧ (disposition deep).gain = 4000000 := by decide
-- After an earlier return of capital of $30,000, the same $60,000 cost leaves a $70,000 gain.
example : deemedGain { deep with priorDeductions := 3000000 } = 7000000 := by decide
-- A holder of 30 of the 100 shares.
example : returnOfCapital { roc with sharesHeld := 30 } = 3000000 := by decide
-- A public corporation: all of it is a dividend (84(4.1)), and the cost is untouched.
example : dividend { roc with publicCorporation := true } = 10000000 ∧ adjustedCostBase { roc with publicCorporation := true } = 15000000 := by
  decide
-- Unless it distributes proceeds of an extraordinary disposition in the last 24 months.
example : dividend { roc with publicCorporation := true, fromExtraordinaryProceeds := true } = 0 := by decide

/-! ## Read-back -/

#guard (explain deep).render.splitOn "\n" ==
  ["1. The holder receives $100,000.00 on the reduction of paid-up capital of the common shares of Opco. [ITA 84(4)]",
   "2. The amount paid exceeds the paid-up capital reduced by $0.00, so the holder's dividend is $0.00. [ITA 84(4)(a), (b)]",
   "3. The rest, $100,000.00, reduces the adjusted cost base. [ITA 53(2)(a)(ii)]",
   "4. That takes the adjusted cost base below nil by $40,000.00, a gain from a disposition of the shares, which is added back to bring the adjusted cost base to nil. [ITA 40(3); 53(1)(a)]"]

end Canteen.Tests.ReturnOfCapital

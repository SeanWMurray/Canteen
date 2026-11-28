import Canteen.ITA.S146_6.FirstHomeSavings

/-!
# Tests: the FHSA deduction (146.6(1), (5))

Constructed examples.
-/

namespace Canteen.Tests.FirstHomeSavings

open Canteen Canteen.ITA Canteen.ITA.FirstHomeSavings

-- $8,000 a year for five years: $8,000 limits and deductions, $40,000 in all; a sixth year, nothing more.
def steady : List Year := List.replicate 6 ⟨800000, none⟩
example : limits steady = List.replicate 6 800000 := by decide
example : deductions steady = List.replicate 5 800000 ++ [0] := by decide
-- Nothing the first year, $16,000 the second: the $8,000 of unused room carries forward.
example : limits [⟨0, none⟩, ⟨1600000, none⟩] = [0, 1600000] := by decide
-- $20,000 the first year: the limit is $8,000; the other $12,000 counts in the next year's (a), with no
-- carryforward of room.
example : limits [⟨2000000, none⟩, ⟨0, none⟩] = [800000, 800000] := by decide
-- Room carries forward only $8,000: two empty years then $24,000 gives $16,000.
example : limits [⟨0, none⟩, ⟨0, none⟩, ⟨2400000, none⟩] = [0, 0, 1600000] := by decide
-- Deferring the deduction: contribute $8,000, deduct nothing; deduct both years' $16,000 the next year.
example : deductions [⟨800000, some 0⟩, ⟨800000, none⟩] = [0, 1600000] := by decide

end Canteen.Tests.FirstHomeSavings

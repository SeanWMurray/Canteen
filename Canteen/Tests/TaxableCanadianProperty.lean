import Canteen.ITA.S248.TaxableCanadianProperty

/-!
# Tests: 248(1) "taxable Canadian property"

Constructed examples.
-/

namespace Canteen.Tests.TaxableCanadianProperty

open Canteen Canteen.ITA Canteen.ITA.TaxableCanadianProperty

-- A cottage in Muskoka; a villa in Portugal.
example : (Property.realProperty true).isTCP = true ∧ (Property.realProperty false).isTCP = false := by decide
-- Equipment of a business carried on in Canada; of an insurance business.
example : (Property.businessProperty true).isTCP = true ∧ (Property.businessProperty true true).isTCP = false := by decide
-- Shares of Landco, a private company: 70% of value from Ontario land two years ago, 40% now: still
-- taxable Canadian property (the 60-month look-back).
def landco : List Snapshot := List.replicate 24 ⟨70, 0⟩ ++ List.replicate 36 ⟨40, 0⟩
example : (Property.unlisted landco).isTCP = true := by decide
-- After 60 months at 40%: no longer.
example : (Property.unlisted (List.replicate 60 ⟨40, 0⟩)).isTCP = false := by decide
-- Exactly 50% is not more than 50%.
example : (Property.unlisted (List.replicate 60 ⟨50, 0⟩)).isTCP = false := by decide
-- Shares of a listed real estate company (80% from Canadian real property): 10% held, no; 30% held, yes.
example : (Property.listed (List.replicate 60 ⟨80, 10⟩)).isTCP = false := by decide
example : (Property.listed (List.replicate 60 ⟨80, 30⟩)).isTCP = true := by decide
-- The two tests must be met at the same time: 30% held while the value test failed, and 80% while held 10%.
example : (Property.listed (List.replicate 30 ⟨40, 30⟩ ++ List.replicate 30 ⟨80, 10⟩)).isTCP = false := by decide
-- An option to buy the cottage; an income interest in a resident trust.
example : (Property.option (.realProperty true)).isTCP = true ∧ Property.incomeInterest.isTCP = false := by decide

end Canteen.Tests.TaxableCanadianProperty

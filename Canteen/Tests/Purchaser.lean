import Canteen.ITA.S116.Purchaser

/-!
# Tests: the purchaser's liability under section 116

A purchaser buys from a vendor living in the United Kingdom. Constructed examples.
-/

namespace Canteen.Tests.Purchaser

open Canteen Canteen.ITA Canteen.ITA.Purchaser

-- Shares of a private company whose value is mostly Canadian real estate, for $1,000,000, no certificate: 25%.
def shares : Purchase := { description := "shares of Landco", kind := .capital, cost := 100000000 }
example : shares.liability = 25000000 := by decide
-- With a 116(2) certificate limit of $1,000,000: nothing; with $600,000: 25% of $400,000.
example : ({ shares with certificateLimit := some 100000000 } : Purchase).liability = 0 := by decide
example : ({ shares with certificateLimit := some 60000000 } : Purchase).liability = 10000000 := by decide
-- A rental building (depreciable property, 116(5.2)), $2,000,000: 50%.
def building : Purchase := { description := "the rental building", kind := .listed, cost := 200000000 }
example : building.liability = 100000000 := by decide
-- A 116(4) certificate does not cover 116(5.2) property: still 50%.
example : ({ building with section116_4 := true } : Purchase).liability = 100000000 := by decide
-- Treaty-protected property with the notice given, or no reason to believe the vendor non-resident: none.
example : ({ shares with treatyProtected := true } : Purchase).liability = 0 := by decide
example : ({ shares with noReasonToBelieve := .judged "J-INQ" true } : Purchase).liability = 0 := by decide
example : (explain { shares with noReasonToBelieve := .judged "J-INQ" true }).reliesOn = ["J-INQ"] := by decide
-- Listed shares of a public company (excluded property): none.
example : ({ shares with kind := .excluded } : Purchase).liability = 0 := by decide

-- With the property given: Landco's shares drew 70% of their value from Ontario land within 60 months.
def landcoShares : Purchase := { shares with property := some (.unlisted (List.replicate 60 ⟨70, 0⟩)) }
example : landcoShares.liability = 25000000 := by decide
-- Shares of a software company with no Canadian real property: not taxable Canadian property.
example : ({ shares with property := some (.unlisted (List.replicate 60 ⟨5, 0⟩)) } : Purchase).liability = 0 := by decide

end Canteen.Tests.Purchaser

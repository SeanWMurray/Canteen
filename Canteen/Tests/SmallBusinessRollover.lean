import Canteen.ITA.S44_1.SmallBusinessRollover

/-!
# Tests: the small business investment rollover (44.1)

Shares bought on 2020-01-15 for $200,000 and sold on 2025-06-30 for $1,000,000: an $800,000 gain.
Constructed examples.
-/

namespace Canteen.Tests.SmallBusinessRollover

open Canteen Canteen.ITA Canteen.ITA.SmallBusinessRollover

def sale : Facts :=
  { acquired := ⟨2020, 1, 15⟩, disposed := ⟨2025, 6, 30⟩, proceeds := 100000000, capitalGain := 80000000,
    replacements := [{ description := "Newco common shares", cost := 60000000, acquiredIn := 2025 }] }

-- $600,000 reinvested: 60% of the gain, $480,000, is deferred; $320,000 is taxed now.
example : permittedDeferral sale = 48000000 ∧ capitalGainAfter sale = 32000000 := by decide
-- The replacement shares' cost of $600,000 is reduced by $480,000.
example : acbReduction sale (sale.replacements.head!) = 48000000 := by decide
-- Two replacements, $400,000 in 2025 and $200,000 in 2026: the reduction is shared $320,000 and $160,000.
def two : Facts := { sale with replacements := [{ description := "A", cost := 40000000, acquiredIn := 2025 }, { description := "B", cost := 20000000, acquiredIn := 2026 }] }
example : permittedDeferral two = 48000000 ∧ two.replacements.map (acbReduction two) = [32000000, 16000000] := by decide
-- Bought in 2027: too late, not a replacement share.
example : permittedDeferral { sale with replacements := [{ description := "late", cost := 60000000, acquiredIn := 2027 }] } = 0 := by decide
-- Not designated: not a replacement share.
example : permittedDeferral { sale with replacements := [{ description := "Newco", cost := 60000000, acquiredIn := 2025, designated := false }] } = 0 := by
  decide
-- All the proceeds reinvested: all the gain deferred.
example : permittedDeferral { sale with replacements := [{ description := "Newco", cost := 120000000, acquiredIn := 2026 }] } = 80000000 := by decide
-- Held fewer than 185 days: not a qualifying disposition.
example : permittedDeferral { sale with acquired := ⟨2025, 2, 1⟩ } = 0 := by decide
-- Not an active business corporation throughout (judged): nothing deferred, and the explanation rests on the call.
def notActive : Facts := { sale with activeThroughout := .judged "J-ABC" false }
example : permittedDeferral notActive = 0 ∧ (explain notActive).reliesOn = ["J-ABC"] := by decide

end Canteen.Tests.SmallBusinessRollover

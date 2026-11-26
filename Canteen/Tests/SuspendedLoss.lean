import Canteen.ITA.S40.SuspendedLoss

/-!
# Tests: subsections 40(3.3) to (3.5)

A corporation sells 100 shares at a $500.00 loss on 2025-06-15; one fact changes at a time.
Constructed examples.
-/

namespace Canteen.Tests.SuspendedLoss

open Canteen Canteen.ITA Canteen.ITA.SuspendedLoss

def sale : SuperficialLoss.Disposition :=
  { description := "100 shares", date := ⟨2025, 6, 15⟩, proceeds := 100000, adjustedCostBase := 150000,
    outlaysAndExpenses := 0 }

def buy (date : Date := ⟨2025, 6, 20⟩) (who : SuperficialLoss.Acquirer := .affiliated "Sisterco")
    (identity : Identity := .same) (owned : Bool := true) : Acquisition :=
  { description := "100 shares", date, acquirer := who, identity, ownedAtEndOfPeriod := owned }

def base : Facts := { transferor := .corporation, disposition := sale, acquisitions := [buy] }

def s? (f : Facts) : Bool := suspended f

example : s? base = true := by decide
example : s? { base with transferor := .trust } = true := by decide
example : s? { base with transferor := .partnership } = true := by decide
example : s? { base with transferor := .individual } = false := by decide         -- individuals: not (3.3)
example : s? { base with prescribedDepreciable := true } = false := by decide
example : s? { base with capitalProperty := false } = false := by decide
example : s? { base with surplusExcludedProperty := true } = false := by decide
example : s? { base with disposition := { sale with deemedBy := some .s128_1 } } = false := by decide   -- 54 SL (c)
example : s? { base with disposition := { sale with optionExpiry := true } } = false := by decide       -- 54 SL (d)
example : s? { base with disposition := { sale with proceeds := 200000 } } = false := by decide          -- no loss
-- (b): the period, and the acquirer.
example : s? { base with acquisitions := [buy ⟨2025, 7, 15⟩] } = true := by decide
example : s? { base with acquisitions := [buy ⟨2025, 7, 16⟩] } = false := by decide
example : s? { base with acquisitions := [buy (who := .notAffiliated "a stranger")] } = false := by decide
example : s? { base with acquisitions := [buy (who := .taxpayer)] } = true := by decide              -- the transferor itself
-- (c): owned at the end of the period ("owns", not "had a right to acquire").
example : s? { base with acquisitions := [buy (owned := false)] } = false := by decide
-- (3.5): what counts as identical.
example : s? { base with acquisitions := [buy (identity := .rightToAcquire false)] } = true := by decide
example : s? { base with acquisitions := [buy (identity := .rightToAcquire true)] } = false := by decide
example : s? { base with acquisitions := [buy (identity := .shareExchange)] } = true := by decide
example : s? { base with acquisitions := [buy (identity := .shareExchange85_1 true)] } = true := by decide
example : s? { base with acquisitions := [buy (identity := .shareExchange85_1 false)] } = false := by decide
example : s? { base with acquisitions := [buy (identity := .identical "J-ID" false)] } = false := by decide
#guard (rule.explain { base with acquisitions := [buy (identity := .identical "J-ID" true)] }).reliesOn == ["J-ID"]

/-! ## 40(3.4)(b): the release -/

example : releaseDate base = none := by decide
-- The first of the times in (i) to (v).
def twoEvents : ReleaseEvents := { thirtyDaysWithout := some ⟨2026, 3, 1⟩, lossRestrictionEvent := some ⟨2026, 1, 10⟩ }
example : releaseDate { base with release := twoEvents } = some ⟨2026, 1, 10⟩ := by decide
-- (v) applies only to a corporation.
example : releaseDate { base with transferor := .trust, release := { windingUp := some ⟨2026, 1, 10⟩ } } = none := by decide
example : releaseDate { base with release := { windingUp := some ⟨2026, 1, 10⟩ } } = some ⟨2026, 1, 10⟩ := by decide
-- A time before the disposition is not "after the disposition".
example : releaseDate { base with release := { section50 := some ⟨2025, 1, 1⟩ } } = none := by decide

#guard (rule.explain { base with release := { thirtyDaysWithout := some ⟨2026, 3, 1⟩ } }).steps.getLast?.map (·.claim) ==
  some ("The $500.00 loss is deemed to be a loss of the transferor from a disposition of the property immediately before " ++
    "2026-03-01, when a 30-day period begins throughout which neither the transferor nor a person affiliated with it owns " ++
    "the substituted property (40(3.4)(b)(i)).")

end Canteen.Tests.SuspendedLoss

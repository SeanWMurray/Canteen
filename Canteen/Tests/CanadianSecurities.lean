import Canteen.ITA.S39.CanadianSecurities
import Canteen.ITA.S3.Income

/-!
# Tests: the election for Canadian securities (39(4) to (6))

An individual who trades often in shares of Canadian public companies, so whether the gains are
on capital account is a judgment call (`J-CAPITAL`). Constructed examples.
-/

namespace Canteen.Tests.CanadianSecurities

open Canteen Canteen.ITA Canteen.ITA.CanadianSecurities

def trader : Taxpayer := { electedFrom := some 2023 }
def q (y : Nat) (t : Taxpayer := trader) (k : SecurityKind := .shareOfResidentCorporation) : Query := { taxpayer := t, kind := k, year := y }

def sale : CapitalGains.Disposition :=
  { description := "shares of XYZ Ltd.", proceeds := 1500000, adjustedCostBase := 1000000, capitalAccount := .judged "J-CAPITAL" true }

-- Elected in 2023: in 2025 the gain is on capital account as a fact, so no judgment call.
example : deemedCapital.holds (q 2025) = true ∧ (withElection (q 2025) sale).capitalAccount = .fact true := by decide
-- Before the election year, the judgment call stands.
example : (withElection (q 2022) sale).capitalAccount = .judged "J-CAPITAL" true := by decide
-- Shares of a foreign corporation are not Canadian securities.
example : deemedCapital.holds (q 2025 (k := .other)) = false := by decide
-- Units of a mutual fund trust and Canadian bonds are.
example : deemedCapital.holds (q 2025 (k := .mutualFundTrustUnit)) = true ∧ deemedCapital.holds (q 2025 (k := .debtOfResident)) = true := by
  decide
-- 39(5): not for a trader or dealer (often a judgment call), a financial institution, or a non-resident.
example : deemedCapital.holds (q 2025 { trader with traderOrDealer := .judged "J-TRADER" true }) = false := by decide
#guard (deemedCapital.explain (q 2025 { trader with traderOrDealer := .judged "J-TRADER" false })).reliesOn == ["J-TRADER"]
example : deemedCapital.holds (q 2025 { trader with nonResident := true }) = false := by decide
-- A mutual fund trust is outside 39(5).
example : deemedCapital.holds (q 2025 { trader with nonResident := true, mutualFund := true }) = true := by decide
-- Into the year: the taxable capital gain is $2,500, resting on no judgment call.
example : Income.paraB { capital := ⟨[withElection (q 2025) sale], 0, {}⟩ } = 2 * 250000 := by decide
#guard (Income.report { capital := ⟨[withElection (q 2025) sale], 0, {}⟩ }).reliesOn == []
#guard (Income.report { capital := ⟨[sale], 0, {}⟩ }).reliesOn == ["J-CAPITAL"]

end Canteen.Tests.CanadianSecurities

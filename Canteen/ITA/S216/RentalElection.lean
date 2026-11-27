import Canteen.ITA.S117_1.YearAmounts

/-!
# A non-resident's rent from Canadian real property: Part XIII (212(1)(d)) or the 216(1) election

*Income Tax Act*, as consolidated to 2026-10-29 (verbatim in `statute/ITA-216-1-212-1-d-120-1-118.94.txt`):

**212(1)(d)** A non-resident pays 25% of rent for the use of property in Canada, on the gross amount.
**216(1)** A non-resident paid rent on real property in Canada may file a Part I return for the year
(within two years, or six months with a 216(4) undertaking) and pay Part I tax, in lieu of Part XIII
tax on the rent, as though resident, on the net income from the property. **120(1)** An individual adds
48% of the tax otherwise payable, in the proportion of income not earned in a province. **118.94** A
non-resident's personal credits (118 to 118.07, 118.2, 118.8, 118.9) do not apply unless all or
substantially all of the individual's income is taxable income earned in Canada.

For an individual. The net income (rent less expenses and capital cost allowance) is given, and is all
not earned in a province, so the 120(1) proportion is 1. The federal rates are the year's (`YearAmounts`).
Credits other than those 118.94 removes (such as 118.1 donations) are not encoded. A corporation's 216
election, which also brings in branch tax (219), is not encoded; neither are 216(4) and (5).
-/

namespace Canteen.ITA.RentalElection

structure Facts where
  taxationYear : Nat
  grossRent : Cents
  /-- The net income from the property: rent less expenses and capital cost allowance. -/
  netIncome : Cents
  /-- 212(1)(d): the Part XIII rate (25, or a treaty rate; treaties rarely reduce it for real property rent). -/
  partXIIIRate : Nat := 25
  /-- 118.94: all or substantially all the individual's income is taxable income earned in Canada. -/
  substantiallyAllInCanada : Bool := false
  /-- The personal credits otherwise available (118 to 118.07, 118.2, 118.8, 118.9). -/
  personalCredits : Cents := 0
  deriving Repr, DecidableEq, Inhabited

def brackets (f : Facts) : Rates.Brackets := ((YearAmounts.forYear f.taxationYear).getD YearAmounts.latest.2).brackets

/-- 212(1)(d): Part XIII tax on the gross rent. -/
def partXIII (f : Facts) : Cents := f.grossRent * min 25 f.partXIIIRate / 100

/-- 118.94: the credits allowed. -/
def credits (f : Facts) : Cents := if f.substantiallyAllInCanada then f.personalCredits else 0

/-- Part I tax on the net income, under 117(2), less the credits allowed. -/
def basicTax (f : Facts) : Cents := Rates.tax f.netIncome (brackets f) - credits f

/-- 120(1): 48% more, all the income being not earned in a province. -/
def surtax (f : Facts) : Cents := basicTax f * 48 / 100

/-- 216(1): the tax on electing. -/
def electedTax (f : Facts) : Cents := basicTax f + surtax f

/-- What electing saves (negative if it costs). -/
def saving (f : Facts) : Int := (partXIII f : Int) - (electedTax f : Int)

def explain (f : Facts) : Finding :=
  let c := formatCents
  ⟨saving f > 0, [
    ⟨s!"Without electing, Part XIII tax at {min 25 f.partXIIIRate}% of the gross rent of {c f.grossRent}: {c (partXIII f)}.", "ITA 212(1)(d)"⟩,
    ⟨s!"Electing, Part I tax on the net income of {c f.netIncome}: {c (Rates.tax f.netIncome (brackets f))}" ++
      (if credits f > 0 then s!", less credits of {c (credits f)}" else ", with no personal credits (118.94)") ++
      s!", plus 48% for income not earned in a province, {c (surtax f)}: {c (electedTax f)}.", "ITA 216(1); 117(2); 120(1); 118.94"⟩,
    ⟨s!"Electing " ++ (if saving f > 0 then "saves" else "costs") ++ s!" {c (Int.natAbs (saving f))}.", "ITA 216(1)"⟩], []⟩

/-! ## Truths -/

/-- No net income, no tax on electing. -/
theorem no_net_income (f : Facts) (h : f.netIncome = 0) : electedTax f = 0 := by
  have : Rates.tax 0 (brackets f) = 0 := by
    simp only [Rates.tax, Rates.slices, Rates.slice, Nat.zero_min, Nat.zero_sub]; rfl
  simp [electedTax, surtax, basicTax, h, this]

end Canteen.ITA.RentalElection

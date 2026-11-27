import Canteen.ITA.S127_5.MinimumTax

/-!
# Tests: the minimum tax (127.5 to 127.531)

Constructed examples for 2025: the exemption is $177,882 (117(2)(d)).
-/

namespace Canteen.Tests.MinimumTax

open Canteen Canteen.ITA Canteen.ITA.MinimumTax

def sale : CapitalGains.Disposition := { description := "QSBC shares", proceeds := 125010000, adjustedCostBase := 10000 }

/-- A $1,250,000 gain on qualified small business corporation shares, fully sheltered. -/
def crystallized : IndividualYear.Facts :=
  { taxationYear := 2025, capital := ⟨[sale], 0, {}⟩, claimsPersonal := true, deduction110_6 := some { qualifying := [sale] } }

-- No regular tax; adjusted taxable income $1,250,000 − 7/5 × $625,000 = $375,000.
example : IndividualYear.taxableIncome crystallized = 0 ∧ IndividualYear.federalTax crystallized = 0 := by decide
example : adjustedTaxableIncome crystallized = 2 * 37500000 := by decide
-- 20.5% × ($375,000 − $177,882) = $40,409.19, less half the $2,035.32 personal credit: $39,391.53.
example : basicCredit crystallized = 101766 ∧ minimumAmount crystallized = 3939153 ∧ taxPayable crystallized = 3939153 := by decide
-- With a $100,000 salary, regular tax is $14,735.30 and the minimum amount $59,891.53.
example : IndividualYear.federalTax { crystallized with employmentAndBusiness := 10000000 } = 1473530 ∧
    taxPayable { crystallized with employmentAndBusiness := 10000000 } = 5989153 := by decide

-- An ordinary salary is below the exemption.
example : taxPayable { taxationYear := 2025, employmentAndBusiness := 15000000, claimsPersonal := true } =
    IndividualYear.federalTax { taxationYear := 2025, employmentAndBusiness := 15000000, claimsPersonal := true } := by decide
-- A high salary: regular tax well above the minimum amount.
example : additional { taxationYear := 2025, employmentAndBusiness := 50000000, claimsPersonal := true } = 0 := by decide

-- Dividends are not grossed up: $880,000 of dividends gives $880,000 of adjusted taxable income.
def dividends : IndividualYear.Facts :=
  { taxationYear := 2025, claimsPersonal := true,
    dividends := [{ description := "eligible", amount := 36000000, eligible := true }, { description := "other", amount := 52000000 }] }
example : adjustedTaxableIncome dividends = 2 * 88000000 ∧ minimumAmount dividends = 14291653 ∧ additional dividends = 0 := by decide

-- A $2,000,000 gift of listed shares with no cost, on a $300,000 salary: 3/10 of the gain is included.
def bigGift : IndividualYear.Facts :=
  { taxationYear := 2025, employmentAndBusiness := 30000000, claimsPersonal := true, charitableGifts := 200000000,
    capital := ⟨[{ description := "listed shares", proceeds := 200000000, adjustedCostBase := 0, giftToQualifiedDonee := true }], 0, {}⟩ }
example : adjustedTaxableIncome bigGift = 2 * 90000000 := by decide
-- Only 4/5 of the $67,083.44 donation credit counts: the minimum amount is $93,349.78, against $4,367.59.
example : IndividualYear.donationCredit bigGift = 6708344 ∧ IndividualYear.federalTax bigGift = 436759 ∧
    minimumAmount bigGift = 9334978 ∧ additional bigGift = 8898219 := by decide

-- Capital losses count in full against gains.
example : paragraph3b ⟨[{ description := "gain", proceeds := 1000000, adjustedCostBase := 0 },
    { description := "loss", proceeds := 0, adjustedCostBase := 400000 }], 0, {}⟩ = 2 * 600000 := by decide

/-! ## Recovering it (120.2) -/

def later (salary : Cents) (year : Nat := 2026) : IndividualYear.Facts :=
  { taxationYear := year, employmentAndBusiness := salary, claimsPersonal := true }
def prior : List Carryforward := [⟨2025, 3939153⟩]

-- The crystallization year's $39,391.53 is additional tax.
example : additional crystallized = 3939153 := by decide
-- With $250,000 of salary in 2026, regular tax exceeds the minimum amount by $41,709.99: all of it is recovered.
example : recovery (later 25000000) prior = 3939153 ∧ taxAfterRecovery (later 25000000) prior = 1532273 := by decide
-- With $200,000, only $37,386.26: tax payable falls to the minimum amount, $2,680.53.
example : recovery (later 20000000) prior = 3738626 ∧ taxAfterRecovery (later 20000000) prior = 268053 := by decide
-- Seven years later it is still available; eight years later it is not. (2032 is beyond the CPI data, so
-- its amounts are 2027's, flagged.)
example : IndividualYear.amountsKnown (later 25000000 2032) = false ∧ recovery (later 25000000 2032) prior = 3939153 ∧ recovery (later 25000000 2033) prior = 0 := by decide
-- Not in the same year, or from a later year.
example : available (later 25000000 2025) prior = 0 ∧ available (later 25000000 2024) prior = 0 := by decide

end Canteen.Tests.MinimumTax

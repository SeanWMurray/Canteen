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
  { taxationYear := 2025, capital := ⟨[sale], 0, {}⟩, personalAmounts := some {}, deduction110_6 := some { qualifying := [sale] } }

-- No regular tax; adjusted taxable income $1,250,000 − 7/5 × $625,000 = $375,000.
example : IndividualYear.taxableIncome crystallized = 0 ∧ IndividualYear.federalTax crystallized = 0 := by decide
example : adjustedTaxableIncome crystallized = 2 * 37500000 := by decide
-- 20.5% × ($375,000 − $177,882) = $40,409.19, less half the $1,721.72 personal credit: $39,548.33.
example : basicCredit crystallized = 86086 ∧ minimumAmount crystallized = 3954833 ∧ taxPayable crystallized = 3954833 := by decide
-- With a $100,000 salary, regular tax is $15,048.90 and the minimum amount $60,048.33.
example : IndividualYear.federalTax { crystallized with employmentAndBusiness := 10000000 } = 1504890 ∧
    taxPayable { crystallized with employmentAndBusiness := 10000000 } = 6004833 := by decide

-- An ordinary salary is below the exemption.
example : taxPayable { taxationYear := 2025, employmentAndBusiness := 15000000, personalAmounts := some {} } =
    IndividualYear.federalTax { taxationYear := 2025, employmentAndBusiness := 15000000, personalAmounts := some {} } := by decide
-- A high salary: regular tax well above the minimum amount.
example : additional { taxationYear := 2025, employmentAndBusiness := 50000000, personalAmounts := some {} } = 0 := by decide

-- Dividends are not grossed up: $880,000 of dividends gives $880,000 of adjusted taxable income.
def dividends : IndividualYear.Facts :=
  { taxationYear := 2025, personalAmounts := some {},
    dividends := [{ description := "eligible", amount := 36000000, eligible := true }, { description := "other", amount := 52000000 }] }
example : adjustedTaxableIncome dividends = 2 * 88000000 ∧ minimumAmount dividends = 14307333 ∧ additional dividends = 0 := by decide

-- A $2,000,000 gift of listed shares with no cost, on a $300,000 salary: 3/10 of the gain is included.
def bigGift : IndividualYear.Facts :=
  { taxationYear := 2025, employmentAndBusiness := 30000000, personalAmounts := some {}, charitableGifts := 200000000,
    capital := ⟨[{ description := "listed shares", proceeds := 200000000, adjustedCostBase := 0, giftToQualifiedDonee := true }], 0, {}⟩ }
example : adjustedTaxableIncome bigGift = 2 * 90000000 := by decide
-- Only 4/5 of the $67,083.44 donation credit counts: the minimum amount is $93,506.58, against $4,681.19.
example : IndividualYear.donationCredit bigGift = 6708344 ∧ IndividualYear.federalTax bigGift = 468119 ∧
    minimumAmount bigGift = 9350658 ∧ additional bigGift = 8882539 := by decide

-- Capital losses count in full against gains.
example : paragraph3b ⟨[{ description := "gain", proceeds := 1000000, adjustedCostBase := 0 },
    { description := "loss", proceeds := 0, adjustedCostBase := 400000 }], 0, {}⟩ = 2 * 600000 := by decide

/-! ## Recovering it (120.2) -/

def later (salary : Cents) (year : Nat := 2026) : IndividualYear.Facts :=
  { taxationYear := year, employmentAndBusiness := salary, personalAmounts := some {} }
def prior : List Carryforward := [⟨2025, 3954833⟩]

-- The crystallization year's $39,548.33 is additional tax.
example : additional crystallized = 3954833 := by decide
-- With $250,000 of salary in 2026, regular tax exceeds the minimum amount by $41,469.31: all of it is recovered.
example : recovery (later 25000000) prior = 3954833 ∧ taxAfterRecovery (later 25000000) prior = 1583577 := by decide
-- With $200,000, only $37,094.11: tax payable falls to the minimum amount, $3,539.58.
example : recovery (later 20000000) prior = 3709411 ∧ taxAfterRecovery (later 20000000) prior = 353958 := by decide
-- Seven years later it is still available; eight years later it is not.
example : recovery (later 25000000 2032) prior = 3954833 ∧ recovery (later 25000000 2033) prior = 0 := by decide
-- Not in the same year, or from a later year.
example : available (later 25000000 2025) prior = 0 ∧ available (later 25000000 2024) prior = 0 := by decide

end Canteen.Tests.MinimumTax

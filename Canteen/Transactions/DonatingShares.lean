import Canteen.ITA.S127_5.MinimumTax

/-!
# Layer 3: donating shares in kind, or selling them and donating the cash

A constructed transaction under 38(a.1), 118.1, 118(1) and 117(2), computed for the whole year.

* An individual earns a $200,000 salary in 2025 and owns shares of a public company costing $10,000,
  now worth $50,000, and wants to give $50,000 to a registered charity.
* Option A: donate the shares themselves. The gain is taxed at nil (38(a.1)(i)).
* Option B: sell the shares, and donate the $50,000 of cash. Half the $40,000 gain is taxed.

Both claim the basic personal amount and the donation credit.

What if the gift is $1,000,000 of shares costing $200,000? Then the minimum tax (127.5) applies. The
gifts that cannot be claimed this year (118.1(1)) carry forward five years; their later credit is
not computed.
-/

namespace Canteen.Transactions.DonatingShares

open Canteen Canteen.ITA

def shares (gift : Bool) : CapitalGains.Disposition :=
  { description := "shares of XYZ Ltd.", proceeds := 5000000, adjustedCostBase := 1000000, giftToQualifiedDonee := gift }

def year (gift : Bool) : IndividualYear.Facts :=
  { taxationYear := 2025, employmentAndBusiness := 20000000, capital := ⟨[shares gift], 0, {}⟩,
    personalAmounts := some {}, charitableGifts := 5000000 }

def inKind : IndividualYear.Facts := year true
def cash : IndividualYear.Facts := year false

/-! ## Analysis -/

/-- In kind: the $40,000 gain is taxed at nil, so income stays at the $200,000 salary. -/
theorem in_kind_no_gain :
    (shares true).taxableCapitalGain = 0 ∧ IndividualYear.income inKind = 2 * 20000000 := by decide

/-- Sold: half the gain, $20,000, is taxable, so income is $220,000. -/
theorem cash_gain : (shares false).taxableCapitalGain = 2 * 2000000 ∧ IndividualYear.income cash = 2 * 22000000 := by decide

/-- The donation credit is the same either way: 14% of $200 and 29% of $49,800, $14,470. -/
theorem same_donation_credit :
    IndividualYear.donationCredit inKind = 1447000 ∧ IndividualYear.donationCredit cash = 1447000 := by decide

/-- The higher income also phases out more of the basic personal amount. -/
theorem personal_credits :
    IndividualYear.personalCredit inKind = 198922 ∧ IndividualYear.personalCredit cash = 188906 := by decide

/-- Federal tax: $26,163.69 in kind, $32,063.85 selling first. -/
theorem federal_tax :
    IndividualYear.federalTax inKind = 2616369 ∧ IndividualYear.federalTax cash = 3206385 := by decide

/-- **Donating in kind saves $5,900.16 of federal tax.** -/
theorem saving : IndividualYear.federalTax cash - IndividualYear.federalTax inKind = 590016 := by decide

/-- Neither year pays minimum tax: in kind the minimum amount is nil, and selling first it is $213.66,
far below regular tax. -/
theorem no_minimum_tax :
    MinimumTax.taxPayable inKind = IndividualYear.federalTax inKind ∧ MinimumTax.taxPayable cash = IndividualYear.federalTax cash := by
  decide

/-! ## What if: a $1,000,000 gift -/

def bigShares (gift : Bool) : CapitalGains.Disposition :=
  { description := "shares of XYZ Ltd.", proceeds := 100000000, adjustedCostBase := 20000000, giftToQualifiedDonee := gift }

def bigYear (gift : Bool) : IndividualYear.Facts :=
  { taxationYear := 2025, employmentAndBusiness := 20000000, capital := ⟨[bigShares gift], 0, {}⟩,
    personalAmounts := some {}, charitableGifts := 100000000 }

/-- In kind, no regular tax, but 3/10 of the $800,000 gain counts for the minimum tax: $17,963.58. -/
theorem big_in_kind :
    IndividualYear.federalTax (bigYear true) = 0 ∧ MinimumTax.adjustedTaxableIncome (bigYear true) = 2 * 44000000 ∧
    MinimumTax.taxPayable (bigYear true) = 1796358 := by decide

/-- Selling first, regular tax is $26,431.19, but the whole gain counts for the minimum tax: $52,206.58. -/
theorem big_cash :
    IndividualYear.federalTax (bigYear false) = 2643119 ∧ MinimumTax.adjustedTaxableIncome (bigYear false) = 2 * 100000000 ∧
    MinimumTax.taxPayable (bigYear false) = 5220658 := by decide

/-- Donating in kind still saves $34,243.00, though the minimum tax applies either way. -/
theorem big_saving : MinimumTax.taxPayable (bigYear false) - MinimumTax.taxPayable (bigYear true) = 3424300 := by decide

end Canteen.Transactions.DonatingShares

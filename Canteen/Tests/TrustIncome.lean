import Canteen.ITA.S104.TrustIncome

/-!
# Tests: a trust's income paid out (104(6)(b), (13), (19), (21), (24))

A family trust has $30,000 of dividends, $20,000 of net taxable capital gains and $10,000 of interest.
Constructed examples.
-/

namespace Canteen.Tests.TrustIncome

open Canteen Canteen.ITA Canteen.ITA.TrustIncome

def trust (bs : List Beneficiary) : Facts := { dividends := 3000000, netTaxableGains := 2000000, otherIncome := 1000000, beneficiaries := bs }

-- Everything payable to two adult children, dividends to one and gains to the other.
def allOut : Facts := trust [⟨"Ada", 3500000, 3000000, 0, true⟩, ⟨"Ben", 2500000, 0, 2000000, true⟩]
example : deduction allOut = 6000000 ∧ retained allOut = 0 := by decide
example : shares allOut = [⟨"Ada", 3000000, 0, 500000⟩, ⟨"Ben", 0, 2000000, 500000⟩] := by decide
-- Only $40,000 payable: the trust is taxed on $20,000.
example : retained (trust [⟨"Ada", 4000000, 0, 0, true⟩]) = 2000000 := by decide
-- Designations over the trust's dividends are cut to them: Ada keeps $30,000, Ben gets none.
example : (shares (trust [⟨"Ada", 3000000, 3000000, 0, true⟩, ⟨"Ben", 3000000, 3000000, 0, true⟩])).map (·.dividends) = [3000000, 0] := by decide
-- A designation is part of the amount payable: $10,000 payable carries at most $10,000 of dividends.
example : (shares (trust [⟨"Ada", 1000000, 3000000, 0, true⟩])).map (·.dividends) = [1000000] := by decide
-- A non-resident beneficiary cannot be designated capital gains: they are income from the trust.
example : shares (trust [⟨"Cy", 2000000, 0, 2000000, false⟩]) = [⟨"Cy", 0, 0, 2000000⟩] := by decide
-- A trust not resident throughout the year: no designations.
example : (shares { allOut with resident := false }).map (·.dividends) = [0, 0] := by decide

-- 122(1): $20,000 kept by a family trust, none of it dividends: 33%, $6,600. In a graduated rate
-- estate: 14%, $2,800.
def keeps : Facts := trust [⟨"Ada", 4000000, 3000000, 0, true⟩]
example : keptDividends keeps = 0 ∧ tax keeps = 660000 ∧ tax { keeps with kind := .graduated } = 280000 := by decide
-- Keeping $20,000 of eligible dividends instead: grossed up 38% to $27,600, taxed at 33% ($9,108), less
-- the 15.0198% dividend tax credit ($4,145.46).
def keepsDividends : Facts := trust [⟨"Ada", 4000000, 1000000, 0, true⟩]
example : keptDividends keepsDividends = 2000000 ∧ amountTaxable keepsDividends = 2760000 := by decide
example : tax keepsDividends = 910800 - Dividends.credit (keptDividendFacts keepsDividends) := by decide
-- Paying it all out: no tax for the trust.
example : tax allOut = 0 := by decide

-- 118.1: the family trust keeping $20,000 gives $10,000 to a charity: 14% of $200 and 33% of $9,800.
example : donationCredit { keeps with charitableGifts := 1000000 } = (20000 * 1400 + 980000 * 3300) / 10000 := by decide
example : tax { keeps with charitableGifts := 1000000 } = 660000 - (20000 * 1400 + 980000 * 3300) / 10000 := by decide
-- At most 75% of its income: $15,000 of a $30,000 gift.
example : Donations.totalGifts (donationFacts { keeps with charitableGifts := 3000000 }) = 1500000 := by decide

end Canteen.Tests.TrustIncome

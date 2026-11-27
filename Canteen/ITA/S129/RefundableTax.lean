import Canteen.ITA.S123.CorporateRates

/-!
# Refundable taxes: 123.3, Part IV (186(1)), RDTOH (129(4)) and the dividend refund (129(1))

*Income Tax Act*, as consolidated to 2026-10-29 (verbatim in `statute/ITA-123.3-129-186-refundable-tax.txt`):

* **123.3** A Canadian-controlled private corporation adds 10⅔% of the lesser of its aggregate
  investment income and its taxable income in excess of the small business amount (125(1)(a) to (c)).
* **186(1)** A private corporation pays Part IV tax of (a) 38⅓% of assessable dividends from
  corporations not connected with it, and (b) for each dividend from a connected private corporation,
  that dividend's share of the payer's dividend refund; less (c), (d) 38⅓% of the non-capital losses it claims.
* **129(4) "non-eligible refundable dividend tax on hand"**: for a CCPC, the least of 30⅔% of aggregate
  investment income (less foreign tax credits), 30⅔% of taxable income in excess of the small business
  amount, and Part I tax; plus Part IV tax other than the eligible part; plus last year's balance, less
  last year's refund from it. **"eligible refundable dividend tax on hand"**: Part IV tax on eligible
  dividends from unconnected corporations and on connected dividends that caused a refund from the
  payer's eligible account; plus last year's balance, less last year's refunds from it.
* **129(1)** The dividend refund is (i) the lesser of 38⅓% of eligible dividends paid and the eligible
  account, plus (ii)(A) the lesser of 38⅓% of non-eligible dividends paid and the non-eligible account,
  and (B) if 38⅓% of the non-eligible dividends is more than the non-eligible account, the lesser of the
  excess and what is left of the eligible account.

The opening balances (last year's balance less last year's refunds) are given; foreign tax credits are
nil. The losses claimed under 186(1)(c) and (d) are given (see `CorporateYear` for their limits); their
reduction comes off the Part IV tax on non-eligible dividends first, and only then off the eligible part. 38⅓%, 10⅔% and 30⅔% are 115/300, 32/300 and 92/300, each product
rounded down to the cent. The 129(4) Part I tax cap uses the tax from `CorporateRates`.
-/

namespace Canteen.ITA.RefundableTax

structure Facts where
  /-- The corporation's Part I facts (CCPC status, taxable income, active business income, ...). -/
  rates : CorporateRates.Facts
  /-- Dividends received from corporations not connected with it (186(1)(a)). -/
  portfolioEligible : Cents := 0
  portfolioNonEligible : Cents := 0
  /-- 186(1)(b): dividends from connected corporations' shares of the payer's refund, split by the payer's account. -/
  connectedFromEligible : Cents := 0
  connectedFromNonEligible : Cents := 0
  /-- Opening balances: last year's accounts less last year's refunds from them. -/
  openingEligible : Cents := 0
  openingNonEligible : Cents := 0
  /-- Taxable dividends paid in the year. -/
  eligibleDividendsPaid : Cents := 0
  nonEligibleDividendsPaid : Cents := 0
  /-- 186(1)(c), (d): non-capital losses claimed against Part IV tax. -/
  lossesClaimed : Cents := 0
  deriving Repr, DecidableEq, Inhabited

def frac (x n : Nat) : Cents := x * n / 300

/-- Taxable income over the small business amount. -/
def excessOverSmallBusiness (f : Facts) : Cents := f.rates.taxableIncome - CorporateRates.smallBusinessAmount f.rates

/-- 123.3: the additional refundable tax. -/
def additionalTax (f : Facts) : Cents :=
  if f.rates.ccpc then frac (min f.rates.aggregateInvestmentIncome (excessOverSmallBusiness f)) 32 else 0

/-- Part I tax, with 123.3. -/
def partITax (f : Facts) : Cents := CorporateRates.tax f.rates + additionalTax f

/-- 186(1): Part IV tax, and its eligible part. -/
def partIVEligibleGross (f : Facts) : Cents := frac f.portfolioEligible 115 + f.connectedFromEligible
def partIVGross (f : Facts) : Cents := frac (f.portfolioEligible + f.portfolioNonEligible) 115 + f.connectedFromEligible + f.connectedFromNonEligible
/-- 186(1)(c), (d): 38⅓% of the losses claimed. -/
def lossReduction (f : Facts) : Cents := frac f.lossesClaimed 115
def partIV (f : Facts) : Cents := partIVGross f - lossReduction f
/-- The eligible part, after the reduction (which comes off the non-eligible part first). -/
def partIVEligible (f : Facts) : Cents := min (partIVEligibleGross f) (partIV f)

/-- 129(4): the eligible account at year end. -/
def eligibleAccount (f : Facts) : Cents := f.openingEligible + partIVEligible f

/-- 129(4): the non-eligible account at year end. -/
def nonEligibleAccount (f : Facts) : Cents :=
  (if f.rates.ccpc then min (frac f.rates.aggregateInvestmentIncome 92) (min (frac (excessOverSmallBusiness f) 92) (partITax f)) else 0) +
  (partIV f - partIVEligible f) + f.openingNonEligible

/-- 129(1)(a)(i). -/
def refundEligible (f : Facts) : Cents := min (frac f.eligibleDividendsPaid 115) (eligibleAccount f)
/-- 129(1)(a)(ii)(A). -/
def refundNonEligible (f : Facts) : Cents := min (frac f.nonEligibleDividendsPaid 115) (nonEligibleAccount f)
/-- 129(1)(a)(ii)(B): non-eligible dividends drawing on what is left of the eligible account. -/
def refundCross (f : Facts) : Cents :=
  if nonEligibleAccount f < frac f.nonEligibleDividendsPaid 115 then
    min (frac f.nonEligibleDividendsPaid 115 - nonEligibleAccount f) (eligibleAccount f - refundEligible f)
  else 0

/-- 129(1): the dividend refund. -/
def dividendRefund (f : Facts) : Cents := refundEligible f + refundNonEligible f + refundCross f

def explain (f : Facts) : Finding :=
  let c := formatCents
  ⟨dividendRefund f > 0, [
    ⟨s!"Part I tax {c (CorporateRates.tax f.rates)}, plus the 10⅔% refundable tax on investment income {c (additionalTax f)}.",
      "ITA 123–125; 123.3"⟩,
    ⟨s!"Part IV tax on dividends received: {c (partIV f)}, {c (partIVEligible f)} of it on eligible dividends.", "ITA 186(1)"⟩,
    ⟨s!"At year end the eligible refundable dividend tax on hand is {c (eligibleAccount f)}, and the non-eligible {c (nonEligibleAccount f)}.",
      "ITA 129(4)"⟩,
    ⟨s!"The dividend refund is {c (dividendRefund f)}: {c (refundEligible f)} on eligible dividends, {c (refundNonEligible f)} on " ++
      s!"non-eligible dividends, and {c (refundCross f)} of the eligible account used for non-eligible dividends.", "ITA 129(1)"⟩], []⟩

/-! ## Truths about the refund -/

private theorem three (a b c E N : Nat) (h1 : a ≤ E) (h2 : b ≤ N) (h3 : c ≤ E - a) : a + b + c ≤ E + N := by omega

/-- The refund never exceeds the two accounts together. -/
theorem refund_le_accounts (f : Facts) : dividendRefund f ≤ eligibleAccount f + nonEligibleAccount f := by
  have h1 : refundEligible f ≤ eligibleAccount f := Nat.min_le_right _ _
  have h2 : refundNonEligible f ≤ nonEligibleAccount f := Nat.min_le_right _ _
  have h3 : refundCross f ≤ eligibleAccount f - refundEligible f := by
    unfold refundCross; split
    · exact Nat.min_le_right _ _
    · exact Nat.zero_le _
  unfold dividendRefund
  exact three _ _ _ _ _ h1 h2 h3

/-- **Flow-through.** A private corporation that only receives eligible portfolio dividends and pays
them all out as eligible dividends gets back all of its Part IV tax. -/
theorem flow_through (d : Cents) :
    dividendRefund { rates := { taxableIncome := 0, ccpc := false }, portfolioEligible := d, eligibleDividendsPaid := d } =
      partIV { rates := { taxableIncome := 0, ccpc := false }, portfolioEligible := d, eligibleDividendsPaid := d } := by
  simp [dividendRefund, refundEligible, refundNonEligible, refundCross, eligibleAccount, nonEligibleAccount, partIV, partIVEligible,
    partIVGross, partIVEligibleGross, lossReduction, frac]

/-- Losses claimed never make Part IV tax more than it would be without them. -/
theorem partIV_le_gross (f : Facts) : partIV f ≤ partIVGross f := Nat.sub_le _ _

end Canteen.ITA.RefundableTax

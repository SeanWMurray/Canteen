import Canteen.ITA.S3.Income
import Canteen.ITA.S111.NetCapitalLoss
import Canteen.ITA.S111.NonCapitalLoss
import Canteen.ITA.S55.IntercorporateDividends
import Canteen.ITA.S110_1.CorporateDonations
import Canteen.ITA.S129.RefundableTax
import Canteen.ITA.S89.GeneralRateIncomePool
import Canteen.ITA.S89.CapitalDividendAccount

/-!
# A corporation's year: income, taxable income, investment income and the taxes on them

*Income Tax Act*, as consolidated to 2026-10-29: the 129(4) definitions "aggregate investment income",
"eligible portion" and "income or loss" are verbatim in `statute/ITA-129-4-aggregate-investment-income.txt`;
the provisions it puts together are in the files their modules cite.

This puts the encoded corporate provisions together for one corporation and one taxation year.
The other corporate modules take taxable income and aggregate investment income as given; here they
are computed.

* **3(a)** income from sources: active business income, personal services business income, income
  from property (interest, rents, royalties), and taxable dividends received (12(1)(j), (k)), less
  any part 55(2) deems not to be a dividend;
* **3(b)** taxable capital gains less allowable capital losses (sections 38 to 41), with each 55(2)
  gain (55(2)(c)) as a disposition of its own;
* **3(d)** losses from active businesses and from property;
* **taxable income (2(2))**: income less charitable gifts (110.1(1)(a), with its 75% limit on the
  year's income), intercorporate dividends (112(1)), net capital losses (111(1)(b), limited to 3(b))
  and non-capital losses of other years (111(1)(a), oldest first, by default as much as is needed);
* **111(8)**: the year's own non-capital loss, such as a 112(1) deduction over income creates;
* **129(4) "aggregate investment income"**: (a) taxable capital gains less allowable capital losses
  and the 111(1)(b) deduction, and (b) income from property other than the part of a dividend
  deductible in computing taxable income, less losses from property.

From these, Part I tax (123 to 125 with 123.3), Part IV tax (186(1)), the refundable dividend tax
accounts and the dividend refund (129), the general rate income pool and Part III.1 tax (89(1),
185.1), and the capital dividend account (89(1)).

What counts as active business income, and what is income from property (129(4) "income or loss",
including property incident to an active business and specified investment businesses, 125(7)), is
the caller's classification. Every taxable capital gain and allowable capital loss is taken as an
"eligible portion" (the property did not accrue its gain outside a CCPC). A 55(2) dividend received
on a redemption is added to the redeemed share's proceeds (55(2)(b)): the caller includes it in the
disposition; the explanation gives the amount. Not encoded: 113 (dividends from foreign affiliates),
126 (foreign tax credits), and farm losses (in 186(1)(c), (d) as in 111). Non-capital losses claimed
against Part IV tax (186(1)(c), (d)) are limited to the year's own loss and to what is left of other
years' after 111(1)(a), and are taken off the losses carried forward (111(3)(a)(ii)). Section 3 and
taxable income are in half-cents; the amounts handed to the corporate rate modules are in cents,
rounded down.
-/

namespace Canteen.ITA.CorporateYear

open CapitalGains (HalfCents Disposition Year formatHalfCents)

/-- A taxable dividend the corporation received. -/
structure Received where
  /-- The dividend, for 112(1) and 55(2). -/
  dividend : IntercorporateDividends.Facts
  /-- Designated an eligible dividend by the payer (89(14)). -/
  eligible : Bool := false
  /-- From a payer corporation connected with the recipient (186(4)). -/
  connected : Bool := false
  /-- 186(1)(b): for a connected payer, the recipient's share of the payer's dividend refund, split by
  the payer's account it came from. -/
  refundFromEligible : Cents := 0
  refundFromNonEligible : Cents := 0
  deriving Repr, Inhabited

/-- A dividend from a taxable Canadian corporation with no 55(2) purpose: the usual portfolio dividend. -/
def Received.portfolio (description : String) (amount : Cents) (eligible : Bool := false) : Received :=
  { dividend := { description, amount, reducesGain := .fact false, safeIncome := 0 }, eligible }

/-- The part included in income: 55(2)(a) deems the caught part not to be a dividend received. -/
def Received.included (r : Received) : Cents := r.dividend.amount - IntercorporateDividends.caught r.dividend

/-- 112(1). -/
def Received.deduction (r : Received) : Cents := IntercorporateDividends.deduction r.dividend

/-- 129(4) "aggregate investment income" (b)(iii) excludes the deductible part; the rest is investment income. -/
def Received.notDeducted (r : Received) : Cents := r.included - r.deduction

/-- Part IV tax applies to "assessable dividends": those deductible under 112(1). -/
def Received.assessable (r : Received) : Cents := if IntercorporateDividends.deductible r.dividend then r.included else 0

structure Facts where
  taxationYear : Nat
  /-- A Canadian-controlled private corporation throughout the year. -/
  ccpc : Bool := true
  /-- 125(1)(a): income, and losses, from active businesses carried on in Canada. -/
  activeBusinessIncome : Cents := 0
  activeBusinessLosses : Cents := 0
  /-- Income from a personal services business (not an active business for 125(1)). -/
  personalServicesIncome : Cents := 0
  /-- 125(1)(c): the business limit, after 125(2) to (5.1). -/
  businessLimit : Cents := 50000000
  /-- 129(4) "income or loss" from a source that is a property, other than taxable dividends from corporations. -/
  propertyIncome : Cents := 0
  propertyLosses : Cents := 0
  /-- Taxable dividends received. -/
  dividends : List Received := []
  /-- The year's dispositions. -/
  capital : Year := ⟨[], 0, {}⟩
  /-- 110.1(1)(a): gifts of the year and earlier years not yet deducted, and B, C and D of the limit. -/
  gifts : List CorporateDonations.Gift := []
  giftGains : Cents := 0
  gains40_1_01 : Cents := 0
  giftRecapture : Cents := 0
  /-- 111(1)(a): non-capital losses of other years, with what is left of each, and the amount claimed
  (by default, as much as brings taxable income to nil). -/
  nonCapitalLosses : List NonCapitalLoss.Loss := []
  nonCapitalLossClaim : Option HalfCents := none
  /-- 186(1)(c): the part of the year's own non-capital loss claimed against Part IV tax; (d): the part of
  other years' losses (what is left after 111(1)(a), oldest first). -/
  partIVOwnLossClaim : HalfCents := 0
  partIVCarriedLossClaim : HalfCents := 0
  netCapitalLossClaims : List NetCapitalLoss.Claim := []
  /-- 129(4): the refundable dividend tax accounts at the start of the year (last year's balances
  less last year's refunds from them). -/
  openingEligible : Cents := 0
  openingNonEligible : Cents := 0
  /-- Taxable dividends paid in the year. -/
  eligibleDividendsPaid : Cents := 0
  nonEligibleDividendsPaid : Cents := 0
  /-- 89(1) "general rate income pool": the pool at the end of last year, and last year's eligible
  dividends and excessive designations. -/
  priorPool : Int := 0
  eligiblePaidLastYear : Cents := 0
  excessiveLastYear : Cents := 0
  /-- 185.1(1)(c): a purpose of artificially maintaining or increasing the pool. -/
  artificial : Answer := .fact false
  /-- 89(1) "capital dividend account": the earlier part of the period (dispositions of earlier years,
  capital dividends received and paid, life insurance); the year's dispositions are added. -/
  cdaPeriod : CapitalDividendAccount.Facts := {}
  deriving Inhabited

/-- 55(2)(c): each dividend 55(2) deems a gain is a disposition of a capital property. -/
def section55Gains (f : Facts) : List Disposition :=
  f.dividends.filterMap fun r =>
    let g := IntercorporateDividends.gain r.dividend
    if g = 0 then none else some { description := s!"{r.dividend.description} (a gain under 55(2)(c))", proceeds := g, adjustedCostBase := 0 }

def capitalYear (f : Facts) : Year := { f.capital with dispositions := f.capital.dispositions ++ section55Gains f }

def dividendsIncluded (f : Facts) : Cents := (f.dividends.map Received.included).sum
def dividendDeduction (f : Facts) : Cents := (f.dividends.map Received.deduction).sum
def dividendsNotDeducted (f : Facts) : Cents := (f.dividends.map Received.notDeducted).sum

/-- 125(1)(a): active business income net of active business losses. -/
def netActiveBusinessIncome (f : Facts) : Cents := f.activeBusinessIncome - f.activeBusinessLosses

def incomeFacts (f : Facts) : Income.Facts :=
  { incomeFromSources := f.activeBusinessIncome + f.personalServicesIncome + f.propertyIncome + dividendsIncluded f,
    capital := capitalYear f, sourceLosses := f.activeBusinessLosses + f.propertyLosses }

/-- Section 3: income for the year, in half-cents. -/
def income (f : Facts) : HalfCents := Income.income (incomeFacts f)

def donationFacts (f : Facts) : CorporateDonations.Facts :=
  { taxationYear := f.taxationYear, income := income f / 2, giftGains := f.giftGains, gains40_1_01 := f.gains40_1_01,
    giftRecapture := f.giftRecapture, gifts := f.gifts }

/-- 110.1(1)(a). -/
def donationDeduction (f : Facts) : Cents := CorporateDonations.deduction (donationFacts f)

/-- 111(1)(b), at most the amount in 3(b). -/
def netCapitalLossDeduction (f : Facts) : HalfCents :=
  NetCapitalLoss.deduction f.taxationYear (Income.paraB (incomeFacts f)) f.netCapitalLossClaims

/-- Taxable income before 111(1)(a). -/
def beforeNonCapitalLosses (f : Facts) : HalfCents :=
  income f - 2 * donationDeduction f - 2 * dividendDeduction f - netCapitalLossDeduction f

/-- 111(1)(a), oldest losses first (111(3)(b)). -/
def nonCapitalLossDeduction (f : Facts) : HalfCents :=
  NonCapitalLoss.deduction f.taxationYear (f.nonCapitalLossClaim.getD (beforeNonCapitalLosses f)) f.nonCapitalLosses

/-- Taxable income (2(2)), in half-cents. -/
def taxableIncome (f : Facts) : HalfCents := beforeNonCapitalLosses f - nonCapitalLossDeduction f

/-- 111(8): the year's own non-capital loss. E counts losses from business and property, the 112(1)
deduction and the 111(1)(b) deduction, and the allowable business investment loss; F is 3(c). -/
def nonCapitalLossFacts (f : Facts) : NonCapitalLoss.Facts :=
  { taxationYear := f.taxationYear, sourceLosses := f.activeBusinessLosses + f.propertyLosses,
    divisionC := 2 * dividendDeduction f + netCapitalLossDeduction f,
    abil := (capitalYear f).allowableBusinessInvestmentLosses, para3c := Income.paraC (incomeFacts f) }

def nonCapitalLoss (f : Facts) : HalfCents := NonCapitalLoss.amount (nonCapitalLossFacts f)

/-- The available losses of other years, after the 111(1)(a) deduction, oldest first. -/
def afterDeduction (f : Facts) : List NonCapitalLoss.Loss :=
  NonCapitalLoss.remaining f.taxationYear (f.nonCapitalLossClaim.getD (beforeNonCapitalLosses f)) f.nonCapitalLosses

/-- 186(1)(c): at most the year's own loss. -/
def partIVOwnClaim (f : Facts) : HalfCents := min f.partIVOwnLossClaim (nonCapitalLoss f)

/-- 186(1)(d): at most what is deductible of other years' losses, oldest first (111(3)). -/
def partIVCarriedTaken (f : Facts) : List HalfCents := NonCapitalLoss.take f.partIVCarriedLossClaim (afterDeduction f)
def partIVCarriedClaim (f : Facts) : HalfCents := (partIVCarriedTaken f).sum

/-- 111(3)(a)(ii): the year's own loss, less what was claimed against Part IV tax. -/
def ownLossForward (f : Facts) : HalfCents := nonCapitalLoss f - partIVOwnClaim f

/-- The non-capital losses at the start of next year: what is left of those available, those of later
years not yet available, and the year's own. -/
def nonCapitalLossesForward (f : Facts) : List NonCapitalLoss.Loss :=
  (List.zipWith (fun (l : NonCapitalLoss.Loss) d => { l with unused := l.unused - d }) (afterDeduction f) (partIVCarriedTaken f)).filter (0 < ·.unused) ++
    f.nonCapitalLosses.filter (fun l => f.taxationYear + 3 < l.year) ++
    (if ownLossForward f = 0 then [] else [⟨f.taxationYear, ownLossForward f⟩])

/-- 129(4) "aggregate investment income" (a): net taxable capital gains, less the 111(1)(b) deduction. -/
def netGains (f : Facts) : HalfCents :=
  (capitalYear f).taxableCapitalGains - ((capitalYear f).allowableCapitalLosses + netCapitalLossDeduction f)

/-- 129(4) "aggregate investment income", in half-cents. -/
def aggregateInvestmentIncome (f : Facts) : HalfCents :=
  netGains f + 2 * (f.propertyIncome + dividendsNotDeducted f) - 2 * f.propertyLosses

def ratesFacts (f : Facts) : CorporateRates.Facts :=
  { taxableIncome := taxableIncome f / 2, ccpc := f.ccpc, activeBusinessIncome := netActiveBusinessIncome f,
    businessLimit := f.businessLimit, aggregateInvestmentIncome := aggregateInvestmentIncome f / 2,
    personalServicesIncome := f.personalServicesIncome }

def portfolio (f : Facts) (eligible : Bool) : Cents :=
  ((f.dividends.filter fun r => !r.connected && r.eligible == eligible).map Received.assessable).sum

def refundableFacts (f : Facts) : RefundableTax.Facts :=
  { rates := ratesFacts f, portfolioEligible := portfolio f true, portfolioNonEligible := portfolio f false,
    connectedFromEligible := ((f.dividends.filter (·.connected)).map (·.refundFromEligible)).sum,
    connectedFromNonEligible := ((f.dividends.filter (·.connected)).map (·.refundFromNonEligible)).sum,
    openingEligible := f.openingEligible, openingNonEligible := f.openingNonEligible,
    eligibleDividendsPaid := f.eligibleDividendsPaid, nonEligibleDividendsPaid := f.nonEligibleDividendsPaid,
    lossesClaimed := (partIVOwnClaim f + partIVCarriedClaim f) / 2 }

def gripFacts (f : Facts) : GeneralRateIncomePool.Facts :=
  { priorPool := f.priorPool, rates := ratesFacts f,
    eligibleReceived := ((f.dividends.filter (·.eligible)).map Received.included).sum,
    eligiblePaidLastYear := f.eligiblePaidLastYear, excessiveLastYear := f.excessiveLastYear,
    eligiblePaid := f.eligibleDividendsPaid, artificial := f.artificial }

def cdaFacts (f : Facts) : CapitalDividendAccount.Facts :=
  { f.cdaPeriod with dispositions := f.cdaPeriod.dispositions ++ (capitalYear f).dispositions }

/-- Part I tax, with the 123.3 additional refundable tax. -/
def partITax (f : Facts) : Cents := RefundableTax.partITax (refundableFacts f)
/-- Part IV tax. -/
def partIVTax (f : Facts) : Cents := RefundableTax.partIV (refundableFacts f)
/-- Part III.1 tax on excessive eligible dividend designations. -/
def partIII1Tax (f : Facts) : Cents := GeneralRateIncomePool.partIII1 (gripFacts f)
def dividendRefund (f : Facts) : Cents := RefundableTax.dividendRefund (refundableFacts f)

/-- The year's federal taxes, less the dividend refund. -/
def netTax (f : Facts) : Cents := partITax f + partIVTax f + partIII1Tax f - dividendRefund f

/-- The capital dividend account at the end of the year, in half-cents. -/
def capitalDividendAccount (f : Facts) : HalfCents := CapitalDividendAccount.account (cdaFacts f)

def judgments (f : Facts) : List String :=
  mergeIds ((f.dividends.map fun r => IntercorporateDividends.purposeJudgments r.dividend).foldl mergeIds [])
    (mergeIds f.artificial.judgments (f.capital.dispositions.foldl (fun acc d => mergeIds acc d.capitalAccount.judgments) []))

def explain (f : Facts) : Finding :=
  let c := formatCents
  let h := formatHalfCents
  let caught := f.dividends.filterMap fun r =>
    let a := IntercorporateDividends.caught r.dividend
    if a = 0 then none else some (⟨s!"{r.dividend.description}: {c a} of it, over safe income, is not a dividend (55(2)(a)); it is " ++
      (if r.dividend.onRedemption then s!"added to the proceeds of the redeemed share (55(2)(b))."
       else "a gain from the disposition of a capital property (55(2)(c))."), "ITA 55(2)"⟩ : Step)
  ⟨true, [
    ⟨s!"Income from sources: active business {c f.activeBusinessIncome}, personal services business {c f.personalServicesIncome}, " ++
      s!"property {c f.propertyIncome}, and taxable dividends received {c (dividendsIncluded f)}.", "ITA 3(a); 9; 12(1)(c), (j), (k)"⟩] ++
    caught ++ [
    ⟨s!"Taxable capital gains less allowable capital losses: {h (Income.paraB (incomeFacts f))}. Losses from sources: " ++
      s!"{c (f.activeBusinessLosses + f.propertyLosses)}. Income for the year: {h (income f)}.", "ITA 3(b), (d); 38"⟩,
    ⟨s!"Deducted: charitable gifts {c (donationDeduction f)} (at most {c (CorporateDonations.limit (donationFacts f))}), " ++
      s!"intercorporate dividends {c (dividendDeduction f)}, net capital losses {h (netCapitalLossDeduction f)}, " ++
      s!"and non-capital losses {h (nonCapitalLossDeduction f)}. Taxable income: {h (taxableIncome f)}. The year's own non-capital " ++
      s!"loss: {h (nonCapitalLoss f)}.", "ITA 2(2); 110.1(1)(a); 111(1)(a), (b); 111(8); 112(1)"⟩,
    ⟨s!"Aggregate investment income: net taxable capital gains {h (netGains f)}, and income from property, with dividends not " ++
      s!"deducted, less property losses: {h (aggregateInvestmentIncome f)}.", "ITA 129(4) \"aggregate investment income\""⟩,
    ⟨s!"Part I tax {c (partITax f)}, of which {c (RefundableTax.additionalTax (refundableFacts f))} is the 123.3 additional tax; " ++
      s!"Part IV tax {c (partIVTax f)}; Part III.1 tax {c (partIII1Tax f)}.", "ITA 123–125; 123.3; 186(1); 185.1(1)"⟩,
    ⟨s!"Dividend refund {c (dividendRefund f)}. Net federal tax for the year: {c (netTax f)}.", "ITA 129(1)"⟩,
    ⟨s!"General rate income pool at year end: {GeneralRateIncomePool.pool (gripFacts f)} cents. Capital dividend account: " ++
      s!"{h (capitalDividendAccount f)}.", "ITA 89(1)"⟩], judgments f⟩

/-! ## Truths -/

private theorem sub5 (a b c d e : Nat) : a - b - c - d - e ≤ a := by omega

/-- Taxable income never exceeds income. -/
theorem taxableIncome_le_income (f : Facts) : taxableIncome f ≤ income f := by
  unfold taxableIncome beforeNonCapitalLosses
  exact sub5 _ _ _ _ _

private theorem loss_nil (a s b c d g x : Nat) (h : 0 < s + (d + g) + b - a - 0) : a - (s + b) - c - d - g - x = 0 := by omega

/-- A year with a non-capital loss has no taxable income: the loss is what is left over. -/
theorem loss_year_no_taxable_income (f : Facts) (h : 0 < nonCapitalLoss f) : taxableIncome f = 0 := by
  simp only [nonCapitalLoss, NonCapitalLoss.amount, NonCapitalLoss.amountAt, NonCapitalLoss.e, nonCapitalLossFacts,
    Nat.lt_add_of_pos_right (by decide : 0 < 11), ite_true] at h
  unfold taxableIncome beforeNonCapitalLosses income Income.income Income.paraD
  exact loss_nil _ _ _ _ _ _ _ h

/-- 112(1) never deducts more of a dividend than income includes. -/
theorem Received.deduction_le (r : Received) : r.deduction ≤ r.included := by
  unfold Received.deduction Received.included IntercorporateDividends.deduction
  split <;> simp

private theorem sum_le {α} (l : List α) (g h : α → Nat) (hle : ∀ a, g a ≤ h a) : (l.map g).sum ≤ (l.map h).sum := by
  induction l with
  | nil => simp
  | cons a t ih => simp only [List.map_cons, List.sum_cons]; exact Nat.add_le_add (hle a) ih

/-- In total too. -/
theorem dividendDeduction_le (f : Facts) : dividendDeduction f ≤ dividendsIncluded f :=
  sum_le _ _ _ Received.deduction_le

/-- A dividend from a taxable Canadian corporation that 55(2) does not reach is not investment income:
it is deducted under 112(1), and 129(4)(b)(iii) leaves it out. (It bears Part IV tax instead.) -/
theorem deductible_dividend_not_investment_income (f : Facts) (r : Received)
    (hd : IntercorporateDividends.deductible r.dividend = true) (hc : IntercorporateDividends.caught r.dividend = 0) :
    aggregateInvestmentIncome { f with dividends := r :: f.dividends } = aggregateInvestmentIncome f := by
  have hg : IntercorporateDividends.gain r.dividend = 0 := by
    unfold IntercorporateDividends.gain; split <;> simp [hc]
  have hn : r.notDeducted = 0 := by
    unfold Received.notDeducted Received.deduction Received.included IntercorporateDividends.deduction
    simp [hd, hc]
  simp [aggregateInvestmentIncome, netGains, dividendsNotDeducted, netCapitalLossDeduction, incomeFacts, capitalYear,
    section55Gains, dividendsIncluded, Income.paraB, hg, hn]

/-- A non-capital loss claimed against Part IV tax is not lost: what is claimed and what carries forward make up the loss. -/
theorem own_loss_conserved (f : Facts) : partIVOwnClaim f + ownLossForward f = nonCapitalLoss f :=
  Nat.add_sub_cancel' (Nat.min_le_right _ _)

end Canteen.ITA.CorporateYear

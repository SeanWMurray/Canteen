import Canteen.Core.Answer
import Canteen.Core.Money
import Canteen.ITA.S40.Paragraph40_2_g
import Canteen.ITA.S40.SuspendedLoss

/-!
# Capital gains and losses: 40(1), 39(1), 38, 41

*Income Tax Act*, as consolidated to 2026-10-29 (verbatim in `statute/ITA-3-38-41.txt`):

* **40(1)(a), (b)** a taxpayer's *gain* or *loss* from the disposition of a property: proceeds
  less adjusted cost base and outlays and expenses, less any reserve claimed under 40(1)(a)(iii)
  (at most a reasonable reserve and ⅕ of the gain for each of the years remaining in four);
* **39(1)(a), (b)** which gains and losses are *capital* gains and losses: those not otherwise
  included in income (on capital account), from property other than the excluded kinds (and, for
  losses, other than depreciable property);
* **39(1)(c)** a *business investment loss*, taken as a fact with its reductions;
* **38(a), (a.1)(i), (b), (c)** the inclusion rate: ½, or nil for a gift of listed securities
  to a qualified donee;
* **41** listed personal property: its gains and losses are pooled, with carried-over losses.

Taxable amounts are ½ of whole cents, so they are kept exactly, in **half-cents**.

A loss made nil by paragraph 40(2)(g) or subsection 40(3.4) is nil here: `ofParagraph40_2_g`
and `ofSuspendedLoss` build a disposition from those encodings.
-/

namespace Canteen.ITA.CapitalGains

/-- An amount in half-cents, for taxable amounts (½ of a gain or loss). -/
abbrev HalfCents := Nat

/-- Dollars, to the half cent: `$254.995`. -/
def formatHalfCents (h : HalfCents) : String :=
  if h % 2 == 0 then formatCents (h / 2) else formatCents (h / 2) ++ "5"

/-- The kind of property, for 39(1) and 41. -/
inductive PropertyClass where
  /-- Capital property other than the kinds below. -/
  | ordinary
  /-- Listed personal property (section 54): pooled under section 41. -/
  | listedPersonal
  /-- Depreciable property: a capital gain, but no capital loss (39(1)(b)(i)). -/
  | depreciable
  /-- A kind listed in 39(1)(a)(i.1) to (v) (certified cultural property, resource property,
  insurance policies, timber resource property, environmental trust interests): no capital gain or loss. -/
  | excluded
  deriving Repr, DecidableEq, Inhabited

/-- One disposition, for a taxation year. -/
structure Disposition where
  description : String
  proceeds : Cents
  adjustedCostBase : Cents
  outlaysAndExpenses : Cents := 0
  /-- The gain or loss is on capital account: it would not otherwise be included in or deducted
  from income (for example, as business income). Often a judgment call. -/
  capitalAccount : Answer := .fact true
  propertyClass : PropertyClass := .ordinary
  /-- 40(1)(a)(ii): disposed of before the year; the reserve claimed in the preceding year. -/
  priorYearReserve : Option Cents := none
  /-- 40(1)(a)(iii): the reserve the taxpayer claims this year. -/
  reserveClaimed : Cents := 0
  /-- 40(1)(a)(iii)(C): a reasonable reserve for proceeds payable after the end of the year. -/
  reasonableReserve : Cents := 0
  /-- 40(1)(a)(iii)(D): the number of preceding taxation years ending after the disposition. -/
  precedingYears : Nat := 0
  /-- The loss is nil under paragraph 40(2)(g) or subsection 40(3.4). -/
  lossNil : Bool := false
  /-- 38(a.1)(i): a gift to a qualified donee of a listed share, debt obligation or right, a
  mutual fund share or unit, a related segregated fund trust interest, or a prescribed debt obligation. -/
  giftToQualifiedDonee : Bool := false
  /-- 39(1)(c): the capital loss is a business investment loss (a small business corporation
  share or debt, disposed of to an arm's length person or under 50(1)), less `bilReduction`. -/
  businessInvestment : Bool := false
  /-- 39(1)(c)(v) to (viii): reductions of the business investment loss. -/
  bilReduction : Cents := 0
  deriving Repr, DecidableEq, Inhabited

namespace Disposition

/-- 40(1)(a)(i): proceeds less the adjusted cost base and outlays and expenses, if positive. -/
def excess (d : Disposition) : Cents :=
  d.proceeds - (d.adjustedCostBase + d.outlaysAndExpenses)

/-- 40(1)(a)(iii): the most the reserve can be: the lesser of a reasonable reserve (C) and
⅕ of the gain times the number of years by which 4 exceeds the preceding years (D). -/
def reserveLimit (d : Disposition) : Cents :=
  min d.reasonableReserve (d.excess * (4 - d.precedingYears) / 5)

/-- 40(1)(a): the gain for the year. -/
def gain (d : Disposition) : Cents :=
  let base := match d.priorYearReserve with
    | some r => r
    | none => d.excess
  base - min d.reserveClaimed d.reserveLimit

/-- 40(1)(b): the loss for the year (nil if disposed of before the year), and nil where
40(2)(g) or 40(3.4) makes it so. -/
def loss (d : Disposition) : Cents :=
  if d.lossNil || d.priorYearReserve.isSome then 0
  else d.adjustedCostBase + d.outlaysAndExpenses - d.proceeds

/-- 39(1)(a): a capital gain. -/
def capitalGain (d : Disposition) : Cents :=
  if d.capitalAccount.value && d.propertyClass != .excluded then d.gain else 0

/-- 39(1)(b): a capital loss. -/
def capitalLoss (d : Disposition) : Cents :=
  if d.capitalAccount.value && d.propertyClass != .excluded && d.propertyClass != .depreciable then d.loss else 0

/-- 39(1)(c): a business investment loss. -/
def businessInvestmentLoss (d : Disposition) : Cents :=
  if d.businessInvestment then d.capitalLoss - d.bilReduction else 0

/-- 38(a), (a.1)(i): the taxable capital gain, in half-cents: ½ of the capital gain, or nil. -/
def taxableCapitalGain (d : Disposition) : HalfCents :=
  if d.giftToQualifiedDonee then 0 else d.capitalGain

/-- 38(b): the allowable capital loss, in half-cents: ½ of the capital loss. -/
def allowableCapitalLoss (d : Disposition) : HalfCents := d.capitalLoss

/-- 38(c): the allowable business investment loss, in half-cents. -/
def allowableBusinessInvestmentLoss (d : Disposition) : HalfCents := d.businessInvestmentLoss

def isListed (d : Disposition) : Bool := d.propertyClass == .listedPersonal

end Disposition

/-! ## The year's totals -/

/-- The dispositions of a taxation year, and the listed-personal-property losses of other years
the taxpayer claims under 41(2)(b). -/
structure Year where
  dispositions : List Disposition
  lppLossesClaimed : Cents := 0
  deriving Repr, Inhabited

namespace Year

def sumBy (ds : List Disposition) (f : Disposition → Nat) : Nat := ds.foldl (· + f ·) 0

def nonListed (y : Year) : List Disposition := y.dispositions.filter (!·.isListed)
def listed (y : Year) : List Disposition := y.dispositions.filter (·.isListed)

/-- 3(b)(i)(A): taxable capital gains from property other than listed personal property. -/
def taxableCapitalGains (y : Year) : HalfCents := sumBy y.nonListed (·.taxableCapitalGain)

/-- 3(b)(ii): allowable capital losses from property other than listed personal property. -/
def allowableCapitalLosses (y : Year) : HalfCents := sumBy y.nonListed (·.allowableCapitalLoss)

/-- 38(c): allowable business investment losses. -/
def allowableBusinessInvestmentLosses (y : Year) : HalfCents :=
  sumBy y.dispositions (·.allowableBusinessInvestmentLoss)

/-- 41(2)(a): listed-personal-property gains less losses, if positive. -/
def lppExcess (y : Year) : Cents := sumBy y.listed (·.gain) - sumBy y.listed (·.loss)

/-- 41(2): the net gain, after the listed-personal-property losses of other years claimed
(at most the amount in 41(2)(a)). -/
def lppNetGain (y : Year) : Cents := y.lppExcess - min y.lppLossesClaimed y.lppExcess

/-- 41(1): the taxable net gain, in half-cents: ½ of the net gain. -/
def lppTaxableNetGain (y : Year) : HalfCents := y.lppNetGain

/-- 41(3): the year's listed-personal-property loss, to carry to other years. -/
def lppLoss (y : Year) : Cents := sumBy y.listed (·.loss) - sumBy y.listed (·.gain)

/-- Paragraph 3(b): taxable capital gains and the taxable net gain from listed personal
property, less allowable capital losses in excess of allowable business investment losses. -/
def paragraph3b (y : Year) : HalfCents :=
  (y.taxableCapitalGains + y.lppTaxableNetGain) - (y.allowableCapitalLosses - y.allowableBusinessInvestmentLosses)

/-- Net capital loss for the year, in half-cents, available under 111(1)(b) (not encoded): the
allowable capital losses (less ABILs) that 3(b) could not use. -/
def unusedAllowableCapitalLosses (y : Year) : HalfCents :=
  (y.allowableCapitalLosses - y.allowableBusinessInvestmentLosses) - (y.taxableCapitalGains + y.lppTaxableNetGain)

end Year

/-! ## From the loss rules -/

/-- A disposition whose loss is decided by paragraph 40(2)(g). -/
def ofParagraph40_2_g (f : Paragraph40_2_g.Facts) (capitalAccount : Answer := .fact true) : Disposition :=
  { description := f.sl.disposition.description, proceeds := f.sl.disposition.proceeds,
    adjustedCostBase := f.sl.disposition.adjustedCostBase, outlaysAndExpenses := f.sl.disposition.outlaysAndExpenses,
    capitalAccount, lossNil := Paragraph40_2_g.paragraph.holds f }

/-- A disposition whose loss is decided by subsection 40(3.4). -/
def ofSuspendedLoss (f : SuspendedLoss.Facts) (capitalAccount : Answer := .fact true) : Disposition :=
  { description := f.disposition.description, proceeds := f.disposition.proceeds,
    adjustedCostBase := f.disposition.adjustedCostBase, outlaysAndExpenses := f.disposition.outlaysAndExpenses,
    capitalAccount, lossNil := SuspendedLoss.suspended f }

/-! ## Truths about the computation -/

/-- A loss made nil by 40(2)(g) or 40(3.4) is no capital loss. -/
theorem capitalLoss_of_lossNil (d : Disposition) (h : d.lossNil = true) : d.capitalLoss = 0 := by
  simp [Disposition.capitalLoss, Disposition.loss, h]

/-- Depreciable property never gives a capital loss. -/
theorem capitalLoss_of_depreciable (d : Disposition) (h : d.propertyClass = .depreciable) : d.capitalLoss = 0 := by
  simp [Disposition.capitalLoss, h]

/-- The reserve never exceeds ⅕ of the gain for each year remaining of four, so after four
preceding years none is allowed. -/
theorem reserveLimit_after_four (d : Disposition) (h : 4 ≤ d.precedingYears) : d.reserveLimit = 0 := by
  simp [Disposition.reserveLimit, Nat.sub_eq_zero_of_le h]

/-- A gift of listed securities to a qualified donee is never taxed. -/
theorem taxableCapitalGain_of_gift (d : Disposition) (h : d.giftToQualifiedDonee = true) :
    d.taxableCapitalGain = 0 := by
  simp [Disposition.taxableCapitalGain, h]

/-- The taxable net gain from listed personal property never exceeds the year's excess of
listed-personal-property gains over losses. -/
theorem lppNetGain_le (y : Year) : y.lppNetGain ≤ y.lppExcess := Nat.sub_le _ _

end Canteen.ITA.CapitalGains

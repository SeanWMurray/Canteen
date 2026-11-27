import Canteen.Core.Money
import Canteen.Core.Finding

/-!
# Subsection 18(4): thin capitalization

*Income Tax Act*, as consolidated to 2026-10-29 (verbatim in `statute/ITA-18-4-5-equity-amount.txt` and
`statute/ITA-212-2-214-16-17.txt`):

**18(4)** In computing a corporation's income from a business or property, no deduction for the
proportion of the interest on outstanding debts to specified non-residents that (a) the excess of (i)
the average, over the calendar months ending in the year, of the greatest such debt at any time in the
month, over (ii) 1.5 times the equity amount, is of (b) that average.

**18(5) "equity amount"** of a corporation resident in Canada: (i) its retained earnings at the beginning
of the year (other than those of another corporation), plus (ii) the average of its contributed surplus
at the beginning of each calendar month ending in the year, to the extent contributed by a specified
non-resident shareholder, plus (iii) the average of its paid-up capital at the beginning of each such
month, excluding shares of classes owned by others than specified non-resident shareholders.

Which debts are "outstanding debts to specified non-residents" (to non-resident specified shareholders,
owning 25% or more of votes or value, and persons not at arm's length with them) and which shareholders
are specified non-resident shareholders are given, month by month, as amounts. Trusts (18(5)(b)) and
non-resident corporations ((c)), 18(4.1) to (8) and 214(16)(b) (the designation among payments) are
not encoded.

**214(16)(a)** Interest paid or credited by a corporation resident in Canada to a non-resident is deemed,
for Part XIII, a dividend to the extent it is not deductible because of 18(4); **214(17)(a)** interest
payable for the year and not paid is deemed paid immediately before the end of the year. **212(2)**
Part XIII tax of 25% (or the treaty rate, given) on dividends paid to a non-resident. Part XIII tax on
the interest that remains interest (212(1)(b), for non-arm's length interest) is not encoded.
-/

namespace Canteen.ITA.ThinCapitalization

/-- A calendar month ending in the year. -/
structure Month where
  /-- The greatest total at any time in the month of the outstanding debts to specified non-residents. -/
  maxDebt : Cents
  /-- At the beginning of the month: contributed surplus contributed by specified non-resident shareholders. -/
  contributedSurplus : Cents := 0
  /-- At the beginning of the month: paid-up capital of the classes owned by specified non-resident shareholders. -/
  paidUpCapital : Cents := 0
  deriving Repr, DecidableEq, Inhabited

structure Facts where
  /-- The interest on those debts, otherwise deductible. -/
  interest : Cents
  /-- (a)(i): retained earnings at the beginning of the year (not of another corporation). -/
  retainedEarnings : Cents := 0
  months : List Month
  /-- 212(2): the Part XIII rate on dividends to the non-resident, in percent (25, or less under a treaty). -/
  dividendRate : Nat := 25
  deriving Repr, DecidableEq, Inhabited

def average (f : Facts) (g : Month → Cents) : Cents :=
  if f.months.isEmpty then 0 else (f.months.map g).sum / f.months.length

/-- 18(4)(a)(i). -/
def averageDebt (f : Facts) : Cents := average f (·.maxDebt)

/-- 18(5) "equity amount", for a corporation resident in Canada. -/
def equityAmount (f : Facts) : Cents := f.retainedEarnings + average f (·.contributedSurplus) + average f (·.paidUpCapital)

/-- 18(4)(a): the excess debt. -/
def excessDebt (f : Facts) : Cents := averageDebt f - 3 * equityAmount f / 2

/-- 18(4): the interest denied. -/
def denied (f : Facts) : Cents := if averageDebt f = 0 then 0 else f.interest * excessDebt f / averageDebt f

def deductible (f : Facts) : Cents := f.interest - denied f

/-- 214(16)(a), (17)(a): the interest denied is deemed paid as a dividend (interest payable at the end of
the year deemed paid then), for Part XIII. -/
def deemedDividend (f : Facts) : Cents := denied f

/-- 212(2): Part XIII tax on the deemed dividend. -/
def partXIII (f : Facts) : Cents := deemedDividend f * f.dividendRate / 100

def explain (f : Facts) : Finding :=
  let c := formatCents
  ⟨denied f > 0, [
    ⟨s!"Average outstanding debts to specified non-residents: {c (averageDebt f)}. Equity amount: retained earnings {c f.retainedEarnings}, " ++
      s!"contributed surplus {c (average f (·.contributedSurplus))} and paid-up capital {c (average f (·.paidUpCapital))}: {c (equityAmount f)}.",
      "ITA 18(4)(a)(i); 18(5) \"equity amount\""⟩,
    ⟨s!"The debt over 1.5 times equity is {c (excessDebt f)}, so that proportion of the interest of {c f.interest}, {c (denied f)}, " ++
      s!"is not deductible; {c (deductible f)} is.", "ITA 18(4)"⟩,
    ⟨s!"The {c (deemedDividend f)} denied is deemed a dividend paid to the non-resident, with Part XIII tax at {f.dividendRate}%: " ++
      s!"{c (partXIII f)} to withhold.", "ITA 214(16)(a), (17)(a); 212(2)"⟩], []⟩

/-! ## Truths -/

private theorem mul_div_le (a b d : Nat) (h : b ≤ d) : a * b / d ≤ a := by
  rcases Nat.eq_zero_or_pos d with hd | hd
  · simp [hd]
  · calc a * b / d ≤ a * d / d := Nat.div_le_div_right (Nat.mul_le_mul_left _ h)
      _ = a := Nat.mul_div_cancel _ hd

/-- Never more than the interest. -/
theorem denied_le (f : Facts) : denied f ≤ f.interest := by
  unfold denied; split
  · exact Nat.zero_le _
  · exact mul_div_le _ _ _ (Nat.sub_le _ _)

/-- Within 1.5 to 1, all the interest is deductible. -/
theorem within_ratio (f : Facts) (h : averageDebt f ≤ 3 * equityAmount f / 2) : denied f = 0 := by
  have : excessDebt f = 0 := Nat.sub_eq_zero_of_le h
  simp [denied, this]

/-- Under a treaty rate below 25%, less withholding than at the statutory rate. -/
theorem treaty_le (f : Facts) (h : f.dividendRate ≤ 25) : partXIII f ≤ deemedDividend f * 25 / 100 :=
  Nat.div_le_div_right (Nat.mul_le_mul_left _ h)

end Canteen.ITA.ThinCapitalization

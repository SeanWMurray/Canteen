import Canteen.ITA.S82.Dividends

/-!
# Subsection 84(1): an increase in paid-up capital, and the deemed dividend

*Income Tax Act*, as consolidated to 2026-10-29 (verbatim in `statute/ITA-84-1-53-1-b.txt`):

**84(1)** Where a corporation resident in Canada increases the paid-up capital of a class of its shares,
otherwise than by (a) a stock dividend, (b) a transaction that increases its net assets (or decreases
its net liabilities) by at least the increase, (c) a transaction that reduces the paid-up capital of
its other classes by at least the increase, or (c.1) to (c.3) certain conversions of contributed
surplus, it is deemed to pay a dividend on the class equal to the increase less (d) the net asset
increase in (b), (e) the reduction in (c), and (f) the increase from a conversion in (c.1) to (c.3);
and each holder of the class immediately after is deemed to receive its proportion of it.

**53(1)(b)** The holder adds to the adjusted cost base of the share the dividends deemed received on it
by 84(1), except (for a corporation) those deducted under 112(1) that would be subject to 55(2) if paid
as a separate dividend.

Whether contributed surplus qualifies under (c.1) to (c.3) is a fact (the amount converted that
qualifies). The holder's proportion is rounded down to the cent.
-/

namespace Canteen.ITA.PaidUpCapitalIncrease

structure Facts where
  description : String
  corporationResident : Bool := true
  /-- The increase in the paid-up capital of the class. -/
  increase : Cents
  /-- (a): by payment of a stock dividend. -/
  stockDividend : Bool := false
  /-- (b), (d): the increase in net assets (or decrease in net liabilities) from the transaction. -/
  netAssetIncrease : Cents := 0
  /-- (c), (e): the reduction in the paid-up capital of the other classes. -/
  otherClassesReduction : Cents := 0
  /-- (c.1) to (c.3), (f): the part of the increase from a qualifying conversion of contributed surplus. -/
  qualifyingSurplus : Cents := 0
  /-- The holder's shares of the class, and all the shares of the class, immediately after. -/
  sharesHeld : Nat
  sharesOutstanding : Nat
  deriving Repr, DecidableEq, Inhabited

/-- 84(1): the dividend the corporation is deemed to pay. -/
def dividendPaid (f : Facts) : Cents :=
  if f.corporationResident && !f.stockDividend then
    f.increase - (f.netAssetIncrease + f.otherClassesReduction + f.qualifyingSurplus)
  else 0

/-- The holder's proportion. -/
def dividend (f : Facts) : Cents :=
  if f.sharesOutstanding = 0 then 0 else dividendPaid f * f.sharesHeld / f.sharesOutstanding

/-- 53(1)(b): added to the holder's adjusted cost base; `excluded` is the part a corporate holder
deducted under 112(1) that would be subject to 55(2) as a separate dividend. -/
def costAddition (f : Facts) (excluded : Cents := 0) : Cents := dividend f - excluded

/-- For an individual holder: the dividend, not eligible unless designated (82(1)). -/
def asDividend (f : Facts) (eligible : Bool := false) : Dividends.Dividend :=
  { description := s!"the dividend deemed by 84(1) on {f.description}", amount := dividend f, eligible }

def explain (f : Facts) : Finding :=
  let c := formatCents
  ⟨dividendPaid f > 0, [
    ⟨s!"The paid-up capital of {f.description} increases by {c f.increase}" ++
      (if f.stockDividend then ", by a stock dividend: no dividend is deemed." else
        s!", against a net asset increase of {c f.netAssetIncrease}, a reduction of other classes of {c f.otherClassesReduction} " ++
        s!"and qualifying surplus of {c f.qualifyingSurplus}: a dividend of {c (dividendPaid f)} is deemed paid."),
      "ITA 84(1)"⟩,
    ⟨s!"The holder's {f.sharesHeld} of {f.sharesOutstanding} shares receive {c (dividend f)}, added to their adjusted cost base.",
      "ITA 84(1); 53(1)(b)"⟩], []⟩

/-! ## Truths about 84(1) -/

/-- The dividend never exceeds the increase. -/
theorem dividendPaid_le (f : Facts) : dividendPaid f ≤ f.increase := by
  unfold dividendPaid; split
  · exact Nat.sub_le _ _
  · exact Nat.zero_le _

/-- Paid for in full: an increase matched by net assets is no dividend. -/
theorem paid_for (f : Facts) (h : f.increase ≤ f.netAssetIncrease) : dividendPaid f = 0 := by
  unfold dividendPaid; split
  · exact Nat.sub_eq_zero_of_le (Nat.le_trans h (Nat.le_trans (Nat.le_add_right _ _) (Nat.le_add_right _ _)))
  · rfl

/-- A sole holder adds the whole dividend to cost: the paid-up capital increase is matched by cost. -/
theorem sole_holder (f : Facts) (h : f.sharesHeld = f.sharesOutstanding) (hp : 0 < f.sharesOutstanding) :
    costAddition f = dividendPaid f := by
  simp [costAddition, dividend, h, Nat.pos_iff_ne_zero.mp hp, Nat.mul_div_cancel _ hp]

end Canteen.ITA.PaidUpCapitalIncrease

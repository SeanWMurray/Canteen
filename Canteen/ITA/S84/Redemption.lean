import Canteen.ITA.S38.CapitalGains
import Canteen.ITA.S82.Dividends
import Canteen.ITA.S55.IntercorporateDividends

/-!
# Subsection 84(3): a redemption of shares, and the deemed dividend

*Income Tax Act*, as consolidated to 2026-10-29 (verbatim in `statute/ITA-84-3-54-j.txt`):

> 84(3) Where at any time after December 31, 1977 a corporation resident in Canada has redeemed,
> acquired or cancelled in any manner whatever (otherwise than by way of a transaction described
> in subsection 84(2)) any of the shares of any class of its capital stock, (a) the corporation
> shall be deemed to have paid at that time a dividend on a separate class of shares comprising
> the shares so redeemed, acquired or cancelled equal to the amount, if any, by which the amount
> paid by the corporation on the redemption, acquisition or cancellation … of those shares exceeds
> the paid-up capital in respect of those shares immediately before that time; and (b) a dividend
> shall be deemed to have been received at that time by each person who held any of the shares of
> that separate class at that time equal to that portion of the amount of the excess … that the
> number of those shares held by the person immediately before that time is of the total number of
> shares of that separate class that the corporation has redeemed, acquired or cancelled …

Section 54 "proceeds of disposition" does not include (j) an amount to the extent it is deemed by
84(3) to be a dividend received, except to the extent the dividend is deemed (i) by 55(2)(b) to be
proceeds of disposition of the share.

So the holder's proceeds are its share of the amount paid less its deemed dividend (in effect, its
share of the paid-up capital), plus any part of the dividend 55(2)(b) turns back into proceeds.
The holder's shares of the amount paid and of the dividend are rounded down to the cent. Not
encoded: 84(2) (distributions on winding-up), 84(3)'s exclusions in 84(6) to (9), and 88(2)(b)(ii).
-/

namespace Canteen.ITA.Redemption

structure Facts where
  /-- The shares, e.g. `"the preferred shares of Opco"`. -/
  description : String
  /-- The corporation is resident in Canada. -/
  corporationResident : Bool := true
  /-- The amount paid on the redemption, for all the shares of the class redeemed at that time. -/
  amountPaid : Cents
  /-- The paid-up capital of those shares immediately before. -/
  paidUpCapital : Cents
  /-- The number of those shares redeemed, and how many of them the holder held. -/
  sharesRedeemed : Nat
  sharesHeld : Nat
  /-- The holder's adjusted cost base of its shares. -/
  adjustedCostBase : Cents
  deriving Repr, DecidableEq, Inhabited

/-- 84(3)(a): the dividend the corporation is deemed to pay. -/
def dividendPaid (f : Facts) : Cents := if f.corporationResident then f.amountPaid - f.paidUpCapital else 0

/-- The holder's share of an amount for the class, by number of shares. -/
def share (f : Facts) (x : Cents) : Cents := if f.sharesRedeemed = 0 then 0 else x * f.sharesHeld / f.sharesRedeemed

/-- 84(3)(b): the dividend the holder is deemed to receive. -/
def dividend (f : Facts) : Cents := share f (dividendPaid f)

/-- The holder's share of the amount paid. -/
def received (f : Facts) : Cents := share f f.amountPaid

/-- 54 "proceeds of disposition" (j): the holder's proceeds, with `caught` the part of its dividend
that 55(2)(b) deems proceeds. -/
def proceeds (f : Facts) (caught : Cents := 0) : Cents := received f - dividend f + min caught (dividend f)

/-- The holder's disposition, for the capital gains computation. -/
def disposition (f : Facts) (caught : Cents := 0) : CapitalGains.Disposition :=
  { description := f.description, proceeds := proceeds f caught, adjustedCostBase := f.adjustedCostBase }

/-- For an individual holder: the dividend, not eligible unless designated (82(1)). -/
def asDividend (f : Facts) (eligible : Bool := false) : Dividends.Dividend :=
  { description := s!"the dividend deemed by 84(3) on {f.description}", amount := dividend f, eligible }

/-- For a corporate holder: the dividend, for 112(1) and 55(2), on a redemption. -/
def asIntercorporate (f : Facts) (reducesGain : Answer) (safeIncome : Cents)
    (unrelatedEvents : List IntercorporateDividends.UnrelatedEvent := []) : IntercorporateDividends.Facts :=
  { description := s!"the dividend deemed by 84(3) on {f.description}", amount := dividend f, onRedemption := true,
    reducesGain, safeIncome, unrelatedEvents }

/-- A corporate holder's disposition, with 55(2)(b) applied. -/
def corporateDisposition (f : Facts) (d : IntercorporateDividends.Facts) : CapitalGains.Disposition :=
  disposition f (IntercorporateDividends.proceedsAddition d)

def explain (f : Facts) (caught : Cents := 0) : Finding :=
  let c := formatCents
  ⟨dividend f > 0,
    [⟨s!"On the redemption of {f.description}, the corporation paid {c f.amountPaid} for shares with paid-up capital of " ++
        s!"{c f.paidUpCapital}, so it is deemed to pay a dividend of {c (dividendPaid f)}.", "ITA 84(3)(a)"⟩,
     ⟨s!"The holder held {f.sharesHeld} of the {f.sharesRedeemed} shares, so it is deemed to receive a dividend of {c (dividend f)}.",
        "ITA 84(3)(b)"⟩] ++
    (if caught > 0 then
      [⟨s!"Of that dividend, {c (min caught (dividend f))} is deemed by 55(2)(b) to be proceeds of disposition.", "ITA 55(2)(b)"⟩]
    else []) ++
    [⟨s!"The holder's proceeds of disposition are {c (proceeds f caught)}: the {c (received f)} received, less the dividend" ++
        (if caught > 0 then ", plus the part 55(2)(b) restores." else "."), "ITA 54 \"proceeds of disposition\" (j)"⟩], []⟩

/-! ## Truths about redemptions -/

/-- Paid no more than paid-up capital, there is no dividend. -/
theorem no_dividend_within_puc (f : Facts) (h : f.amountPaid ≤ f.paidUpCapital) : dividend f = 0 := by
  simp [dividend, dividendPaid, share, Nat.sub_eq_zero_of_le h]

/-- A single holder of all the shares: the dividend and the proceeds add up to the amount paid,
and the proceeds are the paid-up capital (when the amount paid covers it). -/
theorem sole_holder (f : Facts) (hr : f.corporationResident = true) (hs : f.sharesHeld = f.sharesRedeemed)
    (hn : 0 < f.sharesRedeemed) (hp : f.paidUpCapital ≤ f.amountPaid) :
    dividend f + proceeds f = f.amountPaid ∧ proceeds f = f.paidUpCapital := by
  have hne : f.sharesRedeemed ≠ 0 := Nat.pos_iff_ne_zero.mp hn
  have hd : dividend f = f.amountPaid - f.paidUpCapital := by
    simp [dividend, dividendPaid, share, hr, hne, hs, Nat.mul_div_cancel _ hn]
  have hrec : received f = f.amountPaid := by simp [received, share, hne, hs, Nat.mul_div_cancel _ hn]
  have hpr : proceeds f = f.paidUpCapital := by
    simp only [proceeds, hrec, hd, Nat.zero_min, Nat.add_zero]
    exact Nat.sub_sub_self hp
  refine ⟨?_, hpr⟩
  rw [hpr, hd]
  exact Nat.sub_add_cancel hp

/-- 55(2)(b) turns the caught part of the dividend back into proceeds, never more than the dividend. -/
theorem caught_restores (f : Facts) (caught : Cents) : proceeds f caught ≤ proceeds f + dividend f := by
  simp only [proceeds, Nat.zero_min, Nat.add_zero]
  exact Nat.add_le_add_left (Nat.min_le_right _ _) _

end Canteen.ITA.Redemption

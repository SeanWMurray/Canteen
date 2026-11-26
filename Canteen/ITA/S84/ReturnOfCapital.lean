import Canteen.ITA.S38.CapitalGains

/-!
# Returns of capital: 84(4), (4.1), 53(2)(a)(ii), 40(3) and 53(1)(a)

*Income Tax Act*, as consolidated to 2026-10-29 (verbatim in `statute/ITA-84-4-40-3-53.txt`):

**84(4)** Where a corporation resident in Canada has reduced the paid-up capital of a class of its
shares (otherwise than by a redemption, acquisition or cancellation, or a transaction in 84(2) or
(4.1)), (a) it is deemed to have paid a dividend equal to the amount paid on the reduction over the
amount by which the paid-up capital was reduced, and (b) each holder is deemed to receive its
share by number of shares.

**84(4.1)** Any amount paid by a public corporation on a reduction of paid-up capital … is deemed
a dividend, unless (a) it may reasonably be considered derived from proceeds of disposition realized
outside the ordinary course of business within the 24 months before the payment, and (b) no amount
derived from those proceeds was paid on a previous reduction of paid-up capital.

**53(2)(a)(ii)** The adjusted cost base of the share is reduced by any amount received on a
reduction of its paid-up capital, except to the extent deemed a dividend by 84(4) or (4.1).

**40(3)** Where the deductions from the adjusted cost base exceed its cost and additions, the excess
is deemed a gain from a disposition of the property; **53(1)(a)** and that gain is added back to the
adjusted cost base.

Whether a public corporation's distribution meets 84(4.1)(a) and (b) is a fact. Where it does, the
reduction is read as falling under 84(4) instead (only an excess over the paid-up capital reduced is
a dividend). Each holder's share is rounded down to the cent.
-/

namespace Canteen.ITA.ReturnOfCapital

structure Facts where
  /-- The shares, e.g. `"the common shares of Opco"`. -/
  description : String
  /-- The corporation is resident in Canada. -/
  corporationResident : Bool := true
  /-- The corporation is a public corporation (84(4.1)). -/
  publicCorporation : Bool := false
  /-- 84(4.1)(a), (b): the amount is derived from proceeds of a disposition outside the ordinary
  course of business in the 24 months before, not paid out on an earlier reduction. -/
  fromExtraordinaryProceeds : Bool := false
  /-- The amount paid on the reduction, for the whole class. -/
  amountPaid : Cents
  /-- The amount by which the class's paid-up capital was reduced. -/
  pucReduction : Cents
  /-- The holder's shares and the class's issued shares, immediately before. -/
  sharesHeld : Nat
  sharesOutstanding : Nat
  /-- The holder's cost and additions to it (53(1)), and earlier deductions (53(2)), before this one. -/
  costAndAdditions : Cents
  priorDeductions : Cents := 0
  deriving Repr, DecidableEq, Inhabited

/-- 84(4.1) applies: a public corporation's distribution that does not meet (a) and (b). -/
def under4_1 (f : Facts) : Bool := f.corporationResident && f.publicCorporation && !f.fromExtraordinaryProceeds

/-- 84(4)(a), 84(4.1): the dividend the corporation is deemed to pay. -/
def dividendPaid (f : Facts) : Cents :=
  if under4_1 f then f.amountPaid
  else if f.corporationResident then f.amountPaid - f.pucReduction
  else 0

def share (f : Facts) (x : Cents) : Cents := if f.sharesOutstanding = 0 then 0 else x * f.sharesHeld / f.sharesOutstanding

/-- 84(4)(b): the holder's dividend. -/
def dividend (f : Facts) : Cents := share f (dividendPaid f)

/-- The holder's share of the amount paid. -/
def received (f : Facts) : Cents := share f f.amountPaid

/-- 53(2)(a)(ii): the return of capital, which reduces the adjusted cost base. -/
def returnOfCapital (f : Facts) : Cents := received f - dividend f

/-- 40(3): the excess of the deductions over the cost and additions, deemed a gain. -/
def deemedGain (f : Facts) : Cents := (f.priorDeductions + returnOfCapital f) - f.costAndAdditions

/-- The adjusted cost base after, with the 40(3) gain added back under 53(1)(a). -/
def adjustedCostBase (f : Facts) : Cents :=
  (f.costAndAdditions + deemedGain f) - (f.priorDeductions + returnOfCapital f)

/-- The 40(3) gain, as a disposition for the capital gains computation. -/
def disposition (f : Facts) : CapitalGains.Disposition :=
  { description := s!"{f.description} (40(3) deemed gain)", proceeds := deemedGain f, adjustedCostBase := 0 }

def explain (f : Facts) : Finding :=
  let c := formatCents
  ⟨dividend f > 0 || deemedGain f > 0,
    [⟨s!"The holder receives {c (received f)} on the reduction of paid-up capital of {f.description}.", "ITA 84(4)"⟩,
     (if under4_1 f then
        ⟨s!"The corporation is a public corporation and the amount is not from extraordinary proceeds, so all of it is a dividend: {c (dividend f)}.",
          "ITA 84(4.1)"⟩
      else
        ⟨s!"The amount paid exceeds the paid-up capital reduced by {c (dividendPaid f)}, so the holder's dividend is {c (dividend f)}.",
          "ITA 84(4)(a), (b)"⟩),
     ⟨s!"The rest, {c (returnOfCapital f)}, reduces the adjusted cost base.", "ITA 53(2)(a)(ii)"⟩] ++
    (if deemedGain f > 0 then
      [⟨s!"That takes the adjusted cost base below nil by {c (deemedGain f)}, a gain from a disposition of the shares, which is " ++
          "added back to bring the adjusted cost base to nil.", "ITA 40(3); 53(1)(a)"⟩]
    else [⟨s!"The adjusted cost base is now {c (adjustedCostBase f)}.", "ITA 54 \"adjusted cost base\""⟩]), []⟩

/-! ## Truths about returns of capital -/

private theorem sub_add_sub (r d : Nat) (h : d ≤ r) : (r - d) + d = r := Nat.sub_add_cancel h

/-- A private corporation paying out exactly the paid-up capital it reduces pays no dividend. -/
theorem no_dividend_at_puc (f : Facts) (hp : f.publicCorporation = false) (h : f.amountPaid ≤ f.pucReduction) :
    dividend f = 0 := by
  simp [dividend, dividendPaid, under4_1, hp, share, Nat.sub_eq_zero_of_le h]

/-- The return of capital and the dividend add up to what the holder received. -/
theorem split (f : Facts) (h : dividend f ≤ received f) : returnOfCapital f + dividend f = received f :=
  sub_add_sub _ _ h

private theorem acb_floor (c d g : Nat) (hg : g = d - c) : (c + g) - d = c - d := by omega

/-- The adjusted cost base never goes below nil: any excess is a 40(3) gain, added back. -/
theorem acb_after (f : Facts) :
    adjustedCostBase f = f.costAndAdditions - (f.priorDeductions + returnOfCapital f) :=
  acb_floor _ _ _ rfl

end Canteen.ITA.ReturnOfCapital

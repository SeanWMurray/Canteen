import Canteen.ITA.S38.CapitalGains

/-!
# The capital dividend account (89(1)) and capital dividends (83(2))

*Income Tax Act*, as consolidated to 2026-10-29 (verbatim in `statute/ITA-83-2-89-1-cda.txt`):

**89(1) "capital dividend account"** of a corporation at a particular time: (a) the amount by
which (i) the total, for each disposition in the period (from the corporation's first taxation
year beginning after it last became a private corporation), of its capital gain less (B) the
taxable capital gain and (C) the part that accrued while the property was held by a public (or
non-resident-controlled, or exempt) corporation, exceeds (ii) the like total for its capital losses
less the allowable capital losses; plus (b) capital dividends received; plus (d) life insurance
proceeds received on a death, less the policy's adjusted cost basis; plus (c), (c.1), (c.2) and
(e) to (h); less the capital dividends that became payable in the period.

**83(2)** Where a dividend becomes payable by a private corporation and it elects in respect of
the full amount, (a) the dividend is deemed a capital dividend to the extent of the capital
dividend account immediately before, and (b) no part of it is included in any shareholder's income.

The account is kept in half-cents, since the untaxed half of an odd number of cents is a half-cent.
For each disposition, the untaxed part of a gain is the gain less its taxable capital gain (so a
gift of listed securities under 38(a.1)(i), taxed at nil, adds the whole gain), and likewise for
losses. The (C) amounts, (b), (d) and the other paragraphs are given. The excess of an elected
dividend over the account is subject to Part III tax (184(2)) unless the 184(3) election is made;
neither is encoded.
-/

namespace Canteen.ITA.CapitalDividendAccount

open CapitalGains (HalfCents Disposition formatHalfCents)

structure Facts where
  /-- The corporation is a private corporation. -/
  privateCorporation : Bool := true
  /-- Its dispositions in the period. -/
  dispositions : List Disposition := []
  /-- (a)(i)(C) less (a)(ii)(C): the untaxed parts that accrued while not a private corporation (net), in half-cents. -/
  accruedOutside : HalfCents := 0
  /-- (b): capital dividends received, in cents. -/
  capitalDividendsReceived : Cents := 0
  /-- (d): life insurance proceeds received on a death, less the adjusted cost basis of the policy, in cents. -/
  lifeInsurance : Cents := 0
  /-- (c), (c.1), (c.2), (e) to (h), in cents. -/
  otherAdditions : Cents := 0
  /-- Capital dividends that became payable in the period, in cents. -/
  capitalDividendsPaid : Cents := 0
  deriving Repr, Inhabited

/-- The untaxed part of a capital gain, in half-cents: the gain less the taxable capital gain. -/
def untaxedGain (d : Disposition) : HalfCents := 2 * d.capitalGain - d.taxableCapitalGain

/-- The unallowed part of a capital loss, in half-cents. -/
def unallowedLoss (d : Disposition) : HalfCents := 2 * d.capitalLoss - d.allowableCapitalLoss

def sumBy (ds : List Disposition) (g : Disposition → Nat) : Nat := (ds.map g).sum

/-- (a). -/
def paraA (f : Facts) : HalfCents :=
  (sumBy f.dispositions untaxedGain - f.accruedOutside) - sumBy f.dispositions unallowedLoss

/-- The capital dividend account, in half-cents. -/
def account (f : Facts) : HalfCents :=
  (paraA f + 2 * f.capitalDividendsReceived + 2 * f.lifeInsurance + 2 * f.otherAdditions) - 2 * f.capitalDividendsPaid

/-- 83(2)(a): the part of an elected dividend that is a capital dividend, in half-cents. -/
def capitalDividend (f : Facts) (dividend : Cents) : HalfCents :=
  if f.privateCorporation then min (2 * dividend) (account f) else 0

/-- The excess of an elected dividend over the account, in half-cents (Part III tax, not encoded). -/
def excessElection (f : Facts) (dividend : Cents) : HalfCents :=
  if f.privateCorporation then 2 * dividend - account f else 0

def explain (f : Facts) (dividend : Cents) : Finding :=
  let h := formatHalfCents
  ⟨capitalDividend f dividend > 0,
    [⟨s!"The untaxed part of the corporation's capital gains, less the unallowed part of its capital losses, is {h (paraA f)}.",
        "ITA 89(1) \"capital dividend account\" (a)"⟩,
     ⟨s!"With capital dividends received, life insurance proceeds and other additions, less capital dividends paid, the " ++
        s!"capital dividend account is {h (account f)}.", "ITA 89(1) \"capital dividend account\""⟩] ++
    (if f.privateCorporation then
      [⟨s!"Of the {formatCents dividend} dividend elected on, {h (capitalDividend f dividend)} is a capital dividend" ++
          (if excessElection f dividend > 0 then s!", and {h (excessElection f dividend)} exceeds the account." else "."),
          "ITA 83(2)(a)"⟩,
       ⟨"No part of it is included in computing any shareholder's income.", "ITA 83(2)(b)"⟩]
    else [⟨"The corporation is not a private corporation, so it cannot elect under subsection 83(2).", "ITA 83(2)"⟩]), []⟩

/-! ## Truths about the capital dividend account -/

/-- A capital dividend never exceeds the account. -/
theorem capitalDividend_le_account (f : Facts) (d : Cents) : capitalDividend f d ≤ account f := by
  unfold capitalDividend; split
  · exact Nat.min_le_right _ _
  · exact Nat.zero_le _

private theorem halves (g l : Nat) : (2 * g - g) - (2 * l - l) = g - l := by omega

/-- **Integration.** A private corporation with one capital gain taxed at ½ (and nothing else) can
pay out the untaxed half as a capital dividend: the account, in half-cents, equals the gain in cents. -/
theorem untaxed_half (d : Disposition) (hd : d.giftToQualifiedDonee = false) :
    account { dispositions := [d] } = d.capitalGain - d.capitalLoss := by
  simp only [account, paraA, sumBy, untaxedGain, unallowedLoss, List.map_cons, List.map_nil, List.sum_cons, List.sum_nil,
    Nat.add_zero, Nat.sub_zero, Nat.mul_zero]
  simp only [Disposition.taxableCapitalGain, Disposition.allowableCapitalLoss, hd, Bool.false_eq_true, ite_false]
  exact halves _ _

end Canteen.ITA.CapitalDividendAccount

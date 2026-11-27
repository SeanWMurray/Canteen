import Canteen.Core.StatuteSyntax
import Canteen.ITA.S38.CapitalGains
import Canteen.ITA.S82.Dividends

/-!
# Subsection 84(2): a distribution on winding-up, discontinuance or reorganization

*Income Tax Act*, as consolidated to 2026-10-29 (verbatim in `statute/ITA-84-2.txt`):

**84(2)** Where funds or property of a corporation resident in Canada have been distributed or otherwise
appropriated in any manner whatever to or for the benefit of the shareholders of a class, on the
winding-up, discontinuance or reorganization of its business, the corporation is deemed to have paid a
dividend on the class equal to the amount by which (a) the funds or property distributed exceed (b) the
reduction in the paid-up capital of the class; and each holder is deemed to receive its proportion.

Section 54 "proceeds of disposition" (j) excludes an amount deemed by 84(2) to be a dividend, so the
holder's proceeds are its share of what was distributed less its dividend. Whether a distribution is
"on the winding-up, discontinuance or reorganization" of the business, "in any manner whatever", is
often a judgment call (the surplus-stripping cases, for example MacDonald, 2013 FCA 110, and Pomerleau,
2018 TCC 89). Shares are rounded down to the cent. Not encoded: 84(2)'s interaction with 84.1 and 88(2).
-/

namespace Canteen.ITA.WindingUpDividend

structure Facts where
  description : String
  corporationResident : Bool := true
  /-- Distributed or appropriated on the winding-up, discontinuance or reorganization of the business. Often a judgment call. -/
  onWindingUp : Answer := .fact true
  /-- (a): the amount or value of the funds or property distributed to the class. -/
  distributed : Cents
  /-- (b): the reduction in the paid-up capital of the class on the distribution. -/
  pucReduction : Cents
  sharesHeld : Nat
  sharesOutstanding : Nat
  /-- The holder's adjusted cost base of its shares. -/
  adjustedCostBase : Cents
  deriving Repr, Inhabited

/-- Subsection 84(2). -/
statute applies (f : Facts) named "subsection 84(2)" cites "ITA 84(2)"
  applies where
    | "resident" f.corporationResident
        => "The corporation is resident in Canada."
        else "The corporation is not resident in Canada."
    | "winding-up" judgments f.onWindingUp.judgments f.onWindingUp.value
        => "Its funds or property were distributed or appropriated to the shareholders on the winding-up, discontinuance or reorganization of its business."
        else "The distribution was not on the winding-up, discontinuance or reorganization of its business."

/-- The dividend the corporation is deemed to pay: (a) − (b). -/
def dividendPaid (f : Facts) : Cents := if applies.holds f then f.distributed - f.pucReduction else 0

def share (f : Facts) (x : Cents) : Cents := if f.sharesOutstanding = 0 then 0 else x * f.sharesHeld / f.sharesOutstanding

/-- The holder's dividend, and what it received. -/
def dividend (f : Facts) : Cents := share f (dividendPaid f)
def received (f : Facts) : Cents := share f f.distributed

/-- 54 "proceeds of disposition" (j): what the holder received, less the deemed dividend. -/
def proceeds (f : Facts) : Cents := received f - dividend f

def disposition (f : Facts) : CapitalGains.Disposition :=
  { description := f.description, proceeds := proceeds f, adjustedCostBase := f.adjustedCostBase }

/-- For an individual holder: a non-eligible dividend unless designated. -/
def asDividend (f : Facts) (eligible : Bool := false) : Dividends.Dividend :=
  { description := s!"the dividend deemed by 84(2) on {f.description}", amount := dividend f, eligible }

def explain (f : Facts) : Finding :=
  let e := applies.explain f
  let c := formatCents
  ⟨e.conclusion, e.steps ++
    (if applies.holds f then
      [⟨s!"{c f.distributed} was distributed, and the paid-up capital reduced by {c f.pucReduction}: a dividend of {c (dividendPaid f)}, " ++
        s!"of which the holder's {f.sharesHeld} of {f.sharesOutstanding} shares receive {c (dividend f)}.", "ITA 84(2)"⟩,
       ⟨s!"The holder's proceeds of disposition are {c (proceeds f)}.", "ITA 54 \"proceeds of disposition\" (j)"⟩] else []),
    e.reliesOn⟩

/-! ## Truths -/

/-- A sole shareholder's proceeds are the paid-up capital returned (when no more than what was distributed). -/
theorem sole_proceeds (f : Facts) (h : applies.holds f = true) (hs : f.sharesHeld = f.sharesOutstanding)
    (hp : 0 < f.sharesOutstanding) (hr : f.pucReduction ≤ f.distributed) : proceeds f = f.pucReduction := by
  have hne : f.sharesOutstanding ≠ 0 := Nat.pos_iff_ne_zero.mp hp
  simp only [proceeds, received, dividend, share, dividendPaid, h, ite_true, hs, hne, ite_false, Nat.mul_div_cancel _ hp]
  exact Nat.sub_sub_self hr

/-- The dividend never exceeds what was distributed. -/
theorem dividendPaid_le (f : Facts) : dividendPaid f ≤ f.distributed := by
  unfold dividendPaid; split
  · exact Nat.sub_le _ _
  · exact Nat.zero_le _

end Canteen.ITA.WindingUpDividend

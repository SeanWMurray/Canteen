import Canteen.Core.StatuteSyntax
import Canteen.ITA.S82.Dividends
import Canteen.Core.Answer

/-!
# Subsection 74.4(2): transfers and loans to corporations (corporate attribution)

*Income Tax Act*, as consolidated to 2026-10-29 (verbatim in `statute/ITA-74.4-1-2-74.5-5.txt`):

> (2) Where an individual has transferred or lent property … to a corporation and one of the main
> purposes of the transfer or loan may reasonably be considered to be to reduce the income of the
> individual and to benefit … a person who is a designated person in respect of the individual, in
> computing the income of the individual for any taxation year that includes a period after the loan
> or transfer throughout which (a) the person is a designated person … and would have been a
> specified shareholder of the corporation [10% or more of a class, read narrowly], (b) the
> individual was resident in Canada, and (c) the corporation was not a small business corporation,
> the individual shall be deemed to have received as interest in the year the amount, if any, by
> which (d) the amount that would be interest on the outstanding amount of the loan or transfer …
> computed … at the prescribed rate of interest … exceeds the total of (e) any interest received in
> the year by the individual in respect of the transfer or loan …, (f) all amounts included in the
> individual's income … pursuant to subsection 82(1) … in respect of taxable dividends received …
> on shares that were received from the corporation as consideration for the transfer … that were
> excluded consideration …, and (g) [dividends taxed as split income of the designated person].

**74.5(5)** A designated person is (a) the individual's spouse or common-law partner, or (b) a person
under 18 who does not deal with the individual at arm's length, or is the individual's niece or nephew.

The main-purpose test, and whether the corporation is a small business corporation ("all or
substantially all"), are facts or judgment calls. The prescribed rate is given in basis points a
year, and the period in months; the deemed interest is rounded down to the cent. The dividends in
(f) are the grossed-up amounts 82(1) includes. Not encoded: 74.4(3) to (11), and 74.5(1) as it
applies to 74.4.
-/

namespace Canteen.ITA.CorporateAttribution

structure Facts where
  taxationYear : Nat
  /-- A designated person (74.5(5)) benefits, and would be a specified shareholder (10% of a class). -/
  designatedShareholder : Bool := true
  /-- One of the main purposes is to reduce the individual's income and benefit a designated person. -/
  mainPurpose : Answer
  /-- (b): the individual was resident in Canada throughout the period. -/
  resident : Bool := true
  /-- (c): the corporation was a small business corporation (often a judgment call). -/
  smallBusinessCorporation : Answer := .fact false
  /-- (d): the outstanding amount of the loan or transfer. -/
  outstanding : Cents
  /-- The prescribed rate, in basis points a year (100 = 1%). -/
  prescribedRate : Nat
  /-- The months of the year in the period. -/
  months : Nat := 12
  /-- (e): interest received on the loan or transfer. -/
  interestReceived : Cents := 0
  /-- (f): taxable dividends received in the year on the shares taken as consideration (excluded consideration). -/
  dividendsOnConsideration : List Dividends.Dividend := []
  /-- (g): the designated person's split income dividends that are part of the benefit. -/
  splitIncomeDividends : Cents := 0
  deriving Repr, Inhabited

/-- Subsection 74.4(2). -/
statute applies (f : Facts) named "subsection 74.4(2)" cites "ITA 74.4(2)"
  applies where
    | "main purpose" judgments f.mainPurpose.judgments f.mainPurpose.value
        => "One of the main purposes of the transfer or loan may reasonably be considered to be to reduce the individual's income and benefit a designated person."
        else "None of the main purposes of the transfer or loan is to reduce the individual's income and benefit a designated person."
    | (a) f.designatedShareholder
        => "A designated person (a spouse or common-law partner, or a minor child, niece or nephew) is a specified shareholder of the corporation."
        else "No designated person is a specified shareholder of the corporation."
    | (b) f.resident
        => "The individual was resident in Canada."
        else "The individual was not resident in Canada."
  except where
    | (c) judgments f.smallBusinessCorporation.judgments f.smallBusinessCorporation.value
        => "The corporation was a small business corporation throughout the period."
        else "The corporation was not a small business corporation."

/-- (d): interest at the prescribed rate on the outstanding amount, for the period. -/
def prescribedInterest (f : Facts) : Cents := f.outstanding * f.prescribedRate * f.months / (10000 * 12)

/-- (f): the dividends 82(1) includes, gross-up and all. -/
def dividendsIncluded (f : Facts) : Cents :=
  Dividends.inclusion { taxationYear := f.taxationYear, dividends := f.dividendsOnConsideration }

/-- The amount deemed received as interest. -/
def deemedInterest (f : Facts) : Cents :=
  if applies.holds f then prescribedInterest f - (f.interestReceived + dividendsIncluded f + f.splitIncomeDividends) else 0

def explain (f : Facts) : Finding :=
  let e := applies.explain f
  let c := formatCents
  if !applies.holds f then e else
  ⟨true, e.steps ++ [
    ⟨s!"Interest at the prescribed rate on {c f.outstanding} for {f.months} months would be {c (prescribedInterest f)}; less interest " ++
      s!"received of {c f.interestReceived}, dividends included of {c (dividendsIncluded f)}, and split income dividends of " ++
      s!"{c f.splitIncomeDividends}, the individual is deemed to receive {c (deemedInterest f)} of interest.", "ITA 74.4(2)(d)–(g)"⟩],
    e.reliesOn⟩

/-- Subsection 74.4(2), as a rule, with the amount. -/
def rule : Rule Facts where
  name := "subsection 74.4(2)"
  citation := "ITA 74.4(2)"
  holds := applies.holds
  explain := explain
  sound := fun f => by unfold explain; split <;> simp_all

/-! ## Truths about corporate attribution -/

/-- A small business corporation is outside 74.4(2). -/
theorem not_for_small_business (f : Facts) (h : f.smallBusinessCorporation.value = true) : deemedInterest f = 0 := by
  simp [deemedInterest, applies, h]

/-- **Paying dividends on the freeze shares.** Dividends included at least the prescribed interest
leave nothing deemed. -/
theorem dividends_cover (f : Facts) (h : prescribedInterest f ≤ dividendsIncluded f) : deemedInterest f = 0 := by
  unfold deemedInterest; split
  · exact Nat.sub_eq_zero_of_le (Nat.le_trans h (Nat.le_trans (Nat.le_add_left _ _) (Nat.le_add_right _ _)))
  · rfl

end Canteen.ITA.CorporateAttribution

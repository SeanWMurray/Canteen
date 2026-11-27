import Canteen.Core.StatuteSyntax
import Canteen.Core.Answer
import Canteen.Core.Money

/-!
# Subsection 118.3(1): the disability tax credit

*Income Tax Act*, as consolidated to 2026-10-29 (verbatim in `statute/ITA-118.3-1.txt`):

**118.3(1)** Where (a) an individual has one or more severe and prolonged impairments in physical or
mental functions, (a.1) whose effects markedly restrict a basic activity of daily living (or would but
for life-sustaining therapy, or significantly restrict more than one with an equivalent cumulative
effect), (a.2), (a.3) certified by a medical practitioner in prescribed form, (b) the certificate has
been filed, and (c) no remuneration for an attendant or care in a nursing home for the individual is
included in a 118.2 deduction by anyone (other than under 118.2(2)(b.1)), the individual may deduct
A × (B + C): A the appropriate percentage (14%), B $6,000 (indexed), and C for an individual under 18 at
the end of the year, $3,500 (indexed) less the care and supervision expenses claimed over $2,050
(indexed).

**118.3(2)** An individual who claimed (or could have claimed, were the person an adult with no income)
the 118(1)(b) eligible dependant amount, or the 118(1)(d) amount for a parent, grandparent, child,
grandchild, sibling, aunt, uncle, nephew or niece, for a person resident in Canada who is entitled to the
118.3(1) deduction (and whose spouse claims no 118 or 118.8 amount for them), with no attendant or
nursing home care for the person's impairment claimed under 118.2 other than under (b.1), may deduct the
amount by which the person's 118.3(1) deduction exceeds the person's tax payable before deductions under
Division E, other than under 118 to 118.07 and 118.7.

The amounts default to their 2025 indexed values: $10,138, $5,914 and $3,464. Whether the impairment
meets (a) and (a.1) is usually a judgment call; the certificate, by the right practitioner for the
impairment, is a fact. Amounts are credits (the deduction from tax), not the underlying amounts. Not
encoded: 118.3(3) (sharing between supporting persons). Rounded
down to the cent.
-/

namespace Canteen.ITA.Disability

structure Amounts where
  base : Cents := 1013800
  supplement : Cents := 591400
  careThreshold : Cents := 346400
  deriving Repr, DecidableEq, Inhabited

structure Facts where
  /-- (a), (a.1): a severe and prolonged impairment, markedly restricting a basic activity of daily living. -/
  impairment : Answer
  /-- (a.2), (a.3): certified in prescribed form by the right practitioner. -/
  certified : Bool := true
  /-- (b): the certificate filed with the Minister. -/
  filed : Bool := true
  /-- (c): attendant or nursing home care for the individual included in a 118.2 deduction, other than under (b.1). -/
  attendantCareClaimed : Bool := false
  /-- Under 18 at the end of the year. -/
  minor : Bool := false
  /-- C(a)(ii)(A): amounts paid for the individual's care or supervision, claimed under 63, 64 or 118.2. -/
  careExpenses : Cents := 0
  amounts : Amounts := {}
  deriving Repr, Inhabited

/-- Subsection 118.3(1). -/
statute eligible (f : Facts) named "subsection 118.3(1)" cites "ITA 118.3(1)"
  applies where
    | "(a), (a.1)" judgments f.impairment.judgments f.impairment.value
        => "The individual has a severe and prolonged impairment that markedly restricts a basic activity of daily living."
        else "The individual's impairment is not severe and prolonged, or does not markedly restrict a basic activity of daily living."
    | "(a.2), (a.3)" f.certified
        => "A medical practitioner has certified it in prescribed form."
        else "No qualified medical practitioner has certified it in prescribed form."
    | (b) f.filed
        => "The certificate has been filed with the Minister."
        else "The certificate has not been filed."
  except where
    | (c) f.attendantCareClaimed
        => "Attendant or nursing home care for the individual is claimed as a medical expense."
        else "No attendant or nursing home care for the individual is claimed as a medical expense."

/-- C: the supplement for a minor, less care expenses over the threshold. -/
def supplement (f : Facts) : Cents :=
  if f.minor then f.amounts.supplement - (f.careExpenses - f.amounts.careThreshold) else 0

/-- B + C. -/
def amount (f : Facts) : Cents := if eligible.holds f then f.amounts.base + supplement f else 0

/-- The credit, at 14%. -/
def credit (f : Facts) : Cents := amount f * 1400 / 10000

def explain (f : Facts) : Finding :=
  let e := eligible.explain f
  ⟨e.conclusion, e.steps ++
    (if eligible.holds f then
      [⟨s!"The amount is {formatCents f.amounts.base}" ++ (if f.minor then s!" plus a supplement of {formatCents (supplement f)}" else "") ++
        s!"; the credit is 14% of it: {formatCents (credit f)}.", "ITA 118.3(1)"⟩] else []), e.reliesOn⟩

/-- 118.3(2): the supporting individual's side. -/
structure Supporter where
  /-- (a)(i), (ii): claimed or could have claimed the 118(1)(b) or (d) amount for the person. -/
  supports : Bool := true
  /-- The person is resident in Canada at any time in the year. -/
  resident : Bool := true
  /-- The person's spouse or common-law partner claims a 118 or 118.8 amount for them. -/
  spouseClaims : Bool := false
  deriving Repr, DecidableEq, Inhabited

/-- 118.3(2): what the supporter may deduct, given the person's facts and their tax before the
deduction ((d): tax at the rates, less credits under 118 to 118.07 and 118.7). -/
def transfer (s : Supporter) (f : Facts) (taxBefore : Cents) : Cents :=
  if s.supports && s.resident && !s.spouseClaims && !f.attendantCareClaimed then credit f - taxBefore else 0

/-! ## Truths about the credit -/

/-- The supplement never exceeds its indexed amount, and is nil for an adult. -/
theorem supplement_le (f : Facts) : supplement f ≤ f.amounts.supplement := by
  unfold supplement; split
  · exact Nat.sub_le _ _
  · exact Nat.zero_le _

/-- Claiming attendant care as a medical expense rules the credit out. -/
theorem not_with_attendant_care (f : Facts) (h : f.attendantCareClaimed = true) : credit f = 0 := by
  simp [credit, amount, eligible, h]

/-- Between them, the person and the supporter never deduct more than the credit: what the person can
use against their own tax, plus the transfer. -/
private theorem min_add_sub (c t : Nat) : min c t + (c - t) ≤ c := by omega

theorem transfer_le (s : Supporter) (f : Facts) (taxBefore : Cents) :
    min (credit f) taxBefore + transfer s f taxBefore ≤ credit f := by
  unfold transfer; split
  · exact min_add_sub _ _
  · exact Nat.min_le_left _ _

end Canteen.ITA.Disability

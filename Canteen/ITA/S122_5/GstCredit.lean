import Canteen.ITA.S117_1.Indexation
import Canteen.Core.Finding

/-!
# Subsection 122.5(3): the GST/HST credit

*Income Tax Act*, as consolidated to 2026-10-29 (verbatim in `statute/ITA-122.5-3-4.txt`):

**122.5(3)** An eligible individual is deemed to have paid, in each month specified for a taxation year
(**(4)**: July and October of the next year, January and April of the year after), ¼ of A − B: A the total
of (a) $213, (b) $213 for a qualified relation, (c) $213 for a qualified dependant for whom the eligible
dependant amount is claimed (without a qualified relation), (d) $112 for each other qualified dependant,
(e) $112 for a single parent, and (f) for an individual with neither, the lesser of $112 and 2% of income
over $6,911; B 5% of adjusted income (the couple's) over $27,749. **117.1(1)(m)** indexes these amounts.

**The base year and the year of indexing are not confirmed.** Taken as the 2002 amounts and indexed to the
calendar year in which the payments begin (the year after the taxation year), they give $349, $184,
$45,521 and $11,337 for the payments from July 2025, which agree with CRA's figures as recalled; read
with the statute's "for the taxation year", the same amounts would apply a year earlier. canada.ca could
not be reached to confirm either. Eligibility, qualified relations and dependants, and adjusted income
are given; shared custody (3.01) and the $50 lump-sum rule (3.1), (3.2) are not encoded; neither is
122.5(3.005).
-/

namespace Canteen.ITA.GstCredit

open Indexation (Specified)

def adult : Specified := ⟨"122.5(3) A (a), (b), (c)", 213, 2002⟩
def child : Specified := ⟨"122.5(3) A (d), (e), (f)", 112, 2002⟩
def phaseIn : Specified := ⟨"122.5(3) A (f)", 6911, 2002⟩
def threshold : Specified := ⟨"122.5(3) B", 27749, 2002⟩

/-- The amount for the payments beginning in July of `paymentYear`. -/
def amount (s : Specified) (paymentYear : Nat) : Cents := ((s.cents paymentYear).orElse fun _ => s.cents 2027).getD (s.dollars * 100)

structure Facts where
  /-- The taxation year whose return the credit is based on. -/
  taxationYear : Nat
  /-- A qualified relation (spouse or common-law partner). -/
  relation : Bool := false
  /-- Qualified dependants, and whether the eligible dependant amount (118(1)(b)) is claimed for one. -/
  dependants : Nat := 0
  eligibleDependantClaimed : Bool := false
  /-- The individual's income (for (f)) and the couple's adjusted income (for B). -/
  income : Cents
  adjustedIncome : Cents
  deriving Repr, DecidableEq, Inhabited

def paymentYear (f : Facts) : Nat := f.taxationYear + 1

/-- A. -/
def paraA (f : Facts) : Cents :=
  let y := paymentYear f
  let a := amount adult y
  let c := amount child y
  a + (if f.relation then a else 0)
    + (if !f.relation && f.eligibleDependantClaimed && f.dependants > 0 then a else 0)
    + c * (f.dependants - (if !f.relation && f.eligibleDependantClaimed && f.dependants > 0 then 1 else 0))
    + (if !f.relation && f.dependants > 0 then c else 0)
    + (if !f.relation && f.dependants == 0 then min c ((f.income - amount phaseIn y) * 2 / 100) else 0)

/-- B. -/
def paraB (f : Facts) : Cents := (f.adjustedIncome - amount threshold (paymentYear f)) * 5 / 100

/-- The year's credit (four quarterly payments). -/
def annual (f : Facts) : Cents := paraA f - paraB f

/-- Each quarterly payment. -/
def quarterly (f : Facts) : Cents := annual f / 4

def explain (f : Facts) : Finding :=
  let c := formatCents
  ⟨annual f > 0, [⟨s!"A, {c (paraA f)}, less 5% of adjusted income over {c (amount threshold (paymentYear f))}, {c (paraB f)}: " ++
      s!"{c (annual f)} a year, {c (quarterly f)} a quarter from July {paymentYear f}.", "ITA 122.5(3), (4); 117.1(1)(m)"⟩], []⟩

/-! ## Truths -/

theorem annual_le (f : Facts) : annual f ≤ paraA f := Nat.sub_le _ _

end Canteen.ITA.GstCredit

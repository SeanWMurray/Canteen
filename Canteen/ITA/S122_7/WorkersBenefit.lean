import Canteen.ITA.S117_1.Indexation
import Canteen.Core.Finding

/-!
# Section 122.7: the Canada workers benefit

*Income Tax Act*, as consolidated to 2026-10-29 (verbatim in `statute/ITA-122.7-2-3.txt`):

**122.7(2)** An eligible individual is deemed to have paid on account of tax A − B: A the lesser of $1,395
($2,403 with an eligible spouse or dependant) and 27% of working income (the couple's together) over
$3,000; B 15% of adjusted net income (the couple's) over $22,944 ($26,177). **122.7(3)** An individual
who may claim the disability tax credit gets C − D more: C the lesser of $720 and 27% of working income
over $1,150; D 15% of adjusted net income over $32,244 (or of the couple's over $42,197; 7.5% where the
spouse also has the disability credit).

**117.1(1)(q), (r)** index the dollar amounts except $3,000 and $1,150; they are taken as the 2021 amounts
(their indexed values for 2022 to 2025, $1,428, $1,518, $1,590 and $1,633, agree with CRA's published
figures as recalled; canada.ca could not be reached to confirm).

Eligibility (122.7(1): resident, 19 or older or living with a spouse or child, not a full-time student
for more than 13 weeks unless with a dependant, not confined in prison), working income and adjusted
net income are given; so is which spouse claims (122.7(2) is claimed by one of them). The advance
payments (122.7(5) to (8)) and the Quebec and other provincial variations (122.7(1.3)) are not encoded.
-/

namespace Canteen.ITA.WorkersBenefit

open Indexation (Specified)

def maxSingle : Specified := ⟨"122.7(2) A (a)", 1395, 2021⟩
def maxFamily : Specified := ⟨"122.7(2) A (b)", 2403, 2021⟩
def thresholdSingle : Specified := ⟨"122.7(2) B (a)", 22944, 2021⟩
def thresholdFamily : Specified := ⟨"122.7(2) B (b)", 26177, 2021⟩
def supplementMax : Specified := ⟨"122.7(3) C", 720, 2021⟩
def supplementSingle : Specified := ⟨"122.7(3) D (a)", 32244, 2021⟩
def supplementFamily : Specified := ⟨"122.7(3) D (b), (c)", 42197, 2021⟩

/-- An amount for the year, or the latest computed year's where the year is not yet computable. -/
def amount (s : Specified) (year : Nat) : Cents := ((s.cents year).orElse fun _ => s.cents 2027).getD (s.dollars * 100)

structure Facts where
  taxationYear : Nat
  /-- An eligible spouse or eligible dependant. -/
  family : Bool := false
  /-- Working income: the individual's, and the eligible spouse's. -/
  workingIncome : Cents
  spouseWorkingIncome : Cents := 0
  /-- Adjusted net income: the individual's, and the eligible spouse's. -/
  adjustedNetIncome : Cents
  spouseAdjustedNetIncome : Cents := 0
  /-- 118.3(1): the individual, and the spouse, may claim the disability tax credit. -/
  disability : Bool := false
  spouseDisability : Bool := false
  deriving Repr, DecidableEq, Inhabited

/-- 122.7(2) A. -/
def paraA (f : Facts) : Cents :=
  let wi := if f.family then f.workingIncome + f.spouseWorkingIncome else f.workingIncome
  min (amount (if f.family then maxFamily else maxSingle) f.taxationYear) ((wi - 300000) * 27 / 100)

/-- 122.7(2) B. -/
def paraB (f : Facts) : Cents :=
  let ani := if f.family then f.adjustedNetIncome + f.spouseAdjustedNetIncome else f.adjustedNetIncome
  (ani - amount (if f.family then thresholdFamily else thresholdSingle) f.taxationYear) * 15 / 100

/-- 122.7(2): the benefit. -/
def benefit (f : Facts) : Cents := paraA f - paraB f

/-- 122.7(3): the disability supplement. -/
def supplement (f : Facts) : Cents :=
  if !f.disability then 0 else
    let c := min (amount supplementMax f.taxationYear) ((f.workingIncome - 115000) * 27 / 100)
    let d :=
      if !f.family then (f.adjustedNetIncome - amount supplementSingle f.taxationYear) * 15 / 100
      else
        let excess := (f.adjustedNetIncome + f.spouseAdjustedNetIncome) - amount supplementFamily f.taxationYear
        if f.spouseDisability then excess * 75 / 1000 else excess * 15 / 100
    c - d

def total (f : Facts) : Cents := benefit f + supplement f

def explain (f : Facts) : Finding :=
  let c := formatCents
  ⟨total f > 0, [
    ⟨s!"27% of working income over $3,000, up to {c (amount (if f.family then maxFamily else maxSingle) f.taxationYear)}: {c (paraA f)}; " ++
      s!"less 15% of adjusted net income over {c (amount (if f.family then thresholdFamily else thresholdSingle) f.taxationYear)}: " ++
      s!"{c (paraB f)}. The benefit is {c (benefit f)}.", "ITA 122.7(2); 117.1(1)(q)"⟩,
    ⟨s!"The disability supplement: {c (supplement f)}.", "ITA 122.7(3); 117.1(1)(r)"⟩], []⟩

/-! ## Truths -/

theorem benefit_le_max (f : Facts) : benefit f ≤ amount (if f.family then maxFamily else maxSingle) f.taxationYear :=
  Nat.le_trans (Nat.sub_le _ _) (Nat.min_le_left _ _)

/-- No working income over $3,000: no benefit. -/
theorem low_working_income (f : Facts) (h : f.workingIncome + (if f.family then f.spouseWorkingIncome else 0) ≤ 300000) :
    benefit f = 0 := by
  have : paraA f = 0 := by
    unfold paraA; split
    · rename_i hf; simp only [hf, ite_true] at h; simp [Nat.sub_eq_zero_of_le h]
    · rename_i hf; simp only [hf] at h; simp [Nat.sub_eq_zero_of_le (by simpa using h)]
  unfold benefit; rw [this]; exact Nat.zero_sub _

end Canteen.ITA.WorkersBenefit

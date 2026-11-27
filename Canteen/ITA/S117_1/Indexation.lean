import Canteen.ITA.S117_1.Cpi
import Canteen.Core.Money

/-!
# Section 117.1: indexing the dollar amounts

*Income Tax Act*, as consolidated to 2026-10-29 (verbatim in `statute/ITA-117.1.txt`):

* **117.1(1)** each specified amount for a taxation year is the amount for the preceding year (before
  the rounding in (3)) plus that amount times (A/B − 1), rounded to the nearest one-thousandth (half
  up): A the Consumer Price Index for the 12 months ending on September 30 before the year, B for the
  12 months before those.
* **117.1(2)** the specified amounts, among them the dollar amounts in 117(2), 118(1) B, 118(1.1) A and
  F, 118(2), 118(10), 118.2(1), 118.3(1) and Part I.2, and 110.6(2)(a)'s $625,000 after 2025.
* **117.1(3)** an amount so adjusted is rounded to the nearest dollar (half up).
* **117.1(4)** the CPI for a 12-month period: the average of the monthly all-items CPI for Canada
  published by Statistics Canada, rounded to the nearest one-thousandth (half up).

The monthly CPI is in `Cpi.lean`, generated from `data/statcan-cpi-41690973.json` (Statistics
Canada's 2002=100 series; the ratio A/B does not depend on the base). Each year's factor is computed
here from that data; `factorTable` records them, and `factorTable_correct` proves each entry equals
the computation. Each specified amount is its dollar figure in the Act and the year that figure is
for; amounts for later years are compounded on the unrounded amount, as (1)(a) requires, and rounded
once. A year whose factor needs CPI months not yet in the data has no amount (`none`), never another
year's.

The Part I.2 threshold is the exception: its $50,000 dates from 1989 and was only partly indexed
until 2000 under the former 117.1, which is not in the consolidated text; it is anchored at its 2000
amount, $53,960, and indexed fully from there.
-/

namespace Canteen.ITA.Indexation

/-- Round `n / d` to the nearest whole number, half up. -/
def roundDiv (n d : Nat) : Nat := (2 * n + d) / (2 * d)

/-- The monthly CPI for a month, in tenths, if published in the data. -/
def cpi (year month : Nat) : Option Nat :=
  if year * 12 + month < cpiFirstYear * 12 + cpiFirstMonth then none
  else cpiTenths[year * 12 + month - (cpiFirstYear * 12 + cpiFirstMonth)]?

/-- 117.1(4): the CPI for the 12 months ending on September 30 of `year`, in thousandths. -/
def periodCpi (year : Nat) : Option Nat := do
  let months := [(year - 1, 10), (year - 1, 11), (year - 1, 12)] ++ (List.range 9).map (fun m => (year, m + 1))
  let vals ← months.mapM fun (y, m) => cpi y m
  -- The average in tenths is (Σ vals) / 12; in thousandths, (Σ vals) × 100 / 12.
  pure (roundDiv (vals.sum * 100) 12)

/-- 117.1(1)(b)(ii): (A/B) − 1 for `year`, in thousandths, rounded half up (A for the period ending
September 30 of the preceding year). -/
def computedFactor (year : Nat) : Option Int := do
  let a ← periodCpi (year - 1)
  let b ← periodCpi (year - 2)
  if b = 0 then none
  else if b ≤ a then pure (roundDiv ((a - b) * 1000) b : Nat)
  else pure (-((roundDiv ((b - a) * 1000) b : Nat) : Int))

/-- The factors, in thousandths, for 1999 to 2027. -/
def factorTable : List (Nat × Int) :=
  [(1999, 10), (2000, 14), (2001, 25), (2002, 30), (2003, 16), (2004, 33), (2005, 17), (2006, 22), (2007, 22),
   (2008, 19), (2009, 25), (2010, 6), (2011, 14), (2012, 28), (2013, 20), (2014, 9), (2015, 17), (2016, 13),
   (2017, 14), (2018, 15), (2019, 22), (2020, 19), (2021, 10), (2022, 24), (2023, 63), (2024, 47), (2025, 27),
   (2026, 20), (2027, 26)]

/-- Every factor in the table is the one 117.1(1) and (4) give from the CPI data. -/
theorem factorTable_correct : factorTable.all (fun (y, f) => computedFactor y == some f) = true := by decide +kernel

def factor (year : Nat) : Option Int := (factorTable.find? (·.1 == year)).map (·.2)

/-- A specified amount: the provision, its dollar figure in the Act, and the year that figure is for. -/
structure Specified where
  provision : String
  dollars : Nat
  baseYear : Nat
  deriving Repr, DecidableEq, Inhabited

/-- 117.1(1), (3): the amount for `year`, in dollars. -/
def Specified.forYear (s : Specified) (year : Nat) : Option Nat := do
  if year < s.baseYear then none
  let fs ← (List.range (year - s.baseYear)).mapM fun k => factor (s.baseYear + k + 1)
  -- Compounded exactly: dollars × Π (1000 + f) / 1000^n, then rounded once.
  let num := fs.foldl (fun acc f => acc * (1000 + f).toNat) s.dollars
  pure (roundDiv num (1000 ^ fs.length))

/-- The amount in cents. -/
def Specified.cents (s : Specified) (year : Nat) : Option Cents := (s.forYear year).map (· * 100)

/-! ## The specified amounts encoded -/

def bracket1 : Specified := ⟨"117(2)(a), (b)", 57375, 2025⟩
def bracket2 : Specified := ⟨"117(2)(b), (c)", 114750, 2025⟩
def bracket3 : Specified := ⟨"117(2)(c), (d)", 177882, 2025⟩
def bracket4 : Specified := ⟨"117(2)(d), (e)", 253414, 2025⟩
def bpaBase : Specified := ⟨"118(1.1) A", 12298, 2020⟩
def bpaEnhanced : Specified := ⟨"118(1.1) F (d)", 15000, 2023⟩
def infirm : Specified := ⟨"118(1) B (a) C, (b) D", 2150, 2017⟩
def ageAmount : Specified := ⟨"118(2)", 6408, 2009⟩
def ageThreshold : Specified := ⟨"118(2) B", 25921, 1999⟩
def employmentAmount : Specified := ⟨"118(10)", 1000, 2007⟩
def medicalThreshold : Specified := ⟨"118.2(1) C, F", 1813, 2004⟩
def disability : Specified := ⟨"118.3(1) B", 6000, 2001⟩
def disabilitySupplement : Specified := ⟨"118.3(1) C (a)(i)", 3500, 2001⟩
def disabilityCare : Specified := ⟨"118.3(1) C (a)(ii)(B)", 2050, 2001⟩
def oasThreshold : Specified := ⟨"180.2(2) A (b) (the 2000 amount)", 53960, 2000⟩
def capitalGainsLimit : Specified := ⟨"110.6(2)(a)", 625000, 2025⟩

def all : List Specified :=
  [bracket1, bracket2, bracket3, bracket4, bpaBase, bpaEnhanced, infirm, ageAmount, ageThreshold, employmentAmount,
   medicalThreshold, disability, disabilitySupplement, disabilityCare, oasThreshold, capitalGainsLimit]

/-- The years for which every specified amount can be computed. -/
def covered (year : Nat) : Bool := all.all fun s => (s.forYear year).isSome

/-! ## Checked against the amounts the Canada Revenue Agency published -/

/-- 2025: the published amounts, reproduced from the Act's figures and the CPI. -/
theorem published_2025 :
    [bracket1, bracket2, bracket3, bracket4, bpaBase, bpaEnhanced, infirm, ageAmount, ageThreshold, employmentAmount,
      medicalThreshold, disability, disabilitySupplement, disabilityCare, oasThreshold].map (·.forYear 2025) =
    [some 57375, some 114750, some 177882, some 253414, some 14538, some 16129, some 2687, some 9028, some 45522,
      some 1471, some 2834, some 10138, some 5914, some 3464, some 93454] := by decide +kernel

/-- 2026. -/
theorem amounts_2026 :
    [bracket1, bracket2, bracket3, bracket4, bpaBase, bpaEnhanced, ageAmount, employmentAmount, capitalGainsLimit].map
      (·.forYear 2026) =
    [some 58523, some 117045, some 181440, some 258482, some 14829, some 16452, some 9208, some 1501, some 637500] := by
  decide +kernel

/-- 2028 needs CPI months not yet published: no amounts. -/
theorem not_yet : covered 2027 = true ∧ covered 2028 = false := by decide +kernel

/-- Before its base year, an amount is not given by this text. -/
theorem before_base : bracket1.forYear 2024 = none := by decide +kernel

end Canteen.ITA.Indexation

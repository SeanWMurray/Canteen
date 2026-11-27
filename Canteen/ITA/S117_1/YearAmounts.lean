import Canteen.ITA.S117_1.Indexation
import Canteen.ITA.S117.Rates

/-!
# The indexed amounts for a taxation year

Every dollar amount an individual's year uses that 117.1 indexes, for one taxation year, in cents.
`computed` derives them from the Act's figures and the CPI (`Indexation`). `table` lists the years
computed so far; `table_correct` proves each row equals `computed`, so a row cannot be mistyped, and
the year's computations look the row up instead of recomputing the CPI each time.

To add a year once Statistics Canada has published CPI to September 30 of the year before: update
`data/statcan-cpi-41690973.json`, run `scripts/cpi.py`, add the year's factor to
`Indexation.factorTable`, and add a row here (`#eval computed 2028` prints it). The proofs check all
three.
-/

namespace Canteen.ITA

structure YearAmounts where
  brackets : Rates.Brackets
  /-- 118(1.1) A and F. -/
  bpaBase : Cents
  bpaEnhanced : Cents
  /-- 118(1) B (a) C and (b) D: the infirmity amount. -/
  infirm : Cents
  /-- 118(2). -/
  age : Cents
  ageThreshold : Cents
  /-- 118(10). -/
  employmentAmount : Cents
  /-- 118.2(1) C, F. -/
  medicalThreshold : Cents
  /-- 118.3(1) B, C. -/
  disability : Cents
  disabilitySupplement : Cents
  disabilityCare : Cents
  /-- 180.2(2) A (b). -/
  oasThreshold : Cents
  /-- 110.6(2)(a). -/
  capitalGainsLimit : Cents
  deriving Repr, DecidableEq, Inhabited

namespace YearAmounts

/-- The amounts for `year`, from the Act's figures and the CPI; `none` if the CPI is not yet published
for it, or the year is before 2025 (the first year the current text's figures cover). -/
def computed (year : Nat) : Option YearAmounts := do
  pure {
    brackets := { first := ← Indexation.bracket1.cents year, second := ← Indexation.bracket2.cents year, third := ← Indexation.bracket3.cents year,
                  fourth := ← Indexation.bracket4.cents year },
    bpaBase := ← Indexation.bpaBase.cents year, bpaEnhanced := ← Indexation.bpaEnhanced.cents year, infirm := ← Indexation.infirm.cents year,
    age := ← Indexation.ageAmount.cents year, ageThreshold := ← Indexation.ageThreshold.cents year,
    employmentAmount := ← Indexation.employmentAmount.cents year, medicalThreshold := ← Indexation.medicalThreshold.cents year,
    disability := ← Indexation.disability.cents year, disabilitySupplement := ← Indexation.disabilitySupplement.cents year,
    disabilityCare := ← Indexation.disabilityCare.cents year, oasThreshold := ← Indexation.oasThreshold.cents year,
    capitalGainsLimit := ← Indexation.capitalGainsLimit.cents year }

/-- The years computed so far. -/
def table : List (Nat × YearAmounts) := [
  (2025, { brackets := ⟨5737500, 11475000, 17788200, 25341400⟩, bpaBase := 1453800, bpaEnhanced := 1612900, infirm := 268700,
           age := 902800, ageThreshold := 4552200, employmentAmount := 147100, medicalThreshold := 283400, disability := 1013800,
           disabilitySupplement := 591400, disabilityCare := 346400, oasThreshold := 9345400, capitalGainsLimit := 62500000 }),
  (2026, { brackets := ⟨5852300, 11704500, 18144000, 25848200⟩, bpaBase := 1482900, bpaEnhanced := 1645200, infirm := 274000,
           age := 920800, ageThreshold := 4643200, employmentAmount := 150100, medicalThreshold := 289000, disability := 1034100,
           disabilitySupplement := 603200, disabilityCare := 353300, oasThreshold := 9532300, capitalGainsLimit := 63750000 }),
  (2027, { brackets := ⟨6004400, 12008800, 18615700, 26520300⟩, bpaBase := 1521400, bpaEnhanced := 1687900, infirm := 281200,
           age := 944800, ageThreshold := 4763900, employmentAmount := 154000, medicalThreshold := 296600, disability := 1061000,
           disabilitySupplement := 618900, disabilityCare := 362500, oasThreshold := 9780200, capitalGainsLimit := 65407500 })]

/-- Each row is the computation from the Act and the CPI. -/
theorem table_correct : table.all (fun (y, a) => computed y == some a) = true := by decide +kernel

def forYear (year : Nat) : Option YearAmounts := (table.find? (·.1 == year)).map (·.2)

/-- The latest year in the table, used (and flagged) where a year is not covered. -/
def latest : Nat × YearAmounts := table.getLast!

end YearAmounts

end Canteen.ITA

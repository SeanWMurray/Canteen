import Canteen.ITA.S127_5.MinimumTax

/-!
# Layer 3: splitting pension income between spouses

A constructed example under 60.03, 60(c), 56(1)(a.2), 118(1), (2), (3) and 117(2), federal tax only.

* Spouses, both over 65, in 2025. The pensioner receives a $90,000 life annuity from a registered
  pension plan; the other spouse $10,000 of RRIF payments. Both claim the basic personal amount.
* They may jointly elect to split up to half of the pensioner's eligible pension income, $45,000.
  How much should they split?

What if both also receive $8,700 of Old Age Security? Provincial tax is not computed.
-/

namespace Canteen.Transactions.PensionSplit

open Canteen Canteen.ITA

def pensioner (split : Cents) : IndividualYear.Facts :=
  { taxationYear := 2025, age65 := true, claimsPersonal := true, pensions := [⟨"pension plan annuity", 9000000, .pensionPlan⟩],
    splitOut := split }

def transferee (split : Cents) : IndividualYear.Facts :=
  { taxationYear := 2025, age65 := true, claimsPersonal := true, pensions := [⟨"RRIF payments", 1000000, .registeredFund⟩],
    splitIn := split }

def total (split : Cents) : Cents := IndividualYear.federalTax (pensioner split) + IndividualYear.federalTax (transferee split)

/-! ## Analysis -/

/-- Up to $45,000 may be split. -/
theorem limit : PensionSplitting.splitLimit true (pensioner 0).pensions = 4500000 := by decide

/-- Without splitting: $11,852.68 between them, all of it the pensioner's. The pensioner's age credit is
mostly clawed back ($329.88 left of $1,263.92). -/
theorem no_split :
    IndividualYear.federalTax (pensioner 0) = 1185268 ∧ IndividualYear.federalTax (transferee 0) = 0 ∧
    IndividualYear.ageAndPensionCredits (pensioner 0) = 60988 := by decide

/-- Splitting $40,000 gives each $50,000 of income and $3,292.06 of tax: $6,584.12 in all. The pensioner's
age credit comes back to $1,169.88. -/
theorem split_40000 :
    IndividualYear.income (pensioner 4000000) = 2 * 5000000 ∧ IndividualYear.income (transferee 4000000) = 2 * 5000000 ∧
    IndividualYear.federalTax (pensioner 4000000) = 329206 ∧ IndividualYear.federalTax (transferee 4000000) = 329206 ∧
    IndividualYear.ageAndPensionCredits (pensioner 4000000) = 144988 := by decide

/-- **Splitting saves $5,268.56.** -/
theorem saving : total 0 - total 4000000 = 526856 := by decide

/-- No split in $1,000 steps up to the limit does better than $40,000. -/
theorem best : ∀ k, k ≤ 45 → total 4000000 ≤ total (k * 100000) := by decide +kernel

/-- Splitting the whole $45,000 overshoots: $10.96 more. -/
theorem overshoot : total 4500000 - total 4000000 = 1096 := by decide

/-! ## What if: with Old Age Security -/

def oas : PensionSplitting.Payment := ⟨"Old Age Security", 870000, .oldAgeSecurity⟩

def pensionerOas (split : Cents) : IndividualYear.Facts := { pensioner split with pensions := (pensioner split).pensions ++ [oas] }
def transfereeOas (split : Cents) : IndividualYear.Facts := { transferee split with pensions := (transferee split).pensions ++ [oas] }

/-- Federal tax under Part I and Part I.2, for both. -/
def totalOas (split : Cents) : Cents :=
  IndividualYear.federalTax (pensionerOas split) + IndividualYear.oasRecovery (pensionerOas split) +
    IndividualYear.federalTax (transfereeOas split) + IndividualYear.oasRecovery (transfereeOas split)

/-- Without splitting, the pensioner's $98,700 of adjusted income is $5,246 over the threshold: $786.90
of the OAS is recovered. Splitting $40,000 avoids it, and saves $4,870.19 in all. -/
theorem with_oas :
    IndividualYear.oasRecovery (pensionerOas 0) = 78690 ∧ IndividualYear.oasRecovery (pensionerOas 4000000) = 0 ∧
    totalOas 0 = 1442795 ∧ totalOas 4000000 = 955776 ∧ totalOas 0 - totalOas 4000000 = 487019 := by decide

/-- Still no split in $1,000 steps up to the limit does better. -/
theorem best_with_oas : ∀ k, k ≤ 45 → totalOas 4000000 ≤ totalOas (k * 100000) := by decide +kernel

end Canteen.Transactions.PensionSplit

import Canteen.Core.Money

/-!
# Pension income, the age and pension credits, and pension splitting

*Income Tax Act*, as consolidated to 2026-10-29 (verbatim in `statute/ITA-118-2-3-7-60.03.txt`):

* **118(7), (8)** "pension income": life annuity payments out of a pension plan, RRSP annuity and RRIF
  payments and the like, but not Old Age Security or Canada Pension Plan benefits; "qualified pension
  income": the pension plan annuity payments (and the others, received on a spouse's death).
  "Eligible pension income" is pension income for an individual 65 or over at the end of the year,
  qualified pension income otherwise.
* **118(2)** the age credit, for an individual 65 or over: 14% × ($6,408 (indexed) − 15% of income over
  $25,921 (indexed)).
* **118(3)** the pension credit: 14% of the lesser of $2,000 and eligible pension income.
* **60.03(1)** the split-pension amount: at most ½ of the pensioner's eligible pension income, times
  the months married in the year over 12, as jointly elected; **60(c)** the pensioner deducts it and
  **56(1)(a.2)** the transferee includes it; **60.03(2)** for 118(3), the pensioner is deemed not to have
  received it, and the transferee to have received it as pension income (and as qualified pension
  income to the extent it was to the pensioner).

The 118(2) amounts default to their 2025 indexed values, $9,028 and $45,522. Not encoded: 60.03(1)
"eligible pension income" (b) and (c) (retirement compensation arrangements and veterans' benefits),
the 118(2) adjustments for section 79 and 20(1)(ww), and 118(8.1). Rounded down to the cent.
-/

namespace Canteen.ITA.PensionSplitting

inductive Kind where
  /-- 118(7) "pension income" (a)(i): a life annuity out of a registered pension plan. Qualified pension income. -/
  | pensionPlan
  /-- (a)(ii) to (vi): RRSP annuities, RRIF payments and the like. Qualified only if received on a spouse's death. -/
  | registeredFund (onSpouseDeath : Bool := false)
  /-- 118(8)(b): Canada Pension Plan and provincial plan benefits; not pension income. -/
  | government
  /-- 118(8)(a): Old Age Security; not pension income, and subject to the Part I.2 recovery tax. -/
  | oldAgeSecurity
  deriving Repr, DecidableEq, Inhabited

structure Payment where
  description : String
  amount : Cents
  kind : Kind
  deriving Repr, DecidableEq, Inhabited

def Payment.isPensionIncome (p : Payment) : Bool :=
  match p.kind with
  | .government | .oldAgeSecurity => false
  | _ => true

def Payment.isQualified (p : Payment) : Bool :=
  match p.kind with
  | .pensionPlan => true
  | .registeredFund onSpouseDeath => onSpouseDeath
  | .government | .oldAgeSecurity => false

/-- 118(7) "eligible pension income". -/
def eligiblePensionIncome (age65 : Bool) (ps : List Payment) : Cents :=
  ((ps.filter fun p => if age65 then p.isPensionIncome else p.isQualified).map (·.amount)).sum

/-- 60.03(1) "split-pension amount": the most that may be elected. -/
def splitLimit (age65 : Bool) (ps : List Payment) (monthsMarried : Nat := 12) : Cents :=
  eligiblePensionIncome age65 ps * min monthsMarried 12 / 24

structure AgeAmounts where
  amount : Cents := 902800
  threshold : Cents := 4552200
  deriving Repr, DecidableEq, Inhabited

/-- 118(2): $9,028 (2025) less 15% of income over $45,522. -/
def ageAmount (a : AgeAmounts) (income : Cents) : Cents := a.amount - (income - a.threshold) * 15 / 100

def ageCredit (a : AgeAmounts) (age65 : Bool) (income : Cents) : Cents :=
  if age65 then ageAmount a income * 1400 / 10000 else 0

/-- 118(3): 14% of the lesser of $2,000 and eligible pension income. -/
def pensionCredit (eligible : Cents) : Cents := min 200000 eligible * 1400 / 10000

/-! ## Truths -/

/-- Government benefits are never eligible pension income. -/
theorem government_not_eligible (age65 : Bool) (d : String) (x : Cents) :
    eligiblePensionIncome age65 [⟨d, x, .government⟩] = 0 := by
  cases age65 <;> rfl

private theorem twelve (x : Nat) : x * 12 / 24 = x / 2 := by omega

/-- The split-pension amount is at most half of eligible pension income. -/
theorem split_le_half (age65 : Bool) (ps : List Payment) (m : Nat) :
    splitLimit age65 ps m ≤ eligiblePensionIncome age65 ps / 2 := by
  unfold splitLimit
  have h : min m 12 ≤ 12 := Nat.min_le_right _ _
  have : eligiblePensionIncome age65 ps * min m 12 ≤ eligiblePensionIncome age65 ps * 12 := Nat.mul_le_mul_left _ h
  calc eligiblePensionIncome age65 ps * min m 12 / 24 ≤ eligiblePensionIncome age65 ps * 12 / 24 := Nat.div_le_div_right this
    _ = eligiblePensionIncome age65 ps / 2 := twelve _

/-- The pension credit never exceeds $280. -/
theorem pension_credit_le (e : Cents) : pensionCredit e ≤ 28000 := by
  unfold pensionCredit
  have : min 200000 e * 1400 ≤ 200000 * 1400 := Nat.mul_le_mul_right _ (Nat.min_le_left _ _)
  calc min 200000 e * 1400 / 10000 ≤ 200000 * 1400 / 10000 := Nat.div_le_div_right this
    _ = 28000 := by decide

end Canteen.ITA.PensionSplitting

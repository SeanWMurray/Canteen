import Canteen.ITA.S117_1.YearAmounts

/-!
# A trust's income paid out to beneficiaries: 104(6)(b), 104(13), 104(19), 104(21), 104(24)

*Income Tax Act*, as consolidated to 2026-10-29 (verbatim in `statute/ITA-104-6-13-19-21-24.txt` and
`statute/ITA-122-1-1.1.txt`):

**122(1)(a)** A trust (other than a graduated rate estate or qualified disability trust) pays the
highest individual percentage on its amount taxable; **(1.1)** with no credits but 118.1, 120.2 and 121.

**104(6)(b)** A trust (other than the special trusts of (a) to (a.4)) deducts the part of its income for the
year that became payable in the year to beneficiaries. **104(13)(a)** Each beneficiary includes the part
that became payable to the beneficiary. **104(24)** An amount becomes payable only if paid in the year or
the beneficiary was entitled in the year to enforce payment. **104(19)** A portion of the trust's taxable
dividends from taxable Canadian corporations designated for a beneficiary, and part of what the
beneficiary includes, is deemed a taxable dividend received by the beneficiary (so the gross-up and
dividend tax credit, or 112(1) for a corporate beneficiary, apply there), and not by the trust.
**104(21)** Likewise for the trust's net taxable capital gains, which are the beneficiary's taxable capital
gains (for 3 and 111, not 110.6). Designations are limited to the trust's totals ((19)(d), (21)(d)), and
the trust must be resident in Canada throughout the year (and, for (21), the beneficiary resident).

The trust's income is given in three parts: taxable dividends (actual amounts), net taxable capital
gains, and other income. The amounts payable and the designations are given per beneficiary and capped
here. 104(6)(b)(i) to (iv) (preferred beneficiary elections, the 104(6)(b)(iii) 120.4 rule), 104(7) to
(7.1), 104(12), (14) and 105 are not encoded; nor is the trust's own gross-up of retained dividends.
-/

namespace Canteen.ITA.TrustIncome

structure Beneficiary where
  name : String
  /-- Paid in the year, or enforceable in the year (104(24)). -/
  payable : Cents
  /-- 104(19): taxable dividends designated. -/
  dividends : Cents := 0
  /-- 104(21): net taxable capital gains designated. -/
  gains : Cents := 0
  /-- 104(21)(b)(ii): resident in Canada. -/
  resident : Bool := true
  deriving Repr, DecidableEq, Inhabited

/-- 122(1): the kind of trust, for its rate. -/
inductive Kind where
  /-- A graduated rate estate or qualified disability trust: the 117(2) rates. -/
  | graduated
  /-- Any other trust: the highest individual percentage. -/
  | flat
  deriving Repr, DecidableEq, Inhabited

structure Facts where
  taxationYear : Nat := 2025
  kind : Kind := .flat
  /-- Taxable dividends received from taxable Canadian corporations (actual amounts). -/
  dividends : Cents := 0
  /-- Net taxable capital gains. -/
  netTaxableGains : Cents := 0
  otherIncome : Cents := 0
  /-- Resident in Canada throughout the year. -/
  resident : Bool := true
  beneficiaries : List Beneficiary := []
  deriving Repr, DecidableEq, Inhabited

def income (f : Facts) : Cents := f.dividends + f.netTaxableGains + f.otherIncome

def totalPayable (f : Facts) : Cents := (f.beneficiaries.map (·.payable)).sum

/-- 104(6)(b): the deduction, at most the trust's income. -/
def deduction (f : Facts) : Cents := min (totalPayable f) (income f)

/-- The trust's income after the deduction. -/
def retained (f : Facts) : Cents := income f - deduction f

/-- 122(1)(a): tax on what the trust keeps, taken as its taxable income: the highest individual
percentage (33%), or for a graduated rate estate or qualified disability trust the year's 117(2) rates.
122(1.1) leaves only the 118.1, 120.2 and 121 credits, not computed here. -/
def tax (f : Facts) : Cents :=
  match f.kind with
  | .flat => retained f * 33 / 100
  | .graduated => Rates.tax (retained f) ((YearAmounts.forYear f.taxationYear).getD YearAmounts.latest.2).brackets

/-- 104(19): the designated dividends allowed, beneficiary by beneficiary, in order, within the trust's
total and each beneficiary's payable amount. -/
def allowDividends : Cents → List Beneficiary → List Cents
  | _, [] => []
  | left, b :: bs => let d := min left (min b.dividends b.payable); d :: allowDividends (left - d) bs

/-- 104(21): the designated gains allowed, within the trust's total and what is left of each beneficiary's
payable amount after its dividends; none for a non-resident beneficiary. -/
def allowGains : Cents → List (Beneficiary × Cents) → List Cents
  | _, [] => []
  | left, (b, d) :: bs =>
    let g := if b.resident then min left (min b.gains (b.payable - d)) else 0
    g :: allowGains (left - g) bs

def dividendsTo (f : Facts) : List Cents := if f.resident then allowDividends f.dividends f.beneficiaries else f.beneficiaries.map fun _ => 0
def gainsTo (f : Facts) : List Cents :=
  if f.resident then allowGains f.netTaxableGains (f.beneficiaries.zip (dividendsTo f)) else f.beneficiaries.map fun _ => 0

/-- What each beneficiary includes: as taxable dividends, as taxable capital gains, and as income from
property (104(13)) for the rest of the amount payable. -/
structure Share where
  name : String
  dividends : Cents
  gains : Cents
  other : Cents
  deriving Repr, DecidableEq, Inhabited

def shares (f : Facts) : List Share :=
  ((f.beneficiaries.zip (dividendsTo f)).zip (gainsTo f)).map fun ((b, d), g) => ⟨b.name, d, g, b.payable - d - g⟩

def explain (f : Facts) : Finding :=
  let c := formatCents
  let steps : List Step := (shares f).map fun s =>
    ⟨s!"{s.name}: {c s.dividends} as taxable dividends, {c s.gains} as taxable capital gains, and {c s.other} as income from the trust.",
      "ITA 104(13)(a), (19), (21)"⟩
  ⟨deduction f > 0, [⟨s!"The trust's income of {c (income f)}; {c (totalPayable f)} became payable to beneficiaries, so it deducts " ++
      s!"{c (deduction f)} and is taxed on {c (retained f)}" ++ (match f.kind with
        | .flat => s!", at 33%: {c (tax f)}."
        | .graduated => s!", at the graduated rates: {c (tax f)}."), "ITA 104(6)(b), (24); 122(1)"⟩] ++ steps, []⟩

/-! ## Truths -/

theorem deduction_le_income (f : Facts) : deduction f ≤ income f := Nat.min_le_right _ _

private theorem add_within (d t l : Nat) (h : t ≤ l - d) (h2 : d ≤ l) : d + t ≤ l := by omega

/-- The dividends designated never exceed what the trust received. -/
theorem allowDividends_le (l : Cents) (bs : List Beneficiary) : (allowDividends l bs).sum ≤ l := by
  induction bs generalizing l with
  | nil => simp [allowDividends]
  | cons b bs ih =>
    simp only [allowDividends, List.sum_cons]
    exact add_within _ _ _ (ih _) (Nat.min_le_left _ _)

/-- A trust that pays out all its income pays no tax under 122(1)(a). -/
theorem all_out (f : Facts) (h : income f ≤ totalPayable f) : tax f = 0 := by
  have : retained f = 0 := by unfold retained deduction; rw [Nat.min_eq_right h]; exact Nat.sub_self _
  unfold tax; rw [this]; split
  · rfl
  · simp only [Rates.tax, Rates.slices, Rates.slice, Nat.zero_min, Nat.zero_sub]; rfl

end Canteen.ITA.TrustIncome

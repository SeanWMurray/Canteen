import Canteen.Core.Money
import Canteen.Core.Finding

/-!
# Part XIII: tax on dividends and interest paid to non-residents (212(1)(b), 212(2))

*Income Tax Act*, as consolidated to 2026-10-29 (verbatim in `statute/ITA-212-1-b-3.txt` and
`statute/ITA-212-2-214-16-17.txt`):

**212(1)(b)** A non-resident pays 25% on interest paid or credited (or deemed paid or credited) by a person
resident in Canada that (i) is not fully exempt interest and is paid or payable to, or on a debt to, a
person with whom the payer does not deal at arm's length, or (ii) is participating debt interest.
**212(2)** 25% on taxable dividends and capital dividends paid or credited (or deemed paid or credited)
by a corporation resident in Canada.

**212(3)** "Fully exempt interest" (interest on government and similar obligations, and the others the
definition lists) and "participating debt interest" (contingent on use or production, or computed by
reference to revenue, profit, cash flow, commodity prices or dividends) are facts here, as is arm's
length (from `RelatedPersons` where the facts allow).

A treaty may reduce the rate (given as a percentage). The payer withholds and remits under 215(1); 215
and 227 are not encoded. Other payments (212(1)(a), (d), (h) and the rest) are not encoded.
-/

namespace Canteen.ITA.Withholding

inductive Kind where
  | dividend
  | capitalDividend
  | interest
  deriving Repr, DecidableEq, Inhabited

structure Payment where
  description : String
  kind : Kind
  amount : Cents
  /-- The payer does not deal at arm's length with the payee (or with the person to whom the debt is owed). -/
  nonArmsLength : Bool := false
  /-- 212(3) "fully exempt interest". -/
  fullyExempt : Bool := false
  /-- 212(3) "participating debt interest". -/
  participating : Bool := false
  /-- The rate under a tax treaty, in percent, if any. -/
  treatyRate : Option Nat := none
  deriving Repr, DecidableEq, Inhabited

/-- Subject to Part XIII. -/
def Payment.taxable (p : Payment) : Bool :=
  match p.kind with
  | .dividend | .capitalDividend => true
  | .interest => (!p.fullyExempt && p.nonArmsLength) || p.participating

def Payment.rate (p : Payment) : Nat := min 25 (p.treatyRate.getD 25)

def Payment.tax (p : Payment) : Cents := if p.taxable then p.amount * p.rate / 100 else 0

def tax (ps : List Payment) : Cents := (ps.map Payment.tax).sum

def explain (ps : List Payment) : Finding :=
  let c := formatCents
  let steps : List Step := ps.map fun p =>
    match p.kind with
    | .interest =>
      if !p.taxable then ⟨s!"{p.description}: interest to an arm's length person (or fully exempt), not participating: no Part XIII tax.", "ITA 212(1)(b)"⟩
      else ⟨s!"{p.description}: " ++ (if p.participating then "participating debt interest" else "interest to a non-arm's length person") ++
        s!": {p.rate}% of {c p.amount}, {c p.tax}.", "ITA 212(1)(b)"⟩
    | _ => ⟨s!"{p.description}: a dividend to a non-resident: {p.rate}% of {c p.amount}, {c p.tax}.", "ITA 212(2)"⟩
  ⟨tax ps > 0, steps ++ [⟨s!"Part XIII tax to withhold: {c (tax ps)}.", "ITA 212; 215(1)"⟩], []⟩

/-! ## Truths -/

theorem Payment.tax_le (p : Payment) : p.tax ≤ p.amount * 25 / 100 := by
  unfold Payment.tax; split
  · exact Nat.div_le_div_right (Nat.mul_le_mul_left _ (Nat.min_le_left _ _))
  · exact Nat.zero_le _

/-- Arm's length interest that is not participating bears no Part XIII tax. -/
theorem arms_length_interest (p : Payment) (h : p.kind = .interest) (ha : p.nonArmsLength = false) (hp : p.participating = false) :
    p.tax = 0 := by
  simp [Payment.tax, Payment.taxable, h, ha, hp]

end Canteen.ITA.Withholding

import Canteen.Core.Money
import Canteen.Core.Finding

/-!
# Part XIII: tax on management fees, interest and dividends paid to non-residents (212(1)(a), (b), 212(2))

*Income Tax Act*, as consolidated to 2026-10-29 (verbatim in `statute/ITA-212-1-a-b-3-4.txt` and
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
and 227 are not encoded. Other payments (212(1)(d), (h) and the rest) are not encoded.

**212(1)(a)** 25% on a management or administration fee or charge; **212(4)** which does not include, to
the extent reasonable, an amount for (a) a service performed in the ordinary course of the non-resident's
business of performing such services for a fee, at arm's length, or (b) a specific expense incurred to
perform a service for the payer.
-/

namespace Canteen.ITA.Withholding

inductive Kind where
  | dividend
  | capitalDividend
  | interest
  /-- 212(1)(a): a management or administration fee or charge. -/
  | managementFee
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
  /-- 212(4)(a): for a service performed in the ordinary course of the non-resident's business of performing
  such services for a fee (and at arm's length: `nonArmsLength` false). -/
  ordinaryCourse : Bool := false
  /-- 212(4)(b): reimbursing a specific expense incurred to perform a service for the payer. -/
  reimbursement : Bool := false
  /-- 212(4): the part reasonable in the circumstances, if less than the amount. -/
  reasonable : Option Cents := none
  /-- The rate under a tax treaty, in percent, if any. -/
  treatyRate : Option Nat := none
  deriving Repr, DecidableEq, Inhabited

/-- Subject to Part XIII. -/
def Payment.taxable (p : Payment) : Bool :=
  match p.kind with
  | .dividend | .capitalDividend => true
  | .interest => (!p.fullyExempt && p.nonArmsLength) || p.participating
  | .managementFee => true

def Payment.rate (p : Payment) : Nat := min 25 (p.treatyRate.getD 25)

/-- 212(4): the part of a management fee that is not a "management or administration fee or charge". -/
def Payment.excluded (p : Payment) : Cents :=
  if (p.ordinaryCourse && !p.nonArmsLength) || p.reimbursement then min p.amount (p.reasonable.getD p.amount) else 0

/-- The amount Part XIII taxes. -/
def Payment.base (p : Payment) : Cents :=
  match p.kind with
  | .managementFee => p.amount - p.excluded
  | _ => if p.taxable then p.amount else 0

def Payment.tax (p : Payment) : Cents := p.base * p.rate / 100

def tax (ps : List Payment) : Cents := (ps.map Payment.tax).sum

def explain (ps : List Payment) : Finding :=
  let c := formatCents
  let steps : List Step := ps.map fun p =>
    match p.kind with
    | .interest =>
      if !p.taxable then ⟨s!"{p.description}: interest to an arm's length person (or fully exempt), not participating: no Part XIII tax.", "ITA 212(1)(b)"⟩
      else ⟨s!"{p.description}: " ++ (if p.participating then "participating debt interest" else "interest to a non-arm's length person") ++
        s!": {p.rate}% of {c p.amount}, {c p.tax}.", "ITA 212(1)(b)"⟩
    | .managementFee =>
      if p.excluded > 0 then ⟨s!"{p.description}: {c p.excluded} is for services in the ordinary course of an arm's length business, " ++
        s!"or reimburses a specific expense, and is not a management fee; {p.rate}% of the rest, {c p.base}: {c p.tax}.", "ITA 212(1)(a); 212(4)"⟩
      else ⟨s!"{p.description}: a management or administration fee: {p.rate}% of {c p.amount}, {c p.tax}.", "ITA 212(1)(a)"⟩
    | _ => ⟨s!"{p.description}: a dividend to a non-resident: {p.rate}% of {c p.amount}, {c p.tax}.", "ITA 212(2)"⟩
  ⟨tax ps > 0, steps ++ [⟨s!"Part XIII tax to withhold: {c (tax ps)}.", "ITA 212; 215(1)"⟩], []⟩

/-! ## Truths -/

theorem Payment.base_le (p : Payment) : p.base ≤ p.amount := by
  unfold Payment.base; split
  · exact Nat.sub_le _ _
  · split
    · exact Nat.le_refl _
    · exact Nat.zero_le _

theorem Payment.tax_le (p : Payment) : p.tax ≤ p.amount * 25 / 100 :=
  Nat.div_le_div_right (Nat.mul_le_mul p.base_le (Nat.min_le_left _ _))

/-- Arm's length interest that is not participating bears no Part XIII tax. -/
theorem arms_length_interest (p : Payment) (h : p.kind = .interest) (ha : p.nonArmsLength = false) (hp : p.participating = false) :
    p.tax = 0 := by
  simp [Payment.tax, Payment.base, Payment.taxable, h, ha, hp]

/-- A reasonable fee for a service in the ordinary course of an arm's length business bears none. -/
theorem ordinary_course_fee (p : Payment) (h : p.kind = .managementFee) (ho : p.ordinaryCourse = true) (ha : p.nonArmsLength = false)
    (hr : p.reasonable = none) : p.tax = 0 := by
  simp [Payment.tax, Payment.base, Payment.excluded, h, ho, ha, hr]

end Canteen.ITA.Withholding

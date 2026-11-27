import Canteen.Core.Money
import Canteen.Core.Finding
import Canteen.Core.Answer

/-!
# Section 67.1: meals and entertainment

*Income Tax Act*, as consolidated to 2026-10-29 (verbatim in `statute/ITA-67.1.txt`):

**67.1(1)** For the purposes of the Act (other than 62, 63, 118.01 and 118.2), an amount paid or payable
for food, beverages or entertainment is deemed to be 50% of the lesser of the amount paid or payable and
a reasonable amount. **(1.1)** For a long-haul truck driver's food and beverages during an eligible
travel period, the specified percentage instead: 80% after 2010 (60% from March 19, 2007, 65% in 2008,
70% in 2009, 75% in 2010).

**67.1(2)** Not for an amount (a) for food, beverages or entertainment the person provides for
compensation in the ordinary course of its business; (b) for a fund-raising event primarily to benefit
a registered charity; (c) for which the person is compensated, the compensation reasonable and
specifically identified in writing; (d) included in a taxpayer's income under section 6 (or that would
be, but for 6(6)(a)(ii)); (e) at a remote work site, (e.1) at a construction work camp, each as the
paragraph describes; or (f) for one of six or fewer special events in a calendar year generally open to
all employees at a place of business.

**67.1(3)** A conference fee that entitles the participant to food, beverages or entertainment (beyond
incidental refreshments), without a reasonable part of it identified for them: $50 a day of food is
deemed the amount paid for them, and the fee is the rest. **(4)** Fares do not include food on board;
entertainment includes amusement and recreation.

The exception that applies (if any) and the reasonable amount are given; whether the person is a
long-haul truck driver in an eligible travel period (67.1(5)) is a fact. The specified percentage is
taken by calendar year, with 2007 as a whole at 60%. For (f), "one of six or fewer" is read as no
exception at all once more than six special events are held in the year. Percentages are applied in
cents, rounded down.
-/

namespace Canteen.ITA.MealsEntertainment

/-- 67.1(2): the exceptions. -/
inductive Exception where
  /-- (a) provided for compensation in the ordinary course of the person's business. -/
  | ordinaryBusiness
  /-- (b) a fund-raising event primarily to benefit a registered charity. -/
  | charityFundraiser
  /-- (c) compensated, the compensation reasonable and identified in writing. -/
  | billedToClient
  /-- (d) included in an employee's income under section 6. -/
  | taxableBenefit
  /-- (e) a remote work site. -/
  | remoteWorkSite
  /-- (e.1) a construction work camp. -/
  | constructionCamp
  /-- (f) a special event for all employees at a place of business. -/
  | staffEvent
  deriving Repr, DecidableEq, Inhabited

def Exception.cite : Exception → String
  | .ordinaryBusiness => "ITA 67.1(2)(a)"
  | .charityFundraiser => "ITA 67.1(2)(b)"
  | .billedToClient => "ITA 67.1(2)(c)"
  | .taxableBenefit => "ITA 67.1(2)(d)"
  | .remoteWorkSite => "ITA 67.1(2)(e)"
  | .constructionCamp => "ITA 67.1(2)(e.1)"
  | .staffEvent => "ITA 67.1(2)(f)"

structure Expense where
  description : String
  /-- The calendar year it was paid or became payable. -/
  year : Nat
  amount : Cents
  /-- A reasonable amount in the circumstances, if less than the amount. -/
  reasonable : Option Cents := none
  /-- The 67.1(2) exception claimed, if any: a fact or a judgment call. -/
  exception : Option Exception := none
  exceptionApplies : Answer := .fact true
  /-- 67.1(1.1): food or beverages of a long-haul truck driver during an eligible travel period. -/
  truckDriver : Bool := false
  deriving Repr, DecidableEq, Inhabited

/-- 67.1(5) "specified percentage", by calendar year. -/
def specifiedPercentage (year : Nat) : Nat :=
  if year < 2007 then 50 else if year == 2007 then 60 else if year == 2008 then 65
  else if year == 2009 then 70 else if year == 2010 then 75 else 80

/-- The lesser of the amount and a reasonable amount. -/
def Expense.base (e : Expense) : Cents := min e.amount (e.reasonable.getD e.amount)

/-- The exception applies: claimed and established, and for (f), no more than six special events in the year. -/
def Expense.excepted (e : Expense) (staffEvents : Nat) : Bool :=
  match e.exception with
  | none => false
  | some .staffEvent => e.exceptionApplies.value && staffEvents ≤ 6
  | some _ => e.exceptionApplies.value

def Expense.percentage (e : Expense) : Nat := if e.truckDriver then specifiedPercentage e.year else 50

/-- The amount the Act treats as paid or payable. -/
def Expense.deemed (e : Expense) (staffEvents : Nat := 0) : Cents :=
  if e.excepted staffEvents then e.amount else e.base * e.percentage / 100

/-- 67.1(3): a conference fee with food not identified, and the days on which food is provided. -/
structure Conference where
  description : String
  year : Nat
  fee : Cents
  /-- The part of the fee identified for food, beverages and entertainment, if any. -/
  identified : Option Cents := none
  daysWithFood : Nat := 0
  deriving Repr, DecidableEq, Inhabited

/-- The food part: identified, or $50 a day (never more than the fee). -/
def Conference.foodPart (c : Conference) : Cents := min c.fee (c.identified.getD (5000 * c.daysWithFood))

/-- The conference fee as the Act treats it: the rest of the fee, and 50% of the food part. -/
def Conference.deemed (c : Conference) : Cents :=
  (c.fee - c.foodPart) + ({ description := c.description, year := c.year, amount := c.foodPart } : Expense).deemed

structure Facts where
  expenses : List Expense := []
  conferences : List Conference := []
  /-- 67.1(2)(f): the special events for all employees held in the calendar year. -/
  staffEvents : Nat := 0
  deriving Repr, DecidableEq, Inhabited

def total (f : Facts) : Cents := (f.expenses.map (·.amount)).sum + (f.conferences.map (·.fee)).sum
def deductible (f : Facts) : Cents := (f.expenses.map (·.deemed f.staffEvents)).sum + (f.conferences.map (·.deemed)).sum

def judgments (f : Facts) : List String :=
  f.expenses.foldl (fun ids e => mergeIds ids (if e.exception.isSome then e.exceptionApplies.judgments else [])) []

def explain (f : Facts) : Finding :=
  let c := formatCents
  let steps : List Step := f.expenses.map fun e =>
    if e.excepted f.staffEvents then
      ⟨s!"{e.description}: {c e.amount}, excepted from the 50% limit.", (e.exception.map Exception.cite).getD "ITA 67.1(2)"⟩
    else if e.exception == some .staffEvent && e.exceptionApplies.value then
      ⟨s!"{e.description}: more than six special events were held in the year, so 67.1(2)(f) does not apply: " ++
        s!"{e.percentage}% of {c e.base}, {c (e.deemed f.staffEvents)}.", "ITA 67.1(1); 67.1(2)(f)"⟩
    else if e.truckDriver then
      ⟨s!"{e.description}: a long-haul truck driver's meals in an eligible travel period: {e.percentage}% of {c e.base}, " ++
        s!"{c (e.deemed f.staffEvents)}.", "ITA 67.1(1.1), (5)"⟩
    else
      ⟨s!"{e.description}: 50% of {c e.base}" ++ (if e.base < e.amount then " (the reasonable amount)" else "") ++
        s!", {c (e.deemed f.staffEvents)}.", "ITA 67.1(1)"⟩
  let conf : List Step := f.conferences.map fun k =>
    ⟨s!"{k.description}: the fee of {c k.fee} includes food of {c k.foodPart}" ++
      (if k.identified.isNone then s!" ($50 for each of {k.daysWithFood} days)" else "") ++
      s!", of which 50% counts: {c k.deemed} in all.", "ITA 67.1(1), (3)"⟩
  ⟨deductible f < total f, steps ++ conf ++
    [⟨s!"Of {c (total f)} paid, {c (deductible f)} is treated as paid or payable.", "ITA 67.1"⟩], judgments f⟩

/-! ## Truths -/

theorem Expense.deemed_le (e : Expense) (n : Nat) : e.deemed n ≤ e.amount := by
  unfold Expense.deemed
  split
  · exact Nat.le_refl _
  · have hp : e.percentage ≤ 100 := by
      unfold Expense.percentage specifiedPercentage; split <;> (try split) <;> (try split) <;> (try split) <;> (try split) <;> (try split) <;> decide
    calc e.base * e.percentage / 100 ≤ e.base * 100 / 100 := Nat.div_le_div_right (Nat.mul_le_mul_left _ hp)
      _ = e.base := Nat.mul_div_cancel _ (by decide)
      _ ≤ e.amount := Nat.min_le_left _ _

/-- The general rule: half of a reasonable expense, without an exception. -/
theorem Expense.half (e : Expense) (n : Nat) (h : e.exception = none) (ht : e.truckDriver = false) (hr : e.reasonable = none) :
    e.deemed n = e.amount * 50 / 100 := by
  simp [Expense.deemed, Expense.excepted, Expense.base, Expense.percentage, h, ht, hr]

/-- Over six special events, the staff event exception is lost. -/
theorem Expense.seventh_event (e : Expense) (n : Nat) (h : e.exception = some .staffEvent) (hn : 6 < n) :
    e.excepted n = false := by
  simp [Expense.excepted, h]; omega

end Canteen.ITA.MealsEntertainment

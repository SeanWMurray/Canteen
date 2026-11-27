import Canteen.Core.StatuteSyntax
import Canteen.Core.Answer
import Canteen.Core.Money

/-!
# Paragraph 20(1)(c) and subsection 20(3): interest on borrowed money

*Income Tax Act*, as consolidated to 2026-10-29 (verbatim in `statute/ITA-20-1-c-20-3.txt`):

* **20(1)(c)(i)** in computing income from a business or property, there may be deducted interest paid
  in the year or payable in respect of it, under a legal obligation to pay interest, on borrowed money
  used for the purpose of earning income from a business or property (other than to acquire property
  the income from which would be exempt, or a life insurance policy), or a reasonable amount in respect
  of it, whichever is less.
* **20(3)** borrowed money used to repay money previously borrowed is deemed to be used for the purpose
  for which the previous borrowing was used.

The use is the current, direct use of the borrowed money, traced to it (Bronfman Trust, Singleton);
the purpose of earning income is a judgment call (Ludco: a reasonable expectation of income, gross
not net). Where only part of a borrowing is traced to an eligible use, interest is apportioned.
Not encoded: 20(1)(c)(ii) to (iv), 20(1)(d) to (f), 20.1 (lost sources), 20(2), 20(2.2), 20(3.1),
18(9) and 18(3.1) (prepaid and construction interest), and the thin capitalization rules.
-/

namespace Canteen.ITA.InterestDeductibility

/-- What borrowed money was used for. -/
inductive Use where
  | business
  | property
  /-- Property the income from which would be exempt. -/
  | exempt
  | lifeInsurance
  | personal
  /-- 20(3): to repay money previously borrowed. -/
  | refinancing
  deriving Repr, DecidableEq, Inhabited

structure Borrowing where
  description : String
  principal : Cents
  /-- Interest paid in the year or payable in respect of it. -/
  interest : Cents
  legalObligation : Bool := true
  use : Use
  /-- 20(3): for a refinancing, the use of the previous borrowing (itself traced through any earlier refinancing). -/
  previousUse : Use := .personal
  /-- The part of the principal traced to the use, if not all of it. -/
  traced : Option Cents := none
  /-- The purpose of earning income from the business or property. Often a judgment call. -/
  incomePurpose : Answer := .fact true
  /-- A reasonable amount of interest, where the rate is not reasonable. -/
  reasonable : Option Cents := none
  deriving Repr, Inhabited

/-- 20(3): the use the borrowed money is taken to have. -/
def effectiveUse (b : Borrowing) : Use := if b.use = .refinancing then b.previousUse else b.use

def earningUse (u : Use) : Bool := u = .business || u = .property || u = .exempt || u = .lifeInsurance

/-- Subparagraph 20(1)(c)(i), with 20(3). -/
statute deductible (b : Borrowing) named "subparagraph 20(1)(c)(i)" cites "ITA 20(1)(c)(i); 20(3)"
  applies where
    | "legal obligation" b.legalObligation
        => "The interest is paid or payable under a legal obligation to pay interest."
        else "There is no legal obligation to pay interest."
    | "use" (earningUse (effectiveUse b))
        => "The borrowed money was used (or, under 20(3), the borrowing it repaid was used) in a business or to acquire property."
        else "The borrowed money was used for a personal purpose, not in a business or to acquire property."
    | "income purpose" judgments b.incomePurpose.judgments b.incomePurpose.value
        => "It was used for the purpose of earning income from the business or property."
        else "It was not used for the purpose of earning income."
  except where
    | "exempt income, life insurance" (effectiveUse b = .exempt || effectiveUse b = .lifeInsurance)
        => "The property acquired is property the income from which would be exempt, or a life insurance policy."
        else "The property acquired is not property with exempt income or a life insurance policy."

/-- The interest on the traced part. -/
def apportioned (b : Borrowing) : Cents :=
  match b.traced with
  | none => b.interest
  | some t => if b.principal = 0 then 0 else b.interest * min t b.principal / b.principal

/-- The deduction: the interest on the part used to earn income, or a reasonable amount if less. -/
def deduction (b : Borrowing) : Cents :=
  if deductible.holds b then min (apportioned b) (b.reasonable.getD (apportioned b)) else 0

def total (bs : List Borrowing) : Cents := (bs.map deduction).sum

/-- 127.52(1)(j)(ii): the part on money borrowed to earn income from property. -/
def propertyPart (bs : List Borrowing) : Cents :=
  ((bs.filter fun b => effectiveUse b = .property).map deduction).sum

def explain (b : Borrowing) : Finding :=
  let e := deductible.explain b
  ⟨e.conclusion, e.steps ++
    (if deductible.holds b then [⟨s!"Interest of {formatCents (deduction b)} on {b.description} is deductible.", "ITA 20(1)(c)"⟩] else []),
    e.reliesOn⟩

/-! ## Truths about interest -/

/-- The deduction never exceeds the interest. -/
theorem deduction_le (b : Borrowing) : deduction b ≤ b.interest := by
  unfold deduction apportioned
  split
  · refine Nat.le_trans (Nat.min_le_left _ _) ?_
    split
    · exact Nat.le_refl _
    · split
      · exact Nat.zero_le _
      · exact Nat.div_le_of_le_mul (Nat.le_trans (Nat.mul_le_mul_left _ (Nat.min_le_right _ _)) (Nat.le_of_eq (Nat.mul_comm _ _)))
  · exact Nat.zero_le _

/-- 20(3): refinancing an income-earning loan is deductible on the same terms as the loan it repaid. -/
theorem refinancing_inherits (b : Borrowing) (h : b.use = .refinancing) (hp : b.previousUse ≠ .refinancing) :
    deductible.holds b = deductible.holds { b with use := b.previousUse } := by
  have h1 : effectiveUse b = b.previousUse := by simp [effectiveUse, h]
  have h2 : effectiveUse { b with use := b.previousUse } = b.previousUse := by simp [effectiveUse, hp]
  simp only [deductible] at *
  simp [h1, h2]

/-- Money borrowed for a personal use gives no deduction. -/
theorem personal_nil (b : Borrowing) (h : effectiveUse b = .personal) : deduction b = 0 := by
  simp [deduction, deductible, h, earningUse]

end Canteen.ITA.InterestDeductibility

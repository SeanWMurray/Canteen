import Canteen.Core.StatuteSyntax
import Canteen.Core.Answer
import Canteen.Core.Money

/-!
# Support payments: deducted by the payer (60(b)), included by the recipient (56(1)(b))

*Income Tax Act*, as consolidated to 2026-10-29 (verbatim in `statute/ITA-56-1-b-56.1-4-60-b.txt`):

* **56.1(4) "support amount"** an amount payable or receivable as an allowance on a periodic basis for the
  maintenance of the recipient, the recipient's children or both, the recipient having discretion as to
  its use, and (a) the recipient is the payer's spouse or common-law partner (or former one), living
  separate and apart because of the breakdown of the relationship, and the amount is receivable under a
  court order or written agreement, or (b) the payer is a legal parent of a child of the recipient and the
  amount is receivable under a court order under provincial law.
* **"child support amount"** a support amount not identified in the agreement or order as solely for the
  support of the recipient. **"commencement day"** for an agreement or order made after April 1997, the day
  it is made; for an earlier one, a later day the payer and recipient elect, or on which child support is
  varied (among others).
* **60(b)** the payer deducts, for each recipient, A − (B + C): A the support amounts paid after 1996 while
  living apart, B the child support amounts that became payable on or after the commencement day for
  periods beginning on or after it, C the support amounts deducted in earlier years. **56(1)(b)** the
  recipient includes the same, received and receivable.

Because B counts child support payable, not paid, a payment goes to child support first: a payer behind
on child support deducts nothing until it is caught up. The amounts are totals since 1997 for one payer
and one recipient. Whether an amount is an allowance on a periodic basis, and whether the recipient has
discretion as to its use, are often judgment calls. Not encoded: 56.1(1) to (3), 60.1 (third-party
payments and prior payments), and the commencement day's election rules (the day is given).
-/

namespace Canteen.ITA.Support

structure Facts where
  /-- An allowance on a periodic basis for the maintenance of the recipient and/or the recipient's children. -/
  periodicAllowance : Answer := .fact true
  /-- The recipient has discretion as to the use of the amount. -/
  recipientDiscretion : Answer := .fact true
  /-- (a): a spouse or former spouse, living apart because of a breakdown, under a court order or written agreement. -/
  spouseApartUnderOrderOrAgreement : Bool := true
  /-- (b): the payer is a legal parent of the recipient's child, under a provincial court order. -/
  parentUnderProvincialOrder : Bool := false
  /-- A: support amounts paid (or received) after 1996 and before the end of the year, while living apart. -/
  paidSince1997 : Cents
  /-- B: child support amounts that became payable on or after the commencement day, for periods beginning on or after it. -/
  childSupportPayable : Cents := 0
  /-- C: support amounts deducted (or included) in earlier years. -/
  deductedBefore : Cents := 0
  deriving Repr, Inhabited

/-- 56.1(4) "support amount". -/
statute supportAmount (f : Facts) named "\"support amount\" (56.1(4))" cites "ITA 56.1(4)"
  applies where
    | "periodic allowance" judgments f.periodicAllowance.judgments f.periodicAllowance.value
        => "The amounts are payable as an allowance on a periodic basis for the maintenance of the recipient or the recipient's children."
        else "The amounts are not an allowance on a periodic basis for maintenance (a lump sum, for example)."
    | "discretion" judgments f.recipientDiscretion.judgments f.recipientDiscretion.value
        => "The recipient has discretion as to their use."
        else "The recipient has no discretion as to their use."
    | "(a) or (b)" (f.spouseApartUnderOrderOrAgreement || f.parentUnderProvincialOrder)
        => "They are payable to a former spouse living apart, under an order or written agreement, or by a legal parent under a provincial order."
        else "They are not payable under an order or written agreement to a former spouse living apart, nor by a legal parent under a provincial order."

/-- 60(b), 56(1)(b): A − (B + C), for one payer and recipient. -/
def amount (f : Facts) : Cents :=
  if supportAmount.holds f then f.paidSince1997 - (f.childSupportPayable + f.deductedBefore) else 0

def explain (f : Facts) : Finding :=
  let e := supportAmount.explain f
  let c := formatCents
  ⟨e.conclusion, e.steps ++
    (if supportAmount.holds f then
      [⟨s!"Support paid since 1997 of {c f.paidSince1997}, less child support payable since the commencement day of " ++
        s!"{c f.childSupportPayable} and amounts deducted before of {c f.deductedBefore}: {c (amount f)}.", "ITA 60(b); 56(1)(b)"⟩]
     else []), e.reliesOn⟩

/-! ## Truths -/

/-- Child support first: while child support payable is not caught up, nothing is deductible. -/
theorem child_support_first (f : Facts) (h : f.paidSince1997 ≤ f.childSupportPayable) : amount f = 0 := by
  unfold amount; split
  · exact Nat.sub_eq_zero_of_le (Nat.le_trans h (Nat.le_add_right _ _))
  · rfl

/-- Never more than what was paid. -/
theorem amount_le (f : Facts) : amount f ≤ f.paidSince1997 := by
  unfold amount; split
  · exact Nat.sub_le _ _
  · exact Nat.zero_le _

end Canteen.ITA.Support

import Canteen.Core.StatuteSyntax
import Canteen.Core.Answer
import Canteen.Core.Date
import Canteen.Core.Money

/-!
# Shareholder loans: 15(2), (2.6), 80.4(2), (3) and 20(1)(j)

*Income Tax Act*, as consolidated to 2026-10-29 (verbatim in `statute/ITA-15-2-80.4-20-1-j.txt`):

* **15(2)** A person (other than a corporation resident in Canada) who is (a) a shareholder of a
  corporation, (b) connected with a shareholder, or (c) a member of a partnership or beneficiary of a trust
  that is a shareholder, and who receives a loan from or becomes indebted to the corporation (or a related
  corporation, or a partnership of either), otherwise than by a pertinent loan, includes its amount in income.
* **15(2.6)** Not where the loan is repaid within one year after the end of the lender's taxation year in
  which it was made, and it is established that the repayment was not part of a series of loans and
  repayments.
* **80.4(2)** Such a person who, by virtue of the shareholding, receives a loan is deemed to receive a
  benefit of interest at the prescribed rate on it for the period outstanding, less interest paid for the
  year within 30 days after it; **80.4(3)** not on a loan (a) at an arm's length commercial rate, or (b)
  included in income (under 15(2)).
* **20(1)(j)** A loan included under 15(2) is deducted in the year it is repaid, if the repayment was
  not part of a series of loans and repayments.

Whether the borrower is a shareholder (or connected, or a partner or beneficiary), whether the lender is
the corporation or a related one, and whether the loan is pertinent are facts; whether a repayment was
part of a series is a fact or a judgment call. 15(2.2) to (2.4) (other exceptions, such as employee
loans) and 15(2.17) are not encoded. The deemed interest is rounded down to the cent.
-/

namespace Canteen.ITA.ShareholderLoans

structure Facts where
  /-- (a), (b), (c): the borrower is a shareholder, connected with one, or a partner or beneficiary. -/
  shareholderOrConnected : Bool := true
  /-- The borrower is a corporation resident in Canada (or a partnership of them): outside 15(2). -/
  residentCorporation : Bool := false
  /-- The lender is the corporation, a related corporation, or a partnership of either. -/
  lenderInGroup : Bool := true
  /-- A pertinent loan or indebtedness (15(2.11)). -/
  pertinent : Bool := false
  amount : Cents
  /-- The end of the lender's taxation year in which the loan was made. -/
  lenderYearEnd : Date
  /-- When the loan was repaid, if it was. -/
  repaidOn : Option Date := none
  /-- The repayment was part of a series of loans and repayments. Often a judgment call. -/
  series : Answer := .fact false
  /-- 80.4: the prescribed rate in basis points a year, the months outstanding in the year, and the
  interest for the year paid within 30 days after it. -/
  prescribedRate : Nat := 0
  months : Nat := 12
  interestPaid : Cents := 0
  /-- 80.4(3)(a): interest at least an arm's length commercial lender's rate. -/
  commercialRate : Bool := false
  deriving Repr, Inhabited

/-- One year after the end of the lender's year. -/
def deadline (f : Facts) : Date := { f.lenderYearEnd with year := f.lenderYearEnd.year + 1 }

def repaidInTime (f : Facts) : Bool := f.repaidOn.any (·.toDays ≤ (deadline f).toDays)

/-- Subsection 15(2), with 15(2.6). -/
statute included (f : Facts) named "subsection 15(2)" cites "ITA 15(2)"
  applies where
    | "(a)–(c)" (f.shareholderOrConnected && !f.residentCorporation)
        => "The borrower is a shareholder (or connected with one, or a partner or beneficiary of one), not a corporation resident in Canada."
        else "The borrower is not a shareholder or connected with one, or is a corporation resident in Canada."
    | "loan" (f.lenderInGroup && !f.pertinent)
        => "It received a loan from the corporation, a related corporation or a partnership of either, not a pertinent loan."
        else "No loan from the corporation or its group, or the loan is a pertinent loan."
  except where
    | "15(2.6)" := (Rule.clause "15(2.6)" "ITA 15(2.6)" (fun f : Facts => repaidInTime f && !f.series.value)
        "The loan was repaid within one year after the end of the lender's taxation year, not as part of a series of loans and repayments."
        "The loan was not repaid within one year after the end of the lender's taxation year, or the repayment was part of a series."
        (fun f => if repaidInTime f then f.series.judgments else []))

/-- The amount included in income under 15(2). -/
def inclusion (f : Facts) : Cents := if included.holds f then f.amount else 0

/-- 80.4(2): the deemed interest benefit, unless the loan is in income (80.4(3)(b)) or at a commercial rate (80.4(3)(a)). -/
def deemedInterest (f : Facts) : Cents :=
  if f.shareholderOrConnected && !f.residentCorporation && f.lenderInGroup && !included.holds f && !f.commercialRate then
    f.amount * f.prescribedRate * f.months / (10000 * 12) - f.interestPaid
  else 0

/-- 20(1)(j): the deduction in the year of a later repayment of a loan included under 15(2). -/
def repaymentDeduction (f : Facts) (repaid : Cents) : Cents :=
  if included.holds f && !f.series.value then min repaid f.amount else 0

def explain (f : Facts) : Finding :=
  let e := included.explain f
  let c := formatCents
  ⟨e.conclusion, e.steps ++
    (if included.holds f then [⟨s!"So the {c f.amount} loan is included in the borrower's income for the year it was received.", "ITA 15(2)"⟩]
     else if deemedInterest f > 0 then
      [⟨s!"Instead, interest at the prescribed rate, less interest paid, is a benefit: {c (deemedInterest f)}.", "ITA 80.4(2)"⟩]
     else []), e.reliesOn⟩

/-! ## Truths about shareholder loans -/

/-- Never both: a loan in income bears no deemed interest (80.4(3)(b)). -/
theorem not_both (f : Facts) : inclusion f = 0 ∨ deemedInterest f = 0 := by
  unfold inclusion deemedInterest
  cases included.holds f <;> simp

/-- Repaid in time, not in a series: nothing in income. -/
theorem repaid_in_time (f : Facts) (h : repaidInTime f = true) (hs : f.series.value = false) : inclusion f = 0 := by
  simp [inclusion, included, h, hs]

/-- What is included and later repaid comes back out, in full. -/
theorem repayment_restores (f : Facts) (h : included.holds f = true) (hs : f.series.value = false) :
    repaymentDeduction f f.amount = inclusion f := by
  simp [repaymentDeduction, inclusion, h, hs]

end Canteen.ITA.ShareholderLoans

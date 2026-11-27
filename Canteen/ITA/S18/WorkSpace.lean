import Canteen.Core.Money
import Canteen.Core.Finding
import Canteen.Core.Answer

/-!
# Work space in the home: subsections 18(12) (business) and 8(13) (employment)

*Income Tax Act*, as consolidated to 2026-10-29 (verbatim in `statute/ITA-18-12-8-13.txt`):

**18(12)** In computing an individual's income from a business, (a) nothing is deducted for a work space
in the self-contained domestic establishment where the individual resides, except to the extent it is
(i) the individual's principal place of business, or (ii) used exclusively for the business and on a
regular and continuous basis for meeting clients, customers or patients; (b) if so, the deduction is at
most the income from the business computed without it (and without 34.1); and (c) what was not
deductible last year by reason only of (b) is deemed otherwise deductible this year, subject to (a) and (b).

**8(13)** The same for an office or employment: (a)(i) where the individual principally performs the
duties, or (ii) used exclusively for earning the employment income and regularly and continuously for
meeting customers or others in performing the duties; (b) at most the employment income; (c) the carryforward.

The expenses given are the work space's share of the otherwise deductible amounts (the apportionment,
by area or otherwise, is the caller's). The tests in (a)(i) and (ii) are facts or judgment calls. An
amount carried in that cannot be deducted because (a) is not met in the year is not carried further:
it is then not deductible "by reason only of" (b).
-/

namespace Canteen.ITA.WorkSpace

inductive Source where
  | business
  | employment
  deriving Repr, DecidableEq, Inhabited

structure Facts where
  source : Source := .business
  /-- (a)(i): the principal place of business, or where the employee principally performs the duties. -/
  principalPlace : Answer := .fact false
  /-- (a)(ii): used exclusively for the income, and regularly and continuously for meeting clients or others. -/
  exclusiveForMeetings : Answer := .fact false
  /-- The work space's share of the year's otherwise deductible expenses. -/
  expenses : Cents := 0
  /-- (c): last year's amount not deductible by reason only of (b). -/
  carriedIn : Cents := 0
  /-- (b): the income from the business or employment computed without the work space deduction. -/
  income : Cents := 0
  deriving Repr, DecidableEq, Inhabited

def eligible (f : Facts) : Bool := f.principalPlace.value || f.exclusiveForMeetings.value

def available (f : Facts) : Cents := f.expenses + f.carriedIn

def deduction (f : Facts) : Cents := if eligible f then min (available f) f.income else 0

/-- (c): carried to next year, what (b) alone kept out. -/
def carriedForward (f : Facts) : Cents := if eligible f then available f - deduction f else 0

def cite (f : Facts) : String := match f.source with
  | .business => "ITA 18(12)"
  | .employment => "ITA 8(13)"

def judgments (f : Facts) : List String := mergeIds f.principalPlace.judgments f.exclusiveForMeetings.judgments

def explain (f : Facts) : Finding :=
  let c := formatCents
  let place := match f.source with | .business => "principal place of business" | .employment => "place where the duties are principally performed"
  ⟨deduction f > 0,
    (if !eligible f then
      [⟨s!"The work space is not the {place}, nor used exclusively and regularly for meeting clients: nothing is deducted for it.", cite f ++ "(a)"⟩]
    else
      [⟨s!"The work space is " ++ (if f.principalPlace.value then s!"the {place}" else "used exclusively and regularly for meeting clients") ++
          s!": {c (f.expenses)} for the year and {c f.carriedIn} carried in may be deducted.", cite f ++ "(a), (c)"⟩,
       ⟨s!"At most the income of {c f.income}: {c (deduction f)} is deducted, and {c (carriedForward f)} carries forward.", cite f ++ "(b), (c)"⟩]),
    judgments f⟩

/-! ## Truths -/

/-- The deduction never creates or increases a loss. -/
theorem deduction_le_income (f : Facts) : deduction f ≤ f.income := by
  unfold deduction; split
  · exact Nat.min_le_right _ _
  · exact Nat.zero_le _

/-- Nothing is lost while the work space qualifies: deducted plus carried is what was available. -/
theorem nothing_lost (f : Facts) (h : eligible f = true) : deduction f + carriedForward f = available f := by
  simp only [deduction, carriedForward, h, ite_true]
  exact Nat.add_sub_cancel' (Nat.min_le_left _ _)

theorem not_eligible (f : Facts) (h : eligible f = false) : deduction f = 0 ∧ carriedForward f = 0 := by
  simp [deduction, carriedForward, h]

end Canteen.ITA.WorkSpace

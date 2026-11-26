import Canteen.Core.StatuteSyntax
import Canteen.ITA.S74.Attribution

/-!
# Subsections 74.1(1) to (3): income attributed back to the transferor or lender

*Income Tax Act*, as consolidated to 2026-10-29 (verbatim in `statute/ITA-74.1-74.5-2-3.txt`):

> 74.1(1) If an individual has transferred or lent property …, either directly or indirectly, by
> means of a trust or by any other means whatever, to or for the benefit of a person who is the
> individual's spouse or common-law partner or who has since become the individual's spouse or
> common-law partner, any income or loss … of that person for a taxation year from the property
> or from property substituted therefor, that relates to the period in the year throughout which
> the individual is resident in Canada and that person is the individual's spouse or common-law
> partner, is deemed to be income or a loss … of the individual for the year and not of that person.
>
> (2) If an individual has transferred or lent property … to or for the benefit of a person who
> was under 18 years of age … and who (a) does not deal with the individual at arm's length, or
> (b) is the niece or nephew of the individual, any income or loss … of that person for a taxation
> year from the property or from property substituted for that property, that relates to the
> period in the taxation year throughout which the individual is resident in Canada, is deemed to
> be income or a loss … of the individual and not of that person unless that person has, before
> the end of the taxation year, attained the age of 18 years.
>
> (3) … where … the lent or transferred property or property substituted therefor is used (a) to
> repay, in whole or in part, borrowed money with which other property was acquired, or (b) to
> reduce an amount payable for other property, there shall be included in computing the income
> from the lent or transferred property … that proportion of the income or loss … derived after
> that time from the other property … that the fair market value at that time of the lent or
> transferred property … that is so used is of the cost to that person of the other property at
> the time of its acquisition …
>
> 74.5(2) … subsections 74.1(1) and (2) and section 74.2 do not apply to any income, gain or loss
> derived in a particular taxation year from lent property … if (a) interest was charged on the
> loan at a rate equal to or greater than the lesser of (i) the prescribed rate … at the time the
> loan was made, and (ii) the [arm's length] rate …; (b) the … interest … payable in respect of
> the particular year … was paid not later than 30 days after the end of the particular year; and
> (c) the … interest … payable in respect of each taxation year preceding the particular year …
> was paid not later than 30 days after the end of each such taxation year.
>
> 74.5(3) … (a) subsection 74.1(1) does not apply with respect to any income or loss from the
> property … that relates to the period throughout which the individual is living separate and
> apart from that person by reason of a breakdown of their marriage or common-law partnership …

74.5(1) (a transfer for fair market value) is `Attribution.fairMarketValueException`. Income from
the property (interest, dividends, rent), not business income, is what is attributed; which
amounts are income from the property or substituted property, and which fall in the period, are
given. Income earned on attributed income ("second-generation" income) is not income from the
property and is left with the recipient. Not encoded: 74.1(1)'s exclusion for pension assignments
(a fact the caller excludes), 74.3, 74.4 (corporate attribution) and 56(4.1).
-/

namespace Canteen.ITA.IncomeAttribution

/-- Who received the property. -/
inductive Recipient where
  /-- (1): the individual's spouse or common-law partner, or one who has since become so. -/
  | spouse
  /-- (2): under 18 when the property was transferred or lent, and not at arm's length with the
  individual or the individual's niece or nephew; `adultByYearEnd` if 18 before the end of the year. -/
  | minor (adultByYearEnd : Bool := false)
  /-- Anyone else, for example an adult child. -/
  | other
  deriving Repr, DecidableEq, Inhabited

/-- One amount of income or loss of the recipient from the property, or substituted property. -/
structure Amount where
  description : String
  income : Cents := 0
  loss : Cents := 0
  /-- In the period in the year throughout which the individual is resident in Canada (and, for
  (1), the recipient is the individual's spouse or common-law partner). -/
  inPeriod : Bool := true
  /-- 74.5(3)(a): relates to a period throughout which the two live apart because of a breakdown. -/
  separated : Bool := false
  deriving Repr, DecidableEq, Inhabited

/-- 74.1(3): the property was used to repay borrowed money with which other property was acquired,
or to reduce an amount payable for other property. -/
structure Repayment where
  /-- The fair market value, at that time, of the property so used. -/
  usedValue : Cents
  /-- The recipient's cost of the other property when acquired. -/
  otherCost : Cents
  /-- Income from the other property after that time, in the year (and period). -/
  otherIncome : Cents := 0
  otherLoss : Cents := 0
  deriving Repr, DecidableEq, Inhabited

/-- 74.5(2): the property was lent. -/
structure Loan where
  /-- (a) interest at least the lesser of the prescribed rate when the loan was made and an arm's length rate. -/
  adequateRate : Bool
  /-- (b), (c) the interest for the year and each preceding year paid within 30 days after year-end. -/
  paidOnTime : Bool
  deriving Repr, DecidableEq, Inhabited

structure Facts where
  recipient : Recipient
  /-- The transfer, for 74.5(1) (its `toSpouse` is taken from the recipient). -/
  transfer : Attribution.Transfer := {}
  loan : Option Loan := none
  amounts : List Amount
  repayment : Option Repayment := none
  deriving Repr, Inhabited

def exceptionTransfer (f : Facts) : Attribution.Transfer :=
  { f.transfer with toSpouse := f.recipient == .spouse }

/-- 74.5(2): a loan at an adequate rate with the interest paid on time. -/
def loanForValue (f : Facts) : Bool := f.loan.any fun l => l.adequateRate && l.paidOnTime

/-- Subsections 74.1(1) and (2), with 74.5(1) and (2). -/
statute applies (f : Facts) named "subsection 74.1(1) or (2)" cites "ITA 74.1(1), (2)"
  applies where
    | "recipient" (f.recipient != .other)
        => "The property was transferred or lent to the individual's spouse or common-law partner, or to a minor not at arm's length with the individual or a niece or nephew."
        else "The property was not transferred or lent to a spouse or common-law partner, or to a minor not at arm's length or a niece or nephew."
  except where
    | "turned 18" (f.recipient == .minor true)
        => "The minor attained 18 years of age before the end of the year (74.1(2))."
        else "The recipient is not a minor who attained 18 before the end of the year."
    | "74.5(1)" := (Rule.clause "74.5(1)" "ITA 74.5(1)" (fun f : Facts => Attribution.fairMarketValueException.holds (exceptionTransfer f))
        "The property was transferred for fair market value consideration, on the terms of 74.5(1)."
        "The property was not transferred on the terms of 74.5(1).")
    | "74.5(2)" := (Rule.clause "74.5(2)" "ITA 74.5(2)" loanForValue
        "The property was lent at interest at least the lesser of the prescribed and an arm's length rate, paid within 30 days after each year-end."
        "The property was not lent at an adequate rate with interest paid on time.")

/-- The amounts that are attributed: in the period, and for a spouse, not while separated. -/
def counted (f : Facts) : List Amount :=
  f.amounts.filter fun a => a.inPeriod && !(f.recipient == .spouse && a.separated)

/-- 74.1(3): the proportion of the other property's income, rounded down. -/
def repaymentShare (r : Repayment) : Cents × Cents :=
  if r.otherCost = 0 then (0, 0)
  else (r.otherIncome * min r.usedValue r.otherCost / r.otherCost, r.otherLoss * min r.usedValue r.otherCost / r.otherCost)

/-- The income attributed to the individual. -/
def attributedIncome (f : Facts) : Cents :=
  if applies.holds f then
    ((counted f).map (·.income)).sum + ((f.repayment.map repaymentShare).map (·.1)).getD 0
  else 0

/-- The loss attributed to the individual. -/
def attributedLoss (f : Facts) : Cents :=
  if applies.holds f then
    ((counted f).map (·.loss)).sum + ((f.repayment.map repaymentShare).map (·.2)).getD 0
  else 0

/-- The recipient's income from the property, after attribution. -/
def recipientIncome (f : Facts) : Cents := (f.amounts.map (·.income)).sum - (if applies.holds f then ((counted f).map (·.income)).sum else 0)

def explain (f : Facts) : Finding :=
  let e := applies.explain f
  if !applies.holds f then e else
  ⟨true, e.steps ++ [
    ⟨s!"So {formatCents (attributedIncome f)} of income" ++
      (if attributedLoss f > 0 then s!" and {formatCents (attributedLoss f)} of losses" else "") ++
      " from the property (or property substituted for it) in the period is the individual's, and not the recipient's." ++
      (if f.repayment.isSome then " That includes the share of the other property's income under 74.1(3)." else ""),
      if f.recipient == .spouse then "ITA 74.1(1)" else "ITA 74.1(2)"⟩], e.reliesOn⟩

/-- Subsections 74.1(1) and (2), as a rule, with the amount. -/
def rule : Rule Facts where
  name := "subsection 74.1(1) or (2)"
  citation := "ITA 74.1(1), (2)"
  holds := applies.holds
  explain := explain
  sound := fun f => by unfold explain; split <;> simp_all

/-! ## Truths about income attribution -/

/-- A loan at the prescribed rate, the interest paid on time, attributes nothing. -/
theorem prescribed_rate_loan (f : Facts) (h : loanForValue f = true) : attributedIncome f = 0 ∧ attributedLoss f = 0 := by
  simp [attributedIncome, attributedLoss, applies, h]

/-- Once a minor turns 18 before year-end, nothing for that year. -/
theorem adult_by_year_end (f : Facts) (h : f.recipient = .minor true) : attributedIncome f = 0 := by
  simp [attributedIncome, applies, h]

/-- An adult child is outside 74.1 (though 56(4.1) may reach a low-interest loan). -/
theorem other_outside (f : Facts) (h : f.recipient = .other) : attributedIncome f = 0 := by
  simp [attributedIncome, applies, h]

/-- 74.1(3): the share of the other property's income never exceeds that income. -/
theorem repayment_share_le (r : Repayment) : (repaymentShare r).1 ≤ r.otherIncome := by
  unfold repaymentShare; split
  · exact Nat.zero_le _
  · exact Nat.div_le_of_le_mul (by rw [Nat.mul_comm r.otherCost]; exact Nat.mul_le_mul_left _ (Nat.min_le_right _ _))

private theorem sum_filter_le (p : Amount → Bool) (g : Amount → Nat) (l : List Amount) :
    ((l.filter p).map g).sum ≤ (l.map g).sum := by
  induction l with
  | nil => simp
  | cons a as ih =>
    simp only [List.filter_cons]
    split
    · simp only [List.map_cons, List.sum_cons]; exact Nat.add_le_add_left ih _
    · simp only [List.map_cons, List.sum_cons]; exact Nat.le_trans ih (Nat.le_add_left _ _)

/-- Nothing is lost or counted twice: without a repayment, the individual's and the recipient's
shares of the income add up to it. -/
theorem income_split (f : Facts) (h : f.repayment = none) :
    attributedIncome f + recipientIncome f = (f.amounts.map (·.income)).sum := by
  have hle := sum_filter_le (fun a => a.inPeriod && !(f.recipient == .spouse && a.separated)) (fun a => a.income) f.amounts
  unfold attributedIncome recipientIncome; split
  · simp only [Option.map_none, Option.getD_none, Nat.add_zero, *]
    exact Nat.add_sub_of_le hle
  · simp_all

end Canteen.ITA.IncomeAttribution

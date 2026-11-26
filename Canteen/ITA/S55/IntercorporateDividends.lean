import Canteen.Core.StatuteSyntax
import Canteen.Core.Answer
import Canteen.Core.Money

/-!
# Subsection 112(1) and subsection 55(2): intercorporate dividends, and when they are gains

*Income Tax Act*, as consolidated to 2026-10-29 (verbatim in `statute/ITA-112-1-55-2.txt`):

**112(1)** A corporation that receives a taxable dividend from (a) a taxable Canadian corporation,
or (b) a corporation resident in Canada (other than a non-resident-owned investment corporation or
one exempt from tax) and controlled by it, may deduct an amount equal to the dividend in computing
its taxable income.

**55(2.1)** Subsection (2) applies to a taxable dividend received by a corporation resident in
Canada (the dividend recipient) as part of a transaction, event or series if (a) the recipient is
entitled to a 112(1) deduction for it; (b) (i) one of the purposes of the dividend (or, for an
84(3) dividend, one of its results) is to effect a significant reduction in the capital gain that,
but for the dividend, would have been realized on a disposition of any share at fair market value
immediately before the dividend, or (ii) [for a dividend on a share held as capital property, not
on a redemption] one of its purposes is to effect a significant reduction in the fair market
value of any share or a significant increase in the cost of property; and (c) the dividend
exceeds the income earned or realized by any corporation after 1971 and before the safe-income
determination time that could reasonably be considered to contribute to the capital gain on the
share ("safe income").

**55(2)** The dividend is then deemed (a) not to be a dividend received by the recipient, (b) if
received on a redemption, acquisition or cancellation to which 84(2) or (3) applies, to be
proceeds of disposition of the share, and (c) otherwise, to be a gain from the disposition of a
capital property. (Part IV tax not refunded is excluded.)

**55(3)(a)** Subsection (2) does not apply to a dividend on a redemption, acquisition or
cancellation to which 84(2) or (3) applies if, as part of the series, there was not (i) a
disposition of property (other than money on a dividend or paid-up capital reduction, or property
for at least fair market value) to an unrelated person, (ii) a significant increase in an unrelated
person's total direct interest in any corporation, (iii) a disposition to an unrelated person of
shares of the dividend payer (or property more than 10% of whose value derives from its shares or
debt), (iv) after the dividend, such a disposition of the recipient's shares (or such property),
or (v) a significant increase in unrelated persons' direct interests in the dividend payer.
**55(3)(b)**: nor to a dividend on a qualifying butterfly reorganization.

**55(5)(f)** The dividend is split into two separate dividends: the lesser of it and safe income,
and the rest.

The purposes in (2.1)(b) are judgment calls (or facts). Each of the events in 55(3)(a)(i) to (v) is
given as a fact, with "unrelated person" (55(3.01)(a)) decided by the caller. Safe income is given.
After 55(5)(f), (2.1)(c) is read as reaching the excess portion and not the safe-income portion.
Not encoded: 112(2) to (2.9), 138(6), 55(2.2) to (2.5), 55(3.01)(b) to (g), the conditions of
55(3)(b) (a fact), 55(3.1) to (3.2), and Part IV tax.
-/

namespace Canteen.ITA.IntercorporateDividends

/-- The payer, for 112(1). -/
inductive Payer where
  /-- (a): a taxable Canadian corporation. -/
  | taxableCanadian
  /-- (b): a corporation resident in Canada, controlled by the recipient (not a NRO or exempt). -/
  | residentControlled
  /-- Anyone else, for example a non-resident corporation. -/
  | other
  deriving Repr, DecidableEq, Inhabited

/-- The events in 55(3)(a)(i) to (v), any of which (involving an unrelated person) takes a
redemption dividend out of the related-party exception. -/
inductive UnrelatedEvent where
  | dispositionOfProperty
  | increaseInInterest
  | dispositionOfPayerShares
  | dispositionOfRecipientShares
  | increaseInPayerInterest
  deriving Repr, DecidableEq, Inhabited

structure Facts where
  /-- The dividend, e.g. `"the dividend on the redemption of Opco's preferred shares"`. -/
  description : String
  amount : Cents
  /-- The dividend recipient is a corporation resident in Canada. -/
  recipientResident : Bool := true
  payer : Payer := .taxableCanadian
  /-- Received on a redemption, acquisition or cancellation of a share to which 84(2) or (3) applies. -/
  onRedemption : Bool := false
  /-- (2.1)(b)(i): one of the purposes (for an 84(3) dividend, one of the results) is a significant
  reduction in the capital gain on a share. -/
  reducesGain : Answer
  /-- (2.1)(b)(ii): on a share held as capital property, one of the purposes is a significant
  reduction in a share's value or a significant increase in the cost of property. -/
  reducesValueOrIncreasesCost : Answer := .fact false
  /-- (2.1)(c), 55(5)(f): the safe income contributing to the gain on the share. -/
  safeIncome : Cents
  /-- 55(3)(a): the events in the series, each involving an unrelated person. -/
  unrelatedEvents : List UnrelatedEvent := []
  /-- 55(3)(b): a qualifying butterfly reorganization. -/
  butterfly : Bool := false
  deriving Repr, Inhabited

/-- 112(1): the dividend may be deducted, but for 55(2). -/
def deductible (f : Facts) : Bool := f.payer != .other

/-- (2.1)(b). -/
def purposeTest (f : Facts) : Bool :=
  f.reducesGain.value || (!f.onRedemption && f.reducesValueOrIncreasesCost.value)

def purposeJudgments (f : Facts) : List String :=
  mergeIds f.reducesGain.judgments (if f.onRedemption then [] else f.reducesValueOrIncreasesCost.judgments)

/-- 55(5)(f)(ii): the portion over safe income, a separate dividend. -/
def excessPortion (f : Facts) : Cents := f.amount - f.safeIncome

/-- 55(3)(a): a redemption dividend in a series with no event involving an unrelated person. -/
def relatedPartyException (f : Facts) : Bool := f.onRedemption && f.unrelatedEvents.isEmpty

/-- Subsection 55(2), with (2.1), (3) and (5)(f), for the portion of the dividend over safe income. -/
statute subsection55_2 (f : Facts) named "subsection 55(2)" cites "ITA 55(2)"
  applies where
    | "(2.1) recipient" f.recipientResident
        => "The dividend recipient is a corporation resident in Canada."
        else "The dividend recipient is not a corporation resident in Canada."
    | "(2.1)(a)" := (Rule.clause "(2.1)(a)" "ITA 55(2.1)(a)" deductible
        "The recipient is entitled to deduct the dividend under subsection 112(1)."
        "The recipient is not entitled to deduct the dividend under subsection 112(1).")
    | "(2.1)(b)" := (Rule.clause "(2.1)(b)" "ITA 55(2.1)(b)" purposeTest
        "One of the purposes (or, for an 84(3) dividend, one of the results) of the dividend is a significant reduction in the capital gain on a share, or in a share's value or an increase in cost."
        "None of the purposes (or results) of the dividend is a significant reduction in a capital gain or a share's value, or an increase in cost."
        purposeJudgments)
    | "(2.1)(c), (5)(f)" := (Rule.clause "(2.1)(c), (5)(f)" "ITA 55(2.1)(c); 55(5)(f)" (fun f : Facts => 0 < excessPortion f)
        "The dividend exceeds the safe income that could reasonably be considered to contribute to the capital gain on the share; the excess is a separate dividend."
        "The dividend does not exceed the safe income contributing to the capital gain on the share.")
  except where
    | "(3)(a)" := (Rule.clause "(3)(a)" "ITA 55(3)(a)" relatedPartyException
        "The dividend is on a redemption, and no disposition to or increase in interest of an unrelated person in 55(3)(a)(i) to (v) is part of the series."
        "The dividend is not on a redemption in a series free of the dispositions and increases in interest in 55(3)(a)(i) to (v).")
    | "(3)(b)" := (Rule.clause "(3)(b)" "ITA 55(3)(b)" (fun f : Facts => f.butterfly)
        "The dividend is received on a qualifying butterfly reorganization."
        "The dividend is not received on a butterfly reorganization.")

/-- The amount 55(2) recharacterizes. -/
def caught (f : Facts) : Cents := if subsection55_2.holds f then excessPortion f else 0

/-- 55(2)(b): added to the proceeds of disposition of the redeemed share. -/
def proceedsAddition (f : Facts) : Cents := if f.onRedemption then caught f else 0

/-- 55(2)(c): a gain from the disposition of a capital property. -/
def gain (f : Facts) : Cents := if f.onRedemption then 0 else caught f

/-- 112(1): the deduction, on what remains a dividend. -/
def deduction (f : Facts) : Cents := if deductible f then f.amount - caught f else 0

def explain (f : Facts) : Finding :=
  let e := subsection55_2.explain f
  let c := formatCents
  let tail : List Step :=
    if subsection55_2.holds f then
      [⟨s!"So {c (caught f)}, the excess over safe income of {c f.safeIncome}, is deemed not to be a dividend, but " ++
          (if f.onRedemption then "proceeds of disposition of the redeemed share." else "a gain from the disposition of a capital property."),
          if f.onRedemption then "ITA 55(2)(a), (b)" else "ITA 55(2)(a), (c)"⟩,
       ⟨s!"The recipient deducts the remaining {c (deduction f)} under subsection 112(1).", "ITA 112(1)"⟩]
    else if deductible f then
      [⟨s!"So the whole dividend of {c f.amount} remains a dividend, deductible under subsection 112(1).", "ITA 112(1)"⟩]
    else []
  ⟨subsection55_2.holds f, e.steps ++ tail, e.reliesOn⟩

/-- Subsection 55(2), as a rule, with its consequences. -/
def rule : Rule Facts where
  name := "subsection 55(2)"
  citation := "ITA 55(2)"
  holds := subsection55_2.holds
  explain := explain
  sound := fun _ => rfl

/-! ## Truths about 55(2) -/

/-- A dividend within safe income is never recharacterized, and is fully deductible. -/
theorem within_safe_income (f : Facts) (h : f.amount ≤ f.safeIncome) (hd : deductible f = true) :
    caught f = 0 ∧ deduction f = f.amount := by
  have : excessPortion f = 0 := Nat.sub_eq_zero_of_le h
  simp [caught, deduction, hd, this]

/-- The recharacterized amount never exceeds the excess over safe income. -/
theorem caught_le_excess (f : Facts) : caught f ≤ f.amount - f.safeIncome := by
  unfold caught excessPortion; split
  · exact Nat.le_refl _
  · exact Nat.zero_le _

/-- **55(3)(a).** A redemption dividend in a series involving no unrelated person is never caught. -/
theorem related_redemption (f : Facts) (hr : f.onRedemption = true) (he : f.unrelatedEvents = []) : caught f = 0 := by
  simp [caught, subsection55_2, relatedPartyException, hr, he]

/-- Nothing is lost: what 55(2) takes out of the deduction becomes proceeds or a gain. -/
theorem conserved (f : Facts) (hd : deductible f = true) (h : caught f ≤ f.amount) :
    deduction f + proceedsAddition f + gain f = f.amount := by
  unfold deduction proceedsAddition gain
  simp only [hd, ite_true]
  split <;> simp [Nat.sub_add_cancel h]

end Canteen.ITA.IntercorporateDividends

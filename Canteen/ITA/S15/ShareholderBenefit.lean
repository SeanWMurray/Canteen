import Canteen.Core.StatuteSyntax
import Canteen.Core.Answer
import Canteen.Core.Money

/-!
# Subsection 15(1): benefits conferred on a shareholder

*Income Tax Act*, as consolidated to 2026-10-29 (verbatim in `statute/ITA-15-1.txt`):

**15(1)** If a benefit is conferred by a corporation on a shareholder (or a member of a partnership that
is a shareholder, or a contemplated shareholder), its amount or value is included in the shareholder's
income for the year, except to the extent it is deemed by section 84 to be a dividend, or it is conferred
(a) by a corporation resident in Canada by a reduction of paid-up capital, a redemption, acquisition or
cancellation of shares, on the winding-up, discontinuance or reorganization of its business, or by a
transaction to which 88(1) or (2) applies; (a.1) by a non-resident corporation in the corresponding ways;
(b) by a dividend or stock dividend; (c) by identical rights to acquire shares conferred on all common
shareholders; or (d) by an action to which 84(1)(c.1) to (c.3) applies.

Whether the benefit was conferred on the person in their capacity as shareholder (rather than, for
example, as an employee, where 6(1)(a) applies instead) is often a judgment call. The benefit is its
value less what the shareholder paid for it. Not encoded: 15(1.1) to (1.4), 15(7), (9), 56(2) and 246(1)
(benefits to others), 80.4 (in `ShareholderLoans`), and the corporation's side (no deduction, 18(1)(a)).
-/

namespace Canteen.ITA.ShareholderBenefit

/-- How the benefit was conferred. -/
inductive Way where
  /-- Any other way: use of property, payment of personal expenses, a transfer at undervalue, and so on. -/
  | other
  /-- (a)(i) or (a.1)(ii): a reduction of paid-up capital. -/
  | paidUpCapitalReduction
  /-- (a)(ii) or (a.1)(iii): a redemption, acquisition or cancellation of shares. -/
  | redemption
  /-- (a)(iii) or (a.1)(iv): on the winding-up, discontinuance or reorganization (or liquidation). -/
  | windingUp
  /-- (a)(iv): a transaction to which 88(1) or (2) applies (resident corporation only). -/
  | section88
  /-- (a.1)(i): a distribution to which 86.1(1) applies (non-resident corporation only). -/
  | section86_1
  /-- (b): a dividend or stock dividend. -/
  | dividend
  /-- (c): identical rights to acquire shares, conferred on all common shareholders. -/
  | rightsOffering
  /-- (d): an action to which 84(1)(c.1) to (c.3) applies. -/
  | surplusConversion
  deriving Repr, DecidableEq, Inhabited

structure Facts where
  description : String
  /-- A shareholder, a member of a partnership that is one, or a contemplated shareholder. -/
  shareholder : Bool := true
  /-- Conferred on the person as shareholder (not, for example, as an employee). Often a judgment call. -/
  asShareholder : Answer := .fact true
  corporationResident : Bool := true
  way : Way := .other
  /-- The amount or value of the benefit, and what the shareholder paid for it. -/
  value : Cents
  paid : Cents := 0
  /-- The part deemed by section 84 to be a dividend. -/
  deemedDividend : Cents := 0
  deriving Repr, Inhabited

/-- The exceptions in (a) to (d). -/
def excepted (f : Facts) : Bool :=
  match f.way with
  | .other => false
  | .section88 => f.corporationResident
  | .section86_1 => !f.corporationResident
  | _ => true

/-- Subsection 15(1). -/
statute applies (f : Facts) named "subsection 15(1)" cites "ITA 15(1)"
  applies where
    | "shareholder" f.shareholder
        => "The person is a shareholder of the corporation (or a partner of one, or a contemplated shareholder)."
        else "The person is not a shareholder, a partner of one, or a contemplated shareholder."
    | "as shareholder" judgments f.asShareholder.judgments f.asShareholder.value
        => "The benefit was conferred on the person in their capacity as shareholder."
        else "The benefit was conferred in another capacity (as an employee, for example)."
  except where
    | "(a) to (d)" (excepted f)
        => "It was conferred in one of the ways excepted (a return of capital, a redemption, a winding-up, a dividend, a rights offering and the like)."
        else "It was not conferred in any of the ways excepted."

/-- The amount included. -/
def inclusion (f : Facts) : Cents := if applies.holds f then f.value - f.paid - f.deemedDividend else 0

def explain (f : Facts) : Finding :=
  let e := applies.explain f
  let c := formatCents
  ⟨e.conclusion, e.steps ++
    (if applies.holds f then
      [⟨s!"The benefit ({f.description}) is worth {c f.value}; less {c f.paid} paid and {c f.deemedDividend} deemed a dividend, " ++
        s!"{c (inclusion f)} is included in income.", "ITA 15(1)"⟩] else []), e.reliesOn⟩

/-! ## Truths -/

/-- Paid for at full value: nothing is included. -/
theorem paid_in_full (f : Facts) (h : f.value ≤ f.paid) : inclusion f = 0 := by
  unfold inclusion; split
  · rw [Nat.sub_eq_zero_of_le h]; exact Nat.zero_sub _
  · rfl

/-- A dividend is never a 15(1) benefit as well. -/
theorem not_dividend (f : Facts) (h : f.way = .dividend) : inclusion f = 0 := by
  simp [inclusion, applies, excepted, h]

end Canteen.ITA.ShareholderBenefit

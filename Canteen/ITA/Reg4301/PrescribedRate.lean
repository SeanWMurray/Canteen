import Canteen.Core.Finding

/-!
# The prescribed rate of interest: Regulation 4301

*Income Tax Regulations*, as consolidated to 2026-10-29 (verbatim in `statute/ITR-4301.txt`):

**4301** The prescribed rate for a quarter is (c), for the provisions that refer to a prescribed rate
(80.4, 74.5(2) and the others): the simple arithmetic mean of the average equivalent yields of 3-month
Government of Canada Treasury Bills sold at auction in the first month of the preceding quarter, rounded
to the next higher whole percentage where the mean is not a whole percentage; (a) for interest owed to
the Receiver General, that rate plus 4%; (b) for interest the Minister pays, that rate plus 2% (plus nil
for a corporation); (b.1) for 17.1(1), (a) with the mean taken to two decimals.

The auctions' average yields are given, in thousandths of a percent (as the Bank of Canada publishes
them, to three decimals); they are not available from Statistics Canada, whose tables hold a single
monthly auction figure, and the Bank of Canada's site is not reachable here. Rates are returned in
basis points. 4302 (rates for certain earlier periods) is not encoded.
-/

namespace Canteen.ITA.PrescribedRate

/-- 4301(a)(i): the mean of the yields (in thousandths of a percent), rounded up to a whole percent,
in basis points. -/
def base (yields : List Nat) : Nat :=
  if yields.isEmpty then 0 else
    let s := yields.sum
    let d := yields.length * 1000
    ((s + d - 1) / d) * 100

/-- 4301(c): the rate for 80.4, 74.5(2) and the other provisions that refer to a prescribed rate. -/
def general (yields : List Nat) : Nat := base yields

/-- 4301(a): on amounts owed to the Receiver General. -/
def owing (yields : List Nat) : Nat := base yields + 400

/-- 4301(b): on amounts the Minister pays. -/
def refund (yields : List Nat) (corporation : Bool) : Nat := base yields + (if corporation then 0 else 200)

def explain (yields : List Nat) : Finding :=
  ⟨true, [⟨s!"The mean of {yields.length} three-month Treasury Bill auction yields, rounded up to a whole percent: " ++
      s!"{base yields} basis points; {owing yields} on amounts owed, {refund yields false} on refunds to individuals.", "ITR 4301"⟩], []⟩

/-! ## Truths -/

/-- The prescribed rate is a whole percent. -/
theorem whole (yields : List Nat) : base yields % 100 = 0 := by
  unfold base; split
  · rfl
  · exact Nat.mul_mod_left _ _

/-- Owing is always 4% above the base. -/
theorem owing_spread (yields : List Nat) : owing yields = general yields + 400 := rfl

end Canteen.ITA.PrescribedRate

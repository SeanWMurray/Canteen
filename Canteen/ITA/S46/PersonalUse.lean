import Canteen.Core.StatuteSyntax
import Canteen.ITA.S38.CapitalGains

/-!
# Section 46: personal-use property, the $1,000 rule

*Income Tax Act*, as consolidated to 2026-10-29 (verbatim in `statute/ITA-46-1-2-3-5.txt`):

* **46(1)** on a disposition of personal-use property (other than excluded property given to a charity),
  its adjusted cost base and the proceeds are each deemed to be at least $1,000.
* **46(2)** on a disposition of part of one, the part's adjusted cost base and proceeds are each at least
  its share of $1,000, in proportion to its adjusted cost base over the whole property's.
* **46(3)** personal-use properties that would ordinarily be disposed of as a set, disposed of in more than
  one disposition to one person or a non-arm's length group, and worth more than $1,000 in total before the
  first, are one personal-use property, each disposition a disposition of part of it.
* **46(5)** "excluded property": acquired under a promoted gifting arrangement.

Whether the properties would ordinarily be disposed of as a set is often a judgment call. Shares of
$1,000 are rounded down to the cent. Not encoded: 46(4) (a loss on a debt owed in respect of personal-use
property).
-/

namespace Canteen.ITA.PersonalUse

def floor : Cents := 100000

/-- 46(1): the disposition with the $1,000 floors (unless excluded property given to a charity). -/
def apply (d : CapitalGains.Disposition) (excludedGift : Bool := false) : CapitalGains.Disposition :=
  if excludedGift then d else { d with adjustedCostBase := max floor d.adjustedCostBase, proceeds := max floor d.proceeds }

/-- 46(2)(a)(ii): the part's share of $1,000. -/
def partFloor (partAcb wholeAcb : Cents) : Cents := if wholeAcb = 0 then 0 else floor * partAcb / wholeAcb

/-- 46(2): a disposition of part, with the part's share of the floor. -/
def applyPart (d : CapitalGains.Disposition) (wholeAcb : Cents) (excludedGift : Bool := false) : CapitalGains.Disposition :=
  if excludedGift then d else
    let pf := partFloor d.adjustedCostBase wholeAcb
    { d with adjustedCostBase := max pf d.adjustedCostBase, proceeds := max pf d.proceeds }

structure SetFacts where
  /-- Would ordinarily be disposed of in one disposition as a set. Often a judgment call. -/
  ordinarilyASet : Answer
  /-- (a): disposed of by more than one disposition, all acquired by one person or a non-arm's length group. -/
  piecemealToOneGroup : Bool
  /-- (b): their total fair market value immediately before the first disposition. -/
  totalValue : Cents
  deriving Repr, Inhabited

/-- Subsection 46(3). -/
statute set (s : SetFacts) named "subsection 46(3)" cites "ITA 46(3)"
  applies where
    | "a set" judgments s.ordinarilyASet.judgments s.ordinarilyASet.value
        => "The properties would ordinarily be disposed of in one disposition as a set."
        else "The properties would not ordinarily be disposed of as a set."
    | (a) s.piecemealToOneGroup
        => "They were disposed of in more than one disposition, all to one person or a group not dealing at arm's length."
        else "They were not all acquired, piecemeal, by one person or a non-arm's length group."
    | (b) decide (floor < s.totalValue)
        => "They were worth more than $1,000 in total before the first disposition."
        else "They were worth $1,000 or less in total before the first disposition."

/-- Each piece: under 46(3), a part of one property (46(2)); otherwise a property of its own (46(1)). -/
def applyPiece (s : SetFacts) (d : CapitalGains.Disposition) (setAcb : Cents) : CapitalGains.Disposition :=
  if set.holds s then applyPart d setAcb else apply d

/-! ## Truths -/

/-- Under the floor, neither a gain nor a loss: a $400 item sold for $300 or $900. -/
theorem below_floor (d : CapitalGains.Disposition) (ha : d.adjustedCostBase ≤ floor) (hp : d.proceeds ≤ floor) :
    (apply d).adjustedCostBase = floor ∧ (apply d).proceeds = floor := by
  simp [apply, Nat.max_eq_left ha, Nat.max_eq_left hp]

/-- The floor never lowers the adjusted cost base or the proceeds. -/
theorem never_lower (d : CapitalGains.Disposition) (g : Bool) :
    d.adjustedCostBase ≤ (apply d g).adjustedCostBase ∧ d.proceeds ≤ (apply d g).proceeds := by
  unfold apply; split
  · exact ⟨Nat.le_refl _, Nat.le_refl _⟩
  · exact ⟨Nat.le_max_right _ _, Nat.le_max_right _ _⟩

end Canteen.ITA.PersonalUse

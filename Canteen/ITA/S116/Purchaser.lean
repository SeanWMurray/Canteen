import Canteen.Core.Money
import Canteen.Core.Finding
import Canteen.Core.Answer

/-!
# Section 116: the purchaser's liability on buying from a non-resident

*Income Tax Act*, as consolidated to 2026-10-29 (verbatim in `statute/ITA-116-5-5.01-5.3.txt`):

**116(5)** A purchaser that acquires taxable Canadian property (other than depreciable or excluded
property) from a non-resident is liable for, and must remit within 30 days after the end of the month,
25% of the cost to the purchaser over the certificate limit of any 116(2) certificate, unless (a) after
reasonable inquiry it had no reason to believe the vendor was non-resident, (a.1) 116(5.01) applies, or
(b) a 116(4) certificate was issued for the property; and may withhold it from the price.

**116(5.01)** Not where the purchaser concludes after reasonable inquiry that the vendor is resident
in a treaty country, the property would be treaty-protected property, and the purchaser gives the
116(5.02) notice.

**116(5.3)** For property referred to in 116(5.2) (depreciable taxable Canadian property, Canadian
resource and timber resource property, real property inventory, life insurance policies and the like),
50% of the amount payable over the amount fixed in any 116(5.2) certificate, with the same exceptions
but (b).

What is taxable Canadian, excluded (116(6)) or 116(5.2) property, the reasonable inquiries and the
treaty conditions are facts (the inquiry often a judgment call). The vendor's own notices and the
certificates' issue (116(1) to (4), (5.2)) are given as their limits. 116(5.4) and the penalties are
not encoded.
-/

namespace Canteen.ITA.Purchaser

inductive Kind where
  /-- 116(5): taxable Canadian property other than depreciable or excluded property. -/
  | capital
  /-- 116(5.2): depreciable taxable Canadian property, resource property, real property inventory and the like. -/
  | listed
  /-- 116(6) "excluded property", or not taxable Canadian property. -/
  | excluded
  deriving Repr, DecidableEq, Inhabited

structure Purchase where
  description : String
  kind : Kind
  /-- The cost to the purchaser (116(5)(c)), or the amount payable (116(5.3)(a)(i)). -/
  cost : Cents
  /-- The 116(2) certificate limit, or the amount fixed in a 116(5.2) certificate. -/
  certificateLimit : Option Cents := none
  /-- 116(5)(b): a 116(4) certificate was issued to the purchaser (capital property only). -/
  section116_4 : Bool := false
  /-- 116(5)(a): after reasonable inquiry, no reason to believe the vendor was non-resident. -/
  noReasonToBelieve : Answer := .fact false
  /-- 116(5.01): treaty residence concluded after reasonable inquiry, treaty-protected property, notice given. -/
  treatyProtected : Bool := false
  deriving Repr, DecidableEq, Inhabited

def Purchase.rate (p : Purchase) : Nat := if p.kind == .listed then 50 else 25

def Purchase.excepted (p : Purchase) : Bool :=
  p.kind == .excluded || p.noReasonToBelieve.value || p.treatyProtected || (p.kind == .capital && p.section116_4)

/-- The tax the purchaser is liable to remit, and may withhold. -/
def Purchase.liability (p : Purchase) : Cents :=
  if p.excepted then 0 else (p.cost - p.certificateLimit.getD 0) * p.rate / 100

def explain (p : Purchase) : Finding :=
  let c := formatCents
  ⟨p.liability > 0,
    [if p.kind == .excluded then ⟨s!"{p.description}: excluded property; no liability.", "ITA 116(6)"⟩
     else if p.excepted then ⟨s!"{p.description}: " ++
        (if p.noReasonToBelieve.value then "after reasonable inquiry, no reason to believe the vendor was non-resident"
         else if p.treatyProtected then "treaty-protected property, with the notice given"
         else "a 116(4) certificate was issued") ++ "; no liability.", "ITA 116(5)(a), (a.1), (b); 116(5.01)"⟩
     else ⟨s!"{p.description}: {p.rate}% of the cost of {c p.cost} over the certificate limit of {c (p.certificateLimit.getD 0)}: " ++
        s!"{c p.liability} to withhold and remit within 30 days after the end of the month.", if p.kind == .listed then "ITA 116(5.3)" else "ITA 116(5)"⟩],
    p.noReasonToBelieve.judgments⟩

/-! ## Truths -/

theorem Purchase.liability_le (p : Purchase) : p.liability ≤ p.cost * 50 / 100 := by
  unfold Purchase.liability; split
  · exact Nat.zero_le _
  · apply Nat.div_le_div_right
    apply Nat.mul_le_mul (Nat.sub_le _ _)
    unfold Purchase.rate; split <;> decide

/-- A certificate limit of the whole cost: no liability. -/
theorem Purchase.full_certificate (p : Purchase) (h : p.certificateLimit = some p.cost) : p.liability = 0 := by
  simp [Purchase.liability, h]

end Canteen.ITA.Purchaser

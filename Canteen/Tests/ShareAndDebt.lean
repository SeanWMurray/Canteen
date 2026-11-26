import Canteen.ITA.S38.CapitalGains

/-!
# Tests: 40(3.6) and 40(2)(e.1)

Constructed examples, checked by the kernel.
-/

namespace Canteen.Tests.ShareAndDebt

open Canteen Canteen.ITA Canteen.ITA.AffiliatedPersons

def ann : Person := ⟨0, "Ann", .individual⟩
def bob : Person := ⟨1, "Bob", .individual⟩
def fay : Person := ⟨2, "Fay", .individual⟩
def holdco : Person := ⟨10, "Holdco", .corporation⟩
def fayco : Person := ⟨11, "Fayco", .corporation⟩

/-- Ann and Bob are married; Ann controls Holdco; Fay, a friend, controls Fayco. -/
def world : World :=
  { persons := [ann, bob, fay, holdco, fayco], spouses := [(0, 1)],
    controls := [⟨10, .person 0, .fact true, false⟩, ⟨11, .person 2, .fact true, false⟩] }

def lossSale (desc : String) : SuperficialLoss.Disposition :=
  { description := desc, date := ⟨2025, 5, 1⟩, proceeds := 200000, adjustedCostBase := 500000, outlaysAndExpenses := 0 }

/-! ## 40(3.6): Holdco redeems some of Ann's shares at a $3,000 loss -/

def redemption : ShareToAffiliate.Facts :=
  { world, taxpayer := 0, corporation := 10, disposition := lossSale "10 common shares of Holdco",
    shareOfCorporation := true,
    holdingsAfter := [("Ann's 90 remaining common shares of Holdco", 9000000), ("Ann's preferred shares of Holdco", 1000000)] }

example : ShareToAffiliate.denied redemption = true := by decide +kernel
-- The $3,000 is spread 90:10 over the shares Ann still owns.
example : ShareToAffiliate.additions redemption =
    [("Ann's 90 remaining common shares of Holdco", 270000), ("Ann's preferred shares of Holdco", 30000)] := by decide +kernel
-- Fayco is not affiliated with Ann: no denial.
example : ShareToAffiliate.denied { redemption with corporation := 11 } = false := by decide +kernel
-- A distress preferred share, or a share of another corporation: no denial.
example : ShareToAffiliate.denied { redemption with distressPreferred := true } = false := by decide +kernel
example : ShareToAffiliate.denied { redemption with shareOfCorporation := false } = false := by decide +kernel
-- And so no allowable capital loss in the year.
example : (CapitalGains.ofShareToAffiliate redemption).allowableCapitalLoss = 0 := by decide +kernel

#guard (ShareToAffiliate.rule.explain redemption).renderWithJudgments [] ==
  "1. The taxpayer disposed of a share of a class of the capital stock of the corporation to that corporation. [ITA 40(3.6) share]\n" ++
  "2. Holdco is a corporation controlled by Ann. [ITA 251.1(1)(b)(i)]\n" ++
  "3. So Ann and Holdco are affiliated persons. [ITA 251.1(1)]\n" ++
  "4. The share is not a distress preferred share. [ITA 40(3.6) distress preferred share]\n" ++
  "5. The share is not excluded property being considered in computing a foreign affiliate's surplus or deficit. [ITA 40(3.6) surplus carve-out]\n" ++
  "6. Therefore subsection 40(3.6) applies. [ITA 40(3.6)]\n" ++
  "7. So the taxpayer's loss of $3,000.00 is deemed to be nil. [ITA 40(3.6)(a)]\n" ++
  "8. $2,700.00 is added to the adjusted cost base of Ann's 90 remaining common shares of Holdco, in proportion to its fair market value. [ITA 40(3.6)(b); 53(1)(f.2)]\n" ++
  "9. $300.00 is added to the adjusted cost base of Ann's preferred shares of Holdco, in proportion to its fair market value. [ITA 40(3.6)(b); 53(1)(f.2)]\n" ++
  "Relies on no judgment calls."

/-! ## 40(2)(e.1): Ann sells a loan Holdco owes her -/

def loanToBob : RelatedDebt.Facts :=
  { world, taxpayer := 0, transferee := 1, debtor := 10, disposition := lossSale "a $5,000 loan to Holdco",
    obligationPayableToTransferee := true }

-- To Bob: Ann, Bob and Holdco are each related to the others, so the loss is nil.
example : RelatedDebt.denied loanToBob = true := by decide +kernel
-- To Fay: not related, so the loss stands.
example : RelatedDebt.denied { loanToBob with transferee := 2 } = false := by decide +kernel
-- Unless 80(2)(j) would make them related.
example : RelatedDebt.denied { loanToBob with transferee := 2, relatedBy80_2_j := true } = true := by decide +kernel
-- 53(1)(f.1): added to the transferee's cost only between taxable Canadian corporations.
example : RelatedDebt.transfereeCostAddition loanToBob false = 0 := by decide +kernel
-- Paragraph (e) of the superficial loss definition now follows from 40(2)(e.1).
example : (RelatedDebt.withRelatedDebt loanToBob).applies40_2_e1 = true := by decide +kernel
example : (CapitalGains.ofRelatedDebt loanToBob).allowableCapitalLoss = 0 := by decide +kernel
example : (CapitalGains.ofRelatedDebt { loanToBob with transferee := 2 }).allowableCapitalLoss = 300000 := by decide +kernel

end Canteen.Tests.ShareAndDebt

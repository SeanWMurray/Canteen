import Canteen.ITA.S40.Paragraph40_2_g
import Canteen.Transactions.TfsaContribution

/-!
# Tests: paragraph 40(2)(g), subparagraphs (ii) to (iv)

Known answers built from the statute text, one fact changed at a time from a base case:
property sold at a loss of $1,000.00, with no acquisitions (so subparagraph (i) never applies).
-/

namespace Canteen.Tests.Paragraph40_2_g

open Canteen Canteen.ITA Canteen.ITA.Paragraph40_2_g

def base : Facts :=
  { sl := ⟨{ description := "the property", date := ⟨2025, 5, 1⟩, proceeds := 100000,
             adjustedCostBase := 200000, outlaysAndExpenses := 0 }, []⟩ }

def gain : Facts := { base with sl := ⟨{ base.sl.disposition with proceeds := 300000 }, []⟩ }

example : paragraph.holds base = false := by decide

/-! ## (ii) debts -/

def debt (d : DebtFacts) : Facts := { base with debt := d }

example : debtLoss.holds (debt { isDebtOrRight := true }) = true := by decide                     -- denied
example : debtLoss.holds (debt { isDebtOrRight := true, incomePurpose := .fact true }) = false := by decide
def armsLengthSale (b : Bool) : DebtFacts :=
  { isDebtOrRight := true, considerationForCapitalProperty := true, armsLength := .fact b }

example : debtLoss.holds (debt (armsLengthSale true)) = false := by decide    -- arm's length sale
example : debtLoss.holds (debt (armsLengthSale false)) = true := by decide    -- non-arm's length sale
example : debtLoss.holds (debt { isDebtOrRight := false }) = false := by decide
example : debtLoss.holds { gain with debt := { isDebtOrRight := true } } = false := by decide       -- no loss
-- A judged income purpose is relied on; a factual one is not.
#guard (debtLoss.explain (debt { isDebtOrRight := true, incomePurpose := .judged "J-P" false })).reliesOn == ["J-P"]
#guard (debtLoss.explain (debt { isDebtOrRight := true, incomePurpose := .fact true })).reliesOn == []

/-! ## (iii) personal-use property -/

def pup (p : PersonalUseFacts) : Facts := { base with personalUse := p }

example : personalUseLoss.holds (pup { primarilyPersonalUse := .fact true }) = true := by decide
example : personalUseLoss.holds (pup { debtForPersonalUseProperty := true }) = true := by decide       -- (b)
example : personalUseLoss.holds (pup { optionOnPersonalUseProperty := true }) = true := by decide      -- (c)
example : personalUseLoss.holds (pup { primarilyPersonalUse := .fact true, listedKind := some .coin }) = false := by
  decide                                                                                               -- listed
example : personalUseLoss.holds (pup { primarilyPersonalUse := .fact true, debtReferredTo50_2 := true }) = false := by
  decide
example : personalUseLoss.holds (pup {}) = false := by decide
-- Listed personal property needs personal-use property: a coin held as an investment is neither.
example : isListed (pup { listedKind := some .coin }) = false := by decide
example : isListed (pup { primarilyPersonalUse := .fact true, listedKind := some .artwork }) = true := by decide

/-! ## (iv) transfers to registered plans -/

def toPlan (t : TransferFacts) : Facts := { base with transfer := some t }

def clauseAPlans : List PlanTrust := [.dpsp, .epsp, .fhsa, .rdsp, .rrif, .tfsa]

-- Every plan in (iv)(A), with the taxpayer a beneficiary, denies the loss…
example : clauseAPlans.all (fun p => planTransferLoss.holds (toPlan { plan := p, taxpayerBeneficiary := true })) = true := by
  decide
-- …but not if the taxpayer is not a beneficiary.
example : clauseAPlans.all (fun p => !planTransferLoss.holds (toPlan { plan := p })) = true := by decide
-- (iv)(B): an RRSP, with the taxpayer or spouse an annuitant.
example : planTransferLoss.holds (toPlan { plan := .rrsp, annuitant := true }) = true := by decide
example : planTransferLoss.holds (toPlan { plan := .rrsp, taxpayerBeneficiary := true }) = false := by decide
-- An RRSP is not in (iv)(A), and a TFSA is not in (iv)(B).
example : planTransferLoss.holds (toPlan { plan := .tfsa, annuitant := true }) = false := by decide
example : planTransferLoss.holds (toPlan { plan := .other "a family trust", taxpayerBeneficiary := true }) = false := by
  decide

/-! ## The paragraph -/

example : paragraph.holds (toPlan { plan := .tfsa, taxpayerBeneficiary := true }) = true := by decide
example : paragraph.holds { toPlan { plan := .tfsa, taxpayerBeneficiary := true } with surplusExcludedProperty := true } = false := by
  decide
example : deniedLoss (pup { primarilyPersonalUse := .fact true }) = 100000 := by decide
example : deniedLoss base = 0 := by decide

/-! ## Read-back -/

#guard paragraph.explainText (pup { primarilyPersonalUse := .fact true }) ==
  "1. The taxpayer has a loss from the disposition. [ITA 40(2)(g)(iii) loss]\n" ++
  "2. The property is personal-use property of the taxpayer: property used primarily for the personal use or enjoyment of the taxpayer or related individuals, a debt owing in respect of the disposition of personal-use property, or an option to acquire personal-use property. [ITA 54 \"personal-use property\" (a) to (c)]\n" ++
  "3. Therefore personal-use property applies. [ITA 54 \"personal-use property\"]\n" ++
  "4. The property is not of a kind listed in the definition \"listed personal property\" in section 54. [ITA 40(2)(g)(iii) listed personal property]\n" ++
  "5. The property is not a debt referred to in subsection 50(2). [ITA 40(2)(g)(iii) debt under 50(2)]\n" ++
  "6. Therefore subparagraph 40(2)(g)(iii) applies. [ITA 40(2)(g)(iii)]\n" ++
  "7. Therefore one of subparagraphs 40(2)(g)(i) to (iv) applies. [ITA 40(2)(g)]\n" ++
  "8. The property is not excluded property being considered in computing a foreign affiliate's surplus or deficit. [ITA 40(2)(g) opening words]\n" ++
  "9. Therefore paragraph 40(2)(g) applies. [ITA 40(2)(g)]"

open Transactions.TfsaContribution in
#guard (paragraph.explain (facts affiliatedBranch)).renderWithJudgments affiliatedBranch ==
  "1. The taxpayer has a loss from the disposition. [ITA 40(2)(g)(iv) loss]\n" ++
  "2. The property was disposed of to a trust governed by a deferred profit sharing plan, an employees profit sharing plan, a FHSA, a registered disability savings plan, a registered retirement income fund or a TFSA. [ITA 40(2)(g)(iv)(A) trust]\n" ++
  "3. The taxpayer is, or immediately after the disposition becomes, a beneficiary under it. [ITA 40(2)(g)(iv)(A) beneficiary]\n" ++
  "4. Therefore clause 40(2)(g)(iv)(A) applies. [ITA 40(2)(g)(iv)(A)]\n" ++
  "5. Therefore clause (A) or (B) applies. [ITA 40(2)(g)(iv)]\n" ++
  "6. Therefore subparagraph 40(2)(g)(iv) applies. [ITA 40(2)(g)(iv)]\n" ++
  "7. Therefore one of subparagraphs 40(2)(g)(i) to (iv) applies. [ITA 40(2)(g)]\n" ++
  "8. The property is not excluded property being considered in computing a foreign affiliate's surplus or deficit. [ITA 40(2)(g) opening words]\n" ++
  "9. Therefore paragraph 40(2)(g) applies. [ITA 40(2)(g)]\n" ++
  "Relies on no judgment calls."

end Canteen.Tests.Paragraph40_2_g

import Canteen.ITA.S85.TransferToCorporation
import Canteen.ITA.S84_1.SurplusStripping
import Canteen.ITA.S110_6.CapitalGainsDeduction
import Canteen.ITA.S40.Paragraph40_2_g
import Canteen.ITA.S53.CostAddition
import Canteen.ITA.S251_1.AffiliatedPersons
import Canteen.ITA.S251.RelatedPersons
import Canteen.Core.Branch

/-!
# Layer 3: crystallizing the capital gains exemption, then stripping the cost

A constructed transaction under 85(1), 84.1, 110.6, section 54 "superficial loss", paragraph
40(2)(g) and 53(1)(f).

* The taxpayer owns all the common shares of Opco: paid-up capital and adjusted cost base $100,
  worth $2,000,000. The taxpayer also controls two new holding companies, Holdco and Newco.
* 2025-06-30, **step 1**: the taxpayer transfers the Opco shares to Holdco for preferred shares
  worth $2,000,000, with $1,250,100 of stated capital, jointly electing $1,250,100 under 85(1):
  a $1,250,000 capital gain, to be sheltered by the capital gains deduction.
* 2026-03-02, **step 2**: the taxpayer sells the Holdco preferred shares to Newco for a $1,250,100
  note, hoping to take the crystallized cost out of the companies tax-free.
* Judgment call `J-SBC`: is Opco a small business corporation (all or substantially all of its
  assets' value in active business assets)?
-/

namespace Canteen.Transactions.Crystallization

open Canteen Canteen.ITA Canteen.ITA.AffiliatedPersons

/-! ## Facts -/

def taxpayer : Nat := 0
def opco : Nat := 1
def holdco : Nat := 2
def newco : Nat := 3

/-- The taxpayer controls Holdco and Newco (and, until step 1, Opco). -/
def world : World :=
  { persons := [⟨taxpayer, "the taxpayer", .individual⟩, ⟨opco, "Opco", .corporation⟩,
                ⟨holdco, "Holdco", .corporation⟩, ⟨newco, "Newco", .corporation⟩],
    controls := [⟨opco, .person taxpayer, .fact true, false⟩, ⟨holdco, .person taxpayer, .fact true, false⟩,
                 ⟨newco, .person taxpayer, .fact true, false⟩] }

def calls : List JudgmentCall :=
  [{ id := "J-SBC", question := "Is all or substantially all of the fair market value of Opco's assets attributable to assets used principally in an active business carried on primarily in Canada?",
     riskIfYes := .low, riskIfNo := .high }]

def position : List Judgment := [(calls.head!).assume true]

/-- The Opco shares, for the definition of "qualified small business corporation share": held by
the taxpayer alone for years, Opco's active business assets 85% and 90% of its assets' value. -/
def opcoShares (branch : List Judgment) : CapitalGainsDeduction.ShareFacts :=
  { description := "the common shares of Opco", smallBusinessCorporation := Answer.ofBranch "J-SBC" branch,
    periods := [{ label := "2023-06-30 to 2024-06-30", qualifyingAssets := 170000000, totalAssets := 200000000 },
                { label := "2024-06-30 to 2025-06-30", qualifyingAssets := 180000000, totalAssets := 200000000 }] }

def holdcoPreferred : TransferToCorporation.ShareClass :=
  { name := "Holdco preferred shares", fairMarketValue := 200000000, paidUpCapitalIncrease := 125010000 }

/-- Step 1, under 85(1). -/
def transfer : TransferToCorporation.Facts :=
  { description := "the common shares of Opco", fairMarketValue := 200000000, costAmount := 10000, agreed := 125010000,
    preferred := [holdcoPreferred] }

/-- Step 1, under 84.1: the taxpayer and Holdco are related (251(2)(b)(i)), so not at arm's length. -/
def step1 : SurplusStripping.Facts :=
  SurplusStripping.ofTransfer transfer 10000
    (armsLength := RelatedPersons.armsLengthAnswer ⟨world, taxpayer, holdco, false, .fact true⟩)

/-- The taxpayer's 2025 disposition. -/
def disposition1 : CapitalGains.Disposition := SurplusStripping.disposition step1

/-- The taxpayer's 2025 capital gains deduction, on a branch. -/
def deduction (branch : List Judgment) : CapitalGains.HalfCents :=
  CapitalGainsDeduction.deduction
    { taxationYear := 2025, year := ⟨[disposition1], 0, {}⟩,
      qualifying := if CapitalGainsDeduction.qualifiedShare.holds (opcoShares branch) then [disposition1] else [] }

/-- The gain sheltered by the deduction. A deduction of `h` half-cents shelters a taxable capital
gain of `h` half-cents, which is a gain of `h` cents. -/
def shelteredGain (branch : List Judgment) : Cents := deduction branch

/-- Step 2, under 84.1. The Holdco preferred shares were acquired from Holdco, a person not at arm's
length, so 84.1(2)(a.1)(ii) takes off the gain on the Opco shares they were substituted for, to the
extent sheltered by the capital gains deduction. -/
def step2 (branch : List Judgment) : SurplusStripping.Facts :=
  { description := "the Holdco preferred shares",
    armsLength := RelatedPersons.armsLengthAnswer ⟨world, taxpayer, newco, false, .fact true⟩,
    subjectPaidUpCapital := SurplusStripping.paidUpCapital step1 holdcoPreferred,
    adjustedCostBase := TransferToCorporation.preferredCost transfer holdcoPreferred,
    costReduction := shelteredGain branch,
    boot := 125010000, proceedsOtherwise := 125010000 }

def sale2 (branch : List Judgment) : SuperficialLoss.Disposition :=
  { description := "the Holdco preferred shares", date := ⟨2026, 3, 2⟩,
    proceeds := SurplusStripping.proceeds (step2 branch), adjustedCostBase := (step2 branch).adjustedCostBase,
    outlaysAndExpenses := 0 }

/-- Newco acquires the very shares, and holds them at the end of the period. -/
def newcoPurchase : SuperficialLoss.Acquisition :=
  { description := "the Holdco preferred shares", date := ⟨2026, 3, 2⟩,
    acquirer := AffiliatedPersons.acquirer world taxpayer newco, identity := .same, heldAtEndOfPeriod := true }

def slFacts (branch : List Judgment) : Paragraph40_2_g.Facts :=
  { sl := ⟨sale2 branch, [newcoPurchase]⟩, surplusExcludedProperty := false }

def newcoCostFacts : CostAddition.Facts :=
  { owner := "Newco", property := "the Holdco preferred shares", cost := 125010000, substitutedProperty := true,
    superficialLoss := Paragraph40_2_g.deniedLoss (slFacts position) }

/-! ## Step 1: the crystallization -/

/-- On the position taken, the Opco shares are qualified small business corporation shares; it
rests on J-SBC alone. -/
theorem opco_qualified :
    CapitalGainsDeduction.qualifiedShare.holds (opcoShares position) = true ∧
    (CapitalGainsDeduction.qualifiedShare.explain (opcoShares position)).reliesOn = ["J-SBC"] := by decide

/-- 85(1) applies; the elected amount is the $1,250,100 agreed, and the preferred shares cost that. -/
theorem step1_elected :
    TransferToCorporation.rollover.holds transfer = true ∧ TransferToCorporation.electedAmount transfer = 125010000 ∧
    TransferToCorporation.preferredCost transfer holdcoPreferred = 125010000 := by decide

/-- 84.1 applies (the taxpayer and Holdco are related), but with no boot there is no dividend; the
preferred shares' paid-up capital is ground from $1,250,100 to $100. -/
theorem step1_paid_up_capital :
    SurplusStripping.applies.holds step1 = true ∧ SurplusStripping.dividend step1 = 0 ∧
    SurplusStripping.paidUpCapital step1 holdcoPreferred = 10000 := by decide +kernel

/-- A $1,250,000 capital gain. -/
theorem step1_gain : disposition1.gain = 125000000 := by decide +kernel

/-- On the position taken, the deduction shelters all of it ($625,000 of taxable capital gain). -/
theorem step1_sheltered : deduction position = 125000000 := by decide +kernel

/-! ## Step 2: the strip -/

/-- The note over the preferred shares' $100 of paid-up capital and $100 of hard cost (the $1,250,100
cost less the sheltered $1,250,000) is a dividend of $1,250,000. -/
theorem step2_dividend :
    SurplusStripping.applies.holds (step2 position) = true ∧ SurplusStripping.hardCost (step2 position) = 10000 ∧
    SurplusStripping.dividend (step2 position) = 125000000 := by decide +kernel

/-- The dividend is not proceeds (54 "proceeds of disposition" (k)): proceeds of $100 on a $1,250,100
cost, a $1,250,000 loss. -/
theorem step2_loss : SuperficialLoss.lossAmount (sale2 position) = 125000000 := by decide +kernel

/-- Newco, controlled by the taxpayer, is affiliated with the taxpayer and acquired the very shares,
so the loss is a superficial loss, nil under 40(2)(g)(i). -/
theorem step2_loss_nil :
    Paragraph40_2_g.paragraph.holds (slFacts position) = true ∧
    Paragraph40_2_g.deniedLoss (slFacts position) = 125000000 := by decide +kernel

/-- It is added to Newco's cost of the preferred shares (53(1)(f)): $2,500,100. -/
theorem newco_cost : CostAddition.adjustedCostBase newcoCostFacts = 250010000 := by decide +kernel

/-! ## If Opco is not a small business corporation -/

/-- Then the shares do not qualify, nothing is deducted, and the whole gain is taxed in 2025. -/
theorem not_sbc_no_deduction : deduction [(calls.head!).assume false] = 0 := by decide +kernel

/-- But then nothing comes off the cost, and the $1,250,100 note is within it: no dividend. -/
theorem not_sbc_no_dividend : SurplusStripping.dividend (step2 [(calls.head!).assume false]) = 0 := by decide +kernel

end Canteen.Transactions.Crystallization

import Canteen.ITA.S84_1.SurplusStripping

/-!
# Tests: section 84.1

An individual holds shares of Opco with $100 of paid-up capital and a $100 cost, worth $1,000,000,
and transfers them under 85(1) to Holdco, which the individual controls, for a $300,000 note and
preferred shares worth $700,000 with $700,000 of stated capital. Constructed examples.
-/

namespace Canteen.Tests.SurplusStripping

open Canteen Canteen.ITA Canteen.ITA.SurplusStripping

def prefs (puc : Cents) : TransferToCorporation.ShareClass :=
  { name := "preferred shares", fairMarketValue := 70000000, paidUpCapitalIncrease := puc }

def transfer : TransferToCorporation.Facts :=
  { description := "shares of Opco", fairMarketValue := 100000000, costAmount := 10000, agreed := 30000000,
    boot := [{ description := "the note", fairMarketValue := 30000000 }], preferred := [prefs 70000000] }

def strip : Facts := ofTransfer transfer 10000

example : applies.holds strip = true := by decide
-- The note over the $100 of paid-up capital and cost is a dividend of $299,900.
example : e strip = 10000 ∧ dividend strip = 29990000 := by decide
-- The preferred shares' paid-up capital is ground to nil.
example : paidUpCapital strip (prefs 70000000) = 0 := by decide
-- The proceeds exclude the dividend (54 "proceeds of disposition" (k)): no capital gain.
example : proceeds strip = 10000 ∧ (disposition strip).gain = 0 := by decide

-- A $100 note: no dividend, but the paid-up capital is still ground down, to E less the boot.
def small : Facts := ofTransfer { transfer with agreed := 10000, boot := [{ description := "the note", fairMarketValue := 10000 }] } 10000
example : dividend small = 0 ∧ paidUpCapital small (prefs 70000000) = 0 := by decide

-- Cost from the taxpayer's own earlier gain sheltered by the capital gains exemption does not
-- count (84.1(2)(a.1)(ii)): a $500,000 cost, $499,900 of it crystallized, gives the same dividend.
def crystallized : Facts := ofTransfer { transfer with costAmount := 50000000, agreed := 50000000 } 10000 49990000
example : hardCost crystallized = 10000 ∧ dividend crystallized = 29990000 := by decide
-- But a $500,000 cost from an arm's length purchase covers the note: no dividend.
def bought : Facts := ofTransfer { transfer with costAmount := 50000000, agreed := 50000000 } 10000
example : dividend bought = 0 ∧ paidUpCapital bought (prefs 70000000) = 20000000 := by decide

-- Outside 84.1: arm's length (as judged), not connected, or a qualifying intergenerational transfer.
example : dividend { strip with armsLength := .judged "J-ARM" true } = 0 := by decide
#guard (rule.explain { strip with armsLength := .judged "J-ARM" false }).reliesOn == ["J-ARM"]
example : dividend { strip with connected := false } = 0 := by decide
example : dividend { strip with intergenerational := true } = 0 := by decide
-- (2)(b) deems a fewer-than-6 control group not at arm's length, whatever the judgment.
example : dividend { strip with armsLength := .judged "J-ARM" true, groupControl := true } = 29990000 := by decide
#guard (rule.explain { strip with armsLength := .judged "J-ARM" true, groupControl := true }).reliesOn == []
-- A corporate vendor is outside 84.1.
example : dividend { strip with residentNonCorporation := false } = 0 := by decide

/-! ## Read-back -/

#guard ((rule.explain strip).render.splitOn "\n").drop 4 ==
  ["5. Therefore subsection 84.1(1) applies. [ITA 84.1(1)]",
   "6. The greater of the subject shares' paid-up capital ($100.00) and their adjusted cost base as 84.1(2)(a.1) reduces it ($100.00) is $100.00. [ITA 84.1(1)(a) B, (b) E; 84.1(2)(a.1)]",
   "7. The new shares' paid-up capital is reduced by $700,000.00, to $0.00. [ITA 84.1(1)(a)]",
   "8. A dividend of $299,900.00 is deemed paid to the taxpayer: the $300,000.00 of other consideration exceeds $100.00. [ITA 84.1(1)(b)]",
   "9. The taxpayer's proceeds of disposition are $100.00. [ITA 54 \"proceeds of disposition\" (k)]"]

end Canteen.Tests.SurplusStripping

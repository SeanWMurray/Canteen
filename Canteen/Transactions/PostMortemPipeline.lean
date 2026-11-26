import Canteen.ITA.S70.Death
import Canteen.ITA.S84_1.SurplusStripping
import Canteen.ITA.S82.Dividends
import Canteen.Core.Branch

/-!
# Layer 3: a post-mortem pipeline

A constructed transaction under 70(5), 84.1 and 82(1).

* The deceased owned all the shares of Opco: paid-up capital and adjusted cost base $100, worth
  $1,000,000. They pass to the estate (not to a spouse), so 70(5) deems them disposed of at
  $1,000,000 immediately before death: a $999,900 capital gain in the terminal return, with no
  capital gains deduction claimed. The estate acquires them at $1,000,000 (70(5)(b)).
* 2026-04-01: the estate sells the Opco shares to Newco, a new corporation it controls, for a
  $1,000,000 note. Newco later repays the note from Opco's funds.
* Without the pipeline, Opco would pay the funds out as a dividend (or on a winding-up under 84(2)):
  taxed again, on top of the gain at death.

The CRA's conditions for not applying 84(2) or 245(2) to the later repayment (Opco continuing its
business for at least a year) are not encoded.
-/

namespace Canteen.Transactions.PostMortemPipeline

open Canteen Canteen.ITA

/-! ## Facts -/

def opcoShares : Death.Property :=
  { description := "the shares of Opco", fairMarketValue := 100000000, adjustedCostBase := 10000, recipient := .other "the estate" }

/-- Death: the deemed disposition. -/
def death : Death.Query := ⟨true, opcoShares⟩

/-- The estate's sale to Newco, under 84.1. The estate is not at arm's length with Newco, which it
controls; its cost comes from 70(5)(b). `costReduction` is 84.1(2)(a.1)(ii): the gain on the
deceased's disposition, to the extent the capital gains deduction was claimed on it (`sheltered`). -/
def sale (sheltered : Cents) : SurplusStripping.Facts :=
  { description := "the shares of Opco", armsLength := .fact false, connected := true,
    subjectPaidUpCapital := 10000, adjustedCostBase := Death.recipientCost death,
    costReduction := sheltered, boot := 100000000, proceedsOtherwise := 100000000 }

/-! ## Analysis -/

/-- At death: proceeds of $1,000,000, a $999,900 gain, and the estate's cost is $1,000,000. -/
theorem gain_at_death :
    Death.proceeds death = 100000000 ∧ (Death.disposition death).gain = 99990000 ∧ Death.recipientCost death = 100000000 := by
  decide

/-- The pipeline: 84.1 applies, but the estate's hard cost is the full $1,000,000 (no capital gains
deduction was claimed at death), so the $1,000,000 note is no dividend. -/
theorem pipeline_no_dividend :
    SurplusStripping.applies.holds (sale 0) = true ∧ SurplusStripping.e (sale 0) = 100000000 ∧
    SurplusStripping.dividend (sale 0) = 0 := by decide

/-- And the estate has no gain on the sale: proceeds of $1,000,000 against a $1,000,000 cost. -/
theorem pipeline_no_gain : (SurplusStripping.disposition (sale 0)).gain = 0 := by decide

/-- **One level of tax.** The gain at death is the only amount taxed: $999,900, half of it taxable. -/
theorem taxed_once :
    (Death.disposition death).taxableCapitalGain + (SurplusStripping.disposition (sale 0)).taxableCapitalGain = 99990000 := by
  decide

/-- Without the pipeline, a $1,000,000 dividend from Opco would add $1,150,000 of income: taxed twice. -/
theorem without_pipeline :
    Dividends.inclusion { taxationYear := 2026, dividends := [{ description := "a dividend from Opco", amount := 100000000 }] } =
      115000000 := by decide

/-- Had the capital gains deduction sheltered $500,000 of the gain at death, 84.1(2)(a.1)(ii) would
take it off the estate's cost, and $500,000 of the note would be a dividend. -/
theorem sheltered_part_is_dividend :
    SurplusStripping.hardCost (sale 50000000) = 50000000 ∧ SurplusStripping.dividend (sale 50000000) = 50000000 := by decide

end Canteen.Transactions.PostMortemPipeline

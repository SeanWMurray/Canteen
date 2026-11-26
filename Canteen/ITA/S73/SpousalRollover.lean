import Canteen.Core.StatuteSyntax
import Canteen.ITA.S69.NonArmsLength

/-!
# Subsections 73(1) and (1.01): the spousal rollover

*Income Tax Act*, as consolidated to 2026-10-29 (verbatim in `statute/ITA-73-1-1.01.txt`):

> (1) … where at any time any particular capital property of an individual (other than a trust)
> has been transferred in circumstances to which subsection (1.01) applies and both the individual
> and the transferee are resident in Canada at that time, unless the individual elects … that the
> provisions of this subsection not apply, the particular property is deemed (a) to have been
> disposed of at that time by the individual for proceeds equal to, (i) where the particular
> property is depreciable property of a prescribed class, [a proportion of the class's
> undepreciated capital cost], and (ii) in any other case, the adjusted cost base … ; and (b) to
> have been acquired at that time by the transferee for an amount equal to those proceeds.
>
> (1.01) Subject to subsection (1.02), property is transferred … in circumstances to which this
> subsection applies where it is transferred to (a) the individual's spouse or common-law partner;
> (b) a former spouse or common-law partner … in settlement of rights arising out of their marriage
> or common-law partnership; or (c) a trust created by the individual under which (i) [a spousal
> trust], (ii) [an alter ego trust], or (iii) [a joint spousal or common-law partner trust].

Where the rollover applies it displaces 69(1) ("except as expressly otherwise provided");
otherwise 69(1) governs, as when the individual elects out. Not encoded: 73(1.02), and the
attribution rules in 74.1 and 74.2 that usually follow a transfer to a spouse.
-/

namespace Canteen.ITA.SpousalRollover

/-- Who the property is transferred to, for 73(1.01). -/
inductive Transferee where
  /-- (a) the individual's spouse or common-law partner -/
  | spouse
  /-- (b) a former spouse or common-law partner, in settlement of rights arising out of the relationship -/
  | formerSpouseInSettlement
  /-- (c)(i) a trust under which the spouse or common-law partner has all the income for life, and no one else the use of income or capital -/
  | spousalTrust
  /-- (c)(ii) a trust under which the individual has all the income for life, and no one else the use -/
  | alterEgoTrust
  /-- (c)(iii) a trust under which the individual and spouse or common-law partner together have all the income until the later death -/
  | jointTrust
  /-- Anyone else. -/
  | other
  deriving Repr, DecidableEq, Inhabited

def Transferee.in1_01 : Transferee → Bool
  | .other => false
  | _ => true

structure Facts where
  transfer : NonArmsLength.Transfer
  /-- The transferor is an individual, not a trust. -/
  individual : Bool := true
  /-- The property is capital property of the individual. -/
  capitalProperty : Bool := true
  transferee : Transferee
  /-- Both the individual and the transferee are resident in Canada at the time. -/
  bothResident : Bool := true
  /-- The individual elects, in the return for the year, that 73(1) not apply. -/
  electedOut : Bool := false
  adjustedCostBase : Cents
  /-- (a)(i): for depreciable property of a prescribed class, the proportion of the class's
  undepreciated capital cost that the property's fair market value is of the class's. -/
  prescribedClassShare : Option Cents := none
  deriving Repr, DecidableEq, Inhabited

/-- Subsection 73(1). -/
statute rollover (f : Facts) named "subsection 73(1)" cites "ITA 73(1)"
  applies where
    | "capital property of an individual" (f.individual && f.capitalProperty)
        => "The property is capital property of an individual who is not a trust."
        else "The property is not capital property of an individual other than a trust."
    | "(1.01)" := (Rule.clause "(1.01)" "ITA 73(1.01)" (fun f : Facts => f.transferee.in1_01)
        "It was transferred to the individual's spouse or common-law partner, a former one in settlement of rights arising out of the relationship, or a qualifying spousal, alter ego or joint trust."
        "It was not transferred to a spouse or common-law partner, a former one in settlement, or a qualifying trust.")
    | "resident" f.bothResident
        => "Both the individual and the transferee are resident in Canada at the time."
        else "The individual or the transferee is not resident in Canada at the time."
  except where
    | "election" f.electedOut
        => "The individual elects that subsection 73(1) not apply."
        else "The individual does not elect out of subsection 73(1)."

/-- 73(1)(a): the rollover amount, the adjusted cost base (or the prescribed class share). -/
def rolloverAmount (f : Facts) : Cents := f.prescribedClassShare.getD f.adjustedCostBase

/-- The transferor's proceeds: 73(1)(a) where it applies, otherwise 69(1). -/
def proceeds (f : Facts) : Cents :=
  if rollover.holds f then rolloverAmount f else NonArmsLength.sellerProceeds f.transfer

/-- The transferee's cost: 73(1)(b) where it applies, otherwise 69(1). -/
def transfereeCost (f : Facts) : Cents :=
  if rollover.holds f then rolloverAmount f else NonArmsLength.buyerCost f.transfer

/-- The transferor's disposition, for the capital gains computation. -/
def disposition (f : Facts) : CapitalGains.Disposition :=
  { description := f.transfer.description, proceeds := proceeds f, adjustedCostBase := f.adjustedCostBase }

/-! ## Truths about the rollover -/

/-- Where 73(1) applies to property other than prescribed depreciable property, the transferor
has no gain, and the transferee takes over the transferor's cost. -/
theorem no_gain_on_rollover (f : Facts) (h : rollover.holds f = true) (hd : f.prescribedClassShare = none) :
    (disposition f).gain = 0 ∧ transfereeCost f = f.adjustedCostBase := by
  simp [disposition, proceeds, transfereeCost, rolloverAmount, h, hd, CapitalGains.Disposition.gain,
    CapitalGains.Disposition.excess, CapitalGains.Disposition.reserveLimit]

/-- Electing out leaves the transfer to 69(1). -/
theorem elect_out (f : Facts) (h : f.electedOut = true) :
    proceeds f = NonArmsLength.sellerProceeds f.transfer ∧ transfereeCost f = NonArmsLength.buyerCost f.transfer := by
  simp [proceeds, transfereeCost, rollover, h]

end Canteen.ITA.SpousalRollover

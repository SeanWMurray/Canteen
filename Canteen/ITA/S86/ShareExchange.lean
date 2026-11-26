import Canteen.ITA.S85.TransferToCorporation

/-!
# Subsections 86(1) to (3): exchange of shares in a reorganization of capital

*Income Tax Act*, as consolidated to 2026-10-29 (verbatim in `statute/ITA-86-1-3.txt`):

> (1) Where … in the course of a reorganization of the capital of a corporation, a taxpayer has
> disposed of capital property that was all the shares of any particular class of the capital
> stock of the corporation that were owned by the taxpayer … (the "old shares"), and property is
> receivable from the corporation therefor that includes other shares of the capital stock of the
> corporation (the "new shares"), … (a) the cost … of any property (other than new shares) … shall
> be deemed to be its fair market value …; (b) the cost … of any new shares of any class … shall be
> deemed to be that proportion of the amount, if any, by which the total of the adjusted cost bases
> … of the old shares exceeds the fair market value … of the consideration … (other than new
> shares) that (i) the fair market value … of those new shares of that class, is of (ii) the fair
> market value … of all new shares …; and (c) the taxpayer shall be deemed to have disposed of the
> old shares for proceeds of disposition equal to the cost … of all new shares and other property …
>
> (2) Notwithstanding … where … the fair market value of the old shares immediately before the
> disposition exceeds the total of (a) the cost … of the [non-share consideration] …, and (b) the
> fair market value of the new shares, immediately after the disposition, and it is reasonable to
> regard any portion of the excess (the "gift portion") as a benefit that the taxpayer desired to
> have conferred on a person related to the taxpayer, … (c) the taxpayer shall be deemed to have
> disposed of the old shares for proceeds of disposition equal to the lesser of (i) the total of
> the cost … of the [non-share consideration] and the gift portion and (ii) the fair market value
> of the old shares …, (d) the taxpayer's capital loss from the disposition of the old shares shall
> be deemed to be nil, and (e) the cost … of any new shares of any class … shall be deemed to be
> that proportion of the amount, if any, by which the total of the adjusted cost bases … of the old
> shares exceeds the total determined under subparagraph 86(2)(c)(i) that [their value is of all
> the new shares' value].
>
> (2.1) … (a) [the paid-up capital of each class is reduced by] (A − B) × C / A where A is the
> increase in paid-up capital of all classes as a result of the exchange, B is the amount, if any,
> by which the paid-up capital in respect of the old shares exceeds the fair market value of the
> [non-share consideration] …, and C is the increase for the particular class …
>
> (3) Subsections 86(1) and 86(2) do not apply in any case where subsection 85(1) or 85(2) applies.

Whether there is a reorganization of capital is a fact; whether part of an excess is a benefit to a
related person is a fact or a judgment call. Proportions are rounded down to the cent. An 84(3)
dividend on the old shares (where the boot exceeds their paid-up capital) is for `Redemption`.
Not encoded: 86(2.1)(b), and 86(4) (shares of a foreign affiliate).
-/

namespace Canteen.ITA.ShareExchange

open TransferToCorporation (Boot ShareClass)

structure Facts where
  /-- The old shares, e.g. `"the common shares of Opco"`. -/
  description : String
  /-- The old shares are capital property, all of the taxpayer's shares of their class. -/
  allSharesOfClass : Bool := true
  /-- In the course of a reorganization of the capital of the corporation. -/
  reorganization : Bool := true
  /-- 86(3): subsection 85(1) or (2) applies (a joint election was filed). -/
  section85Applies : Bool := false
  /-- The old shares' adjusted cost base, paid-up capital and fair market value immediately before. -/
  adjustedCostBase : Cents
  paidUpCapital : Cents
  fairMarketValue : Cents
  boot : List Boot := []
  /-- The new shares, by class, with their value immediately after and paid-up capital increase. -/
  newShares : List ShareClass
  /-- 86(2): part of the excess of value is reasonably regarded as a benefit the taxpayer desired to
  confer on a related person. Often a judgment call. -/
  benefit : Answer := .fact false
  /-- 86(2): the gift portion, if not all of the excess. -/
  giftPortion : Option Cents := none
  deriving Repr, Inhabited

/-- Subsection 86(1). -/
statute applies (f : Facts) named "subsection 86(1)" cites "ITA 86(1)"
  applies where
    | "reorganization" f.reorganization
        => "The shares were disposed of in the course of a reorganization of the capital of the corporation."
        else "The shares were not disposed of in the course of a reorganization of the capital of the corporation."
    | "old shares" f.allSharesOfClass
        => "They were capital property, all the shares of their class the taxpayer owned."
        else "They were not capital property that was all the taxpayer's shares of the class."
    | "new shares" (!f.newShares.isEmpty)
        => "Property receivable for them includes other shares of the corporation."
        else "No shares of the corporation are receivable for them."
  except where
    | "86(3)" := (Rule.clause "86(3)" "ITA 86(3)" (fun f : Facts => f.section85Applies)
        "Subsection 85(1) or (2) applies, so subsections 86(1) and (2) do not."
        "Subsection 85(1) or (2) does not apply.")

def bootTotal (f : Facts) : Cents := (f.boot.map (·.fairMarketValue)).sum
def newTotal (f : Facts) : Cents := (f.newShares.map (·.fairMarketValue)).sum

/-- 86(2): the excess of the old shares' value over the boot and the new shares' value. -/
def excess (f : Facts) : Cents := f.fairMarketValue - (bootTotal f + newTotal f)

/-- 86(2) applies: there is an excess, and part of it is a benefit to a related person. -/
def benefitConferred (f : Facts) : Bool := applies.holds f && f.benefit.value && 0 < excess f

def gift (f : Facts) : Cents := min (excess f) (f.giftPortion.getD (excess f))

/-- The amount the new shares' cost is computed from: the boot, plus the gift under 86(2)(e). -/
def deducted (f : Facts) : Cents := if benefitConferred f then bootTotal f + gift f else bootTotal f

/-- 86(1)(b), 86(2)(e): a class of new shares' cost. -/
def newCost (f : Facts) (s : ShareClass) : Cents :=
  if newTotal f = 0 then 0 else (f.adjustedCostBase - deducted f) * s.fairMarketValue / newTotal f

def newCostTotal (f : Facts) : Cents := (f.newShares.map (newCost f)).sum

/-- 86(1)(c), 86(2)(c): the proceeds for the old shares. -/
def proceeds (f : Facts) : Cents :=
  if benefitConferred f then min (bootTotal f + gift f) f.fairMarketValue else newCostTotal f + bootTotal f

/-- The taxpayer's disposition of the old shares (86(2)(d): any capital loss is nil). -/
def disposition (f : Facts) : CapitalGains.Disposition :=
  { description := f.description, proceeds := proceeds f, adjustedCostBase := f.adjustedCostBase,
    lossNil := benefitConferred f }

/-- 86(2.1)(a): A, B, and the reduction for a class. -/
def pucA (f : Facts) : Cents := (f.newShares.map (·.paidUpCapitalIncrease)).sum
def pucB (f : Facts) : Cents := f.paidUpCapital - bootTotal f
def pucReduction (f : Facts) (s : ShareClass) : Cents :=
  if pucA f = 0 then 0 else (pucA f - pucB f) * s.paidUpCapitalIncrease / pucA f
def paidUpCapital (f : Facts) (s : ShareClass) : Cents := s.paidUpCapitalIncrease - pucReduction f s

/-- The judgment calls the result rests on: 86(2)'s, where there is an excess. -/
def judgments (f : Facts) : List String := if applies.holds f && 0 < excess f then f.benefit.judgments else []

def explain (f : Facts) : Finding :=
  let e := applies.explain f
  let c := formatCents
  if !applies.holds f then e else
  ⟨true, e.steps ++
    (if benefitConferred f then
      [⟨s!"The old shares, worth {c f.fairMarketValue}, exceed the boot and new shares by {c (excess f)}; {c (gift f)} of that " ++
          "is a benefit the taxpayer desired to confer on a related person.", "ITA 86(2)"⟩,
       ⟨s!"So the proceeds are {c (proceeds f)}, any capital loss is nil, and the new shares cost {c (newCostTotal f)}.",
          "ITA 86(2)(c)–(e)"⟩]
    else
      [⟨s!"The new shares cost the old shares' adjusted cost base of {c f.adjustedCostBase} less the boot of {c (bootTotal f)}: " ++
          s!"{c (newCostTotal f)}.", "ITA 86(1)(a), (b)"⟩,
       ⟨s!"So the proceeds for the old shares are {c (proceeds f)}.", "ITA 86(1)(c)"⟩]),
    mergeIds e.reliesOn (judgments f)⟩

/-- Subsection 86(1), as a rule, with its consequences. -/
def rule : Rule Facts where
  name := "subsection 86(1)"
  citation := "ITA 86(1)"
  holds := applies.holds
  explain := explain
  sound := fun f => by unfold explain; split <;> simp_all

/-! ## Truths about share exchanges -/

/-- **The freeze.** One class of new shares, boot no more than the cost, and no benefit conferred:
the proceeds equal the cost, so there is no gain or loss, and the new shares take over the cost
less the boot. -/
theorem freeze_no_gain (f : Facts) (s : ShareClass) (h : f.newShares = [s]) (hs : 0 < s.fairMarketValue)
    (hb : bootTotal f ≤ f.adjustedCostBase) (hn : benefitConferred f = false) :
    proceeds f = f.adjustedCostBase ∧ newCost f s = f.adjustedCostBase - bootTotal f := by
  have ht : newTotal f = s.fairMarketValue := by simp [newTotal, h]
  have hc : newCost f s = f.adjustedCostBase - bootTotal f := by
    simp [newCost, ht, Nat.pos_iff_ne_zero.mp hs, Nat.mul_div_cancel _ hs, deducted, hn]
  refine ⟨?_, hc⟩
  simp only [proceeds, hn, Bool.false_eq_true, ite_false, newCostTotal, h, List.map_cons, List.map_nil, List.sum_cons,
    List.sum_nil, Nat.add_zero, hc]
  exact Nat.sub_add_cancel hb

/-- **86(2).** Conferring a benefit on a related person: the proceeds include the gift (up to the
old shares' value), and there is never a capital loss. -/
theorem benefit_taxed (f : Facts) (h : benefitConferred f = true) :
    proceeds f = min (bootTotal f + gift f) f.fairMarketValue ∧ (disposition f).capitalLoss = 0 := by
  refine ⟨by simp [proceeds, h], ?_⟩
  simp [disposition, h, CapitalGains.Disposition.capitalLoss, CapitalGains.Disposition.loss]

/-- 86(3): never where 85(1) applies. -/
theorem not_with_85 (f : Facts) (h : f.section85Applies = true) : applies.holds f = false := by
  simp [applies, h]

end Canteen.ITA.ShareExchange

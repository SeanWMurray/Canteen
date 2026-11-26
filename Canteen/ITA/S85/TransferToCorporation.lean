import Canteen.Core.StatuteSyntax
import Canteen.Core.Answer
import Canteen.ITA.S38.CapitalGains

/-!
# Subsections 85(1), (1.1) and (2.1): transfer of property to a corporation

*Income Tax Act*, as consolidated to 2026-10-29 (verbatim in `statute/ITA-85-1-1.1-2.1.txt`):

> (1) Where a taxpayer has, in a taxation year, disposed of any of the taxpayer's property that
> was eligible property to a taxable Canadian corporation for consideration that includes shares
> of the capital stock of the corporation, if the taxpayer and the corporation have jointly
> elected in prescribed form and in accordance with subsection 85(6), the following rules apply:
> (a) the amount that the taxpayer and the corporation have agreed on in their election … shall
> be deemed to be the taxpayer's proceeds of disposition of the property and the corporation's
> cost of the property; (b) subject to paragraph 85(1)(c), where the amount … agreed on … is less
> than the fair market value … of the consideration therefor (other than any shares of the
> capital stock of the corporation …), the amount so agreed on shall … be deemed to be an amount
> equal to that fair market value; (c) where the amount … agreed on … is greater than the fair
> market value … of the property so disposed of, [it] shall … be deemed to be an amount equal to
> that fair market value; (c.1) where the property was inventory, capital property (other than
> depreciable property of a prescribed class) … and the amount … agreed on … is less than the
> lesser of (i) the fair market value of the property …, and (ii) the cost amount to the taxpayer
> of the property …, [it] shall … be deemed to be [that lesser amount]; … (e) where the property
> was depreciable property of a prescribed class … [and the proceeds would be] less than the least
> of (i) the undepreciated capital cost … of all property of that class immediately before the
> disposition, (ii) the cost to the taxpayer of the property, and (iii) the fair market value of
> the property …, [the agreed amount] shall … be deemed to be the least of [them]; … (e.2) where
> the fair market value of the property immediately before the disposition exceeds the greater of
> (i) the fair market value, immediately after the disposition, of the consideration received …,
> and (ii) the amount … agreed on …, determined without reference to this paragraph, and it is
> reasonable to regard any part of the excess as a benefit that the taxpayer desired to have
> conferred on a person related to the taxpayer (other than a corporation that was a wholly owned
> corporation of the taxpayer immediately after the disposition), the amount … agreed on … shall …
> be deemed (except for the purposes of paragraphs 85(1)(g) and 85(1)(h)) to be … the total of the
> amount referred to in subparagraph 85(1)(e.2)(ii) and that part of the excess; (e.3) where,
> under any of paragraphs (c.1) and (e), the [elected amount] would be deemed to be an amount that
> is greater or less than the amount that would be deemed, subject to paragraph (c), to be the
> elected amount under paragraph (b), the elected amount is deemed to be the greater of [the two];
> … (f) the cost to the taxpayer of any particular property (other than shares …) received … as
> consideration … [is] the lesser of (i) [its] fair market value …, and (ii) that proportion of
> the fair market value … of the property disposed of … that (A) the amount determined under
> subparagraph 85(1)(f)(i) is of (B) the fair market value … of all properties (other than shares
> …) received …; (g) the cost to the taxpayer of any preferred shares of any class … [is] the
> lesser of the fair market value of those shares immediately after the disposition and that
> proportion of the amount, if any, by which the proceeds of the disposition exceed the fair
> market value of the consideration (other than shares …) …, that (i) the fair market value … of
> those preferred shares of that class, is of (ii) the fair market value … of all preferred
> shares … receivable …; (h) the cost to the taxpayer of any common shares of any class … [is]
> that proportion of the amount, if any, by which the proceeds of the disposition exceed the total
> of the fair market value … of the consideration (other than shares …) … and the cost to the
> taxpayer of all preferred shares …, that (i) the fair market value … of those common shares of
> that class, is of (ii) the fair market value … of all common shares … receivable …
>
> (2.1) … (a) in computing the paid-up capital in respect of any particular class of shares …
> there shall be deducted an amount determined by the formula (A − B) × C / A where A is the
> increase, if any, … in the paid-up capital in respect of all the shares … as a result of the
> acquisition by the corporation of the property, B is the amount, if any, by which the
> corporation's cost of the property … determined under subsection 85(1) … exceeds the fair
> market value … of any consideration (other than shares …) received by the taxpayer …, and C is
> the increase, if any, … in the paid-up capital in respect of the particular class of shares …

Read together, (b), (c), (c.1), (e) and (e.3) put the elected amount at the agreed amount, but at
least the non-share consideration (the "boot") and the floor in (c.1) or (e), and at most the
property's fair market value. Eligible property (85(1.1)), a taxable Canadian corporation, and a
joint election filed in time (85(6)) are facts; (e.2)'s benefit is a fact or a judgment call.
Proportions are rounded down to the cent.

Not encoded: (c.2) (cash-method farm inventory), (e.1) (ordering of depreciable properties),
(e.4), (e.5) (passenger vehicles), (i) (taxable Canadian property), 85(1.11), (1.12) and (1.2);
85(2.1)(b); and section 84.1, which displaces 85(2.1) for shares of a connected corporation.
-/

namespace Canteen.ITA.TransferToCorporation

/-- The kind of eligible property, for (c.1) and (e). -/
inductive PropertyKind where
  /-- Capital property other than depreciable property of a prescribed class: (c.1). -/
  | capital
  /-- Inventory: (c.1). The gain is income from the business, not a capital gain. -/
  | inventory
  /-- Depreciable property of a prescribed class, with the undepreciated capital cost of the whole
  class immediately before the disposition: (e). -/
  | depreciable (undepreciatedCapitalCost : Cents)
  deriving Repr, DecidableEq, Inhabited

/-- Non-share consideration (the "boot"), e.g. cash or a promissory note. -/
structure Boot where
  description : String
  fairMarketValue : Cents
  deriving Repr, DecidableEq, Inhabited

/-- One class of shares of the corporation receivable as consideration. -/
structure ShareClass where
  name : String
  /-- Fair market value immediately after the disposition. -/
  fairMarketValue : Cents
  /-- 85(2.1)(a) C: the increase in the class's paid-up capital as a result of the acquisition,
  determined without reference to 85(2.1) (usually the stated capital added under corporate law). -/
  paidUpCapitalIncrease : Cents := 0
  deriving Repr, DecidableEq, Inhabited

structure Facts where
  /-- The property, e.g. `"shares of Opco"`. -/
  description : String
  kind : PropertyKind := .capital
  /-- 85(1.1): the property is eligible property. -/
  eligible : Bool := true
  /-- The corporation is a taxable Canadian corporation. -/
  taxableCanadianCorporation : Bool := true
  /-- The taxpayer and the corporation jointly elected in prescribed form, in time (85(6)). -/
  jointElection : Bool := true
  /-- Fair market value of the property at the time of the disposition. -/
  fairMarketValue : Cents
  /-- (c.1)(ii) the cost amount to the taxpayer (for capital property, its adjusted cost base); for
  depreciable property, (e)(ii) its cost. -/
  costAmount : Cents
  /-- The amount agreed on in the election. -/
  agreed : Cents
  boot : List Boot := []
  preferred : List ShareClass := []
  common : List ShareClass := []
  /-- (e.2): it is reasonable to regard part of any excess of value over the consideration as a
  benefit the taxpayer desired to confer on a related person (other than a corporation wholly
  owned by the taxpayer immediately after). Often a judgment call. -/
  benefit : Answer := .fact false
  /-- (e.2): the part of the excess so regarded, if not all of it. -/
  benefitPart : Option Cents := none
  deriving Repr, Inhabited

/-- Subsection 85(1). -/
statute rollover (f : Facts) named "subsection 85(1)" cites "ITA 85(1)"
  applies where
    | "eligible property" f.eligible
        => "The property is eligible property (85(1.1))."
        else "The property is not eligible property (85(1.1))."
    | "taxable Canadian corporation" f.taxableCanadianCorporation
        => "It was disposed of to a taxable Canadian corporation."
        else "It was not disposed of to a taxable Canadian corporation."
    | "shares" (!(f.preferred.isEmpty && f.common.isEmpty))
        => "The consideration includes shares of the capital stock of the corporation."
        else "The consideration does not include shares of the capital stock of the corporation."
    | "election" f.jointElection
        => "The taxpayer and the corporation jointly elected in prescribed form and in time (85(6))."
        else "The taxpayer and the corporation did not jointly elect in prescribed form and in time."

/-! ## The elected amount -/

def bootTotal (f : Facts) : Cents := (f.boot.map (·.fairMarketValue)).sum
def preferredTotal (f : Facts) : Cents := (f.preferred.map (·.fairMarketValue)).sum
def commonTotal (f : Facts) : Cents := (f.common.map (·.fairMarketValue)).sum

/-- The fair market value of all the consideration, immediately after. -/
def considerationTotal (f : Facts) : Cents := bootTotal f + preferredTotal f + commonTotal f

/-- The floor in (c.1) or (e). -/
def floor (f : Facts) : Cents :=
  match f.kind with
  | .capital | .inventory => min f.fairMarketValue f.costAmount
  | .depreciable ucc => min (min ucc f.costAmount) f.fairMarketValue

/-- (b), (c), (c.1), (e), (e.3): the agreed amount, raised to the boot and the floor, and capped at
fair market value. This is the amount "determined without reference to" (e.2). -/
def electedBeforeBenefit (f : Facts) : Cents :=
  min f.fairMarketValue (max f.agreed (max (bootTotal f) (floor f)))

/-- (e.2): the excess of the property's value over the greater of the consideration and the
elected amount. -/
def excess (f : Facts) : Cents := f.fairMarketValue - max (considerationTotal f) (electedBeforeBenefit f)

/-- (e.2): the part of the excess added to the elected amount. -/
def benefitAddition (f : Facts) : Cents :=
  if f.benefit.value && 0 < excess f then min (excess f) (f.benefitPart.getD (excess f)) else 0

/-- (a): the taxpayer's proceeds and the corporation's cost. -/
def electedAmount (f : Facts) : Cents := electedBeforeBenefit f + benefitAddition f

/-- The judgment calls the elected amount rests on: (e.2)'s, where there is an excess. -/
def judgments (f : Facts) : List String := if 0 < excess f then f.benefit.judgments else []

/-! ## The cost of the consideration -/

/-- (f): a boot item's cost, the lesser of its value and its share of the property's value. -/
def bootCost (f : Facts) (b : Boot) : Cents :=
  if bootTotal f = 0 then 0 else min b.fairMarketValue (f.fairMarketValue * b.fairMarketValue / bootTotal f)

/-- (g): a preferred class's cost, the lesser of its value and its share of the proceeds over the boot. -/
def preferredCost (f : Facts) (s : ShareClass) : Cents :=
  if preferredTotal f = 0 then 0
  else min s.fairMarketValue ((electedBeforeBenefit f - bootTotal f) * s.fairMarketValue / preferredTotal f)

def preferredCostTotal (f : Facts) : Cents := (f.preferred.map (preferredCost f)).sum

/-- (h): a common class's cost, its share of what is left after the boot and the preferred shares. -/
def commonCost (f : Facts) (s : ShareClass) : Cents :=
  if commonTotal f = 0 then 0
  else (electedBeforeBenefit f - bootTotal f - preferredCostTotal f) * s.fairMarketValue / commonTotal f

/-! ## Paid-up capital: 85(2.1)(a) -/

/-- A: the increase in paid-up capital of all the shares. -/
def pucIncrease (f : Facts) : Cents :=
  ((f.preferred ++ f.common).map (·.paidUpCapitalIncrease)).sum

/-- B: the corporation's cost less the boot. -/
def pucB (f : Facts) : Cents := electedAmount f - bootTotal f

/-- (A − B) × C / A, the reduction for one class. -/
def pucReduction (f : Facts) (s : ShareClass) : Cents :=
  if pucIncrease f = 0 then 0 else (pucIncrease f - pucB f) * s.paidUpCapitalIncrease / pucIncrease f

/-- The class's paid-up capital increase after the reduction. -/
def paidUpCapital (f : Facts) (s : ShareClass) : Cents := s.paidUpCapitalIncrease - pucReduction f s

/-! ## Consequences -/

/-- The taxpayer's disposition, for the capital gains computation: at the elected amount where
85(1) applies; otherwise at fair market value (the price agreed, if 69(1) does not reach it, is
for the caller). -/
def disposition (f : Facts) : CapitalGains.Disposition :=
  { description := s!"{f.description} (to the corporation)",
    proceeds := if rollover.holds f then electedAmount f else f.fairMarketValue,
    adjustedCostBase := f.costAmount,
    capitalAccount := .fact (f.kind != .inventory),
    propertyClass := match f.kind with | .depreciable _ => .depreciable | _ => .ordinary }

def explain (f : Facts) : Finding :=
  let e := rollover.explain f
  if !rollover.holds f then e else
  let raised :=
    if electedBeforeBenefit f == f.agreed then s!"the amount agreed on, {formatCents f.agreed}"
    else if electedBeforeBenefit f == f.fairMarketValue && f.agreed > f.fairMarketValue then
      s!"{formatCents f.fairMarketValue}, the property's fair market value (85(1)(c)), not the {formatCents f.agreed} agreed on"
    else s!"{formatCents (electedBeforeBenefit f)}, not the {formatCents f.agreed} agreed on: at least the boot of " ++
      s!"{formatCents (bootTotal f)} (85(1)(b)) and the floor of {formatCents (floor f)} (85(1)(c.1), (e), (e.3))"
  let benefitSteps : List Step :=
    if benefitAddition f > 0 then
      [⟨s!"The property's value exceeds the consideration by {formatCents (excess f)}, and {formatCents (benefitAddition f)} of " ++
        "that is reasonably regarded as a benefit the taxpayer desired to confer on a related person, so it is added to the " ++
        "elected amount (but not to the cost of the shares).", "ITA 85(1)(e.2)"⟩]
    else []
  let costs : List Step :=
    (f.boot.map fun b => ⟨s!"The taxpayer's cost of {b.description} is {formatCents (bootCost f b)}.", "ITA 85(1)(f)"⟩) ++
    (f.preferred.map fun s => ⟨s!"The taxpayer's cost of the {s.name} is {formatCents (preferredCost f s)}.", "ITA 85(1)(g)"⟩) ++
    (f.common.map fun s => ⟨s!"The taxpayer's cost of the {s.name} is {formatCents (commonCost f s)}.", "ITA 85(1)(h)"⟩)
  ⟨true, e.steps ++ [⟨s!"The elected amount is {raised}.", "ITA 85(1)(b), (c), (c.1), (e), (e.3)"⟩] ++ benefitSteps ++
    [⟨s!"So the taxpayer's proceeds, and the corporation's cost, are {formatCents (electedAmount f)}.", "ITA 85(1)(a)"⟩] ++ costs,
    mergeIds e.reliesOn (judgments f)⟩

/-- Subsection 85(1), as a rule, with its consequences. -/
def rule : Rule Facts where
  name := "subsection 85(1)"
  citation := "ITA 85(1)"
  holds := rollover.holds
  explain := explain
  sound := fun f => by unfold explain; split <;> simp_all

/-! ## Truths about the rollover -/

/-- (c): the elected amount (before (e.2)) never exceeds the property's fair market value. -/
theorem elected_le_fairMarketValue (f : Facts) : electedBeforeBenefit f ≤ f.fairMarketValue :=
  Nat.min_le_left _ _

/-- (b): the elected amount is at least the boot (up to the property's value): taking back cash or
a note over the cost realizes a gain. -/
theorem boot_le_elected (f : Facts) (h : bootTotal f ≤ f.fairMarketValue) : bootTotal f ≤ electedAmount f := by
  have : bootTotal f ≤ electedBeforeBenefit f := by
    unfold electedBeforeBenefit
    exact Nat.le_min.mpr ⟨h, Nat.le_trans (Nat.le_max_left _ _) (Nat.le_max_right _ _)⟩
  exact Nat.le_trans this (Nat.le_add_right _ _)

/-- **The rollover.** Electing at cost, with boot no more than the cost, on capital property worth
at least its cost and with no (e.2) benefit, defers the whole gain. -/
theorem at_cost_no_gain (f : Facts) (hk : f.kind = .capital) (ha : f.agreed = f.costAmount)
    (hb : bootTotal f ≤ f.costAmount) (hv : f.costAmount ≤ f.fairMarketValue) (hn : f.benefit.value = false)
    (hr : rollover.holds f = true) : (disposition f).gain = 0 := by
  have hf : floor f = f.costAmount := by simp [floor, hk, Nat.min_eq_right hv]
  have he : electedBeforeBenefit f = f.costAmount := by
    simp only [electedBeforeBenefit, hf, ha, Nat.max_eq_right hb, Nat.max_self, Nat.min_eq_right hv]
  have hz : benefitAddition f = 0 := by simp [benefitAddition, hn]
  simp [disposition, hr, electedAmount, he, hz, CapitalGains.Disposition.gain, CapitalGains.Disposition.excess,
    CapitalGains.Disposition.reserveLimit]

/-- (e.2) raises the proceeds, but not the cost of the shares: the benefit is taxed and lost. -/
theorem benefit_not_in_share_cost (f : Facts) (s : ShareClass) (b : Answer) :
    commonCost { f with benefit := b } s = commonCost f s ∧ preferredCost { f with benefit := b } s = preferredCost f s :=
  ⟨rfl, rfl⟩

/-- (h): a single class of common shares takes what is left of the proceeds. -/
theorem single_common_takes_rest (f : Facts) (s : ShareClass) (h : f.common = [s]) (hs : 0 < s.fairMarketValue) :
    commonCost f s = electedBeforeBenefit f - bootTotal f - preferredCostTotal f := by
  have ht : commonTotal f = s.fairMarketValue := by simp [commonTotal, h]
  simp [commonCost, ht, Nat.pos_iff_ne_zero.mp hs, Nat.mul_div_cancel _ hs]

/-- **85(2.1).** Where one class of shares is issued, its paid-up capital is ground down to the
corporation's cost less the boot (B), when the increase would otherwise exceed it. -/
theorem puc_single_class (f : Facts) (s : ShareClass) (h : f.preferred ++ f.common = [s])
    (hb : pucB f ≤ s.paidUpCapitalIncrease) (hp : 0 < s.paidUpCapitalIncrease) :
    paidUpCapital f s = pucB f := by
  have ha : pucIncrease f = s.paidUpCapitalIncrease := by simp [pucIncrease, h]
  simp only [paidUpCapital, pucReduction, ha, Nat.pos_iff_ne_zero.mp hp, ite_false, Nat.mul_div_cancel _ hp]
  exact Nat.sub_sub_self hb

end Canteen.ITA.TransferToCorporation

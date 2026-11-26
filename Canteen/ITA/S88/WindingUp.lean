import Canteen.Core.StatuteSyntax
import Canteen.ITA.S38.CapitalGains

/-!
# Subsection 88(1): winding up a subsidiary into its parent, and the bump

*Income Tax Act*, as consolidated to 2026-10-29 (verbatim, in part, in `statute/ITA-88-1.txt`):

> (1) Where a taxable Canadian corporation (the "subsidiary") has been wound up … and not less than
> 90% of the issued shares of each class of [its] capital stock … were, immediately before the
> winding-up, owned by another taxable Canadian corporation (the "parent") and all of the shares of
> the subsidiary that were not owned by the parent … were owned … by persons with whom the parent
> was dealing at arm's length, … (a) each property … of the subsidiary that was distributed to the
> parent on the winding-up shall be deemed to have been disposed of by the subsidiary for proceeds
> equal to … (iii) … the cost amount to the subsidiary of the property immediately before the
> winding-up; (b) the shares of the capital stock of the subsidiary owned by the parent … shall be
> deemed to have been disposed of by the parent … for proceeds equal to the greater of (i) the lesser
> of the paid-up capital in respect of those shares … and the amount determined under subparagraph
> 88(1)(d)(i), and (ii) [their] adjusted cost base to the parent …; (c) the cost to the parent of
> each property of the subsidiary distributed to the parent … shall be deemed to be … the amount …
> deemed by paragraph 88(1)(a) to be the proceeds of disposition of the property … plus where the
> property was a capital property (other than an ineligible property) of the subsidiary at the time
> that the parent last acquired control of the subsidiary and was owned by the subsidiary thereafter
> without interruption …, the amount determined under paragraph 88(1)(d) …; [ineligible property
> being (iii) depreciable property and (iv) to (vi) property in certain reorganizations and sales];
> (d) [the bump:] such portion of the amount, if any, by which the total determined under
> subparagraph 88(1)(b)(ii) exceeds the total of (i) the amount, if any, by which (A) the total of
> the cost amounts of the subsidiary's property and its money exceeds (B) its debts and other
> obligations and (C) certain reserves, and (i.1) [taxable dividends deductible under 112, and
> capital dividends, received by the parent (or a non-arm's length corporation) on the shares], as
> is designated by the parent in respect of that capital property …, except that (ii) the amount
> designated in respect of any such capital property may not exceed … A − (B + C) where A is the
> fair market value of the property at the time the parent last acquired control of the subsidiary,
> B is the greater of the cost amount to the subsidiary of the property at [that] time and [its]
> cost amount … immediately before the winding-up, and C is the prescribed amount, and … (iii) in no
> case shall the total of amounts so designated … exceed the amount, if any, by which the total
> determined under subparagraph 88(1)(b)(ii) exceeds the total of the amounts determined under
> subparagraphs 88(1)(d)(i) and 88(1)(d)(i.1) …

Whether each property is eligible for the bump (a capital property held since the parent last
acquired control, not ineligible under (c)(iii) to (vi)) is a fact, as are the amounts the parent
designates; designations are capped by (d)(ii) for each property and then by (d)(iii) in the order
given. The prescribed amount C is nil. Not encoded: resource properties and partnership interests
((a)(i), (a.2), (c)(i), (d)(ii.1)), section 80, (a.1), (a.3), (c.2) to (c.9), (d.1) to (e.8).
-/

namespace Canteen.ITA.WindingUp

/-- One property of the subsidiary distributed to the parent. -/
structure Property where
  description : String
  /-- Cost amount to the subsidiary immediately before the winding-up. -/
  costAmount : Cents
  /-- Eligible for the bump: a capital property, held without interruption since the parent last
  acquired control, and not ineligible property ((c)(iii) to (vi)). -/
  eligible : Bool := false
  /-- (d)(ii) A: fair market value when the parent last acquired control. -/
  valueAtControl : Cents := 0
  /-- (d)(ii) B: cost amount when the parent last acquired control. -/
  costAmountAtControl : Cents := 0
  /-- The amount the parent designates for it. -/
  designated : Cents := 0
  deriving Repr, DecidableEq, Inhabited

structure Facts where
  /-- Both are taxable Canadian corporations. -/
  bothTaxableCanadian : Bool := true
  /-- The parent owns at least 90% of each class of the subsidiary's shares. -/
  ninetyPercent : Bool := true
  /-- The other shares are owned by persons dealing at arm's length with the parent. -/
  minorityArmsLength : Bool := true
  properties : List Property
  money : Cents := 0
  /-- (d)(i)(B), (C): debts and other obligations, and reserves. -/
  liabilities : Cents := 0
  /-- The parent's adjusted cost base of the shares, and their paid-up capital. -/
  adjustedCostBase : Cents
  paidUpCapital : Cents
  /-- (d)(i.1): dividends received on the shares (112-deductible taxable dividends, and capital dividends). -/
  dividendsReceived : Cents := 0
  deriving Repr, DecidableEq, Inhabited

/-- Subsection 88(1). -/
statute applies (f : Facts) named "subsection 88(1)" cites "ITA 88(1)"
  applies where
    | "taxable Canadian corporations" f.bothTaxableCanadian
        => "The subsidiary and the parent are taxable Canadian corporations."
        else "The subsidiary or the parent is not a taxable Canadian corporation."
    | "90%" f.ninetyPercent
        => "The parent owned at least 90% of the issued shares of each class of the subsidiary immediately before the winding-up."
        else "The parent did not own at least 90% of each class of the subsidiary's shares."
    | "minority" f.minorityArmsLength
        => "The other shares were owned by persons dealing at arm's length with the parent."
        else "Some other shares were owned by persons not dealing at arm's length with the parent."

/-- (d)(i): the subsidiary's net tax cost: cost amounts and money, less liabilities and reserves. -/
def netTaxCost (f : Facts) : Cents := ((f.properties.map (·.costAmount)).sum + f.money) - f.liabilities

/-- (b): the parent's proceeds for the shares. -/
def shareProceeds (f : Facts) : Cents := max (min f.paidUpCapital (netTaxCost f)) f.adjustedCostBase

/-- (d)(iii): the total that may be designated. -/
def bumpRoom (f : Facts) : Cents := f.adjustedCostBase - (netTaxCost f + f.dividendsReceived)

/-- (d)(ii): the most that may be designated for one property. -/
def cap (p : Property) : Cents := if p.eligible then p.valueAtControl - max p.costAmountAtControl p.costAmount else 0

/-- The bump for each property: its designation, capped by (d)(ii), and by what is left of (d)(iii). -/
def bumps : Cents → List Property → List Cents
  | _, [] => []
  | room, p :: ps => let b := min (min p.designated (cap p)) room; b :: bumps (room - b) ps

def bumpOf (f : Facts) : List Cents := if applies.holds f then bumps (bumpRoom f) f.properties else f.properties.map fun _ => 0

/-- (c): the parent's cost of each property: the subsidiary's cost amount, plus its bump. -/
def parentCosts (f : Facts) : List Cents := (f.properties.zip (bumpOf f)).map fun (p, b) => p.costAmount + b

/-- (a): the subsidiary's dispositions: each at its cost amount, so no gain or loss on capital account. -/
def subsidiaryDispositions (f : Facts) : List CapitalGains.Disposition :=
  f.properties.map fun p => { description := p.description, proceeds := p.costAmount, adjustedCostBase := p.costAmount }

/-- (b): the parent's disposition of the shares. -/
def parentDisposition (f : Facts) : CapitalGains.Disposition :=
  { description := "the shares of the subsidiary", proceeds := shareProceeds f, adjustedCostBase := f.adjustedCostBase }

def explain (f : Facts) : Finding :=
  let e := applies.explain f
  let c := formatCents
  if !applies.holds f then e else
  ⟨true, e.steps ++ [
    ⟨"Each property of the subsidiary is deemed disposed of at its cost amount: no gain or loss.", "ITA 88(1)(a)"⟩,
    ⟨s!"The subsidiary's net tax cost is {c (netTaxCost f)}; the parent's shares are deemed disposed of for {c (shareProceeds f)}, " ++
      s!"the greater of the lesser of their paid-up capital and that cost, and their adjusted cost base of {c f.adjustedCostBase}.",
      "ITA 88(1)(b)"⟩,
    ⟨s!"The adjusted cost base exceeds the net tax cost and dividends received by {c (bumpRoom f)}, the most that can be added " ++
      s!"to the cost of eligible capital property; {c (bumpOf f).sum} is added.", "ITA 88(1)(c), (d)"⟩], e.reliesOn⟩

/-- Subsection 88(1), as a rule, with its consequences. -/
def rule : Rule Facts where
  name := "subsection 88(1)"
  citation := "ITA 88(1)"
  holds := applies.holds
  explain := explain
  sound := fun f => by unfold explain; split <;> simp_all

/-! ## Truths about the winding-up -/

private theorem add_le (b s r : Nat) (h1 : s ≤ r - b) (h2 : b ≤ r) : b + s ≤ r := by omega

private theorem replicate_zero_sum : ∀ n : Nat, (List.replicate n (0 : Nat)).sum = 0
  | 0 => rfl
  | n + 1 => by simp [List.replicate_succ, replicate_zero_sum n]

theorem bumps_le_room : ∀ (room : Cents) (ps : List Property), (bumps room ps).sum ≤ room
  | _, [] => by simp [bumps]
  | room, p :: ps => by
    simp only [bumps, List.sum_cons]
    have ih := bumps_le_room (room - min (min p.designated (cap p)) room) ps
    have hb : min (min p.designated (cap p)) room ≤ room := Nat.min_le_right _ _
    exact add_le _ _ _ ih hb

/-- **The bump never exceeds the room:** the parent's adjusted cost base less the net tax cost and
dividends received. -/
theorem bump_le_room (f : Facts) : (bumpOf f).sum ≤ bumpRoom f := by
  unfold bumpOf; split
  · exact bumps_le_room _ _
  · simp only [List.map_const']
    rw [replicate_zero_sum]
    exact Nat.zero_le _

/-- **No loss on the shares:** the parent's proceeds are at least their adjusted cost base. -/
theorem no_share_loss (f : Facts) : (parentDisposition f).loss = 0 := by
  have : f.adjustedCostBase ≤ shareProceeds f := Nat.le_max_right _ _
  simp [parentDisposition, CapitalGains.Disposition.loss, Nat.sub_eq_zero_of_le this]

/-- The subsidiary has no gain on any property it distributes. -/
theorem no_subsidiary_gain (f : Facts) : ∀ d ∈ subsidiaryDispositions f, d.gain = 0 := by
  intro d hd
  simp only [subsidiaryDispositions, List.mem_map] at hd
  obtain ⟨p, _, rfl⟩ := hd
  simp [CapitalGains.Disposition.gain, CapitalGains.Disposition.excess, CapitalGains.Disposition.reserveLimit]

end Canteen.ITA.WindingUp

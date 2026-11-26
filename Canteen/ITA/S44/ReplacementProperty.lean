import Canteen.Core.StatuteSyntax
import Canteen.ITA.S38.CapitalGains

/-!
# Subsection 44(1): replacement property

*Income Tax Act*, as consolidated to 2026-10-29 (verbatim in `statute/ITA-44-1.txt`):

> (1) Where at any time in a taxation year (the "initial year") an amount has become receivable by a
> taxpayer as proceeds of disposition of a capital property that is not a share of the capital
> stock of a corporation (the taxpayer's "former property") that is either (a) property the proceeds
> of disposition of which are described in paragraph (b), (c) or (d) of the definition proceeds of
> disposition [compensation for property unlawfully taken, destroyed, or expropriated] …, or (b) a
> property that was, immediately before the disposition, a former business property of the
> taxpayer, and the taxpayer has (c) if the former property is described in paragraph (a), before
> the later of the end of the second taxation year following the initial year and 24 months after
> the end of the initial year, and (d) in any other case, before the later of the end of the first
> taxation year following the initial year and 12 months after the end of the initial year,
> acquired a capital property that is a replacement property for the taxpayer's former property …,
> notwithstanding subsection 40(1), if the taxpayer so elects …, (e) the gain for [the initial year]
> … shall be deemed to be the amount, if any, by which … the lesser of (A) the amount, if any, by
> which the proceeds of disposition of the former property exceed [its adjusted cost base and
> outlays] and (B) the amount, if any, by which the proceeds of disposition of the former property
> exceed the total of the cost … of the taxpayer's replacement property and any outlays and expenses
> …, exceeds (iii) [a reserve] …; and (f) the cost … of the taxpayer's replacement property … shall
> be deemed to be (i) [its cost] … minus (ii) the amount, if any, by which the amount determined
> under clause 44(1)(e)(i)(A) exceeds the amount determined under clause 44(1)(e)(i)(B).

Taxation years are numbered; the deadlines in (c) and (d) are read as the end of the second (or
first) taxation year after the initial year, which for a calendar-year taxpayer is also 24 (or 12)
months after its end. Whether the property is a replacement property (44(5)), whether its proceeds
are of the kinds in (a), whether it was a former business property (248(1)), and the election, are
facts. For depreciable property, (e)(i)(A)(I) uses the lesser of proceeds and cost, which gives the
same excess. Not encoded: the reserve in (e)(ii) and (iii) and 44(1.1), 44(2) to (7), and 13(4).
-/

namespace Canteen.ITA.ReplacementProperty

/-- Why the former property was disposed of. -/
inductive Kind where
  /-- (a): stolen, destroyed, expropriated, or the like: two years to replace it. -/
  | involuntary
  /-- (b): a former business property sold: one year to replace it. -/
  | formerBusinessProperty
  /-- Neither. -/
  | other
  deriving Repr, DecidableEq, Inhabited

structure Facts where
  /-- The former property, e.g. `"the warehouse"`. -/
  description : String
  kind : Kind
  /-- The former property is a share of the capital stock of a corporation. -/
  share : Bool := false
  /-- The taxation year the proceeds became receivable. -/
  initialYear : Nat
  /-- The taxation year the replacement property was acquired, if one was. -/
  replacedInYear : Option Nat
  /-- The property acquired is a replacement property (44(5)), not disposed of before the former property. -/
  isReplacement : Bool := true
  /-- The taxpayer elects in the return for the year of the replacement. -/
  elected : Bool := true
  proceeds : Cents
  adjustedCostBase : Cents
  outlaysAndExpenses : Cents := 0
  /-- The replacement property's cost (or capital cost) otherwise determined. -/
  replacementCost : Cents
  deriving Repr, DecidableEq, Inhabited

/-- (c), (d): replaced in time. -/
def inTime (f : Facts) : Bool :=
  match f.replacedInYear with
  | none => false
  | some y => match f.kind with
    | .involuntary => y ≤ f.initialYear + 2
    | .formerBusinessProperty => y ≤ f.initialYear + 1
    | .other => false

/-- Subsection 44(1). -/
statute applies (f : Facts) named "subsection 44(1)" cites "ITA 44(1)"
  applies where
    | "former property" (f.kind != .other && !f.share)
        => "The former property is capital property (not a share) whose proceeds are compensation for its loss, destruction or expropriation, or a former business property."
        else "The former property is a share, or neither property whose proceeds are compensation for its loss, destruction or expropriation nor a former business property."
    | "(c), (d)" (f.isReplacement && inTime f)
        => "A replacement property was acquired in time (by the end of the second taxation year after the initial year for (a), the first for (b))."
        else "No replacement property was acquired in time."
    | "election" f.elected
        => "The taxpayer elects under subsection 44(1)."
        else "The taxpayer does not elect under subsection 44(1)."

/-- (e)(i)(A): the gain otherwise. -/
def gainA (f : Facts) : Cents := f.proceeds - (f.adjustedCostBase + f.outlaysAndExpenses)

/-- (e)(i)(B): the proceeds not reinvested. -/
def gainB (f : Facts) : Cents := f.proceeds - (f.replacementCost + f.outlaysAndExpenses)

/-- (e)(i): the initial year's gain (before any reserve). -/
def gain (f : Facts) : Cents := if applies.holds f then min (gainA f) (gainB f) else gainA f

/-- The gain deferred: (f)(ii). -/
def deferred (f : Facts) : Cents := if applies.holds f then gainA f - gainB f else 0

/-- (f): the replacement property's cost, less the deferred gain. -/
def replacementCostAfter (f : Facts) : Cents := f.replacementCost - deferred f

/-- The disposition of the former property, for the capital gains computation: the gain as 44(1)(e)
deems it, expressed as proceeds over cost. -/
def disposition (f : Facts) : CapitalGains.Disposition :=
  { description := f.description, proceeds := f.proceeds - deferred f, adjustedCostBase := f.adjustedCostBase,
    outlaysAndExpenses := f.outlaysAndExpenses }

def explain (f : Facts) : Finding :=
  let e := applies.explain f
  let c := formatCents
  if !applies.holds f then e else
  ⟨true, e.steps ++ [
    ⟨s!"The gain otherwise would be {c (gainA f)}; the proceeds exceed the replacement property's cost of " ++
      s!"{c f.replacementCost} (and outlays) by {c (gainB f)}. The gain is the lesser, {c (gain f)}.", "ITA 44(1)(e)(i)"⟩,
    ⟨s!"The {c (deferred f)} deferred reduces the replacement property's cost to {c (replacementCostAfter f)}.", "ITA 44(1)(f)"⟩],
    e.reliesOn⟩

/-- Subsection 44(1), as a rule, with its consequences. -/
def rule : Rule Facts where
  name := "subsection 44(1)"
  citation := "ITA 44(1)"
  holds := applies.holds
  explain := explain
  sound := fun f => by unfold explain; split <;> simp_all

/-! ## Truths about replacement property -/

private theorem min_add_sub (a b : Nat) : min a b + (a - b) = a := by omega

/-- **Deferred, not forgiven.** The gain recognized and the gain deferred add up to the gain otherwise. -/
theorem gain_add_deferred (f : Facts) : gain f + deferred f = gainA f := by
  unfold gain deferred; split
  · exact min_add_sub _ _
  · rfl

/-- Reinvesting all the proceeds (the replacement costs at least the proceeds less outlays) defers the whole gain. -/
theorem fully_reinvested (f : Facts) (h : applies.holds f = true) (hr : f.proceeds ≤ f.replacementCost + f.outlaysAndExpenses) :
    gain f = 0 := by
  have : gainB f = 0 := Nat.sub_eq_zero_of_le hr
  simp [gain, h, this]

/-- A share is never former property. -/
theorem not_a_share (f : Facts) (h : f.share = true) : applies.holds f = false := by
  simp [applies, h]

end Canteen.ITA.ReplacementProperty

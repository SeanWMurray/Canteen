import Canteen.Core.StatuteSyntax
import Canteen.ITA.S38.CapitalGains

/-!
# Subsections 70(5) and (6): death

*Income Tax Act*, as consolidated to 2026-10-29 (verbatim in `statute/ITA-70-5-6.txt`):

> **70(5)** Where in a taxation year a taxpayer dies, (a) the taxpayer shall be deemed to have,
> immediately before the taxpayer's death, disposed of each capital property … and received
> proceeds of disposition therefor equal to the fair market value of the property immediately
> before the death; (b) any person who as a consequence of the taxpayer's death acquires any
> property … shall be deemed to have acquired it … at a cost equal to its fair market value …
>
> **70(6)** Where any property of a taxpayer who was resident in Canada immediately before the
> taxpayer's death … is, as a consequence of the death, transferred or distributed to (a) the
> taxpayer's spouse or common-law partner who was resident in Canada immediately before the
> taxpayer's death, or (b) a trust, created by the taxpayer's will, that was resident in Canada …
> under which (i) the … spouse or common-law partner is entitled to receive all of the income …
> and (ii) no person except the spouse … may … receive or otherwise obtain the use of any of the
> income or capital …, if it can be shown, within the period ending 36 months after the death …,
> that the property has become vested indefeasibly in the spouse or … trust, … (c) paragraphs
> 70(5)(a) and (b) do not apply …, (d) … the taxpayer shall be deemed to have … disposed of the
> property and received proceeds … equal to (i) [for prescribed depreciable property, the lesser
> of capital cost and cost amount] and (ii) in any other case, its adjusted cost base …, and the
> spouse … or trust … shall be deemed to have acquired the property … at a cost equal to those proceeds.

70(6.2) lets the legal representative elect that 70(6) not apply to a property (a fact here).
Not encoded: 70(5)(c), (d), 70(6)(d.1), (e) (depreciable property and partnership interests
beyond the proceeds amount), and the Minister's extension of the 36-month period.
-/

namespace Canteen.ITA.Death

/-- Who acquires a property as a consequence of the death. -/
inductive Recipient where
  /-- (6)(a) the spouse or common-law partner; `resident` immediately before the death. -/
  | spouse (resident : Bool)
  /-- (6)(b) a testamentary spousal or common-law partner trust meeting (i) and (ii);
  `resident` immediately after the property vested in it. -/
  | spousalTrust (resident : Bool)
  /-- Anyone else (a child, an estate distributed to others, a charity …). -/
  | other (who : String)
  deriving Repr, DecidableEq, Inhabited

/-- A capital property of the deceased. -/
structure Property where
  description : String
  fairMarketValue : Cents
  adjustedCostBase : Cents
  recipient : Recipient
  /-- It can be shown that it vested indefeasibly in the spouse or trust within 36 months. -/
  vestedWithin36Months : Bool := true
  /-- 70(6.2): the legal representative elects that 70(6) not apply. -/
  electedOut : Bool := false
  /-- (6)(d)(i): for depreciable property of a prescribed class, the lesser of capital cost and cost amount. -/
  prescribedClassAmount : Option Cents := none
  deriving Repr, DecidableEq, Inhabited

/-- The deceased and one property. -/
structure Query where
  residentBeforeDeath : Bool
  property : Property
  deriving Inhabited

private def toSpouseOrTrust : Recipient → Bool
  | .spouse r => r
  | .spousalTrust r => r
  | .other _ => false

/-- Subsection 70(6). -/
statute rollover (q : Query) named "subsection 70(6)" cites "ITA 70(6)"
  applies where
    | "resident" q.residentBeforeDeath
        => "The deceased was resident in Canada immediately before death."
        else "The deceased was not resident in Canada immediately before death."
    | "(a), (b)" (toSpouseOrTrust q.property.recipient)
        => "The property was transferred, as a consequence of the death, to the spouse or common-law partner, resident in Canada immediately before the death, or to a resident testamentary trust under which the spouse or common-law partner has all the income for life and no one else may use the income or capital."
        else "The property did not pass to a resident spouse or common-law partner or a qualifying resident spousal trust."
    | "vesting" q.property.vestedWithin36Months
        => "It can be shown that the property vested indefeasibly in the spouse or trust within 36 months after the death."
        else "It cannot be shown that the property vested indefeasibly within 36 months after the death."
  except where
    | "election under 70(6.2)" q.property.electedOut
        => "The legal representative elects under subsection 70(6.2) that subsection 70(6) not apply to the property."
        else "No election is made under subsection 70(6.2)."

/-- The deceased's proceeds: 70(6)(d) where 70(6) applies, otherwise fair market value (70(5)(a)). -/
def proceeds (q : Query) : Cents :=
  if rollover.holds q then q.property.prescribedClassAmount.getD q.property.adjustedCostBase
  else q.property.fairMarketValue

/-- The recipient's cost: equal to the deceased's proceeds (70(5)(b), 70(6)(d)). -/
def recipientCost (q : Query) : Cents := proceeds q

/-- The deemed disposition, for the terminal year's capital gains computation. -/
def disposition (q : Query) : CapitalGains.Disposition :=
  { description := q.property.description, proceeds := proceeds q, adjustedCostBase := q.property.adjustedCostBase }

/-- Every capital property of the deceased, as the terminal year's deemed dispositions. -/
def terminalDispositions (residentBeforeDeath : Bool) (ps : List Property) : List CapitalGains.Disposition :=
  ps.map fun p => disposition ⟨residentBeforeDeath, p⟩

/-- The deemed disposition, for the superficial loss definition: deemed by section 70, so excepted
by its paragraph (c). -/
def slDisposition (q : Query) (date : Date) : SuperficialLoss.Disposition :=
  { description := q.property.description, date, proceeds := proceeds q, adjustedCostBase := q.property.adjustedCostBase,
    outlaysAndExpenses := 0, deemedBy := some .s70 }

def explain (q : Query) : Finding :=
  let e := rollover.explain q
  let p := q.property
  let tail : Step :=
    if rollover.holds q then
      ⟨s!"So {p.description} is deemed disposed of for {formatCents (proceeds q)}, its adjusted cost base, and acquired by the " ++
        "spouse or trust at that cost: no gain or loss.", "ITA 70(6)(c), (d)"⟩
    else
      ⟨s!"So {p.description} is deemed disposed of immediately before death for its fair market value, " ++
        s!"{formatCents p.fairMarketValue}, and acquired at that cost.", "ITA 70(5)(a), (b)"⟩
  ⟨rollover.holds q, e.steps ++ [tail], e.reliesOn⟩

/-- Subsection 70(6), as a rule, with its consequence. -/
def rule : Rule Query where
  name := "subsection 70(6)"
  citation := "ITA 70(6)"
  holds := rollover.holds
  explain := explain
  sound := fun _ => rfl

/-! ## Truths about death -/

/-- Property left to a child is deemed disposed of at fair market value: the growth is taxed. -/
theorem to_child_at_fair_market_value (b : Bool) (p : Property) (h : ∃ w, p.recipient = .other w) :
    proceeds ⟨b, p⟩ = p.fairMarketValue := by
  obtain ⟨w, hw⟩ := h
  simp [proceeds, rollover, toSpouseOrTrust, hw]

/-- Property rolled to the spouse (other than prescribed depreciable property) has no gain or loss. -/
theorem rollover_no_gain (q : Query) (h : rollover.holds q = true) (hd : q.property.prescribedClassAmount = none) :
    (disposition q).gain = 0 ∧ (disposition q).loss = 0 := by
  simp [disposition, proceeds, h, hd, CapitalGains.Disposition.gain, CapitalGains.Disposition.loss,
    CapitalGains.Disposition.excess, CapitalGains.Disposition.reserveLimit]

/-- The recipient's cost always equals the deceased's proceeds. -/
theorem cost_eq_proceeds (q : Query) : recipientCost q = proceeds q := rfl

end Canteen.ITA.Death

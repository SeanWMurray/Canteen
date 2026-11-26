import Canteen.Core.StatuteSyntax
import Canteen.ITA.S54.SuperficialLoss

/-!
# Subsections 40(3.3) to (3.5): suspended losses of corporations, trusts and partnerships

*Income Tax Act*, subsections 40(3.3), (3.4) and (3.5), as consolidated to 2026-10-29
(verbatim in `statute/ITA-40-3.3-3.5.txt`).

When a corporation, trust or partnership (the **transferor**) disposes of a capital property
and, in the period from 30 days before to 30 days after, it or an affiliated person acquires the
same or an identical property and owns it at the end of the period (40(3.3)), the loss is nil
(40(3.4)(a)) but **suspended**: it is deemed to be a loss of the transferor immediately before
the first of the times in 40(3.4)(b)(i) to (v), for example when neither the transferor nor an
affiliated person has owned the property for 30 days.

This reuses the superficial loss encoding: the same period, the same exceptions (paragraphs (c)
to (g) of that definition), and the same acquirers (affiliation decided by section 251.1). It is
the rule that paragraph (h) of the superficial loss definition defers to.
-/

namespace Canteen.ITA.SuspendedLoss

open SuperficialLoss

/-- Who disposed of the property. 40(3.3) applies only to a corporation, trust or partnership. -/
inductive TransferorKind where
  | corporation
  | trust
  | partnership
  | individual
  deriving Repr, DecidableEq, Inhabited

/-- How an acquired property relates to the particular property, with 40(3.5). -/
inductive Identity where
  | same
  /-- Identical, as a judgment call. -/
  | identical (judgment : String) (assumed : Bool)
  /-- (3.5)(a): a right to acquire the property; `securityOnly` if it is a right, as security
  only, derived from a mortgage, hypothec, agreement for sale or similar obligation. -/
  | rightToAcquire (securityOnly : Bool)
  /-- (3.5)(b)(i): a share acquired in exchange for the particular share in a transaction to which
  section 51, 86 or 87 applies. -/
  | shareExchange
  /-- (3.5)(b)(ii): a share acquired in exchange under section 85.1, where 40(3.4) applied to a
  prior disposition of the particular share and no release time in 40(3.4)(b) has occurred. -/
  | shareExchange85_1 (priorSuspendedAndNotReleased : Bool)
  /-- (3.5)(b.1): a share of a SIFT wind-up corporation, for equity in the SIFT wind-up entity. -/
  | siftWindUpShare
  | different
  deriving Repr, DecidableEq, Inhabited

def Identity.judgment? : Identity → Option String
  | .identical j _ => some j
  | _ => none

/-- An acquisition that may be of substituted property. -/
structure Acquisition where
  description : String
  date : Date
  acquirer : Acquirer
  identity : Identity
  /-- At the end of the period, the transferor or a person affiliated with the transferor owns it
  (40(3.3)(c): "owns", not "had a right to acquire"). -/
  ownedAtEndOfPeriod : Bool
  deriving Repr, DecidableEq

/-- The times in 40(3.4)(b), each the date it occurs, if it has. -/
structure ReleaseEvents where
  /-- (i) A 30-day period begins throughout which neither the transferor nor an affiliated person
  owns the substituted property (or an identical property acquired after the day 31 days before). -/
  thirtyDaysWithout : Option Date := none
  /-- (ii) The property would be deemed disposed of by section 128.1 or subsection 149(10). -/
  deemedDisposition : Option Date := none
  /-- (iii) The transferor is subject to a loss restriction event (immediately before it). -/
  lossRestrictionEvent : Option Date := none
  /-- (iv) The transferor or an affiliated person is deemed by section 50 to have disposed of it
  (where the substituted property is a debt or a share). -/
  section50 : Option Date := none
  /-- (v) A corporation's winding-up (other than under 88(1)) begins. -/
  windingUp : Option Date := none
  deriving Repr, DecidableEq, Inhabited

/-- The facts 40(3.3) and (3.4) need. -/
structure Facts where
  transferor : TransferorKind
  /-- The disposition: its date, amounts, and the facts for paragraphs (c) to (g) of the
  superficial loss definition. -/
  disposition : Disposition
  /-- The particular property is capital property. -/
  capitalProperty : Bool := true
  /-- It is depreciable property of a prescribed class. -/
  prescribedDepreciable : Bool := false
  /-- The foreign affiliate surplus carve-out in 40(3.3)(a) (excluded property). -/
  surplusExcludedProperty : Bool := false
  acquisitions : List Acquisition
  release : ReleaseEvents := {}
  deriving Repr, DecidableEq

/-! ## Subsection 40(3.3) -/

/-- (3.3)(b) with (3.5): the property is, or is identical to, the particular property. -/
def isOrIsIdentical (a : Acquisition) : Bool :=
  match a.identity with
  | .same => true
  | .identical _ b => b
  | .rightToAcquire securityOnly => !securityOnly
  | .shareExchange => true
  | .shareExchange85_1 ok => ok
  | .siftWindUpShare => a.date.before ⟨2013, 1, 1⟩
  | .different => false

/-- (3.3)(b) and (c): acquired in the period by the transferor or an affiliated person, and owned
by one of them at its end. -/
def qualifies (d : Disposition) (a : Acquisition) : Bool :=
  d.date.withinDaysAround a.date 30 && a.acquirer.isTaxpayerOrAffiliated && isOrIsIdentical a && a.ownedAtEndOfPeriod

/-- The judgment calls the acquisitions rest on. -/
def acquisitionJudgments (f : Facts) : List String :=
  (f.acquisitions.filter fun a => f.disposition.date.withinDaysAround a.date 30 && a.ownedAtEndOfPeriod).foldl
    (fun ids a => mergeIds ids (mergeIds a.acquirer.judgments a.identity.judgment?.toList)) []

/-- Subsection 40(3.3). -/
statute applies (f : Facts) named "subsection 40(3.3)" cites "ITA 40(3.3)"
  applies where
    | (a) (f.transferor != .individual)
        => "The transferor is a corporation, trust or partnership."
        else "The transferor is not a corporation, trust or partnership."
    | "(a) property" (f.capitalProperty && !f.prescribedDepreciable)
        => "It disposed of a capital property that is not depreciable property of a prescribed class."
        else "The property is not a capital property, or is depreciable property of a prescribed class."
    | "(b), (c)" judgments (acquisitionJudgments f) (f.acquisitions.any (qualifies f.disposition))
        => "During the period that begins 30 days before and ends 30 days after the disposition, the transferor or a person affiliated with it acquired a property that is, or is identical to, the particular property, and at the end of that period the transferor or a person affiliated with it owns it."
        else "No property that is, or is identical to, the particular property was acquired in the period by the transferor or a person affiliated with it and owned by one of them at the end of the period."
  except where
    | "(a) surplus carve-out" f.surplusExcludedProperty
        => "For the purposes of computing a foreign affiliate's surplus or deficit, the property is excluded property."
        else "The property is not excluded property being considered in computing a foreign affiliate's surplus or deficit."
    | "(a) dispositions in 54 \"superficial loss\" (c) to (g)"
        (paraC f.disposition || paraD f.disposition || paraE f.disposition || paraF f.disposition || paraG f.disposition)
        => "The disposition is one described in paragraphs (c) to (g) of the definition \"superficial loss\" in section 54."
        else "The disposition is not one described in paragraphs (c) to (g) of the definition \"superficial loss\" in section 54."

/-! ## Subsection 40(3.4) -/

/-- (3.4)(a): the transferor's loss is deemed nil. -/
def suspended (f : Facts) : Bool := applies.holds f && isLoss f.disposition

/-- The suspended loss (determined without reference to 40(2)(g) and 40(3.4)). -/
def suspendedLoss (f : Facts) : Cents := if suspended f then lossAmount f.disposition else 0

private def earliest : List Date → Option Date
  | [] => none
  | d :: ds => match earliest ds with
    | none => some d
    | some e => some (if e.before d then e else d)

/-- (3.4)(b): the first of the times in (i) to (v), if any has occurred. The loss is deemed to
be a loss of the transferor immediately before then. -/
def releaseDate (f : Facts) : Option Date :=
  let r := f.release
  let afterDisposition (o : Option Date) := o.filter (f.disposition.date.toDays ≤ ·.toDays)
  earliest ([r.thirtyDaysWithout, r.deemedDisposition, r.lossRestrictionEvent, r.section50,
    if f.transferor == .corporation then r.windingUp else none].filterMap afterDisposition)

/-- Which of (i) to (v) the release date is. -/
def releaseReason (f : Facts) : String :=
  let r := f.release
  match releaseDate f with
  | none => "none of the times in 40(3.4)(b)(i) to (v) has occurred"
  | some d =>
    if r.thirtyDaysWithout == some d then "a 30-day period begins throughout which neither the transferor nor a person affiliated with it owns the substituted property (40(3.4)(b)(i))"
    else if r.deemedDisposition == some d then "the property would be deemed disposed of by section 128.1 or subsection 149(10) (40(3.4)(b)(ii))"
    else if r.lossRestrictionEvent == some d then "the transferor is subject to a loss restriction event (40(3.4)(b)(iii))"
    else if r.section50 == some d then "the transferor or an affiliated person is deemed by section 50 to have disposed of the property (40(3.4)(b)(iv))"
    else "the transferor's winding-up begins (40(3.4)(b)(v))"

def explainSuspension (f : Facts) : Finding :=
  let e := applies.explain f
  if !suspended f then
    ⟨false, e.steps ++ (if applies.holds f then
      [⟨"The transferor has no loss from the disposition, so nothing is suspended.", "ITA 40(3.4)"⟩] else []), e.reliesOn⟩
  else
    let release := match releaseDate f with
      | some d => ⟨s!"The {formatCents (suspendedLoss f)} loss is deemed to be a loss of the transferor from a disposition " ++
          s!"of the property immediately before {d}, when {releaseReason f}.", "ITA 40(3.4)(b)"⟩
      | none => ⟨s!"The {formatCents (suspendedLoss f)} loss stays suspended: {releaseReason f}.", "ITA 40(3.4)(b)"⟩
    ⟨true, e.steps ++ [⟨s!"So the transferor's loss of {formatCents (lossAmount f.disposition)} from the disposition is " ++
        "deemed to be nil.", "ITA 40(3.4)(a)"⟩, release], e.reliesOn⟩

theorem explainSuspension_sound (f : Facts) : (explainSuspension f).conclusion = suspended f := by
  unfold explainSuspension
  cases h : suspended f <;> simp

/-- Subsection 40(3.4): the loss is nil now, and suspended. -/
def rule : Rule Facts where
  name := "subsection 40(3.4)"
  citation := "ITA 40(3.4)"
  holds := suspended
  explain := explainSuspension
  sound := explainSuspension_sound

/-! ## Facts about suspended losses -/

/-- An individual's loss is never suspended under 40(3.4): the superficial loss rule deals with
individuals. -/
theorem not_individual (f : Facts) (h : f.transferor = .individual) : suspended f = false := by
  simp [suspended, applies, h]

/-- A disposition described in paragraphs (c) to (g) of the superficial loss definition (for
example, a deemed disposition on emigration, section 128.1) is never suspended. -/
theorem not_of_excepted (f : Facts)
    (h : (paraC f.disposition || paraD f.disposition || paraE f.disposition || paraF f.disposition ||
      paraG f.disposition) = true) : suspended f = false := by
  have ha : applies.holds f = false := by
    simp only [applies, Rule.statute_holds, Rule.clause_holds, List.all_cons, List.all_nil, List.any_cons,
      List.any_nil, h, Bool.or_false, Bool.or_true, Bool.not_true, Bool.and_false]
  simp [suspended, ha]

private theorem earliest_mem : ∀ (l : List Date) (d : Date), earliest l = some d → d ∈ l
  | [], d, h => by simp [earliest] at h
  | x :: xs, d, h => by
    unfold earliest at h
    cases he : earliest xs with
    | none =>
      rw [he] at h
      simp only [Option.some.injEq] at h
      simp [h]
    | some e =>
      rw [he] at h
      simp only [Option.some.injEq] at h
      split at h
      · exact List.mem_cons_of_mem _ (h ▸ earliest_mem xs e he)
      · simp [h]

/-- The release, if any, is on or after the disposition. -/
theorem releaseDate_after (f : Facts) (d : Date) (h : releaseDate f = some d) :
    f.disposition.date.toDays ≤ d.toDays := by
  unfold releaseDate at h
  have hm := earliest_mem _ _ h
  rw [List.mem_filterMap] at hm
  obtain ⟨o, _, ho⟩ := hm
  cases o with
  | none => simp at ho
  | some y =>
    simp only [Option.filter] at ho
    split at ho
    · rename_i hy
      simp only [Option.some.injEq] at ho
      subst ho
      simpa using hy
    · simp at ho

/-! ## Paragraph (h) of the superficial loss definition -/

/-- The disposition, for the superficial loss definition, with paragraph (h)'s "a disposition to
which subsection 40(3.4) applies" decided by this encoding rather than given. -/
def withSuspension (f : Facts) : Disposition :=
  { f.disposition with applies40_3_4 := f.disposition.applies40_3_4 || applies.holds f }

/-- Where 40(3.4) applies, the loss is not also a superficial loss: paragraph (h) of that
definition defers to 40(3.4). -/
theorem not_superficial_of_applies (f : Facts) (as : List SuperficialLoss.Acquisition) (h : applies.holds f = true) :
    superficialLoss ⟨withSuspension f, as⟩ = false := by
  simp [superficialLoss, excepted, paraH, withSuspension, h]

/-! ## A timeline -/

/-- The disposition, the period, every acquisition, and the release of the suspended loss, as a
Mermaid Gantt chart. -/
def timeline (f : Facts) : String :=
  let d := f.disposition
  let start := d.date.subDays 30
  let stop := d.date.addDays 30
  let task (s : String) := (s.replace ":" " -").replace ";" ","
  let who (a : Acquisition) : String :=
    match a.acquirer with
    | .taxpayer => "the transferor"
    | .affiliated w => s!"{w} (affiliated)"
    | .notAffiliated w => s!"{w} (not affiliated)"
    | .judged w js b => s!"{w} ({if b then "affiliated" else "not affiliated"}, judgment calls {", ".intercalate js})"
  let acqs := f.acquisitions.zipIdx.map fun (a, i) =>
    s!"    {task s!"{a.date} {who a} acquires {a.description}"} :{if qualifies d a then "milestone, crit" else "milestone"}, a{i}, {a.date}, 0d"
  let susp := match releaseDate f with
    | some r => if suspended f then
        [ "    section Suspended loss",
          s!"    {task s!"{formatCents (suspendedLoss f)} suspended"} :active, susp, {d.date}, {r.toDays - d.date.toDays}d",
          s!"    {task s!"{r} released ({(releaseReason f).takeWhile (· != '(')})"} :milestone, rel, {r}, 0d"]
      else []
    | none => if suspended f then
        [ "    section Suspended loss", s!"    {task s!"{formatCents (suspendedLoss f)} suspended, not yet released"} :active, susp, {d.date}, 120d"]
      else []
  "\n".intercalate ([
    "gantt",
    s!"    title Suspended loss for the disposition on {d.date}",
    "    dateFormat YYYY-MM-DD",
    "    axisFormat %b %d",
    "    section Period 40(3.3)(b)",
    s!"    {task s!"{start} to {stop}"} :active, period, {start}, 61d",
    "    section Disposition",
    s!"    {task s!"{d.date} disposition of {d.description}"} :milestone, disp, {d.date}, 0d",
    "    section Acquisitions"] ++ acqs ++ susp)

end Canteen.ITA.SuspendedLoss

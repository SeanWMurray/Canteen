import Canteen.Core.Argument
import Canteen.Core.Date
import Canteen.Core.Money

/-!
# Section 54, "superficial loss"

*Income Tax Act*, R.S.C. 1985, c. 1 (5th Supp.), section 54, definition of
"superficial loss". The text encoded here is from the Justice Canada consolidation
current to 2026-10-29 (last amended 2026-06-18); a verbatim copy is in
`statute/ITA-54-superficial-loss.txt`.

> **superficial loss** of a taxpayer means the taxpayer's loss from the disposition
> of a particular property where
>
> (a) during the period that begins 30 days before and ends 30 days after the
> disposition, the taxpayer or a person affiliated with the taxpayer acquires a
> property (in this definition referred to as the "substituted property") that is,
> or is identical to, the particular property, and
>
> (b) at the end of that period, the taxpayer or a person affiliated with the
> taxpayer owns or had a right to acquire the substituted property,
>
> except where the disposition was (c) … (h) …, and, for the purpose of this
> definition, (i) … and (j) ….

One Lean definition per paragraph, labelled with its paragraph (design §6, "Mirror
the statute"). Inputs that other provisions decide (affiliation under section 251.1,
a loss restriction event under section 251.2, whether paragraph 40(2)(e.1) or
subsection 40(3.4) or 69(5) applies) are taken as facts until those provisions are
encoded. Whether a property is *identical* to another is a judgment call.

Interpretation choices for review are listed in `docs/review/superficial-loss.md`.
-/

namespace Canteen.ITA.SuperficialLoss

/-! ## Facts -/

/-- The provisions listed in paragraph (c), plus `other` for any deeming provision
that paragraph (c) does not list. -/
inductive DeemingProvision where
  | s45_1
  | s48_pre1993
  | s50
  | s70
  | s104_4
  | s128_1
  | s132_2_3_a
  | s132_2_3_c
  | s138_11_3
  | s138_2_4
  | s142_5_2
  | s142_6
  | s144_4_1
  | s144_4_2
  | s149_10
  /-- A deeming provision not listed in paragraph (c), e.g. `"subsection 7(1.31)"`. -/
  | other (citation : String)
  deriving Repr, DecidableEq

namespace DeemingProvision

/-- How the Act refers to the provision. -/
def cite : DeemingProvision → String
  | .s45_1 => "subsection 45(1)"
  | .s48_pre1993 => "section 48 as it read in its application before 1993"
  | .s50 => "section 50"
  | .s70 => "section 70"
  | .s104_4 => "subsection 104(4)"
  | .s128_1 => "section 128.1"
  | .s132_2_3_a => "paragraph 132.2(3)(a)"
  | .s132_2_3_c => "paragraph 132.2(3)(c)"
  | .s138_11_3 => "subsection 138(11.3)"
  | .s138_2_4 => "subsection 138.2(4)"
  | .s142_5_2 => "subsection 142.5(2)"
  | .s142_6 => "section 142.6"
  | .s144_4_1 => "subsection 144(4.1)"
  | .s144_4_2 => "subsection 144(4.2)"
  | .s149_10 => "subsection 149(10)"
  | .other c => c

/-- Listed in paragraph (c). -/
def listedInC : DeemingProvision → Bool
  | .other _ => false
  | _ => true

end DeemingProvision

/-- The disposition of the particular property. -/
structure Disposition where
  /-- The particular property, e.g. `"100 common shares of ABC Ltd."`. -/
  description : String
  date : Date
  proceeds : Cents
  adjustedCostBase : Cents
  outlaysAndExpenses : Cents
  /-- (c) The provision, if any, that deemed the disposition to have been made. -/
  deemedBy : Option DeemingProvision := none
  /-- (d) The disposition was the expiry of an option. -/
  optionExpiry : Bool := false
  /-- (e) Paragraph 40(2)(e.1) applies to the disposition (an input: not yet encoded). -/
  applies40_2_e1 : Bool := false
  /-- (f) The date the taxpayer was subject to a loss restriction event (section 251.2),
  if it was, on or after the disposition. -/
  lossRestrictionEvent : Option Date := none
  /-- (g) The date the taxpayer became or ceased to be exempt from tax under Part I on
  its taxable income, if it did, on or after the disposition. -/
  exemptStatusChange : Option Date := none
  /-- (h) Subsection 40(3.4) applies to the disposition (an input: not yet encoded). -/
  applies40_3_4 : Bool := false
  /-- (h) Subsection 69(5) applies to the disposition (an input: not yet encoded). -/
  applies69_5 : Bool := false
  deriving Repr, DecidableEq

/-- Who acquired a property. Affiliation is as determined under section 251.1
(`Affiliation.acquirer` decides it under paragraph 251.1(1)(a)). -/
inductive Acquirer where
  | taxpayer
  /-- A person affiliated with the taxpayer, e.g. `"the taxpayer's spouse"`. -/
  | affiliated (who : String)
  /-- A person not affiliated with the taxpayer. -/
  | notAffiliated (who : String)
  /-- A person whose affiliation with the taxpayer rests on judgment calls; `affiliated` is
  the answer on this branch. -/
  | judged (who : String) (judgments : List String) (affiliated : Bool)
  deriving Repr, DecidableEq

/-- How an acquired property relates to the particular property. -/
inductive Identity where
  /-- It is the particular property itself. -/
  | same
  /-- Whether it is identical to the particular property is a judgment call;
  `assumed` is the answer on this branch. -/
  | identical (judgment : String) (assumed : Bool)
  /-- A right to acquire the particular property. `securityOnly`: the right is, as
  security only, derived from a mortgage, hypothec, agreement for sale or similar
  obligation. Paragraph (i). -/
  | rightToAcquire (securityOnly : Bool)
  /-- A share of the capital stock of a SIFT wind-up corporation in respect of a SIFT
  wind-up entity, where the particular property is equity in that entity. Paragraph (j). -/
  | siftWindUpShare
  /-- Neither the particular property nor identical to it, and no deeming rule applies. -/
  | different
  deriving Repr, DecidableEq

/-- A property acquired by the taxpayer or someone else. -/
structure Acquisition where
  description : String
  date : Date
  acquirer : Acquirer
  identity : Identity
  /-- At the end of the period, the taxpayer or a person affiliated with the taxpayer
  owns or had a right to acquire this property. -/
  heldAtEndOfPeriod : Bool
  deriving Repr, DecidableEq

/-- Everything the definition needs: the disposition, and every property acquired by
the taxpayer or by persons who may be affiliated with the taxpayer around that time. -/
structure Facts where
  disposition : Disposition
  acquisitions : List Acquisition
  deriving Repr, DecidableEq

/-! ## The definition, paragraph by paragraph -/

/-- Opening words: "the taxpayer's loss from the disposition". The adjusted cost base
plus outlays and expenses exceeds the proceeds (paragraph 40(1)(b)). -/
def isLoss (d : Disposition) : Bool :=
  d.proceeds < d.adjustedCostBase + d.outlaysAndExpenses

/-- The amount of the loss (paragraph 40(1)(b)); zero if there is none. -/
def lossAmount (d : Disposition) : Cents :=
  d.adjustedCostBase + d.outlaysAndExpenses - d.proceeds

/-- (a) "the period that begins 30 days before and ends 30 days after the disposition",
both ends included. -/
def inPeriod (d : Disposition) (a : Acquisition) : Bool :=
  d.date.withinDaysAround a.date 30

/-- (a), (b) "the taxpayer or a person affiliated with the taxpayer". -/
def Acquirer.isTaxpayerOrAffiliated : Acquirer → Bool
  | .taxpayer => true
  | .affiliated _ => true
  | .notAffiliated _ => false
  | .judged _ _ b => b

/-- The judgment calls an acquirer's affiliation rests on: none for a fact. -/
def Acquirer.judgments : Acquirer → List String
  | .judged _ js _ => js
  | _ => []

/-- (j) applies only to a share "acquired before 2013". -/
def acquiredBefore2013 (a : Acquisition) : Bool :=
  a.date.before ⟨2013, 1, 1⟩

/-- (a) "a property … that is, or is identical to, the particular property", with the
deeming rules in paragraphs (i) and (j). -/
def isOrIsIdentical (a : Acquisition) : Bool :=
  match a.identity with
  | .same => true
  | .identical _ assumed => assumed
  | .rightToAcquire securityOnly => !securityOnly   -- (i)
  | .siftWindUpShare => acquiredBefore2013 a         -- (j)
  | .different => false

/-- Paragraph (a). -/
def paraA (d : Disposition) (a : Acquisition) : Bool :=
  inPeriod d a && a.acquirer.isTaxpayerOrAffiliated && isOrIsIdentical a

/-- Paragraph (b). -/
def paraB (a : Acquisition) : Bool :=
  a.heldAtEndOfPeriod

/-- The acquisition is of a substituted property meeting both (a) and (b). -/
def qualifies (d : Disposition) (a : Acquisition) : Bool :=
  paraA d a && paraB a

/-- (c) A disposition deemed to have been made by a listed provision. -/
def paraC (d : Disposition) : Bool :=
  match d.deemedBy with
  | some p => p.listedInC
  | none => false

/-- (d) The expiry of an option. -/
def paraD (d : Disposition) : Bool :=
  d.optionExpiry

/-- (e) A disposition to which paragraph 40(2)(e.1) applies. -/
def paraE (d : Disposition) : Bool :=
  d.applies40_2_e1

/-- (f) A disposition by a taxpayer that was subject to a loss restriction event within
30 days after the disposition. -/
def paraF (d : Disposition) : Bool :=
  match d.lossRestrictionEvent with
  | some e => d.date.withinDaysAfter e 30
  | none => false

/-- (g) A disposition by a person that, within 30 days after the disposition, became or
ceased to be exempt from tax under this Part on its taxable income. -/
def paraG (d : Disposition) : Bool :=
  match d.exemptStatusChange with
  | some e => d.date.withinDaysAfter e 30
  | none => false

/-- (h) A disposition to which subsection 40(3.4) or 69(5) applies. -/
def paraH (d : Disposition) : Bool :=
  d.applies40_3_4 || d.applies69_5

/-- "except where the disposition was" (c), (d), (e), (f), (g) or (h). -/
def excepted (d : Disposition) : Bool :=
  paraC d || paraD d || paraE d || paraF d || paraG d || paraH d

/-- **Superficial loss.** The taxpayer's loss from the disposition is a superficial loss:
there is a loss, some acquired property meets paragraphs (a) and (b), and the
disposition is not excepted by paragraphs (c) to (h). -/
def superficialLoss (f : Facts) : Bool :=
  isLoss f.disposition && f.acquisitions.any (qualifies f.disposition) && !excepted f.disposition

/-! ## The explanation -/

def citeDef : String := "ITA 54 \"superficial loss\""
def cite (para : String) : String := s!"{citeDef} {para}"

/-- End a sentence with the text, without doubling a final period (e.g. "Ltd."). -/
def sentenceEnd (text : String) : String :=
  if text.endsWith "." then text else text ++ "."

def periodText (d : Disposition) : String :=
  s!"the period from {d.date.subDays 30} to {d.date.addDays 30}"

def lossStep (d : Disposition) : Step :=
  let cost := formatCents (d.adjustedCostBase + d.outlaysAndExpenses)
  if isLoss d then
    ⟨s!"The taxpayer disposed of {d.description} on {d.date} for proceeds of {formatCents d.proceeds}. " ++
      s!"The adjusted cost base plus outlays and expenses was {cost}, so the taxpayer's loss from the disposition is {formatCents (lossAmount d)}.",
      "ITA 40(1)(b)"⟩
  else
    ⟨s!"The taxpayer disposed of {d.description} on {d.date} for proceeds of {formatCents d.proceeds}, " ++
      s!"which are not less than the adjusted cost base plus outlays and expenses of {cost}. " ++
      "There is no loss, so there is no superficial loss.",
      s!"ITA 40(1); {citeDef}"⟩

private def dateText : Option Date → String
  | some e => toString e
  | none => ""

private def deemedText (d : Disposition) : String :=
  match d.deemedBy with
  | some p => p.cite
  | none => ""

/-- The first exception in (c) to (h) that applies, as a step. -/
def exceptionStep? (d : Disposition) : Option Step :=
  let notSL := "so the loss is not a superficial loss."
  if paraC d then
    some ⟨s!"The disposition was deemed to have been made by {deemedText d}, {notSL}", cite "(c)"⟩
  else if paraD d then
    some ⟨s!"The disposition was the expiry of an option, {notSL}", cite "(d)"⟩
  else if paraE d then
    some ⟨s!"Paragraph 40(2)(e.1) applies to the disposition, {notSL}", cite "(e)"⟩
  else if paraF d then
    some ⟨s!"The taxpayer was subject to a loss restriction event on {dateText d.lossRestrictionEvent}, " ++
      s!"within 30 days after the disposition, {notSL}", cite "(f)"⟩
  else if paraG d then
    some ⟨s!"On {dateText d.exemptStatusChange}, within 30 days after the disposition, the taxpayer became or " ++
      s!"ceased to be exempt from tax under Part I on its taxable income, {notSL}", cite "(g)"⟩
  else if d.applies40_3_4 then
    some ⟨s!"Subsection 40(3.4) applies to the disposition, {notSL}", cite "(h)"⟩
  else if d.applies69_5 then
    some ⟨s!"Subsection 69(5) applies to the disposition, {notSL}", cite "(h)"⟩
  else
    none

def Acquirer.phrase : Acquirer → String
  | .taxpayer => "the taxpayer"
  | .affiliated who => s!"{who}, a person affiliated with the taxpayer,"
  | .notAffiliated who => s!"{who}, a person not affiliated with the taxpayer,"
  | .judged who js true => s!"{who}, a person affiliated with the taxpayer (judgment calls: {", ".intercalate js}),"
  | .judged who js false => s!"{who}, a person not affiliated with the taxpayer (judgment calls: {", ".intercalate js}),"

/-- The judgment call an acquisition's identity relies on, if any. -/
def Identity.judgment? : Identity → Option String
  | .identical j _ => some j
  | _ => none

/-- The steps showing an acquisition meets (a) and (b), including any deeming rule. -/
def qualifyingSteps (d : Disposition) (a : Acquisition) : List Step :=
  let acquired := sentenceEnd s!"On {a.date}, within {periodText d}, {a.acquirer.phrase} acquired {a.description}"
  let identity : List Step :=
    match a.identity with
    | .same => [⟨s!"{acquired} That property is the particular property.", cite "(a)"⟩]
    | .identical j _ =>
      [⟨s!"{acquired} That property is identical to the particular property (judgment call {j}).", cite "(a)"⟩]
    | .rightToAcquire _ =>
      [⟨s!"{acquired} That property is a right to acquire the particular property.", cite "(a)"⟩,
       ⟨"A right to acquire a property (other than a right, as security only, derived from a mortgage, " ++
          "hypothec, agreement for sale or similar obligation) is deemed to be a property that is identical " ++
          "to the property.", cite "(i)"⟩]
    | .siftWindUpShare =>
      [⟨s!"{acquired} That property is a share of the capital stock of a SIFT wind-up corporation in " ++
          "respect of the SIFT wind-up entity whose equity is the particular property.", cite "(a)"⟩,
       ⟨"The share was acquired before 2013, so it is deemed to be a property that is identical to equity " ++
          "in the SIFT wind-up entity.", cite "(j)"⟩]
    | .different => [⟨acquired, cite "(a)"⟩]
  identity ++
    [⟨s!"At the end of that period, on {d.date.addDays 30}, the taxpayer or a person affiliated with the " ++
        "taxpayer owned or had a right to acquire that property.", cite "(b)"⟩]

/-- Why an acquisition does not meet (a) and (b). Factual reasons are given before
judgment calls on affiliation and identity (design principle 3). -/
def failStep (d : Disposition) (a : Acquisition) : Step :=
  let prop := s!"The property acquired on {a.date} ({a.description})"
  let identityFailsOnFacts := !isOrIsIdentical a && a.identity.judgment?.isNone
  if !inPeriod d a then
    ⟨s!"{prop} was acquired outside {periodText d}, so it does not meet paragraph (a).", cite "(a)"⟩
  else if !a.acquirer.isTaxpayerOrAffiliated && a.acquirer.judgments.isEmpty then
    ⟨s!"{prop} was acquired by {a.acquirer.phrase} so it does not meet paragraph (a).", cite "(a)"⟩
  else if !paraB a then
    ⟨s!"At the end of the period, on {d.date.addDays 30}, neither the taxpayer nor a person affiliated with " ++
      s!"the taxpayer owned or had a right to acquire the property acquired on {a.date} ({a.description}), " ++
      "so it does not meet paragraph (b).", cite "(b)"⟩
  else if identityFailsOnFacts then
    match a.identity with
    | .rightToAcquire _ =>
      ⟨s!"{prop} is a right, as security only, derived from a mortgage, hypothec, agreement for sale or " ++
        "similar obligation, so it is not deemed to be identical to the particular property and does not " ++
        "meet paragraph (a).", cite "(i)"⟩
    | .siftWindUpShare =>
      ⟨s!"{prop} is a share of a SIFT wind-up corporation acquired after 2012, so it is not deemed to be " ++
        "identical to the particular property and does not meet paragraph (a).", cite "(j)"⟩
    | _ =>
      ⟨s!"{prop} is neither the particular property nor identical to it, so it does not meet paragraph (a).",
        cite "(a)"⟩
  else if !a.acquirer.isTaxpayerOrAffiliated then
    ⟨s!"{prop} was acquired by {a.acquirer.phrase} so it does not meet paragraph (a).", cite "(a)"⟩
  else
    match a.identity with
    | .identical j _ =>
      ⟨s!"{prop} is not identical to the particular property (judgment call {j}), so it does not meet " ++
        "paragraph (a).", cite "(a)"⟩
    | _ =>
      ⟨s!"{prop} does not meet paragraph (a).", cite "(a)"⟩

/-- The judgment calls a failed acquisition's failure rests on: those answered "no" when
every factual condition is met. -/
def failJudgments (d : Disposition) (a : Acquisition) : List String :=
  if inPeriod d a && (a.acquirer.isTaxpayerOrAffiliated || !a.acquirer.judgments.isEmpty) && paraB a &&
      (isOrIsIdentical a || a.identity.judgment?.isSome) then
    (if a.acquirer.isTaxpayerOrAffiliated then [] else a.acquirer.judgments) ++
      (if isOrIsIdentical a then [] else a.identity.judgment?.toList)
  else []

/-- Qualifies without relying on a judgment call. -/
def qualifiesOnFacts (d : Disposition) (a : Acquisition) : Bool :=
  qualifies d a && a.identity.judgment?.isNone && a.acquirer.judgments.isEmpty

def positive (d : Disposition) (a : Acquisition) : Finding :=
  ⟨true,
    [lossStep d] ++ qualifyingSteps d a ++
      [⟨s!"The disposition is not one described in paragraphs (c) to (h), so the taxpayer's loss of " ++
          s!"{formatCents (lossAmount d)} is a superficial loss.", citeDef⟩],
    mergeIds a.acquirer.judgments a.identity.judgment?.toList⟩

def negative (d : Disposition) (as : List Acquisition) : Finding :=
  let reasons :=
    if as.isEmpty then
      [⟨s!"Neither the taxpayer nor a person affiliated with the taxpayer acquired the particular property " ++
          s!"or an identical property in {periodText d}.", cite "(a)"⟩]
    else as.map (failStep d)
  ⟨false,
    [lossStep d] ++ reasons ++
      [⟨"No property meets both paragraphs (a) and (b), so the loss is not a superficial loss.", citeDef⟩],
    as.foldl (fun ids a => mergeIds ids (failJudgments d a)) []⟩

/-- The definition, with reasons: no loss; else an exception; else a qualifying
acquisition (one resting on facts first); else why none qualifies. -/
def explain (f : Facts) : Finding :=
  let d := f.disposition
  if !isLoss d then ⟨false, [lossStep d], []⟩
  else
    match exceptionStep? d with
    | some s => ⟨false, [lossStep d, s], []⟩
    | none =>
      match f.acquisitions.find? (qualifiesOnFacts d) with
      | some a => positive d a
      | none =>
        match f.acquisitions.find? (qualifies d) with
        | some a => positive d a
        | none => negative d f.acquisitions

/-! ## Soundness -/

theorem exceptionStep?_isSome (d : Disposition) : (exceptionStep? d).isSome = excepted d := by
  unfold exceptionStep? excepted paraH
  repeat' split
  all_goals simp_all

theorem explain_sound (f : Facts) : (explain f).conclusion = superficialLoss f := by
  have he := exceptionStep?_isSome f.disposition
  unfold explain superficialLoss
  cases hl : isLoss f.disposition
  · simp [hl]
  · cases hs : exceptionStep? f.disposition with
    | some s =>
      simp only [hs, Option.isSome_some] at he
      simp [hl, hs, ← he]
    | none =>
      simp only [hs, Option.isSome_none] at he
      simp only [hl, hs, ← he, Bool.not_true, Bool.false_eq_true, ↓reduceIte, Bool.not_false,
        Bool.and_true, Bool.true_and]
      cases h1 : f.acquisitions.find? (qualifiesOnFacts f.disposition) with
      | some a =>
        have hq := List.find?_some h1
        have hm := List.mem_of_find?_eq_some h1
        simp only [qualifiesOnFacts, Bool.and_eq_true] at hq
        simp only [positive]
        exact (List.any_eq_true.mpr ⟨a, hm, hq.1.1⟩).symm
      | none =>
        cases h2 : f.acquisitions.find? (qualifies f.disposition) with
        | some a =>
          have hq := List.find?_some h2
          have hm := List.mem_of_find?_eq_some h2
          simp only [positive]
          exact (List.any_eq_true.mpr ⟨a, hm, hq⟩).symm
        | none =>
          simp only [negative]
          rw [List.find?_eq_none] at h2
          symm
          rw [List.any_eq_false]
          intro a ha
          simpa using h2 a ha

/-- Section 54, "superficial loss", with its explanation proven sound. -/
def rule : Rule Facts where
  name := "the superficial loss rule"
  citation := citeDef
  holds := superficialLoss
  explain := explain
  sound := explain_sound

end Canteen.ITA.SuperficialLoss

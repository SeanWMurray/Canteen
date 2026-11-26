import Canteen.ITA.S251.RelatedPersons

/-!
# Amalgamations: subsections 251.1(2), 251(3.1) and 251(3.2)

*Income Tax Act*, as consolidated to 2026-10-29 (verbatim in `statute/ITA-251-1.txt` and
`statute/ITA-251.txt`):

> **251.1(2)** Where at any time 2 or more corporations (in this subsection referred to as the
> "predecessors") amalgamate or merge to form a new corporation, the new corporation and any
> predecessor are deemed to have been affiliated with each other where they would have been
> affiliated with each other immediately before that time if (a) the new corporation had
> existed immediately before that time; and (b) the persons who were the shareholders of the
> new corporation immediately after that time had been the shareholders of the new corporation
> immediately before that time.
>
> **251(3.1)** … the new corporation … and any predecessor corporation would have been related
> immediately before the amalgamation or merger if the new corporation were in existence at
> that time, and if the persons who were the shareholders of the new corporation immediately
> after … were the shareholders of the new corporation at that time, … shall be deemed to have
> been related persons.
>
> **251(3.2)** Where there has been an amalgamation or merger of 2 or more corporations each of
> which was related (otherwise than because of a right referred to in paragraph 251(5)(b)) to
> each other immediately before …, the new corporation … and each of the predecessor
> corporations is deemed to have been related to each other.

251.1(2) and 251(3.1) ask a counterfactual question. It is answered by building the
**hypothetical world**: the world immediately before the amalgamation, with the new corporation
added and controlled as it is immediately after (by the shareholders it then has). The
affiliation and related-persons engines then run on that world unchanged.
-/

namespace Canteen.ITA.Amalgamation

open AffiliatedPersons

/-- An amalgamation or merger. -/
structure Facts where
  /-- The world immediately before the amalgamation. -/
  before : World
  /-- The predecessor corporations. -/
  predecessors : List Nat
  /-- The new corporation. -/
  newCorp : Person
  /-- Who controls the new corporation immediately after, by its shareholders then. Each is a
  control of `newCorp.id`. -/
  controlAfter : List Control
  /-- For 251(3.2): the world immediately before, leaving out any control that exists only
  because of a right referred to in paragraph 251(5)(b). Where not given, `before`. -/
  beforeWithoutRights : Option World := none
  deriving Inhabited

/-- The hypothetical world of 251.1(2)(a), (b) and 251(3.1): the new corporation existing
immediately before, with the shareholders it has immediately after. -/
def hypothetical (f : Facts) : World :=
  { f.before with persons := f.before.persons ++ [f.newCorp],
                  controls := f.before.controls ++ f.controlAfter.map ({ · with corporation := f.newCorp.id }) }

/-- A predecessor of an amalgamation of two or more corporations. -/
def isPredecessor (f : Facts) (p : Nat) : Bool :=
  f.predecessors.length ≥ 2 && f.predecessors.contains p && f.before.isKind .corporation p

/-- The new corporation and a predecessor of the amalgamation. -/
structure Query where
  facts : Facts
  predecessor : Nat
  deriving Inhabited

def supposition (f : Facts) : Step :=
  let w := f.before
  let preds := f.predecessors.map w.name
  let names := if preds.length ≤ 1 then ", ".intercalate preds
    else ", ".intercalate preds.dropLast ++ " and " ++ preds.getLast!
  ⟨s!"{names} amalgamated to form {f.newCorp.name}. Suppose {f.newCorp.name} had existed immediately before the " ++
    s!"amalgamation, with the shareholders it had immediately after it.", "ITA 251.1(2)(a), (b); 251(3.1)"⟩

/-! ## 251.1(2): deemed affiliated -/

def affiliatedHolds (q : Query) : Bool :=
  isPredecessor q.facts q.predecessor &&
    affiliated ⟨hypothetical q.facts, q.facts.newCorp.id, q.predecessor⟩

def affiliatedExplain (q : Query) : Finding :=
  let f := q.facts
  let inner := AffiliatedPersons.explain ⟨hypothetical f, f.newCorp.id, q.predecessor⟩
  let c := affiliatedHolds q
  let steps :=
    if !isPredecessor f q.predecessor then
      [⟨s!"{f.before.name q.predecessor} is not a predecessor corporation of an amalgamation of two or more " ++
        "corporations.", "ITA 251.1(2)"⟩]
    else
      [supposition f] ++ inner.steps ++
        [if c then ⟨s!"So {f.newCorp.name} and {f.before.name q.predecessor} are deemed to have been affiliated with " ++
            "each other.", "ITA 251.1(2)"⟩
         else ⟨s!"So subsection 251.1(2) does not deem {f.newCorp.name} and {f.before.name q.predecessor} to have been " ++
            "affiliated.", "ITA 251.1(2)"⟩]
  ⟨c, steps, if isPredecessor f q.predecessor then inner.reliesOn else []⟩

theorem affiliatedExplain_sound (q : Query) : (affiliatedExplain q).conclusion = affiliatedHolds q := rfl

/-- Subsection 251.1(2). -/
def affiliatedRule : Rule Query where
  name := "subsection 251.1(2)"
  citation := "ITA 251.1(2)"
  holds := affiliatedHolds
  explain := affiliatedExplain
  sound := affiliatedExplain_sound

/-! ## 251(3.1) and (3.2): deemed related -/

/-- 251(3.1): related in the hypothetical world. -/
def relatedHypothetical (q : Query) : Bool :=
  isPredecessor q.facts q.predecessor &&
    RelatedPersons.related ⟨hypothetical q.facts, q.facts.newCorp.id, q.predecessor⟩

/-- 251(3.2): each predecessor related to each other immediately before, otherwise than because
of a 251(5)(b) right. -/
def predecessorsRelated (f : Facts) : Bool :=
  let w := f.beforeWithoutRights.getD f.before
  f.predecessors.length ≥ 2 &&
    f.predecessors.all fun p => f.predecessors.all fun q => p == q || RelatedPersons.related ⟨w, p, q⟩

def relatedHolds (q : Query) : Bool :=
  relatedHypothetical q || (isPredecessor q.facts q.predecessor && predecessorsRelated q.facts)

def relatedExplanation (q : Query) : List Step × List String :=
  let f := q.facts
  let w := f.beforeWithoutRights.getD f.before
  let name := f.before.name q.predecessor
  let pairs := (f.predecessors.flatMap fun p => (f.predecessors.filter (· > p)).map (p, ·))
  if !isPredecessor f q.predecessor then
    ([⟨s!"{name} is not a predecessor corporation of an amalgamation of two or more corporations.", "ITA 251(3.1), (3.2)"⟩], [])
  else if relatedHypothetical q then
    let inner := RelatedPersons.explain ⟨hypothetical f, f.newCorp.id, q.predecessor⟩
    ([supposition f] ++ inner.steps ++
        [⟨s!"So {f.newCorp.name} and {name} are deemed to have been related persons.", "ITA 251(3.1)"⟩], inner.reliesOn)
  else if predecessorsRelated f then
    let chains := pairs.map fun (a, b) => RelatedPersons.explain ⟨w, a, b⟩
    (chains.flatMap (·.steps) ++
        [⟨s!"Each of the predecessor corporations was related to each other immediately before the amalgamation, " ++
            "otherwise than because of a right referred to in paragraph 251(5)(b).", "ITA 251(3.2)"⟩,
         ⟨s!"So {f.newCorp.name} and {name} are deemed to have been related to each other.", "ITA 251(3.2)"⟩],
      chains.foldl (fun ids e => mergeIds ids e.reliesOn) [])
  else
    let inner := RelatedPersons.explain ⟨hypothetical f, f.newCorp.id, q.predecessor⟩
    ([supposition f] ++ inner.steps ++
        [⟨s!"And the predecessor corporations were not each related to each other immediately before the amalgamation " ++
            "(otherwise than because of a right referred to in paragraph 251(5)(b)).", "ITA 251(3.2)"⟩,
         ⟨s!"So neither subsection 251(3.1) nor 251(3.2) deems {f.newCorp.name} and {name} to have been related.",
            "ITA 251(3.1), (3.2)"⟩], inner.reliesOn)

def relatedExplain (q : Query) : Finding :=
  ⟨relatedHolds q, (relatedExplanation q).1, (relatedExplanation q).2⟩

theorem relatedExplain_sound (q : Query) : (relatedExplain q).conclusion = relatedHolds q := rfl

/-- Subsections 251(3.1) and (3.2). -/
def relatedRule : Rule Query where
  name := "subsections 251(3.1) and (3.2)"
  citation := "ITA 251(3.1), (3.2)"
  holds := relatedHolds
  explain := relatedExplain
  sound := relatedExplain_sound

/-! ## Facts about amalgamations -/

/-- Only a predecessor can be deemed affiliated with the new corporation. -/
theorem affiliated_only_predecessors (q : Query) (h : isPredecessor q.facts q.predecessor = false) :
    affiliatedHolds q = false := by
  simp [affiliatedHolds, h]

/-- 251(3.2) needs no supposition: if the predecessors were each related to each other, the
new corporation is deemed related to every predecessor, however it is controlled after. -/
theorem related_of_predecessorsRelated (q : Query) (hp : isPredecessor q.facts q.predecessor = true)
    (h : predecessorsRelated q.facts = true) : relatedHolds q = true := by
  simp [relatedHolds, hp, h]

end Canteen.ITA.Amalgamation

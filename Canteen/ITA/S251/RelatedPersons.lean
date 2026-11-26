import Canteen.ITA.S251_1.AffiliatedPersons

/-!
# Section 251: related persons and arm's length

*Income Tax Act*, subsections 251(1) to (6), as consolidated to 2026-10-29 (verbatim in
`statute/ITA-251.txt`).

* **Related persons (251(2), (3), (4)).** Individuals connected by blood relationship,
  marriage, common-law partnership or adoption (251(6)); a corporation and its controller,
  each member of a related group that controls it, and anyone related to either; two
  corporations in any of the six cases in 251(2)(c); and two corporations related to the same
  corporation (251(3)). Like affiliation, this refers to itself, so it is computed for a whole
  `World` as the smallest relation closed under the paragraphs, with every pair's reasons kept.
* **Control** in 251(2) is control in fact of the votes (de jure): a control given as
  `deFactoOnly` counts for affiliation but not here. Rights under 251(5)(b) and the
  related-group rule in 251(5)(a) are reflected in the controls given.
* **Arm's length (251(1)).** Related persons are deemed not to deal at arm's length (a); so
  are a taxpayer and certain personal trusts (b), taken as a fact; otherwise it is a question
  of fact (c), a judgment call.
-/

namespace Canteen.ITA.RelatedPersons

open AffiliatedPersons

/-- Why two persons are related: the citation, a sentence, and the pairs it relies on. -/
structure Link where
  x : Nat
  y : Nat
  cite : String
  text : String
  parents : List (Nat × Nat) := []
  judgments : List String := []
  deriving Repr, Inhabited

def lk (x y : Nat) (cite text : String) (parents : List (Nat × Nat) := []) (judgments : List String := []) : Link :=
  { x, y, cite, text, parents, judgments }

/-- Related in `D` (in either order). Unlike affiliation, a person is not related to itself,
except as 251(5)(c) provides for shareholders, which `rel?` allows where a rule names one
person in two roles. -/
def rel (D : List Link) (p q : Nat) : Bool :=
  D.any fun d => (d.x == p && d.y == q) || (d.x == q && d.y == p)

/-- Related, or the same person (251(5)(c)). -/
def rel? (D : List Link) (p q : Nat) : Bool := p == q || rel D p q

/-- A related group: each member related to every other (251(4)). -/
def relatedGroup (D : List Link) (g : List Nat) : Bool :=
  g.all fun m => g.all fun n => m == n || rel D m n

def pairsOf (g : List Nat) : List (Nat × Nat) := g.flatMap fun m => (g.filter (· > m)).map (m, ·)

def jnote (js : List String) : String :=
  if js.isEmpty then "" else s!" (judgment call {", ".intercalate js})"

/-- Every pair subsections 251(2) and (3) give, from the pairs found so far. -/
def candidates (w : World) (allowJudged : Bool) (D : List Link) : List Link := Id.run do
  let n := w.name
  let controls := w.controls.filter fun c =>
    c.answer.value && !c.deFactoOnly && (allowJudged || c.answer.judgments.isEmpty) && w.isKind .corporation c.corporation
  let mut out : List Link := []
  -- (2)(a): individuals connected by blood relationship, marriage, common-law partnership or adoption
  for p in w.ids .individual do
    for q in w.ids .individual do
      if p < q && w.connectedPair p q then
        out := out ++ [lk p q "ITA 251(2)(a), (6)" s!"{n p} and {n q} are individuals {w.connectionText p q}."]
  -- (2)(b)
  for c in controls do
    let js := c.answer.judgments
    let described : List (Nat × String × List (Nat × Nat)) :=
      match c.controller with
      | .person p => [(p, "ITA 251(2)(b)(i)", [])]
      | .group g => if relatedGroup D g then g.map fun m => (m, "ITA 251(2)(b)(ii)", pairsOf g) else []
    for (x, cite, ps) in described do
      let how := match c.controller with
        | .person _ => s!"{n c.corporation} is a corporation controlled by one person, {n x}{jnote js}."
        | .group g => s!"{n c.corporation} is a corporation controlled by {describeGroup w g}, a related group of which " ++
            s!"{n x} is a member{jnote js}."
      out := out ++ [lk c.corporation x cite how ps js]
      -- (b)(iii): any person related to x
      for d in D do
        let other := if d.x == x then some d.y else if d.y == x then some d.x else none
        match other with
        | some r =>
          if r != c.corporation then
            out := out ++ [lk c.corporation r "ITA 251(2)(b)(iii)"
              s!"{n r} is related to {n x}, a person described in subparagraph 251(2)(b)(i) or (ii) in respect of {n c.corporation}."
              [(c.corporation, x), (x, r)] js]
        | none => pure ()
  -- (2)(c)
  for c1 in controls do
    for c2 in controls do
      if c1.corporation < c2.corporation then
        let a := c1.corporation
        let b := c2.corporation
        let js := mergeIds c1.answer.judgments c2.answer.judgments
        let both (cite text : String) (ps : List (Nat × Nat)) := lk a b cite (text ++ jnote js ++ ".") ps js
        let found : Option Link :=
          match c1.controller, c2.controller with
          | .person p, .person q =>
            if p == q then some (both "ITA 251(2)(c)(i)" s!"{n a} and {n b} are controlled by the same person, {n p}" [])
            else if rel D p q then
              some (both "ITA 251(2)(c)(ii)" s!"{n a} and {n b} are each controlled by one person, and {n p} is related to {n q}" [(p, q)])
            else none
          | .group g1, .group g2 =>
            if g1.all g2.contains && g2.all g1.contains then
              some (both "ITA 251(2)(c)(i)" s!"{n a} and {n b} are controlled by the same group, {describeGroup w g1}" [])
            else
              let r1 := relatedGroup D g1
              let r2 := relatedGroup D g2
              -- (v): a member of a related group controlling one is related to each member of an unrelated group controlling the other
              let v (gr gu : List Nat) : Option Link :=
                (gr.find? fun m => gu.all (rel? D m ·)).map fun m =>
                  both "ITA 251(2)(c)(v)" (s!"{m |> n}, a member of {describeGroup w gr}, a related group controlling one of " ++
                    s!"{n a} and {n b}, is related to each member of {describeGroup w gu}, an unrelated group controlling the other")
                    ((gu.filter (· != m)).map (m, ·))
              -- (vi): each member of an unrelated group controlling one is related to at least one member of an unrelated group controlling the other
              let vi (g h : List Nat) : Option Link :=
                (eachRelatedWithSome D g h).map fun ps =>
                  both "ITA 251(2)(c)(vi)" (s!"Each member of {describeGroup w g}, an unrelated group controlling one of {n a} and " ++
                    s!"{n b}, is related to at least one member of {describeGroup w h}, an unrelated group controlling the other") ps
              if r1 && !r2 then v g1 g2
              else if r2 && !r1 then v g2 g1
              else if !r1 && !r2 then vi g1 g2 <|> vi g2 g1
              else none
          | .person p, .group g | .group g, .person p =>
            if relatedGroup D g then
              -- (iii): the person is related to any member of a related group controlling the other
              (g.find? (rel? D p ·)).map fun m =>
                both "ITA 251(2)(c)(iii)" (s!"One of {n a} and {n b} is controlled by {n p}, who is related to {n m}, a member " ++
                  s!"of {describeGroup w g}, a related group controlling the other") (if m == p then [] else [(p, m)])
            else if g.all (rel? D p ·) then
              -- (iv): related to each member of an unrelated group controlling the other
              some (both "ITA 251(2)(c)(iv)" (s!"One of {n a} and {n b} is controlled by {n p}, who is related to each member " ++
                s!"of {describeGroup w g}, an unrelated group controlling the other") ((g.filter (· != p)).map (p, ·)))
            else none
        match found with
        | some l => out := out ++ [l]
        | none => pure ()
  -- (3): two corporations related to the same corporation
  for c in w.ids .corporation do
    let relatedCorps := (w.ids .corporation).filter fun k => k != c && rel D c k
    for a in relatedCorps do
      for b in relatedCorps do
        if a < b then
          out := out ++ [lk a b "ITA 251(3)"
            s!"{n a} and {n b} are each related to {n c}, so they are deemed related to each other." [(a, c), (b, c)]]
  return out
where
  eachRelatedWithSome (D : List Link) (g h : List Nat) : Option (List (Nat × Nat)) :=
    g.foldl (fun acc m => acc.bind fun ps =>
      (h.find? (rel? D m ·)).map fun k => if m == k then ps else ps ++ [(m, k)]) (some [])

def step (w : World) (allowJudged : Bool) (D : List Link) : List Link :=
  (candidates w allowJudged D).foldl (fun acc l => if l.x == l.y || rel acc l.x l.y then acc else acc ++ [l]) D

def closeFrom (w : World) (allowJudged : Bool) : Nat → List Link → List Link
  | 0, D => D
  | fuel + 1, D =>
    let D' := step w allowJudged D
    if D'.length == D.length then D else closeFrom w allowJudged fuel D'

/-- The relation: on the facts alone first, then with the judgment calls. -/
def relation (w : World) : List Link :=
  closeFrom w true (fuel w) (closeFrom w false (fuel w) [])

def isClosed (w : World) : Bool := (step w true (relation w)).length == (relation w).length

/-! ## The rule -/

/-- Subsection 251(2): the two persons are related. -/
def related (q : Query) : Bool := rel (relation q.world) q.first q.second

def chain (D : List Link) (p q : Nat) : List Link :=
  let find (a b : Nat) := D.find? fun d => (d.x == a && d.y == b) || (d.x == b && d.y == a)
  let rec go : Nat → List (Nat × Nat) → List Link → List Link
    | 0, _, acc => acc
    | _, [], acc => acc
    | fuel + 1, (a, b) :: rest, acc =>
      match find a b with
      | none => go fuel rest acc
      | some d =>
        if acc.any (fun e => e.x == d.x && e.y == d.y) then go fuel rest acc
        else
          let before := go fuel d.parents acc
          go fuel rest (if before.any (fun e => e.x == d.x && e.y == d.y) then before else before ++ [d])
  go (D.length * D.length + 2) [(p, q)] []

def explanation (q : Query) (c : Bool) : List Step × List String :=
  let w := q.world
  if c then
    let ch := chain (relation w) q.first q.second
    (ch.map (fun d => (⟨d.text.capitalize, d.cite⟩ : Step)) ++
        [⟨s!"So {w.name q.first} and {w.name q.second} are related persons.", "ITA 251(2)"⟩],
      ch.foldl (fun ids d => mergeIds ids d.judgments) [])
  else
    ([⟨(s!"{w.name q.first} and {w.name q.second} are not related persons: no paragraph of subsection 251(2), alone " ++
        "or through other related persons, and not subsection 251(3), makes them so.").capitalize, "ITA 251(2), (3)"⟩], [])

def explain (q : Query) : Finding :=
  ⟨related q, (explanation q (related q)).1, (explanation q (related q)).2⟩

/-- Subsection 251(2). -/
def rule : Rule Query where
  name := "related persons under subsection 251(2)"
  citation := "ITA 251(2)"
  holds := related
  explain := explain
  sound := fun _ => rfl

theorem related_symm (w : World) (p q : Nat) : related ⟨w, p, q⟩ = related ⟨w, q, p⟩ := by
  simp only [related, rel]
  rw [Bool.eq_iff_iff]
  simp only [List.any_eq_true, Bool.or_eq_true, Bool.and_eq_true, beq_iff_eq]
  constructor <;> rintro ⟨d, hd, h⟩ <;> exact ⟨d, hd, h.symm⟩

/-! ## Arm's length (251(1)) -/

/-- Whether two persons deal with each other at arm's length. -/
structure ArmsLengthQuery where
  world : World
  first : Nat
  second : Nat
  /-- 251(1)(b): a taxpayer and a personal trust in which the taxpayer, or a person not dealing
  at arm's length with the taxpayer, would be beneficially interested (an input). -/
  personalTrust : Bool := false
  /-- 251(1)(c): for persons not related to each other, whether they deal at arm's length is a
  question of fact, usually a judgment call. -/
  questionOfFact : Answer := .fact true
  deriving Inhabited

def armsLength (q : ArmsLengthQuery) : Bool :=
  !related ⟨q.world, q.first, q.second⟩ && !q.personalTrust && q.questionOfFact.value

def armsLengthExplanation (q : ArmsLengthQuery) : List Step × List String :=
  let w := q.world
  let rq : Query := ⟨w, q.first, q.second⟩
  if related rq then
    ((explain rq).steps ++ [⟨"Related persons are deemed not to deal with each other at arm's length.", "ITA 251(1)(a)"⟩],
      (explain rq).reliesOn)
  else if q.personalTrust then
    ([⟨s!"{w.name q.first} and {w.name q.second} are a taxpayer and a personal trust in which the taxpayer, or a person " ++
        "not dealing at arm's length with the taxpayer, would be beneficially interested, so they are deemed not to deal " ++
        "at arm's length.", "ITA 251(1)(b)"⟩], [])
  else
    ((explain rq).steps ++ [⟨s!"Whether persons not related to each other deal at arm's length is a question of fact: " ++
        s!"{if q.questionOfFact.value then "they do" else "they do not"}{jnote q.questionOfFact.judgments}.", "ITA 251(1)(c)"⟩],
      q.questionOfFact.judgments)

/-- Subsection 251(1): the two persons deal with each other at arm's length. -/
def armsLengthRule : Rule ArmsLengthQuery where
  name := "dealing at arm's length under subsection 251(1)"
  citation := "ITA 251(1)"
  holds := armsLength
  explain := fun q => ⟨armsLength q, (armsLengthExplanation q).1, (armsLengthExplanation q).2⟩
  sound := fun _ => rfl

/-- Related persons never deal at arm's length, whatever the question of fact would say. -/
theorem not_armsLength_of_related (q : ArmsLengthQuery) (h : related ⟨q.world, q.first, q.second⟩ = true) :
    armsLength q = false := by
  simp [armsLength, h]

/-- The answer, for provisions that ask whether persons deal at arm's length (such as
40(2)(g)(ii)): a fact where 251(1)(a) or (b) settles it, otherwise the question of fact. -/
def armsLengthAnswer (q : ArmsLengthQuery) : Answer :=
  if related ⟨q.world, q.first, q.second⟩ || q.personalTrust then .fact false else q.questionOfFact

theorem armsLengthAnswer_value (q : ArmsLengthQuery) : (armsLengthAnswer q).value = armsLength q := by
  unfold armsLengthAnswer armsLength
  cases h : related ⟨q.world, q.first, q.second⟩ <;> cases q.personalTrust <;> simp

/-! ## Drawing a family -/

/-- The world as a Mermaid graph: children by blood (solid arrows from parent to child),
adoptions (dotted arrows), marriages (thick lines), control (dashed arrows), and each related
pair as a thin line labelled with its paragraph. -/
def diagram (w : World) : String := Id.run do
  let esc := Graphs.esc
  let node (p : Person) : String :=
    let l := esc p.name
    match p.kind with
    | .individual => s!"  p{p.id}(\"{l}\")"
    | .corporation => s!"  p{p.id}[\"{l}\"]"
    | .partnership => s!"  p{p.id}{"{{"}\"{l}\"{"}}"}"
    | .trust => s!"  p{p.id}[(\"{l}\")]"
  let mut out := ["flowchart TB"] ++ w.persons.map node
  for (par, ch) in w.children do out := out ++ [s!"  p{par} -->|child| p{ch}"]
  for (par, ch) in w.adoptions do out := out ++ [s!"  p{par} -.->|adopted| p{ch}"]
  for (a, b) in w.spouses do out := out ++ [s!"  p{a} ===|married| p{b}"]
  for c in w.controls do
    let from_ := match c.controller with
      | .person p => [p]
      | .group g => g
    for f in from_ do
      out := out ++ [s!"  p{f} -.->|\"{if c.deFactoOnly then "controls de facto" else "controls"}\"| p{c.corporation}"]
  for d in relation w do
    out := out ++ [s!"  p{d.x} ---|\"{(d.cite.drop "ITA ".length).toString}\"| p{d.y}"]
  return "\n".intercalate out

end Canteen.ITA.RelatedPersons

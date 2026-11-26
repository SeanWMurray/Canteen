import Canteen.Core.Answer
import Canteen.Core.Money
import Canteen.ITA.S54.SuperficialLoss
import Canteen.Core.Graphs

/-!
# Section 251.1: affiliated persons, paragraphs (a) to (h)

*Income Tax Act*, subsection 251.1(1) paragraphs (a) to (h), with the definitions in
251.1(3), the interpretation rules in 251.1(4), and the definition "majority-interest
partner" in 248(1). Verbatim in `statute/ITA-251-1.txt`.

Affiliation is defined in terms of itself: (c), (d), (f) and (g) turn on whether other
persons are affiliated, and so do the majority-interest tests. So it is computed for a whole
`World` of persons at once, as the smallest relation that

* contains every pair named by paragraphs (a) to (h) (with any further pairs given for (h)), and
* is symmetric, with every person affiliated with itself (251.1(4)(a)).

The relation is built up step by step until nothing more is added. Paragraph (g)(ii) asks
whether a person "would, if this subsection were read without reference to this paragraph,
be affiliated with" a beneficiary, so it uses the relation built without paragraph (g).

**Facts before judgment.** Control can be a fact (a majority of the votes) or a judgment call
(control "directly or indirectly in any manner whatever"). The relation is first built from
the facts alone, then with the judgment calls, so a pair the facts settle is always explained
by them. Every pair keeps the reasons it was added and the judgment calls they rest on.
-/

namespace Canteen.ITA.AffiliatedPersons

/-! ## The world -/

inductive Kind where
  | individual
  | corporation
  | partnership
  | trust
  deriving Repr, DecidableEq, Inhabited

structure Person where
  id : Nat
  name : String
  kind : Kind
  deriving Repr, DecidableEq, Inhabited

/-- Who controls a corporation: one person, or a group of persons. -/
inductive Controller where
  | person (p : Nat)
  | group (members : List Nat)
  deriving Repr, DecidableEq, Inhabited

/-- A corporation is controlled by a controller. "Controlled" means controlled, directly or
indirectly in any manner whatever (251.1(3)): a fact, or a judgment call. -/
structure Control where
  corporation : Nat
  controller : Controller
  answer : Answer := .fact true
  /-- The control is de facto only (not de jure). It counts for affiliation, where "controlled"
  includes control "in any manner whatever", but not for related persons under 251(2). -/
  deFactoOnly : Bool := false
  deriving Repr, DecidableEq, Inhabited

/-- A partner's interest in a partnership, for the definition "majority-interest partner". -/
structure PartnershipInterest where
  partnership : Nat
  partner : Nat
  /-- The partner's share of the partnership's income from all sources for the last fiscal period. -/
  incomeShare : Cents
  /-- The amount that would be paid to the partner (otherwise than as income) on winding up. -/
  windingUpShare : Cents
  deriving Repr, DecidableEq, Inhabited

/-- A beneficiary's interest in a trust, at fair market value, for "majority-interest beneficiary". -/
structure BeneficialInterest where
  trust : Nat
  beneficiary : Nat
  income : Cents
  capital : Cents
  deriving Repr, DecidableEq, Inhabited

/-- Everything section 251.1 needs about a group of persons. -/
structure World where
  persons : List Person
  /-- Pairs of an individual and a spouse or common-law partner of the individual. -/
  spouses : List (Nat × Nat) := []
  controls : List Control := []
  partnershipInterests : List PartnershipInterest := []
  beneficialInterests : List BeneficialInterest := []
  /-- Contributors to trusts, as (trust, contributor), within the meaning of 251.1(3): a person
  who made a loan or transfer of property to or for the benefit of the trust, other than an arm's
  length loan at a reasonable rate of interest or transfer for fair market value by a person who
  is not then a majority-interest beneficiary. Taken as facts. -/
  contributors : List (Nat × Nat) := []
  /-- Further pairs of individuals connected by blood relationship, marriage, common-law
  partnership or adoption, beyond those computed from the family below (251(6)). -/
  connected : List (Nat × Nat) := []
  /-- (parent, child): the child is a child of the parent by blood. -/
  children : List (Nat × Nat) := []
  /-- Pairs who are brother or sister, where their parents are not given. -/
  siblings : List (Nat × Nat) := []
  /-- (parent, child): the child was adopted, legally or in fact, as the child of the parent. -/
  adoptions : List (Nat × Nat) := []
  /-- Further pairs affiliated under paragraph (h), given rather than computed (for example,
  where the contributor or beneficiary facts are not modelled). -/
  paragraphH : List (Nat × Nat × Answer) := []
  deriving Repr, Inhabited

namespace World

def person? (w : World) (p : Nat) : Option Person := w.persons.find? (·.id == p)
def name (w : World) (p : Nat) : String := ((w.person? p).map (·.name)).getD s!"person {p}"
def isKind (w : World) (k : Kind) (p : Nat) : Bool := ((w.person? p).map (·.kind == k)).getD false
def ids (w : World) (k : Kind) : List Nat := (w.persons.filter (·.kind == k)).map (·.id)

private def hasPair (ps : List (Nat × Nat)) (p q : Nat) : Bool :=
  ps.any fun (a, b) => (a == p && b == q) || (a == q && b == p)

/-- Married or in a common-law partnership. -/
def married (w : World) (p q : Nat) : Bool := hasPair w.spouses p q

/-- `d` is a child or other descendant of `a` by blood. -/
def descendant (w : World) (a d : Nat) : Bool :=
  let rec go : Nat → List Nat → Bool
    | 0, _ => false
    | fuel + 1, gen =>
      let next := w.children.filterMap fun (par, ch) => if gen.contains par then some ch else none
      next.contains d || (!next.isEmpty && go fuel next)
  go w.persons.length [a]

/-- Brother or sister: given as siblings, or sharing a parent. -/
def sibling (w : World) (p q : Nat) : Bool :=
  p != q && (hasPair w.siblings p q ||
    w.children.any fun (par, c) => c == p && w.children.any fun (par', c') => par' == par && c' == q)

/-- 251(6)(a): connected by blood relationship. -/
def blood (w : World) (p q : Nat) : Bool :=
  p != q && (w.descendant p q || w.descendant q p || w.sibling p q)

/-- 251(6)(b), (b.1): connected by marriage or common-law partnership: married to the other,
or to a person connected by blood relationship to the other. -/
def byMarriage (w : World) (p q : Nat) : Bool :=
  w.married p q || w.persons.any fun s =>
    (w.married p s.id && w.blood s.id q) || (w.married q s.id && w.blood s.id p)

/-- 251(6)(c): connected by adoption: adopted, legally or in fact, as the child of the other, or
as the child of a person connected by blood relationship (otherwise than as a brother or sister)
to the other. -/
def byAdoption (w : World) (p q : Nat) : Bool :=
  let adopted (child par : Nat) := hasPair (w.adoptions.filter fun (a, c) => a == par && c == child) par child
  let lineal (a b : Nat) := w.descendant a b || w.descendant b a
  adopted p q || adopted q p || w.persons.any fun s =>
    (adopted p s.id && lineal s.id q) || (adopted q s.id && lineal s.id p)

/-- Subsection 251(6): individuals connected by blood relationship, marriage, common-law
partnership or adoption (or given as connected). -/
def connectedPair (w : World) (p q : Nat) : Bool :=
  p != q && (w.blood p q || w.byMarriage p q || w.byAdoption p q || hasPair w.connected p q)

/-- How two persons are connected, in words, for explanations. -/
def connectionText (w : World) (p q : Nat) : String :=
  if w.descendant p q || w.descendant q p then "connected by blood relationship (one is a child or other descendant of the other)"
  else if w.sibling p q then "connected by blood relationship (brother or sister)"
  else if w.married p q then "connected by marriage or common-law partnership"
  else if w.byMarriage p q then "connected by marriage or common-law partnership (one is married to a person connected by blood relationship to the other)"
  else if w.byAdoption p q then "connected by adoption"
  else "connected by blood relationship, marriage, common-law partnership or adoption"

end World

/-! ## Derivations: each affiliated pair, with why -/

/-- The paragraph a pair is affiliated under. -/
inductive Para where
  | a | bi | bii | biii | ci | cii | ciii | d | e | fi | fii | fiii | gi | gii | hi | hii | hiii | h
  deriving Repr, DecidableEq, Inhabited

def Para.cite : Para → String
  | .a => "ITA 251.1(1)(a)" | .bi => "ITA 251.1(1)(b)(i)" | .bii => "ITA 251.1(1)(b)(ii)"
  | .biii => "ITA 251.1(1)(b)(iii)" | .ci => "ITA 251.1(1)(c)(i)" | .cii => "ITA 251.1(1)(c)(ii)"
  | .ciii => "ITA 251.1(1)(c)(iii)" | .d => "ITA 251.1(1)(d)" | .e => "ITA 251.1(1)(e)"
  | .fi => "ITA 251.1(1)(f)(i)" | .fii => "ITA 251.1(1)(f)(ii)" | .fiii => "ITA 251.1(1)(f)(iii)"
  | .gi => "ITA 251.1(1)(g)(i)" | .gii => "ITA 251.1(1)(g)(ii)" | .hi => "ITA 251.1(1)(h)(i)"
  | .hii => "ITA 251.1(1)(h)(ii)" | .hiii => "ITA 251.1(1)(h)(iii)" | .h => "ITA 251.1(1)(h)"

/-- Why two persons are affiliated: the paragraph, a sentence, the pairs it relies on, and
the judgment calls it rests on directly. -/
structure Derivation where
  x : Nat
  y : Nat
  para : Para
  text : String
  parents : List (Nat × Nat) := []
  judgments : List String := []
  deriving Repr, Inhabited

/-- A derivation. -/
def dv (x y : Nat) (para : Para) (text : String) (parents : List (Nat × Nat) := [])
    (judgments : List String := []) : Derivation :=
  { x, y, para, text, parents, judgments }

/-- `p` and `q` are affiliated in `D`: the same person (251.1(4)(a)), or a recorded pair, in
either order. -/
def aff (D : List Derivation) (p q : Nat) : Bool :=
  p == q || D.any fun d => (d.x == p && d.y == q) || (d.x == q && d.y == p)

/-- A group of persons each of whom is affiliated with every other (251.1(3)). -/
def affiliatedGroup (D : List Derivation) (g : List Nat) : Bool :=
  g.all fun m => g.all fun n => aff D m n

/-- The distinct pairs of a group, for citing that it is an affiliated group. -/
def groupPairs (g : List Nat) : List (Nat × Nat) :=
  g.flatMap fun m => (g.filter (· > m)).map (m, ·)

/-- Every member of `g` is affiliated with at least one member of `h`; the witnessing pairs. -/
def eachAffiliatedWithSome (D : List Derivation) (g h : List Nat) : Option (List (Nat × Nat)) :=
  g.foldl (fun acc m => acc.bind fun ps =>
    (h.find? (aff D m ·)).map fun n => if m == n then ps else ps ++ [(m, n)]) (some [])

def describeGroup (w : World) (g : List Nat) : String :=
  match g with
  | [] => "an empty group"
  | [m] => s!"the group consisting of {w.name m}"
  | _ => s!"the group made up of {", ".intercalate ((g.dropLast).map w.name)} and {w.name g.getLast!}"

/-! ## Majority interests (248(1), 251.1(3)) -/

def sumIncome (is : List PartnershipInterest) : Cents := is.foldl (· + ·.incomeShare) 0
def sumWindingUp (is : List PartnershipInterest) : Cents := is.foldl (· + ·.windingUpShare) 0

def interestsIn (w : World) (P : Nat) : List PartnershipInterest :=
  w.partnershipInterests.filter (·.partnership == P)

/-- "majority-interest partner" (248(1)): the shares of `t` and every person affiliated with
`t`, of the income or of the winding-up amounts, exceed half the total. Returns the
affiliation pairs it relies on (other contributors). -/
def majorityInterestPartner? (w : World) (D : List Derivation) (t P : Nat) : Option (List (Nat × Nat)) :=
  if !w.isKind .partnership P || t == P then none
  else
    let all := interestsIn w P
    let mine := all.filter (aff D t ·.partner)
    if 2 * sumIncome mine > sumIncome all || 2 * sumWindingUp mine > sumWindingUp all then
      some ((mine.map (·.partner)).eraseDups.filterMap fun q => if q == t then none else some (t, q))
    else none

/-- All sub-lists of a list (every subset, in order). -/
def subsets : List Nat → List (List Nat)
  | [] => [[]]
  | x :: xs => let r := subsets xs; r.map (x :: ·) ++ r

/-- Would one person holding all of `g`'s interests be a majority-interest partner? -/
def groupMajority (w : World) (P : Nat) (g : List Nat) : Bool :=
  let all := interestsIn w P
  let theirs := all.filter (g.contains ·.partner)
  2 * sumIncome theirs > sumIncome all || 2 * sumWindingUp theirs > sumWindingUp all

/-- "majority-interest group of partners" (251.1(3)): a group whose combined interests would
make one holder a majority-interest partner, and no member of which can be left out. -/
def majorityInterestGroups (w : World) (P : Nat) : List (List Nat) :=
  let partners := ((interestsIn w P).map (·.partner)).eraseDups
  (subsets partners).filter fun g =>
    !g.isEmpty && groupMajority w P g && g.all fun m => !groupMajority w P (g.erase m)

def trustInterests (w : World) (T : Nat) : List BeneficialInterest :=
  w.beneficialInterests.filter (·.trust == T)

/-- "majority-interest beneficiary" (251.1(3)): the interests of `p` and every person
affiliated with `p` in the income, or in the capital, exceed half. A trust must itself have
an interest of that kind (251.1(4)(d)(iii)). -/
def majorityInterestBeneficiary? (w : World) (D : List Derivation) (p T : Nat) : Option (List (Nat × Nat)) :=
  if !w.isKind .trust T || p == T then none
  else
    let all := trustInterests w T
    let mine := all.filter (aff D p ·.beneficiary)
    let own := all.filter (·.beneficiary == p)
    let trustOk (f : BeneficialInterest → Cents) := !w.isKind .trust p || own.any (f · > 0)
    let sumBy (f : BeneficialInterest → Cents) (is : List BeneficialInterest) := is.foldl (· + f ·) 0
    let byIncome := 2 * sumBy (·.income) mine > sumBy (·.income) all && trustOk (·.income)
    let byCapital := 2 * sumBy (·.capital) mine > sumBy (·.capital) all && trustOk (·.capital)
    if byIncome || byCapital then
      some ((mine.map (·.beneficiary)).eraseDups.filterMap fun q => if q == p then none else some (p, q))
    else none

/-- Would one person holding all of `g`'s interests be a majority-interest beneficiary? -/
def groupMajorityB (w : World) (T : Nat) (g : List Nat) : Bool :=
  let all := trustInterests w T
  let theirs := all.filter (g.contains ·.beneficiary)
  let sumBy (f : BeneficialInterest → Cents) (is : List BeneficialInterest) := is.foldl (· + f ·) 0
  2 * sumBy (·.income) theirs > sumBy (·.income) all || 2 * sumBy (·.capital) theirs > sumBy (·.capital) all

/-- "majority-interest group of beneficiaries" (251.1(3)): beneficiaries whose combined
interests would make one holder a majority-interest beneficiary, none of whom can be left out. -/
def majorityInterestGroupsB (w : World) (T : Nat) : List (List Nat) :=
  let bens := ((trustInterests w T).map (·.beneficiary)).eraseDups
  (subsets bens).filter fun g =>
    !g.isEmpty && groupMajorityB w T g && g.all fun m => !groupMajorityB w T (g.erase m)

/-- For comparing contributors to two trusts: affiliated, or individuals connected by blood
relationship, marriage, common-law partnership or adoption (251.1(4)(d)(iv)). Returns the
affiliation pair relied on, if any. -/
def contributorsAffiliated (w : World) (D : List Derivation) (p q : Nat) : Option (List (Nat × Nat)) :=
  if aff D p q then some (if p == q then [] else [(p, q)])
  else if w.isKind .individual p && w.isKind .individual q && w.connectedPair p q then some []
  else none

/-! ## The paragraphs, as steps that add pairs -/

def jnote (js : List String) : String :=
  if js.isEmpty then "" else s!" (judgment call {", ".intercalate js})"

/-- The persons described in (b)(i) and (b)(ii) for a control: the controller, or each member
of an affiliated controlling group. -/
def described (D : List Derivation) (c : Control) : List Nat :=
  match c.controller with
  | .person p => [p]
  | .group g => if affiliatedGroup D g then g else []

/-- Every pair paragraphs (a) to (h) give, from the pairs found so far. -/
def candidates (w : World) (allowJudged withG : Bool) (noG D : List Derivation) : List Derivation := Id.run do
  let n := w.name
  let controls := w.controls.filter fun c =>
    c.answer.value && (allowJudged || c.answer.judgments.isEmpty) && w.isKind .corporation c.corporation
  let mut out : List Derivation := []
  -- (a)
  for (p, q) in w.spouses do
    if w.isKind .individual p then
      out := out ++ [{
        x := p, y := q, para := .a,
        text := s!"{n p} and {n q} are an individual and a spouse or common-law partner of the individual." }]
  -- (b)
  for c in controls do
    let js := c.answer.judgments
    match c.controller with
    | .person p =>
      out := out ++ [{
        x := c.corporation, y := p, para := .bi, judgments := js,
        text := s!"{n c.corporation} is a corporation controlled by {n p}{jnote js}." }]
    | .group g =>
      if affiliatedGroup D g then
        for m in g do
          out := out ++ [{
            x := c.corporation, y := m, para := .bii, judgments := js, parents := groupPairs g,
            text := s!"{n c.corporation} is a corporation controlled by {describeGroup w g}, an affiliated group of " ++
              s!"persons, of which {n m} is a member{jnote js}." }]
    for x in described D c do
      for (p, q) in w.spouses do
        for s in (if p == x then [q] else if q == x then [p] else []) do
          out := out ++ [{
            x := c.corporation, y := s, para := .biii, judgments := js,
            parents := [(c.corporation, x), (x, s)],
            text := s!"{n s} is a spouse or common-law partner of {n x}, a person described in subparagraph " ++
              s!"251.1(1)(b)(i) or (ii) in respect of {n c.corporation}." }]
  -- (c)
  for c1 in controls do
    for c2 in controls do
      if c1.corporation < c2.corporation then
        let js := mergeIds c1.answer.judgments c2.answer.judgments
        let a := c1.corporation
        let b := c2.corporation
        match c1.controller, c2.controller with
        | .person p1, .person p2 =>
          if aff D p1 p2 then
            out := out ++ [{
              x := a, y := b, para := .ci, judgments := js,
              parents := if p1 == p2 then [] else [(p1, p2)],
              text := if p1 == p2 then s!"{n a} and {n b} are each controlled by {n p1}{jnote js}."
                else s!"{n a} is controlled by {n p1} and {n b} by {n p2}, and {n p1} is affiliated with {n p2}{jnote js}." }]
        | .person p, .group g | .group g, .person p =>
          if g.all (aff D · p) then
            out := out ++ [{
              x := a, y := b, para := .cii, judgments := js,
              parents := (g.filter (· != p)).map (·, p),
              text := s!"One of {n a} and {n b} is controlled by {n p} and the other by {describeGroup w g}, each member " ++
                s!"of which is affiliated with {n p}{jnote js}." }]
        | .group g1, .group g2 =>
          match eachAffiliatedWithSome D g1 g2, eachAffiliatedWithSome D g2 g1 with
          | some ps1, some ps2 =>
            out := out ++ [{
              x := a, y := b, para := .ciii, judgments := js, parents := ps1 ++ ps2,
              text := s!"{n a} is controlled by {describeGroup w g1} and {n b} by {describeGroup w g2}, and each member of " ++
                s!"each group is affiliated with at least one member of the other{jnote js}." }]
          | _, _ => pure ()
  -- (d)
  for c in controls do
    match c.controller with
    | .group g =>
      for P in w.ids .partnership do
        for m in majorityInterestGroups w P do
          match eachAffiliatedWithSome D g m, eachAffiliatedWithSome D m g with
          | some ps1, some ps2 =>
            out := out ++ [{
              x := c.corporation, y := P, para := .d, judgments := c.answer.judgments,
              parents := ps1 ++ ps2,
              text := s!"{n c.corporation} is controlled by {describeGroup w g}, each member of which is affiliated with at " ++
                s!"least one member of {describeGroup w m}, a majority-interest group of partners of {n P}, and each member " ++
                s!"of that group is affiliated with at least one member of the controlling group{jnote c.answer.judgments}." }]
          | _, _ => pure ()
    | _ => pure ()
  -- (e)
  for P in w.ids .partnership do
    for t in w.persons.map (·.id) do
      match majorityInterestPartner? w D t P with
      | some ps =>
        out := out ++ [{
          x := P, y := t, para := .e, parents := ps,
          text := s!"{n t} is a majority-interest partner of {n P}: its share of the income or of the amount paid on a " ++
            "winding-up, together with those of the persons affiliated with it, exceeds one half." }]
      | none => pure ()
  -- (f)
  for P1 in w.ids .partnership do
    for P2 in w.ids .partnership do
      if P1 < P2 then
        let mips (P : Nat) := (w.persons.map (·.id)).filterMap fun t => (majorityInterestPartner? w D t P).map (t, ·)
        match (mips P1).find? (fun (t, _) => (mips P2).any (·.1 == t)) with
        | some (t, ps) =>
          out := out ++ [{
            x := P1, y := P2, para := .fi, parents := ps,
            text := s!"{n t} is a majority-interest partner of both {n P1} and {n P2}." }]
        | none =>
          let fii (A B : Nat) : Option Derivation :=
            (mips A).findSome? fun (t, _) =>
              (majorityInterestGroups w B).findSome? fun m =>
                if m.all (aff D t ·) then
                  some {
                    x := P1, y := P2, para := .fii, parents := (m.filter (· != t)).map (t, ·),
                    text := s!"{n t}, a majority-interest partner of {n A}, is affiliated with each member of " ++
                      s!"{describeGroup w m}, a majority-interest group of partners of {n B}." }
                else none
          match fii P1 P2 <|> fii P2 P1 with
          | some d => out := out ++ [d]
          | none =>
            let fiii := (majorityInterestGroups w P1).findSome? fun m1 =>
              (majorityInterestGroups w P2).findSome? fun m2 =>
                match eachAffiliatedWithSome D m1 m2, eachAffiliatedWithSome D m2 m1 with
                | some ps1, some ps2 => some (m1, m2, ps1 ++ ps2)
                | _, _ => none
            match fiii with
            | some (m1, m2, ps) =>
              out := out ++ [{
                x := P1, y := P2, para := .fiii, parents := ps,
                text := s!"Each member of {describeGroup w m1}, a majority-interest group of partners of {n P1}, is " ++
                  s!"affiliated with at least one member of {describeGroup w m2}, a majority-interest group of partners " ++
                  s!"of {n P2}, and the reverse." }]
            | none => pure ()
  -- (g)
  if withG then
    for T in w.ids .trust do
      for p in w.persons.map (·.id) do
        match majorityInterestBeneficiary? w D p T with
        | some ps =>
          out := out ++ [{
            x := p, y := T, para := .gi, parents := ps,
            text := s!"{n p} is a majority-interest beneficiary of {n T}: its interest in the income or capital, " ++
              "together with those of the persons affiliated with it, exceeds half by fair market value." }]
        | none =>
          let mibs := (w.persons.map (·.id)).filter fun m => (majorityInterestBeneficiary? w D m T).isSome
          match mibs.find? (fun m => m != p && m != T && aff noG p m) with
          | some m =>
            out := out ++ [{
              x := p, y := T, para := .gii, parents := [(p, m), (m, T)],
              text := s!"{n p} would, if subsection 251.1(1) were read without reference to paragraph (g), be " ++
                s!"affiliated with {n m}, a majority-interest beneficiary of {n T}." }]
          | none => pure ()
  -- (h)
  for T1 in w.ids .trust do
    for T2 in w.ids .trust do
      if T1 < T2 then
        let c1 := (w.contributors.filter (·.1 == T1)).map (·.2)
        let c2 := (w.contributors.filter (·.1 == T2)).map (·.2)
        let contrib := c1.findSome? fun p => c2.findSome? fun q =>
          (contributorsAffiliated w D p q).map fun ps => (p, q, ps)
        match contrib with
        | none => pure ()
        | some (p, q, cps) =>
          let link := if aff D p q then s!"{n p}, a contributor to {n T1}, is affiliated with {n q}, a contributor to {n T2}"
            else s!"{n p}, a contributor to {n T1}, and {n q}, a contributor to {n T2}, are individuals " ++
              s!"{w.connectionText p q}, so are deemed affiliated (251.1(4)(d)(iv))"
          let mibs (T : Nat) := (w.persons.map (·.id)).filter fun m => (majorityInterestBeneficiary? w D m T).isSome
          let hi := (mibs T1).findSome? fun a => (mibs T2).findSome? fun b =>
            if aff D a b then some (a, b) else none
          match hi with
          | some (a, b) =>
            out := out ++ [dv T1 T2 .hi
              (if a == b then s!"{link}; and {n a} is a majority-interest beneficiary of both trusts."
                else s!"{link}; and {n a}, a majority-interest beneficiary of {n T1}, is affiliated with {n b}, a " ++
                  s!"majority-interest beneficiary of {n T2}.")
              (parents := cps ++ (if a == b then [] else [(a, b)]) ++ [(a, T1), (b, T2)])]
          | none =>
            let hii (A B : Nat) := (mibs A).findSome? fun a =>
              (majorityInterestGroupsB w B).findSome? fun g => if g.all (aff D a ·) then some (a, A, g, B) else none
            match hii T1 T2 <|> hii T2 T1 with
            | some (a, A, g, B) =>
              out := out ++ [dv T1 T2 .hii
                (s!"{link}; and {n a}, a majority-interest beneficiary of {n A}, is affiliated with each member of " ++
                  s!"{describeGroup w g}, a majority-interest group of beneficiaries of {n B}.")
                (parents := cps ++ (g.filter (· != a)).map (a, ·) ++ [(a, A)])]
            | none =>
              let hiii := (majorityInterestGroupsB w T1).findSome? fun g1 =>
                (majorityInterestGroupsB w T2).findSome? fun g2 =>
                  match eachAffiliatedWithSome D g1 g2, eachAffiliatedWithSome D g2 g1 with
                  | some ps1, some ps2 => some (g1, g2, ps1 ++ ps2)
                  | _, _ => none
              match hiii with
              | some (g1, g2, ps) =>
                out := out ++ [dv T1 T2 .hiii
                  (s!"{link}; and each member of {describeGroup w g1}, a majority-interest group of beneficiaries of " ++
                    s!"{n T1}, is affiliated with at least one member of {describeGroup w g2}, a majority-interest group " ++
                    s!"of beneficiaries of {n T2}, and the reverse.")
                  (parents := cps ++ ps)]
              | none => pure ()
  -- (h), as given
  for (p, q, ans) in w.paragraphH do
    if ans.value && (allowJudged || ans.judgments.isEmpty) then
      out := out ++ [{
        x := p, y := q, para := .h, judgments := ans.judgments,
        text := s!"{n p} and {n q} are affiliated under paragraph 251.1(1)(h){jnote ans.judgments} (given as an input)." }]
  return out

/-- Add every new pair the paragraphs give. -/
def step (w : World) (allowJudged withG : Bool) (noG D : List Derivation) : List Derivation :=
  (candidates w allowJudged withG noG D).foldl (fun acc d => if aff acc d.x d.y then acc else acc ++ [d]) D

/-- Repeat until nothing is added (at most one round per possible pair). -/
def closeFrom (w : World) (allowJudged withG : Bool) (noG : List Derivation) : Nat → List Derivation → List Derivation
  | 0, D => D
  | fuel + 1, D =>
    let D' := step w allowJudged withG noG D
    if D'.length == D.length then D else closeFrom w allowJudged withG noG fuel D'

def fuel (w : World) : Nat := w.persons.length * w.persons.length + 1

/-- The relation without paragraph (g): on the facts alone, then with the judgment calls. -/
def withoutG (w : World) (allowJudged : Bool) : List Derivation :=
  let facts := closeFrom w false false [] (fuel w) []
  if allowJudged then closeFrom w true false [] (fuel w) facts else facts

/-- The relation: paragraphs (a) to (h) (and any further (h) pairs given), on the facts alone first,
then with the judgment calls. -/
def relation (w : World) : List Derivation :=
  let facts := closeFrom w false true (withoutG w false) (fuel w) []
  closeFrom w true true (withoutG w true) (fuel w) facts

/-- The computed relation is closed: one more round adds nothing. -/
def isClosed (w : World) : Bool :=
  (step w true true (withoutG w true) (relation w)).length == (relation w).length

/-! ## The rule -/

/-- Two persons of a world, asking whether they are affiliated. -/
structure Query where
  world : World
  first : Nat
  second : Nat
  deriving Inhabited

/-- Subsection 251.1(1), paragraphs (a) to (h): the two persons are affiliated. -/
def affiliated (q : Query) : Bool :=
  aff (relation q.world) q.first q.second

/-- The derivations behind a pair, in the order they build on each other. -/
def chain (D : List Derivation) (p q : Nat) : List Derivation :=
  let find (a b : Nat) := D.find? fun d => (d.x == a && d.y == b) || (d.x == b && d.y == a)
  let rec go : Nat → List (Nat × Nat) → List Derivation → List Derivation
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

/-- Judgment calls answered "no" that could, if answered "yes", make a pair affiliated. -/
def judgedNo (w : World) : List String :=
  (w.controls.filter (!·.answer.value)).foldl (fun ids c => mergeIds ids c.answer.judgments) [] |>.append
    ((w.paragraphH.filter fun (_, _, a) => !a.value).foldl (fun ids (_, _, a) => mergeIds ids a.judgments) [])

/-- The reasons, given whether the two persons are affiliated. -/
def explanation (q : Query) (c : Bool) : List Step × List String :=
  let w := q.world
  let D := relation w
  let p := q.first
  let r := q.second
  if p == r then
    ([⟨(s!"{w.name p} is affiliated with itself.").capitalize, "ITA 251.1(4)(a)"⟩], [])
  else if c then
    let ch := chain D p r
    (ch.map (fun d => (⟨d.text.capitalize, d.para.cite⟩ : Step)) ++
        [⟨s!"So {w.name p} and {w.name r} are affiliated persons.", "ITA 251.1(1)"⟩],
      ch.foldl (fun ids d => mergeIds ids d.judgments) [])
  else
    let js := judgedNo w
    ([⟨s!"No paragraph of subsection 251.1(1), from (a) to (h), alone or through other affiliated persons, makes " ++
        s!"{w.name p} and {w.name r} affiliated persons" ++
        (if js.isEmpty then "." else s!", on the answers given to judgment calls {", ".intercalate js}."), "ITA 251.1(1)"⟩],
      js)

def explain (q : Query) : Finding :=
  ⟨affiliated q, (explanation q (affiliated q)).1, (explanation q (affiliated q)).2⟩

theorem explain_sound (q : Query) : (explain q).conclusion = affiliated q := rfl

/-- Subsection 251.1(1), paragraphs (a) to (h). -/
def rule : Rule Query where
  name := "affiliation under subsection 251.1(1)"
  citation := "ITA 251.1(1)"
  holds := affiliated
  explain := explain
  sound := explain_sound

/-! ## Basic truths, for every world -/

/-- Every person is affiliated with itself (251.1(4)(a)). -/
theorem affiliated_self (w : World) (p : Nat) : affiliated ⟨w, p, p⟩ = true := by
  simp [affiliated, aff]

/-- Affiliation is symmetric. -/
theorem affiliated_symm (w : World) (p q : Nat) : affiliated ⟨w, p, q⟩ = affiliated ⟨w, q, p⟩ := by
  simp only [affiliated, aff]
  rw [Bool.eq_iff_iff]
  simp only [Bool.or_eq_true, beq_iff_eq, List.any_eq_true, Bool.and_eq_true]
  constructor <;> rintro (h | ⟨d, hd, h⟩)
  · exact .inl h.symm
  · exact .inr ⟨d, hd, h.symm⟩
  · exact .inl h.symm
  · exact .inr ⟨d, hd, h.symm⟩

/-! ## For the superficial loss definition -/

/-- Who acquired a property, for the superficial loss definition: affiliated with the taxpayer
or not, under subsection 251.1(1), with the judgment calls that decide it. -/
def acquirer (w : World) (taxpayer buyer : Nat) : SuperficialLoss.Acquirer :=
  let f := explain ⟨w, taxpayer, buyer⟩
  let who := w.name buyer
  if f.reliesOn.isEmpty then (if f.conclusion then .affiliated who else .notAffiliated who)
  else .judged who f.reliesOn f.conclusion

theorem acquirer_isTaxpayerOrAffiliated (w : World) (taxpayer buyer : Nat) :
    (acquirer w taxpayer buyer).isTaxpayerOrAffiliated = affiliated ⟨w, taxpayer, buyer⟩ := by
  unfold acquirer
  rw [← explain_sound]
  generalize explain { world := w, first := taxpayer, second := buyer } = f
  dsimp only
  split
  · split <;> simp_all [SuperficialLoss.Acquirer.isTaxpayerOrAffiliated]
  · rfl

/-! ## Drawing a world -/

private def shortPara (p : Para) : String :=
  (p.cite.drop "ITA 251.1(1)".length).toString

/-- The world as a Mermaid graph: persons by kind (rounded: individuals; boxes: corporations;
hexagons: partnerships; cylinders: trusts), control as dashed arrows (orange where a judgment
call), and each affiliated pair as a line labelled with its paragraph. -/
def diagram (w : World) : String := Id.run do
  let esc := Graphs.esc
  let node (p : Person) : String :=
    let l := esc p.name
    match p.kind with
    | .individual => s!"  p{p.id}(\"{l}\")"
    | .corporation => s!"  p{p.id}[\"{l}\"]"
    | .partnership => s!"  p{p.id}{"{{"}\"{l}\"{"}}"}"
    | .trust => s!"  p{p.id}[(\"{l}\")]"
  let mut out := ["flowchart LR"] ++ w.persons.map node
  let mut linkCount := 0
  let mut judgedLinks : List Nat := []
  for c in w.controls do
    let label := match c.answer with
      | .fact true => "controls"
      | .fact false => "does not control"
      | .judged j b => s!"{if b then "controls" else "does not control"} ({j})"
    let from_ := match c.controller with
      | .person p => [p]
      | .group g => g
    for f in from_ do
      out := out ++ [s!"  p{f} -.->|\"{esc label}\"| p{c.corporation}"]
      if !c.answer.judgments.isEmpty then judgedLinks := judgedLinks ++ [linkCount]
      linkCount := linkCount + 1
  for d in relation w do
    out := out ++ [s!"  p{d.x} ---|\"{shortPara d.para}\"| p{d.y}"]
    linkCount := linkCount + 1
  for i in judgedLinks do
    out := out ++ [s!"  linkStyle {i} stroke:#ef6c00,color:#e65100"]
  return "\n".intercalate out

end Canteen.ITA.AffiliatedPersons

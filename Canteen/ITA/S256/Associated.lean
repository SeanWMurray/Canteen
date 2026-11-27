import Canteen.ITA.S251.RelatedPersons

/-!
# Associated corporations (256(1))

*Income Tax Act*, as consolidated to 2026-10-29 (verbatim in `statute/ITA-256-1-1.1-1.2-1.5-5.1-associated.txt`):

**256(1)** One corporation is associated with another in a taxation year if, at any time in the year,
(a) one controlled the other; (b) both were controlled by the same person or group of persons; (c)
each was controlled by a person, the two persons were related, and either of them owned at least 25%
of the issued shares of a class (other than a specified class) of each corporation; (d) one was
controlled by a person related to each member of a group that controlled the other, and that person
owned at least 25% of the shares of a class of the other; or (e) each was controlled by a related
group, each member of one group was related to all members of the other, and one or more persons in
both groups, alone or together, owned at least 25% of the shares of a class of each.

**256(1.2)(a)** A group of persons in respect of a corporation is any two or more persons each of
whom owns shares of it; **(b)(i)** a corporation controlled by one or more members of a group is
controlled by the group; **(c)** owning shares worth more than 50% of all the shares (or of the
common shares) is control.

**256(1.5)** A person who owns shares in two or more corporations is, as shareholder of one, related
to himself as shareholder of the other.

**256(5.1)** "Controlled, directly or indirectly in any manner whatever" includes de facto control.

"Controlled" is read from the world's controls, de facto control included (256(5.1)), as facts or
judgment calls; 256(1.2)(c) is the caller's to apply when stating them. "Related" is section 251 as
computed by `RelatedPersons` on the same world, with a person related to himself (256(1.5)). For (b),
two controllers are the same if they have the same members; by 256(1.2)(b)(i), they also count as the
same group when every member of either owns shares of both corporations. Shareholdings are given by
class, with whether the class is a specified class (256(1.1), a fact). Not encoded: the look-through
rules of 256(1.2)(d) to (f), 256(1.3) (a child's shares), 256(1.4) (rights), 256(2) (association
through a third corporation) and 256(2.1) (the anti-avoidance rule).
-/

namespace Canteen.ITA.Associated

open AffiliatedPersons RelatedPersons

/-- Shares of a class of a corporation's capital stock owned by a person. -/
structure Holding where
  corporation : Nat
  holder : Nat
  shareClass : String
  /-- The percentage of the issued shares of the class. -/
  percent : Nat
  /-- 256(1.1): a specified class (non-voting, fixed preferred, redeemable at no more than issue price, ...). -/
  specified : Bool := false
  deriving Repr, DecidableEq, Inhabited

structure Facts where
  world : World
  holdings : List Holding := []
  first : Nat
  second : Nat
  deriving Inhabited

/-- Those who control the corporation, de jure or de facto (256(5.1)). -/
def controllers (w : World) (c : Nat) : List Controller :=
  (w.controls.filter fun k => k.corporation == c && k.answer.value).map (·.controller)

def controlJudgments (w : World) (c : Nat) : List String :=
  (w.controls.filter fun k => k.corporation == c).foldl (fun ids k => mergeIds ids k.answer.judgments) []

def members : Controller → List Nat
  | .person p => [p]
  | .group ms => ms

def sameMembers (a b : List Nat) : Bool := a.all (b.contains ·) && b.all (a.contains ·)

def shareholder (f : Facts) (c p : Nat) : Bool := f.holdings.any fun h => h.corporation == c && h.holder == p

/-- The persons together own at least 25% of the issued shares of a class of the corporation, other than a specified class. -/
def owns25 (f : Facts) (c : Nat) (ps : List Nat) : Bool :=
  (f.holdings.filter fun h => h.corporation == c && !h.specified).any fun h =>
    25 ≤ ((f.holdings.filter fun g => g.corporation == c && g.shareClass == h.shareClass && ps.contains g.holder).map (·.percent)).sum

def D (f : Facts) : List Link := relation f.world

/-- 251, with 256(1.5). -/
def related (f : Facts) (p q : Nat) : Bool := rel? (D f) p q

/-- (a): one controlled the other. -/
def paraA (f : Facts) : Bool :=
  (controllers f.world f.second).contains (.person f.first) || (controllers f.world f.first).contains (.person f.second)

/-- (b): the same person or group controlled both (256(1.2)(b)(i) for a group of shareholders of both). -/
def paraB (f : Facts) : Bool :=
  (controllers f.world f.first).any fun kx => (controllers f.world f.second).any fun ky =>
    sameMembers (members kx) (members ky) ||
      (let g := members kx ++ members ky
       2 ≤ g.eraseDups.length && g.all (shareholder f f.first) && g.all (shareholder f f.second))

/-- (c): each controlled by a person, the two related, and one of them owning 25% of a class of each. -/
def paraC (f : Facts) : Bool :=
  (controllers f.world f.first).any fun kx => (controllers f.world f.second).any fun ky =>
    match kx, ky with
    | .person p, .person q => related f p q &&
        ((owns25 f f.first [p] && owns25 f f.second [p]) || (owns25 f f.first [q] && owns25 f f.second [q]))
    | _, _ => false

/-- (d), one way: `x` controlled by a person related to each member of a group controlling `y`, who owns 25% of a class of `y`. -/
def paraDFrom (f : Facts) (x y : Nat) : Bool :=
  (controllers f.world x).any fun kx => (controllers f.world y).any fun ky =>
    match kx, ky with
    | .person p, .group ms => ms.all (related f p ·) && owns25 f y [p]
    | _, _ => false

def paraD (f : Facts) : Bool := paraDFrom f f.first f.second || paraDFrom f f.second f.first

/-- (e): each controlled by a related group, each member of one related to all of the other, and members of both owning 25% of a class of each. -/
def paraE (f : Facts) : Bool :=
  (controllers f.world f.first).any fun kx => (controllers f.world f.second).any fun ky =>
    match kx, ky with
    | .group gs, .group hs =>
        let both := gs.filter hs.contains
        relatedGroup (D f) gs && relatedGroup (D f) hs && gs.all (fun m => hs.all (related f m ·)) &&
          !both.isEmpty && owns25 f f.first both && owns25 f f.second both
    | _, _ => false

/-- 256(1): the two corporations are associated. -/
def associated (f : Facts) : Bool := paraA f || paraB f || paraC f || paraD f || paraE f

/-- For 125(2): associated with any of the other corporations. -/
def associatedWithAny (w : World) (holdings : List Holding) (c : Nat) (others : List Nat) : Bool :=
  others.any fun o => o != c && associated { world := w, holdings, first := c, second := o }

def judgments (f : Facts) : List String := mergeIds (controlJudgments f.world f.first) (controlJudgments f.world f.second)

def explain (f : Facts) : Finding :=
  let n := f.world.name
  let a := n f.first
  let b := n f.second
  let which : List (Bool × String × String) := [
    (paraA f, s!"One of {a} and {b} controls the other.", "ITA 256(1)(a)"),
    (paraB f, s!"{a} and {b} are controlled by the same person or group of persons.", "ITA 256(1)(b); 256(1.2)(b)(i)"),
    (paraC f, s!"{a} and {b} are each controlled by a person, the two are related, and one of them owns at least 25% of a class of the shares of each.", "ITA 256(1)(c)"),
    (paraD f, s!"One is controlled by a person related to each member of a group controlling the other, who owns at least 25% of a class of the other's shares.", "ITA 256(1)(d)"),
    (paraE f, s!"Each is controlled by a related group, every member of one related to all of the other, and members of both own at least 25% of a class of each.", "ITA 256(1)(e)")]
  let met := which.filter (·.1)
  ⟨associated f,
    (if met.isEmpty then [⟨s!"None of paragraphs 256(1)(a) to (e) applies to {a} and {b}: they are not associated.", "ITA 256(1)"⟩]
     else met.map fun (_, claim, cite) => ⟨claim, cite⟩) ++
    (if associated f then [⟨s!"So {a} is associated with {b}.", "ITA 256(1)"⟩] else []), judgments f⟩

/-! ## Truths -/

/-- (a): a corporation that controls another is associated with it. -/
theorem controls_other (f : Facts) (k : Control) (hk : k ∈ f.world.controls) (hc : k.corporation = f.second)
    (hp : k.controller = .person f.first) (ha : k.answer.value = true) : associated f = true := by
  have hm : Controller.person f.first ∈ controllers f.world f.second := by
    unfold controllers
    exact List.mem_map.mpr ⟨k, List.mem_filter.mpr ⟨hk, by simp [hc, ha]⟩, hp⟩
  simp [associated, paraA, hm]

private theorem same_self (a : List Nat) : sameMembers a a = true := by
  simp [sameMembers, List.all_eq_true]

/-- (b): two corporations controlled by the same controller are associated. -/
theorem same_controller (f : Facts) (k₁ k₂ : Control) (h₁ : k₁ ∈ f.world.controls) (h₂ : k₂ ∈ f.world.controls)
    (c₁ : k₁.corporation = f.first) (c₂ : k₂.corporation = f.second) (a₁ : k₁.answer.value = true)
    (a₂ : k₂.answer.value = true) (same : k₁.controller = k₂.controller) : associated f = true := by
  have m₁ : k₁.controller ∈ controllers f.world f.first :=
    List.mem_map.mpr ⟨k₁, List.mem_filter.mpr ⟨h₁, by simp [c₁, a₁]⟩, rfl⟩
  have m₂ : k₁.controller ∈ controllers f.world f.second :=
    List.mem_map.mpr ⟨k₂, List.mem_filter.mpr ⟨h₂, by simp [c₂, a₂]⟩, same.symm⟩
  have hb : paraB f = true := by
    unfold paraB
    exact List.any_eq_true.mpr ⟨_, m₁, List.any_eq_true.mpr ⟨_, m₂, by simp [same_self]⟩⟩
  simp [associated, hb]

/-- Without any controller, no association. -/
theorem uncontrolled (f : Facts) (h : controllers f.world f.first = []) (h' : controllers f.world f.second = []) :
    associated f = false := by
  simp [associated, paraA, paraB, paraC, paraD, paraDFrom, paraE, h, h']

end Canteen.ITA.Associated

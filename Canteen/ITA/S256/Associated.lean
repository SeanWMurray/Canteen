import Canteen.ITA.S251.RelatedPersons

/-!
# Associated corporations (256(1), (2))

*Income Tax Act*, as consolidated to 2026-10-29 (verbatim in `statute/ITA-256-1-2-5.1-associated.txt`):

**256(1.2)(d) to (f)** Shares owned (or deemed owned) by a holding corporation are deemed owned by each of
its shareholders in proportion to the value of the shareholder's shares of it; by a partnership, by its
members in proportion to their income shares; by a trust, by each discretionary beneficiary in full,
other beneficiaries by value, and the 75(2) contributor. **256(1.4)(a)** A person (or a partnership in
which the person has an interest) with a right to acquire shares, or to control their votes, is deemed
to own them, and they are deemed issued and outstanding, unless the right is exercisable only on a
death, bankruptcy or permanent disability. **256(1.3)** Shares owned by a
child under 18 are deemed owned by the parent, in determining association with a corporation the parent
(or a group including the parent) controls, unless the child manages the business without significant
influence from the parent.

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

**256(1.4)(b)** A right to cause the corporation to redeem other shareholders' shares: as if they were
redeemed. **256(2.1)** Corporations are deemed associated where one of the main reasons for their separate
existence is to reduce tax.

**256(2)** (a) Two corporations not otherwise associated are deemed associated if each is associated
(or deemed by this subsection associated) with the same third corporation; (b) for section 125, not if
the third corporation is not a CCPC, or is a CCPC that elects, in which case its business limit is nil.

"Controlled" is read from the world's controls, de facto control included (256(5.1)), as facts or
judgment calls; 256(1.2)(c) is the caller's to apply when stating them. "Related" is section 251 as
computed by `RelatedPersons` on the same world, with a person related to himself (256(1.5)). For (b),
two controllers are the same if they have the same members; by 256(1.2)(b)(i), they also count as the
same group when every member of either owns shares of both corporations. Shareholdings are given by
class, with whether the class is a specified class (256(1.1), a fact). For the 25% tests, shares owned
by a corporation, partnership or trust are deemed owned by its shareholders, members or beneficiaries
in the proportions of 256(1.2)(d) to (f), through any number of levels; a right to acquire shares makes
its holder their owner, and new shares issued and outstanding (256(1.4)(a)); and a parent is deemed to
own the shares of a child under 18 unless the child manages the corporation independently (256(1.3)).
A right to have another shareholder's shares redeemed puts its holder in the position as if they
were (256(1.4)(b)): they leave the class. 256(2.1) is a judgment call on the pair. For 256(2), the corporations to consider are listed; a chain of thirds of any
length is followed, and for section 125 every third on the chain must be a CCPC that has not elected.
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

/-- 256(1.2)(d) to (f): an interest in a holding entity, as a percentage: for a corporation, of the fair market
value of all its issued shares (d); for a partnership, the member's share of its income or loss (e); for
a trust, 100 for a beneficiary whose share depends on a discretion (f)(ii), otherwise the value of the
beneficial interest over that of all of them (f)(iii), and 100 for the person in 75(2) (f)(iv). -/
structure Equity where
  corporation : Nat
  holder : Nat
  percent : Nat
  deriving Repr, DecidableEq, Inhabited

/-- 256(1.3): a child under 18 at the time, and whether the child manages the corporation's business and
affairs without a significant degree of influence by the parent (usually a judgment call). -/
structure Minor where
  child : Nat
  independent : Answer := .fact false
  deriving Repr, DecidableEq, Inhabited

/-- 256(1.4)(a): a right to acquire shares of a class (or to control their votes), as a percentage of the
class's issued shares, whether the shares would be newly issued, and whether it is exercisable only on a
death, bankruptcy or permanent disability. -/
structure Right where
  corporation : Nat
  holder : Nat
  shareClass : String
  percent : Nat
  newShares : Bool := true
  onlyOnDeathOrDisability : Bool := false
  deriving Repr, DecidableEq, Inhabited

/-- 256(1.4)(b): a right to cause the corporation to redeem, acquire or cancel shares of a class owned by
another shareholder, as a percentage of the class's issued shares. -/
structure RedemptionRight where
  corporation : Nat
  holder : Nat
  shareClass : String
  /-- Whose shares. -/
  of : Nat
  percent : Nat
  onlyOnDeathOrDisability : Bool := false
  deriving Repr, DecidableEq, Inhabited

structure Facts where
  world : World
  holdings : List Holding := []
  rights : List Right := []
  redemptionRights : List RedemptionRight := []
  /-- 256(2.1): one of the main reasons for the corporations' separate existence is to reduce tax (or increase
  refundable investment tax credits). A judgment call. -/
  separateExistence : Answer := .fact false
  /-- For the look-through of 256(1.2)(d): the shareholders of each holding corporation, by value. -/
  equity : List Equity := []
  minors : List Minor := []
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

/-- 256(1.2)(d) to (f): `p`'s share of the holding entity `h`, in basis points: directly, and through
corporations, partnerships and trusts that hold interests in it (to the given depth). -/
def shareOf (f : Facts) (p : Nat) : Nat → Nat → Nat
  | 0, h => 100 * ((f.equity.filter fun e => e.corporation == h && e.holder == p).map (·.percent)).sum
  | k + 1, h => 100 * ((f.equity.filter fun e => e.corporation == h && e.holder == p).map (·.percent)).sum +
      ((f.equity.filter fun e => e.corporation == h && e.holder != p && !f.world.isKind .individual e.holder).map
        fun e => e.percent * shareOf f p k e.holder / 100).sum

/-- 256(1.4)(a): the rights that count (not those exercisable only on a death, bankruptcy or disability). -/
def rightsIn (f : Facts) (c : Nat) (cls : String) : List Right :=
  f.rights.filter fun r => r.corporation == c && r.shareClass == cls && !r.onlyOnDeathOrDisability

/-- `h`'s shares of a class, owned or deemed owned by a right, in basis points of the class as enlarged by
the new shares the rights are deemed to issue. -/
def classBp (f : Facts) (c : Nat) (cls : String) (h : Nat) : Nat :=
  let redeemed := f.redemptionRights.filter fun r => r.corporation == c && r.shareClass == cls && !r.onlyOnDeathOrDisability
  let base := 100 + (((rightsIn f c cls).filter (·.newShares)).map (·.percent)).sum - (redeemed.map (·.percent)).sum
  let held := ((f.holdings.filter fun g => g.corporation == c && g.shareClass == cls && g.holder == h).map (·.percent)).sum +
    (((rightsIn f c cls).filter (·.holder == h)).map (·.percent)).sum - ((redeemed.filter (·.of == h)).map (·.percent)).sum
  10000 * held / base

/-- The holders of a class, directly or by a right. -/
def holdersOf (f : Facts) (c : Nat) (cls : String) : List Nat :=
  ((f.holdings.filter fun g => g.corporation == c && g.shareClass == cls).map (·.holder) ++ (rightsIn f c cls).map (·.holder)).eraseDups

/-- The shares of a class of `c` that `p` owns or is deemed to own (256(1.2)(d) to (f), 256(1.4)(a)), in
basis points of the class. -/
def ownedBp (f : Facts) (c : Nat) (cls : String) (p : Nat) : Nat :=
  classBp f c cls p +
    (((holdersOf f c cls).filter fun h => h != p && !f.world.isKind .individual h).map
      fun h => classBp f c cls h * shareOf f p f.equity.length h / 10000).sum

/-- 256(1.3): the children under 18 of a parent, whose shares the parent is deemed to own when the other
corporation is controlled by the parent or by a group of which the parent is a member. -/
def minorsOf (f : Facts) (other parent : Nat) : List Nat :=
  if (controllers f.world other).any (fun k => (members k).contains parent) then
    (f.minors.filter fun m => !m.independent.value &&
      (f.world.children.contains (parent, m.child) || f.world.adoptions.contains (parent, m.child))).map (·.child)
  else []

/-- The persons together own (or are deemed to own) at least 25% of the issued shares of a class of the
corporation, other than a specified class. `other` is the corporation whose association is asked about. -/
def owns25 (f : Facts) (c : Nat) (ps : List Nat) : Bool :=
  let other := if c == f.first then f.second else f.first
  let owners := (ps ++ ps.flatMap (minorsOf f other)).eraseDups
  (f.holdings.filter fun h => h.corporation == c && !h.specified).any fun h =>
    2500 ≤ (owners.map (ownedBp f c h.shareClass)).sum

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

/-- 256(1), with 256(2.1): the two corporations are associated. -/
def associated (f : Facts) : Bool := paraA f || paraB f || paraC f || paraD f || paraE f || f.separateExistence.value

/-! ## Through a third corporation (256(2)) -/

/-- The corporations to consider together. -/
structure Group where
  world : World
  holdings : List Holding := []
  corporations : List Nat
  /-- Canadian-controlled private corporations among them. -/
  ccpcs : List Nat := []
  /-- 256(2)(b)(ii): CCPCs electing not to link the others, for section 125. -/
  electing : List Nat := []
  deriving Inhabited

/-- 256(1) between two of them. -/
def Group.direct (g : Group) (a b : Nat) : Bool := a != b && associated { world := g.world, holdings := g.holdings, first := a, second := b }

/-- A third corporation through which 256(2) links: for section 125, a CCPC that has not elected. -/
def Group.linksThrough (g : Group) (for125 : Bool) (t : Nat) : Bool :=
  !for125 || (g.ccpcs.contains t && !g.electing.contains t)

/-- One round: add the corporations associated with a reached corporation that may serve as a third. -/
def Group.expand (g : Group) (for125 : Bool) (start : Nat) (reached : List Nat) : List Nat :=
  reached ++ g.corporations.filter fun n => !reached.contains n && n != start &&
    reached.any fun v => (v == start || g.linksThrough for125 v) && g.direct v n

def Group.reachFrom (g : Group) (for125 : Bool) (start : Nat) : Nat → List Nat → List Nat
  | 0, r => r
  | k + 1, r => g.reachFrom for125 start k (g.expand for125 start r)

/-- Associated under 256(1), or deemed by 256(2) (for section 125 if `for125`). -/
def Group.associatedWith (g : Group) (for125 : Bool) (a b : Nat) : Bool :=
  a != b && (g.direct a b || (g.reachFrom for125 a g.corporations.length [a]).contains b)

/-- 256(2)(b)(ii): an electing third corporation's business limit is nil. -/
def Group.electedNil (g : Group) (c : Nat) : Bool := g.electing.contains c && g.ccpcs.contains c

/-- Associated directly is associated in the group. -/
theorem Group.direct_associated (g : Group) (for125 : Bool) (a b : Nat) (h : g.direct a b = true) :
    g.associatedWith for125 a b = true := by
  have hab : (a != b) = true := by unfold Group.direct at h; simp_all
  simp [Group.associatedWith, h, hab]

/-- For 125(2): associated with any of the other corporations. -/
def associatedWithAny (w : World) (holdings : List Holding) (c : Nat) (others : List Nat) : Bool :=
  others.any fun o => o != c && associated { world := w, holdings, first := c, second := o }

def judgments (f : Facts) : List String :=
  mergeIds (mergeIds (mergeIds (controlJudgments f.world f.first) (controlJudgments f.world f.second))
    (f.minors.foldl (fun ids m => mergeIds ids m.independent.judgments) [])) f.separateExistence.judgments

def explain (f : Facts) : Finding :=
  let n := f.world.name
  let a := n f.first
  let b := n f.second
  let which : List (Bool × String × String) := [
    (paraA f, s!"One of {a} and {b} controls the other.", "ITA 256(1)(a)"),
    (paraB f, s!"{a} and {b} are controlled by the same person or group of persons.", "ITA 256(1)(b); 256(1.2)(b)(i)"),
    (paraC f, s!"{a} and {b} are each controlled by a person, the two are related, and one of them owns at least 25% of a class of the shares of each.", "ITA 256(1)(c)"),
    (paraD f, s!"One is controlled by a person related to each member of a group controlling the other, who owns at least 25% of a class of the other's shares.", "ITA 256(1)(d)"),
    (paraE f, s!"Each is controlled by a related group, every member of one related to all of the other, and members of both own at least 25% of a class of each.", "ITA 256(1)(e)"),
    (f.separateExistence.value, s!"One of the main reasons for the separate existence of {a} and {b} is to reduce tax.", "ITA 256(2.1)")]
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

/-- Without any controller, and without 256(2.1), no association. -/
theorem uncontrolled (f : Facts) (h : controllers f.world f.first = []) (h' : controllers f.world f.second = [])
    (hs : f.separateExistence.value = false) : associated f = false := by
  simp [associated, paraA, paraB, paraC, paraD, paraDFrom, paraE, h, h', hs]

end Canteen.ITA.Associated

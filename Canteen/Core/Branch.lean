import Canteen.Core.Argument

/-!
# Branches

The three ways to handle a judgment call (design §4.5):

* **Assume:** build the facts from one registry of answers.
* **Branch:** `branches calls` lists every combination of answers. `analyzeBranches`
  applies a rule on each and reports its outcome and risk.
* **Make it irrelevant:** `Rule.SameOnEveryBranch` says a conclusion holds whatever
  the answers. It is decidable, so `by decide` proves it.

A branch is a registry (`List Judgment`) giving one answer to each judgment call.
Facts are built from the branch (`answerOf`), so the switches in the facts always
match the judgment calls reported alongside them.
-/

namespace Canteen

/-- A judgment call before it is answered: the question, and the risk of answering
it each way. -/
structure JudgmentCall where
  /-- Stable identifier, e.g. `"J-001"`. -/
  id : String
  /-- The question, in plain English. -/
  question : String
  /-- Confidence in answering "yes". -/
  riskIfYes : Risk
  /-- Confidence in answering "no". -/
  riskIfNo : Risk
  deriving Repr, DecidableEq, Inhabited

/-- Answer a judgment call one way. -/
def JudgmentCall.assume (c : JudgmentCall) (answer : Bool) : Judgment :=
  { id := c.id, question := c.question, answer := answer,
    risk := if answer then c.riskIfYes else c.riskIfNo }

/-- The answer to judgment call `id` on this branch. An id the branch does not
answer reads as `false`; `Rule.renderBranches` lists such ids as unregistered
whenever a finding relies on them. -/
def answerOf (branch : List Judgment) (id : String) : Bool :=
  match Judgment.find? branch id with
  | some j => j.answer
  | none => false

/-- Every combination of answers to `calls`, "yes" before "no", earlier calls varying slowest. -/
def branches : List JudgmentCall → List (List Judgment)
  | [] => [[]]
  | c :: cs => [true, false].flatMap fun b => (branches cs).map (c.assume b :: ·)

/-! ## Every branch really is every branch -/

theorem branches_length (cs : List JudgmentCall) : (branches cs).length = 2 ^ cs.length := by
  induction cs with
  | nil => rfl
  | cons c cs ih =>
    simp only [branches, List.flatMap_cons, List.flatMap_nil, List.append_nil,
      List.length_append, List.length_map, ih, List.length_cons, Nat.pow_succ]
    omega

/-- Every way of answering the calls is one of the branches. -/
theorem mem_branches (cs : List JudgmentCall) (answers : List Bool)
    (h : answers.length = cs.length) :
    List.zipWith JudgmentCall.assume cs answers ∈ branches cs := by
  induction cs generalizing answers with
  | nil =>
    cases answers with
    | nil => simp [branches]
    | cons _ _ => simp at h
  | cons c cs ih =>
    cases answers with
    | nil => simp at h
    | cons b bs =>
      simp only [List.length_cons, Nat.add_right_cancel_iff] at h
      simp only [List.zipWith_cons_cons, branches, List.mem_flatMap, List.mem_map]
      exact ⟨b, by cases b <;> simp, _, ih bs h, rfl⟩

/-- Each branch answers each call, in order. -/
theorem branch_ids (cs : List JudgmentCall) :
    ∀ b ∈ branches cs, b.map (·.id) = cs.map (·.id) := by
  induction cs with
  | nil => simp [branches]
  | cons c cs ih =>
    intro b hb
    simp only [branches, List.mem_flatMap, List.mem_map] at hb
    obtain ⟨_, _, b', hb', rfl⟩ := hb
    simp [JudgmentCall.assume, ih b' hb']

/-! ## Outcomes on each branch -/

/-- A rule's outcome on one branch. -/
structure BranchOutcome where
  /-- The answers on this branch. -/
  branch : List Judgment
  /-- The rule's finding on this branch. -/
  finding : Finding
  deriving Repr, DecidableEq

/-- The outcome's risk: the highest risk among the judgment calls the finding relies on. -/
def BranchOutcome.risk (o : BranchOutcome) : Risk :=
  findingRisk o.branch o.finding

/-- How a judgment call was answered on a branch, e.g. `"J-B = yes"`. -/
def describeBranch (branch : List Judgment) : String :=
  if branch.isEmpty then "no judgment calls"
  else ", ".intercalate (branch.map fun j => s!"{j.id} = {if j.answer then "yes" else "no"}")

/-- Each branch's argument, with its judgment calls and risk. Works for any argument
built from a branch, e.g. a whole series (`explainSeries`). -/
def renderEachBranch (calls : List JudgmentCall) (argOf : List Judgment → Argument) : String :=
  let parts := (branches calls).zipIdx.map fun (b, i) =>
    s!"Branch {i + 1} ({describeBranch b}):\n" ++ (argOf b).render b
  "\n\n".intercalate parts

namespace Rule

variable {Facts : Type}

/-- Apply the rule on every branch, building the facts from each branch's answers. -/
def analyzeBranches (r : Rule Facts) (calls : List JudgmentCall)
    (mk : List Judgment → Facts) : List BranchOutcome :=
  (branches calls).map fun b => ⟨b, r.explain (mk b)⟩

/-- The rule reaches conclusion `c` on every branch: the judgment calls in `calls`
don't affect the result (design §4.5, "make it irrelevant"). -/
def SameOnEveryBranch (r : Rule Facts) (calls : List JudgmentCall)
    (mk : List Judgment → Facts) (c : Bool) : Prop :=
  ∀ b ∈ branches calls, r.holds (mk b) = c

instance (r : Rule Facts) (calls : List JudgmentCall) (mk : List Judgment → Facts) (c : Bool) :
    Decidable (r.SameOnEveryBranch calls mk c) :=
  inferInstanceAs (Decidable (∀ b ∈ branches calls, r.holds (mk b) = c))

/-- The reported outcomes agree with the rule on every branch. -/
theorem analyzeBranches_sound (r : Rule Facts) (calls : List JudgmentCall)
    (mk : List Judgment → Facts) :
    ∀ o ∈ r.analyzeBranches calls mk, o.finding.conclusion = r.holds (mk o.branch) := by
  intro o ho
  simp only [analyzeBranches, List.mem_map] at ho
  obtain ⟨b, _, rfl⟩ := ho
  simp

/-- A conclusion reached on every branch is reached however the calls are answered. -/
theorem SameOnEveryBranch.holds {r : Rule Facts} {calls : List JudgmentCall}
    {mk : List Judgment → Facts} {c : Bool} (h : r.SameOnEveryBranch calls mk c)
    (answers : List Bool) (hlen : answers.length = calls.length) :
    r.holds (mk (List.zipWith JudgmentCall.assume calls answers)) = c :=
  h _ (mem_branches calls answers hlen)

/-- Each branch's argument and risk, then a summary of how many branches the rule
applies on and whether the judgment calls matter. -/
def renderBranches (r : Rule Facts) (calls : List JudgmentCall)
    (mk : List Judgment → Facts) : String :=
  let outcomes := r.analyzeBranches calls mk
  let verdict (b : Bool) := if b then s!"{r.name} applies" else s!"{r.name} does not apply"
  let parts := outcomes.zipIdx.map fun (o, i) =>
    s!"Branch {i + 1} ({describeBranch o.branch}):\n" ++
      "\n".intercalate (renderSteps 1 o.finding.steps) ++
      s!"\nConclusion: {verdict o.finding.conclusion}. Risk: {o.risk}."
  let yes := (outcomes.filter (·.finding.conclusion)).length
  let n := outcomes.length
  let summary :=
    if yes = n then s!"Summary: {verdict true} on every branch, so the judgment calls do not affect the conclusion."
    else if yes = 0 then s!"Summary: {verdict false} on any branch, so the judgment calls do not affect the conclusion."
    else s!"Summary: {r.name} applies on {yes} of {n} branches, so the conclusion depends on the judgment calls."
  "\n\n".intercalate (parts ++ [summary])

end Rule

end Canteen

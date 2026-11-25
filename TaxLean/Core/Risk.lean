/-!
# Risk

How confident we are in the answer to a judgment call (design §4.3).
Risks are totally ordered `low < medium < high` via `Risk.rank`, and a
conclusion resting on several judgment calls takes the highest of their risks
(`Risk.max`).
-/

namespace TaxLean

/-- Confidence in the answer assumed for a judgment call. -/
inductive Risk where
  | low
  | medium
  | high
  deriving Repr, DecidableEq, Inhabited

namespace Risk

/-- Numeric rank used to order risks: `low = 0`, `medium = 1`, `high = 2`. -/
def rank : Risk → Nat
  | .low => 0
  | .medium => 1
  | .high => 2

/-- The higher of two risks. -/
def max (a b : Risk) : Risk :=
  if a.rank ≥ b.rank then a else b

/-- Lower-case English name, used when rendering findings. -/
def name : Risk → String
  | .low => "low"
  | .medium => "medium"
  | .high => "high"

instance : ToString Risk := ⟨Risk.name⟩

/-! ## Basic facts about `Risk.max` -/

theorem rank_injective {a b : Risk} (h : a.rank = b.rank) : a = b := by
  cases a <;> cases b <;> first | rfl | (simp [rank] at h)

theorem max_comm (a b : Risk) : a.max b = b.max a := by
  cases a <;> cases b <;> rfl

theorem max_assoc (a b c : Risk) : (a.max b).max c = a.max (b.max c) := by
  cases a <;> cases b <;> cases c <;> rfl

theorem max_self (a : Risk) : a.max a = a := by
  cases a <;> rfl

theorem low_max (a : Risk) : Risk.low.max a = a := by
  cases a <;> rfl

theorem max_low (a : Risk) : a.max .low = a := by
  cases a <;> rfl

theorem high_max (a : Risk) : Risk.high.max a = .high := by
  cases a <;> rfl

theorem max_high (a : Risk) : a.max .high = .high := by
  cases a <;> rfl

/-- The combined risk is at least as high as either input. -/
theorem le_max_left (a b : Risk) : a.rank ≤ (a.max b).rank := by
  cases a <;> cases b <;> decide

theorem le_max_right (a b : Risk) : b.rank ≤ (a.max b).rank := by
  cases a <;> cases b <;> decide

/-- `max` always returns one of its inputs: combining risks never invents a new one. -/
theorem max_eq_or (a b : Risk) : a.max b = a ∨ a.max b = b := by
  cases a <;> cases b <;> decide

end Risk

end TaxLean

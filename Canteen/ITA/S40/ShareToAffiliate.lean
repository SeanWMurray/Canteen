import Canteen.Core.StatuteSyntax
import Canteen.ITA.S251_1.AffiliatedPersons

/-!
# Subsection 40(3.6) and paragraph 53(1)(f.2): a share disposed of to an affiliated corporation

*Income Tax Act*, as consolidated to 2026-10-29 (verbatim in `statute/ITA-40-3.6-2-e.1.txt`):

> (3.6) If at any time a taxpayer disposes, to a corporation that is affiliated with the taxpayer
> immediately after the disposition, of a share of a class of the capital stock of the
> corporation (other than a share that is a distress preferred share … and other than … excluded
> property …), (a) the taxpayer's loss, if any, from the disposition is deemed to be nil; and
> (b) in computing the adjusted cost base … of a share of a class of the capital stock of the
> corporation owned by the taxpayer immediately after the disposition, there shall be added the
> proportion of the amount of the taxpayer's loss … that (i) the fair market value, immediately
> after the disposition, of the share is of (ii) the fair market value, immediately after the
> disposition, of all shares of the capital stock of the corporation owned by the taxpayer.

53(1)(f.2) adds the amount in 40(3.6)(b) to the adjusted cost base. Affiliation "immediately
after the disposition" is decided by section 251.1 on the world as it is then.
-/

namespace Canteen.ITA.ShareToAffiliate

open SuperficialLoss AffiliatedPersons

/-- The facts 40(3.6) needs. -/
structure Facts where
  /-- The world immediately after the disposition. -/
  world : World
  taxpayer : Nat
  /-- The corporation the share is disposed of to. -/
  corporation : Nat
  disposition : Disposition
  /-- The property is a share of a class of the capital stock of that corporation. -/
  shareOfCorporation : Bool
  /-- A distress preferred share (80(1)). -/
  distressPreferred : Bool := false
  /-- The foreign affiliate surplus carve-out (excluded property). -/
  surplusExcludedProperty : Bool := false
  /-- The corporation's shares the taxpayer owns immediately after, with their fair market values. -/
  holdingsAfter : List (String × Cents) := []

/-- The two persons, for section 251.1. -/
def query (f : Facts) : AffiliatedPersons.Query := ⟨f.world, f.taxpayer, f.corporation⟩

/-- Subsection 40(3.6). -/
statute applies (f : Facts) named "subsection 40(3.6)" cites "ITA 40(3.6)"
  applies where
    | "share" f.shareOfCorporation
        => "The taxpayer disposed of a share of a class of the capital stock of the corporation to that corporation."
        else "The property is not a share of the capital stock of the corporation it was disposed of to."
    | "affiliated immediately after" := (AffiliatedPersons.rule.comap query)
  except where
    | "distress preferred share" f.distressPreferred
        => "The share is a distress preferred share."
        else "The share is not a distress preferred share."
    | "surplus carve-out" f.surplusExcludedProperty
        => "For the purposes of computing a foreign affiliate's surplus or deficit, the share is excluded property."
        else "The share is not excluded property being considered in computing a foreign affiliate's surplus or deficit."

/-- (a): the loss is deemed nil. -/
def denied (f : Facts) : Bool := applies.holds f && isLoss f.disposition

/-- (b) and 53(1)(f.2): the loss, spread over the shares the taxpayer owns immediately after, in
proportion to their fair market values (each rounded down to the cent). -/
def additions (f : Facts) : List (String × Cents) :=
  let total := f.holdingsAfter.foldl (· + ·.2) 0
  if denied f && total > 0 then f.holdingsAfter.map fun (d, v) => (d, lossAmount f.disposition * v / total) else []

def explain (f : Facts) : Finding :=
  let e := applies.explain f
  let tail : List Step :=
    if !denied f then
      if applies.holds f then [⟨"There is no loss, so nothing is deemed nil.", "ITA 40(3.6)(a)"⟩] else []
    else
      [⟨s!"So the taxpayer's loss of {formatCents (lossAmount f.disposition)} is deemed to be nil.", "ITA 40(3.6)(a)"⟩] ++
      (additions f).map fun (d, a) =>
        (⟨s!"{formatCents a} is added to the adjusted cost base of {d}, in proportion to its fair market value.",
          "ITA 40(3.6)(b); 53(1)(f.2)"⟩ : Step)
  ⟨denied f, e.steps ++ tail, e.reliesOn⟩

theorem explain_sound (f : Facts) : (explain f).conclusion = denied f := rfl

/-- Subsection 40(3.6), as a rule: the loss is nil. -/
def rule : Rule Facts where
  name := "subsection 40(3.6)"
  citation := "ITA 40(3.6)"
  holds := denied
  explain := explain
  sound := explain_sound

private theorem le_foldl_of_mem (l : List (String × Cents)) (d : String) (v : Cents) (acc : Cents)
    (h : (d, v) ∈ l) : v ≤ l.foldl (· + ·.2) acc := by
  have grow : ∀ (ys : List (String × Cents)) (a : Cents), a ≤ ys.foldl (· + ·.2) a := by
    intro ys; induction ys with
    | nil => intro a; exact Nat.le_refl a
    | cons y ys ih => intro a; exact Nat.le_trans (Nat.le_add_right a y.2) (ih _)
  induction l generalizing acc with
  | nil => simp at h
  | cons x xs ih =>
    simp only [List.foldl_cons]
    rcases List.mem_cons.mp h with rfl | h
    · exact Nat.le_trans (Nat.le_add_left v acc) (grow xs _)
    · exact ih _ h

/-- No addition exceeds the loss. -/
theorem addition_le_loss (f : Facts) : ∀ p ∈ additions f, p.2 ≤ lossAmount f.disposition := by
  intro p hp
  dsimp only [additions] at hp
  split at hp
  · rename_i h
    simp only [List.mem_map] at hp
    obtain ⟨⟨d, v⟩, hm, rfl⟩ := hp
    have hv := le_foldl_of_mem f.holdingsAfter d v 0 hm
    show lossAmount f.disposition * v / _ ≤ _
    apply Nat.div_le_of_le_mul
    rw [Nat.mul_comm (List.foldl _ _ _)]
    exact Nat.mul_le_mul_left _ hv
  · simp at hp

/-- Where the taxpayer is not affiliated with the corporation immediately after, nothing is denied. -/
theorem not_of_not_affiliated (f : Facts) (h : affiliated (query f) = false) : denied f = false := by
  simp [denied, applies, AffiliatedPersons.rule, h]

end Canteen.ITA.ShareToAffiliate

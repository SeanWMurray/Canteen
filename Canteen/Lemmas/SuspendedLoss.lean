import Canteen.ITA.S40.SuspendedLoss

/-!
# Layer 2: reusable truths about suspended losses (40(3.3), (3.4))
-/

namespace Canteen.ITA.SuspendedLoss

open SuperficialLoss

/-- If every acquisition is outside the period, made by someone not affiliated with the
transferor, or not owned at the end of the period, no loss is suspended. -/
theorem not_of_all_fail (f : Facts)
    (h : ∀ a ∈ f.acquisitions, f.disposition.date.withinDaysAround a.date 30 = false ∨
      a.acquirer.isTaxpayerOrAffiliated = false ∨ a.ownedAtEndOfPeriod = false) :
    suspended f = false := by
  have hq : f.acquisitions.any (qualifies f.disposition) = false := by
    rw [List.any_eq_false]
    intro a ha
    rcases h a ha with h | h | h <;> simp [qualifies, h]
  simp [suspended, applies, hq]

/-- The 31-day safe harbour, for a corporation, trust or partnership. -/
theorem safe_harbour (f : Facts)
    (h : ∀ a ∈ f.acquisitions, f.disposition.date.toDays + 30 < a.date.toDays) :
    suspended f = false :=
  not_of_all_fail f fun a ha => .inl (by
    have := h a ha
    simp only [Date.withinDaysAround, Bool.and_eq_false_iff, decide_eq_false_iff_not]
    right; omega)

/-- A suspended loss is always the whole loss on the disposition. -/
theorem suspendedLoss_of_suspended (f : Facts) (h : suspended f = true) :
    suspendedLoss f = lossAmount f.disposition := by
  simp [suspendedLoss, h]

end Canteen.ITA.SuspendedLoss

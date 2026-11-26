import Canteen.ITA.S54.SuperficialLoss

/-!
# Layer 2: reusable truths about the superficial loss definition

Proven once, for every set of facts, and reusable in any later transaction.
-/

namespace Canteen.ITA.SuperficialLoss

/-- The definition, restated as a proposition that reads like the statute: there is a
loss, some acquired property meets paragraphs (a) and (b), and the disposition is not
excepted by (c) to (h). -/
theorem superficialLoss_iff (f : Facts) :
    superficialLoss f = true ↔
      isLoss f.disposition = true ∧
      (∃ a ∈ f.acquisitions, paraA f.disposition a = true ∧ paraB a = true) ∧
      excepted f.disposition = false := by
  simp [superficialLoss, qualifies, List.any_eq_true, and_assoc]

/-- No loss, no superficial loss. -/
theorem not_of_no_loss (f : Facts) (h : isLoss f.disposition = false) :
    superficialLoss f = false := by
  simp [superficialLoss, h]

/-- A disposition excepted by any of paragraphs (c) to (h) never gives a superficial
loss, whatever was acquired and however the identity judgment calls are answered. -/
theorem not_of_excepted (f : Facts) (h : excepted f.disposition = true) :
    superficialLoss f = false := by
  simp [superficialLoss, h]

/-- Paragraph (d): the expiry of an option never gives a superficial loss. -/
theorem not_of_option_expiry (f : Facts) (h : f.disposition.optionExpiry = true) :
    superficialLoss f = false :=
  not_of_excepted f (by simp [excepted, paraD, h])

/-- Paragraph (c): a disposition deemed by section 70 (death) never gives a superficial loss. -/
theorem not_of_death (f : Facts) (h : f.disposition.deemedBy = some .s70) :
    superficialLoss f = false :=
  not_of_excepted f (by simp [excepted, paraC, h, DeemingProvision.listedInC])

/-- If nothing was acquired, there is no superficial loss. -/
theorem not_of_no_acquisitions (f : Facts) (h : f.acquisitions = []) :
    superficialLoss f = false := by
  simp [superficialLoss, h]

/-- An acquisition outside the 61-day period never matters, whoever made it and whatever
it is. -/
theorem outside_period_irrelevant (d : Disposition) (as : List Acquisition) (a : Acquisition)
    (h : inPeriod d a = false) :
    superficialLoss ⟨d, a :: as⟩ = superficialLoss ⟨d, as⟩ := by
  simp [superficialLoss, qualifies, paraA, h]

/-- An acquisition no longer held at the end of the period never matters: in particular,
the judgment call on whether it is identical makes no difference. -/
theorem not_held_irrelevant (d : Disposition) (as : List Acquisition) (a : Acquisition)
    (h : a.heldAtEndOfPeriod = false) :
    superficialLoss ⟨d, a :: as⟩ = superficialLoss ⟨d, as⟩ := by
  simp [superficialLoss, qualifies, paraB, h]

/-- Acquisitions by persons not affiliated with the taxpayer never matter. -/
theorem not_affiliated_irrelevant (d : Disposition) (as : List Acquisition) (a : Acquisition)
    (who : String) (h : a.acquirer = .notAffiliated who) :
    superficialLoss ⟨d, a :: as⟩ = superficialLoss ⟨d, as⟩ := by
  simp [superficialLoss, qualifies, paraA, h, Acquirer.isTaxpayerOrAffiliated]

/-- More acquisitions can only make a loss superficial, never the reverse. -/
theorem mono_acquisitions (d : Disposition) (as bs : List Acquisition)
    (h : superficialLoss ⟨d, as⟩ = true) : superficialLoss ⟨d, as ++ bs⟩ = true := by
  simp only [superficialLoss, Bool.and_eq_true, Bool.not_eq_true', List.any_append,
    Bool.or_eq_true] at h ⊢
  exact ⟨⟨h.1.1, .inl h.1.2⟩, h.2⟩

/-- Paragraph (i): a right to acquire the particular property, other than a security-only
right, is treated as identical to it. -/
theorem right_to_acquire_identical (a : Acquisition) (h : a.identity = .rightToAcquire false) :
    isOrIsIdentical a = true := by
  simp [isOrIsIdentical, h]

/-- Paragraph (j) stops applying to SIFT wind-up shares acquired in 2013 or later. -/
theorem sift_share_after_2012 (a : Acquisition) (h : a.identity = .siftWindUpShare)
    (hd : acquiredBefore2013 a = false) : isOrIsIdentical a = false := by
  simp [isOrIsIdentical, h, hd]

/-! ## Planning a sale at a loss -/

/-- If every acquisition is outside the period, made by someone not affiliated with the
taxpayer, or not held at the end of the period, the loss is not superficial, however any
identity or affiliation judgment calls are answered. -/
theorem not_of_all_fail (f : Facts)
    (h : ∀ a ∈ f.acquisitions, inPeriod f.disposition a = false ∨
      a.acquirer.isTaxpayerOrAffiliated = false ∨ a.heldAtEndOfPeriod = false) :
    superficialLoss f = false := by
  simp only [superficialLoss, Bool.and_eq_false_iff]
  left; right
  rw [List.any_eq_false]
  intro a ha
  rcases h a ha with h | h | h <;> simp [qualifies, paraA, paraB, h]

/-- **The 31-day safe harbour.** If nothing is acquired, by anyone, in the 30 days before the
disposition, and every repurchase is on day 31 or later, the loss is not superficial. -/
theorem safe_harbour (f : Facts)
    (h : ∀ a ∈ f.acquisitions, f.disposition.date.toDays + 30 < a.date.toDays) :
    superficialLoss f = false :=
  not_of_all_fail f fun a ha => .inl (by
    have := h a ha
    simp only [inPeriod, Date.withinDaysAround, Bool.and_eq_false_iff, decide_eq_false_iff_not]
    right; omega)

end Canteen.ITA.SuperficialLoss

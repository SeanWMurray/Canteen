import Canteen.ITA.S40.SuspendedLoss
import Canteen.ITA.S251_1.AffiliatedPersons

/-!
# Layer 3: a company sells shares at a loss, and its sister company buys them

A constructed transaction under subsections 40(3.3) to (3.5) and section 251.1.

* Ann controls both Opco and Sisterco.
* 2025-08-01: Opco sells 1,000 common shares of PQR Ltd. for $20,000.00. Adjusted cost base
  $35,000.00.
* 2025-08-15: Sisterco buys 1,000 common shares of PQR Ltd.
* 2026-02-02: Sisterco sells them to an unrelated buyer; neither Opco nor Sisterco owns any
  for at least 30 days after.
-/

namespace Canteen.Transactions.SisterCompanyRepurchase

open Canteen Canteen.ITA Canteen.ITA.AffiliatedPersons

def ann : Nat := 0
def opco : Nat := 1
def sisterco : Nat := 2

/-- Ann controls both companies. -/
def world : World :=
  { persons := [⟨ann, "Ann", .individual⟩, ⟨opco, "Opco", .corporation⟩, ⟨sisterco, "Sisterco", .corporation⟩],
    controls := [⟨opco, .person ann, .fact true, false⟩, ⟨sisterco, .person ann, .fact true, false⟩] }

def sale : SuperficialLoss.Disposition :=
  { description := "1,000 common shares of PQR Ltd.", date := ⟨2025, 8, 1⟩,
    proceeds := 2000000, adjustedCostBase := 3500000, outlaysAndExpenses := 0 }

def sisterPurchase : SuspendedLoss.Acquisition :=
  { description := "1,000 common shares of PQR Ltd.", date := ⟨2025, 8, 15⟩,
    acquirer := AffiliatedPersons.acquirer world opco sisterco, identity := .same, ownedAtEndOfPeriod := true }

/-- The facts: a corporation's disposition of capital property, Sisterco's purchase, and the
first release time: Sisterco's sale on 2026-02-02 starts a 30-day period without the shares. -/
def facts : SuspendedLoss.Facts :=
  { transferor := .corporation, disposition := sale, acquisitions := [sisterPurchase],
    release := { thirtyDaysWithout := some ⟨2026, 2, 2⟩ } }

/-- The same, before Sisterco sells: the loss is not yet released. -/
def factsBeforeRelease : SuspendedLoss.Facts := { facts with release := {} }

/-! ## Analysis -/

/-- Opco and Sisterco are affiliated: each is controlled by Ann (251.1(1)(c)(i)), on the facts. -/
theorem companies_affiliated :
    affiliated ⟨world, opco, sisterco⟩ = true ∧ (rule.explain ⟨world, opco, sisterco⟩).reliesOn = [] := by
  decide +kernel

theorem loss_amount : SuperficialLoss.isLoss sale = true ∧ SuperficialLoss.lossAmount sale = 1500000 := by decide

/-- Subsection 40(3.3) applies. -/
theorem applies : SuspendedLoss.applies.holds facts = true := by decide +kernel

/-- So the $15,000.00 loss is nil now, and suspended. -/
theorem suspended : SuspendedLoss.suspended facts = true ∧ SuspendedLoss.suspendedLoss facts = 1500000 := by
  decide +kernel

/-- It is released immediately before 2026-02-02, when Sisterco's sale starts a 30-day period
throughout which neither company owns the shares. -/
theorem released : SuspendedLoss.releaseDate facts = some ⟨2026, 2, 2⟩ := by decide +kernel

/-- Before Sisterco sells, nothing has released it. -/
theorem not_yet_released : SuspendedLoss.releaseDate factsBeforeRelease = none := by decide +kernel

/-- And the loss is not also a superficial loss: paragraph (h) of that definition defers to 40(3.4). -/
theorem not_superficial :
    SuperficialLoss.superficialLoss ⟨SuspendedLoss.withSuspension facts,
      [{ description := "1,000 common shares of PQR Ltd.", date := ⟨2025, 8, 15⟩,
         acquirer := AffiliatedPersons.acquirer world opco sisterco, identity := .same, heldAtEndOfPeriod := true }]⟩ = false :=
  SuspendedLoss.not_superficial_of_applies _ _ applies

end Canteen.Transactions.SisterCompanyRepurchase

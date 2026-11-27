import Canteen.Core.Money

/-!
# The tuition credit (118.5(1)(a)), its carryforward (118.61) and its transfer (118.81, 118.9)

*Income Tax Act*, as consolidated to 2026-10-29 (verbatim in `statute/ITA-118.5-118.61-118.81-118.9.txt`):

* **118.5(1)(a)** a student at a post-secondary (or certified occupational) institution in Canada
  deducts 14% of the tuition fees paid for the year (with exceptions for courses not at the
  post-secondary level and students under 16).
* **118.61(2)** the unused credits carried from earlier years may be deducted, up to the year's tax
  after the credits in 118(1) to (10), 118.01 to 118.07, 118.3 and 118.7; **(1)** what is unused at the
  end of the year: the amount carried in, plus the year's 118.5 credit not needed against tax (B − C),
  less what was deducted from the carryforward (D) and what was transferred (E).
* **118.81** the tuition tax credit transferred: the lesser of the year's 118.5 credit, up to 14% of
  $5,000, less the student's tax after the credits in 118 to 118.07, 118.3, 118.61 and 118.7, and the
  amount the student designates; **118.9** a parent or grandparent who is the only person designated
  (where no spouse claims for the student) deducts it.

The credits are applied in that order: carried-forward credits, then the year's, then the transfer
(118.92). Whether the fees qualify is a fact. The appropriate percentage is 14% each year, so 118.61(4)
does not change anything. Amounts are credits (14% of fees), in cents, rounded down.
-/

namespace Canteen.ITA.Tuition

/-- 118.5(1)(a): 14% of the qualifying tuition fees. -/
def credit (fees : Cents) : Cents := fees * 1400 / 10000

/-- 118.61(2): the carryforward deducted, given the tax left after the earlier credits. -/
def carryforwardUsed (carried taxLeft : Cents) : Cents := min carried taxLeft

/-- 118.61(1) C: the year's credit used against the tax left after the carryforward. -/
def currentUsed (yearCredit taxLeft carriedUsed : Cents) : Cents := min yearCredit (taxLeft - carriedUsed)

/-- 118.81: the transfer, the lesser of (a) the year's credit up to $700 less the tax left, and (b) the
amount designated. -/
def transferred (yearCredit taxLeft carriedUsed designated : Cents) : Cents :=
  min designated (min yearCredit 70000 - (taxLeft - carriedUsed))

/-- 118.61(1): unused at the end of the year, A + (B − C) − (D + E). -/
def unused (carried yearCredit taxLeft designated : Cents) : Cents :=
  let d := carryforwardUsed carried taxLeft
  let c := currentUsed yearCredit taxLeft d
  let e := transferred yearCredit taxLeft d designated
  carried + (yearCredit - c) - (d + e)

/-! ## Truths -/

/-- The transfer never exceeds $700 (14% of $5,000). -/
theorem transferred_le (y t u d : Cents) : transferred y t u d ≤ 70000 :=
  Nat.le_trans (Nat.min_le_right _ _) (Nat.le_trans (Nat.sub_le _ _) (Nat.min_le_right _ _))

private theorem conserve (a y t d : Nat) :
    min a t + min y (t - min a t) + min d (min y 70000 - (t - min a t)) + (a + (y - min y (t - min a t)) -
      (min a t + min d (min y 70000 - (t - min a t)))) = a + y := by omega

/-- Nothing is lost or created: what is carried in plus the year's credit equals what is used, what is
transferred, and what is carried out. -/
theorem conservation (a y t d : Cents) :
    carryforwardUsed a t + currentUsed y t (carryforwardUsed a t) + transferred y t (carryforwardUsed a t) d +
      unused a y t d = a + y := conserve a y t d

end Canteen.ITA.Tuition

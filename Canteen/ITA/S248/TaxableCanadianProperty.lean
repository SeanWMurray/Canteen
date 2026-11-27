import Canteen.Core.Finding

/-!
# 248(1) "taxable Canadian property"

*Income Tax Act*, as consolidated to 2026-10-29 (verbatim in `statute/ITA-248-1-taxable-canadian-property.txt`):

Taxable Canadian property of a taxpayer at a time is (a) real or immovable property in Canada; (b)
property used or held in, or inventory of, a business carried on in Canada (other than insurance
business property and, for a non-resident, international ships and aircraft where the home country
reciprocates); (c) an insurer's designated insurance property; (d) an unlisted share (not of a mutual
fund corporation), or an interest in a partnership or trust (other than a mutual fund trust unit or an
income interest in a resident trust), if at any time in the 60 months before, more than 50% of its fair
market value was derived from real property in Canada, Canadian resource property, timber resource
property, or options and interests in them; (e) a listed share, a mutual fund corporation share or a
mutual fund trust unit, if at some time in the 60 months both (i) the taxpayer, non-arm's length persons
and their partnerships owned 25% or more of the issued shares of a class (or units), and (ii) the 50%
value test was met; or (f) an option or interest in any of these. (g) to (k), for certain purposes only,
are not encoded.

For (d) and (e) each month of the 60-month period is given: the percentage of the property's value
derived from the listed properties (directly or indirectly, otherwise than through entities whose
shares or interests were not themselves taxable Canadian property, which the caller excludes), and for
(e) the percentage held by the taxpayer and its non-arm's length group. Exactly 50% is not "more than 50%".
-/

namespace Canteen.ITA.TaxableCanadianProperty

/-- A month in the 60-month period. -/
structure Snapshot where
  /-- The percentage of fair market value derived from Canadian real, resource and timber property. -/
  fromCanadianProperty : Nat
  /-- (e)(i): the percentage of the class (or units) owned by the taxpayer, non-arm's length persons and their partnerships. -/
  groupHolding : Nat := 0
  deriving Repr, DecidableEq, Inhabited

inductive Property where
  /-- (a) -/
  | realProperty (inCanada : Bool)
  /-- (b): used or held in, or inventory of, a business carried on in Canada; or not. -/
  | businessProperty (canadianBusiness : Bool) (insuranceBusiness : Bool := false) (internationalShipOrAircraftExempt : Bool := false)
  /-- (c) -/
  | designatedInsuranceProperty
  /-- (d): an unlisted share, or a partnership or trust interest (not excluded), with the 60 months. -/
  | unlisted (months : List Snapshot)
  /-- (d)'s exclusions: a mutual fund trust unit is under (e); an income interest in a resident trust is out. -/
  | incomeInterest
  /-- (e): a listed share, a mutual fund corporation share, or a mutual fund trust unit, with the 60 months. -/
  | listed (months : List Snapshot)
  /-- (f): an option on, or interest in, another property. -/
  | option (underlying : Property)
  | other
  deriving Repr, DecidableEq, Inhabited

def Property.isTCP : Property → Bool
  | .realProperty c => c
  | .businessProperty c ins ship => c && !ins && !ship
  | .designatedInsuranceProperty => true
  | .unlisted ms => ms.any (50 < ·.fromCanadianProperty)
  | .incomeInterest => false
  | .listed ms => ms.any fun m => 25 ≤ m.groupHolding && 50 < m.fromCanadianProperty
  | .option p => p.isTCP
  | .other => false

def Property.paragraph : Property → String
  | .realProperty _ => "(a)"
  | .businessProperty .. => "(b)"
  | .designatedInsuranceProperty => "(c)"
  | .unlisted _ | .incomeInterest => "(d)"
  | .listed _ => "(e)"
  | .option _ => "(f)"
  | .other => ""

def explain (p : Property) : Finding :=
  ⟨p.isTCP, [⟨(if p.isTCP then s!"The property is taxable Canadian property under paragraph {p.paragraph}."
      else "The property is not taxable Canadian property.") ++
      (match p with
       | .unlisted _ => " (More than 50% of its value derived from Canadian real, resource or timber property at some time in the last 60 months is the test.)"
       | .listed _ => " (The test is 25% held by the taxpayer and its non-arm's length group together with the 50% value test, at the same time in the last 60 months.)"
       | _ => ""),
    s!"ITA 248(1) \"taxable Canadian property\" {p.paragraph}"⟩], []⟩

/-! ## Truths -/

/-- An unlisted share whose value never came more than half from Canadian real property in 60 months is not. -/
theorem unlisted_below_half (ms : List Snapshot) (h : ∀ m ∈ ms, m.fromCanadianProperty ≤ 50) : (Property.unlisted ms).isTCP = false := by
  simp only [Property.isTCP, List.any_eq_false, decide_eq_true_eq, Nat.not_lt]
  exact h

/-- A listed share held under 25% throughout is never taxable Canadian property, whatever its assets. -/
theorem listed_small_holding (ms : List Snapshot) (h : ∀ m ∈ ms, m.groupHolding < 25) : (Property.listed ms).isTCP = false := by
  simp only [Property.isTCP, List.any_eq_false, Bool.and_eq_true, decide_eq_true_eq, not_and]
  intro m hm h25; exact absurd h25 (Nat.not_le.mpr (h m hm))

/-- An option is taxable Canadian property exactly when what it is over is. -/
theorem option_iff (p : Property) : (Property.option p).isTCP = p.isTCP := rfl

end Canteen.ITA.TaxableCanadianProperty

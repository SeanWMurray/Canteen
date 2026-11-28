import Canteen.ITA.S38.CapitalGains
import Canteen.ITA.S248.TaxableCanadianProperty

/-!
# Section 128.1: becoming resident (128.1(1)(b), (c)) and ceasing to be resident (128.1(4)(b), (c))

*Income Tax Act*, as consolidated to 2026-10-29 (verbatim in `statute/ITA-128.1-1-4-b-c.txt`):

**128.1(1)(b)** A taxpayer who becomes resident in Canada is deemed to have disposed, immediately before,
of each property owned, for its fair market value, other than, for an individual, (i) taxable Canadian
property, (ii) inventory of a business carried on in Canada, (iii) Class 14.1 property of such a
business, and (iv) an excluded right or interest (other than one in 128.1(10)(k)). **(c)** It is deemed
to have acquired each such property at a cost equal to the proceeds. The disposition is made while
non-resident, so for property other than taxable Canadian property its effect is the new cost.

**128.1(4)(b)** A taxpayer who ceases to be resident in Canada is deemed to have disposed, immediately
before, of each property owned, for proceeds equal to its fair market value, other than, for an
individual, (i) real or immovable property in Canada, Canadian resource and timber resource property,
(ii) capital property, Class 14.1 property and inventory of a business carried on through a permanent
establishment in Canada, (iii) an excluded right or interest (pensions, RRSPs, TFSAs, employee options
and the others 128.1(10) lists), (iv) for an individual (not a trust) resident in Canada for no more than
60 of the 120 months before, property owned on last becoming resident or inherited since, and (v)
property elected under 128.1(6)(a) on a later return to Canada. **(c)** Each property so disposed of is
reacquired at a cost equal to the proceeds.

For an individual. Each property's class under (i) to (v) is given; the gains and losses go into the
section 38 computation (`CapitalGains`) as dispositions on capital account. The security election
(220(4.5)), the 128.1(4)(d) election for property in (i) and (ii), (b.1), (6) to (8) and the corporate
and trust rules ((a), (4)(e) and (5)) are not encoded.
-/

namespace Canteen.ITA.Emigration

open CapitalGains (Disposition Year HalfCents)

structure Holding where
  description : String
  fairMarketValue : Cents
  adjustedCostBase : Cents
  /-- (i): real or immovable property in Canada, Canadian resource or timber resource property. -/
  canadianRealProperty : Bool := false
  /-- (ii): used in, or inventory of, a business carried on through a permanent establishment in Canada. -/
  canadianBusiness : Bool := false
  /-- (iii): an excluded right or interest (128.1(10)). -/
  excludedRight : Bool := false
  /-- (iv): owned on last becoming resident, or inherited since. -/
  ownedOnArrivalOrInherited : Bool := false
  /-- (v): elected under 128.1(6)(a). -/
  electedOnReturn : Bool := false
  deriving Repr, DecidableEq, Inhabited

structure Facts where
  holdings : List Holding
  /-- Months resident in Canada in the 120 months ending at emigration. -/
  monthsResident : Nat := 120
  deriving Repr, DecidableEq, Inhabited

/-- (iv): a short-term resident. -/
def shortTerm (f : Facts) : Bool := f.monthsResident ≤ 60

/-- Deemed disposed of under (b). -/
def Holding.deemed (h : Holding) (f : Facts) : Bool :=
  !(h.canadianRealProperty || h.canadianBusiness || h.excludedRight || (shortTerm f && h.ownedOnArrivalOrInherited) || h.electedOnReturn)

/-- The deemed dispositions, at fair market value. -/
def dispositions (f : Facts) : List Disposition :=
  (f.holdings.filter (·.deemed f)).map fun h =>
    { description := s!"{h.description} (deemed disposed of on emigration)", proceeds := h.fairMarketValue, adjustedCostBase := h.adjustedCostBase }

/-- (c): the cost of each property afterwards. -/
def Holding.costAfter (h : Holding) (f : Facts) : Cents := if h.deemed f then h.fairMarketValue else h.adjustedCostBase

/-- 3(b) for the deemed dispositions alone, in half-cents. -/
def netTaxableGains (f : Facts) : HalfCents := (⟨dispositions f, 0, {}⟩ : Year).paragraph3b

def explain (f : Facts) : Finding :=
  let c := formatCents
  let steps : List Step := f.holdings.map fun h =>
    if h.deemed f then ⟨s!"{h.description}: deemed disposed of for its value, {c h.fairMarketValue} (cost {c h.adjustedCostBase}), " ++
        s!"and reacquired at that cost.", "ITA 128.1(4)(b), (c)"⟩
    else ⟨s!"{h.description}: not deemed disposed of (" ++
        (if h.canadianRealProperty then "real property in Canada" else if h.canadianBusiness then "property of a business in Canada"
         else if h.excludedRight then "an excluded right or interest" else if h.electedOnReturn then "elected on returning"
         else "owned on arriving, by a short-term resident") ++ ").", "ITA 128.1(4)(b)(i) to (v)"⟩
  ⟨!(dispositions f).isEmpty, steps ++ [⟨s!"Net taxable capital gains from the deemed dispositions: {CapitalGains.formatHalfCents (netTaxableGains f)}.", "ITA 3(b); 38; 128.1(4)(b)"⟩], []⟩

/-! ## Truths -/

/-- Property that is not deemed disposed of keeps its cost. -/
theorem Holding.excepted_keeps_cost (h : Holding) (f : Facts) (hd : h.deemed f = false) : h.costAfter f = h.adjustedCostBase := by
  simp [Holding.costAfter, hd]

/-- Property deemed disposed of is reacquired at its value. -/
theorem Holding.deemed_cost (h : Holding) (f : Facts) (hd : h.deemed f = true) : h.costAfter f = h.fairMarketValue := by
  simp [Holding.costAfter, hd]

/-- Canadian real property is never deemed disposed of on emigration. -/
theorem Holding.real_property (h : Holding) (f : Facts) (hr : h.canadianRealProperty = true) : h.deemed f = false := by
  simp [Holding.deemed, hr]

/-! ## Becoming resident (128.1(1)) -/

structure Arriving where
  description : String
  fairMarketValue : Cents
  adjustedCostBase : Cents
  /-- (i): taxable Canadian property; decided by 248(1) if the property is given. -/
  taxableCanadian : Bool := false
  property : Option TaxableCanadianProperty.Property := none
  /-- (ii), (iii): inventory or Class 14.1 property of a business carried on in Canada. -/
  canadianBusiness : Bool := false
  /-- (iv): an excluded right or interest (other than 128.1(10)(k)). -/
  excludedRight : Bool := false
  deriving Repr, DecidableEq, Inhabited

def Arriving.isTCP (a : Arriving) : Bool := (a.property.map (·.isTCP)).getD a.taxableCanadian

/-- Deemed disposed of and reacquired under 128.1(1)(b), (c). -/
def Arriving.deemed (a : Arriving) : Bool := !(a.isTCP || a.canadianBusiness || a.excludedRight)

/-- The cost on becoming resident. -/
def Arriving.costOnArrival (a : Arriving) : Cents := if a.deemed then a.fairMarketValue else a.adjustedCostBase

/-- Property brought to Canada (other than the exceptions) takes its value as its cost: a gain accrued
abroad is never taxed in Canada. -/
theorem Arriving.step_up (a : Arriving) (h : a.deemed = true) : a.costOnArrival = a.fairMarketValue := by
  simp [Arriving.costOnArrival, h]

/-- Taxable Canadian property keeps its cost: its gain was always taxable in Canada. -/
theorem Arriving.tcp_keeps_cost (a : Arriving) (h : a.isTCP = true) : a.costOnArrival = a.adjustedCostBase := by
  simp [Arriving.costOnArrival, Arriving.deemed, h]

end Canteen.ITA.Emigration

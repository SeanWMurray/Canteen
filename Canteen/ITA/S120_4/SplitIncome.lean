import Canteen.Core.StatuteSyntax
import Canteen.ITA.S82.Dividends
import Canteen.Core.Answer

/-!
# Section 120.4: tax on split income

*Income Tax Act*, as consolidated to 2026-10-29 (verbatim in `statute/ITA-120.4-split-income.txt`):

**"split income"** of a specified individual: the total, other than excluded amounts, of (a) taxable
dividends (with the 82(1) gross-up) on shares of a corporation not listed on a designated stock
exchange (nor a mutual fund corporation), and section 15 benefits on such shares; (b) partnership
income from a related business or a related rental; (c) trust income of those kinds; and more.

**"excluded amount"**: income or a taxable capital gain to the extent it (a) for an individual under
24, is from property inherited from a parent (or anyone, for a full-time student or a person with a
disability); (b) is from property acquired under a 160(4) transfer (on a marriage breakdown); (c) is
a taxable capital gain under 70(5); (d) is a taxable capital gain on qualified farm or fishing
property or qualified small business corporation shares; (e) for an individual 17 or older before the
year, is not derived from a related business, or is derived from an excluded business (one in which
the individual is actively engaged on a regular, continuous and substantial basis in the year or any
five earlier years); (f) for an individual 17 to 23, is a safe harbour capital return or a reasonable
return on arm's length capital; (g) for an individual 24 or older, is from excluded shares (10% of the
votes and value of a corporation not earning 90% of its income from services, not a professional
corporation, not living off a related business), or is a reasonable return.

**"specified individual"**: an individual (not a trust) resident in Canada at the end of the year (or
immediately before death) and, if under 17 before the year, with a parent resident in Canada.

**120.4(2)** The highest individual percentage (33%, 117(2)(e)) times split income is added to tax.
**120.4(3)** Tax is at least that amount, plus the lesser of the 117(2.1) amounts, less the
disability credit and the dividend tax credits on the split income. **20(1)(ww)** Split income is
deducted in computing income, so it is not taxed twice.

Ages are the age attained before the year (the age at the start of it). Each amount is excluded or not
as a whole; "to the extent" is honoured by splitting an amount into its parts. Related business,
excluded business, and reasonable return are facts or judgment calls; the other tests are facts.
-/

namespace Canteen.ITA.SplitIncome

/-- What an amount is, for "split income". -/
inductive Source where
  /-- (a)(i): a taxable dividend on shares of a corporation not listed (nor a mutual fund corporation). -/
  | privateDividend (d : Dividends.Dividend)
  /-- A dividend on listed shares: not split income. -/
  | listedDividend (d : Dividends.Dividend)
  /-- (a)(ii), (b), (c) and the rest: an amount included in income (in cents). -/
  | otherIncluded (amount : Cents)
  /-- A taxable capital gain on shares of a private corporation disposed of to a non-arm's length person
  (120.4(4), (5) make it a dividend), in cents. -/
  | gainToRelated (amount : Cents)
  deriving Repr, DecidableEq, Inhabited

/-- One amount, with the facts the exclusions turn on. -/
structure Amount where
  description : String
  source : Source
  /-- (a): from property inherited from a parent (or anyone, for a student or a person with a disability). -/
  inherited : Bool := false
  /-- (b): from property acquired under a 160(4) transfer. -/
  marriageBreakdown : Bool := false
  /-- (c), (d): a 70(5) gain, or a gain on qualified farm or fishing property or small business shares. -/
  exemptGain : Bool := false
  /-- (e)(i): derived from a related business in respect of the individual. Often a judgment call. -/
  relatedBusiness : Answer := .fact true
  /-- (e)(ii): derived from an excluded business (actively engaged on a regular, continuous and
  substantial basis this year or in any five earlier years). Often a judgment call. -/
  excludedBusiness : Answer := .fact false
  /-- (f)(i): a safe harbour capital return. -/
  safeHarbour : Bool := false
  /-- (f)(ii), (g)(ii): a reasonable return (for 17 to 23, having regard only to arm's length capital). Often judged. -/
  reasonableReturn : Answer := .fact false
  /-- (g)(i): from excluded shares. -/
  excludedShares : Bool := false
  deriving Repr, DecidableEq, Inhabited

structure Facts where
  taxationYear : Nat
  /-- The age attained before the year. -/
  age : Nat
  residentAtYearEnd : Bool := true
  /-- For an individual under 17: a parent was resident in Canada at some time in the year. -/
  parentResident : Bool := true
  amounts : List Amount
  /-- The highest individual percentage (117(2)), in percent. -/
  highestRate : Nat := 33
  /-- 120.4(3) B: the lesser of the 117(2.1) amounts (tax on the rest of taxable income), and C: the disability credit. -/
  regularTaxOnRest : Cents := 0
  disabilityCredit : Cents := 0
  deriving Repr, Inhabited

/-- "specified individual". -/
def specified (f : Facts) : Bool := f.residentAtYearEnd && (17 ≤ f.age || f.parentResident)

/-- The amount included in income, in cents. -/
def included (f : Facts) (a : Amount) : Cents :=
  match a.source with
  | .privateDividend d | .listedDividend d => Dividends.inclusion { taxationYear := f.taxationYear, dividends := [d] }
  | .otherIncluded x | .gainToRelated x => x

/-- Whether the amount is of a kind in "split income" at all. -/
def ofSplitKind (a : Amount) : Bool :=
  match a.source with
  | .listedDividend _ => false
  | _ => true

/-- "excluded amount", by age. -/
def excluded (f : Facts) (a : Amount) : Bool :=
  (f.age < 24 && a.inherited) || a.marriageBreakdown || (a.exemptGain && !(a.source matches .gainToRelated _)) ||
  (17 ≤ f.age && (!a.relatedBusiness.value || a.excludedBusiness.value)) ||
  (17 ≤ f.age && f.age < 24 && (a.safeHarbour || a.reasonableReturn.value)) ||
  (24 ≤ f.age && (a.excludedShares || a.reasonableReturn.value))

/-- The judgment calls an amount's exclusion turns on, for the individual's age. -/
def judgments (f : Facts) (a : Amount) : List String :=
  if 17 ≤ f.age then mergeIds (mergeIds a.relatedBusiness.judgments a.excludedBusiness.judgments) a.reasonableReturn.judgments else []

/-- "split income". -/
def splitIncome (f : Facts) : Cents :=
  if specified f then ((f.amounts.filter fun a => ofSplitKind a && !excluded f a).map (included f)).sum else 0

/-- 120.4(2): the tax on split income. -/
def tax (f : Facts) : Cents := splitIncome f * f.highestRate / 100

/-- The private dividends in split income. -/
def splitDividends (f : Facts) : List Dividends.Dividend :=
  f.amounts.filterMap fun a => match a.source with
    | .privateDividend d => if excluded f a then none else some d
    | _ => none

/-- The dividend tax credits on the dividends in split income (120.4(3) D). -/
def dividendCredits (f : Facts) : Cents :=
  if specified f then Dividends.credit { taxationYear := f.taxationYear, dividends := splitDividends f } else 0

/-- 120.4(3): the minimum tax, (A + B) − (C + D). -/
def minimumTax (f : Facts) : Cents := (tax f + f.regularTaxOnRest) - (f.disabilityCredit + dividendCredits f)

def explain (f : Facts) : Finding :=
  let c := formatCents
  let js := f.amounts.foldl (fun ids a => mergeIds ids (judgments f a)) []
  if !specified f then
    ⟨false, [⟨"The individual is not a specified individual (not resident at year end, or a minor without a resident parent).",
      "ITA 120.4(1) \"specified individual\""⟩], []⟩
  else
  ⟨splitIncome f > 0,
    (f.amounts.map fun a =>
      (⟨if !ofSplitKind a then s!"{a.description}: not split income (listed shares)."
        else if excluded f a then s!"{a.description}: an excluded amount."
        else s!"{a.description}: split income of {c (included f a)}.", "ITA 120.4(1) \"split income\", \"excluded amount\""⟩ : Step)) ++
    [⟨s!"Split income is {c (splitIncome f)}; it is deducted in computing income, and taxed at {f.highestRate}%: {c (tax f)}.",
        "ITA 120.4(2); 20(1)(ww)"⟩,
     ⟨s!"Less dividend tax credits on it of {c (dividendCredits f)}.", "ITA 120.4(3)"⟩], js⟩

/-- Subsection 120.4(2), as a rule: there is split income. -/
def rule : Rule Facts where
  name := "subsection 120.4(2)"
  citation := "ITA 120.4(2)"
  holds := fun f => splitIncome f > 0
  explain := explain
  sound := fun f => by unfold explain; split <;> simp_all [splitIncome]

/-! ## Truths about split income -/

/-- An adult's dividends on excluded shares are never split income. -/
theorem excluded_shares (f : Facts) (a : Amount) (h : 24 ≤ f.age) (hs : a.excludedShares = true) : excluded f a = true := by
  simp [excluded, h, hs]

/-- For a minor (under 17 before the year), a related business's private dividends are split
income, whatever their reasonableness: the age-based exclusions are not available. -/
theorem minor_no_reasonable_return (f : Facts) (a : Amount) (h : f.age < 17) (ha : a.inherited = false)
    (hm : a.marriageBreakdown = false) (he : a.exemptGain = false) : excluded f a = false := by
  have h1 : ¬ 17 ≤ f.age := by omega
  have h2 : ¬ 24 ≤ f.age := by omega
  simp [excluded, ha, hm, he, h1, h2]

end Canteen.ITA.SplitIncome

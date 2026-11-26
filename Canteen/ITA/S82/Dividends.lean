import Canteen.Core.StatuteSyntax
import Canteen.Core.Money

/-!
# Subsection 82(1) and section 121: taxable dividends, the gross-up and the dividend tax credit

*Income Tax Act*, as consolidated to 2026-10-29 (verbatim in `statute/ITA-82-1-121.txt`):

**82(1)** In computing the income of a taxpayer for a taxation year, there shall be included
(a) the taxable dividends (other than eligible dividends and amounts in (c), (d) or (e)) received
in the year from corporations resident in Canada, (a.1) the eligible dividends so received, and
(b) for an individual (other than a trust that is a registered charity), the gross-up: (i) the
amount in (a) multiplied by 16% for 2018 and 15% after 2018, and (ii) the amount in (a.1) multiplied
by 45% for years ending after 2005 and before 2010, 44% for 2010, 41% for 2011 and 38% after 2011;
(c) taxable dividends received under dividend rental arrangements; (d) taxable dividends from
corporations resident in Canada that are not taxable Canadian corporations; and (e) [for a trust,
dividends included in a non-resident beneficiary's income].

**121** An individual may deduct from tax otherwise payable (a) the 82(1)(b)(i) gross-up multiplied
by 8/11 for 2018 and 9/13 after 2018, and (b) the 82(1)(b)(ii) gross-up multiplied by 11/18 for
2009, 10/17 for 2010, 13/23 for 2011 and 6/11 after 2011.

Each gross-up and credit is rounded down to the cent. Where the consolidated text gives no rate
for the year (a non-eligible dividend before 2018, an eligible dividend before 2006, or an eligible
dividend credit before 2009), the gross-up or credit is nil here, and the explanation says so.
Dividends from non-resident corporations are not taxable dividends under 82(1) and are left out.
Not encoded: the securities lending deductions in (a)(ii) and (a.1)(ii) (subsection 260(5.1)),
paragraph (e), and the eligible dividend designation itself (89(14)), taken as a fact.
-/

namespace Canteen.ITA.Dividends

/-- One taxable dividend received. -/
structure Dividend where
  description : String
  amount : Cents
  /-- Designated an eligible dividend by the payer (89(14)). -/
  eligible : Bool := false
  /-- The payer is resident in Canada. -/
  payerResident : Bool := true
  /-- The payer is a taxable Canadian corporation ((d) if not). -/
  payerTaxableCanadian : Bool := true
  /-- Received under a dividend rental arrangement ((c)). -/
  rental : Bool := false
  deriving Repr, DecidableEq, Inhabited

structure Facts where
  taxationYear : Nat
  /-- An individual, other than a trust that is a registered charity. -/
  individual : Bool := true
  dividends : List Dividend
  deriving Repr, DecidableEq, Inhabited

/-- Paragraphs (c) and (d): included as received, without gross-up. -/
def Dividend.cOrD (d : Dividend) : Bool := d.payerResident && (d.rental || !d.payerTaxableCanadian)

def total (ds : List Dividend) : Cents := (ds.map (·.amount)).sum

/-- (a): non-eligible taxable dividends from corporations resident in Canada, other than (c), (d). -/
def paraA (f : Facts) : Cents := total (f.dividends.filter fun d => d.payerResident && !d.cOrD && !d.eligible)

/-- (a.1): eligible dividends from corporations resident in Canada, other than (c), (d). -/
def paraA1 (f : Facts) : Cents := total (f.dividends.filter fun d => d.payerResident && !d.cOrD && d.eligible)

/-- (c), (d). -/
def paraCD (f : Facts) : Cents := total (f.dividends.filter Dividend.cOrD)

/-- (b)(i): the non-eligible gross-up rate for the year, in percent. -/
def rateI (year : Nat) : Option Nat :=
  if year = 2018 then some 16 else if 2018 < year then some 15 else none

/-- (b)(ii): the eligible gross-up rate for the year, in percent. -/
def rateII (year : Nat) : Option Nat :=
  if 2006 ≤ year ∧ year < 2010 then some 45 else if year = 2010 then some 44 else if year = 2011 then some 41
  else if 2011 < year then some 38 else none

/-- 121(a): the credit fraction for the non-eligible gross-up. -/
def creditI (year : Nat) : Option (Nat × Nat) :=
  if year = 2018 then some (8, 11) else if 2018 < year then some (9, 13) else none

/-- 121(b): the credit fraction for the eligible gross-up. -/
def creditII (year : Nat) : Option (Nat × Nat) :=
  if year = 2009 then some (11, 18) else if year = 2010 then some (10, 17) else if year = 2011 then some (13, 23)
  else if 2011 < year then some (6, 11) else none

def grossUpI (f : Facts) : Cents := if f.individual then paraA f * (rateI f.taxationYear).getD 0 / 100 else 0
def grossUpII (f : Facts) : Cents := if f.individual then paraA1 f * (rateII f.taxationYear).getD 0 / 100 else 0

/-- 82(1)(b). -/
def grossUp (f : Facts) : Cents := grossUpI f + grossUpII f

/-- 82(1): the total included in income. -/
def inclusion (f : Facts) : Cents := paraA f + paraA1 f + grossUp f + paraCD f

private def times (amount : Cents) : Option (Nat × Nat) → Cents
  | some (n, d) => amount * n / d
  | none => 0

/-- Section 121: the dividend tax credit. -/
def credit (f : Facts) : Cents :=
  if f.individual then times (grossUpI f) (creditI f.taxationYear) + times (grossUpII f) (creditII f.taxationYear) else 0

def explain (f : Facts) : Finding :=
  let c := formatCents
  let missing : List Step :=
    (if paraA f > 0 && (rateI f.taxationYear).isNone then
      [⟨s!"The consolidated text gives no gross-up rate for non-eligible dividends for {f.taxationYear}; none is applied.", "ITA 82(1)(b)(i)"⟩]
    else []) ++
    (if paraA1 f > 0 && (rateII f.taxationYear).isNone then
      [⟨s!"The consolidated text gives no gross-up rate for eligible dividends for {f.taxationYear}; none is applied.", "ITA 82(1)(b)(ii)"⟩]
    else [])
  ⟨inclusion f > 0,
    [⟨s!"Taxable dividends (other than eligible dividends) from corporations resident in Canada: {c (paraA f)}.", "ITA 82(1)(a)"⟩,
     ⟨s!"Eligible dividends from corporations resident in Canada: {c (paraA1 f)}.", "ITA 82(1)(a.1)"⟩] ++
    (if paraCD f > 0 then
      [⟨s!"Dividends under dividend rental arrangements or from corporations that are not taxable Canadian corporations, included without gross-up: {c (paraCD f)}.", "ITA 82(1)(c), (d)"⟩]
    else []) ++ missing ++
    [⟨s!"The gross-up is {c (grossUpI f)} on the non-eligible dividends and {c (grossUpII f)} on the eligible dividends" ++
        (if f.individual then "." else ": none, as the taxpayer is not an individual."), "ITA 82(1)(b)"⟩,
     ⟨s!"So {c (inclusion f)} is included in income.", "ITA 82(1)"⟩,
     ⟨s!"The dividend tax credit is {c (credit f)}.", "ITA 121"⟩], []⟩

/-- Subsection 82(1), as a rule: something is included. -/
def rule : Rule Facts where
  name := "subsection 82(1)"
  citation := "ITA 82(1)"
  holds := fun f => inclusion f > 0
  explain := explain
  sound := fun _ => rfl

/-! ## Truths about dividends -/

/-- The credit never exceeds the gross-up: every credit fraction is below one. -/
theorem credit_le_grossUp (f : Facts) : credit f ≤ grossUp f := by
  have hI : ∀ a, times a (creditI f.taxationYear) ≤ a := by
    intro a; unfold creditI; split
    · exact Nat.div_le_of_le_mul (by omega)
    · split
      · exact Nat.div_le_of_le_mul (by omega)
      · exact Nat.zero_le _
  have hII : ∀ a, times a (creditII f.taxationYear) ≤ a := by
    intro a; unfold creditII
    repeat' (first | (split; exact Nat.div_le_of_le_mul (by omega)) | split)
    all_goals first | exact Nat.div_le_of_le_mul (by omega) | exact Nat.zero_le _
  unfold credit grossUp; split
  · exact Nat.add_le_add (hI _) (hII _)
  · exact Nat.zero_le _

/-- Only individuals gross up. -/
theorem no_grossUp_unless_individual (f : Facts) (h : f.individual = false) : grossUp f = 0 ∧ credit f = 0 := by
  simp [grossUp, grossUpI, grossUpII, credit, h]

private theorem arith115 (n : Nat) : 100 * n + n * 15 = 115 * n := by omega

/-- After 2018, $100 of non-eligible dividend is $115 of income. -/
theorem non_eligible_2025 (n : Nat) :
    inclusion { taxationYear := 2025, dividends := [{ description := "", amount := 100 * n }] } = 115 * n := by
  simp [inclusion, paraA, paraA1, paraCD, grossUp, grossUpI, grossUpII, rateI, rateII, total, Dividend.cOrD]
  rw [Nat.mul_assoc, Nat.mul_div_cancel_left _ (by decide : 0 < 100)]
  exact arith115 n

end Canteen.ITA.Dividends

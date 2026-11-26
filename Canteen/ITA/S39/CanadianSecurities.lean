import Canteen.Core.StatuteSyntax
import Canteen.ITA.S38.CapitalGains

/-!
# Subsections 39(4) to (6): the election for Canadian securities

*Income Tax Act*, as consolidated to 2026-10-29 (verbatim in `statute/ITA-39-4-6.txt`):

> (4) Except as provided in subsection 39(5), where a Canadian security has been disposed of by a
> taxpayer in a taxation year and the taxpayer so elects in prescribed form …, (a) every Canadian
> security owned by the taxpayer in that year or any subsequent taxation year shall be deemed to
> have been a capital property … and (b) every disposition … of any such Canadian security shall be
> deemed to be a disposition … of a capital property.
>
> (5) An election … does not apply to a disposition of a Canadian security by a taxpayer (other than
> a mutual fund corporation or a mutual fund trust) who at the time of the disposition is (a) a
> trader or dealer in securities, (b) a financial institution …, (f) a corporation whose principal
> business is the lending of money or the purchasing of debt obligations …, or (g) a non-resident …
>
> (6) … Canadian security means a security (other than a prescribed security) that is a share of
> the capital stock of a corporation resident in Canada, a unit of a mutual fund trust or a bond,
> debenture, bill, note, mortgage, hypothecary claim or similar obligation issued by a person
> resident in Canada.

Whether a gain is on capital account is otherwise often a judgment call (`Disposition.capitalAccount`).
The election settles it as a fact for Canadian securities, in the year of the election and every
later year. Whether the taxpayer is a trader or dealer (39(5)(a)) is itself often a judgment call.
Prescribed securities (Regulation 6200) are taken as a fact.
-/

namespace Canteen.ITA.CanadianSecurities

/-- (6): what kind of security it is. -/
inductive SecurityKind where
  | shareOfResidentCorporation
  | mutualFundTrustUnit
  /-- A bond, debenture, bill, note, mortgage, hypothecary claim or similar obligation of a resident. -/
  | debtOfResident
  | other
  deriving Repr, DecidableEq, Inhabited

/-- The taxpayer's status, for 39(5). -/
structure Taxpayer where
  /-- A mutual fund corporation or mutual fund trust (to which 39(5) does not apply). -/
  mutualFund : Bool := false
  /-- (a) a trader or dealer in securities: often a judgment call. -/
  traderOrDealer : Answer := .fact false
  /-- (b) a financial institution; (f) a money-lending corporation. -/
  financialInstitutionOrLender : Bool := false
  /-- (g) non-resident. -/
  nonResident : Bool := false
  /-- The first taxation year for which the election was made, if it was. -/
  electedFrom : Option Nat := none
  deriving Repr, DecidableEq, Inhabited

structure Query where
  taxpayer : Taxpayer
  kind : SecurityKind
  prescribed : Bool := false
  year : Nat
  deriving Repr, DecidableEq, Inhabited

def canadianSecurity (q : Query) : Bool := q.kind != .other && !q.prescribed

def elected (q : Query) : Bool := q.taxpayer.electedFrom.any (· ≤ q.year)

/-- Subsection 39(4), with (5). -/
statute deemedCapital (q : Query) named "subsection 39(4)" cites "ITA 39(4)"
  applies where
    | "(6) Canadian security" (canadianSecurity q)
        => "The property is a Canadian security."
        else "The property is not a Canadian security (or is a prescribed security)."
    | "election" (elected q)
        => "The taxpayer elected under subsection 39(4) for this or an earlier year."
        else "The taxpayer has not elected under subsection 39(4)."
  except where
    | "(5)" judgments (if q.taxpayer.mutualFund then [] else q.taxpayer.traderOrDealer.judgments)
        (!q.taxpayer.mutualFund && (q.taxpayer.traderOrDealer.value || q.taxpayer.financialInstitutionOrLender || q.taxpayer.nonResident))
        => "The taxpayer is a trader or dealer in securities, a financial institution, a money-lending corporation, or a non-resident."
        else "The taxpayer is not a trader or dealer, financial institution, money-lending corporation or non-resident (or is a mutual fund)."

/-- The disposition, with its capital account settled by the election where it applies. -/
def withElection (q : Query) (d : CapitalGains.Disposition) : CapitalGains.Disposition :=
  if deemedCapital.holds q then { d with capitalAccount := .fact true } else d

/-! ## Truths about the election -/

/-- Once elected, a later year's Canadian security is on capital account, with no judgment call. -/
theorem settles_capital_account (q : Query) (d : CapitalGains.Disposition) (h : deemedCapital.holds q = true) :
    (withElection q d).capitalAccount = .fact true := by
  simp [withElection, h]

/-- A non-resident's election never applies. -/
theorem not_for_non_resident (q : Query) (hm : q.taxpayer.mutualFund = false) (h : q.taxpayer.nonResident = true) :
    deemedCapital.holds q = false := by
  simp [deemedCapital, hm, h]

end Canteen.ITA.CanadianSecurities

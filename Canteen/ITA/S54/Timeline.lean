import Canteen.ITA.S54.SuperficialLoss

/-!
# A timeline of the superficial loss period

A Mermaid Gantt chart of the facts the definition looks at: the disposition, the period in
paragraph (a), every acquisition, and the end of the period in paragraph (b). Acquisitions
that meet both (a) and (b) are drawn in red.
-/

namespace Canteen.ITA.SuperficialLoss

/-- Text safe as a Gantt task name (no colons or semicolons). -/
private def taskName (s : String) : String :=
  (s.replace ":" " -").replace ";" ","

/-- The disposition, the 61-day period and every acquisition, as a Gantt chart. -/
def timeline (f : Facts) : String :=
  let d := f.disposition
  let start := d.date.subDays 30
  let stop := d.date.addDays 30
  let loss := if isLoss d then s!"loss {formatCents (lossAmount d)}" else "no loss"
  let who (a : Acquisition) : String :=
    match a.acquirer with
    | .taxpayer => "the taxpayer"
    | .affiliated w => s!"{w} (affiliated)"
    | .notAffiliated w => s!"{w} (not affiliated)"
    | .judged w js b => s!"{w} ({if b then "affiliated" else "not affiliated"}, judgment calls {", ".intercalate js})"
  let acqs := f.acquisitions.zipIdx.map fun (a, i) =>
    let tags := if qualifies d a then "milestone, crit" else "milestone"
    let held := if a.heldAtEndOfPeriod then "held at end" else "not held at end"
    let inside := if inPeriod d a then "in period" else "outside period"
    s!"    {taskName s!"{a.date} {who a} acquires {a.description} ({inside}, {held})"} :{tags}, a{i}, {a.date}, 0d"
  "\n".intercalate ([
    "gantt",
    s!"    title Superficial loss period for the disposition on {d.date}",
    "    dateFormat YYYY-MM-DD",
    "    axisFormat %b %d",
    "    section Period (a)",
    s!"    {taskName s!"{start} to {stop}"} :active, period, {start}, 61d",
    "    section Disposition",
    s!"    {taskName s!"{d.date} disposition of {d.description} ({loss})"} :milestone, disp, {d.date}, 0d",
    "    section Acquisitions"] ++ acqs ++ [
    "    section End of period (b)",
    s!"    {taskName s!"{stop} end of period"} :milestone, endp, {stop}, 0d"])

end Canteen.ITA.SuperficialLoss

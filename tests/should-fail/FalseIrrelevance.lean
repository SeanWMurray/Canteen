-- expect: proved that the proposition
/-
Phase 3 check: you cannot prove a judgment call doesn't matter when it does.
After the first two steps of the toy plan, Rule X applies only if J-B is "yes",
so claiming it applies on every branch must be rejected.
-/
import Canteen.Examples.ToySeries

open Canteen Canteen.Examples

theorem x_applies_after_two_steps_on_every_branch :
    ruleX.SameOnEveryBranch toyCalls (fun b => toXFacts b (runSeries (toyPlan.take 2) toyStart)) true := by
  decide

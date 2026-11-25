/-!
# Money

Amounts in cents, as natural numbers, so arithmetic is exact. Generic: nothing
here is specific to tax.
-/

namespace Canteen

/-- An amount of money in cents. -/
abbrev Cents := Nat

private def groupThousands (n : Nat) : String :=
  if n < 1000 then toString n
  else
    let r := n % 1000
    let pad := if r < 10 then s!"00{r}" else if r < 100 then s!"0{r}" else toString r
    groupThousands (n / 1000) ++ "," ++ pad
termination_by n
decreasing_by omega

/-- Dollars and cents, e.g. `$1,234.56`. -/
def formatCents (c : Cents) : String :=
  let cents := c % 100
  s!"${groupThousands (c / 100)}.{if cents < 10 then s!"0{cents}" else toString cents}"

end Canteen

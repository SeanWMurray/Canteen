import Canteen.Examples.RuleXStatute
import Canteen.Examples.RuleZ
import Canteen.ITA.S40.LossDenialStatute
import Canteen.Transactions.SpouseRepurchase

/-!
# Tests: rules written in statute form
-/

namespace Canteen.Tests.Statute

open Canteen Canteen.Examples Canteen.ITA Canteen.Transactions.SpouseRepurchase

/-! ## Citations -/

#guard Rule.subCitation "s.X" "(a)" == "s.X(a)"
#guard Rule.subCitation "ITA 40(2)(g)" "(i)" == "ITA 40(2)(g)(i)"
#guard Rule.subCitation "ITA 54 \"superficial loss\"" "(a)" == "ITA 54 \"superficial loss\" (a)"
#guard Rule.subCitation "ITA 40(2)(g)" "opening words" == "ITA 40(2)(g) opening words"
#guard Rule.subCitation "s.X" "" == "s.X"

/-! ## Every form of clause -/

-- Conditions only, string labels, and a judgment call computed from the facts.
statute ruleQ (f : XFacts) named "Rule Q" cites "s.Q"
  applies where
    | "(a.1)" f.condA => "A holds." else "A fails."
    | "(a.2)" judgments (if f.condA then ["J-1"] else ["J-2"]) f.condB => "B holds." else "B fails."

example : ruleQ.holds ⟨true, true, true⟩ = true := rfl
example : ruleQ.holds ⟨true, false, false⟩ = false := rfl
#guard (ruleQ.explain ⟨true, true, false⟩).reliesOn == ["J-1"]
#guard ruleQ.explainText ⟨true, true, false⟩ ==
  "1. A holds. [s.Q(a.1)]\n2. B holds. [s.Q(a.2)]\n3. Therefore Rule Q applies. [s.Q]"

/-- Rule Z (Rule X and Rule Y), written in statute form with whole rules as clauses. -/
statute ruleZStatute (f : ZFacts) named "Rule Z" cites "s.Z"
  applies where
    | (a) := (ruleX.comap ZFacts.x)
    | (b) := (ruleY.comap ZFacts.y)

theorem ruleZStatute_eq (f : ZFacts) : ruleZStatute.holds f = ruleZ.holds f := by
  simp [ruleZStatute, ruleZ]

/-! ## Rule X in statute form -/

-- The same rule as the hand-written one, on every scenario.
example : ∀ a b e : Bool, ruleXStatute.holds ⟨a, b, e⟩ = ruleX.holds ⟨a, b, e⟩ := by decide

-- Prefer facts over judgment: B fails (a judgment call) but the exception applies (a fact),
-- so the exception is cited and no judgment call is relied on.
example : (ruleXStatute.explain ⟨true, false, true⟩).isFactual = true :=
  Rule.statute_explain_factual _ _ _ _ _ (.inr ⟨_, List.mem_singleton_self _, rfl, rfl⟩)

/-! ## Read-back, word for word -/

-- Rule X applies
#guard (ruleXStatute.explain ⟨true, true, false⟩).renderWithJudgments xJudgments ==
  "1. Condition A is met. [s.X(a)]\n" ++
  "2. Condition B is met. [s.X(b)]\n" ++
  "3. The exception does not apply. [s.X(c)]\n" ++
  "4. Therefore Rule X applies. [s.X]\n" ++
  "Relies on these judgment calls:\n" ++
  "- J-B: Is condition B met? Assumed: yes. Risk: medium.\n" ++
  "Overall risk: medium."

-- The exception (a fact) is cited before condition B (a judgment call)
#guard (ruleXStatute.explain ⟨true, false, true⟩).renderWithJudgments xJudgments ==
  "1. The exception applies. [s.X(c)]\n" ++
  "2. Therefore Rule X does not apply. [s.X]\n" ++
  "Relies on no judgment calls."

-- Condition B fails
#guard (ruleXStatute.explain ⟨true, false, false⟩).renderWithJudgments xJudgments ==
  "1. Condition B is not met. [s.X(b)]\n" ++
  "2. Therefore Rule X does not apply. [s.X]\n" ++
  "Relies on these judgment calls:\n" ++
  "- J-B: Is condition B met? Assumed: yes. Risk: medium.\n" ++
  "Overall risk: medium."

-- Superficial loss in statute form: the spouse-repurchase position
#guard (SuperficialLoss.superficialLossStatute.explain (facts position)).renderWithJudgments position ==
  "1. The taxpayer has a loss from the disposition of the particular property. [ITA 54 \"superficial loss\" opening words]\n" ++
  "2. During the period that begins 30 days before and ends 30 days after the disposition, the taxpayer or a person affiliated with the taxpayer acquired a property that is, or is identical to, the particular property, and at the end of that period the taxpayer or a person affiliated with the taxpayer owned or had a right to acquire it. [ITA 54 \"superficial loss\" (a), (b)]\n" ++
  "3. The disposition was not deemed to have been made by a provision listed in paragraph (c). [ITA 54 \"superficial loss\" (c)]\n" ++
  "4. The disposition was not the expiry of an option. [ITA 54 \"superficial loss\" (d)]\n" ++
  "5. Paragraph 40(2)(e.1) does not apply to the disposition. [ITA 54 \"superficial loss\" (e)]\n" ++
  "6. The taxpayer was not subject to a loss restriction event within 30 days after the disposition. [ITA 54 \"superficial loss\" (f)]\n" ++
  "7. Within 30 days after the disposition, the taxpayer did not become or cease to be exempt from tax under Part I on its taxable income. [ITA 54 \"superficial loss\" (g)]\n" ++
  "8. Neither subsection 40(3.4) nor subsection 69(5) applies to the disposition. [ITA 54 \"superficial loss\" (h)]\n" ++
  "9. Therefore the superficial loss rule applies. [ITA 54 \"superficial loss\"]\n" ++
  "Relies on these judgment calls:\n" ++
  "- J-ID: Are the spouse's 100 common shares of ABC Ltd. identical to the 100 common shares of ABC Ltd. the taxpayer sold? Assumed: yes. Risk: low.\n" ++
  "Overall risk: low."

-- Superficial loss in statute form: the alternative
#guard (SuperficialLoss.superficialLossStatute.explain (facts alternative)).renderWithJudgments alternative ==
  "1. No property that is, or is identical to, the particular property was both acquired by the taxpayer or a person affiliated with the taxpayer during the period that begins 30 days before and ends 30 days after the disposition, and owned by them, or subject to their right to acquire it, at the end of that period. [ITA 54 \"superficial loss\" (a), (b)]\n" ++
  "2. Therefore the superficial loss rule does not apply. [ITA 54 \"superficial loss\"]\n" ++
  "Relies on these judgment calls:\n" ++
  "- J-ID: Are the spouse's 100 common shares of ABC Ltd. identical to the 100 common shares of ABC Ltd. the taxpayer sold? Assumed: no. Risk: high.\n" ++
  "Overall risk: high."

-- Superficial loss in statute form: exception (c)
#guard SuperficialLoss.superficialLossStatute.explainText ⟨{ sale with deemedBy := some .s70 }, [spousePurchase false]⟩ ==
  "1. The disposition was deemed to have been made by a provision listed in paragraph (c). [ITA 54 \"superficial loss\" (c)]\n" ++
  "2. Therefore the superficial loss rule does not apply. [ITA 54 \"superficial loss\"]"

-- Subparagraph 40(2)(g)(i) in statute form: the carve-out
#guard LossDenial.lossDenialStatute.explainText ⟨facts position, true⟩ ==
  "1. For the purposes of computing the surplus or deficit of the taxpayer in respect of another taxpayer of which it is a foreign affiliate, the property is excluded property. [ITA 40(2)(g) opening words]\n" ++
  "2. Therefore subparagraph 40(2)(g)(i) does not apply. [ITA 40(2)(g)]"

end Canteen.Tests.Statute

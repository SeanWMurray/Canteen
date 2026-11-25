import Canteen.ITA.S54.SuperficialLoss
import Canteen.ITA.S40.LossDenial
import Canteen.Lemmas.SuperficialLoss
import Canteen.Core.Branch

/-!
# Tests: section 54 "superficial loss" and subparagraph 40(2)(g)(i)

Known-answer tests built from the statute text: each scenario changes one fact from
a base case, and the expected answer follows from the paragraph that fact engages.
These are constructed examples, not published CRA examples or decided cases.

Base case: 100 shares sold at a loss of $509.99 on 2025-06-15. The period in
paragraph (a) runs from 2025-05-16 to 2025-07-15.
-/

namespace Canteen.Tests.SuperficialLoss

open Canteen Canteen.ITA Canteen.ITA.SuperficialLoss

/-! ## Scenario builders -/

def sale : Disposition :=
  { description := "100 common shares of ABC Ltd.", date := ⟨2025, 6, 15⟩,
    proceeds := 100000, adjustedCostBase := 150000, outlaysAndExpenses := 999 }

/-- A purchase of 100 ABC shares by `who`, treated as identical (judgment call J-ID). -/
def buy (date : Date) (who : Acquirer := .taxpayer) (identity : Identity := .identical "J-ID" true)
    (held : Bool := true) (description := "100 common shares of ABC Ltd.") : Acquisition :=
  { description, date, acquirer := who, identity, heldAtEndOfPeriod := held }

def sl (d : Disposition) (as : List Acquisition) : Bool := superficialLoss ⟨d, as⟩

/-! ## Opening words: a loss -/

example : isLoss sale = true ∧ lossAmount sale = 50999 := by decide
example : sl { sale with proceeds := 150999 } [buy ⟨2025, 6, 20⟩] = false := by decide  -- break-even
example : sl { sale with proceeds := 160000 } [buy ⟨2025, 6, 20⟩] = false := by decide  -- gain
example : sl { sale with proceeds := 150998 } [buy ⟨2025, 6, 20⟩] = true := by decide   -- 1 cent loss

/-! ## Paragraph (a): the period, the acquirer, identity -/

example : sl sale [buy ⟨2025, 6, 20⟩] = true := by decide
example : sl sale [buy ⟨2025, 7, 15⟩] = true := by decide     -- day 30 after: inside
example : sl sale [buy ⟨2025, 7, 16⟩] = false := by decide    -- day 31 after: outside
example : sl sale [buy ⟨2025, 5, 16⟩] = true := by decide     -- day 30 before: inside
example : sl sale [buy ⟨2025, 5, 15⟩] = false := by decide    -- day 31 before: outside
example : sl sale [buy ⟨2025, 6, 15⟩] = true := by decide     -- same day
example : sl sale [] = false := by decide

example : sl sale [buy ⟨2025, 6, 20⟩ (who := .affiliated "the taxpayer's spouse")] = true := by decide
example : sl sale [buy ⟨2025, 6, 20⟩ (who := .notAffiliated "the taxpayer's sibling")] = false := by decide

example : sl sale [buy ⟨2025, 6, 20⟩ (identity := .identical "J-ID" false)] = false := by decide
example : sl sale [buy ⟨2025, 6, 20⟩ (identity := .same)] = true := by decide
example : sl sale [buy ⟨2025, 6, 20⟩ (identity := .different)] = false := by decide

/-! ## Paragraph (b): held at the end of the period -/

example : sl sale [buy ⟨2025, 6, 20⟩ (held := false)] = false := by decide
-- One purchase sold again before the end of the period, another still held.
example : sl sale [buy ⟨2025, 6, 20⟩ (held := false), buy ⟨2025, 7, 1⟩] = true := by decide

/-! ## Paragraph (c): deemed dispositions -/

def listedInC : List DeemingProvision :=
  [.s45_1, .s48_pre1993, .s50, .s70, .s104_4, .s128_1, .s132_2_3_a, .s132_2_3_c,
   .s138_11_3, .s138_2_4, .s142_5_2, .s142_6, .s144_4_1, .s144_4_2, .s149_10]

-- Every provision listed in (c) excepts the disposition…
example : listedInC.all (fun p => !sl { sale with deemedBy := some p } [buy ⟨2025, 6, 20⟩]) = true := by
  decide
-- …the list has all fifteen…
example : listedInC.length = 15 := rfl
-- …and a deeming provision (c) does not list does not.
example : sl { sale with deemedBy := some (.other "subsection 7(1.31)") } [buy ⟨2025, 6, 20⟩] = true := by
  decide

/-! ## Paragraphs (d) to (h) -/

example : sl { sale with optionExpiry := true } [buy ⟨2025, 6, 20⟩] = false := by decide            -- (d)
example : sl { sale with applies40_2_e1 := true } [buy ⟨2025, 6, 20⟩] = false := by decide          -- (e)
example : sl { sale with lossRestrictionEvent := some ⟨2025, 7, 15⟩ } [buy ⟨2025, 6, 20⟩] = false := by decide -- (f)
example : sl { sale with lossRestrictionEvent := some ⟨2025, 7, 16⟩ } [buy ⟨2025, 6, 20⟩] = true := by decide
example : sl { sale with lossRestrictionEvent := some ⟨2025, 6, 1⟩ } [buy ⟨2025, 6, 20⟩] = true := by decide
example : sl { sale with exemptStatusChange := some ⟨2025, 6, 30⟩ } [buy ⟨2025, 6, 20⟩] = false := by decide  -- (g)
example : sl { sale with exemptStatusChange := some ⟨2025, 7, 16⟩ } [buy ⟨2025, 6, 20⟩] = true := by decide
example : sl { sale with applies40_3_4 := true } [buy ⟨2025, 6, 20⟩] = false := by decide          -- (h)
example : sl { sale with applies69_5 := true } [buy ⟨2025, 6, 20⟩] = false := by decide            -- (h)

/-! ## Paragraphs (i) and (j): deemed identical -/

def callOption (securityOnly : Bool) : Acquisition :=
  buy ⟨2025, 6, 20⟩ (identity := .rightToAcquire securityOnly)
    (description := "a call option to acquire 100 common shares of ABC Ltd.")

example : sl sale [callOption false] = true := by decide
example : sl sale [callOption true] = false := by decide

def siftUnits : Disposition :=
  { sale with description := "200 units of XYZ Income Fund", date := ⟨2013, 1, 10⟩ }
def siftShare (date : Date) : Acquisition :=
  buy date (identity := .siftWindUpShare) (description := "200 shares of XYZ Corp.")

example : sl siftUnits [siftShare ⟨2012, 12, 31⟩] = true := by decide   -- acquired before 2013
example : sl siftUnits [siftShare ⟨2013, 1, 1⟩] = false := by decide    -- acquired in 2013

/-! ## Non-vacuity and sanity -/

theorem rule_nonVacuous : SuperficialLoss.rule.NonVacuous :=
  .of_witnesses _ ⟨sale, [buy ⟨2025, 6, 20⟩]⟩ ⟨sale, []⟩ (by decide) (by decide)

/-! ## Judgment calls: identity -/

def idCalls : List JudgmentCall :=
  [{ id := "J-ID", question := "Are the shares bought identical to the shares sold?",
     riskIfYes := .low, riskIfNo := .high }]

def withAnswer (d : Disposition) (b : List Judgment) : Facts :=
  ⟨d, [buy ⟨2025, 6, 20⟩ (identity := .identical "J-ID" (answerOf b "J-ID"))]⟩

/-- Whether the loss is superficial turns on whether the shares are identical… -/
theorem depends_on_identity :
    ¬ SuperficialLoss.rule.SameOnEveryBranch idCalls (withAnswer sale) true ∧
    ¬ SuperficialLoss.rule.SameOnEveryBranch idCalls (withAnswer sale) false := by decide

/-- …unless an exception applies, when it doesn't matter. -/
theorem identity_irrelevant_on_death :
    SuperficialLoss.rule.SameOnEveryBranch idCalls (withAnswer { sale with deemedBy := some .s70 }) false := by
  decide

/-! ## Subparagraph 40(2)(g)(i) -/

example : LossDenial.rule.holds ⟨⟨sale, [buy ⟨2025, 6, 20⟩]⟩, false⟩ = true := by decide
example : LossDenial.rule.holds ⟨⟨sale, [buy ⟨2025, 6, 20⟩]⟩, true⟩ = false := by decide   -- carve-out
example : LossDenial.rule.holds ⟨⟨sale, []⟩, false⟩ = false := by decide
example : LossDenial.deniedLoss ⟨⟨sale, [buy ⟨2025, 6, 20⟩]⟩, false⟩ = 50999 := by decide
example : LossDenial.deniedLoss ⟨⟨sale, []⟩, false⟩ = 0 := by decide

/-! ## Read-back: the English for each kind of outcome, word for word

Reviewed against the statute; also reproduced in `docs/review/superficial-loss.md`. -/

def yesReg : List Judgment := [(idCalls.head!).assume true]
def noReg : List Judgment := [(idCalls.head!).assume false]

def manyFailures : List Acquisition :=
  [buy ⟨2025, 7, 16⟩, buy ⟨2025, 6, 20⟩ (who := .notAffiliated "the taxpayer's sibling"),
   buy ⟨2025, 6, 25⟩ (held := false), buy ⟨2025, 7, 1⟩ (identity := .identical "J-ID" false)]

-- Shares repurchased within the period (identical: judgment call)
#guard (SuperficialLoss.rule.explain ⟨sale, [buy ⟨2025, 6, 20⟩]⟩).renderWithJudgments yesReg ==
  "1. The taxpayer disposed of 100 common shares of ABC Ltd. on 2025-06-15 for proceeds of $1,000.00. The adjusted cost base plus outlays and expenses was $1,509.99, so the taxpayer's loss from the disposition is $509.99. [ITA 40(1)(b)]
" ++
  "2. On 2025-06-20, within the period from 2025-05-16 to 2025-07-15, the taxpayer acquired 100 common shares of ABC Ltd. That property is identical to the particular property (judgment call J-ID). [ITA 54 \"superficial loss\" (a)]
" ++
  "3. At the end of that period, on 2025-07-15, the taxpayer or a person affiliated with the taxpayer owned or had a right to acquire that property. [ITA 54 \"superficial loss\" (b)]
" ++
  "4. The disposition is not one described in paragraphs (c) to (h), so the taxpayer's loss of $509.99 is a superficial loss. [ITA 54 \"superficial loss\"]
" ++
  "Relies on these judgment calls:
" ++
  "- J-ID: Are the shares bought identical to the shares sold? Assumed: yes. Risk: low.
" ++
  "Overall risk: low."

-- Four acquisitions, each failing for a different reason
#guard (SuperficialLoss.rule.explain ⟨sale, manyFailures⟩).renderWithJudgments noReg ==
  "1. The taxpayer disposed of 100 common shares of ABC Ltd. on 2025-06-15 for proceeds of $1,000.00. The adjusted cost base plus outlays and expenses was $1,509.99, so the taxpayer's loss from the disposition is $509.99. [ITA 40(1)(b)]
" ++
  "2. The property acquired on 2025-07-16 (100 common shares of ABC Ltd.) was acquired outside the period from 2025-05-16 to 2025-07-15, so it does not meet paragraph (a). [ITA 54 \"superficial loss\" (a)]
" ++
  "3. The property acquired on 2025-06-20 (100 common shares of ABC Ltd.) was acquired by the taxpayer's sibling, a person not affiliated with the taxpayer, so it does not meet paragraph (a). [ITA 54 \"superficial loss\" (a)]
" ++
  "4. At the end of the period, on 2025-07-15, neither the taxpayer nor a person affiliated with the taxpayer owned or had a right to acquire the property acquired on 2025-06-25 (100 common shares of ABC Ltd.), so it does not meet paragraph (b). [ITA 54 \"superficial loss\" (b)]
" ++
  "5. The property acquired on 2025-07-01 (100 common shares of ABC Ltd.) is not identical to the particular property (judgment call J-ID), so it does not meet paragraph (a). [ITA 54 \"superficial loss\" (a)]
" ++
  "6. No property meets both paragraphs (a) and (b), so the loss is not a superficial loss. [ITA 54 \"superficial loss\"]
" ++
  "Relies on these judgment calls:
" ++
  "- J-ID: Are the shares bought identical to the shares sold? Assumed: no. Risk: high.
" ++
  "Overall risk: high."

-- Nothing acquired
#guard SuperficialLoss.rule.explainText ⟨sale, []⟩ ==
  "1. The taxpayer disposed of 100 common shares of ABC Ltd. on 2025-06-15 for proceeds of $1,000.00. The adjusted cost base plus outlays and expenses was $1,509.99, so the taxpayer's loss from the disposition is $509.99. [ITA 40(1)(b)]
" ++
  "2. Neither the taxpayer nor a person affiliated with the taxpayer acquired the particular property or an identical property in the period from 2025-05-16 to 2025-07-15. [ITA 54 \"superficial loss\" (a)]
" ++
  "3. No property meets both paragraphs (a) and (b), so the loss is not a superficial loss. [ITA 54 \"superficial loss\"]"

-- No loss
#guard SuperficialLoss.rule.explainText ⟨{ sale with proceeds := 160000 }, []⟩ ==
  "1. The taxpayer disposed of 100 common shares of ABC Ltd. on 2025-06-15 for proceeds of $1,600.00, which are not less than the adjusted cost base plus outlays and expenses of $1,509.99. There is no loss, so there is no superficial loss. [ITA 40(1); ITA 54 \"superficial loss\"]"

-- Exception (c): deemed disposition on death (section 70)
#guard SuperficialLoss.rule.explainText ⟨{ sale with deemedBy := some .s70 }, [buy ⟨2025, 6, 20⟩]⟩ ==
  "1. The taxpayer disposed of 100 common shares of ABC Ltd. on 2025-06-15 for proceeds of $1,000.00. The adjusted cost base plus outlays and expenses was $1,509.99, so the taxpayer's loss from the disposition is $509.99. [ITA 40(1)(b)]
" ++
  "2. The disposition was deemed to have been made by section 70, so the loss is not a superficial loss. [ITA 54 \"superficial loss\" (c)]"

-- Exception (f): loss restriction event within 30 days after
#guard SuperficialLoss.rule.explainText ⟨{ sale with lossRestrictionEvent := some ⟨2025, 7, 15⟩ }, [buy ⟨2025, 6, 20⟩]⟩ ==
  "1. The taxpayer disposed of 100 common shares of ABC Ltd. on 2025-06-15 for proceeds of $1,000.00. The adjusted cost base plus outlays and expenses was $1,509.99, so the taxpayer's loss from the disposition is $509.99. [ITA 40(1)(b)]
" ++
  "2. The taxpayer was subject to a loss restriction event on 2025-07-15, within 30 days after the disposition, so the loss is not a superficial loss. [ITA 54 \"superficial loss\" (f)]"

-- Paragraph (i): a call option is deemed identical
#guard SuperficialLoss.rule.explainText ⟨sale, [callOption false]⟩ ==
  "1. The taxpayer disposed of 100 common shares of ABC Ltd. on 2025-06-15 for proceeds of $1,000.00. The adjusted cost base plus outlays and expenses was $1,509.99, so the taxpayer's loss from the disposition is $509.99. [ITA 40(1)(b)]
" ++
  "2. On 2025-06-20, within the period from 2025-05-16 to 2025-07-15, the taxpayer acquired a call option to acquire 100 common shares of ABC Ltd. That property is a right to acquire the particular property. [ITA 54 \"superficial loss\" (a)]
" ++
  "3. A right to acquire a property (other than a right, as security only, derived from a mortgage, hypothec, agreement for sale or similar obligation) is deemed to be a property that is identical to the property. [ITA 54 \"superficial loss\" (i)]
" ++
  "4. At the end of that period, on 2025-07-15, the taxpayer or a person affiliated with the taxpayer owned or had a right to acquire that property. [ITA 54 \"superficial loss\" (b)]
" ++
  "5. The disposition is not one described in paragraphs (c) to (h), so the taxpayer's loss of $509.99 is a superficial loss. [ITA 54 \"superficial loss\"]"

-- Paragraph (j): SIFT wind-up share acquired before 2013
#guard SuperficialLoss.rule.explainText ⟨siftUnits, [siftShare ⟨2012, 12, 31⟩]⟩ ==
  "1. The taxpayer disposed of 200 units of XYZ Income Fund on 2013-01-10 for proceeds of $1,000.00. The adjusted cost base plus outlays and expenses was $1,509.99, so the taxpayer's loss from the disposition is $509.99. [ITA 40(1)(b)]
" ++
  "2. On 2012-12-31, within the period from 2012-12-11 to 2013-02-09, the taxpayer acquired 200 shares of XYZ Corp. That property is a share of the capital stock of a SIFT wind-up corporation in respect of the SIFT wind-up entity whose equity is the particular property. [ITA 54 \"superficial loss\" (a)]
" ++
  "3. The share was acquired before 2013, so it is deemed to be a property that is identical to equity in the SIFT wind-up entity. [ITA 54 \"superficial loss\" (j)]
" ++
  "4. At the end of that period, on 2013-02-09, the taxpayer or a person affiliated with the taxpayer owned or had a right to acquire that property. [ITA 54 \"superficial loss\" (b)]
" ++
  "5. The disposition is not one described in paragraphs (c) to (h), so the taxpayer's loss of $509.99 is a superficial loss. [ITA 54 \"superficial loss\"]"

-- Two acquisitions: the factual one is cited, not the judgment one
#guard (SuperficialLoss.rule.explain ⟨sale, [buy ⟨2025, 6, 20⟩, buy ⟨2025, 6, 22⟩ (who := .affiliated "the taxpayer's spouse") (identity := .same)]⟩).renderWithJudgments yesReg ==
  "1. The taxpayer disposed of 100 common shares of ABC Ltd. on 2025-06-15 for proceeds of $1,000.00. The adjusted cost base plus outlays and expenses was $1,509.99, so the taxpayer's loss from the disposition is $509.99. [ITA 40(1)(b)]
" ++
  "2. On 2025-06-22, within the period from 2025-05-16 to 2025-07-15, the taxpayer's spouse, a person affiliated with the taxpayer, acquired 100 common shares of ABC Ltd. That property is the particular property. [ITA 54 \"superficial loss\" (a)]
" ++
  "3. At the end of that period, on 2025-07-15, the taxpayer or a person affiliated with the taxpayer owned or had a right to acquire that property. [ITA 54 \"superficial loss\" (b)]
" ++
  "4. The disposition is not one described in paragraphs (c) to (h), so the taxpayer's loss of $509.99 is a superficial loss. [ITA 54 \"superficial loss\"]
" ++
  "Relies on no judgment calls."

-- Both answers to the identity judgment call
#guard SuperficialLoss.rule.renderBranches idCalls (withAnswer sale) ==
  "Branch 1 (J-ID = yes):
" ++
  "1. The taxpayer disposed of 100 common shares of ABC Ltd. on 2025-06-15 for proceeds of $1,000.00. The adjusted cost base plus outlays and expenses was $1,509.99, so the taxpayer's loss from the disposition is $509.99. [ITA 40(1)(b)]
" ++
  "2. On 2025-06-20, within the period from 2025-05-16 to 2025-07-15, the taxpayer acquired 100 common shares of ABC Ltd. That property is identical to the particular property (judgment call J-ID). [ITA 54 \"superficial loss\" (a)]
" ++
  "3. At the end of that period, on 2025-07-15, the taxpayer or a person affiliated with the taxpayer owned or had a right to acquire that property. [ITA 54 \"superficial loss\" (b)]
" ++
  "4. The disposition is not one described in paragraphs (c) to (h), so the taxpayer's loss of $509.99 is a superficial loss. [ITA 54 \"superficial loss\"]
" ++
  "Conclusion: The superficial loss rule applies. Risk: low.
" ++
  "
" ++
  "Branch 2 (J-ID = no):
" ++
  "1. The taxpayer disposed of 100 common shares of ABC Ltd. on 2025-06-15 for proceeds of $1,000.00. The adjusted cost base plus outlays and expenses was $1,509.99, so the taxpayer's loss from the disposition is $509.99. [ITA 40(1)(b)]
" ++
  "2. The property acquired on 2025-06-20 (100 common shares of ABC Ltd.) is not identical to the particular property (judgment call J-ID), so it does not meet paragraph (a). [ITA 54 \"superficial loss\" (a)]
" ++
  "3. No property meets both paragraphs (a) and (b), so the loss is not a superficial loss. [ITA 54 \"superficial loss\"]
" ++
  "Conclusion: The superficial loss rule does not apply. Risk: high.
" ++
  "
" ++
  "Summary: The superficial loss rule applies on 1 of 2 branches, so the conclusion depends on the judgment calls."

-- Subparagraph 40(2)(g)(i): the loss is nil
#guard (LossDenial.rule.explain ⟨⟨sale, [buy ⟨2025, 6, 20⟩]⟩, false⟩).renderWithJudgments yesReg ==
  "1. The property is not excluded property being considered in computing a foreign affiliate's surplus or deficit, so the opening words of paragraph 40(2)(g) apply to it. [ITA 40(2)(g)]
" ++
  "2. The taxpayer disposed of 100 common shares of ABC Ltd. on 2025-06-15 for proceeds of $1,000.00. The adjusted cost base plus outlays and expenses was $1,509.99, so the taxpayer's loss from the disposition is $509.99. [ITA 40(1)(b)]
" ++
  "3. On 2025-06-20, within the period from 2025-05-16 to 2025-07-15, the taxpayer acquired 100 common shares of ABC Ltd. That property is identical to the particular property (judgment call J-ID). [ITA 54 \"superficial loss\" (a)]
" ++
  "4. At the end of that period, on 2025-07-15, the taxpayer or a person affiliated with the taxpayer owned or had a right to acquire that property. [ITA 54 \"superficial loss\" (b)]
" ++
  "5. The disposition is not one described in paragraphs (c) to (h), so the taxpayer's loss of $509.99 is a superficial loss. [ITA 54 \"superficial loss\"]
" ++
  "6. Therefore, under subparagraph 40(2)(g)(i), the taxpayer's loss from the disposition is nil to the extent that it is a superficial loss. [ITA 40(2)(g)(i)]
" ++
  "Relies on these judgment calls:
" ++
  "- J-ID: Are the shares bought identical to the shares sold? Assumed: yes. Risk: low.
" ++
  "Overall risk: low."

-- Subparagraph 40(2)(g)(i): foreign affiliate carve-out
#guard LossDenial.rule.explainText ⟨⟨sale, [buy ⟨2025, 6, 20⟩]⟩, true⟩ ==
  "1. The loss is being computed for the surplus or deficit of the taxpayer in respect of another taxpayer of which it is a foreign affiliate, and the property is excluded property, so paragraph 40(2)(g) does not apply to it. [ITA 40(2)(g)]
" ++
  "2. Therefore subparagraph 40(2)(g)(i) does not reduce the taxpayer's loss from the disposition. [ITA 40(2)(g)(i)]"

end Canteen.Tests.SuperficialLoss

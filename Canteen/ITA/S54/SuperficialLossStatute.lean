import Canteen.Core.StatuteSyntax
import Canteen.ITA.S54.SuperficialLoss

/-!
# Section 54 "superficial loss", in statute form

The definition written with the `statute` command, close to the Act's own shape: *the
taxpayer's loss … where (a) … and (b) …, except where the disposition was (c) … (h) ….*
`superficialLossStatute_eq` proves it is the same rule as the paragraph-by-paragraph
encoding in `SuperficialLoss.lean`, which remains the reviewed reference (its explanation
gives dates, amounts and per-acquisition reasons).
-/

namespace Canteen.ITA.SuperficialLoss

/-- The judgment calls that can matter: the affiliation and identity judgment calls of
acquisitions in the period and held at its end. -/
def acquisitionJudgments (f : Facts) : List String :=
  (f.acquisitions.filter fun a => inPeriod f.disposition a && paraB a).foldl
    (fun ids a => mergeIds ids (mergeIds a.acquirer.judgment?.toList a.identity.judgment?.toList)) []

/-- **superficial loss** of a taxpayer means the taxpayer's loss from the disposition of a
particular property where (a) … and (b) …, except where the disposition was (c) … (h) …. -/
statute superficialLossStatute (f : Facts) named "the superficial loss rule" cites "ITA 54 \"superficial loss\""
  applies where
    | "opening words" isLoss f.disposition
        => "The taxpayer has a loss from the disposition of the particular property."
        else "The taxpayer has no loss from the disposition of the particular property."
    | "(a), (b)" judgments (acquisitionJudgments f) f.acquisitions.any (qualifies f.disposition)
        => "During the period that begins 30 days before and ends 30 days after the disposition, the taxpayer or a person affiliated with the taxpayer acquired a property that is, or is identical to, the particular property, and at the end of that period the taxpayer or a person affiliated with the taxpayer owned or had a right to acquire it."
        else "No property that is, or is identical to, the particular property was both acquired by the taxpayer or a person affiliated with the taxpayer during the period that begins 30 days before and ends 30 days after the disposition, and owned by them, or subject to their right to acquire it, at the end of that period."
  except where
    | (c) paraC f.disposition
        => "The disposition was deemed to have been made by a provision listed in paragraph (c)."
        else "The disposition was not deemed to have been made by a provision listed in paragraph (c)."
    | (d) paraD f.disposition
        => "The disposition was the expiry of an option."
        else "The disposition was not the expiry of an option."
    | (e) paraE f.disposition
        => "Paragraph 40(2)(e.1) applies to the disposition."
        else "Paragraph 40(2)(e.1) does not apply to the disposition."
    | (f) paraF f.disposition
        => "The taxpayer was subject to a loss restriction event within 30 days after the disposition."
        else "The taxpayer was not subject to a loss restriction event within 30 days after the disposition."
    | (g) paraG f.disposition
        => "Within 30 days after the disposition, the taxpayer became or ceased to be exempt from tax under Part I on its taxable income."
        else "Within 30 days after the disposition, the taxpayer did not become or cease to be exempt from tax under Part I on its taxable income."
    | (h) paraH f.disposition
        => "Subsection 40(3.4) or 69(5) applies to the disposition."
        else "Neither subsection 40(3.4) nor subsection 69(5) applies to the disposition."

/-- The statute form is the same rule as the paragraph-by-paragraph encoding. -/
theorem superficialLossStatute_eq (f : Facts) :
    superficialLossStatute.holds f = superficialLoss f := by
  simp [superficialLossStatute, superficialLoss, excepted, Bool.or_assoc, Bool.and_assoc]

end Canteen.ITA.SuperficialLoss

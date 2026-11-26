# Layer 1: statute encoding

One folder per section of the *Income Tax Act*, and one file per provision, labelled with its citation.
The verbatim statute text for each is in `statute/`. Review notes are in `docs/review/`.

- `S54/SuperficialLoss.lean`: section 54, "superficial loss"
- `S40/LossDenial.lean`: subparagraph 40(2)(g)(i)
- `S53/CostAddition.lean`: paragraph 53(1)(f)
- `S251_1/Affiliation.lean`: paragraph 251.1(1)(a)
- `*Statute.lean`: the same provisions in statute form, proven equal
- `S54/Timeline.lean`: a timeline chart of the superficial loss period
- `S40/DebtLoss.lean`, `S40/PersonalUseLoss.lean`, `S40/PlanTransferLoss.lean`: subparagraphs 40(2)(g)(ii) to (iv)
- `S40/Paragraph40_2_g.lean`: paragraph 40(2)(g) as a whole (`S40/Paragraph40_2_g_Facts.lean` holds its facts)
- `S251_1/AffiliatedPersons.lean`: section 251.1(1)(a) to (h), for a world of persons
- `S251/RelatedPersons.lean`: section 251, related persons and arm's length
- `S50/BadDebtPersonalUse.lean`: subsection 50(2)

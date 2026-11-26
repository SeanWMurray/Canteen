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
- `S40/SuspendedLoss.lean`: subsections 40(3.3) to (3.5)
- `S251/Amalgamation.lean`: 251.1(2), 251(3.1) and (3.2)
- `S38/CapitalGains.lean`: 40(1), 39(1), 38 and 41
- `S3/Income.lean`: section 3
- `S111/NetCapitalLoss.lean`: net capital losses, 111(8), (1)(b), (1.1)
- `S40/ShareToAffiliate.lean`: 40(3.6) and 53(1)(f.2)
- `S40/RelatedDebt.lean`: 40(2)(e.1) and 53(1)(f.1)
- `S40/PrincipalResidence.lean`: 40(2)(b) and 54 "principal residence"
- `S69/NonArmsLength.lean`: subsection 69(1)
- `S73/SpousalRollover.lean`: subsections 73(1) and (1.01)
- `S70/Death.lean`: subsections 70(5), (6) and (6.2)
- `S74/Attribution.lean`: subsection 74.2(1), and 74.5(1) and (3)
- `S45/ChangeInUse.lean`: subsections 45(1) to (4)
- `S85/TransferToCorporation.lean`: subsections 85(1), (1.1) and (2.1)
- `S84_1/SurplusStripping.lean`: subsections 84.1(1) and (2)
- `S110_6/CapitalGainsDeduction.lean`: subsections 110.6(1) (three definitions) and (2.1)
- `S251_2/LossRestrictionEvent.lean`: paragraph 251.2(2)(a), with 256(7)(a)
- `S74/IncomeAttribution.lean`: subsections 74.1(1) to (3), and 74.5(2) and (3)(a)
- `S82/Dividends.lean`: subsection 82(1) and section 121
- `S55/IntercorporateDividends.lean`: subsection 112(1), and 55(2), (2.1), (3) and (5)(f)
- `S13/Depreciable.lean`: subsections 13(1) and (21) "undepreciated capital cost", and 20(16)
- `S84/Redemption.lean`: subsection 84(3), and 54 "proceeds of disposition" (j)
- `S89/CapitalDividendAccount.lean`: subsection 83(2) and 89(1) "capital dividend account"
- `S86/ShareExchange.lean`: subsections 86(1) to (3)

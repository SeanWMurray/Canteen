# Review: section 54 "superficial loss", paragraph 40(2)(g), subsections 40(3.3) to (3.5), 50(2), paragraph 53(1)(f), and sections 251 and 251.1

**Status:** encoded and tested; **awaiting review against the statute** (roadmap Phase 4).

Lean proves that each explanation agrees with its rule, and that the conclusions follow from the definitions.
It cannot prove that the definitions match the Act. That is what this review is for.

- Statute text (verbatim, current to 2026-10-29): [`statute/ITA-54-superficial-loss.txt`](../../statute/ITA-54-superficial-loss.txt), [`statute/ITA-40-2-g.txt`](../../statute/ITA-40-2-g.txt), [`statute/ITA-53-1-f.txt`](../../statute/ITA-53-1-f.txt), [`statute/ITA-251-1-1-a.txt`](../../statute/ITA-251-1-1-a.txt), [`statute/ITA-54-personal-use-property.txt`](../../statute/ITA-54-personal-use-property.txt), [`statute/ITA-104-2.txt`](../../statute/ITA-104-2.txt), [`statute/ITA-251-1.txt`](../../statute/ITA-251-1.txt) (all of section 251.1, and "majority-interest partner" in 248(1)), [`statute/ITA-251.txt`](../../statute/ITA-251.txt), [`statute/ITA-50-2.txt`](../../statute/ITA-50-2.txt), [`statute/ITA-40-3.3-3.5.txt`](../../statute/ITA-40-3.3-3.5.txt)
- Encoding: [`Canteen/ITA/S54/SuperficialLoss.lean`](../../Canteen/ITA/S54/SuperficialLoss.lean), [`Canteen/ITA/S40/LossDenial.lean`](../../Canteen/ITA/S40/LossDenial.lean), [`Canteen/ITA/S53/CostAddition.lean`](../../Canteen/ITA/S53/CostAddition.lean), [`Canteen/ITA/S251_1/Affiliation.lean`](../../Canteen/ITA/S251_1/Affiliation.lean), and for 40(2)(g)(ii) to (iv) and the paragraph as a whole: [`DebtLoss.lean`](../../Canteen/ITA/S40/DebtLoss.lean), [`PersonalUseLoss.lean`](../../Canteen/ITA/S40/PersonalUseLoss.lean), [`PlanTransferLoss.lean`](../../Canteen/ITA/S40/PlanTransferLoss.lean), [`Paragraph40_2_g.lean`](../../Canteen/ITA/S40/Paragraph40_2_g.lean), and for section 251.1 paragraphs (a) to (g): [`AffiliatedPersons.lean`](../../Canteen/ITA/S251_1/AffiliatedPersons.lean), and for section 251: [`RelatedPersons.lean`](../../Canteen/ITA/S251/RelatedPersons.lean)
- Statute forms, each proven equal to the encoding: [`SuperficialLossStatute.lean`](../../Canteen/ITA/S54/SuperficialLossStatute.lean), [`LossDenialStatute.lean`](../../Canteen/ITA/S40/LossDenialStatute.lean)
- Diagrams: [flowcharts](../graphs/flowcharts.md) and [timelines](../graphs/timelines.md) of the rules as encoded
- Lemmas: [`Canteen/Lemmas/SuperficialLoss.lean`](../../Canteen/Lemmas/SuperficialLoss.lean)
- Tests: [`Canteen/Tests/SuperficialLoss.lean`](../../Canteen/Tests/SuperficialLoss.lean)

## Statute to Lean, paragraph by paragraph

| Statute | Lean | Tested by |
|---|---|---|
| "the taxpayer's loss from the disposition of a particular property" | `isLoss`, `lossAmount` (proceeds less than ACB plus outlays and expenses, per 40(1)(b)) | gain, break-even and one-cent-loss cases |
| (a) "the period that begins 30 days before and ends 30 days after the disposition" | `inPeriod` | day −31, −30, 0, +30, +31 |
| (a) "the taxpayer or a person affiliated with the taxpayer acquires a property" | `Acquirer.isTaxpayerOrAffiliated` | taxpayer, spouse (affiliated), sibling (not affiliated) |
| (a) "that is, or is identical to, the particular property" | `isOrIsIdentical`: `same`, `identical` (judgment call), plus (i) and (j) | same, identical yes/no, different |
| (b) "at the end of that period … owns or had a right to acquire the substituted property" | `paraB` | sold again before the end; one sold and one kept |
| (c) disposition deemed by the listed provisions | `paraC`, `DeemingProvision` (all 15 listed, plus `other`) | every listed provision; an unlisted one |
| (d) "the expiry of an option" | `paraD` | ✓ |
| (e) "a disposition to which paragraph 40(2)(e.1) applies" | `paraE` | ✓ |
| (f) loss restriction event "within 30 days after the disposition" | `paraF` | day +30, +31, before the disposition |
| (g) became or ceased to be exempt "within 30 days after the disposition" | `paraG` | day +15, +31 |
| (h) "subsection 40(3.4) or 69(5) applies" | `paraH` | each |
| (i) right to acquire deemed identical, except a security-only right | `isOrIsIdentical`, `.rightToAcquire` | call option; security-only right |
| (j) SIFT wind-up share acquired before 2013 deemed identical to equity in the entity | `isOrIsIdentical`, `.siftWindUpShare` | acquired 2012-12-31; 2013-01-01 |
| 40(2)(g) opening words: the foreign affiliate surplus carve-out | `LossDenial.notCarvedOut` | carve-out on and off |
| 40(2)(g)(i) "to the extent that it is (i) a superficial loss … is nil" | `LossDenial.rule`, `deniedLoss` | ✓ |
| 53(1)(f) substituted property "of the taxpayer" | `CostAddition.Facts.substitutedProperty` | substituted or not |
| 53(1)(f) "the amount, if any, by which (i) … exceeds (ii) …" | `CostAddition.addition` (truncated difference), `adjustedCostBase` | (ii) nil, smaller, equal, larger |
| 251.1(1)(a) "an individual and a spouse or common-law partner of the individual" | `Affiliation.paragraphA`, `affiliated`, `acquirer` | spouses, siblings, not an individual, another paragraph |
| 40(2)(g)(ii) "a loss from the disposition of a debt or other right to receive an amount" | `debtLoss` (`isDebtOrRight`) | debt, not a debt, gain |
| 40(2)(g)(ii) "unless … acquired … for the purpose of gaining or producing income from a business or property (other than exempt income)" | `debtLoss` exception, `incomePurpose` (fact or judgment call) | purpose met; judged |
| 40(2)(g)(ii) "or as consideration for the disposition of capital property to a person with whom the taxpayer was dealing at arm's length" | `debtLoss` exception, `considerationForCapitalProperty`, `armsLength` (fact or judgment call) | arm's length and not |
| 54 "personal-use property" (a), (b), (c) | `personalUseProperty` | each paragraph |
| 54 "listed personal property" (a) to (e) | `ListedKind`, `isListed` | coin as an investment; art for personal use |
| 40(2)(g)(iii) "personal-use property … (other than listed personal property or a debt referred to in subsection 50(2))" | `personalUseLoss` | listed, 50(2) debt, neither |
| 40(2)(g)(iv)(A) the six listed plans, "under which the taxpayer is a beneficiary or immediately after the disposition becomes a beneficiary" | `planTransferA`, `PlanTrust.inA` | each plan, with and without the taxpayer a beneficiary |
| 40(2)(g)(iv)(B) RRSP, "the taxpayer or the taxpayer's spouse or common-law partner is an annuitant or becomes, within 60 days after the end of the taxation year, an annuitant" | `planTransferB` | RRSP with and without an annuitant; TFSA not in (B) |
| 40(2)(g) "(i) …, (ii) …, (iii) …, or (iv) …" | `paragraph` (`Rule.anyOf` under the carve-out), `deniedLoss` | each subparagraph; carve-out |
| 251.1(1)(b)(i)–(iii) a corporation and its controller, each member of an affiliated controlling group, and their spouses | `candidates` (b) | person, group, not an affiliated group, spouse through a group |
| 251.1(1)(c)(i)–(iii) two corporations | `candidates` (c) | same controller, affiliated controllers, person and group, two groups |
| 251.1(1)(d) a corporation and a partnership | `candidates` (d), `majorityInterestGroups` | family group; mixed group |
| 251.1(1)(e) a partnership and a majority-interest partner | `candidates` (e), `majorityInterestPartner?` | majority only with a spouse's share |
| 251.1(1)(f)(i)–(iii) two partnerships | `candidates` (f) | common partner; (ii) reached through (i); groups; unrelated |
| 251.1(1)(g)(i)–(ii) a person and a trust | `candidates` (g), `majorityInterestBeneficiary?` | income majority; spouse through (g)(ii); two trusts not under (g) |
| 251.1(1)(h)(i)–(iii) two trusts, with affiliated contributors | `candidates` (h), `contributorsAffiliated`, `majorityInterestGroupsB` | each subparagraph; unrelated contributors |
| 251.1(3) "contributor", "majority-interest group of beneficiaries" | `World.contributors` (a fact), `majorityInterestGroupsB` | as above |
| 251.1(4)(d)(iv) individuals connected by blood, marriage, common-law partnership or adoption, for comparing contributors | `World.connected`, `contributorsAffiliated` | siblings |
| 251.1(3) "affiliated group of persons", "controlled", "majority-interest beneficiary", "majority-interest group of partners" | `affiliatedGroup`, `Control.answer`, `majorityInterestBeneficiary?`, `majorityInterestGroups` | as above |
| 251.1(4)(a) persons are affiliated with themselves; (4)(d)(iii) a trust as beneficiary of another | `aff`, `majorityInterestBeneficiary?` | ✓ |
| 248(1) "majority-interest partner" (a) income and (b) winding-up shares, with affiliates' | `majorityInterestPartner?` | ✓ |
| 251(6)(a) blood relationship: child or other descendant, brother or sister | `World.descendant`, `World.sibling`, `World.blood` | child, grandchild, siblings through a parent; not cousins, uncles or nephews |
| 251(6)(b), (b.1) marriage or common-law partnership, including to a person connected by blood to the other | `World.byMarriage` | spouse; in-laws; step-parent |
| 251(6)(c) adoption, legally or in fact, including as the child of a lineal relative of the other | `World.byAdoption` | adopted child; adopted grandchild; not by a sibling |
| 251(2)(a) individuals so connected | `RelatedPersons.candidates` (a) | as above |
| 251(2)(b)(i)–(iii) a corporation and its controller, members of a related controlling group, and persons related to them | `RelatedPersons.candidates` (b) | person, related group, unrelated group, de facto only |
| 251(2)(c)(i)–(vi) two corporations | `RelatedPersons.candidates` (c) | each subparagraph |
| 251(3) two corporations related to the same corporation | `RelatedPersons.candidates` (3) | ✓ |
| 251(4) "related group", "unrelated group" | `relatedGroup` | ✓ |
| 251(1)(a)–(c) arm's length | `armsLength`, `armsLengthAnswer` | related; personal trust; question of fact |
| 40(3.3)(a) a corporation, trust or partnership disposes of capital property (not prescribed depreciable property; not excluded property in an FA surplus computation), otherwise than in a disposition in 54 "superficial loss" (c) to (g) | `SuspendedLoss.applies` | each condition and exception |
| 40(3.3)(b), (c) acquired in the period by the transferor or an affiliated person, and owned at its end | `SuspendedLoss.qualifies` | period edges; not affiliated; not owned |
| 40(3.5)(a), (b), (b.1) rights to acquire; share exchanges under 51, 86, 87, or 85.1; SIFT wind-up shares | `SuspendedLoss.isOrIsIdentical` | each |
| 40(3.5)(c)(i), (ii) after a merger or an 88(1) winding-up, the new corporation or parent; (d) after a redemption, the issuer, deemed to own the share while affiliated with the transferor | `SuspendedLoss.DeemedOwner`, `thirtyDaysWithout`, `deemed_owner_no_release` | redemption with and without (d); affiliation ends; merger; winding-up; another release time |
| 40(3.4)(a) the loss is nil; (b) it arises immediately before the first of the times in (i) to (v) | `suspended`, `suspendedLoss`, `releaseDate` | earliest of several; (v) only for a corporation; times before the disposition ignored |
| 54 "superficial loss" (h) "a disposition to which subsection 40(3.4) applies" | `SuspendedLoss.withSuspension`, `not_superficial_of_applies` | ✓ |
| 251.1(2) new corporation and predecessor deemed affiliated, supposing the new corporation existed immediately before with the shareholders it had immediately after | `Amalgamation.hypothetical`, `affiliatedRule` | sisters; parent and subsidiary; strangers 50/50 |
| 251(3.1) the same, for related persons | `relatedHypothetical`, `relatedRule` | as above |
| 251(3.2) predecessors each related to each other, "otherwise than because of a right referred to in paragraph 251(5)(b)" | `predecessorsRelated`, `Facts.beforeWithoutRights` | related only through an option |
| 40(1)(a), (b) gain and loss; (a)(iii) reserve, at most a reasonable reserve and ⅕ of the gain times (4 − preceding years) | `Disposition.gain`, `loss`, `reserveLimit` | reserve over four years; outlays |
| 39(1)(a), (b) capital gain and loss: not otherwise in income, other than excluded kinds (and depreciable property, for losses) | `capitalGain`, `capitalLoss` | income account; depreciable; excluded |
| 39(1)(c) business investment loss | `businessInvestmentLoss` (a fact, with its reductions) | SBC shares |
| 38(a), (a.1)(i), (b), (c) one half; nil for listed securities given to a qualified donee | `taxableCapitalGain`, `allowableCapitalLoss`, `allowableBusinessInvestmentLoss` | half cents; gift |
| 41(1)–(3) listed personal property: pooled; losses of other years claimed; the year's loss | `Year.lppExcess`, `lppNetGain`, `lppTaxableNetGain`, `lppLoss` | pooled; cannot offset other gains; claims capped |
| 3(a)–(f) income for the year | `Income.income`, `report` | other income; ABIL; capital losses not against other income |
| 40(3.6) a share of the corporation, disposed of to it, affiliated immediately after; not a distress preferred share; not excluded property | `ShareToAffiliate.applies` | redemption; unaffiliated corporation; distress preferred |
| 40(3.6)(b), 53(1)(f.2) the loss spread over the remaining shares by fair market value | `ShareToAffiliate.additions`, `addition_le_loss` | 90:10 |
| 40(2)(e.1) an obligation, payable immediately after by another to the transferee, the three related to each other (or so under 80(2)(j)) | `RelatedDebt.applies`, `relatedToEachOther` | family group; friend; 80(2)(j) |
| 53(1)(f.1) the transferee's cost, between taxable Canadian corporations | `transfereeCostAddition` | ✓ |
| 54 "principal residence": housing unit, owned, (a) ordinarily inhabited by the taxpayer, spouse or former spouse, or child, or (b) a 45(2)/(3) election, and (c) designated with no other designation by the family unit | `PrincipalResidence.principalResidence`, `blocks` | each family member; separated spouse; adult child; minor taxpayer; before 1982 |
| 40(2)(b) A − A × B / C − D, with the "plus one" where resident in the acquisition year | `PrincipalResidence.b`, `c`, `exempt`, `gain`, `exempt_of_b_ge_c` | all years; all but one; five of eleven; non-resident years |
| 69(1)(a) acquired from a non-arm's length person above fair market value; (b)(i)–(iii) disposed of below fair market value to one, by gift, or to a trust without change in beneficial ownership; (c) acquired by gift, bequest, inheritance, or without change | `NonArmsLength.sellerAtFairMarketValue`, `buyerAtFairMarketValue`, `undervalue_sale_double_counted` | child; friend (judged); gift; bare trust |
| 73(1) capital property of an individual (not a trust), (1.01) to a spouse, a former spouse in settlement, or a qualifying trust, both resident, no election out: at adjusted cost base (or the prescribed class share) | `SpousalRollover.rollover`, `proceeds`, `transfereeCost` | each transferee; election; non-resident; child |
| 70(5)(a), (b) deemed disposition and acquisition at fair market value on death | `Death.proceeds`, `recipientCost` | child; non-resident deceased |
| 70(6) to a resident spouse or qualifying spousal trust, vested within 36 months: at adjusted cost base (or the prescribed class amount); 70(6.2) election out | `Death.rollover`, `rollover_no_gain` | spouse; trust; non-resident spouse; not vested; election realizing a loss |
| 74.2(1)(a)–(e) the spouse's net taxable capital gains (or allowable capital losses), and listed-personal-property gains and losses, on lent or transferred property in the attribution period, are the transferor's and not the spouse's | `Attribution.toIndividual`, `recipientYear`, `net_one_way` | gain; net with a loss; net loss; painting |
| 74.5(1) fair market value consideration, adequate interest paid on time, and (for a spouse) an election out of 73(1) | `fairMarketValueException`, `nothing_on_fair_market_value` | each condition |
| 74.5(3)(b) separated, with a joint election | `RecipientDisposition.separatedWithJointElection` | ✓ |
| 74.1(1) income or loss from property transferred or lent to a spouse or common-law partner, in the period; (2) to a minor not at arm's length or a niece or nephew, unless 18 by year-end | `IncomeAttribution.applies`, `counted`, `attributedIncome`, `income_split` | gift; out of period; minor; turned 18; adult child |
| 74.1(3) the share of other property's income where the property repaid its debt | `repaymentShare`, `repayment_share_le` | a quarter of rent; a loss |
| 74.5(2) loans at the prescribed (or arm's length) rate, interest paid within 30 days; 74.5(3)(a) separation | `loanForValue`, `prescribed_rate_loan`; `Amount.separated` | paid late; separated months; separation irrelevant for a minor |
| 45(1)(a), (c) a change in the use regularly made between gaining or producing income and other purposes: a deemed disposition at the proportion of fair market value that the change is of the whole use, and reacquisition at that amount; (b) the cost split in the same proportion | `ChangeInUse.deemedDisposition`, `change`, `proceeds`, `portionCost`, `costAfter`, `gains_add_up` | renting out a home; a basement; moving in; half a duplex; no change |
| 45(2) the election: deemed not to have begun or increased income use; (c) rescission ends its coverage | `ChangeInUse.deemedDisposition` (45(2) clause), `covers45_2`, `elect_45_2` | whole and partial; does not reach a change away from income; rescinded |
| 45(3), (4) the election on becoming the principal residence, unless capital cost allowance was claimed after 1984 | `ChangeInUse.election45_3`, `cca_defeats_45_3`, `covers45_3` | elected; CCA claimed; not a principal residence |
| 54 "principal residence" (d): not because of (b), if solely because of (b) it would have been for 4 or more preceding years | `PrincipalResidence.paraD`, `electionYearsBefore` | four years then not; moving back in; undesignated years; the judgment call relied on only once (d) can matter |
| 85(1) eligible property, to a taxable Canadian corporation, for consideration including its shares, jointly elected | `TransferToCorporation.rollover` | no shares |
| 85(1)(a), (b), (c), (c.1), (e), (e.3) the elected amount: agreed, at least the boot and the floor, at most fair market value | `electedBeforeBenefit`, `electedAmount`, `elected_le_fairMarketValue`, `boot_le_elected`, `at_cost_no_gain` | at cost; boot over cost; above value; below the floor; a loss; depreciable; boot over the depreciable floor |
| 85(1)(e.2) a benefit to a related person: added to the elected amount except for (g) and (h) | `excess`, `benefitAddition`, `benefit_not_in_share_cost` | benefit judged; no excess |
| 85(1)(f), (g), (h) the cost of the boot, the preferred shares and the common shares | `bootCost`, `preferredCost`, `commonCost`, `single_common_takes_rest` | note and preferred; boot over cost; two common classes |
| 85(2.1)(a) the paid-up capital reduction, (A − B) × C / A | `pucReduction`, `paidUpCapital`, `puc_single_class` | ✓ |
| 84.1(1) a resident non-corporate taxpayer, capital property shares of a resident corporation, to a corporation not at arm's length, connected immediately after | `SurplusStripping.applies`, `notArmsLength` | corporate vendor; arm's length (judged); not connected |
| 84.1(1)(a) the paid-up capital reduction (A − B) × C / A; (b) the deemed dividend (A + D) − (E + F) | `reduction`, `paidUpCapital`, `dividend`, `no_dividend_within_e`, `boot_over_e_is_dividend` | note over E; $100 note; cost from a purchase |
| 84.1(2)(a.1) hard adjusted cost base; (b) control groups of fewer than 6; (d) trusts and beneficiaries; (e) intergenerational transfers | `hardCost`, `notArmsLength`, `intergenerational_outside` | crystallized cost; group control; intergenerational |
| 54 "proceeds of disposition" (k) excludes the 84.1 dividend | `SurplusStripping.proceeds`, `proceeds_add_dividend` | ✓ |
| 82(1)(a), (a.1) taxable dividends and eligible dividends from resident corporations; (b) the gross-up for individuals, by year; (c), (d) without gross-up | `Dividends.paraA`, `paraA1`, `grossUp`, `paraCD`, `inclusion`, `non_eligible_2025` | 2025, 2018, 2010, 2007; no rate for 2015; a corporation; (c); (d); non-resident payer |
| 121(a), (b) the credit, a fraction of each gross-up, by year | `Dividends.credit`, `credit_le_grossUp` | each fraction; the 84.1 dividend in the crystallization |
| 112(1) a taxable dividend from a taxable Canadian corporation, or a resident corporation the recipient controls | `IntercorporateDividends.deductible`, `deduction` | each payer; non-resident payer |
| 55(2.1)(a)–(c), 55(5)(f) deductible; a purpose (or for 84(3), a result) of reducing a gain, or a share's value or increasing cost; the excess over safe income, a separate dividend | `subsection55_2`, `purposeTest`, `excessPortion`, `within_safe_income`, `caught_le_excess` | pre-sale dividend; within safe income; purpose judged no; (b)(ii); (b)(ii) not on a redemption |
| 55(2)(a)–(c) not a dividend; proceeds of the redeemed share, or a capital gain | `caught`, `proceedsAddition`, `gain`, `conserved` | redemption with an unrelated buyer; ordinary dividend |
| 55(3)(a) related-party redemptions; 55(3)(b) butterflies | `relatedPartyException`, `related_redemption` | redemption alone; butterfly |
| 110.6(1) "qualified small business corporation share" (a) a small business corporation share owned by the family, (b) 24 months' related ownership, (c) a CCPC with more than 50% qualifying assets, (e) substitutions | `CapitalGainsDeduction.qualifiedShare`, `AssetPeriod.meets` | exactly 50%; not a CCPC; unrelated owner; judged SBC |
| 110.6(1) "annual gains limit" A − B; "cumulative gains limit" (a) − (b) to (e) | `annualA`, `annualB`, `annualGainsLimit`, `cumulativeGainsLimit`, `deduction_le_annual`, `cnil_never_helps` | other losses; net capital losses deducted; ABIL; CNIL |
| 110.6(2.1)(a) to (d) the least of the remaining limit, the two gains limits less the (2) deduction, and the shares' 3(b) amount | `deduction`, `remainingLimit`, `sharesAmount`, `lifetime_limit`, `deduction_le_shares` | under and over the limit; prior deductions; indexed limit; non-resident; other gains |
| 251.2(2)(a) control of a corporation acquired by a person or group of persons | `LossRestrictionEvent.lossRestrictionEvent`, `newControllers`, `no_new_controller` | stranger; no change; de facto only; judged control; not a corporation |
| 256(7)(a)(i)(A)–(D) acquisitions from related persons, by persons related to the corporation, by and from estates | `fromRelated`, `acquirerRelated`, `death`, `related_sale`, `to_estate` | child; holding company; estate to a stranger and to a child |
| 256(7)(a)(ii) redemptions and changes in rights; (iii) related groups | `redemption`, `relatedGroup` | redemption to a stranger and to a spouse; related group from related and unrelated control |
| 111(8) "net capital loss": A − B + C − D | `NetCapitalLoss.netCapitalLoss`, `ExpiredBIL` | gains and losses; ABIL excluded; C with and without a loss restriction event; D |
| 111(1)(b) losses "for taxation years preceding and the three taxation years immediately following the year" | `Claim.allowedFor` | prior year; three years later; four years later; same year |
| 111(1.1)(a) the lesser of 3(b) and Σ A × B / C | `Claim.adjusted`, `deduction` | capped at 3(b); a ¾ year |
| 50(2) a personal-use debt owing by an arm's length person, established to be bad in the year | `BadDebtPersonalUse.rule` | each condition |
| 50(2)(a) deemed proceeds: the amount, if any, by which (i) the debt's adjusted cost base exceeds (ii) the gain on the related disposition; (b) reacquisition at that amount | `deemedProceeds`, `reacquisitionCost`, `loss_eq_min` | gain larger, smaller, nil |

## Interpretation choices to confirm

1. **The period includes both ends.** "Begins 30 days before and ends 30 days after" is read as day −30 to day +30 inclusive (61 days), at the granularity of whole days.
2. **"Within 30 days after" in (f) and (g)** is read as the day of the disposition through day +30. An event on the day of the disposition counts. An event before it does not.
3. **"Identical" is a judgment call** for each acquisition, with a risk for each answer. `same` (the very property) and the deeming rules in (i) and (j) are treated as facts.
4. **Paragraph (i)** is encoded for a right to acquire *the particular property*. A right to acquire a property that is itself only *identical* to it would need the identity judgment as well. It is not modelled separately.
5. **Paragraph (j)** is encoded as the substituted property being a share of a SIFT wind-up corporation in respect of the entity whose equity is the particular property. "Acquired before 2013" means before 2013-01-01.
6. **Paragraph (b)** ("owns or had a right to acquire") is a single fact per acquisition. It isn't derived from later dispositions.
7. **Inputs from provisions not yet encoded** are taken as facts:
   - affiliation under paragraphs 251.1(1)(b) to (g), and who is a spouse or common-law partner;
   - loss restriction event (s. 251.2);
   - whether 40(2)(e.1), 40(3.4) or 69(5) applies;
   - the 40(2)(g) foreign affiliate carve-out.
8. **Any one qualifying acquisition is enough.** When several qualify, the explanation cites one that rests on facts before one that rests on judgment.
9. **"To the extent that" is not quantified.** The rule decides whether the loss is a superficial loss. `deniedLoss` treats the whole loss as denied. Partial cases (for example, fewer shares bought back than sold) are left for a later phase. The Act gives no formula for them.
10. **Not encoded:** subsection 50(2) (which debts it refers to), section 251 (arm's length), and the amount in 53(1)(f)(ii); each is an input.
11. **53(1)(f), amount (i):** "the amount of the loss that was, because of the acquisition by the taxpayer of the property, a superficial loss" is an input. In the spouse transaction it is the whole denied loss, which assumes the spouse's shares are the only substituted property.
12. **53(1)(f), amount (ii):** the amount that would be deducted under 112(3) to (3.2) is an input (nil in the examples). "The amount, if any, by which (i) exceeds (ii)" is read as (i) minus (ii), or nil.
13. **251.1(1)(a)** is read as requiring the first person to be an individual and the second to be that individual's spouse or common-law partner. It is symmetric in practice, but the encoding takes the facts in that order.
14. **Affiliation can be a judgment call.** Whether one of paragraphs 251.1(1)(b) to (g) applies is a fact or a judgment call. When it is a judgment call, the superficial loss acquirer records it (`Acquirer.judged`), and every finding that turns on it relies on it.
15. **40(2)(g)(ii):** "acquired … for the purpose of gaining or producing income" and arm's length dealing are each a fact or a judgment call. The "unless" is read as two alternative exceptions. Exempt income is not separately modelled: the income purpose must be "other than exempt income".
16. **"Personal-use property" says "includes".** Its three listed categories are encoded. Any ordinary meaning beyond them must come in through the judgment call in paragraph (a). The partnership part of the definition is not encoded.
17. **"Listed personal property"** is read as personal-use property that is, or is a portion of or an interest in or right to, one of the five listed kinds. Which kind it is, if any, is a fact.
18. **40(2)(g)(iv):** the TFSA holder is treated as "a beneficiary" under the TFSA. "Within 60 days after the end of the taxation year" in (B) is a single fact, not computed from dates.
19. **Section 251.1 is computed for a world of persons** as the smallest relation that contains every pair paragraphs (a) to (g) name and is symmetric and reflexive. The recursive references ("is affiliated with" inside (c), (d), (f) and (g), and in the majority-interest tests) are read as references to that same relation. (g)(ii) uses the relation computed without paragraph (g). Each result is checked to be closed.
20. **"Controlled" means "directly or indirectly in any manner whatever"** (251.1(3)). Each control is given as a fact or a judgment call (for example, de facto control). Indirect control must be given explicitly: the encoding does not infer that a parent's controller controls its subsidiary.
21. **Control by "a person" and by "a group of persons" are kept apart,** as (b) and (c) distinguish them. For (d), "controlled by a particular group of persons" is read as a group; to treat one person as a group of one, give the control as a group with one member.
22. **Majority-interest partner (248(1)):** the share the taxpayer "would" have had, holding every interest it or an affiliate holds, is taken as the sum of those interests' shares. A majority-interest group of partners is computed from all subsets of the partners: the group's combined shares exceed half, and no member can be dropped. With this reading, 251.1(1)(f)(ii) is always also reached through (f)(i).
23. **Majority-interest beneficiary (251.1(3)):** interests are given at fair market value, after applying 251.1(4)(d)(i) (discretionary powers deemed exercised or not). A trust needs its own interest of the kind in question (251.1(4)(d)(iii)). 251.1(4)(d)(ii) (arm's length) is not needed for (a) to (g).
24. **Paragraph (h):** whether a person is a "contributor" (251.1(3), with its arm's length and fair value exceptions) is a fact, and so is who is "connected by blood relationship, marriage, common-law partnership or adoption" (251.1(4)(d)(iv)). (g)(ii) reads the subsection without (g), so it includes (h).
25. **Not encoded:** 251.1(4)(d)(ii) (arm's length with a trust).
26. **"Controls" in 251(2) is read as de jure control** (control of the votes), since 251(2) does not say "directly or indirectly in any manner whatever". A control can be marked de facto only: it then counts for affiliation, not for 251(2). Rights under 251(5)(b), and 251(5)(a) (a related group in a position to control is deemed to control), must be reflected in the controls given.
27. **A person is not related to itself,** except that 251(5)(c) makes a shareholder of two corporations related to itself in each capacity: the encoding lets one person satisfy "related to" in 251(2)(c) for that reason.
28. **251(6)(a) "brother or sister"** is computed as sharing a parent (so half-siblings count), or given directly. Lineal descent is through children by blood; adoptions count only through 251(6)(c).
29. **251(6)(c)** is read as: one adopted, legally or in fact, as the child of the other, or as the child of a person who is the other's ancestor or descendant (the words "otherwise than as a brother or sister" exclude siblings).
30. **251(1)(b)** (personal trusts) is a fact, not computed: the 248(25) reference is not encoded.
31. **Not encoded:** the 125(7) purposes of 251(5).
32. **40(3.3) to (3.5):** "owns" in (3.3)(c) is a fact per acquisition (unlike the superficial loss definition, a right to acquire does not count there). Each release time in 40(3.4)(b)(i) to (v) is given as the date it occurs; (i) is the day the 30-day period without the property begins. The deeming rules in 40(3.5)(c) and (d) (mergers, wind-ups, redemptions) must be reflected in who owns the property. The partnership continuation rule at the end of 40(3.4) is not encoded.
33. **Amalgamations (251.1(2), 251(3.1)).** The supposition is a hypothetical world: the world immediately before, with the new corporation added and controlled as it is immediately after, by the shareholders it then has (the control must be given, as elsewhere). The predecessors keep their own shareholders in that world. "Deemed to have been affiliated [related]" is reported as a yes-or-no answer; the times for which the deeming matters (for example, under 40(3.4)) are for the provision that uses it.
34. **251(3.2).** Control that exists only because of a 251(5)(b) right is left out by giving the world without it (`beforeWithoutRights`). "Each of which was related … to each other" is read as every pair of predecessors being related. The deemed relationship is reported between the new corporation and each predecessor.
35. **Not encoded:** 40(3.5)(c), which deems the corporation formed on a merger to own a share whose loss is suspended.
36. **50(2):** "established by the taxpayer to have become a bad debt in the year" is a fact or a judgment call, and so is arm's length (which 251 can supply). "The amount, if any, by which (i) exceeds (ii)" is (i) minus (ii), or nil. The resulting loss is proven to be the lesser of the debt's cost and the gain.
37. **"To the extent that" for (ii) to (iv)** is read as the whole loss: the loss is entirely from the disposition of the debt, personal-use property, or property transferred. `Paragraph40_2_g.deniedLoss` treats the whole loss as nil when any subparagraph applies, as `LossDenial.deniedLoss` does for (i).
38. **Capital gains (38 to 41).** Taxable amounts are kept in half-cents, so ½ of an odd number of cents is exact (shown as, for example, $254.995). Whether a gain or loss is on capital account (39(1)(a), (b): "would not … be included in computing the taxpayer's income") is a fact or a judgment call. 39(1)(c) (business investment loss) is a fact with its reductions given; "small business corporation" and 39(9), (10) are not encoded. 38(a.2) and (a.3) are not encoded. The 40(1)(a)(iii) reserve is the amount claimed, capped at the lesser of a reasonable reserve and ⅕ of the gain times (4 − preceding years), with the product rounded down to the cent; 40(1.1) (ten-year reserves) is not encoded.
39. **Section 41.** "Gains" and "losses" are 40(1) gains and losses. Listed-personal-property losses of other years are a single amount claimed; the ordering rules in 41(2)(b)(i), (ii) are for the taxpayer to respect. 39(1)(a)(i.1) property is excluded from the pool's gains, as an excluded kind.
40. **Section 3.** Income from sources, Subdivision E deductions and losses from sources are given amounts. Unused allowable capital losses are reported, but the net capital loss carryover (111(1)(b), 111(8)) is not encoded.
41. **Net capital losses (111).** Each loss year's section 38 fraction is given (½ unless stated) rather than taken from a table of past rates, since the Act's current text states only ½. A × B / C is rounded down to the half-cent where it is not exact. The C term of 111(8) takes its three amounts as given. 111(1.1)(b) (pre-1986 losses) and (c) are not encoded. Taxable income (2(2)) is income less the net capital loss deduction and any other Division C deductions, given.
42. **40(3.6).** Affiliation is decided on the world immediately after the disposition. The share's class and fair market values of the remaining shares are given; each share's addition is rounded down to the cent, so the additions can fall short of the loss by a few cents (proven never to exceed it). "Distress preferred share" (80(1)) is a fact.
43. **40(2)(e.1).** "Related to each other" is read as each of the three pairs being related. Whether they would be related if 80(2)(j) applied is a fact. For 53(1)(f.1), whether both are taxable Canadian corporations, and whether 53(1)(f.2) applies, are facts.
44. **Principal residence.** Encoded for an individual other than a personal trust; (a.1), (c.1), 40(2)(c) and section 54.1 are not encoded. "Ordinarily inhabited" is a fact or a judgment call. Each other designation for a year is given with who made it; marital status and age are given per year. "Taxation years that end after the acquisition date" are the years listed, and each says whether the property was owned. A × B / C is rounded down to the cent, so any rounding is against the taxpayer by under a cent. D (the 1994 election) is given.
45. **69(1).** Arm's length is an `Answer`, from section 251 where it settles it. Fair market value is given. "Except as expressly otherwise provided" is not modelled: where a rollover (70(6), 73(1), 85(1) and so on) applies, 69(1) should not be applied to the same transfer. "Anything" is read as any property.
46. **73(1).** The kind of transferee in 73(1.01) is a fact, including whether a trust meets (c)(i), (ii) or (iii); 73(1.02) is not encoded. For depreciable property of a prescribed class, the proportion of undepreciated capital cost is given. Where 73(1) does not apply (including on an election out), the transfer is left to 69(1). The attribution rules (74.1, 74.2) are not encoded.
47. **Death (70(5), (6)).** The recipient, residence, whether the trust meets 70(6)(b)(i) and (ii), and vesting within 36 months are facts; the Minister's extension of that period is not modelled. For depreciable property the 70(6)(d)(i) amount is given; 70(5)(c), (d) and 70(6)(d.1), (e) are not encoded. 70(6.2) is a fact per property. Deemed dispositions on death carry `deemedBy := some .s70` for the superficial loss definition.
48. **Attribution (74.2, 74.5).** Which of the recipient's dispositions are of lent or transferred property (or property substituted for it) is given, as is whether each falls in the attribution period. "Directly or indirectly, by means of a trust or by any other means whatever" is part of what is given. 74.5(1)(b)'s two interest conditions are facts. The individual's attributed amounts enter their year through `Year.attribution`; the recipient's year leaves those dispositions out (74.2(1)(e)). 74.1 (income attribution), 74.3 and 74.4 are not encoded.
49. **Change in use (45).** Use is measured in parts of a whole, given before and after. A change from wholly one purpose to wholly the other is paragraph (a); any other change is (c). The deemed disposition is read as of the proportion of the property that changed, with that proportion of the adjusted cost base (45(1)(b)) as its cost; both amounts are rounded down to the cent. Whether the part that changes is personal-use property (so that a loss is nil under 40(2)(g)(iii)) is a fact. 45(2) is read as reaching (a)(i) and (c)(ii) and 45(3) as reaching (a)(ii) and (c)(i); 45(4) is a fact. Section 13, 45(1)(d), the timing of the 45(3) election, and the deemed change on rescission (45(2)(c)) are not encoded. For the principal residence definition, (d) counts preceding years that are owned, covered by an election, designated and not blocked, and not ordinarily inhabited.
50. **Transfer to a corporation (85(1), (2.1)).** Eligible property, a taxable Canadian corporation and a joint election filed in time are facts. (b), (c), (c.1), (e) and (e.3) are read together as: the elected amount is the amount agreed, raised to the boot and to the floor in (c.1) or (e), and capped at fair market value (proven). For capital property the cost amount is its adjusted cost base; for depreciable property, the class's undepreciated capital cost is given. Whether (e.2) applies is a fact or a judgment call, relied on only when there is an excess; the part of the excess is all of it unless given. Proportions in (f), (g), (h) and 85(2.1) are rounded down to the cent. Where 85(1) does not apply, the disposition is taken at fair market value. The paid-up capital increase for each class (before 85(2.1)) is given. (c.2), (e.1), (e.4), (e.5), (i), (1.11), (1.12), (1.2), 85(2.1)(b) and section 84.1 are not encoded; nor whether a loss on the transfer is denied (40(2)(g)(i), 40(3.4)), which those provisions decide.
51. **Section 84.1.** "Connected" (186(4)) is a fact, as are (2)(b), (2)(d) and whether (2.31) or (2.32) applies for (2)(e); otherwise arm's length is a fact or a judgment call. The (2)(a.1) reduction is given as one amount; 84.1(2)(a) (shares acquired before 1972) is not encoded. The new shares' paid-up capital increase per class is given. The proceeds otherwise are given (for a 85(1) transfer, the elected amount, via `ofTransfer`), and the dividend is taken out of them under 54 "proceeds of disposition" (k). A capital loss that results (for example, where the cost is mostly crystallized gains) is for 40(2)(g)(i) and 53(1)(f) to deal with. The dividend's gross-up and credit are not encoded.
52. **Capital gains deduction (110.6).** The deduction is in half-cents, like the taxable capital gains it shelters. The indexed 110.6(2)(a) amount is given ($625,000 by default, for years beginning before 2026), and E is 1. A + B + C + D (earlier deductions with their pre-2000 weights) is given, separately from the unweighted total for "cumulative gains limit" (d); so are earlier years' A and B, the 1985 3(e) amount, the cumulative net investment loss, the net capital losses deducted under 111(1)(b) for the year, and the 110.6(2) deduction. Which dispositions are of qualified small business corporation shares (or of qualified farm or fishing property) is given; `qualifiedShare` decides the definition for one share. "Small business corporation" (248(1)) is a fact or a judgment call. "More than 50%" is read strictly. (d) and (f) of the definition, 110.6(2.2), (2.3), (7) to (11), and the alternative minimum tax are not encoded.
53. **Loss restriction events (251.2, 256(7)).** Only corporations (251.2(2)(a)); trusts are not encoded. Each event is one acquisition, redemption or death, described by the world immediately before and after. Control is de jure (a control given as `deFactoOnly` does not count) and is acquired when a person or group controls after who did not before; a change in a controlling group's membership is an acquisition by the new group. Relatedness is section 251 on the world before, with rights under 251(5)(b) reflected in the controls given. In (i)(D) whether the deceased was related to the acquirer before the death is a fact. 256(7)(a)(i)(E), (ii)(B), 256(7)(b) to (g), 256(8) and 111(4) to (5.5) are not encoded. `eventDate` supplies the date to superficial loss (f); 40(3.4)(b)(iii) and the C term of 111(8) take it the same way.
54. **Income attribution (74.1).** The recipient's kind is a fact: a spouse or common-law partner (including one who has since become so), a minor who is not at arm's length with the individual or is a niece or nephew, or other. Which amounts are income or loss from the property or substituted property, and whether each falls in the period, are given; income on attributed income is not from the property and stays with the recipient. 74.5(1) is the existing `fairMarketValueException`, with `toSpouse` taken from the recipient. In 74.1(3), the fair market value used is capped at the other property's cost and the share is rounded down to the cent. The pension assignment exclusion in 74.1(1), 74.3, 74.4 and 56(4.1) are not encoded.
55. **40(3.5)(c), (d).** What happened to the share (a merger, an 88(1) winding-up, or a redemption, acquisition or cancellation by its issuer), its date, and the date the deemed owner ceases to be affiliated with the transferor, if it does, are given; affiliation could be decided from a world under section 251.1, but is given here. While the deemed owner is affiliated, the 30-day period in 40(3.4)(b)(i) does not begin; once affiliation ends, it is read as beginning that day. (c)(iii) (foreign affiliate liquidations) is not encoded.
56. **Dividends (82(1), 121).** Whether a dividend is an eligible dividend (89(14)) is a fact, as are the payer's residence and status and any dividend rental arrangement. Each gross-up and credit is rounded down to the cent. Where the consolidated text gives no rate for the year (non-eligible dividends before 2018, eligible dividends before 2006, the eligible credit before 2009), none is applied and the explanation says so; the historical rates are in the amending Acts. Dividends from non-resident corporations are left out (they are income from property under 90). The 260(5.1) deductions and paragraph (e) are not encoded. The deemed dividend under 84.1(1)(b) is taken as not eligible.
57. **Intercorporate dividends (112(1), 55(2)).** The payer's kind, whether the dividend is on a redemption to which 84(2) or (3) applies, safe income, whether the series includes each of the events in 55(3)(a)(i) to (v) involving an unrelated person (55(3.01)(a)), and whether 55(3)(b) applies are facts. The purpose (or result) tests in (2.1)(b) are judgment calls or facts; for an 84(3) dividend the "results" reading is folded into the same answer. After 55(5)(f) splits the dividend, (2.1)(c) is read as reaching the excess portion and not the safe-income portion, so only the excess is recharacterized. Part IV tax, 55(2.2) to (2.5), 55(3.01)(b) to (g), 112(2) to (2.9) and 138(6) are not encoded.

## Reviewer checklist

- [ ] Each row of the table matches the statute text.
- [ ] Each interpretation choice above is acceptable, or is flagged for change.
- [ ] The read-back below says what the statute says, with the right citations.

## Read-back

These are the explanations the encoding produces, pinned word for word by the tests. The scenarios are constructed examples, not published CRA examples or decided cases.
Base case: 100 shares sold on 2025-06-15 at a loss of $509.99.

### Shares repurchased within the period (identical: judgment call)

```
1. The taxpayer disposed of 100 common shares of ABC Ltd. on 2025-06-15 for proceeds of $1,000.00. The adjusted cost base plus outlays and expenses was $1,509.99, so the taxpayer's loss from the disposition is $509.99. [ITA 40(1)(b)]
2. On 2025-06-20, within the period from 2025-05-16 to 2025-07-15, the taxpayer acquired 100 common shares of ABC Ltd. That property is identical to the particular property (judgment call J-ID). [ITA 54 "superficial loss" (a)]
3. At the end of that period, on 2025-07-15, the taxpayer or a person affiliated with the taxpayer owned or had a right to acquire that property. [ITA 54 "superficial loss" (b)]
4. The disposition is not one described in paragraphs (c) to (h), so the taxpayer's loss of $509.99 is a superficial loss. [ITA 54 "superficial loss"]
Relies on these judgment calls:
- J-ID: Are the shares bought identical to the shares sold? Assumed: yes. Risk: low.
Overall risk: low.
```

### Four acquisitions, each failing for a different reason

```
1. The taxpayer disposed of 100 common shares of ABC Ltd. on 2025-06-15 for proceeds of $1,000.00. The adjusted cost base plus outlays and expenses was $1,509.99, so the taxpayer's loss from the disposition is $509.99. [ITA 40(1)(b)]
2. The property acquired on 2025-07-16 (100 common shares of ABC Ltd.) was acquired outside the period from 2025-05-16 to 2025-07-15, so it does not meet paragraph (a). [ITA 54 "superficial loss" (a)]
3. The property acquired on 2025-06-20 (100 common shares of ABC Ltd.) was acquired by the taxpayer's sibling, a person not affiliated with the taxpayer, so it does not meet paragraph (a). [ITA 54 "superficial loss" (a)]
4. At the end of the period, on 2025-07-15, neither the taxpayer nor a person affiliated with the taxpayer owned or had a right to acquire the property acquired on 2025-06-25 (100 common shares of ABC Ltd.), so it does not meet paragraph (b). [ITA 54 "superficial loss" (b)]
5. The property acquired on 2025-07-01 (100 common shares of ABC Ltd.) is not identical to the particular property (judgment call J-ID), so it does not meet paragraph (a). [ITA 54 "superficial loss" (a)]
6. No property meets both paragraphs (a) and (b), so the loss is not a superficial loss. [ITA 54 "superficial loss"]
Relies on these judgment calls:
- J-ID: Are the shares bought identical to the shares sold? Assumed: no. Risk: high.
Overall risk: high.
```

### Nothing acquired

```
1. The taxpayer disposed of 100 common shares of ABC Ltd. on 2025-06-15 for proceeds of $1,000.00. The adjusted cost base plus outlays and expenses was $1,509.99, so the taxpayer's loss from the disposition is $509.99. [ITA 40(1)(b)]
2. Neither the taxpayer nor a person affiliated with the taxpayer acquired the particular property or an identical property in the period from 2025-05-16 to 2025-07-15. [ITA 54 "superficial loss" (a)]
3. No property meets both paragraphs (a) and (b), so the loss is not a superficial loss. [ITA 54 "superficial loss"]
```

### No loss

```
1. The taxpayer disposed of 100 common shares of ABC Ltd. on 2025-06-15 for proceeds of $1,600.00, which are not less than the adjusted cost base plus outlays and expenses of $1,509.99. There is no loss, so there is no superficial loss. [ITA 40(1); ITA 54 "superficial loss"]
```

### Exception (c): deemed disposition on death (section 70)

```
1. The taxpayer disposed of 100 common shares of ABC Ltd. on 2025-06-15 for proceeds of $1,000.00. The adjusted cost base plus outlays and expenses was $1,509.99, so the taxpayer's loss from the disposition is $509.99. [ITA 40(1)(b)]
2. The disposition was deemed to have been made by section 70, so the loss is not a superficial loss. [ITA 54 "superficial loss" (c)]
```

### Exception (f): loss restriction event within 30 days after

```
1. The taxpayer disposed of 100 common shares of ABC Ltd. on 2025-06-15 for proceeds of $1,000.00. The adjusted cost base plus outlays and expenses was $1,509.99, so the taxpayer's loss from the disposition is $509.99. [ITA 40(1)(b)]
2. The taxpayer was subject to a loss restriction event on 2025-07-15, within 30 days after the disposition, so the loss is not a superficial loss. [ITA 54 "superficial loss" (f)]
```

### Paragraph (i): a call option is deemed identical

```
1. The taxpayer disposed of 100 common shares of ABC Ltd. on 2025-06-15 for proceeds of $1,000.00. The adjusted cost base plus outlays and expenses was $1,509.99, so the taxpayer's loss from the disposition is $509.99. [ITA 40(1)(b)]
2. On 2025-06-20, within the period from 2025-05-16 to 2025-07-15, the taxpayer acquired a call option to acquire 100 common shares of ABC Ltd. That property is a right to acquire the particular property. [ITA 54 "superficial loss" (a)]
3. A right to acquire a property (other than a right, as security only, derived from a mortgage, hypothec, agreement for sale or similar obligation) is deemed to be a property that is identical to the property. [ITA 54 "superficial loss" (i)]
4. At the end of that period, on 2025-07-15, the taxpayer or a person affiliated with the taxpayer owned or had a right to acquire that property. [ITA 54 "superficial loss" (b)]
5. The disposition is not one described in paragraphs (c) to (h), so the taxpayer's loss of $509.99 is a superficial loss. [ITA 54 "superficial loss"]
```

### Paragraph (j): SIFT wind-up share acquired before 2013

```
1. The taxpayer disposed of 200 units of XYZ Income Fund on 2013-01-10 for proceeds of $1,000.00. The adjusted cost base plus outlays and expenses was $1,509.99, so the taxpayer's loss from the disposition is $509.99. [ITA 40(1)(b)]
2. On 2012-12-31, within the period from 2012-12-11 to 2013-02-09, the taxpayer acquired 200 shares of XYZ Corp. That property is a share of the capital stock of a SIFT wind-up corporation in respect of the SIFT wind-up entity whose equity is the particular property. [ITA 54 "superficial loss" (a)]
3. The share was acquired before 2013, so it is deemed to be a property that is identical to equity in the SIFT wind-up entity. [ITA 54 "superficial loss" (j)]
4. At the end of that period, on 2013-02-09, the taxpayer or a person affiliated with the taxpayer owned or had a right to acquire that property. [ITA 54 "superficial loss" (b)]
5. The disposition is not one described in paragraphs (c) to (h), so the taxpayer's loss of $509.99 is a superficial loss. [ITA 54 "superficial loss"]
```

### Two acquisitions: the factual one is cited, not the judgment one

```
1. The taxpayer disposed of 100 common shares of ABC Ltd. on 2025-06-15 for proceeds of $1,000.00. The adjusted cost base plus outlays and expenses was $1,509.99, so the taxpayer's loss from the disposition is $509.99. [ITA 40(1)(b)]
2. On 2025-06-22, within the period from 2025-05-16 to 2025-07-15, the taxpayer's spouse, a person affiliated with the taxpayer, acquired 100 common shares of ABC Ltd. That property is the particular property. [ITA 54 "superficial loss" (a)]
3. At the end of that period, on 2025-07-15, the taxpayer or a person affiliated with the taxpayer owned or had a right to acquire that property. [ITA 54 "superficial loss" (b)]
4. The disposition is not one described in paragraphs (c) to (h), so the taxpayer's loss of $509.99 is a superficial loss. [ITA 54 "superficial loss"]
Relies on no judgment calls.
```

### Both answers to the identity judgment call

```
Branch 1 (J-ID = yes):
1. The taxpayer disposed of 100 common shares of ABC Ltd. on 2025-06-15 for proceeds of $1,000.00. The adjusted cost base plus outlays and expenses was $1,509.99, so the taxpayer's loss from the disposition is $509.99. [ITA 40(1)(b)]
2. On 2025-06-20, within the period from 2025-05-16 to 2025-07-15, the taxpayer acquired 100 common shares of ABC Ltd. That property is identical to the particular property (judgment call J-ID). [ITA 54 "superficial loss" (a)]
3. At the end of that period, on 2025-07-15, the taxpayer or a person affiliated with the taxpayer owned or had a right to acquire that property. [ITA 54 "superficial loss" (b)]
4. The disposition is not one described in paragraphs (c) to (h), so the taxpayer's loss of $509.99 is a superficial loss. [ITA 54 "superficial loss"]
Conclusion: The superficial loss rule applies. Risk: low.

Branch 2 (J-ID = no):
1. The taxpayer disposed of 100 common shares of ABC Ltd. on 2025-06-15 for proceeds of $1,000.00. The adjusted cost base plus outlays and expenses was $1,509.99, so the taxpayer's loss from the disposition is $509.99. [ITA 40(1)(b)]
2. The property acquired on 2025-06-20 (100 common shares of ABC Ltd.) is not identical to the particular property (judgment call J-ID), so it does not meet paragraph (a). [ITA 54 "superficial loss" (a)]
3. No property meets both paragraphs (a) and (b), so the loss is not a superficial loss. [ITA 54 "superficial loss"]
Conclusion: The superficial loss rule does not apply. Risk: high.

Summary: The superficial loss rule applies on 1 of 2 branches, so the conclusion depends on the judgment calls.
```

### Subparagraph 40(2)(g)(i): the loss is nil

```
1. The property is not excluded property being considered in computing a foreign affiliate's surplus or deficit, so the opening words of paragraph 40(2)(g) apply to it. [ITA 40(2)(g)]
2. The taxpayer disposed of 100 common shares of ABC Ltd. on 2025-06-15 for proceeds of $1,000.00. The adjusted cost base plus outlays and expenses was $1,509.99, so the taxpayer's loss from the disposition is $509.99. [ITA 40(1)(b)]
3. On 2025-06-20, within the period from 2025-05-16 to 2025-07-15, the taxpayer acquired 100 common shares of ABC Ltd. That property is identical to the particular property (judgment call J-ID). [ITA 54 "superficial loss" (a)]
4. At the end of that period, on 2025-07-15, the taxpayer or a person affiliated with the taxpayer owned or had a right to acquire that property. [ITA 54 "superficial loss" (b)]
5. The disposition is not one described in paragraphs (c) to (h), so the taxpayer's loss of $509.99 is a superficial loss. [ITA 54 "superficial loss"]
6. Therefore, under subparagraph 40(2)(g)(i), the taxpayer's loss from the disposition is nil to the extent that it is a superficial loss. [ITA 40(2)(g)(i)]
Relies on these judgment calls:
- J-ID: Are the shares bought identical to the shares sold? Assumed: yes. Risk: low.
Overall risk: low.
```

### Subparagraph 40(2)(g)(i): foreign affiliate carve-out

```
1. The loss is being computed for the surplus or deficit of the taxpayer in respect of another taxpayer of which it is a foreign affiliate, and the property is excluded property, so paragraph 40(2)(g) does not apply to it. [ITA 40(2)(g)]
2. Therefore subparagraph 40(2)(g)(i) does not reduce the taxpayer's loss from the disposition. [ITA 40(2)(g)(i)]
```

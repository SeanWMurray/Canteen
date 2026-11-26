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
| 40(3.4)(a) the loss is nil; (b) it arises immediately before the first of the times in (i) to (v) | `suspended`, `suspendedLoss`, `releaseDate` | earliest of several; (v) only for a corporation; times before the disposition ignored |
| 54 "superficial loss" (h) "a disposition to which subsection 40(3.4) applies" | `SuspendedLoss.withSuspension`, `not_superficial_of_applies` | ✓ |
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
20. **Section 251.1 is computed for a world of persons** as the smallest relation that contains every pair paragraphs (a) to (g) name and is symmetric and reflexive. The recursive references ("is affiliated with" inside (c), (d), (f) and (g), and in the majority-interest tests) are read as references to that same relation. (g)(ii) uses the relation computed without paragraph (g). Each result is checked to be closed.
21. **"Controlled" means "directly or indirectly in any manner whatever"** (251.1(3)). Each control is given as a fact or a judgment call (for example, de facto control). Indirect control must be given explicitly: the encoding does not infer that a parent's controller controls its subsidiary.
22. **Control by "a person" and by "a group of persons" are kept apart,** as (b) and (c) distinguish them. For (d), "controlled by a particular group of persons" is read as a group; to treat one person as a group of one, give the control as a group with one member.
23. **Majority-interest partner (248(1)):** the share the taxpayer "would" have had, holding every interest it or an affiliate holds, is taken as the sum of those interests' shares. A majority-interest group of partners is computed from all subsets of the partners: the group's combined shares exceed half, and no member can be dropped. With this reading, 251.1(1)(f)(ii) is always also reached through (f)(i).
24. **Majority-interest beneficiary (251.1(3)):** interests are given at fair market value, after applying 251.1(4)(d)(i) (discretionary powers deemed exercised or not). A trust needs its own interest of the kind in question (251.1(4)(d)(iii)). 251.1(4)(d)(ii) (arm's length) is not needed for (a) to (g).
25. **Paragraph (h):** whether a person is a "contributor" (251.1(3), with its arm's length and fair value exceptions) is a fact, and so is who is "connected by blood relationship, marriage, common-law partnership or adoption" (251.1(4)(d)(iv)). (g)(ii) reads the subsection without (g), so it includes (h).
26. **Not encoded:** subsection 251.1(2) (amalgamations), and 251.1(4)(d)(ii) (arm's length with a trust).
27. **"Controls" in 251(2) is read as de jure control** (control of the votes), since 251(2) does not say "directly or indirectly in any manner whatever". A control can be marked de facto only: it then counts for affiliation, not for 251(2). Rights under 251(5)(b), and 251(5)(a) (a related group in a position to control is deemed to control), must be reflected in the controls given.
28. **A person is not related to itself,** except that 251(5)(c) makes a shareholder of two corporations related to itself in each capacity: the encoding lets one person satisfy "related to" in 251(2)(c) for that reason.
29. **251(6)(a) "brother or sister"** is computed as sharing a parent (so half-siblings count), or given directly. Lineal descent is through children by blood; adoptions count only through 251(6)(c).
30. **251(6)(c)** is read as: one adopted, legally or in fact, as the child of the other, or as the child of a person who is the other's ancestor or descendant (the words "otherwise than as a brother or sister" exclude siblings).
31. **251(1)(b)** (personal trusts) is a fact, not computed: the 248(25) reference is not encoded.
32. **Not encoded:** 251(3.1) and (3.2) (amalgamations), and the 125(7) purposes of 251(5).
34. **40(3.3) to (3.5):** "owns" in (3.3)(c) is a fact per acquisition (unlike the superficial loss definition, a right to acquire does not count there). Each release time in 40(3.4)(b)(i) to (v) is given as the date it occurs; (i) is the day the 30-day period without the property begins. The deeming rules in 40(3.5)(c) and (d) (mergers, wind-ups, redemptions) must be reflected in who owns the property. The partnership continuation rule at the end of 40(3.4) is not encoded.
33. **50(2):** "established by the taxpayer to have become a bad debt in the year" is a fact or a judgment call, and so is arm's length (which 251 can supply). "The amount, if any, by which (i) exceeds (ii)" is (i) minus (ii), or nil. The resulting loss is proven to be the lesser of the debt's cost and the gain.
19. **"To the extent that" for (ii) to (iv)** is read as the whole loss: the loss is entirely from the disposition of the debt, personal-use property, or property transferred. `Paragraph40_2_g.deniedLoss` treats the whole loss as nil when any subparagraph applies, as `LossDenial.deniedLoss` does for (i).

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

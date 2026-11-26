# Review: section 54 "superficial loss", subparagraph 40(2)(g)(i), paragraph 53(1)(f) and paragraph 251.1(1)(a)

**Status:** encoded and tested; **awaiting review against the statute** (roadmap Phase 4).

Lean proves that each explanation agrees with its rule, and that the conclusions follow from the definitions.
It cannot prove that the definitions match the Act. That is what this review is for.

- Statute text (verbatim, current to 2026-10-29): [`statute/ITA-54-superficial-loss.txt`](../../statute/ITA-54-superficial-loss.txt), [`statute/ITA-40-2-g.txt`](../../statute/ITA-40-2-g.txt), [`statute/ITA-53-1-f.txt`](../../statute/ITA-53-1-f.txt), [`statute/ITA-251-1-1-a.txt`](../../statute/ITA-251-1-1-a.txt)
- Encoding: [`Canteen/ITA/S54/SuperficialLoss.lean`](../../Canteen/ITA/S54/SuperficialLoss.lean), [`Canteen/ITA/S40/LossDenial.lean`](../../Canteen/ITA/S40/LossDenial.lean), [`Canteen/ITA/S53/CostAddition.lean`](../../Canteen/ITA/S53/CostAddition.lean), [`Canteen/ITA/S251_1/Affiliation.lean`](../../Canteen/ITA/S251_1/Affiliation.lean)
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
10. **Not encoded:** 40(2)(g)(ii) to (iv).
11. **53(1)(f), amount (i):** "the amount of the loss that was, because of the acquisition by the taxpayer of the property, a superficial loss" is an input. In the spouse transaction it is the whole denied loss, which assumes the spouse's shares are the only substituted property.
12. **53(1)(f), amount (ii):** the amount that would be deducted under 112(3) to (3.2) is an input (nil in the examples). "The amount, if any, by which (i) exceeds (ii)" is read as (i) minus (ii), or nil.
13. **251.1(1)(a)** is read as requiring the first person to be an individual and the second to be that individual's spouse or common-law partner. It is symmetric in practice, but the encoding takes the facts in that order.

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

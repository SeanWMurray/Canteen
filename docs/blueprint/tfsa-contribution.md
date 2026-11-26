# Memo: shares contributed in kind to a TFSA at a loss

> Generated from the Lean sources by `scripts/blueprint.sh`. Do not edit by hand.

**Issue.** On 2025-09-02 the taxpayer contributed 80 common shares of JKL Corp., worth $4,000.00 and with an adjusted cost base of $5,000.00, to the taxpayer's TFSA. Can the taxpayer use the $1,000.00 loss?

**Conclusion.** No. Clause 40(2)(g)(iv)(A) makes a loss on property disposed of to a TFSA trust under which the taxpayer is a beneficiary nil (A2, A5). Whether the trust is affiliated with the taxpayer is a judgment call (J-AFF) that decides whether the loss is also a superficial loss (A3), but not the outcome: the loss is nil either way (A4), and the conclusion rests on no judgment call.

This is a constructed example, not advice on a real transaction.

**Status of the 15 statements:** 8 proven, 2 encoded, 4 fact, 1 judgment call.

## Dependency graph

```mermaid
graph TD
  n0["L0 · Transfers to registered plans"]:::proven
  n1["L3 · Superficial loss"]:::encoded
  n2["L2 · Affiliation"]:::encoded
  n3["L1 · Paragraph 40(2)(g)"]:::proven
  n4["F1 · The contribution"]:::fact
  n5["F2 · The taxpayer's own TFSA"]:::fact
  n6["F3 · The trust holds the shares"]:::fact
  n7["F4 · An individual taxpayer"]:::fact
  n8["J-AFF · Is the trust affiliated?"]:::judgment
  n9["A1 · A loss of $1,000.00"]:::proven
  n10["A2 · Clause (iv)(A) applies"]:::proven
  n11["A3 · Superficial only if the trust is affiliated"]:::proven
  n12["A4 · Nil on every branch"]:::proven
  n13["A5 · The reasons rest on facts"]:::proven
  n14["K · Conclusion"]:::proven
  n0 --> n3
  n1 --> n3
  n2 --> n6
  n4 --> n9
  n9 --> n10
  n5 --> n10
  n6 --> n10
  n7 --> n10
  n0 --> n10
  n4 --> n11
  n5 --> n11
  n6 --> n11
  n7 --> n11
  n8 --> n11
  n1 --> n11
  n10 --> n12
  n7 --> n12
  n3 --> n12
  n12 --> n13
  n12 --> n14
  n13 --> n14
  classDef proven fill:#c8e6c9,stroke:#2e7d32,color:#1b5e20
  classDef encoded fill:#bbdefb,stroke:#1565c0,color:#0d47a1
  classDef fact fill:#eeeeee,stroke:#616161,color:#212121
  classDef judgment fill:#ffe0b2,stroke:#ef6c00,color:#e65100
  classDef notFormalized fill:#ffffff,stroke:#c62828,color:#b71c1c,stroke-dasharray:5 5
  classDef unproven fill:#ffcdd2,stroke:#c62828,color:#b71c1c
```

Green: proven in Lean. Blue: encoded (definitions). Grey: facts. Orange: judgment calls. Dashed red: not yet formalized. An arrow points from a statement to the statements that use it.

### What the Lean proofs use

The same statements, with the dependencies Lean finds in the proofs themselves (solid) and those stated only in the memo's reasoning (dotted). Every dependency a proof has is also stated in the memo: `Blueprint.check` refuses a memo that hides one.

```mermaid
graph TD
  n0["L0"]:::proven
  n1["L3"]:::encoded
  n2["L2"]:::encoded
  n3["L1"]:::proven
  n4["F1"]:::fact
  n5["F2"]:::fact
  n6["F3"]:::fact
  n7["F4"]:::fact
  n8["J-AFF"]:::judgment
  n9["A1"]:::proven
  n10["A2"]:::proven
  n11["A3"]:::proven
  n12["A4"]:::proven
  n13["A5"]:::proven
  n14["K"]:::proven
  n1 --> n3
  n0 --> n3
  n2 -.-> n6
  n4 --> n9
  n7 --> n10
  n4 --> n10
  n6 --> n10
  n0 --> n10
  n5 --> n10
  n9 --> n10
  n7 --> n11
  n4 --> n11
  n6 --> n11
  n5 --> n11
  n1 --> n11
  n8 -.-> n11
  n7 --> n12
  n4 --> n12
  n3 --> n12
  n6 --> n12
  n5 --> n12
  n10 --> n12
  n1 --> n12
  n9 --> n12
  n0 --> n12
  n7 --> n13
  n4 --> n13
  n3 --> n13
  n6 --> n13
  n5 --> n13
  n12 -.-> n13
  n7 --> n14
  n4 --> n14
  n10 --> n14
  n3 --> n14
  n6 --> n14
  n5 --> n14
  n1 --> n14
  n9 --> n14
  n0 --> n14
  n12 -.-> n14
  n13 -.-> n14
  classDef proven fill:#c8e6c9,stroke:#2e7d32,color:#1b5e20
  classDef encoded fill:#bbdefb,stroke:#1565c0,color:#0d47a1
  classDef fact fill:#eeeeee,stroke:#616161,color:#212121
  classDef judgment fill:#ffe0b2,stroke:#ef6c00,color:#e65100
  classDef notFormalized fill:#ffffff,stroke:#c62828,color:#b71c1c,stroke-dasharray:5 5
```

### Decision tree: J-AFF doesn't matter

```mermaid
flowchart LR
  B{"J-AFF<br/>Is the trust governed by the<br/>taxpayer's TFSA affiliated with the<br/>taxpayer under one of paragraphs<br/>251.1(1)(b) to (g)?"}:::judgment
  B -->|"yes (risk medium)"| By
  B -->|"no (risk medium)"| Bn
  By(["Paragraph 40(2)(g) applies<br/>risk: low"]):::yes
  Bn(["Paragraph 40(2)(g) applies<br/>risk: low"]):::yes
  classDef fact fill:#eeeeee,stroke:#616161,color:#212121
  classDef judgment fill:#ffe0b2,stroke:#ef6c00,color:#e65100
  classDef rule fill:#bbdefb,stroke:#1565c0,color:#0d47a1
  classDef yes fill:#c8e6c9,stroke:#2e7d32,color:#1b5e20
  classDef no fill:#ffcdd2,stroke:#c62828,color:#b71c1c
  classDef start fill:#ffffff,stroke:#212121,color:#212121
```

### Subparagraph (i) alone does turn on J-AFF

```mermaid
flowchart LR
  B{"J-AFF<br/>Is the trust governed by the<br/>taxpayer's TFSA affiliated with the<br/>taxpayer under one of paragraphs<br/>251.1(1)(b) to (g)?"}:::judgment
  B -->|"yes (risk medium)"| By
  B -->|"no (risk medium)"| Bn
  By(["The superficial loss rule applies<br/>risk: medium"]):::yes
  Bn(["The superficial loss rule does not apply<br/>risk: medium"]):::no
  classDef fact fill:#eeeeee,stroke:#616161,color:#212121
  classDef judgment fill:#ffe0b2,stroke:#ef6c00,color:#e65100
  classDef rule fill:#bbdefb,stroke:#1565c0,color:#0d47a1
  classDef yes fill:#c8e6c9,stroke:#2e7d32,color:#1b5e20
  classDef no fill:#ffcdd2,stroke:#c62828,color:#b71c1c
  classDef start fill:#ffffff,stroke:#212121,color:#212121
```

### Paragraph 40(2)(g) as a flowchart

```mermaid
flowchart TD
  S(["paragraph 40(2)(g) · ITA 40(2)(g)"]):::start
  C0["<b>(i) to (iv)</b> one of subparagraphs 40(2)(g)(i) to (iv)<br/>applies<br/>[ITA 40(2)(g)]"]:::rule
  E0["<b>opening words</b> For the purposes of computing the surplus or<br/>deficit of the taxpayer in respect of<br/>another taxpayer of which it is a foreign<br/>affiliate, the property is excluded property<br/>[ITA 40(2)(g) opening words]"]:::fact
  Y(["paragraph 40(2)(g) applies"]):::yes
  N(["paragraph 40(2)(g) does not apply"]):::no
  S --> C0
  C0 -->|met| E0
  C0 -->|not met| N
  E0 -->|does not apply| Y
  E0 -->|applies| N
  classDef fact fill:#eeeeee,stroke:#616161,color:#212121
  classDef judgment fill:#ffe0b2,stroke:#ef6c00,color:#e65100
  classDef rule fill:#bbdefb,stroke:#1565c0,color:#0d47a1
  classDef yes fill:#c8e6c9,stroke:#2e7d32,color:#1b5e20
  classDef no fill:#ffcdd2,stroke:#c62828,color:#b71c1c
  classDef start fill:#ffffff,stroke:#212121,color:#212121
```

### Subparagraph (iv) as a flowchart

```mermaid
flowchart TD
  S(["subparagraph 40(2)(g)(iv) · ITA 40(2)(g)(iv)"]):::start
  C0["<b>loss</b> The taxpayer has a loss from the disposition<br/>[ITA 40(2)(g)(iv) loss]"]:::fact
  C1["<b>(A) or (B)</b> clause (A) or (B) applies<br/>[ITA 40(2)(g)(iv)]"]:::rule
  Y(["subparagraph 40(2)(g)(iv) applies"]):::yes
  N(["subparagraph 40(2)(g)(iv) does not apply"]):::no
  S --> C0
  C0 -->|met| C1
  C0 -->|not met| N
  C1 -->|met| Y
  C1 -->|not met| N
  classDef fact fill:#eeeeee,stroke:#616161,color:#212121
  classDef judgment fill:#ffe0b2,stroke:#ef6c00,color:#e65100
  classDef rule fill:#bbdefb,stroke:#1565c0,color:#0d47a1
  classDef yes fill:#c8e6c9,stroke:#2e7d32,color:#1b5e20
  classDef no fill:#ffcdd2,stroke:#c62828,color:#b71c1c
  classDef start fill:#ffffff,stroke:#212121,color:#212121
```

### Timeline of the superficial loss period

```mermaid
gantt
    title Superficial loss period for the disposition on 2025-09-02
    dateFormat YYYY-MM-DD
    axisFormat %b %d
    section Period (a)
    2025-08-03 to 2025-10-02 :active, period, 2025-08-03, 61d
    section Disposition
    2025-09-02 disposition of 80 common shares of JKL Corp. (loss $1,000.00) :milestone, disp, 2025-09-02, 0d
    section Acquisitions
    2025-09-02 the trust governed by the taxpayer's TFSA (affiliated, judgment call J-AFF) acquires 80 common shares of JKL Corp. (in period, held at end) :milestone, crit, a0, 2025-09-02, 0d
    section End of period (b)
    2025-10-02 end of period :milestone, endp, 2025-10-02, 0d
```

## The law

### L0. Transfers to registered plans

**Status:** proven · **Citation:** ITA 40(2)(g)(iv)

A loss from the disposition of property to a trust governed by a DPSP, EPSP, FHSA, RDSP, RRIF or TFSA under which the taxpayer is (or immediately after becomes) a beneficiary, or to an RRSP trust under which the taxpayer or spouse or common-law partner is (or within 60 days after the year becomes) an annuitant, is nil.

**Lean:** [`Canteen.ITA.Paragraph40_2_g.planTransferLoss`](../../Canteen/ITA/S40/PlanTransferLoss.lean#L45), [`Canteen.ITA.Paragraph40_2_g.planTransferLoss_tfsa`](../../Canteen/ITA/S40/PlanTransferLoss.lean#L59)

### L3. Superficial loss

**Status:** encoded · **Citation:** ITA 54 "superficial loss"

The definition, as in the provision's blueprint.

**Lean:** [`Canteen.ITA.SuperficialLoss.superficialLoss`](../../Canteen/ITA/S54/SuperficialLoss.lean#L255)

### L2. Affiliation

**Status:** encoded · **Citation:** ITA 251.1(1)

Paragraph 251.1(1)(a) covers an individual and a spouse or common-law partner; paragraphs (b) to (g) are not encoded, so whether one applies is taken as given.

**Lean:** [`Canteen.ITA.Affiliation.affiliated`](../../Canteen/ITA/S251_1/Affiliation.lean#L50)

### L1. Paragraph 40(2)(g)

**Status:** proven · **Citation:** ITA 40(2)(g) · **Uses:** L0, L3

A loss is nil to the extent it is within any of subparagraphs (i) to (iv), unless the carve-out in the opening words applies.

**Lean:** [`Canteen.ITA.Paragraph40_2_g.paragraph`](../../Canteen/ITA/S40/Paragraph40_2_g.lean#L32), [`Canteen.ITA.Paragraph40_2_g.paragraph_holds`](../../Canteen/ITA/S40/Paragraph40_2_g.lean#L45)

## Facts

### F1. The contribution

**Status:** fact

On 2025-09-02 the taxpayer contributed 80 common shares of JKL Corp. to the TFSA: proceeds $4,000.00 (their value), adjusted cost base $5,000.00.

**Lean:** [`Canteen.Transactions.TfsaContribution.contribution`](../../Canteen/Transactions/TfsaContribution.lean#L29)

### F2. The taxpayer's own TFSA

**Status:** fact

The shares went to the trust governed by the taxpayer's TFSA. The taxpayer is its holder, so a beneficiary under it.

**Lean:** [`Canteen.Transactions.TfsaContribution.transferFacts`](../../Canteen/Transactions/TfsaContribution.lean#L33)

### F3. The trust holds the shares

**Status:** fact · **Uses:** L2

The trust acquired the same shares that day and still held them at the end of the period. It is an individual (subsection 104(2)) but not the taxpayer's spouse.

**Lean:** [`Canteen.Transactions.TfsaContribution.trustAcquisition`](../../Canteen/Transactions/TfsaContribution.lean#L42), [`Canteen.Transactions.TfsaContribution.trustRelation`](../../Canteen/Transactions/TfsaContribution.lean#L37)

### F4. An individual taxpayer

**Status:** fact

The taxpayer is an individual, so the foreign affiliate carve-out is not engaged.

**Lean:** [`Canteen.Transactions.TfsaContribution.surplusCarveOut`](../../Canteen/Transactions/TfsaContribution.lean#L53)

## Judgment call

### J-AFF. Is the trust affiliated?

**Status:** judgment call

Whether the TFSA trust is affiliated with the taxpayer under one of paragraphs 251.1(1)(b) to (g). Risk: medium either way.

## Analysis

### A1. A loss of $1,000.00

**Status:** proven · **Citation:** ITA 40(1)(b) · **Uses:** F1

The adjusted cost base ($5,000.00) exceeds the proceeds ($4,000.00) by $1,000.00.

**Lean:** [`Canteen.Transactions.TfsaContribution.loss_amount`](../../Canteen/Transactions/TfsaContribution.lean#L65)

**Rests on:** facts F1.

### A2. Clause (iv)(A) applies

**Status:** proven · **Citation:** ITA 40(2)(g)(iv)(A) · **Uses:** A1, F2, F3, F4, L0

The loss is from the disposition of property to a trust governed by a TFSA under which the taxpayer is a beneficiary.

**Lean:** [`Canteen.Transactions.TfsaContribution.iv_applies`](../../Canteen/Transactions/TfsaContribution.lean#L67)

**Rests on:** facts F1, F2, F3, F4.

### A3. Superficial only if the trust is affiliated

**Status:** proven · **Citation:** ITA 54 "superficial loss" · **Uses:** F1, F2, F3, F4, J-AFF, L3

The trust acquired the same shares in the period and held them at its end. So the loss is also a superficial loss if the trust is affiliated with the taxpayer, and not otherwise.

**Lean:** [`Canteen.Transactions.TfsaContribution.superficial_iff_affiliated`](../../Canteen/Transactions/TfsaContribution.lean#L72)

**Rests on:** judgment calls J-AFF; facts F1, F2, F3, F4.

### A4. Nil on every branch

**Status:** proven · **Citation:** ITA 40(2)(g) · **Uses:** A2, F4, L1

Clause (iv)(A) applies whatever the answer to J-AFF, and the carve-out is not engaged, so paragraph 40(2)(g) makes the loss nil on every branch.

**Lean:** [`Canteen.Transactions.TfsaContribution.nil_on_every_branch`](../../Canteen/Transactions/TfsaContribution.lean#L77), [`Canteen.Transactions.TfsaContribution.denied_loss`](../../Canteen/Transactions/TfsaContribution.lean#L81)

**Rests on:** facts F1, F2, F3, F4.

### A5. The reasons rest on facts

**Status:** proven · **Uses:** A4

On either answer, the explanation cites clause (iv)(A), which rests on facts, rather than subparagraph (i), which would rest on J-AFF.

**Lean:** [`Canteen.Transactions.TfsaContribution.explanation_factual`](../../Canteen/Transactions/TfsaContribution.lean#L89)

**Rests on:** facts F1, F2, F3, F4.

### K. Conclusion

**Status:** proven · **Uses:** A4, A5

The taxpayer cannot use the $1,000.00 loss: paragraph 40(2)(g) makes it nil, under clause (iv)(A), on the facts alone.

**Lean:** [`Canteen.Transactions.TfsaContribution.denied_loss`](../../Canteen/Transactions/TfsaContribution.lean#L81)

**Rests on:** facts F1, F2, F3, F4.

## Appendix: the argument as Lean renders it

### Paragraph 40(2)(g), if the trust is affiliated

```
1. The taxpayer has a loss from the disposition. [ITA 40(2)(g)(iv) loss]
2. The property was disposed of to a trust governed by a deferred profit sharing plan, an employees profit sharing plan, a FHSA, a registered disability savings plan, a registered retirement income fund or a TFSA. [ITA 40(2)(g)(iv)(A) trust]
3. The taxpayer is, or immediately after the disposition becomes, a beneficiary under it. [ITA 40(2)(g)(iv)(A) beneficiary]
4. Therefore clause 40(2)(g)(iv)(A) applies. [ITA 40(2)(g)(iv)(A)]
5. Therefore clause (A) or (B) applies. [ITA 40(2)(g)(iv)]
6. Therefore subparagraph 40(2)(g)(iv) applies. [ITA 40(2)(g)(iv)]
7. Therefore one of subparagraphs 40(2)(g)(i) to (iv) applies. [ITA 40(2)(g)]
8. The property is not excluded property being considered in computing a foreign affiliate's surplus or deficit. [ITA 40(2)(g) opening words]
9. Therefore paragraph 40(2)(g) applies. [ITA 40(2)(g)]
Relies on no judgment calls.
```

### Paragraph 40(2)(g), if it is not

```
1. The taxpayer has a loss from the disposition. [ITA 40(2)(g)(iv) loss]
2. The property was disposed of to a trust governed by a deferred profit sharing plan, an employees profit sharing plan, a FHSA, a registered disability savings plan, a registered retirement income fund or a TFSA. [ITA 40(2)(g)(iv)(A) trust]
3. The taxpayer is, or immediately after the disposition becomes, a beneficiary under it. [ITA 40(2)(g)(iv)(A) beneficiary]
4. Therefore clause 40(2)(g)(iv)(A) applies. [ITA 40(2)(g)(iv)(A)]
5. Therefore clause (A) or (B) applies. [ITA 40(2)(g)(iv)]
6. Therefore subparagraph 40(2)(g)(iv) applies. [ITA 40(2)(g)(iv)]
7. Therefore one of subparagraphs 40(2)(g)(i) to (iv) applies. [ITA 40(2)(g)]
8. The property is not excluded property being considered in computing a foreign affiliate's surplus or deficit. [ITA 40(2)(g) opening words]
9. Therefore paragraph 40(2)(g) applies. [ITA 40(2)(g)]
Relies on no judgment calls.
```


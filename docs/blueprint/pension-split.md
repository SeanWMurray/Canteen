# Memo: splitting pension income between spouses

> Generated from the Lean sources by `scripts/blueprint.sh`. Do not edit by hand.

**Issue.** Spouses over 65: one receives a $90,000 pension plan annuity in 2025, the other $10,000 of RRIF payments. How much of the pension should they elect to split?

**Conclusion.** $40,000, which leaves each with $50,000 of income: their federal tax falls from $12,010.74 to $6,900.24, a saving of $5,110.50 (K). Besides the lower rates, the pensioner's age credit, mostly clawed back at $90,000, comes back (A2, A3). No split in $1,000 steps up to the $45,000 limit does better, and splitting the whole $45,000 costs $10.96 more (W1). Old Age Security and its recovery tax, and provincial tax, are not computed.

This is a constructed example, not advice.

**Status of the 9 statements:** 6 proven, 2 encoded, 1 fact.

## Dependency graph

```mermaid
graph TD
  n0["L1 · Pension splitting"]:::proven
  n1["L2 · The age and pension credits"]:::encoded
  n2["L3 · Federal tax"]:::encoded
  n3["F1 · The spouses"]:::fact
  n4["A1 · Up to $45,000 may be split"]:::proven
  n5["A2 · Without splitting: $12,010.74"]:::proven
  n6["A3 · Splitting $40,000: $3,450.12 each"]:::proven
  n7["K · Split $40,000: $5,110.50 saved"]:::proven
  n8["W1 · Splitting the whole $45,000"]:::proven
  n0 --> n1
  n0 --> n2
  n1 --> n2
  n3 --> n4
  n0 --> n4
  n3 --> n5
  n2 --> n5
  n4 --> n6
  n3 --> n6
  n2 --> n6
  n5 --> n7
  n6 --> n7
  n3 --> n7
  n2 --> n7
  n4 --> n8
  n3 --> n8
  n7 --> n8
  n2 --> n8
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
  n0["L1"]:::proven
  n1["L2"]:::encoded
  n2["L3"]:::encoded
  n3["F1"]:::fact
  n4["A1"]:::proven
  n5["A2"]:::proven
  n6["A3"]:::proven
  n7["K"]:::proven
  n8["W1"]:::proven
  n0 --> n1
  n0 --> n2
  n1 --> n2
  n0 --> n4
  n3 --> n4
  n2 --> n5
  n3 --> n5
  n1 --> n5
  n2 --> n6
  n0 --> n6
  n3 --> n6
  n1 --> n6
  n4 -.-> n6
  n2 --> n7
  n3 --> n7
  n5 -.-> n7
  n6 -.-> n7
  n7 --> n8
  n4 -.-> n8
  n3 -.-> n8
  n2 -.-> n8
  classDef proven fill:#c8e6c9,stroke:#2e7d32,color:#1b5e20
  classDef encoded fill:#bbdefb,stroke:#1565c0,color:#0d47a1
  classDef fact fill:#eeeeee,stroke:#616161,color:#212121
  classDef judgment fill:#ffe0b2,stroke:#ef6c00,color:#e65100
  classDef notFormalized fill:#ffffff,stroke:#c62828,color:#b71c1c,stroke-dasharray:5 5
```

## The law

### L1. Pension splitting

**Status:** proven · **Citation:** ITA 60.03; 60(c); 56(1)(a.2)

Spouses may jointly elect to move up to half the pensioner's eligible pension income to the other: deducted by the pensioner, included by the transferee, and treated as the transferee's pension income for the pension credit. Proven: never more than half.

**Lean:** [`Canteen.ITA.PensionSplitting.splitLimit`](../../Canteen/ITA/S60_03/PensionSplitting.lean#L56), [`Canteen.ITA.PensionSplitting.split_le_half`](../../Canteen/ITA/S60_03/PensionSplitting.lean#L83), [`Canteen.ITA.IndividualYear.splitOutAllowed`](../../Canteen/ITA/S3/IndividualYear.lean#L122)

### L2. The age and pension credits

**Status:** encoded · **Citation:** ITA 118(2), (3), (7) · **Uses:** L1

14% of $9,028 less 15% of income over $45,522, for those 65 or over; 14% of up to $2,000 of eligible pension income.

**Lean:** [`Canteen.ITA.PensionSplitting.ageCredit`](../../Canteen/ITA/S60_03/PensionSplitting.lean#L68), [`Canteen.ITA.PensionSplitting.pensionCredit`](../../Canteen/ITA/S60_03/PensionSplitting.lean#L71), [`Canteen.ITA.IndividualYear.ageAndPensionCredits`](../../Canteen/ITA/S3/IndividualYear.lean#L181)

### L3. Federal tax

**Status:** encoded · **Citation:** ITA 117(2); 118(1) · **Uses:** L1, L2

Tax at the 117(2) rates, less the personal, age and pension credits.

**Lean:** [`Canteen.ITA.IndividualYear.federalTax`](../../Canteen/ITA/S3/IndividualYear.lean#L198)

## Facts

### F1. The spouses

**Status:** fact

Both over 65 in 2025; a $90,000 pension plan annuity and $10,000 of RRIF payments; both claim the basic personal amount.

**Lean:** [`Canteen.Transactions.PensionSplit.pensioner`](../../Canteen/Transactions/PensionSplit.lean#L20), [`Canteen.Transactions.PensionSplit.transferee`](../../Canteen/Transactions/PensionSplit.lean#L24)

## Analysis

### A1. Up to $45,000 may be split

**Status:** proven · **Citation:** ITA 60.03(1) · **Uses:** F1, L1

Half the pensioner's $90,000 of eligible pension income.

**Lean:** [`Canteen.Transactions.PensionSplit.limit`](../../Canteen/Transactions/PensionSplit.lean#L32)

**Rests on:** facts F1.

### A2. Without splitting: $12,010.74

**Status:** proven · **Citation:** ITA 117(2); 118(2) · **Uses:** F1, L3

All of it the pensioner's, whose age credit is down to $329.88.

**Lean:** [`Canteen.Transactions.PensionSplit.no_split`](../../Canteen/Transactions/PensionSplit.lean#L35)

**Rests on:** facts F1.

### A3. Splitting $40,000: $3,450.12 each

**Status:** proven · **Citation:** ITA 60(c); 56(1)(a.2) · **Uses:** A1, F1, L3

$50,000 of income each; the pensioner's age credit back to $1,169.88, plus the $280 pension credit.

**Lean:** [`Canteen.Transactions.PensionSplit.split_40000`](../../Canteen/Transactions/PensionSplit.lean#L41)

**Rests on:** facts F1.

## Conclusion

### K. Split $40,000: $5,110.50 saved

**Status:** proven · **Uses:** A2, A3, F1, L3

$6,900.24 between them, against $12,010.74; no split in $1,000 steps up to the limit does better.

**Lean:** [`Canteen.Transactions.PensionSplit.total`](../../Canteen/Transactions/PensionSplit.lean#L28), [`Canteen.Transactions.PensionSplit.saving`](../../Canteen/Transactions/PensionSplit.lean#L48), [`Canteen.Transactions.PensionSplit.best`](../../Canteen/Transactions/PensionSplit.lean#L51)

**Rests on:** facts F1.

## What if

### W1. Splitting the whole $45,000

**Status:** proven · **Citation:** ITA 60.03(1) · **Uses:** A1, F1, K, L3

The transferee's income then exceeds the pensioner's: $10.96 more than at $40,000.

**Lean:** [`Canteen.Transactions.PensionSplit.overshoot`](../../Canteen/Transactions/PensionSplit.lean#L54)

**Rests on:** facts F1.

## Appendix: the argument as Lean renders it

### The pensioner, splitting $40,000

```
1. Employment and business income $0.00; dividends included $0.00 (with the gross-up); recapture $0.00; income attributed $0.00. [ITA 3(a); 82(1); 13(1); 74.1]
2. Taxable capital gains, net: $0.00. [ITA 3(b)]
3. Losses: business $0.00, terminal $0.00, attributed $0.00; interest deducted $0.00. [ITA 3(d); 20(16); 74.1; 20(1)(c)]
4. Income for the year: $50,000.00. [ITA 3]
5. Less the net capital loss deduction $0.00, the capital gains deduction $0.00, and other deductions $0.00: taxable income $50,000.00. [ITA 2(2); 111(1)(b); 110.6(2), (2.1)]
6. Tax under 117(2) on taxable income, $7,000.00, less the dividend tax credit of $0.00, the personal credit of $2,100.00, the age and pension credits of $1,449.88, the donation credit of $0.00, the medical expense credit of $0.00, the disability credit of $0.00 and other credits of $0.00: $3,450.12. [ITA 117(2); 120.4(2); 121; 118; 118.1; 118.2; 118.3]
Relies on no judgment calls.
```

### The transferee, receiving $40,000

```
1. Employment and business income $0.00; dividends included $0.00 (with the gross-up); recapture $0.00; income attributed $0.00. [ITA 3(a); 82(1); 13(1); 74.1]
2. Taxable capital gains, net: $0.00. [ITA 3(b)]
3. Losses: business $0.00, terminal $0.00, attributed $0.00; interest deducted $0.00. [ITA 3(d); 20(16); 74.1; 20(1)(c)]
4. Income for the year: $50,000.00. [ITA 3]
5. Less the net capital loss deduction $0.00, the capital gains deduction $0.00, and other deductions $0.00: taxable income $50,000.00. [ITA 2(2); 111(1)(b); 110.6(2), (2.1)]
6. Tax under 117(2) on taxable income, $7,000.00, less the dividend tax credit of $0.00, the personal credit of $2,100.00, the age and pension credits of $1,449.88, the donation credit of $0.00, the medical expense credit of $0.00, the disability credit of $0.00 and other credits of $0.00: $3,450.12. [ITA 117(2); 120.4(2); 121; 118; 118.1; 118.2; 118.3]
Relies on no judgment calls.
```


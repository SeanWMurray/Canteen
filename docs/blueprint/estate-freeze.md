# Memo: an estate freeze in favour of minor children

> Generated from the Lean sources by `scripts/blueprint.sh`. Do not edit by hand.

**Issue.** A parent exchanges Opco common shares (cost $100, worth $2,000,000) for $2,000,000 of preferred shares, and the parent's minor children take new common shares. Is there tax now, or each year after?

**Conclusion.** No gain on the exchange: 86(1) carries the $100 cost over to the preferred shares, and with a price adjustment clause there is no benefit for 86(2) (A1, A2). Corporate attribution under 74.4(2) does not apply on the low-risk position that Opco is a small business corporation (A3). If it is not, the parent is deemed to receive $60,000 of interest a year, unless Opco pays at least $52,174 of dividends on the preferred shares (W1).

This is a constructed example, not advice on a real transaction.

**Status of the 10 statements:** 5 proven, 2 encoded, 2 fact, 1 judgment call.

## Dependency graph

```mermaid
graph TD
  n0["L1 · Share exchanges"]:::encoded
  n1["L2 · Corporate attribution"]:::encoded
  n2["F1 · The exchange"]:::fact
  n3["F2 · The children's shares, and the rate"]:::fact
  n4["J-SBC · Opco is a small business corporation"]:::judgment
  n5["A1 · No gain on the exchange"]:::proven
  n6["A2 · No benefit"]:::proven
  n7["A3 · No corporate attribution"]:::proven
  n8["K · Conclusion"]:::proven
  n9["W1 · $60,000 a year, unless dividends are paid"]:::proven
  n2 --> n5
  n0 --> n5
  n2 --> n6
  n0 --> n6
  n3 --> n7
  n4 --> n7
  n1 --> n7
  n5 --> n8
  n6 --> n8
  n7 --> n8
  n3 --> n9
  n4 --> n9
  n1 --> n9
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
  n0["L1"]:::encoded
  n1["L2"]:::encoded
  n2["F1"]:::fact
  n3["F2"]:::fact
  n4["J-SBC"]:::judgment
  n5["A1"]:::proven
  n6["A2"]:::proven
  n7["A3"]:::proven
  n8["K"]:::proven
  n9["W1"]:::proven
  n2 --> n5
  n0 --> n5
  n2 --> n6
  n0 --> n6
  n3 --> n7
  n4 --> n7
  n1 --> n7
  n2 --> n8
  n0 --> n8
  n3 --> n8
  n4 --> n8
  n1 --> n8
  n5 -.-> n8
  n6 -.-> n8
  n7 -.-> n8
  n3 --> n9
  n1 --> n9
  n4 --> n9
  classDef proven fill:#c8e6c9,stroke:#2e7d32,color:#1b5e20
  classDef encoded fill:#bbdefb,stroke:#1565c0,color:#0d47a1
  classDef fact fill:#eeeeee,stroke:#616161,color:#212121
  classDef judgment fill:#ffe0b2,stroke:#ef6c00,color:#e65100
  classDef notFormalized fill:#ffffff,stroke:#c62828,color:#b71c1c,stroke-dasharray:5 5
```

### Flowchart: subsection 74.4(2)

```mermaid
flowchart TD
  S(["subsection 74.4(2) · ITA 74.4(2)"]):::start
  C0["<b>main purpose</b> One of the main purposes of the transfer or<br/>loan may reasonably be considered to be to<br/>reduce the individual's income and benefit a<br/>designated person<br/><i>judgment call: judgment calls computed from the facts</i><br/>[ITA 74.4(2) main purpose]"]:::judgment
  C1["<b>(a)</b> A designated person (a spouse or common-law<br/>partner, or a minor child, niece or nephew)<br/>is a specified shareholder of the<br/>corporation<br/>[ITA 74.4(2)(a)]"]:::fact
  C2["<b>(b)</b> The individual was resident in Canada<br/>[ITA 74.4(2)(b)]"]:::fact
  E0["<b>(c)</b> The corporation was a small business<br/>corporation throughout the period<br/><i>judgment call: judgment calls computed from the facts</i><br/>[ITA 74.4(2)(c)]"]:::judgment
  Y(["subsection 74.4(2) applies"]):::yes
  N(["subsection 74.4(2) does not apply"]):::no
  S --> C0
  C0 -->|met| C1
  C0 -->|not met| N
  C1 -->|met| C2
  C1 -->|not met| N
  C2 -->|met| E0
  C2 -->|not met| N
  E0 -->|does not apply| Y
  E0 -->|applies| N
  classDef fact fill:#eeeeee,stroke:#616161,color:#212121
  classDef judgment fill:#ffe0b2,stroke:#ef6c00,color:#e65100
  classDef rule fill:#bbdefb,stroke:#1565c0,color:#0d47a1
  classDef yes fill:#c8e6c9,stroke:#2e7d32,color:#1b5e20
  classDef no fill:#ffcdd2,stroke:#c62828,color:#b71c1c
  classDef start fill:#ffffff,stroke:#212121,color:#212121
```

### Decision tree: J-SBC

```mermaid
flowchart LR
  B{"J-SBC<br/>Is all or substantially all of the<br/>fair market value of Opco's assets<br/>attributable to assets used<br/>principally in an active business<br/>carried on primarily in Canada,<br/>throughout 2025?"}:::judgment
  B -->|"yes (risk low)"| By
  B -->|"no (risk high)"| Bn
  By(["Subsection 74.4(2) does not apply<br/>risk: low"]):::no
  Bn(["Subsection 74.4(2) applies<br/>risk: high"]):::yes
  classDef fact fill:#eeeeee,stroke:#616161,color:#212121
  classDef judgment fill:#ffe0b2,stroke:#ef6c00,color:#e65100
  classDef rule fill:#bbdefb,stroke:#1565c0,color:#0d47a1
  classDef yes fill:#c8e6c9,stroke:#2e7d32,color:#1b5e20
  classDef no fill:#ffcdd2,stroke:#c62828,color:#b71c1c
  classDef start fill:#ffffff,stroke:#212121,color:#212121
```

## The law

### L1. Share exchanges

**Status:** encoded · **Citation:** ITA 86(1), (2)

In a reorganization of capital, old shares exchanged for new shares go at their cost; a benefit to a related person is taxed.

**Lean:** [`Canteen.ITA.ShareExchange.applies`](../../Canteen/ITA/S86/ShareExchange.lean#L73), [`Canteen.ITA.ShareExchange.proceeds`](../../Canteen/ITA/S86/ShareExchange.lean#L110), [`Canteen.ITA.ShareExchange.newCost`](../../Canteen/ITA/S86/ShareExchange.lean#L104), [`Canteen.ITA.ShareExchange.excess`](../../Canteen/ITA/S86/ShareExchange.lean#L93)

### L2. Corporate attribution

**Status:** encoded · **Citation:** ITA 74.4(2)

A transfer to a corporation to benefit a spouse or minor child is taxed as prescribed-rate interest, less dividends on the shares taken back, unless the corporation is a small business corporation.

**Lean:** [`Canteen.ITA.CorporateAttribution.applies`](../../Canteen/ITA/S74/CorporateAttribution.lean#L61), [`Canteen.ITA.CorporateAttribution.deemedInterest`](../../Canteen/ITA/S74/CorporateAttribution.lean#L85)

## Facts

### F1. The exchange

**Status:** fact

Opco common shares (cost and paid-up capital $100, worth $2,000,000) for preferred shares worth $2,000,000.

**Lean:** [`Canteen.Transactions.EstateFreeze.exchange`](../../Canteen/Transactions/EstateFreeze.lean#L34), [`Canteen.Transactions.EstateFreeze.prefs`](../../Canteen/Transactions/EstateFreeze.lean#L32)

### F2. The children's shares, and the rate

**Status:** fact

The minor children subscribe for new common shares; the prescribed rate is 3%.

**Lean:** [`Canteen.Transactions.EstateFreeze.attribution`](../../Canteen/Transactions/EstateFreeze.lean#L39)

## Judgment call

### J-SBC. Opco is a small business corporation

**Status:** judgment call

All or substantially all of Opco's assets' value is in an active business carried on in Canada. Risk: low.

**Lean:** [`Canteen.Transactions.EstateFreeze.calls`](../../Canteen/Transactions/EstateFreeze.lean#L26), [`Canteen.Transactions.EstateFreeze.position`](../../Canteen/Transactions/EstateFreeze.lean#L30)

## Analysis

### A1. No gain on the exchange

**Status:** proven · **Citation:** ITA 86(1) · **Uses:** F1, L1

The preferred shares take over the $100 cost and $100 of paid-up capital; the proceeds are $100.

**Lean:** [`Canteen.Transactions.EstateFreeze.freeze_no_gain`](../../Canteen/Transactions/EstateFreeze.lean#L47)

**Rests on:** facts F1.

### A2. No benefit

**Status:** proven · **Citation:** ITA 86(2) · **Uses:** F1, L1

The preferred shares are worth what the common shares were, so there is no excess to tax.

**Lean:** [`Canteen.Transactions.EstateFreeze.no_benefit`](../../Canteen/Transactions/EstateFreeze.lean#L52)

**Rests on:** facts F1.

### A3. No corporate attribution

**Status:** proven · **Citation:** ITA 74.4(2)(c) · **Uses:** F2, J-SBC, L2

Opco is a small business corporation, so 74.4(2) deems nothing; this rests on J-SBC.

**Lean:** [`Canteen.Transactions.EstateFreeze.no_attribution`](../../Canteen/Transactions/EstateFreeze.lean#L55), [`Canteen.Transactions.EstateFreeze.relies_on_sbc`](../../Canteen/Transactions/EstateFreeze.lean#L65)

**Rests on:** judgment calls J-SBC; facts F2.

## Conclusion

### K. Conclusion

**Status:** proven · **Uses:** A1, A2, A3

The freeze is tax-free now, and, while Opco stays a small business corporation, each year after.

**Lean:** [`Canteen.Transactions.EstateFreeze.freeze_no_gain`](../../Canteen/Transactions/EstateFreeze.lean#L47), [`Canteen.Transactions.EstateFreeze.no_attribution`](../../Canteen/Transactions/EstateFreeze.lean#L55)

**Rests on:** judgment calls J-SBC; facts F1, F2.

## If Opco is not a small business corporation

### W1. $60,000 a year, unless dividends are paid

**Status:** proven · **Citation:** ITA 74.4(2)(d), (f) · **Uses:** F2, J-SBC, L2

The parent would be deemed to receive $60,000 of interest a year, but not if Opco pays at least $52,174 of dividends on the preferred shares ($60,000.10 included with the gross-up).

**Lean:** [`Canteen.Transactions.EstateFreeze.attribution_if_not_sbc`](../../Canteen/Transactions/EstateFreeze.lean#L58), [`Canteen.Transactions.EstateFreeze.dividends_avoid_it`](../../Canteen/Transactions/EstateFreeze.lean#L61)

**Rests on:** judgment calls J-SBC; facts F2.

## Appendix: the argument as Lean renders it

### Subsection 86(1)

```
1. The shares were disposed of in the course of a reorganization of the capital of the corporation. [ITA 86(1) reorganization]
2. They were capital property, all the shares of their class the taxpayer owned. [ITA 86(1) old shares]
3. Property receivable for them includes other shares of the corporation. [ITA 86(1) new shares]
4. Subsection 85(1) or (2) does not apply. [ITA 86(3)]
5. Therefore subsection 86(1) applies. [ITA 86(1)]
6. The new shares cost the old shares' adjusted cost base of $100.00 less the boot of $0.00: $100.00. [ITA 86(1)(a), (b)]
7. So the proceeds for the old shares are $100.00. [ITA 86(1)(c)]
Relies on no judgment calls.
```

### Subsection 74.4(2), if Opco is not a small business corporation

```
1. One of the main purposes of the transfer or loan may reasonably be considered to be to reduce the individual's income and benefit a designated person. [ITA 74.4(2) main purpose]
2. A designated person (a spouse or common-law partner, or a minor child, niece or nephew) is a specified shareholder of the corporation. [ITA 74.4(2)(a)]
3. The individual was resident in Canada. [ITA 74.4(2)(b)]
4. The corporation was not a small business corporation. [ITA 74.4(2)(c)]
5. Therefore subsection 74.4(2) applies. [ITA 74.4(2)]
6. Interest at the prescribed rate on $2,000,000.00 for 12 months would be $60,000.00; less interest received of $0.00, dividends included of $0.00, and split income dividends of $0.00, the individual is deemed to receive $60,000.00 of interest. [ITA 74.4(2)(d)–(g)]
Relies on these judgment calls:
- J-SBC: Is all or substantially all of the fair market value of Opco's assets attributable to assets used principally in an active business carried on primarily in Canada, throughout 2025? Assumed: no. Risk: high.
Overall risk: high.
```


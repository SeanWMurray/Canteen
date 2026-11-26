# Dashboard

> Generated from the Lean sources by `scripts/blueprint.sh`. Do not edit by hand.

An overview of the project, drawn from the Lean.

## Statements by status

Every statement in every blueprint, by the status Lean computes for it.

```mermaid
pie showData title All 138 statements in the memos and blueprints, by status
    "encoded" : 25
    "proven" : 81
    "not formalized" : 3
    "fact" : 24
    "judgment call" : 5
```

## Judgment calls by risk

Every judgment call in the transactions and examples, placed by the risk of answering "yes" (across) and "no" (up). Calls in the same place are spread out a little.

```mermaid
quadrantChart
    title Judgment calls by risk
    x-axis Low risk if yes --> High risk if yes
    y-axis Low risk if no --> High risk if no
    quadrant-1 Risky either way
    quadrant-2 Safer to answer yes
    quadrant-3 Safe either way
    quadrant-4 Safer to answer no
    J-ID in spouse repurchase: [0.15, 0.85]
    J-SIB in sibling repurchase: [0.19, 0.85]
    J-LATE in sibling repurchase: [0.23, 0.85]
    J-AFF in TFSA contribution: [0.50, 0.50]
    J-ID in Holdco repurchase: [0.15, 0.89]
    J-DEFACTO in Holdco what-if: [0.54, 0.50]
    J-PURPOSE in debt example: [0.58, 0.50]
    J-ARM in debt example: [0.50, 0.15]
    J-B in Rule X: [0.54, 0.15]
    J-E in Rule X: [0.85, 0.15]
```

## The transactions, by date

The key dates, read from each transaction's facts.

```mermaid
timeline
    title The transactions, by date
    2025-03-03 : Sibling repurchase, the sale
    2025-04-03 : Sibling repurchase, buy-back on day 31
    2025-06-15 : Spouse repurchase, the sale
    2025-06-20 : Spouse repurchase, the spouse buys
    2025-08-01 : Sister company, Opco sells
    2025-08-15 : Sister company, Sisterco buys
    2025-09-02 : TFSA contribution in kind
    2025-11-03 : Holdco repurchase, the sale
    2025-11-20 : Holdco repurchase, Holdco buys
    2026-02-02 : Sister company, the suspended loss is released
```

## The Act, as encoded

```mermaid
mindmap
  root((Income Tax Act, as encoded))
    n0["`s. 3`"]
      n1["`income for the year: (a) to (f)`"]
    n2["`ss. 38 to 41`"]
      n3["`38: inclusion rates`"]
      n4["`39(1): capital gains and losses`"]
      n5["`40(1): gains and losses, reserves`"]
      n6["`41: listed personal property`"]
    n7["`s. 40`"]
      n8["`40(2)(g): losses that are nil`"]
        n9["`(i) superficial losses`"]
        n10["`(ii) debts`"]
        n11["`(iii) personal-use property`"]
        n12["`(iv) TFSAs, RRSPs and other plans`"]
      n13["`40(3.3) to (3.5): suspended losses`"]
    n14["`s. 50`"]
      n15["`50(2): bad personal-use debts`"]
    n16["`s. 53`"]
      n17["`53(1)(f): cost of substituted property`"]
    n18["`s. 54`"]
      n19["`superficial loss`"]
      n20["`personal-use property`"]
      n21["`listed personal property`"]
    n22["`s. 111`"]
      n23["`111(8): net capital loss`"]
      n24["`111(1)(b), (1.1): deduction`"]
    n25["`s. 248`"]
      n26["`248(1): majority-interest partner`"]
    n27["`s. 251`"]
      n28["`251(1): arm's length`"]
      n29["`251(2), (3): related persons`"]
      n30["`251(3.1), (3.2): amalgamations`"]
      n31["`251(6): blood, marriage, adoption`"]
    n32["`s. 251.1`"]
      n33["`251.1(1)(a) to (h): affiliated persons`"]
      n34["`251.1(2): amalgamations`"]
      n35["`251.1(3), (4): definitions and rules`"]
```

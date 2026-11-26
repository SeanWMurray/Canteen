# Dashboard

> Generated from the Lean sources by `scripts/blueprint.sh`. Do not edit by hand.

An overview of the project, drawn from the Lean.

## Statements by status

Every statement in every blueprint, by the status Lean computes for it.

```mermaid
pie showData title All 173 statements in the memos and blueprints, by status
    "encoded" : 30
    "proven" : 106
    "not formalized" : 3
    "fact" : 28
    "judgment call" : 6
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
    J-SBC in crystallization: [0.19, 0.89]
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
    2025-06-30 : Crystallization, Opco shares to Holdco under 85(1)
    2026-03-02 : Crystallization, Holdco shares sold to Newco
```

## The Act, as encoded

```mermaid
mindmap
  root((Income Tax Act, as encoded))
    n0["`s. 3`"]
      n1["`income for the year: (a) to (f)`"]
    n2["`s. 13`"]
      n3["`13(21): undepreciated capital cost`"]
      n4["`13(1): recapture`"]
    n5["`ss. 38 to 41`"]
      n6["`38: inclusion rates`"]
      n7["`39(1): capital gains and losses`"]
      n8["`40(1): gains and losses, reserves`"]
      n9["`41: listed personal property`"]
    n10["`s. 40`"]
      n11["`40(2)(b): the principal residence exemption`"]
      n12["`40(2)(g): losses that are nil`"]
        n13["`(i) superficial losses`"]
        n14["`(ii) debts`"]
        n15["`(iii) personal-use property`"]
        n16["`(iv) TFSAs, RRSPs and other plans`"]
      n17["`40(2)(e.1): debts within a related group`"]
      n18["`40(3.3) to (3.5): suspended losses`"]
      n19["`40(3.6): shares to an affiliated corporation`"]
    n20["`s. 20`"]
      n21["`20(16): terminal loss`"]
    n22["`s. 45`"]
      n23["`45(1): change in use`"]
      n24["`45(2), (3), (4): the elections`"]
    n25["`s. 50`"]
      n26["`50(2): bad personal-use debts`"]
    n27["`s. 53`"]
      n28["`53(1)(f): cost of substituted property`"]
      n29["`53(1)(f.1), (f.2): cost after 40(2)(e.1), 40(3.6)`"]
    n30["`s. 54`"]
      n31["`superficial loss`"]
      n32["`principal residence`"]
      n33["`personal-use property`"]
      n34["`listed personal property`"]
    n35["`s. 55`"]
      n36["`55(2), (2.1): dividends over safe income`"]
      n37["`55(3): related parties, butterflies`"]
    n38["`s. 69`"]
      n39["`69(1): not at arm's length, gifts`"]
    n40["`s. 70`"]
      n41["`70(5): deemed disposition on death`"]
      n42["`70(6): rollover to a spouse or spousal trust`"]
    n43["`s. 73`"]
      n44["`73(1), (1.01): the spousal rollover`"]
    n45["`ss. 74.1, 74.2, 74.5`"]
      n46["`74.1(1), (2): income attributed back`"]
      n47["`74.1(3): repaying debt`"]
      n48["`74.2(1): capital gains attributed back`"]
      n49["`74.5(1) to (3): fair market value, loans for value, separation`"]
    n50["`s. 82`"]
      n51["`82(1): taxable dividends and the gross-up`"]
    n52["`s. 84.1`"]
      n53["`84.1(1): paid-up capital, and the deemed dividend`"]
      n54["`84.1(2): hard cost, arm's length`"]
    n55["`s. 85`"]
      n56["`85(1): the elected amount, and the cost of the consideration`"]
      n57["`85(2.1): paid-up capital`"]
    n58["`s. 110.6`"]
      n59["`qualified small business corporation share`"]
      n60["`annual and cumulative gains limits`"]
      n61["`110.6(2.1): the deduction`"]
    n62["`s. 111`"]
      n63["`111(8): net capital loss`"]
      n64["`111(1)(b), (1.1): deduction`"]
    n65["`s. 248`"]
      n66["`248(1): majority-interest partner`"]
    n67["`s. 251`"]
      n68["`251(1): arm's length`"]
      n69["`251(2), (3): related persons`"]
      n70["`251(3.1), (3.2): amalgamations`"]
      n71["`251(6): blood, marriage, adoption`"]
    n72["`s. 112`"]
      n73["`112(1): intercorporate dividend deduction`"]
    n74["`s. 121`"]
      n75["`121: the dividend tax credit`"]
    n76["`s. 251.2`"]
      n77["`251.2(2)(a): loss restriction event`"]
    n78["`s. 256`"]
      n79["`256(7)(a): control not acquired`"]
    n80["`s. 251.1`"]
      n81["`251.1(1)(a) to (h): affiliated persons`"]
      n82["`251.1(2): amalgamations`"]
      n83["`251.1(3), (4): definitions and rules`"]
```

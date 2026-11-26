# Dashboard

> Generated from the Lean sources by `scripts/blueprint.sh`. Do not edit by hand.

An overview of the project, drawn from the Lean.

## Statements by status

Every statement in every blueprint, by the status Lean computes for it.

```mermaid
pie showData title All 172 statements in the memos and blueprints, by status
    "encoded" : 30
    "proven" : 105
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
    n2["`ss. 38 to 41`"]
      n3["`38: inclusion rates`"]
      n4["`39(1): capital gains and losses`"]
      n5["`40(1): gains and losses, reserves`"]
      n6["`41: listed personal property`"]
    n7["`s. 40`"]
      n8["`40(2)(b): the principal residence exemption`"]
      n9["`40(2)(g): losses that are nil`"]
        n10["`(i) superficial losses`"]
        n11["`(ii) debts`"]
        n12["`(iii) personal-use property`"]
        n13["`(iv) TFSAs, RRSPs and other plans`"]
      n14["`40(2)(e.1): debts within a related group`"]
      n15["`40(3.3) to (3.5): suspended losses`"]
      n16["`40(3.6): shares to an affiliated corporation`"]
    n17["`s. 45`"]
      n18["`45(1): change in use`"]
      n19["`45(2), (3), (4): the elections`"]
    n20["`s. 50`"]
      n21["`50(2): bad personal-use debts`"]
    n22["`s. 53`"]
      n23["`53(1)(f): cost of substituted property`"]
      n24["`53(1)(f.1), (f.2): cost after 40(2)(e.1), 40(3.6)`"]
    n25["`s. 54`"]
      n26["`superficial loss`"]
      n27["`principal residence`"]
      n28["`personal-use property`"]
      n29["`listed personal property`"]
    n30["`s. 55`"]
      n31["`55(2), (2.1): dividends over safe income`"]
      n32["`55(3): related parties, butterflies`"]
    n33["`s. 69`"]
      n34["`69(1): not at arm's length, gifts`"]
    n35["`s. 70`"]
      n36["`70(5): deemed disposition on death`"]
      n37["`70(6): rollover to a spouse or spousal trust`"]
    n38["`s. 73`"]
      n39["`73(1), (1.01): the spousal rollover`"]
    n40["`ss. 74.1, 74.2, 74.5`"]
      n41["`74.1(1), (2): income attributed back`"]
      n42["`74.1(3): repaying debt`"]
      n43["`74.2(1): capital gains attributed back`"]
      n44["`74.5(1) to (3): fair market value, loans for value, separation`"]
    n45["`s. 82`"]
      n46["`82(1): taxable dividends and the gross-up`"]
    n47["`s. 84.1`"]
      n48["`84.1(1): paid-up capital, and the deemed dividend`"]
      n49["`84.1(2): hard cost, arm's length`"]
    n50["`s. 85`"]
      n51["`85(1): the elected amount, and the cost of the consideration`"]
      n52["`85(2.1): paid-up capital`"]
    n53["`s. 110.6`"]
      n54["`qualified small business corporation share`"]
      n55["`annual and cumulative gains limits`"]
      n56["`110.6(2.1): the deduction`"]
    n57["`s. 111`"]
      n58["`111(8): net capital loss`"]
      n59["`111(1)(b), (1.1): deduction`"]
    n60["`s. 248`"]
      n61["`248(1): majority-interest partner`"]
    n62["`s. 251`"]
      n63["`251(1): arm's length`"]
      n64["`251(2), (3): related persons`"]
      n65["`251(3.1), (3.2): amalgamations`"]
      n66["`251(6): blood, marriage, adoption`"]
    n67["`s. 112`"]
      n68["`112(1): intercorporate dividend deduction`"]
    n69["`s. 121`"]
      n70["`121: the dividend tax credit`"]
    n71["`s. 251.2`"]
      n72["`251.2(2)(a): loss restriction event`"]
    n73["`s. 256`"]
      n74["`256(7)(a): control not acquired`"]
    n75["`s. 251.1`"]
      n76["`251.1(1)(a) to (h): affiliated persons`"]
      n77["`251.1(2): amalgamations`"]
      n78["`251.1(3), (4): definitions and rules`"]
```

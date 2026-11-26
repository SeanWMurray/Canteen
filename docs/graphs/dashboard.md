# Dashboard

> Generated from the Lean sources by `scripts/blueprint.sh`. Do not edit by hand.

An overview of the project, drawn from the Lean.

## Statements by status

Every statement in every blueprint, by the status Lean computes for it.

```mermaid
pie showData title All 192 statements in the memos and blueprints, by status
    "encoded" : 33
    "proven" : 118
    "not formalized" : 3
    "fact" : 31
    "judgment call" : 7
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
    J-55 in sale through Holdco: [0.23, 0.89]
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
    2025-09-01 : Sale through Holdco, Opco's dividends
    2025-09-15 : Sale through Holdco, the sale
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
    n5["`s. 20`"]
      n6["`20(16): terminal loss`"]
    n7["`ss. 38 to 41`"]
      n8["`38: inclusion rates`"]
      n9["`39(1): capital gains and losses`"]
      n10["`40(1): gains and losses, reserves`"]
      n11["`41: listed personal property`"]
    n12["`s. 40`"]
      n13["`40(2)(b): the principal residence exemption`"]
      n14["`40(2)(g): losses that are nil`"]
        n15["`(i) superficial losses`"]
        n16["`(ii) debts`"]
        n17["`(iii) personal-use property`"]
        n18["`(iv) TFSAs, RRSPs and other plans`"]
      n19["`40(2)(e.1): debts within a related group`"]
      n20["`40(3.3) to (3.5): suspended losses`"]
      n21["`40(3.6): shares to an affiliated corporation`"]
    n22["`s. 44`"]
      n23["`44(1): replacement property`"]
    n24["`s. 45`"]
      n25["`45(1): change in use`"]
      n26["`45(2), (3), (4): the elections`"]
    n27["`s. 50`"]
      n28["`50(2): bad personal-use debts`"]
    n29["`s. 53`"]
      n30["`53(1)(f): cost of substituted property`"]
      n31["`53(1)(f.1), (f.2): cost after 40(2)(e.1), 40(3.6)`"]
    n32["`s. 54`"]
      n33["`superficial loss`"]
      n34["`principal residence`"]
      n35["`personal-use property`"]
      n36["`listed personal property`"]
    n37["`s. 55`"]
      n38["`55(2), (2.1): dividends over safe income`"]
      n39["`55(3): related parties, butterflies`"]
    n40["`s. 69`"]
      n41["`69(1): not at arm's length, gifts`"]
    n42["`s. 70`"]
      n43["`70(5): deemed disposition on death`"]
      n44["`70(6): rollover to a spouse or spousal trust`"]
    n45["`s. 73`"]
      n46["`73(1), (1.01): the spousal rollover`"]
    n47["`ss. 74.1, 74.2, 74.5`"]
      n48["`74.1(1), (2): income attributed back`"]
      n49["`74.1(3): repaying debt`"]
      n50["`74.2(1): capital gains attributed back`"]
      n51["`74.5(1) to (3): fair market value, loans for value, separation`"]
    n52["`s. 82`"]
      n53["`82(1): taxable dividends and the gross-up`"]
    n54["`s. 83`"]
      n55["`83(2): capital dividends`"]
    n56["`s. 84`"]
      n57["`84(3): redemptions, the deemed dividend`"]
    n58["`s. 84.1`"]
      n59["`84.1(1): paid-up capital, and the deemed dividend`"]
      n60["`84.1(2): hard cost, arm's length`"]
    n61["`s. 85`"]
      n62["`85(1): the elected amount, and the cost of the consideration`"]
      n63["`85(2.1): paid-up capital`"]
    n64["`s. 86`"]
      n65["`86(1): share exchange in a reorganization`"]
      n66["`86(2): benefit to a related person`"]
    n67["`s. 89`"]
      n68["`89(1): capital dividend account`"]
    n69["`s. 110.6`"]
      n70["`qualified small business corporation share`"]
      n71["`annual and cumulative gains limits`"]
      n72["`110.6(2.1): the deduction`"]
    n73["`s. 111`"]
      n74["`111(8): net capital loss`"]
      n75["`111(1)(b), (1.1): deduction`"]
    n76["`s. 112`"]
      n77["`112(1): intercorporate dividend deduction`"]
    n78["`s. 121`"]
      n79["`121: the dividend tax credit`"]
    n80["`s. 248`"]
      n81["`248(1): majority-interest partner`"]
    n82["`s. 251`"]
      n83["`251(1): arm's length`"]
      n84["`251(2), (3): related persons`"]
      n85["`251(3.1), (3.2): amalgamations`"]
      n86["`251(6): blood, marriage, adoption`"]
    n87["`s. 251.1`"]
      n88["`251.1(1)(a) to (h): affiliated persons`"]
      n89["`251.1(2): amalgamations`"]
      n90["`251.1(3), (4): definitions and rules`"]
    n91["`s. 251.2`"]
      n92["`251.2(2)(a): loss restriction event`"]
    n93["`s. 256`"]
      n94["`256(7)(a): control not acquired`"]
```

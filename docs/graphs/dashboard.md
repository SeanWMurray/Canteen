# Dashboard

> Generated from the Lean sources by `scripts/blueprint.sh`. Do not edit by hand.

An overview of the project, drawn from the Lean.

## Statements by status

Every statement in every blueprint, by the status Lean computes for it.

```mermaid
pie showData title All 213 statements in the memos and blueprints, by status
    "encoded" : 36
    "proven" : 134
    "not formalized" : 3
    "fact" : 33
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
    2026-04-01 : Post-mortem pipeline, the estate sells to Newco
```

## The Act, as encoded

```mermaid
mindmap
  root((Income Tax Act, as encoded))
    n0["`ss. 2, 3`"]
      n1["`income for the year: (a) to (f)`"]
      n2["`2(2): taxable income`"]
    n3["`s. 13`"]
      n4["`13(21): undepreciated capital cost`"]
      n5["`13(1): recapture`"]
    n6["`s. 20`"]
      n7["`20(16): terminal loss`"]
    n8["`ss. 38 to 41`"]
      n9["`38: inclusion rates`"]
      n10["`39(1): capital gains and losses`"]
      n11["`39(4): the Canadian securities election`"]
      n12["`40(1): gains and losses, reserves`"]
      n13["`41: listed personal property`"]
    n14["`s. 40`"]
      n15["`40(2)(b): the principal residence exemption`"]
      n16["`40(2)(g): losses that are nil`"]
        n17["`(i) superficial losses`"]
        n18["`(ii) debts`"]
        n19["`(iii) personal-use property`"]
        n20["`(iv) TFSAs, RRSPs and other plans`"]
      n21["`40(2)(e.1): debts within a related group`"]
      n22["`40(3.3) to (3.5): suspended losses`"]
      n23["`40(3.6): shares to an affiliated corporation`"]
      n24["`40(3): negative adjusted cost base`"]
    n25["`s. 43`"]
      n26["`43(1): part of a property`"]
    n27["`s. 44`"]
      n28["`44(1): replacement property`"]
    n29["`s. 45`"]
      n30["`45(1): change in use`"]
      n31["`45(2), (3), (4): the elections`"]
    n32["`s. 47`"]
      n33["`47(1): identical properties, average cost`"]
    n34["`s. 50`"]
      n35["`50(1): bad debts, worthless shares`"]
      n36["`50(2): bad personal-use debts`"]
    n37["`s. 51`"]
      n38["`51(1), (2): convertible property`"]
    n39["`s. 53`"]
      n40["`53(1)(f): cost of substituted property`"]
      n41["`53(1)(f.1), (f.2): cost after 40(2)(e.1), 40(3.6)`"]
    n42["`s. 54`"]
      n43["`superficial loss`"]
      n44["`principal residence`"]
      n45["`personal-use property`"]
      n46["`listed personal property`"]
    n47["`s. 55`"]
      n48["`55(2), (2.1): dividends over safe income`"]
      n49["`55(3): related parties, butterflies`"]
    n50["`s. 69`"]
      n51["`69(1): not at arm's length, gifts`"]
    n52["`s. 70`"]
      n53["`70(5): deemed disposition on death`"]
      n54["`70(6): rollover to a spouse or spousal trust`"]
    n55["`s. 73`"]
      n56["`73(1), (1.01): the spousal rollover`"]
    n57["`ss. 74.1, 74.2, 74.5`"]
      n58["`74.1(1), (2): income attributed back`"]
      n59["`74.1(3): repaying debt`"]
      n60["`74.2(1): capital gains attributed back`"]
      n61["`74.5(1) to (3): fair market value, loans for value, separation`"]
    n62["`s. 82`"]
      n63["`82(1): taxable dividends and the gross-up`"]
    n64["`s. 83`"]
      n65["`83(2): capital dividends`"]
    n66["`s. 84`"]
      n67["`84(3): redemptions, the deemed dividend`"]
      n68["`84(4), (4.1): returns of capital`"]
    n69["`s. 84.1`"]
      n70["`84.1(1): paid-up capital, and the deemed dividend`"]
      n71["`84.1(2): hard cost, arm's length`"]
    n72["`s. 85`"]
      n73["`85(1): the elected amount, and the cost of the consideration`"]
      n74["`85(2.1): paid-up capital`"]
    n75["`s. 86`"]
      n76["`86(1): share exchange in a reorganization`"]
      n77["`86(2): benefit to a related person`"]
    n78["`s. 87`"]
      n79["`87(1): amalgamation`"]
      n80["`87(2)(e): cost of capital property`"]
      n81["`87(4): shareholders`"]
    n82["`s. 88`"]
      n83["`88(1): winding up a subsidiary`"]
      n84["`88(1)(c), (d): the bump`"]
    n85["`s. 89`"]
      n86["`89(1): capital dividend account`"]
    n87["`s. 110.6`"]
      n88["`qualified small business corporation share`"]
      n89["`annual and cumulative gains limits`"]
      n90["`110.6(2.1): the deduction`"]
    n91["`s. 111`"]
      n92["`111(8): net capital loss`"]
      n93["`111(1)(b), (1.1): deduction`"]
    n94["`s. 112`"]
      n95["`112(1): intercorporate dividend deduction`"]
    n96["`s. 121`"]
      n97["`121: the dividend tax credit`"]
    n98["`s. 186`"]
      n99["`186(4): connected corporations`"]
      n100["`186(2): control with non-arm's length persons`"]
    n101["`s. 248`"]
      n102["`248(1): majority-interest partner`"]
    n103["`s. 251`"]
      n104["`251(1): arm's length`"]
      n105["`251(2), (3): related persons`"]
      n106["`251(3.1), (3.2): amalgamations`"]
      n107["`251(6): blood, marriage, adoption`"]
    n108["`s. 251.1`"]
      n109["`251.1(1)(a) to (h): affiliated persons`"]
      n110["`251.1(2): amalgamations`"]
      n111["`251.1(3), (4): definitions and rules`"]
    n112["`s. 251.2`"]
      n113["`251.2(2)(a): loss restriction event`"]
    n114["`s. 256`"]
      n115["`256(7)(a): control not acquired`"]
```

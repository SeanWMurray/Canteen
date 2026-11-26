# Dashboard

> Generated from the Lean sources by `scripts/blueprint.sh`. Do not edit by hand.

An overview of the project, drawn from the Lean.

## Statements by status

Every statement in every blueprint, by the status Lean computes for it.

```mermaid
pie showData title All 210 statements in the memos and blueprints, by status
    "encoded" : 36
    "proven" : 131
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
      n11["`40(1): gains and losses, reserves`"]
      n12["`41: listed personal property`"]
    n13["`s. 40`"]
      n14["`40(2)(b): the principal residence exemption`"]
      n15["`40(2)(g): losses that are nil`"]
        n16["`(i) superficial losses`"]
        n17["`(ii) debts`"]
        n18["`(iii) personal-use property`"]
        n19["`(iv) TFSAs, RRSPs and other plans`"]
      n20["`40(2)(e.1): debts within a related group`"]
      n21["`40(3.3) to (3.5): suspended losses`"]
      n22["`40(3.6): shares to an affiliated corporation`"]
      n23["`40(3): negative adjusted cost base`"]
    n24["`s. 44`"]
      n25["`44(1): replacement property`"]
    n26["`s. 45`"]
      n27["`45(1): change in use`"]
      n28["`45(2), (3), (4): the elections`"]
    n29["`s. 47`"]
      n30["`47(1): identical properties, average cost`"]
    n31["`s. 50`"]
      n32["`50(2): bad personal-use debts`"]
    n33["`s. 51`"]
      n34["`51(1), (2): convertible property`"]
    n35["`s. 53`"]
      n36["`53(1)(f): cost of substituted property`"]
      n37["`53(1)(f.1), (f.2): cost after 40(2)(e.1), 40(3.6)`"]
    n38["`s. 54`"]
      n39["`superficial loss`"]
      n40["`principal residence`"]
      n41["`personal-use property`"]
      n42["`listed personal property`"]
    n43["`s. 55`"]
      n44["`55(2), (2.1): dividends over safe income`"]
      n45["`55(3): related parties, butterflies`"]
    n46["`s. 69`"]
      n47["`69(1): not at arm's length, gifts`"]
    n48["`s. 70`"]
      n49["`70(5): deemed disposition on death`"]
      n50["`70(6): rollover to a spouse or spousal trust`"]
    n51["`s. 73`"]
      n52["`73(1), (1.01): the spousal rollover`"]
    n53["`ss. 74.1, 74.2, 74.5`"]
      n54["`74.1(1), (2): income attributed back`"]
      n55["`74.1(3): repaying debt`"]
      n56["`74.2(1): capital gains attributed back`"]
      n57["`74.5(1) to (3): fair market value, loans for value, separation`"]
    n58["`s. 82`"]
      n59["`82(1): taxable dividends and the gross-up`"]
    n60["`s. 83`"]
      n61["`83(2): capital dividends`"]
    n62["`s. 84`"]
      n63["`84(3): redemptions, the deemed dividend`"]
      n64["`84(4), (4.1): returns of capital`"]
    n65["`s. 84.1`"]
      n66["`84.1(1): paid-up capital, and the deemed dividend`"]
      n67["`84.1(2): hard cost, arm's length`"]
    n68["`s. 85`"]
      n69["`85(1): the elected amount, and the cost of the consideration`"]
      n70["`85(2.1): paid-up capital`"]
    n71["`s. 86`"]
      n72["`86(1): share exchange in a reorganization`"]
      n73["`86(2): benefit to a related person`"]
    n74["`s. 87`"]
      n75["`87(1): amalgamation`"]
      n76["`87(2)(e): cost of capital property`"]
      n77["`87(4): shareholders`"]
    n78["`s. 88`"]
      n79["`88(1): winding up a subsidiary`"]
      n80["`88(1)(c), (d): the bump`"]
    n81["`s. 89`"]
      n82["`89(1): capital dividend account`"]
    n83["`s. 110.6`"]
      n84["`qualified small business corporation share`"]
      n85["`annual and cumulative gains limits`"]
      n86["`110.6(2.1): the deduction`"]
    n87["`s. 111`"]
      n88["`111(8): net capital loss`"]
      n89["`111(1)(b), (1.1): deduction`"]
    n90["`s. 112`"]
      n91["`112(1): intercorporate dividend deduction`"]
    n92["`s. 121`"]
      n93["`121: the dividend tax credit`"]
    n94["`s. 186`"]
      n95["`186(4): connected corporations`"]
      n96["`186(2): control with non-arm's length persons`"]
    n97["`s. 248`"]
      n98["`248(1): majority-interest partner`"]
    n99["`s. 251`"]
      n100["`251(1): arm's length`"]
      n101["`251(2), (3): related persons`"]
      n102["`251(3.1), (3.2): amalgamations`"]
      n103["`251(6): blood, marriage, adoption`"]
    n104["`s. 251.1`"]
      n105["`251.1(1)(a) to (h): affiliated persons`"]
      n106["`251.1(2): amalgamations`"]
      n107["`251.1(3), (4): definitions and rules`"]
    n108["`s. 251.2`"]
      n109["`251.2(2)(a): loss restriction event`"]
    n110["`s. 256`"]
      n111["`256(7)(a): control not acquired`"]
```

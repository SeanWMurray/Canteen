# Dashboard

> Generated from the Lean sources by `scripts/blueprint.sh`. Do not edit by hand.

An overview of the project, drawn from the Lean.

## Statements by status

Every statement in every blueprint, by the status Lean computes for it.

```mermaid
pie showData title All 209 statements in the memos and blueprints, by status
    "encoded" : 36
    "proven" : 130
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
      n22["`40(3): negative adjusted cost base`"]
    n23["`s. 44`"]
      n24["`44(1): replacement property`"]
    n25["`s. 45`"]
      n26["`45(1): change in use`"]
      n27["`45(2), (3), (4): the elections`"]
    n28["`s. 47`"]
      n29["`47(1): identical properties, average cost`"]
    n30["`s. 50`"]
      n31["`50(2): bad personal-use debts`"]
    n32["`s. 51`"]
      n33["`51(1), (2): convertible property`"]
    n34["`s. 53`"]
      n35["`53(1)(f): cost of substituted property`"]
      n36["`53(1)(f.1), (f.2): cost after 40(2)(e.1), 40(3.6)`"]
    n37["`s. 54`"]
      n38["`superficial loss`"]
      n39["`principal residence`"]
      n40["`personal-use property`"]
      n41["`listed personal property`"]
    n42["`s. 55`"]
      n43["`55(2), (2.1): dividends over safe income`"]
      n44["`55(3): related parties, butterflies`"]
    n45["`s. 69`"]
      n46["`69(1): not at arm's length, gifts`"]
    n47["`s. 70`"]
      n48["`70(5): deemed disposition on death`"]
      n49["`70(6): rollover to a spouse or spousal trust`"]
    n50["`s. 73`"]
      n51["`73(1), (1.01): the spousal rollover`"]
    n52["`ss. 74.1, 74.2, 74.5`"]
      n53["`74.1(1), (2): income attributed back`"]
      n54["`74.1(3): repaying debt`"]
      n55["`74.2(1): capital gains attributed back`"]
      n56["`74.5(1) to (3): fair market value, loans for value, separation`"]
    n57["`s. 82`"]
      n58["`82(1): taxable dividends and the gross-up`"]
    n59["`s. 83`"]
      n60["`83(2): capital dividends`"]
    n61["`s. 84`"]
      n62["`84(3): redemptions, the deemed dividend`"]
      n63["`84(4), (4.1): returns of capital`"]
    n64["`s. 84.1`"]
      n65["`84.1(1): paid-up capital, and the deemed dividend`"]
      n66["`84.1(2): hard cost, arm's length`"]
    n67["`s. 85`"]
      n68["`85(1): the elected amount, and the cost of the consideration`"]
      n69["`85(2.1): paid-up capital`"]
    n70["`s. 86`"]
      n71["`86(1): share exchange in a reorganization`"]
      n72["`86(2): benefit to a related person`"]
    n73["`s. 87`"]
      n74["`87(1): amalgamation`"]
      n75["`87(2)(e): cost of capital property`"]
      n76["`87(4): shareholders`"]
    n77["`s. 88`"]
      n78["`88(1): winding up a subsidiary`"]
      n79["`88(1)(c), (d): the bump`"]
    n80["`s. 89`"]
      n81["`89(1): capital dividend account`"]
    n82["`s. 110.6`"]
      n83["`qualified small business corporation share`"]
      n84["`annual and cumulative gains limits`"]
      n85["`110.6(2.1): the deduction`"]
    n86["`s. 111`"]
      n87["`111(8): net capital loss`"]
      n88["`111(1)(b), (1.1): deduction`"]
    n89["`s. 112`"]
      n90["`112(1): intercorporate dividend deduction`"]
    n91["`s. 121`"]
      n92["`121: the dividend tax credit`"]
    n93["`s. 186`"]
      n94["`186(4): connected corporations`"]
      n95["`186(2): control with non-arm's length persons`"]
    n96["`s. 248`"]
      n97["`248(1): majority-interest partner`"]
    n98["`s. 251`"]
      n99["`251(1): arm's length`"]
      n100["`251(2), (3): related persons`"]
      n101["`251(3.1), (3.2): amalgamations`"]
      n102["`251(6): blood, marriage, adoption`"]
    n103["`s. 251.1`"]
      n104["`251.1(1)(a) to (h): affiliated persons`"]
      n105["`251.1(2): amalgamations`"]
      n106["`251.1(3), (4): definitions and rules`"]
    n107["`s. 251.2`"]
      n108["`251.2(2)(a): loss restriction event`"]
    n109["`s. 256`"]
      n110["`256(7)(a): control not acquired`"]
```

# Dashboard

> Generated from the Lean sources by `scripts/blueprint.sh`. Do not edit by hand.

An overview of the project, drawn from the Lean.

## Statements by status

Every statement in every blueprint, by the status Lean computes for it.

```mermaid
pie showData title All 258 statements in the memos and blueprints, by status
    "encoded" : 45
    "proven" : 164
    "not formalized" : 3
    "fact" : 38
    "judgment call" : 8
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
    J-SBC in estate freeze: [0.15, 0.93]
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
    2025-01-15 : Estate freeze, the exchange
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
    n6["`s. 15`"]
      n7["`15(2), (2.6): shareholder loans`"]
    n8["`s. 20`"]
      n9["`20(16): terminal loss`"]
      n10["`20(1)(j): loan repaid`"]
    n11["`ss. 38 to 41`"]
      n12["`38: inclusion rates`"]
      n13["`39(1): capital gains and losses`"]
      n14["`39(4): the Canadian securities election`"]
      n15["`40(1): gains and losses, reserves`"]
      n16["`41: listed personal property`"]
    n17["`s. 40`"]
      n18["`40(2)(b): the principal residence exemption`"]
      n19["`40(2)(g): losses that are nil`"]
        n20["`(i) superficial losses`"]
        n21["`(ii) debts`"]
        n22["`(iii) personal-use property`"]
        n23["`(iv) TFSAs, RRSPs and other plans`"]
      n24["`40(2)(e.1): debts within a related group`"]
      n25["`40(3.3) to (3.5): suspended losses`"]
      n26["`40(3.6): shares to an affiliated corporation`"]
      n27["`40(3): negative adjusted cost base`"]
    n28["`s. 43`"]
      n29["`43(1): part of a property`"]
    n30["`s. 44`"]
      n31["`44(1): replacement property`"]
    n32["`s. 45`"]
      n33["`45(1): change in use`"]
      n34["`45(2), (3), (4): the elections`"]
    n35["`s. 47`"]
      n36["`47(1): identical properties, average cost`"]
    n37["`s. 50`"]
      n38["`50(1): bad debts, worthless shares`"]
      n39["`50(2): bad personal-use debts`"]
    n40["`s. 51`"]
      n41["`51(1), (2): convertible property`"]
    n42["`s. 53`"]
      n43["`53(1)(f): cost of substituted property`"]
      n44["`53(1)(f.1), (f.2): cost after 40(2)(e.1), 40(3.6)`"]
    n45["`s. 54`"]
      n46["`superficial loss`"]
      n47["`principal residence`"]
      n48["`personal-use property`"]
      n49["`listed personal property`"]
    n50["`s. 55`"]
      n51["`55(2), (2.1): dividends over safe income`"]
      n52["`55(3): related parties, butterflies`"]
    n53["`s. 69`"]
      n54["`69(1): not at arm's length, gifts`"]
    n55["`s. 70`"]
      n56["`70(5): deemed disposition on death`"]
      n57["`70(6): rollover to a spouse or spousal trust`"]
    n58["`s. 73`"]
      n59["`73(1), (1.01): the spousal rollover`"]
    n60["`ss. 74.1, 74.2, 74.4, 74.5`"]
      n61["`74.1(1), (2): income attributed back`"]
      n62["`74.1(3): repaying debt`"]
      n63["`74.2(1): capital gains attributed back`"]
      n64["`74.4(2): corporate attribution`"]
      n65["`74.5(1) to (3): fair market value, loans for value, separation`"]
    n66["`s. 80.4`"]
      n67["`80.4(2): deemed interest on shareholder loans`"]
    n68["`s. 82`"]
      n69["`82(1): taxable dividends and the gross-up`"]
    n70["`s. 83`"]
      n71["`83(2): capital dividends`"]
    n72["`s. 84`"]
      n73["`84(3): redemptions, the deemed dividend`"]
      n74["`84(4), (4.1): returns of capital`"]
    n75["`s. 84.1`"]
      n76["`84.1(1): paid-up capital, and the deemed dividend`"]
      n77["`84.1(2): hard cost, arm's length`"]
    n78["`s. 85`"]
      n79["`85(1): the elected amount, and the cost of the consideration`"]
      n80["`85(2.1): paid-up capital`"]
    n81["`s. 86`"]
      n82["`86(1): share exchange in a reorganization`"]
      n83["`86(2): benefit to a related person`"]
    n84["`s. 87`"]
      n85["`87(1): amalgamation`"]
      n86["`87(2)(e): cost of capital property`"]
      n87["`87(4): shareholders`"]
    n88["`s. 88`"]
      n89["`88(1): winding up a subsidiary`"]
      n90["`88(1)(c), (d): the bump`"]
    n91["`s. 89`"]
      n92["`89(1): capital dividend account`"]
      n93["`89(1): general rate income pool`"]
    n94["`s. 110.6`"]
      n95["`qualified small business corporation share`"]
      n96["`annual and cumulative gains limits`"]
      n97["`110.6(2.1): the deduction`"]
    n98["`s. 111`"]
      n99["`111(8): net capital loss`"]
      n100["`111(1)(b), (1.1): deduction`"]
    n101["`s. 112`"]
      n102["`112(1): intercorporate dividend deduction`"]
    n103["`s. 117`"]
      n104["`117(2): the federal rates`"]
    n105["`s. 118`"]
      n106["`118(1.1): basic personal amount`"]
      n107["`118(1)(a): spouse amount`"]
    n108["`s. 118.1`"]
      n109["`118.1(1): total gifts`"]
      n110["`118.1(3): the credit`"]
    n111["`s. 120.4`"]
      n112["`120.4(1): split income, excluded amounts`"]
      n113["`120.4(2), (3): the tax`"]
    n114["`s. 121`"]
      n115["`121: the dividend tax credit`"]
    n116["`ss. 123 to 125`"]
      n117["`123(1), 124(1): 38%, the abatement`"]
      n118["`123.4(2): general rate reduction`"]
      n119["`125(1): small business deduction`"]
    n120["`ss. 123.3, 129`"]
      n121["`123.3: refundable tax on investment income`"]
      n122["`129(1), (4): the dividend refund`"]
    n123["`s. 185.1`"]
      n124["`185.1(1): Part III.1 tax on excessive designations`"]
    n125["`s. 186`"]
      n126["`186(1): Part IV tax`"]
      n127["`186(4): connected corporations`"]
      n128["`186(2): control with non-arm's length persons`"]
    n129["`s. 248`"]
      n130["`248(1): majority-interest partner`"]
    n131["`s. 251`"]
      n132["`251(1): arm's length`"]
      n133["`251(2), (3): related persons`"]
      n134["`251(3.1), (3.2): amalgamations`"]
      n135["`251(6): blood, marriage, adoption`"]
    n136["`s. 251.1`"]
      n137["`251.1(1)(a) to (h): affiliated persons`"]
      n138["`251.1(2): amalgamations`"]
      n139["`251.1(3), (4): definitions and rules`"]
    n140["`s. 251.2`"]
      n141["`251.2(2)(a): loss restriction event`"]
    n142["`s. 256`"]
      n143["`256(7)(a): control not acquired`"]
```

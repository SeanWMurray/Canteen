# Dashboard

> Generated from the Lean sources by `scripts/blueprint.sh`. Do not edit by hand.

An overview of the project, drawn from the Lean.

## Statements by status

Every statement in every blueprint, by the status Lean computes for it.

```mermaid
pie showData title All 344 statements in the memos and blueprints, by status
    "encoded" : 62
    "proven" : 225
    "not formalized" : 3
    "fact" : 44
    "judgment call" : 10
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
    J-INC in debt swap: [0.19, 0.93]
    J-ID in debt swap what-if: [0.23, 0.93]
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
    n3["`s. 6`"]
      n4["`6(1)(e), 6(2): automobile standby charge`"]
    n5["`s. 13`"]
      n6["`13(21): undepreciated capital cost`"]
      n7["`13(1): recapture`"]
    n8["`s. 15`"]
      n9["`15(2), (2.6): shareholder loans`"]
    n10["`s. 20`"]
      n11["`20(16): terminal loss`"]
      n12["`20(1)(j): loan repaid`"]
      n13["`20(1)(c): interest`"]
      n14["`20(3): refinancing`"]
    n15["`ss. 38 to 41`"]
      n16["`38: inclusion rates`"]
      n17["`39(1): capital gains and losses`"]
      n18["`39(4): the Canadian securities election`"]
      n19["`40(1): gains and losses, reserves`"]
      n20["`41: listed personal property`"]
    n21["`s. 40`"]
      n22["`40(2)(b): the principal residence exemption`"]
      n23["`40(2)(g): losses that are nil`"]
        n24["`(i) superficial losses`"]
        n25["`(ii) debts`"]
        n26["`(iii) personal-use property`"]
        n27["`(iv) TFSAs, RRSPs and other plans`"]
      n28["`40(2)(e.1): debts within a related group`"]
      n29["`40(3.3) to (3.5): suspended losses`"]
      n30["`40(3.6): shares to an affiliated corporation`"]
      n31["`40(3): negative adjusted cost base`"]
    n32["`s. 43`"]
      n33["`43(1): part of a property`"]
    n34["`s. 44`"]
      n35["`44(1): replacement property`"]
    n36["`s. 45`"]
      n37["`45(1): change in use`"]
      n38["`45(2), (3), (4): the elections`"]
    n39["`s. 47`"]
      n40["`47(1): identical properties, average cost`"]
    n41["`s. 50`"]
      n42["`50(1): bad debts, worthless shares`"]
      n43["`50(2): bad personal-use debts`"]
    n44["`s. 51`"]
      n45["`51(1), (2): convertible property`"]
    n46["`s. 53`"]
      n47["`53(1)(f): cost of substituted property`"]
      n48["`53(1)(f.1), (f.2): cost after 40(2)(e.1), 40(3.6)`"]
    n49["`s. 54`"]
      n50["`superficial loss`"]
      n51["`principal residence`"]
      n52["`personal-use property`"]
      n53["`listed personal property`"]
    n54["`s. 55`"]
      n55["`55(2), (2.1): dividends over safe income`"]
      n56["`55(3): related parties, butterflies`"]
    n57["`s. 69`"]
      n58["`69(1): not at arm's length, gifts`"]
    n59["`s. 70`"]
      n60["`70(5): deemed disposition on death`"]
      n61["`70(6): rollover to a spouse or spousal trust`"]
    n62["`s. 73`"]
      n63["`73(1), (1.01): the spousal rollover`"]
    n64["`ss. 74.1, 74.2, 74.4, 74.5`"]
      n65["`74.1(1), (2): income attributed back`"]
      n66["`74.1(3): repaying debt`"]
      n67["`74.2(1): capital gains attributed back`"]
      n68["`74.4(2): corporate attribution`"]
      n69["`74.5(1) to (3): fair market value, loans for value, separation`"]
    n70["`s. 80.4`"]
      n71["`80.4(2): deemed interest on shareholder loans`"]
    n72["`s. 82`"]
      n73["`82(1): taxable dividends and the gross-up`"]
    n74["`s. 83`"]
      n75["`83(2): capital dividends`"]
    n76["`s. 84`"]
      n77["`84(1): paid-up capital increased`"]
      n78["`84(2): distributions on winding-up`"]
      n79["`84(3): redemptions, the deemed dividend`"]
      n80["`84(4), (4.1): returns of capital`"]
    n81["`s. 84.1`"]
      n82["`84.1(1): paid-up capital, and the deemed dividend`"]
      n83["`84.1(2): hard cost, arm's length`"]
    n84["`s. 85`"]
      n85["`85(1): the elected amount, and the cost of the consideration`"]
      n86["`85(2.1): paid-up capital`"]
    n87["`s. 86`"]
      n88["`86(1): share exchange in a reorganization`"]
      n89["`86(2): benefit to a related person`"]
    n90["`s. 87`"]
      n91["`87(1): amalgamation`"]
      n92["`87(2)(e): cost of capital property`"]
      n93["`87(4): shareholders`"]
    n94["`s. 88`"]
      n95["`88(1): winding up a subsidiary`"]
      n96["`88(1)(c), (d): the bump`"]
    n97["`s. 89`"]
      n98["`89(1): capital dividend account`"]
      n99["`89(1): general rate income pool`"]
    n100["`s. 110.6`"]
      n101["`qualified small business corporation share`"]
      n102["`annual and cumulative gains limits`"]
      n103["`110.6(2.1): the deduction`"]
    n104["`s. 111`"]
      n105["`111(8): net capital loss`"]
      n106["`111(1)(b), (1.1): deduction`"]
    n107["`s. 112`"]
      n108["`112(1): intercorporate dividend deduction`"]
      n109["`112(3), (3.01): the stop-loss on shares`"]
    n110["`ss. 56, 56.1, 60`"]
      n111["`56.1(4): support amount, child support`"]
      n112["`56(1)(b), 60(b): included and deducted`"]
    n113["`s. 62`"]
      n114["`62(1): moving expenses`"]
      n115["`248(1): eligible relocation, the 40 km test`"]
    n116["`s. 63`"]
      n117["`63(1): child care expenses`"]
      n118["`63(2): the higher-income spouse`"]
    n119["`s. 60.03`"]
      n120["`60.03(1): split-pension amount`"]
      n121["`60(c), 56(1)(a.2): deducted and included`"]
    n122["`s. 117`"]
      n123["`117(2): the federal rates`"]
    n124["`s. 117.1`"]
      n125["`117.1(1), (4): indexing by the CPI`"]
      n126["`117.1(3): rounding`"]
    n127["`s. 118`"]
      n128["`118(1.1): basic personal amount`"]
      n129["`118(1)(a): spouse amount`"]
      n130["`118(1)(b): eligible dependant`"]
      n131["`118(1)(b.1), (d), (e): caregiver amounts`"]
      n132["`118(2): age credit`"]
      n133["`118(10): Canada employment credit`"]
      n134["`118(3), (7): pension credit`"]
    n135["`s. 118.2`"]
      n136["`118.2(1): the medical expense credit`"]
    n137["`s. 118.3`"]
      n138["`118.3(1): the disability credit`"]
      n139["`118.3(2): transfer to a supporting person`"]
    n140["`ss. 118.01 to 118.07`"]
      n141["`118.01: adoption`"]
      n142["`118.041: home accessibility`"]
      n143["`118.05: home buyers`"]
      n144["`118.06, 118.07: volunteers`"]
    n145["`s. 118.1`"]
      n146["`118.1(1): total gifts`"]
      n147["`118.1(3): the credit`"]
    n148["`ss. 118.5, 118.61, 118.81, 118.9`"]
      n149["`118.5(1)(a): tuition`"]
      n150["`118.61: carryforward`"]
      n151["`118.81, 118.9: transfer to a parent`"]
    n152["`s. 118.7`"]
      n153["`118.7: CPP and EI credits`"]
    n154["`s. 120.4`"]
      n155["`120.4(1): split income, excluded amounts`"]
      n156["`120.4(2), (3): the tax`"]
    n157["`s. 121`"]
      n158["`121: the dividend tax credit`"]
    n159["`ss. 127.5 to 127.531`"]
      n160["`127.51: the minimum amount`"]
      n161["`127.52(1): adjusted taxable income`"]
      n162["`127.531: the basic minimum tax credit`"]
      n163["`120.2: recovering minimum tax`"]
    n164["`ss. 123 to 125`"]
      n165["`123(1), 124(1): 38%, the abatement`"]
      n166["`123.4(2): general rate reduction`"]
      n167["`125(1): small business deduction`"]
    n168["`ss. 123.3, 129`"]
      n169["`123.3: refundable tax on investment income`"]
      n170["`129(1), (4): the dividend refund`"]
    n171["`s. 185.1`"]
      n172["`185.1(1): Part III.1 tax on excessive designations`"]
      n173["`185.1(2), (3): the election`"]
    n174["`s. 180.2`"]
      n175["`180.2(2): OAS recovery tax`"]
    n176["`s. 186`"]
      n177["`186(1): Part IV tax`"]
      n178["`186(4): connected corporations`"]
      n179["`186(2): control with non-arm's length persons`"]
    n180["`s. 248`"]
      n181["`248(1): majority-interest partner`"]
    n182["`s. 251`"]
      n183["`251(1): arm's length`"]
      n184["`251(2), (3): related persons`"]
      n185["`251(3.1), (3.2): amalgamations`"]
      n186["`251(6): blood, marriage, adoption`"]
    n187["`s. 251.1`"]
      n188["`251.1(1)(a) to (h): affiliated persons`"]
      n189["`251.1(2): amalgamations`"]
      n190["`251.1(3), (4): definitions and rules`"]
    n191["`s. 251.2`"]
      n192["`251.2(2)(a): loss restriction event`"]
    n193["`s. 256`"]
      n194["`256(7)(a): control not acquired`"]
```

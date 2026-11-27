# Dashboard

> Generated from the Lean sources by `scripts/blueprint.sh`. Do not edit by hand.

An overview of the project, drawn from the Lean.

## Statements by status

Every statement in every blueprint, by the status Lean computes for it.

```mermaid
pie showData title All 345 statements in the memos and blueprints, by status
    "encoded" : 62
    "proven" : 226
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
      n9["`15(1): shareholder benefits`"]
      n10["`15(2), (2.6): shareholder loans`"]
    n11["`s. 20`"]
      n12["`20(16): terminal loss`"]
      n13["`20(1)(j): loan repaid`"]
      n14["`20(1)(c): interest`"]
      n15["`20(3): refinancing`"]
    n16["`ss. 38 to 41`"]
      n17["`38: inclusion rates`"]
      n18["`39(1): capital gains and losses`"]
      n19["`39(4): the Canadian securities election`"]
      n20["`40(1): gains and losses, reserves`"]
      n21["`41: listed personal property`"]
    n22["`s. 40`"]
      n23["`40(2)(b): the principal residence exemption`"]
      n24["`40(2)(g): losses that are nil`"]
        n25["`(i) superficial losses`"]
        n26["`(ii) debts`"]
        n27["`(iii) personal-use property`"]
        n28["`(iv) TFSAs, RRSPs and other plans`"]
      n29["`40(2)(e.1): debts within a related group`"]
      n30["`40(3.3) to (3.5): suspended losses`"]
      n31["`40(3.6): shares to an affiliated corporation`"]
      n32["`40(3): negative adjusted cost base`"]
    n33["`s. 43`"]
      n34["`43(1): part of a property`"]
    n35["`s. 44`"]
      n36["`44(1): replacement property`"]
    n37["`s. 45`"]
      n38["`45(1): change in use`"]
      n39["`45(2), (3), (4): the elections`"]
    n40["`s. 47`"]
      n41["`47(1): identical properties, average cost`"]
    n42["`s. 50`"]
      n43["`50(1): bad debts, worthless shares`"]
      n44["`50(2): bad personal-use debts`"]
    n45["`s. 51`"]
      n46["`51(1), (2): convertible property`"]
    n47["`s. 53`"]
      n48["`53(1)(f): cost of substituted property`"]
      n49["`53(1)(f.1), (f.2): cost after 40(2)(e.1), 40(3.6)`"]
    n50["`s. 54`"]
      n51["`superficial loss`"]
      n52["`principal residence`"]
      n53["`personal-use property`"]
      n54["`listed personal property`"]
    n55["`s. 55`"]
      n56["`55(2), (2.1): dividends over safe income`"]
      n57["`55(3): related parties, butterflies`"]
    n58["`s. 69`"]
      n59["`69(1): not at arm's length, gifts`"]
    n60["`s. 70`"]
      n61["`70(5): deemed disposition on death`"]
      n62["`70(6): rollover to a spouse or spousal trust`"]
    n63["`s. 73`"]
      n64["`73(1), (1.01): the spousal rollover`"]
    n65["`ss. 74.1, 74.2, 74.4, 74.5`"]
      n66["`74.1(1), (2): income attributed back`"]
      n67["`74.1(3): repaying debt`"]
      n68["`74.2(1): capital gains attributed back`"]
      n69["`74.4(2): corporate attribution`"]
      n70["`74.5(1) to (3): fair market value, loans for value, separation`"]
    n71["`s. 80.4`"]
      n72["`80.4(2): deemed interest on shareholder loans`"]
    n73["`s. 82`"]
      n74["`82(1): taxable dividends and the gross-up`"]
    n75["`s. 83`"]
      n76["`83(2): capital dividends`"]
    n77["`s. 84`"]
      n78["`84(1): paid-up capital increased`"]
      n79["`84(2): distributions on winding-up`"]
      n80["`84(3): redemptions, the deemed dividend`"]
      n81["`84(4), (4.1): returns of capital`"]
    n82["`s. 84.1`"]
      n83["`84.1(1): paid-up capital, and the deemed dividend`"]
      n84["`84.1(2): hard cost, arm's length`"]
    n85["`s. 85`"]
      n86["`85(1): the elected amount, and the cost of the consideration`"]
      n87["`85(2.1): paid-up capital`"]
    n88["`s. 86`"]
      n89["`86(1): share exchange in a reorganization`"]
      n90["`86(2): benefit to a related person`"]
    n91["`s. 87`"]
      n92["`87(1): amalgamation`"]
      n93["`87(2)(e): cost of capital property`"]
      n94["`87(4): shareholders`"]
    n95["`s. 88`"]
      n96["`88(1): winding up a subsidiary`"]
      n97["`88(1)(c), (d): the bump`"]
    n98["`s. 89`"]
      n99["`89(1): capital dividend account`"]
      n100["`89(1): general rate income pool`"]
    n101["`s. 110.6`"]
      n102["`qualified small business corporation share`"]
      n103["`annual and cumulative gains limits`"]
      n104["`110.6(2.1): the deduction`"]
    n105["`s. 111`"]
      n106["`111(8): net capital loss`"]
      n107["`111(1)(b), (1.1): deduction`"]
    n108["`s. 112`"]
      n109["`112(1): intercorporate dividend deduction`"]
      n110["`112(3), (3.01): the stop-loss on shares`"]
    n111["`ss. 56, 56.1, 60`"]
      n112["`56.1(4): support amount, child support`"]
      n113["`56(1)(b), 60(b): included and deducted`"]
    n114["`s. 62`"]
      n115["`62(1): moving expenses`"]
      n116["`248(1): eligible relocation, the 40 km test`"]
    n117["`s. 63`"]
      n118["`63(1): child care expenses`"]
      n119["`63(2): the higher-income spouse`"]
    n120["`s. 60.03`"]
      n121["`60.03(1): split-pension amount`"]
      n122["`60(c), 56(1)(a.2): deducted and included`"]
    n123["`s. 117`"]
      n124["`117(2): the federal rates`"]
    n125["`s. 117.1`"]
      n126["`117.1(1), (4): indexing by the CPI`"]
      n127["`117.1(3): rounding`"]
    n128["`s. 118`"]
      n129["`118(1.1): basic personal amount`"]
      n130["`118(1)(a): spouse amount`"]
      n131["`118(1)(b): eligible dependant`"]
      n132["`118(1)(b.1), (d), (e): caregiver amounts`"]
      n133["`118(2): age credit`"]
      n134["`118(10): Canada employment credit`"]
      n135["`118(3), (7): pension credit`"]
    n136["`s. 118.2`"]
      n137["`118.2(1): the medical expense credit`"]
    n138["`s. 118.3`"]
      n139["`118.3(1): the disability credit`"]
      n140["`118.3(2): transfer to a supporting person`"]
    n141["`ss. 118.01 to 118.07`"]
      n142["`118.01: adoption`"]
      n143["`118.041: home accessibility`"]
      n144["`118.05: home buyers`"]
      n145["`118.06, 118.07: volunteers`"]
    n146["`s. 118.1`"]
      n147["`118.1(1): total gifts`"]
      n148["`118.1(3): the credit`"]
    n149["`ss. 118.5, 118.61, 118.81, 118.9`"]
      n150["`118.5(1)(a): tuition`"]
      n151["`118.61: carryforward`"]
      n152["`118.81, 118.9: transfer to a parent`"]
    n153["`s. 118.7`"]
      n154["`118.7: CPP and EI credits`"]
    n155["`s. 120.4`"]
      n156["`120.4(1): split income, excluded amounts`"]
      n157["`120.4(2), (3): the tax`"]
    n158["`s. 121`"]
      n159["`121: the dividend tax credit`"]
    n160["`ss. 127.5 to 127.531`"]
      n161["`127.51: the minimum amount`"]
      n162["`127.52(1): adjusted taxable income`"]
      n163["`127.531: the basic minimum tax credit`"]
      n164["`120.2: recovering minimum tax`"]
    n165["`ss. 123 to 125`"]
      n166["`123(1), 124(1): 38%, the abatement`"]
      n167["`123.4(2): general rate reduction`"]
      n168["`125(1): small business deduction`"]
    n169["`ss. 123.3, 129`"]
      n170["`123.3: refundable tax on investment income`"]
      n171["`129(1), (4): the dividend refund`"]
    n172["`s. 185.1`"]
      n173["`185.1(1): Part III.1 tax on excessive designations`"]
      n174["`185.1(2), (3): the election`"]
    n175["`s. 180.2`"]
      n176["`180.2(2): OAS recovery tax`"]
    n177["`s. 186`"]
      n178["`186(1): Part IV tax`"]
      n179["`186(4): connected corporations`"]
      n180["`186(2): control with non-arm's length persons`"]
    n181["`s. 248`"]
      n182["`248(1): majority-interest partner`"]
    n183["`s. 251`"]
      n184["`251(1): arm's length`"]
      n185["`251(2), (3): related persons`"]
      n186["`251(3.1), (3.2): amalgamations`"]
      n187["`251(6): blood, marriage, adoption`"]
    n188["`s. 251.1`"]
      n189["`251.1(1)(a) to (h): affiliated persons`"]
      n190["`251.1(2): amalgamations`"]
      n191["`251.1(3), (4): definitions and rules`"]
    n192["`s. 251.2`"]
      n193["`251.2(2)(a): loss restriction event`"]
    n194["`s. 256`"]
      n195["`256(7)(a): control not acquired`"]
```

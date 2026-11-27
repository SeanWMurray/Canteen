# Dashboard

> Generated from the Lean sources by `scripts/blueprint.sh`. Do not edit by hand.

An overview of the project, drawn from the Lean.

## Statements by status

Every statement in every blueprint, by the status Lean computes for it.

```mermaid
pie showData title All 342 statements in the memos and blueprints, by status
    "encoded" : 62
    "proven" : 223
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
      n78["`84(3): redemptions, the deemed dividend`"]
      n79["`84(4), (4.1): returns of capital`"]
    n80["`s. 84.1`"]
      n81["`84.1(1): paid-up capital, and the deemed dividend`"]
      n82["`84.1(2): hard cost, arm's length`"]
    n83["`s. 85`"]
      n84["`85(1): the elected amount, and the cost of the consideration`"]
      n85["`85(2.1): paid-up capital`"]
    n86["`s. 86`"]
      n87["`86(1): share exchange in a reorganization`"]
      n88["`86(2): benefit to a related person`"]
    n89["`s. 87`"]
      n90["`87(1): amalgamation`"]
      n91["`87(2)(e): cost of capital property`"]
      n92["`87(4): shareholders`"]
    n93["`s. 88`"]
      n94["`88(1): winding up a subsidiary`"]
      n95["`88(1)(c), (d): the bump`"]
    n96["`s. 89`"]
      n97["`89(1): capital dividend account`"]
      n98["`89(1): general rate income pool`"]
    n99["`s. 110.6`"]
      n100["`qualified small business corporation share`"]
      n101["`annual and cumulative gains limits`"]
      n102["`110.6(2.1): the deduction`"]
    n103["`s. 111`"]
      n104["`111(8): net capital loss`"]
      n105["`111(1)(b), (1.1): deduction`"]
    n106["`s. 112`"]
      n107["`112(1): intercorporate dividend deduction`"]
    n108["`ss. 56, 56.1, 60`"]
      n109["`56.1(4): support amount, child support`"]
      n110["`56(1)(b), 60(b): included and deducted`"]
    n111["`s. 62`"]
      n112["`62(1): moving expenses`"]
      n113["`248(1): eligible relocation, the 40 km test`"]
    n114["`s. 63`"]
      n115["`63(1): child care expenses`"]
      n116["`63(2): the higher-income spouse`"]
    n117["`s. 60.03`"]
      n118["`60.03(1): split-pension amount`"]
      n119["`60(c), 56(1)(a.2): deducted and included`"]
    n120["`s. 117`"]
      n121["`117(2): the federal rates`"]
    n122["`s. 117.1`"]
      n123["`117.1(1), (4): indexing by the CPI`"]
      n124["`117.1(3): rounding`"]
    n125["`s. 118`"]
      n126["`118(1.1): basic personal amount`"]
      n127["`118(1)(a): spouse amount`"]
      n128["`118(1)(b): eligible dependant`"]
      n129["`118(1)(b.1), (d), (e): caregiver amounts`"]
      n130["`118(2): age credit`"]
      n131["`118(10): Canada employment credit`"]
      n132["`118(3), (7): pension credit`"]
    n133["`s. 118.2`"]
      n134["`118.2(1): the medical expense credit`"]
    n135["`s. 118.3`"]
      n136["`118.3(1): the disability credit`"]
      n137["`118.3(2): transfer to a supporting person`"]
    n138["`ss. 118.01 to 118.07`"]
      n139["`118.01: adoption`"]
      n140["`118.041: home accessibility`"]
      n141["`118.05: home buyers`"]
      n142["`118.06, 118.07: volunteers`"]
    n143["`s. 118.1`"]
      n144["`118.1(1): total gifts`"]
      n145["`118.1(3): the credit`"]
    n146["`ss. 118.5, 118.61, 118.81, 118.9`"]
      n147["`118.5(1)(a): tuition`"]
      n148["`118.61: carryforward`"]
      n149["`118.81, 118.9: transfer to a parent`"]
    n150["`s. 118.7`"]
      n151["`118.7: CPP and EI credits`"]
    n152["`s. 120.4`"]
      n153["`120.4(1): split income, excluded amounts`"]
      n154["`120.4(2), (3): the tax`"]
    n155["`s. 121`"]
      n156["`121: the dividend tax credit`"]
    n157["`ss. 127.5 to 127.531`"]
      n158["`127.51: the minimum amount`"]
      n159["`127.52(1): adjusted taxable income`"]
      n160["`127.531: the basic minimum tax credit`"]
      n161["`120.2: recovering minimum tax`"]
    n162["`ss. 123 to 125`"]
      n163["`123(1), 124(1): 38%, the abatement`"]
      n164["`123.4(2): general rate reduction`"]
      n165["`125(1): small business deduction`"]
    n166["`ss. 123.3, 129`"]
      n167["`123.3: refundable tax on investment income`"]
      n168["`129(1), (4): the dividend refund`"]
    n169["`s. 185.1`"]
      n170["`185.1(1): Part III.1 tax on excessive designations`"]
      n171["`185.1(2), (3): the election`"]
    n172["`s. 180.2`"]
      n173["`180.2(2): OAS recovery tax`"]
    n174["`s. 186`"]
      n175["`186(1): Part IV tax`"]
      n176["`186(4): connected corporations`"]
      n177["`186(2): control with non-arm's length persons`"]
    n178["`s. 248`"]
      n179["`248(1): majority-interest partner`"]
    n180["`s. 251`"]
      n181["`251(1): arm's length`"]
      n182["`251(2), (3): related persons`"]
      n183["`251(3.1), (3.2): amalgamations`"]
      n184["`251(6): blood, marriage, adoption`"]
    n185["`s. 251.1`"]
      n186["`251.1(1)(a) to (h): affiliated persons`"]
      n187["`251.1(2): amalgamations`"]
      n188["`251.1(3), (4): definitions and rules`"]
    n189["`s. 251.2`"]
      n190["`251.2(2)(a): loss restriction event`"]
    n191["`s. 256`"]
      n192["`256(7)(a): control not acquired`"]
```

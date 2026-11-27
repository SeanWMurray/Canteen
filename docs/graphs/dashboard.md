# Dashboard

> Generated from the Lean sources by `scripts/blueprint.sh`. Do not edit by hand.

An overview of the project, drawn from the Lean.

## Statements by status

Every statement in every blueprint, by the status Lean computes for it.

```mermaid
pie showData title All 347 statements in the memos and blueprints, by status
    "encoded" : 62
    "proven" : 228
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
    n37["`s. 44.1`"]
      n38["`44.1(2): small business investment rollover`"]
    n39["`s. 45`"]
      n40["`45(1): change in use`"]
      n41["`45(2), (3), (4): the elections`"]
    n42["`s. 46`"]
      n43["`46(1), (2): the $1,000 floor`"]
      n44["`46(3): sets`"]
    n45["`s. 47`"]
      n46["`47(1): identical properties, average cost`"]
    n47["`s. 50`"]
      n48["`50(1): bad debts, worthless shares`"]
      n49["`50(2): bad personal-use debts`"]
    n50["`s. 51`"]
      n51["`51(1), (2): convertible property`"]
    n52["`s. 53`"]
      n53["`53(1)(f): cost of substituted property`"]
      n54["`53(1)(f.1), (f.2): cost after 40(2)(e.1), 40(3.6)`"]
    n55["`s. 54`"]
      n56["`superficial loss`"]
      n57["`principal residence`"]
      n58["`personal-use property`"]
      n59["`listed personal property`"]
    n60["`s. 55`"]
      n61["`55(2), (2.1): dividends over safe income`"]
      n62["`55(3): related parties, butterflies`"]
    n63["`s. 69`"]
      n64["`69(1): not at arm's length, gifts`"]
    n65["`s. 70`"]
      n66["`70(5): deemed disposition on death`"]
      n67["`70(6): rollover to a spouse or spousal trust`"]
    n68["`s. 73`"]
      n69["`73(1), (1.01): the spousal rollover`"]
    n70["`ss. 74.1, 74.2, 74.4, 74.5`"]
      n71["`74.1(1), (2): income attributed back`"]
      n72["`74.1(3): repaying debt`"]
      n73["`74.2(1): capital gains attributed back`"]
      n74["`74.4(2): corporate attribution`"]
      n75["`74.5(1) to (3): fair market value, loans for value, separation`"]
    n76["`s. 80.4`"]
      n77["`80.4(2): deemed interest on shareholder loans`"]
    n78["`s. 82`"]
      n79["`82(1): taxable dividends and the gross-up`"]
    n80["`s. 83`"]
      n81["`83(2): capital dividends`"]
    n82["`s. 84`"]
      n83["`84(1): paid-up capital increased`"]
      n84["`84(2): distributions on winding-up`"]
      n85["`84(3): redemptions, the deemed dividend`"]
      n86["`84(4), (4.1): returns of capital`"]
    n87["`s. 84.1`"]
      n88["`84.1(1): paid-up capital, and the deemed dividend`"]
      n89["`84.1(2): hard cost, arm's length`"]
    n90["`s. 85`"]
      n91["`85(1): the elected amount, and the cost of the consideration`"]
      n92["`85(2.1): paid-up capital`"]
    n93["`s. 86`"]
      n94["`86(1): share exchange in a reorganization`"]
      n95["`86(2): benefit to a related person`"]
    n96["`s. 87`"]
      n97["`87(1): amalgamation`"]
      n98["`87(2)(e): cost of capital property`"]
      n99["`87(4): shareholders`"]
    n100["`s. 88`"]
      n101["`88(1): winding up a subsidiary`"]
      n102["`88(1)(c), (d): the bump`"]
    n103["`s. 89`"]
      n104["`89(1): capital dividend account`"]
      n105["`89(1): general rate income pool`"]
    n106["`s. 110.6`"]
      n107["`qualified small business corporation share`"]
      n108["`annual and cumulative gains limits`"]
      n109["`110.6(2.1): the deduction`"]
    n110["`s. 111`"]
      n111["`111(8): net capital loss`"]
      n112["`111(1)(b), (1.1): deduction`"]
    n113["`s. 112`"]
      n114["`112(1): intercorporate dividend deduction`"]
      n115["`112(3), (3.01): the stop-loss on shares`"]
    n116["`ss. 56, 56.1, 60`"]
      n117["`56.1(4): support amount, child support`"]
      n118["`56(1)(b), 60(b): included and deducted`"]
    n119["`s. 62`"]
      n120["`62(1): moving expenses`"]
      n121["`248(1): eligible relocation, the 40 km test`"]
    n122["`s. 63`"]
      n123["`63(1): child care expenses`"]
      n124["`63(2): the higher-income spouse`"]
    n125["`s. 60.03`"]
      n126["`60.03(1): split-pension amount`"]
      n127["`60(c), 56(1)(a.2): deducted and included`"]
    n128["`s. 117`"]
      n129["`117(2): the federal rates`"]
    n130["`s. 117.1`"]
      n131["`117.1(1), (4): indexing by the CPI`"]
      n132["`117.1(3): rounding`"]
    n133["`s. 118`"]
      n134["`118(1.1): basic personal amount`"]
      n135["`118(1)(a): spouse amount`"]
      n136["`118(1)(b): eligible dependant`"]
      n137["`118(1)(b.1), (d), (e): caregiver amounts`"]
      n138["`118(2): age credit`"]
      n139["`118(10): Canada employment credit`"]
      n140["`118(3), (7): pension credit`"]
    n141["`s. 118.2`"]
      n142["`118.2(1): the medical expense credit`"]
    n143["`s. 118.3`"]
      n144["`118.3(1): the disability credit`"]
      n145["`118.3(2): transfer to a supporting person`"]
    n146["`ss. 118.01 to 118.07`"]
      n147["`118.01: adoption`"]
      n148["`118.041: home accessibility`"]
      n149["`118.05: home buyers`"]
      n150["`118.06, 118.07: volunteers`"]
    n151["`s. 118.1`"]
      n152["`118.1(1): total gifts`"]
      n153["`118.1(3): the credit`"]
    n154["`ss. 118.5, 118.61, 118.81, 118.9`"]
      n155["`118.5(1)(a): tuition`"]
      n156["`118.61: carryforward`"]
      n157["`118.81, 118.9: transfer to a parent`"]
    n158["`s. 118.7`"]
      n159["`118.7: CPP and EI credits`"]
    n160["`s. 120.4`"]
      n161["`120.4(1): split income, excluded amounts`"]
      n162["`120.4(2), (3): the tax`"]
    n163["`s. 121`"]
      n164["`121: the dividend tax credit`"]
    n165["`ss. 127.5 to 127.531`"]
      n166["`127.51: the minimum amount`"]
      n167["`127.52(1): adjusted taxable income`"]
      n168["`127.531: the basic minimum tax credit`"]
      n169["`120.2: recovering minimum tax`"]
    n170["`ss. 123 to 125`"]
      n171["`123(1), 124(1): 38%, the abatement`"]
      n172["`123.4(2): general rate reduction`"]
      n173["`125(1): small business deduction`"]
    n174["`ss. 123.3, 129`"]
      n175["`123.3: refundable tax on investment income`"]
      n176["`129(1), (4): the dividend refund`"]
    n177["`s. 185.1`"]
      n178["`185.1(1): Part III.1 tax on excessive designations`"]
      n179["`185.1(2), (3): the election`"]
    n180["`s. 180.2`"]
      n181["`180.2(2): OAS recovery tax`"]
    n182["`s. 186`"]
      n183["`186(1): Part IV tax`"]
      n184["`186(4): connected corporations`"]
      n185["`186(2): control with non-arm's length persons`"]
    n186["`s. 248`"]
      n187["`248(1): majority-interest partner`"]
    n188["`s. 251`"]
      n189["`251(1): arm's length`"]
      n190["`251(2), (3): related persons`"]
      n191["`251(3.1), (3.2): amalgamations`"]
      n192["`251(6): blood, marriage, adoption`"]
    n193["`s. 251.1`"]
      n194["`251.1(1)(a) to (h): affiliated persons`"]
      n195["`251.1(2): amalgamations`"]
      n196["`251.1(3), (4): definitions and rules`"]
    n197["`s. 251.2`"]
      n198["`251.2(2)(a): loss restriction event`"]
    n199["`s. 256`"]
      n200["`256(7)(a): control not acquired`"]
```

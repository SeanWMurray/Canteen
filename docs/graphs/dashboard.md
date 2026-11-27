# Dashboard

> Generated from the Lean sources by `scripts/blueprint.sh`. Do not edit by hand.

An overview of the project, drawn from the Lean.

## Statements by status

Every statement in every blueprint, by the status Lean computes for it.

```mermaid
pie showData title All 348 statements in the memos and blueprints, by status
    "encoded" : 62
    "proven" : 229
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
    n5["`s. 7`"]
      n6["`7(1)(a): the option benefit`"]
      n7["`7(1.1): CCPC deferral`"]
    n8["`s. 13`"]
      n9["`13(21): undepreciated capital cost`"]
      n10["`13(1): recapture`"]
    n11["`s. 15`"]
      n12["`15(1): shareholder benefits`"]
      n13["`15(2), (2.6): shareholder loans`"]
    n14["`s. 20`"]
      n15["`20(16): terminal loss`"]
      n16["`20(1)(j): loan repaid`"]
      n17["`20(1)(c): interest`"]
      n18["`20(3): refinancing`"]
    n19["`ss. 38 to 41`"]
      n20["`38: inclusion rates`"]
      n21["`39(1): capital gains and losses`"]
      n22["`39(4): the Canadian securities election`"]
      n23["`40(1): gains and losses, reserves`"]
      n24["`41: listed personal property`"]
    n25["`s. 40`"]
      n26["`40(2)(b): the principal residence exemption`"]
      n27["`40(2)(g): losses that are nil`"]
        n28["`(i) superficial losses`"]
        n29["`(ii) debts`"]
        n30["`(iii) personal-use property`"]
        n31["`(iv) TFSAs, RRSPs and other plans`"]
      n32["`40(2)(e.1): debts within a related group`"]
      n33["`40(3.3) to (3.5): suspended losses`"]
      n34["`40(3.6): shares to an affiliated corporation`"]
      n35["`40(3): negative adjusted cost base`"]
    n36["`s. 43`"]
      n37["`43(1): part of a property`"]
    n38["`s. 44`"]
      n39["`44(1): replacement property`"]
    n40["`s. 44.1`"]
      n41["`44.1(2): small business investment rollover`"]
    n42["`s. 45`"]
      n43["`45(1): change in use`"]
      n44["`45(2), (3), (4): the elections`"]
    n45["`s. 46`"]
      n46["`46(1), (2): the $1,000 floor`"]
      n47["`46(3): sets`"]
    n48["`s. 47`"]
      n49["`47(1): identical properties, average cost`"]
    n50["`s. 50`"]
      n51["`50(1): bad debts, worthless shares`"]
      n52["`50(2): bad personal-use debts`"]
    n53["`s. 51`"]
      n54["`51(1), (2): convertible property`"]
    n55["`s. 53`"]
      n56["`53(1)(f): cost of substituted property`"]
      n57["`53(1)(f.1), (f.2): cost after 40(2)(e.1), 40(3.6)`"]
    n58["`s. 54`"]
      n59["`superficial loss`"]
      n60["`principal residence`"]
      n61["`personal-use property`"]
      n62["`listed personal property`"]
    n63["`s. 55`"]
      n64["`55(2), (2.1): dividends over safe income`"]
      n65["`55(3): related parties, butterflies`"]
    n66["`s. 69`"]
      n67["`69(1): not at arm's length, gifts`"]
    n68["`s. 70`"]
      n69["`70(5): deemed disposition on death`"]
      n70["`70(6): rollover to a spouse or spousal trust`"]
    n71["`s. 73`"]
      n72["`73(1), (1.01): the spousal rollover`"]
    n73["`ss. 74.1, 74.2, 74.4, 74.5`"]
      n74["`74.1(1), (2): income attributed back`"]
      n75["`74.1(3): repaying debt`"]
      n76["`74.2(1): capital gains attributed back`"]
      n77["`74.4(2): corporate attribution`"]
      n78["`74.5(1) to (3): fair market value, loans for value, separation`"]
    n79["`s. 80.4`"]
      n80["`80.4(2): deemed interest on shareholder loans`"]
    n81["`s. 82`"]
      n82["`82(1): taxable dividends and the gross-up`"]
    n83["`s. 83`"]
      n84["`83(2): capital dividends`"]
    n85["`s. 84`"]
      n86["`84(1): paid-up capital increased`"]
      n87["`84(2): distributions on winding-up`"]
      n88["`84(3): redemptions, the deemed dividend`"]
      n89["`84(4), (4.1): returns of capital`"]
    n90["`s. 84.1`"]
      n91["`84.1(1): paid-up capital, and the deemed dividend`"]
      n92["`84.1(2): hard cost, arm's length`"]
    n93["`s. 85`"]
      n94["`85(1): the elected amount, and the cost of the consideration`"]
      n95["`85(2.1): paid-up capital`"]
    n96["`s. 86`"]
      n97["`86(1): share exchange in a reorganization`"]
      n98["`86(2): benefit to a related person`"]
    n99["`s. 87`"]
      n100["`87(1): amalgamation`"]
      n101["`87(2)(e): cost of capital property`"]
      n102["`87(4): shareholders`"]
    n103["`s. 88`"]
      n104["`88(1): winding up a subsidiary`"]
      n105["`88(1)(c), (d): the bump`"]
    n106["`s. 89`"]
      n107["`89(1): capital dividend account`"]
      n108["`89(1): general rate income pool`"]
    n109["`s. 110.6`"]
      n110["`qualified small business corporation share`"]
      n111["`annual and cumulative gains limits`"]
      n112["`110.6(2.1): the deduction`"]
    n113["`s. 110`"]
      n114["`110(1)(d), (d.1): the option deduction`"]
    n115["`s. 111`"]
      n116["`111(8): net capital loss`"]
      n117["`111(1)(b), (1.1): deduction`"]
    n118["`s. 112`"]
      n119["`112(1): intercorporate dividend deduction`"]
      n120["`112(3), (3.01): the stop-loss on shares`"]
    n121["`ss. 56, 56.1, 60`"]
      n122["`56.1(4): support amount, child support`"]
      n123["`56(1)(b), 60(b): included and deducted`"]
    n124["`s. 62`"]
      n125["`62(1): moving expenses`"]
      n126["`248(1): eligible relocation, the 40 km test`"]
    n127["`s. 63`"]
      n128["`63(1): child care expenses`"]
      n129["`63(2): the higher-income spouse`"]
    n130["`s. 60.03`"]
      n131["`60.03(1): split-pension amount`"]
      n132["`60(c), 56(1)(a.2): deducted and included`"]
    n133["`s. 117`"]
      n134["`117(2): the federal rates`"]
    n135["`s. 117.1`"]
      n136["`117.1(1), (4): indexing by the CPI`"]
      n137["`117.1(3): rounding`"]
    n138["`s. 118`"]
      n139["`118(1.1): basic personal amount`"]
      n140["`118(1)(a): spouse amount`"]
      n141["`118(1)(b): eligible dependant`"]
      n142["`118(1)(b.1), (d), (e): caregiver amounts`"]
      n143["`118(2): age credit`"]
      n144["`118(10): Canada employment credit`"]
      n145["`118(3), (7): pension credit`"]
    n146["`s. 118.2`"]
      n147["`118.2(1): the medical expense credit`"]
    n148["`s. 118.3`"]
      n149["`118.3(1): the disability credit`"]
      n150["`118.3(2): transfer to a supporting person`"]
    n151["`ss. 118.01 to 118.07`"]
      n152["`118.01: adoption`"]
      n153["`118.041: home accessibility`"]
      n154["`118.05: home buyers`"]
      n155["`118.06, 118.07: volunteers`"]
    n156["`s. 118.1`"]
      n157["`118.1(1): total gifts`"]
      n158["`118.1(3): the credit`"]
    n159["`ss. 118.5, 118.61, 118.81, 118.9`"]
      n160["`118.5(1)(a): tuition`"]
      n161["`118.61: carryforward`"]
      n162["`118.81, 118.9: transfer to a parent`"]
    n163["`s. 118.7`"]
      n164["`118.7: CPP and EI credits`"]
    n165["`s. 120.4`"]
      n166["`120.4(1): split income, excluded amounts`"]
      n167["`120.4(2), (3): the tax`"]
    n168["`s. 121`"]
      n169["`121: the dividend tax credit`"]
    n170["`ss. 127.5 to 127.531`"]
      n171["`127.51: the minimum amount`"]
      n172["`127.52(1): adjusted taxable income`"]
      n173["`127.531: the basic minimum tax credit`"]
      n174["`120.2: recovering minimum tax`"]
    n175["`ss. 123 to 125`"]
      n176["`123(1), 124(1): 38%, the abatement`"]
      n177["`123.4(2): general rate reduction`"]
      n178["`125(1): small business deduction`"]
    n179["`ss. 123.3, 129`"]
      n180["`123.3: refundable tax on investment income`"]
      n181["`129(1), (4): the dividend refund`"]
    n182["`s. 185.1`"]
      n183["`185.1(1): Part III.1 tax on excessive designations`"]
      n184["`185.1(2), (3): the election`"]
    n185["`s. 180.2`"]
      n186["`180.2(2): OAS recovery tax`"]
    n187["`s. 186`"]
      n188["`186(1): Part IV tax`"]
      n189["`186(4): connected corporations`"]
      n190["`186(2): control with non-arm's length persons`"]
    n191["`s. 248`"]
      n192["`248(1): majority-interest partner`"]
    n193["`s. 251`"]
      n194["`251(1): arm's length`"]
      n195["`251(2), (3): related persons`"]
      n196["`251(3.1), (3.2): amalgamations`"]
      n197["`251(6): blood, marriage, adoption`"]
    n198["`s. 251.1`"]
      n199["`251.1(1)(a) to (h): affiliated persons`"]
      n200["`251.1(2): amalgamations`"]
      n201["`251.1(3), (4): definitions and rules`"]
    n202["`s. 251.2`"]
      n203["`251.2(2)(a): loss restriction event`"]
    n204["`s. 256`"]
      n205["`256(7)(a): control not acquired`"]
```

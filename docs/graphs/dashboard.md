# Dashboard

> Generated from the Lean sources by `scripts/blueprint.sh`. Do not edit by hand.

An overview of the project, drawn from the Lean.

## Statements by status

Every statement in every blueprint, by the status Lean computes for it.

```mermaid
pie showData title All 356 statements in the memos and blueprints, by status
    "encoded" : 62
    "proven" : 237
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
      n3["`a corporation's year`"]
    n4["`s. 6`"]
      n5["`6(1)(e), 6(2): automobile standby charge`"]
    n6["`s. 7`"]
      n7["`7(1)(a): the option benefit`"]
      n8["`7(1.1): CCPC deferral`"]
    n9["`s. 13`"]
      n10["`13(21): undepreciated capital cost`"]
      n11["`13(1): recapture`"]
    n12["`s. 15`"]
      n13["`15(1): shareholder benefits`"]
      n14["`15(2), (2.6): shareholder loans`"]
    n15["`ss. 8, 18`"]
      n16["`18(12), 8(13): work space in the home`"]
    n17["`s. 20`"]
      n18["`20(16): terminal loss`"]
      n19["`20(1)(j): loan repaid`"]
      n20["`20(1)(c): interest`"]
      n21["`20(1)(e), (e.1): financing expenses`"]
      n22["`20(3): refinancing`"]
    n23["`ss. 38 to 41`"]
      n24["`38: inclusion rates`"]
      n25["`39(1): capital gains and losses`"]
      n26["`39(4): the Canadian securities election`"]
      n27["`40(1): gains and losses, reserves`"]
      n28["`41: listed personal property`"]
    n29["`s. 40`"]
      n30["`40(2)(b): the principal residence exemption`"]
      n31["`40(2)(g): losses that are nil`"]
        n32["`(i) superficial losses`"]
        n33["`(ii) debts`"]
        n34["`(iii) personal-use property`"]
        n35["`(iv) TFSAs, RRSPs and other plans`"]
      n36["`40(2)(e.1): debts within a related group`"]
      n37["`40(3.3) to (3.5): suspended losses`"]
      n38["`40(3.6): shares to an affiliated corporation`"]
      n39["`40(3): negative adjusted cost base`"]
    n40["`s. 43`"]
      n41["`43(1): part of a property`"]
    n42["`s. 44`"]
      n43["`44(1): replacement property`"]
    n44["`s. 44.1`"]
      n45["`44.1(2): small business investment rollover`"]
    n46["`s. 45`"]
      n47["`45(1): change in use`"]
      n48["`45(2), (3), (4): the elections`"]
    n49["`s. 46`"]
      n50["`46(1), (2): the $1,000 floor`"]
      n51["`46(3): sets`"]
    n52["`s. 47`"]
      n53["`47(1): identical properties, average cost`"]
    n54["`s. 50`"]
      n55["`50(1): bad debts, worthless shares`"]
      n56["`50(2): bad personal-use debts`"]
    n57["`s. 51`"]
      n58["`51(1), (2): convertible property`"]
    n59["`s. 53`"]
      n60["`53(1)(f): cost of substituted property`"]
      n61["`53(1)(f.1), (f.2): cost after 40(2)(e.1), 40(3.6)`"]
    n62["`s. 54`"]
      n63["`superficial loss`"]
      n64["`principal residence`"]
      n65["`personal-use property`"]
      n66["`listed personal property`"]
    n67["`s. 55`"]
      n68["`55(2), (2.1): dividends over safe income`"]
      n69["`55(3): related parties, butterflies`"]
    n70["`s. 67.1`"]
      n71["`67.1(1): 50% of food and entertainment`"]
      n72["`67.1(2): the exceptions`"]
      n73["`67.1(3): conference fees`"]
    n74["`s. 69`"]
      n75["`69(1): not at arm's length, gifts`"]
    n76["`s. 70`"]
      n77["`70(5): deemed disposition on death`"]
      n78["`70(6): rollover to a spouse or spousal trust`"]
    n79["`s. 73`"]
      n80["`73(1), (1.01): the spousal rollover`"]
    n81["`ss. 74.1, 74.2, 74.4, 74.5`"]
      n82["`74.1(1), (2): income attributed back`"]
      n83["`74.1(3): repaying debt`"]
      n84["`74.2(1): capital gains attributed back`"]
      n85["`74.4(2): corporate attribution`"]
      n86["`74.5(1) to (3): fair market value, loans for value, separation`"]
    n87["`s. 80.4`"]
      n88["`80.4(2): deemed interest on shareholder loans`"]
    n89["`s. 82`"]
      n90["`82(1): taxable dividends and the gross-up`"]
    n91["`s. 83`"]
      n92["`83(2): capital dividends`"]
    n93["`s. 84`"]
      n94["`84(1): paid-up capital increased`"]
      n95["`84(2): distributions on winding-up`"]
      n96["`84(3): redemptions, the deemed dividend`"]
      n97["`84(4), (4.1): returns of capital`"]
    n98["`s. 84.1`"]
      n99["`84.1(1): paid-up capital, and the deemed dividend`"]
      n100["`84.1(2): hard cost, arm's length`"]
    n101["`s. 85`"]
      n102["`85(1): the elected amount, and the cost of the consideration`"]
      n103["`85(2.1): paid-up capital`"]
    n104["`s. 86`"]
      n105["`86(1): share exchange in a reorganization`"]
      n106["`86(2): benefit to a related person`"]
    n107["`s. 87`"]
      n108["`87(1): amalgamation`"]
      n109["`87(2)(e): cost of capital property`"]
      n110["`87(4): shareholders`"]
    n111["`s. 88`"]
      n112["`88(1): winding up a subsidiary`"]
      n113["`88(1)(c), (d): the bump`"]
    n114["`s. 89`"]
      n115["`89(1): capital dividend account`"]
      n116["`89(1): general rate income pool`"]
    n117["`s. 125`"]
      n118["`125(2), (3): the business limit, shared`"]
      n119["`125(5.1): the capital and passive income grinds`"]
      n120["`125(7): adjusted aggregate investment income`"]
    n121["`s. 110.1`"]
      n122["`110.1(1)(a): a corporation's gifts`"]
    n123["`s. 110.6`"]
      n124["`qualified small business corporation share`"]
      n125["`annual and cumulative gains limits`"]
      n126["`110.6(2.1): the deduction`"]
    n127["`s. 110`"]
      n128["`110(1)(d), (d.1): the option deduction`"]
    n129["`s. 111`"]
      n130["`111(8): net capital loss`"]
      n131["`111(1)(b), (1.1): deduction`"]
      n132["`111(8): non-capital loss`"]
      n133["`111(1)(a), (3): its deduction, oldest first`"]
    n134["`s. 112`"]
      n135["`112(1): intercorporate dividend deduction`"]
      n136["`112(3), (3.01): the stop-loss on shares`"]
    n137["`ss. 56, 56.1, 60`"]
      n138["`56.1(4): support amount, child support`"]
      n139["`56(1)(b), 60(b): included and deducted`"]
    n140["`s. 62`"]
      n141["`62(1): moving expenses`"]
      n142["`248(1): eligible relocation, the 40 km test`"]
    n143["`s. 63`"]
      n144["`63(1): child care expenses`"]
      n145["`63(2): the higher-income spouse`"]
    n146["`s. 60.03`"]
      n147["`60.03(1): split-pension amount`"]
      n148["`60(c), 56(1)(a.2): deducted and included`"]
    n149["`s. 256`"]
      n150["`256(1): associated corporations, (a) to (e)`"]
      n151["`256(1.2)(b)(i): a member's control is the group's`"]
      n152["`256(5.1): de facto control`"]
      n153["`256(2): through a third corporation`"]
    n154["`s. 117`"]
      n155["`117(2): the federal rates`"]
    n156["`s. 117.1`"]
      n157["`117.1(1), (4): indexing by the CPI`"]
      n158["`117.1(3): rounding`"]
    n159["`s. 118`"]
      n160["`118(1.1): basic personal amount`"]
      n161["`118(1)(a): spouse amount`"]
      n162["`118(1)(b): eligible dependant`"]
      n163["`118(1)(b.1), (d), (e): caregiver amounts`"]
      n164["`118(2): age credit`"]
      n165["`118(10): Canada employment credit`"]
      n166["`118(3), (7): pension credit`"]
    n167["`s. 118.2`"]
      n168["`118.2(1): the medical expense credit`"]
    n169["`s. 118.3`"]
      n170["`118.3(1): the disability credit`"]
      n171["`118.3(2): transfer to a supporting person`"]
    n172["`ss. 118.01 to 118.07`"]
      n173["`118.01: adoption`"]
      n174["`118.041: home accessibility`"]
      n175["`118.05: home buyers`"]
      n176["`118.06, 118.07: volunteers`"]
    n177["`s. 118.1`"]
      n178["`118.1(1): total gifts`"]
      n179["`118.1(3): the credit`"]
    n180["`ss. 118.5, 118.61, 118.81, 118.9`"]
      n181["`118.5(1)(a): tuition`"]
      n182["`118.61: carryforward`"]
      n183["`118.81, 118.9: transfer to a parent`"]
    n184["`s. 118.7`"]
      n185["`118.7: CPP and EI credits`"]
    n186["`s. 120.4`"]
      n187["`120.4(1): split income, excluded amounts`"]
      n188["`120.4(2), (3): the tax`"]
    n189["`s. 121`"]
      n190["`121: the dividend tax credit`"]
    n191["`ss. 127.5 to 127.531`"]
      n192["`127.51: the minimum amount`"]
      n193["`127.52(1): adjusted taxable income`"]
      n194["`127.531: the basic minimum tax credit`"]
      n195["`120.2: recovering minimum tax`"]
    n196["`ss. 123 to 125`"]
      n197["`123(1), 124(1): 38%, the abatement`"]
      n198["`123.4(2): general rate reduction`"]
      n199["`125(1): small business deduction`"]
    n200["`ss. 123.3, 129`"]
      n201["`123.3: refundable tax on investment income`"]
      n202["`129(1), (4): the dividend refund`"]
    n203["`s. 185.1`"]
      n204["`185.1(1): Part III.1 tax on excessive designations`"]
      n205["`185.1(2), (3): the election`"]
    n206["`s. 180.2`"]
      n207["`180.2(2): OAS recovery tax`"]
    n208["`s. 186`"]
      n209["`186(1): Part IV tax`"]
      n210["`186(4): connected corporations`"]
      n211["`186(2): control with non-arm's length persons`"]
    n212["`s. 248`"]
      n213["`248(1): majority-interest partner`"]
    n214["`s. 251`"]
      n215["`251(1): arm's length`"]
      n216["`251(2), (3): related persons`"]
      n217["`251(3.1), (3.2): amalgamations`"]
      n218["`251(6): blood, marriage, adoption`"]
    n219["`s. 251.1`"]
      n220["`251.1(1)(a) to (h): affiliated persons`"]
      n221["`251.1(2): amalgamations`"]
      n222["`251.1(3), (4): definitions and rules`"]
    n223["`s. 251.2`"]
      n224["`251.2(2)(a): loss restriction event`"]
    n225["`s. 256`"]
      n226["`256(7)(a): control not acquired`"]
```

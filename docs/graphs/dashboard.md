# Dashboard

> Generated from the Lean sources by `scripts/blueprint.sh`. Do not edit by hand.

An overview of the project, drawn from the Lean.

## Statements by status

Every statement in every blueprint, by the status Lean computes for it.

```mermaid
pie showData title All 357 statements in the memos and blueprints, by status
    "encoded" : 62
    "proven" : 238
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
      n22["`20(1)(l), (p), 12(1)(d), (i): doubtful and bad debts`"]
      n23["`20(3): refinancing`"]
    n24["`ss. 38 to 41`"]
      n25["`38: inclusion rates`"]
      n26["`39(1): capital gains and losses`"]
      n27["`39(4): the Canadian securities election`"]
      n28["`40(1): gains and losses, reserves`"]
      n29["`41: listed personal property`"]
    n30["`s. 40`"]
      n31["`40(2)(b): the principal residence exemption`"]
      n32["`40(2)(g): losses that are nil`"]
        n33["`(i) superficial losses`"]
        n34["`(ii) debts`"]
        n35["`(iii) personal-use property`"]
        n36["`(iv) TFSAs, RRSPs and other plans`"]
      n37["`40(2)(e.1): debts within a related group`"]
      n38["`40(3.3) to (3.5): suspended losses`"]
      n39["`40(3.6): shares to an affiliated corporation`"]
      n40["`40(3): negative adjusted cost base`"]
    n41["`s. 43`"]
      n42["`43(1): part of a property`"]
    n43["`s. 44`"]
      n44["`44(1): replacement property`"]
    n45["`s. 44.1`"]
      n46["`44.1(2): small business investment rollover`"]
    n47["`s. 45`"]
      n48["`45(1): change in use`"]
      n49["`45(2), (3), (4): the elections`"]
    n50["`s. 46`"]
      n51["`46(1), (2): the $1,000 floor`"]
      n52["`46(3): sets`"]
    n53["`s. 47`"]
      n54["`47(1): identical properties, average cost`"]
    n55["`s. 50`"]
      n56["`50(1): bad debts, worthless shares`"]
      n57["`50(2): bad personal-use debts`"]
    n58["`s. 51`"]
      n59["`51(1), (2): convertible property`"]
    n60["`s. 53`"]
      n61["`53(1)(f): cost of substituted property`"]
      n62["`53(1)(f.1), (f.2): cost after 40(2)(e.1), 40(3.6)`"]
    n63["`s. 54`"]
      n64["`superficial loss`"]
      n65["`principal residence`"]
      n66["`personal-use property`"]
      n67["`listed personal property`"]
    n68["`s. 55`"]
      n69["`55(2), (2.1): dividends over safe income`"]
      n70["`55(3): related parties, butterflies`"]
    n71["`s. 67.1`"]
      n72["`67.1(1): 50% of food and entertainment`"]
      n73["`67.1(2): the exceptions`"]
      n74["`67.1(3): conference fees`"]
    n75["`s. 69`"]
      n76["`69(1): not at arm's length, gifts`"]
    n77["`s. 70`"]
      n78["`70(5): deemed disposition on death`"]
      n79["`70(6): rollover to a spouse or spousal trust`"]
    n80["`s. 73`"]
      n81["`73(1), (1.01): the spousal rollover`"]
    n82["`ss. 74.1, 74.2, 74.4, 74.5`"]
      n83["`74.1(1), (2): income attributed back`"]
      n84["`74.1(3): repaying debt`"]
      n85["`74.2(1): capital gains attributed back`"]
      n86["`74.4(2): corporate attribution`"]
      n87["`74.5(1) to (3): fair market value, loans for value, separation`"]
    n88["`s. 80.4`"]
      n89["`80.4(2): deemed interest on shareholder loans`"]
    n90["`s. 82`"]
      n91["`82(1): taxable dividends and the gross-up`"]
    n92["`s. 83`"]
      n93["`83(2): capital dividends`"]
    n94["`s. 84`"]
      n95["`84(1): paid-up capital increased`"]
      n96["`84(2): distributions on winding-up`"]
      n97["`84(3): redemptions, the deemed dividend`"]
      n98["`84(4), (4.1): returns of capital`"]
    n99["`s. 84.1`"]
      n100["`84.1(1): paid-up capital, and the deemed dividend`"]
      n101["`84.1(2): hard cost, arm's length`"]
    n102["`s. 85`"]
      n103["`85(1): the elected amount, and the cost of the consideration`"]
      n104["`85(2.1): paid-up capital`"]
    n105["`s. 86`"]
      n106["`86(1): share exchange in a reorganization`"]
      n107["`86(2): benefit to a related person`"]
    n108["`s. 87`"]
      n109["`87(1): amalgamation`"]
      n110["`87(2)(e): cost of capital property`"]
      n111["`87(4): shareholders`"]
    n112["`s. 88`"]
      n113["`88(1): winding up a subsidiary`"]
      n114["`88(1)(c), (d): the bump`"]
    n115["`s. 89`"]
      n116["`89(1): capital dividend account`"]
      n117["`89(1): general rate income pool`"]
    n118["`s. 125`"]
      n119["`125(2), (3): the business limit, shared`"]
      n120["`125(5.1): the capital and passive income grinds`"]
      n121["`125(7): adjusted aggregate investment income`"]
    n122["`s. 110.1`"]
      n123["`110.1(1)(a): a corporation's gifts`"]
    n124["`s. 110.6`"]
      n125["`qualified small business corporation share`"]
      n126["`annual and cumulative gains limits`"]
      n127["`110.6(2.1): the deduction`"]
    n128["`s. 110`"]
      n129["`110(1)(d), (d.1): the option deduction`"]
    n130["`s. 111`"]
      n131["`111(8): net capital loss`"]
      n132["`111(1)(b), (1.1): deduction`"]
      n133["`111(8): non-capital loss`"]
      n134["`111(1)(a), (3): its deduction, oldest first`"]
    n135["`s. 112`"]
      n136["`112(1): intercorporate dividend deduction`"]
      n137["`112(3), (3.01): the stop-loss on shares`"]
    n138["`ss. 56, 56.1, 60`"]
      n139["`56.1(4): support amount, child support`"]
      n140["`56(1)(b), 60(b): included and deducted`"]
    n141["`s. 62`"]
      n142["`62(1): moving expenses`"]
      n143["`248(1): eligible relocation, the 40 km test`"]
    n144["`s. 63`"]
      n145["`63(1): child care expenses`"]
      n146["`63(2): the higher-income spouse`"]
    n147["`s. 60.03`"]
      n148["`60.03(1): split-pension amount`"]
      n149["`60(c), 56(1)(a.2): deducted and included`"]
    n150["`s. 256`"]
      n151["`256(1): associated corporations, (a) to (e)`"]
      n152["`256(1.2)(b)(i): a member's control is the group's`"]
      n153["`256(5.1): de facto control`"]
      n154["`256(2): through a third corporation`"]
    n155["`s. 117`"]
      n156["`117(2): the federal rates`"]
    n157["`s. 117.1`"]
      n158["`117.1(1), (4): indexing by the CPI`"]
      n159["`117.1(3): rounding`"]
    n160["`s. 118`"]
      n161["`118(1.1): basic personal amount`"]
      n162["`118(1)(a): spouse amount`"]
      n163["`118(1)(b): eligible dependant`"]
      n164["`118(1)(b.1), (d), (e): caregiver amounts`"]
      n165["`118(2): age credit`"]
      n166["`118(10): Canada employment credit`"]
      n167["`118(3), (7): pension credit`"]
    n168["`s. 118.2`"]
      n169["`118.2(1): the medical expense credit`"]
    n170["`s. 118.3`"]
      n171["`118.3(1): the disability credit`"]
      n172["`118.3(2): transfer to a supporting person`"]
    n173["`ss. 118.01 to 118.07`"]
      n174["`118.01: adoption`"]
      n175["`118.041: home accessibility`"]
      n176["`118.05: home buyers`"]
      n177["`118.06, 118.07: volunteers`"]
    n178["`s. 118.1`"]
      n179["`118.1(1): total gifts`"]
      n180["`118.1(3): the credit`"]
    n181["`ss. 118.5, 118.61, 118.81, 118.9`"]
      n182["`118.5(1)(a): tuition`"]
      n183["`118.61: carryforward`"]
      n184["`118.81, 118.9: transfer to a parent`"]
    n185["`s. 118.7`"]
      n186["`118.7: CPP and EI credits`"]
    n187["`s. 120.4`"]
      n188["`120.4(1): split income, excluded amounts`"]
      n189["`120.4(2), (3): the tax`"]
    n190["`s. 121`"]
      n191["`121: the dividend tax credit`"]
    n192["`ss. 127.5 to 127.531`"]
      n193["`127.51: the minimum amount`"]
      n194["`127.52(1): adjusted taxable income`"]
      n195["`127.531: the basic minimum tax credit`"]
      n196["`120.2: recovering minimum tax`"]
    n197["`ss. 123 to 125`"]
      n198["`123(1), 124(1): 38%, the abatement`"]
      n199["`123.4(2): general rate reduction`"]
      n200["`125(1): small business deduction`"]
    n201["`ss. 123.3, 129`"]
      n202["`123.3: refundable tax on investment income`"]
      n203["`129(1), (4): the dividend refund`"]
    n204["`s. 185.1`"]
      n205["`185.1(1): Part III.1 tax on excessive designations`"]
      n206["`185.1(2), (3): the election`"]
    n207["`s. 180.2`"]
      n208["`180.2(2): OAS recovery tax`"]
    n209["`s. 186`"]
      n210["`186(1): Part IV tax`"]
      n211["`186(4): connected corporations`"]
      n212["`186(2): control with non-arm's length persons`"]
    n213["`s. 248`"]
      n214["`248(1): majority-interest partner`"]
    n215["`s. 251`"]
      n216["`251(1): arm's length`"]
      n217["`251(2), (3): related persons`"]
      n218["`251(3.1), (3.2): amalgamations`"]
      n219["`251(6): blood, marriage, adoption`"]
    n220["`s. 251.1`"]
      n221["`251.1(1)(a) to (h): affiliated persons`"]
      n222["`251.1(2): amalgamations`"]
      n223["`251.1(3), (4): definitions and rules`"]
    n224["`s. 251.2`"]
      n225["`251.2(2)(a): loss restriction event`"]
    n226["`s. 256`"]
      n227["`256(7)(a): control not acquired`"]
```

# Dashboard

> Generated from the Lean sources by `scripts/blueprint.sh`. Do not edit by hand.

An overview of the project, drawn from the Lean.

## Statements by status

Every statement in every blueprint, by the status Lean computes for it.

```mermaid
pie showData title All 359 statements in the memos and blueprints, by status
    "encoded" : 62
    "proven" : 240
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
      n23["`12(1)(a), 20(1)(m): amounts received in advance`"]
      n24["`20(1)(n), 20(8): unpaid amounts on property sold`"]
      n25["`20(3): refinancing`"]
    n26["`ss. 38 to 41`"]
      n27["`38: inclusion rates`"]
      n28["`39(1): capital gains and losses`"]
      n29["`39(4): the Canadian securities election`"]
      n30["`40(1): gains and losses, reserves`"]
      n31["`41: listed personal property`"]
    n32["`s. 40`"]
      n33["`40(2)(b): the principal residence exemption`"]
      n34["`40(2)(g): losses that are nil`"]
        n35["`(i) superficial losses`"]
        n36["`(ii) debts`"]
        n37["`(iii) personal-use property`"]
        n38["`(iv) TFSAs, RRSPs and other plans`"]
      n39["`40(2)(e.1): debts within a related group`"]
      n40["`40(3.3) to (3.5): suspended losses`"]
      n41["`40(3.6): shares to an affiliated corporation`"]
      n42["`40(3): negative adjusted cost base`"]
    n43["`s. 43`"]
      n44["`43(1): part of a property`"]
    n45["`s. 44`"]
      n46["`44(1): replacement property`"]
    n47["`s. 44.1`"]
      n48["`44.1(2): small business investment rollover`"]
    n49["`s. 45`"]
      n50["`45(1): change in use`"]
      n51["`45(2), (3), (4): the elections`"]
    n52["`s. 46`"]
      n53["`46(1), (2): the $1,000 floor`"]
      n54["`46(3): sets`"]
    n55["`s. 47`"]
      n56["`47(1): identical properties, average cost`"]
    n57["`s. 50`"]
      n58["`50(1): bad debts, worthless shares`"]
      n59["`50(2): bad personal-use debts`"]
    n60["`s. 51`"]
      n61["`51(1), (2): convertible property`"]
    n62["`s. 53`"]
      n63["`53(1)(f): cost of substituted property`"]
      n64["`53(1)(f.1), (f.2): cost after 40(2)(e.1), 40(3.6)`"]
    n65["`s. 54`"]
      n66["`superficial loss`"]
      n67["`principal residence`"]
      n68["`personal-use property`"]
      n69["`listed personal property`"]
    n70["`s. 55`"]
      n71["`55(2), (2.1): dividends over safe income`"]
      n72["`55(3): related parties, butterflies`"]
    n73["`s. 67.1`"]
      n74["`67.1(1): 50% of food and entertainment`"]
      n75["`67.1(2): the exceptions`"]
      n76["`67.1(3): conference fees`"]
    n77["`s. 69`"]
      n78["`69(1): not at arm's length, gifts`"]
    n79["`s. 70`"]
      n80["`70(5): deemed disposition on death`"]
      n81["`70(6): rollover to a spouse or spousal trust`"]
    n82["`s. 73`"]
      n83["`73(1), (1.01): the spousal rollover`"]
    n84["`ss. 74.1, 74.2, 74.4, 74.5`"]
      n85["`74.1(1), (2): income attributed back`"]
      n86["`74.1(3): repaying debt`"]
      n87["`74.2(1): capital gains attributed back`"]
      n88["`74.4(2): corporate attribution`"]
      n89["`74.5(1) to (3): fair market value, loans for value, separation`"]
    n90["`s. 80.4`"]
      n91["`80.4(2): deemed interest on shareholder loans`"]
    n92["`s. 82`"]
      n93["`82(1): taxable dividends and the gross-up`"]
    n94["`s. 83`"]
      n95["`83(2): capital dividends`"]
    n96["`s. 84`"]
      n97["`84(1): paid-up capital increased`"]
      n98["`84(2): distributions on winding-up`"]
      n99["`84(3): redemptions, the deemed dividend`"]
      n100["`84(4), (4.1): returns of capital`"]
    n101["`s. 84.1`"]
      n102["`84.1(1): paid-up capital, and the deemed dividend`"]
      n103["`84.1(2): hard cost, arm's length`"]
    n104["`s. 85`"]
      n105["`85(1): the elected amount, and the cost of the consideration`"]
      n106["`85(2.1): paid-up capital`"]
    n107["`s. 86`"]
      n108["`86(1): share exchange in a reorganization`"]
      n109["`86(2): benefit to a related person`"]
    n110["`s. 87`"]
      n111["`87(1): amalgamation`"]
      n112["`87(2)(e): cost of capital property`"]
      n113["`87(4): shareholders`"]
    n114["`s. 88`"]
      n115["`88(1): winding up a subsidiary`"]
      n116["`88(1)(c), (d): the bump`"]
    n117["`s. 89`"]
      n118["`89(1): capital dividend account`"]
      n119["`89(1): general rate income pool`"]
    n120["`s. 125`"]
      n121["`125(2), (3): the business limit, shared`"]
      n122["`125(5.1): the capital and passive income grinds`"]
      n123["`125(7): adjusted aggregate investment income`"]
    n124["`s. 110.1`"]
      n125["`110.1(1)(a): a corporation's gifts`"]
    n126["`s. 110.6`"]
      n127["`qualified small business corporation share`"]
      n128["`annual and cumulative gains limits`"]
      n129["`110.6(2.1): the deduction`"]
    n130["`s. 110`"]
      n131["`110(1)(d), (d.1): the option deduction`"]
    n132["`s. 111`"]
      n133["`111(8): net capital loss`"]
      n134["`111(1)(b), (1.1): deduction`"]
      n135["`111(8): non-capital loss`"]
      n136["`111(1)(a), (3): its deduction, oldest first`"]
    n137["`s. 112`"]
      n138["`112(1): intercorporate dividend deduction`"]
      n139["`112(3), (3.01): the stop-loss on shares`"]
    n140["`ss. 56, 56.1, 60`"]
      n141["`56.1(4): support amount, child support`"]
      n142["`56(1)(b), 60(b): included and deducted`"]
    n143["`s. 62`"]
      n144["`62(1): moving expenses`"]
      n145["`248(1): eligible relocation, the 40 km test`"]
    n146["`s. 63`"]
      n147["`63(1): child care expenses`"]
      n148["`63(2): the higher-income spouse`"]
    n149["`s. 60.03`"]
      n150["`60.03(1): split-pension amount`"]
      n151["`60(c), 56(1)(a.2): deducted and included`"]
    n152["`s. 256`"]
      n153["`256(1): associated corporations, (a) to (e)`"]
      n154["`256(1.2)(b)(i): a member's control is the group's`"]
      n155["`256(5.1): de facto control`"]
      n156["`256(2): through a third corporation`"]
    n157["`s. 117`"]
      n158["`117(2): the federal rates`"]
    n159["`s. 117.1`"]
      n160["`117.1(1), (4): indexing by the CPI`"]
      n161["`117.1(3): rounding`"]
    n162["`s. 118`"]
      n163["`118(1.1): basic personal amount`"]
      n164["`118(1)(a): spouse amount`"]
      n165["`118(1)(b): eligible dependant`"]
      n166["`118(1)(b.1), (d), (e): caregiver amounts`"]
      n167["`118(2): age credit`"]
      n168["`118(10): Canada employment credit`"]
      n169["`118(3), (7): pension credit`"]
    n170["`s. 118.2`"]
      n171["`118.2(1): the medical expense credit`"]
    n172["`s. 118.3`"]
      n173["`118.3(1): the disability credit`"]
      n174["`118.3(2): transfer to a supporting person`"]
    n175["`ss. 118.01 to 118.07`"]
      n176["`118.01: adoption`"]
      n177["`118.041: home accessibility`"]
      n178["`118.05: home buyers`"]
      n179["`118.06, 118.07: volunteers`"]
    n180["`s. 118.1`"]
      n181["`118.1(1): total gifts`"]
      n182["`118.1(3): the credit`"]
    n183["`ss. 118.5, 118.61, 118.81, 118.9`"]
      n184["`118.5(1)(a): tuition`"]
      n185["`118.61: carryforward`"]
      n186["`118.81, 118.9: transfer to a parent`"]
    n187["`s. 118.7`"]
      n188["`118.7: CPP and EI credits`"]
    n189["`s. 120.4`"]
      n190["`120.4(1): split income, excluded amounts`"]
      n191["`120.4(2), (3): the tax`"]
    n192["`s. 121`"]
      n193["`121: the dividend tax credit`"]
    n194["`ss. 127.5 to 127.531`"]
      n195["`127.51: the minimum amount`"]
      n196["`127.52(1): adjusted taxable income`"]
      n197["`127.531: the basic minimum tax credit`"]
      n198["`120.2: recovering minimum tax`"]
    n199["`ss. 123 to 125`"]
      n200["`123(1), 124(1): 38%, the abatement`"]
      n201["`123.4(2): general rate reduction`"]
      n202["`125(1): small business deduction`"]
    n203["`ss. 123.3, 129`"]
      n204["`123.3: refundable tax on investment income`"]
      n205["`129(1), (4): the dividend refund`"]
    n206["`s. 185.1`"]
      n207["`185.1(1): Part III.1 tax on excessive designations`"]
      n208["`185.1(2), (3): the election`"]
    n209["`s. 180.2`"]
      n210["`180.2(2): OAS recovery tax`"]
    n211["`s. 186`"]
      n212["`186(1): Part IV tax`"]
      n213["`186(4): connected corporations`"]
      n214["`186(2): control with non-arm's length persons`"]
    n215["`s. 248`"]
      n216["`248(1): majority-interest partner`"]
    n217["`s. 251`"]
      n218["`251(1): arm's length`"]
      n219["`251(2), (3): related persons`"]
      n220["`251(3.1), (3.2): amalgamations`"]
      n221["`251(6): blood, marriage, adoption`"]
    n222["`s. 251.1`"]
      n223["`251.1(1)(a) to (h): affiliated persons`"]
      n224["`251.1(2): amalgamations`"]
      n225["`251.1(3), (4): definitions and rules`"]
    n226["`s. 251.2`"]
      n227["`251.2(2)(a): loss restriction event`"]
    n228["`s. 256`"]
      n229["`256(7)(a): control not acquired`"]
```

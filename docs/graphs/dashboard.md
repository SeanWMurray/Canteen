# Dashboard

> Generated from the Lean sources by `scripts/blueprint.sh`. Do not edit by hand.

An overview of the project, drawn from the Lean.

## Statements by status

Every statement in every blueprint, by the status Lean computes for it.

```mermaid
pie showData title All 360 statements in the memos and blueprints, by status
    "encoded" : 62
    "proven" : 241
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
      n17["`18(9): prepaid expenses`"]
    n18["`s. 20`"]
      n19["`20(16): terminal loss`"]
      n20["`20(1)(j): loan repaid`"]
      n21["`20(1)(c): interest`"]
      n22["`20(1)(e), (e.1): financing expenses`"]
      n23["`20(1)(l), (p), 12(1)(d), (i): doubtful and bad debts`"]
      n24["`12(1)(a), 20(1)(m): amounts received in advance`"]
      n25["`20(1)(n), 20(8): unpaid amounts on property sold`"]
      n26["`20(3): refinancing`"]
    n27["`ss. 38 to 41`"]
      n28["`38: inclusion rates`"]
      n29["`39(1): capital gains and losses`"]
      n30["`39(4): the Canadian securities election`"]
      n31["`40(1): gains and losses, reserves`"]
      n32["`41: listed personal property`"]
    n33["`s. 40`"]
      n34["`40(2)(b): the principal residence exemption`"]
      n35["`40(2)(g): losses that are nil`"]
        n36["`(i) superficial losses`"]
        n37["`(ii) debts`"]
        n38["`(iii) personal-use property`"]
        n39["`(iv) TFSAs, RRSPs and other plans`"]
      n40["`40(2)(e.1): debts within a related group`"]
      n41["`40(3.3) to (3.5): suspended losses`"]
      n42["`40(3.6): shares to an affiliated corporation`"]
      n43["`40(3): negative adjusted cost base`"]
    n44["`s. 43`"]
      n45["`43(1): part of a property`"]
    n46["`s. 44`"]
      n47["`44(1): replacement property`"]
    n48["`s. 44.1`"]
      n49["`44.1(2): small business investment rollover`"]
    n50["`s. 45`"]
      n51["`45(1): change in use`"]
      n52["`45(2), (3), (4): the elections`"]
    n53["`s. 46`"]
      n54["`46(1), (2): the $1,000 floor`"]
      n55["`46(3): sets`"]
    n56["`s. 47`"]
      n57["`47(1): identical properties, average cost`"]
    n58["`s. 50`"]
      n59["`50(1): bad debts, worthless shares`"]
      n60["`50(2): bad personal-use debts`"]
    n61["`s. 51`"]
      n62["`51(1), (2): convertible property`"]
    n63["`s. 53`"]
      n64["`53(1)(f): cost of substituted property`"]
      n65["`53(1)(f.1), (f.2): cost after 40(2)(e.1), 40(3.6)`"]
    n66["`s. 54`"]
      n67["`superficial loss`"]
      n68["`principal residence`"]
      n69["`personal-use property`"]
      n70["`listed personal property`"]
    n71["`s. 55`"]
      n72["`55(2), (2.1): dividends over safe income`"]
      n73["`55(3): related parties, butterflies`"]
    n74["`s. 67.1`"]
      n75["`67.1(1): 50% of food and entertainment`"]
      n76["`67.1(2): the exceptions`"]
      n77["`67.1(3): conference fees`"]
    n78["`s. 69`"]
      n79["`69(1): not at arm's length, gifts`"]
    n80["`s. 70`"]
      n81["`70(5): deemed disposition on death`"]
      n82["`70(6): rollover to a spouse or spousal trust`"]
    n83["`s. 73`"]
      n84["`73(1), (1.01): the spousal rollover`"]
    n85["`ss. 74.1, 74.2, 74.4, 74.5`"]
      n86["`74.1(1), (2): income attributed back`"]
      n87["`74.1(3): repaying debt`"]
      n88["`74.2(1): capital gains attributed back`"]
      n89["`74.4(2): corporate attribution`"]
      n90["`74.5(1) to (3): fair market value, loans for value, separation`"]
    n91["`s. 80.4`"]
      n92["`80.4(2): deemed interest on shareholder loans`"]
    n93["`s. 82`"]
      n94["`82(1): taxable dividends and the gross-up`"]
    n95["`s. 83`"]
      n96["`83(2): capital dividends`"]
    n97["`s. 84`"]
      n98["`84(1): paid-up capital increased`"]
      n99["`84(2): distributions on winding-up`"]
      n100["`84(3): redemptions, the deemed dividend`"]
      n101["`84(4), (4.1): returns of capital`"]
    n102["`s. 84.1`"]
      n103["`84.1(1): paid-up capital, and the deemed dividend`"]
      n104["`84.1(2): hard cost, arm's length`"]
    n105["`s. 85`"]
      n106["`85(1): the elected amount, and the cost of the consideration`"]
      n107["`85(2.1): paid-up capital`"]
    n108["`s. 86`"]
      n109["`86(1): share exchange in a reorganization`"]
      n110["`86(2): benefit to a related person`"]
    n111["`s. 87`"]
      n112["`87(1): amalgamation`"]
      n113["`87(2)(e): cost of capital property`"]
      n114["`87(4): shareholders`"]
    n115["`s. 88`"]
      n116["`88(1): winding up a subsidiary`"]
      n117["`88(1)(c), (d): the bump`"]
    n118["`s. 89`"]
      n119["`89(1): capital dividend account`"]
      n120["`89(1): general rate income pool`"]
    n121["`s. 125`"]
      n122["`125(2), (3): the business limit, shared`"]
      n123["`125(5.1): the capital and passive income grinds`"]
      n124["`125(7): adjusted aggregate investment income`"]
    n125["`s. 110.1`"]
      n126["`110.1(1)(a): a corporation's gifts`"]
    n127["`s. 110.6`"]
      n128["`qualified small business corporation share`"]
      n129["`annual and cumulative gains limits`"]
      n130["`110.6(2.1): the deduction`"]
    n131["`s. 110`"]
      n132["`110(1)(d), (d.1): the option deduction`"]
    n133["`s. 111`"]
      n134["`111(8): net capital loss`"]
      n135["`111(1)(b), (1.1): deduction`"]
      n136["`111(8): non-capital loss`"]
      n137["`111(1)(a), (3): its deduction, oldest first`"]
    n138["`s. 112`"]
      n139["`112(1): intercorporate dividend deduction`"]
      n140["`112(3), (3.01): the stop-loss on shares`"]
    n141["`ss. 56, 56.1, 60`"]
      n142["`56.1(4): support amount, child support`"]
      n143["`56(1)(b), 60(b): included and deducted`"]
    n144["`s. 62`"]
      n145["`62(1): moving expenses`"]
      n146["`248(1): eligible relocation, the 40 km test`"]
    n147["`s. 63`"]
      n148["`63(1): child care expenses`"]
      n149["`63(2): the higher-income spouse`"]
    n150["`s. 60.03`"]
      n151["`60.03(1): split-pension amount`"]
      n152["`60(c), 56(1)(a.2): deducted and included`"]
    n153["`s. 256`"]
      n154["`256(1): associated corporations, (a) to (e)`"]
      n155["`256(1.2)(b)(i): a member's control is the group's`"]
      n156["`256(5.1): de facto control`"]
      n157["`256(2): through a third corporation`"]
    n158["`s. 117`"]
      n159["`117(2): the federal rates`"]
    n160["`s. 117.1`"]
      n161["`117.1(1), (4): indexing by the CPI`"]
      n162["`117.1(3): rounding`"]
    n163["`s. 118`"]
      n164["`118(1.1): basic personal amount`"]
      n165["`118(1)(a): spouse amount`"]
      n166["`118(1)(b): eligible dependant`"]
      n167["`118(1)(b.1), (d), (e): caregiver amounts`"]
      n168["`118(2): age credit`"]
      n169["`118(10): Canada employment credit`"]
      n170["`118(3), (7): pension credit`"]
    n171["`s. 118.2`"]
      n172["`118.2(1): the medical expense credit`"]
    n173["`s. 118.3`"]
      n174["`118.3(1): the disability credit`"]
      n175["`118.3(2): transfer to a supporting person`"]
    n176["`ss. 118.01 to 118.07`"]
      n177["`118.01: adoption`"]
      n178["`118.041: home accessibility`"]
      n179["`118.05: home buyers`"]
      n180["`118.06, 118.07: volunteers`"]
    n181["`s. 118.1`"]
      n182["`118.1(1): total gifts`"]
      n183["`118.1(3): the credit`"]
    n184["`ss. 118.5, 118.61, 118.81, 118.9`"]
      n185["`118.5(1)(a): tuition`"]
      n186["`118.61: carryforward`"]
      n187["`118.81, 118.9: transfer to a parent`"]
    n188["`s. 118.7`"]
      n189["`118.7: CPP and EI credits`"]
    n190["`s. 120.4`"]
      n191["`120.4(1): split income, excluded amounts`"]
      n192["`120.4(2), (3): the tax`"]
    n193["`s. 121`"]
      n194["`121: the dividend tax credit`"]
    n195["`ss. 127.5 to 127.531`"]
      n196["`127.51: the minimum amount`"]
      n197["`127.52(1): adjusted taxable income`"]
      n198["`127.531: the basic minimum tax credit`"]
      n199["`120.2: recovering minimum tax`"]
    n200["`ss. 123 to 125`"]
      n201["`123(1), 124(1): 38%, the abatement`"]
      n202["`123.4(2): general rate reduction`"]
      n203["`125(1): small business deduction`"]
    n204["`ss. 123.3, 129`"]
      n205["`123.3: refundable tax on investment income`"]
      n206["`129(1), (4): the dividend refund`"]
    n207["`s. 185.1`"]
      n208["`185.1(1): Part III.1 tax on excessive designations`"]
      n209["`185.1(2), (3): the election`"]
    n210["`s. 180.2`"]
      n211["`180.2(2): OAS recovery tax`"]
    n212["`s. 186`"]
      n213["`186(1): Part IV tax`"]
      n214["`186(4): connected corporations`"]
      n215["`186(2): control with non-arm's length persons`"]
    n216["`s. 248`"]
      n217["`248(1): majority-interest partner`"]
    n218["`s. 251`"]
      n219["`251(1): arm's length`"]
      n220["`251(2), (3): related persons`"]
      n221["`251(3.1), (3.2): amalgamations`"]
      n222["`251(6): blood, marriage, adoption`"]
    n223["`s. 251.1`"]
      n224["`251.1(1)(a) to (h): affiliated persons`"]
      n225["`251.1(2): amalgamations`"]
      n226["`251.1(3), (4): definitions and rules`"]
    n227["`s. 251.2`"]
      n228["`251.2(2)(a): loss restriction event`"]
    n229["`s. 256`"]
      n230["`256(7)(a): control not acquired`"]
```

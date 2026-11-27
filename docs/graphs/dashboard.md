# Dashboard

> Generated from the Lean sources by `scripts/blueprint.sh`. Do not edit by hand.

An overview of the project, drawn from the Lean.

## Statements by status

Every statement in every blueprint, by the status Lean computes for it.

```mermaid
pie showData title All 358 statements in the memos and blueprints, by status
    "encoded" : 62
    "proven" : 239
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
      n24["`20(3): refinancing`"]
    n25["`ss. 38 to 41`"]
      n26["`38: inclusion rates`"]
      n27["`39(1): capital gains and losses`"]
      n28["`39(4): the Canadian securities election`"]
      n29["`40(1): gains and losses, reserves`"]
      n30["`41: listed personal property`"]
    n31["`s. 40`"]
      n32["`40(2)(b): the principal residence exemption`"]
      n33["`40(2)(g): losses that are nil`"]
        n34["`(i) superficial losses`"]
        n35["`(ii) debts`"]
        n36["`(iii) personal-use property`"]
        n37["`(iv) TFSAs, RRSPs and other plans`"]
      n38["`40(2)(e.1): debts within a related group`"]
      n39["`40(3.3) to (3.5): suspended losses`"]
      n40["`40(3.6): shares to an affiliated corporation`"]
      n41["`40(3): negative adjusted cost base`"]
    n42["`s. 43`"]
      n43["`43(1): part of a property`"]
    n44["`s. 44`"]
      n45["`44(1): replacement property`"]
    n46["`s. 44.1`"]
      n47["`44.1(2): small business investment rollover`"]
    n48["`s. 45`"]
      n49["`45(1): change in use`"]
      n50["`45(2), (3), (4): the elections`"]
    n51["`s. 46`"]
      n52["`46(1), (2): the $1,000 floor`"]
      n53["`46(3): sets`"]
    n54["`s. 47`"]
      n55["`47(1): identical properties, average cost`"]
    n56["`s. 50`"]
      n57["`50(1): bad debts, worthless shares`"]
      n58["`50(2): bad personal-use debts`"]
    n59["`s. 51`"]
      n60["`51(1), (2): convertible property`"]
    n61["`s. 53`"]
      n62["`53(1)(f): cost of substituted property`"]
      n63["`53(1)(f.1), (f.2): cost after 40(2)(e.1), 40(3.6)`"]
    n64["`s. 54`"]
      n65["`superficial loss`"]
      n66["`principal residence`"]
      n67["`personal-use property`"]
      n68["`listed personal property`"]
    n69["`s. 55`"]
      n70["`55(2), (2.1): dividends over safe income`"]
      n71["`55(3): related parties, butterflies`"]
    n72["`s. 67.1`"]
      n73["`67.1(1): 50% of food and entertainment`"]
      n74["`67.1(2): the exceptions`"]
      n75["`67.1(3): conference fees`"]
    n76["`s. 69`"]
      n77["`69(1): not at arm's length, gifts`"]
    n78["`s. 70`"]
      n79["`70(5): deemed disposition on death`"]
      n80["`70(6): rollover to a spouse or spousal trust`"]
    n81["`s. 73`"]
      n82["`73(1), (1.01): the spousal rollover`"]
    n83["`ss. 74.1, 74.2, 74.4, 74.5`"]
      n84["`74.1(1), (2): income attributed back`"]
      n85["`74.1(3): repaying debt`"]
      n86["`74.2(1): capital gains attributed back`"]
      n87["`74.4(2): corporate attribution`"]
      n88["`74.5(1) to (3): fair market value, loans for value, separation`"]
    n89["`s. 80.4`"]
      n90["`80.4(2): deemed interest on shareholder loans`"]
    n91["`s. 82`"]
      n92["`82(1): taxable dividends and the gross-up`"]
    n93["`s. 83`"]
      n94["`83(2): capital dividends`"]
    n95["`s. 84`"]
      n96["`84(1): paid-up capital increased`"]
      n97["`84(2): distributions on winding-up`"]
      n98["`84(3): redemptions, the deemed dividend`"]
      n99["`84(4), (4.1): returns of capital`"]
    n100["`s. 84.1`"]
      n101["`84.1(1): paid-up capital, and the deemed dividend`"]
      n102["`84.1(2): hard cost, arm's length`"]
    n103["`s. 85`"]
      n104["`85(1): the elected amount, and the cost of the consideration`"]
      n105["`85(2.1): paid-up capital`"]
    n106["`s. 86`"]
      n107["`86(1): share exchange in a reorganization`"]
      n108["`86(2): benefit to a related person`"]
    n109["`s. 87`"]
      n110["`87(1): amalgamation`"]
      n111["`87(2)(e): cost of capital property`"]
      n112["`87(4): shareholders`"]
    n113["`s. 88`"]
      n114["`88(1): winding up a subsidiary`"]
      n115["`88(1)(c), (d): the bump`"]
    n116["`s. 89`"]
      n117["`89(1): capital dividend account`"]
      n118["`89(1): general rate income pool`"]
    n119["`s. 125`"]
      n120["`125(2), (3): the business limit, shared`"]
      n121["`125(5.1): the capital and passive income grinds`"]
      n122["`125(7): adjusted aggregate investment income`"]
    n123["`s. 110.1`"]
      n124["`110.1(1)(a): a corporation's gifts`"]
    n125["`s. 110.6`"]
      n126["`qualified small business corporation share`"]
      n127["`annual and cumulative gains limits`"]
      n128["`110.6(2.1): the deduction`"]
    n129["`s. 110`"]
      n130["`110(1)(d), (d.1): the option deduction`"]
    n131["`s. 111`"]
      n132["`111(8): net capital loss`"]
      n133["`111(1)(b), (1.1): deduction`"]
      n134["`111(8): non-capital loss`"]
      n135["`111(1)(a), (3): its deduction, oldest first`"]
    n136["`s. 112`"]
      n137["`112(1): intercorporate dividend deduction`"]
      n138["`112(3), (3.01): the stop-loss on shares`"]
    n139["`ss. 56, 56.1, 60`"]
      n140["`56.1(4): support amount, child support`"]
      n141["`56(1)(b), 60(b): included and deducted`"]
    n142["`s. 62`"]
      n143["`62(1): moving expenses`"]
      n144["`248(1): eligible relocation, the 40 km test`"]
    n145["`s. 63`"]
      n146["`63(1): child care expenses`"]
      n147["`63(2): the higher-income spouse`"]
    n148["`s. 60.03`"]
      n149["`60.03(1): split-pension amount`"]
      n150["`60(c), 56(1)(a.2): deducted and included`"]
    n151["`s. 256`"]
      n152["`256(1): associated corporations, (a) to (e)`"]
      n153["`256(1.2)(b)(i): a member's control is the group's`"]
      n154["`256(5.1): de facto control`"]
      n155["`256(2): through a third corporation`"]
    n156["`s. 117`"]
      n157["`117(2): the federal rates`"]
    n158["`s. 117.1`"]
      n159["`117.1(1), (4): indexing by the CPI`"]
      n160["`117.1(3): rounding`"]
    n161["`s. 118`"]
      n162["`118(1.1): basic personal amount`"]
      n163["`118(1)(a): spouse amount`"]
      n164["`118(1)(b): eligible dependant`"]
      n165["`118(1)(b.1), (d), (e): caregiver amounts`"]
      n166["`118(2): age credit`"]
      n167["`118(10): Canada employment credit`"]
      n168["`118(3), (7): pension credit`"]
    n169["`s. 118.2`"]
      n170["`118.2(1): the medical expense credit`"]
    n171["`s. 118.3`"]
      n172["`118.3(1): the disability credit`"]
      n173["`118.3(2): transfer to a supporting person`"]
    n174["`ss. 118.01 to 118.07`"]
      n175["`118.01: adoption`"]
      n176["`118.041: home accessibility`"]
      n177["`118.05: home buyers`"]
      n178["`118.06, 118.07: volunteers`"]
    n179["`s. 118.1`"]
      n180["`118.1(1): total gifts`"]
      n181["`118.1(3): the credit`"]
    n182["`ss. 118.5, 118.61, 118.81, 118.9`"]
      n183["`118.5(1)(a): tuition`"]
      n184["`118.61: carryforward`"]
      n185["`118.81, 118.9: transfer to a parent`"]
    n186["`s. 118.7`"]
      n187["`118.7: CPP and EI credits`"]
    n188["`s. 120.4`"]
      n189["`120.4(1): split income, excluded amounts`"]
      n190["`120.4(2), (3): the tax`"]
    n191["`s. 121`"]
      n192["`121: the dividend tax credit`"]
    n193["`ss. 127.5 to 127.531`"]
      n194["`127.51: the minimum amount`"]
      n195["`127.52(1): adjusted taxable income`"]
      n196["`127.531: the basic minimum tax credit`"]
      n197["`120.2: recovering minimum tax`"]
    n198["`ss. 123 to 125`"]
      n199["`123(1), 124(1): 38%, the abatement`"]
      n200["`123.4(2): general rate reduction`"]
      n201["`125(1): small business deduction`"]
    n202["`ss. 123.3, 129`"]
      n203["`123.3: refundable tax on investment income`"]
      n204["`129(1), (4): the dividend refund`"]
    n205["`s. 185.1`"]
      n206["`185.1(1): Part III.1 tax on excessive designations`"]
      n207["`185.1(2), (3): the election`"]
    n208["`s. 180.2`"]
      n209["`180.2(2): OAS recovery tax`"]
    n210["`s. 186`"]
      n211["`186(1): Part IV tax`"]
      n212["`186(4): connected corporations`"]
      n213["`186(2): control with non-arm's length persons`"]
    n214["`s. 248`"]
      n215["`248(1): majority-interest partner`"]
    n216["`s. 251`"]
      n217["`251(1): arm's length`"]
      n218["`251(2), (3): related persons`"]
      n219["`251(3.1), (3.2): amalgamations`"]
      n220["`251(6): blood, marriage, adoption`"]
    n221["`s. 251.1`"]
      n222["`251.1(1)(a) to (h): affiliated persons`"]
      n223["`251.1(2): amalgamations`"]
      n224["`251.1(3), (4): definitions and rules`"]
    n225["`s. 251.2`"]
      n226["`251.2(2)(a): loss restriction event`"]
    n227["`s. 256`"]
      n228["`256(7)(a): control not acquired`"]
```

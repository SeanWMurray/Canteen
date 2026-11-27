# Dashboard

> Generated from the Lean sources by `scripts/blueprint.sh`. Do not edit by hand.

An overview of the project, drawn from the Lean.

## Statements by status

Every statement in every blueprint, by the status Lean computes for it.

```mermaid
pie showData title All 365 statements in the memos and blueprints, by status
    "encoded" : 62
    "proven" : 246
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
      n18["`18(4): thin capitalization`"]
    n19["`s. 20`"]
      n20["`20(16): terminal loss`"]
      n21["`20(1)(j): loan repaid`"]
      n22["`20(1)(c): interest`"]
      n23["`20(1)(e), (e.1): financing expenses`"]
      n24["`20(1)(l), (p), 12(1)(d), (i): doubtful and bad debts`"]
      n25["`12(1)(a), 20(1)(m): amounts received in advance`"]
      n26["`20(1)(n), 20(8): unpaid amounts on property sold`"]
      n27["`20(3): refinancing`"]
    n28["`ss. 38 to 41`"]
      n29["`38: inclusion rates`"]
      n30["`39(1): capital gains and losses`"]
      n31["`39(4): the Canadian securities election`"]
      n32["`40(1): gains and losses, reserves`"]
      n33["`41: listed personal property`"]
    n34["`s. 40`"]
      n35["`40(2)(b): the principal residence exemption`"]
      n36["`40(2)(g): losses that are nil`"]
        n37["`(i) superficial losses`"]
        n38["`(ii) debts`"]
        n39["`(iii) personal-use property`"]
        n40["`(iv) TFSAs, RRSPs and other plans`"]
      n41["`40(2)(e.1): debts within a related group`"]
      n42["`40(3.3) to (3.5): suspended losses`"]
      n43["`40(3.6): shares to an affiliated corporation`"]
      n44["`40(3): negative adjusted cost base`"]
    n45["`s. 43`"]
      n46["`43(1): part of a property`"]
    n47["`s. 44`"]
      n48["`44(1): replacement property`"]
    n49["`s. 44.1`"]
      n50["`44.1(2): small business investment rollover`"]
    n51["`s. 45`"]
      n52["`45(1): change in use`"]
      n53["`45(2), (3), (4): the elections`"]
    n54["`s. 46`"]
      n55["`46(1), (2): the $1,000 floor`"]
      n56["`46(3): sets`"]
    n57["`s. 47`"]
      n58["`47(1): identical properties, average cost`"]
    n59["`s. 50`"]
      n60["`50(1): bad debts, worthless shares`"]
      n61["`50(2): bad personal-use debts`"]
    n62["`s. 51`"]
      n63["`51(1), (2): convertible property`"]
    n64["`s. 53`"]
      n65["`53(1)(f): cost of substituted property`"]
      n66["`53(1)(f.1), (f.2): cost after 40(2)(e.1), 40(3.6)`"]
    n67["`s. 54`"]
      n68["`superficial loss`"]
      n69["`principal residence`"]
      n70["`personal-use property`"]
      n71["`listed personal property`"]
    n72["`s. 55`"]
      n73["`55(2), (2.1): dividends over safe income`"]
      n74["`55(3): related parties, butterflies`"]
    n75["`s. 67.1`"]
      n76["`67.1(1): 50% of food and entertainment`"]
      n77["`67.1(2): the exceptions`"]
      n78["`67.1(3): conference fees`"]
    n79["`s. 69`"]
      n80["`69(1): not at arm's length, gifts`"]
    n81["`s. 70`"]
      n82["`70(5): deemed disposition on death`"]
      n83["`70(6): rollover to a spouse or spousal trust`"]
    n84["`s. 73`"]
      n85["`73(1), (1.01): the spousal rollover`"]
    n86["`ss. 74.1, 74.2, 74.4, 74.5`"]
      n87["`74.1(1), (2): income attributed back`"]
      n88["`74.1(3): repaying debt`"]
      n89["`74.2(1): capital gains attributed back`"]
      n90["`74.4(2): corporate attribution`"]
      n91["`74.5(1) to (3): fair market value, loans for value, separation`"]
    n92["`s. 80.4`"]
      n93["`80.4(2): deemed interest on shareholder loans`"]
    n94["`s. 82`"]
      n95["`82(1): taxable dividends and the gross-up`"]
    n96["`s. 83`"]
      n97["`83(2): capital dividends`"]
    n98["`s. 84`"]
      n99["`84(1): paid-up capital increased`"]
      n100["`84(2): distributions on winding-up`"]
      n101["`84(3): redemptions, the deemed dividend`"]
      n102["`84(4), (4.1): returns of capital`"]
    n103["`s. 84.1`"]
      n104["`84.1(1): paid-up capital, and the deemed dividend`"]
      n105["`84.1(2): hard cost, arm's length`"]
    n106["`s. 85`"]
      n107["`85(1): the elected amount, and the cost of the consideration`"]
      n108["`85(2.1): paid-up capital`"]
    n109["`s. 86`"]
      n110["`86(1): share exchange in a reorganization`"]
      n111["`86(2): benefit to a related person`"]
    n112["`s. 87`"]
      n113["`87(1): amalgamation`"]
      n114["`87(2)(e): cost of capital property`"]
      n115["`87(4): shareholders`"]
    n116["`s. 88`"]
      n117["`88(1): winding up a subsidiary`"]
      n118["`88(1)(c), (d): the bump`"]
    n119["`s. 89`"]
      n120["`89(1): capital dividend account`"]
      n121["`89(1): general rate income pool`"]
    n122["`s. 125`"]
      n123["`125(2), (3): the business limit, shared`"]
      n124["`125(5.1): the capital and passive income grinds`"]
      n125["`125(7): adjusted aggregate investment income`"]
    n126["`s. 110.1`"]
      n127["`110.1(1)(a): a corporation's gifts`"]
    n128["`s. 110.6`"]
      n129["`qualified small business corporation share`"]
      n130["`annual and cumulative gains limits`"]
      n131["`110.6(2.1): the deduction`"]
    n132["`s. 110`"]
      n133["`110(1)(d), (d.1): the option deduction`"]
    n134["`s. 111`"]
      n135["`111(8): net capital loss`"]
      n136["`111(1)(b), (1.1): deduction`"]
      n137["`111(8): non-capital loss`"]
      n138["`111(1)(a), (3): its deduction, oldest first`"]
    n139["`s. 112`"]
      n140["`112(1): intercorporate dividend deduction`"]
      n141["`112(3), (3.01): the stop-loss on shares`"]
    n142["`ss. 56, 56.1, 60`"]
      n143["`56.1(4): support amount, child support`"]
      n144["`56(1)(b), 60(b): included and deducted`"]
    n145["`s. 62`"]
      n146["`62(1): moving expenses`"]
      n147["`248(1): eligible relocation, the 40 km test`"]
    n148["`s. 63`"]
      n149["`63(1): child care expenses`"]
      n150["`63(2): the higher-income spouse`"]
    n151["`s. 60.03`"]
      n152["`60.03(1): split-pension amount`"]
      n153["`60(c), 56(1)(a.2): deducted and included`"]
    n154["`s. 212`"]
      n155["`212(1)(a), (4): management fees`"]
      n156["`212(1)(b): non-arm's length and participating interest`"]
      n157["`212(2): dividends`"]
      n158["`214(16): thin cap interest as a dividend`"]
      n159["`212(1)(d), 216(1): rent, and the election to file`"]
      n160["`120(1): the 48% for income not earned in a province`"]
    n161["`s. 256`"]
      n162["`256(1): associated corporations, (a) to (e)`"]
      n163["`256(1.2)(b)(i): a member's control is the group's`"]
      n164["`256(5.1): de facto control`"]
      n165["`256(2): through a third corporation`"]
    n166["`s. 116`"]
      n167["`116(5): 25% without a certificate`"]
      n168["`116(5.3): 50% for depreciable and similar property`"]
    n169["`s. 117`"]
      n170["`117(2): the federal rates`"]
    n171["`s. 117.1`"]
      n172["`117.1(1), (4): indexing by the CPI`"]
      n173["`117.1(3): rounding`"]
    n174["`s. 118`"]
      n175["`118(1.1): basic personal amount`"]
      n176["`118(1)(a): spouse amount`"]
      n177["`118(1)(b): eligible dependant`"]
      n178["`118(1)(b.1), (d), (e): caregiver amounts`"]
      n179["`118(2): age credit`"]
      n180["`118(10): Canada employment credit`"]
      n181["`118(3), (7): pension credit`"]
    n182["`s. 118.2`"]
      n183["`118.2(1): the medical expense credit`"]
    n184["`s. 118.3`"]
      n185["`118.3(1): the disability credit`"]
      n186["`118.3(2): transfer to a supporting person`"]
    n187["`ss. 118.01 to 118.07`"]
      n188["`118.01: adoption`"]
      n189["`118.041: home accessibility`"]
      n190["`118.05: home buyers`"]
      n191["`118.06, 118.07: volunteers`"]
    n192["`s. 118.1`"]
      n193["`118.1(1): total gifts`"]
      n194["`118.1(3): the credit`"]
    n195["`ss. 118.5, 118.61, 118.81, 118.9`"]
      n196["`118.5(1)(a): tuition`"]
      n197["`118.61: carryforward`"]
      n198["`118.81, 118.9: transfer to a parent`"]
    n199["`s. 118.7`"]
      n200["`118.7: CPP and EI credits`"]
    n201["`s. 120.4`"]
      n202["`120.4(1): split income, excluded amounts`"]
      n203["`120.4(2), (3): the tax`"]
    n204["`s. 121`"]
      n205["`121: the dividend tax credit`"]
    n206["`ss. 127.5 to 127.531`"]
      n207["`127.51: the minimum amount`"]
      n208["`127.52(1): adjusted taxable income`"]
      n209["`127.531: the basic minimum tax credit`"]
      n210["`120.2: recovering minimum tax`"]
    n211["`ss. 123 to 125`"]
      n212["`123(1), 124(1): 38%, the abatement`"]
      n213["`123.4(2): general rate reduction`"]
      n214["`125(1): small business deduction`"]
    n215["`ss. 123.3, 129`"]
      n216["`123.3: refundable tax on investment income`"]
      n217["`129(1), (4): the dividend refund`"]
    n218["`s. 185.1`"]
      n219["`185.1(1): Part III.1 tax on excessive designations`"]
      n220["`185.1(2), (3): the election`"]
    n221["`s. 180.2`"]
      n222["`180.2(2): OAS recovery tax`"]
    n223["`s. 186`"]
      n224["`186(1): Part IV tax`"]
      n225["`186(4): connected corporations`"]
      n226["`186(2): control with non-arm's length persons`"]
    n227["`s. 248`"]
      n228["`248(1): majority-interest partner`"]
    n229["`s. 248`"]
      n230["`taxable Canadian property: the 60-month look-back`"]
    n231["`s. 251`"]
      n232["`251(1): arm's length`"]
      n233["`251(2), (3): related persons`"]
      n234["`251(3.1), (3.2): amalgamations`"]
      n235["`251(6): blood, marriage, adoption`"]
    n236["`s. 251.1`"]
      n237["`251.1(1)(a) to (h): affiliated persons`"]
      n238["`251.1(2): amalgamations`"]
      n239["`251.1(3), (4): definitions and rules`"]
    n240["`s. 251.2`"]
      n241["`251.2(2)(a): loss restriction event`"]
    n242["`s. 256`"]
      n243["`256(7)(a): control not acquired`"]
```

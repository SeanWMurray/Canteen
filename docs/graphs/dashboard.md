# Dashboard

> Generated from the Lean sources by `scripts/blueprint.sh`. Do not edit by hand.

An overview of the project, drawn from the Lean.

## Statements by status

Every statement in every blueprint, by the status Lean computes for it.

```mermaid
pie showData title All 354 statements in the memos and blueprints, by status
    "encoded" : 62
    "proven" : 235
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
    n15["`s. 20`"]
      n16["`20(16): terminal loss`"]
      n17["`20(1)(j): loan repaid`"]
      n18["`20(1)(c): interest`"]
      n19["`20(3): refinancing`"]
    n20["`ss. 38 to 41`"]
      n21["`38: inclusion rates`"]
      n22["`39(1): capital gains and losses`"]
      n23["`39(4): the Canadian securities election`"]
      n24["`40(1): gains and losses, reserves`"]
      n25["`41: listed personal property`"]
    n26["`s. 40`"]
      n27["`40(2)(b): the principal residence exemption`"]
      n28["`40(2)(g): losses that are nil`"]
        n29["`(i) superficial losses`"]
        n30["`(ii) debts`"]
        n31["`(iii) personal-use property`"]
        n32["`(iv) TFSAs, RRSPs and other plans`"]
      n33["`40(2)(e.1): debts within a related group`"]
      n34["`40(3.3) to (3.5): suspended losses`"]
      n35["`40(3.6): shares to an affiliated corporation`"]
      n36["`40(3): negative adjusted cost base`"]
    n37["`s. 43`"]
      n38["`43(1): part of a property`"]
    n39["`s. 44`"]
      n40["`44(1): replacement property`"]
    n41["`s. 44.1`"]
      n42["`44.1(2): small business investment rollover`"]
    n43["`s. 45`"]
      n44["`45(1): change in use`"]
      n45["`45(2), (3), (4): the elections`"]
    n46["`s. 46`"]
      n47["`46(1), (2): the $1,000 floor`"]
      n48["`46(3): sets`"]
    n49["`s. 47`"]
      n50["`47(1): identical properties, average cost`"]
    n51["`s. 50`"]
      n52["`50(1): bad debts, worthless shares`"]
      n53["`50(2): bad personal-use debts`"]
    n54["`s. 51`"]
      n55["`51(1), (2): convertible property`"]
    n56["`s. 53`"]
      n57["`53(1)(f): cost of substituted property`"]
      n58["`53(1)(f.1), (f.2): cost after 40(2)(e.1), 40(3.6)`"]
    n59["`s. 54`"]
      n60["`superficial loss`"]
      n61["`principal residence`"]
      n62["`personal-use property`"]
      n63["`listed personal property`"]
    n64["`s. 55`"]
      n65["`55(2), (2.1): dividends over safe income`"]
      n66["`55(3): related parties, butterflies`"]
    n67["`s. 67.1`"]
      n68["`67.1(1): 50% of food and entertainment`"]
      n69["`67.1(2): the exceptions`"]
      n70["`67.1(3): conference fees`"]
    n71["`s. 69`"]
      n72["`69(1): not at arm's length, gifts`"]
    n73["`s. 70`"]
      n74["`70(5): deemed disposition on death`"]
      n75["`70(6): rollover to a spouse or spousal trust`"]
    n76["`s. 73`"]
      n77["`73(1), (1.01): the spousal rollover`"]
    n78["`ss. 74.1, 74.2, 74.4, 74.5`"]
      n79["`74.1(1), (2): income attributed back`"]
      n80["`74.1(3): repaying debt`"]
      n81["`74.2(1): capital gains attributed back`"]
      n82["`74.4(2): corporate attribution`"]
      n83["`74.5(1) to (3): fair market value, loans for value, separation`"]
    n84["`s. 80.4`"]
      n85["`80.4(2): deemed interest on shareholder loans`"]
    n86["`s. 82`"]
      n87["`82(1): taxable dividends and the gross-up`"]
    n88["`s. 83`"]
      n89["`83(2): capital dividends`"]
    n90["`s. 84`"]
      n91["`84(1): paid-up capital increased`"]
      n92["`84(2): distributions on winding-up`"]
      n93["`84(3): redemptions, the deemed dividend`"]
      n94["`84(4), (4.1): returns of capital`"]
    n95["`s. 84.1`"]
      n96["`84.1(1): paid-up capital, and the deemed dividend`"]
      n97["`84.1(2): hard cost, arm's length`"]
    n98["`s. 85`"]
      n99["`85(1): the elected amount, and the cost of the consideration`"]
      n100["`85(2.1): paid-up capital`"]
    n101["`s. 86`"]
      n102["`86(1): share exchange in a reorganization`"]
      n103["`86(2): benefit to a related person`"]
    n104["`s. 87`"]
      n105["`87(1): amalgamation`"]
      n106["`87(2)(e): cost of capital property`"]
      n107["`87(4): shareholders`"]
    n108["`s. 88`"]
      n109["`88(1): winding up a subsidiary`"]
      n110["`88(1)(c), (d): the bump`"]
    n111["`s. 89`"]
      n112["`89(1): capital dividend account`"]
      n113["`89(1): general rate income pool`"]
    n114["`s. 125`"]
      n115["`125(2), (3): the business limit, shared`"]
      n116["`125(5.1): the capital and passive income grinds`"]
      n117["`125(7): adjusted aggregate investment income`"]
    n118["`s. 110.1`"]
      n119["`110.1(1)(a): a corporation's gifts`"]
    n120["`s. 110.6`"]
      n121["`qualified small business corporation share`"]
      n122["`annual and cumulative gains limits`"]
      n123["`110.6(2.1): the deduction`"]
    n124["`s. 110`"]
      n125["`110(1)(d), (d.1): the option deduction`"]
    n126["`s. 111`"]
      n127["`111(8): net capital loss`"]
      n128["`111(1)(b), (1.1): deduction`"]
      n129["`111(8): non-capital loss`"]
      n130["`111(1)(a), (3): its deduction, oldest first`"]
    n131["`s. 112`"]
      n132["`112(1): intercorporate dividend deduction`"]
      n133["`112(3), (3.01): the stop-loss on shares`"]
    n134["`ss. 56, 56.1, 60`"]
      n135["`56.1(4): support amount, child support`"]
      n136["`56(1)(b), 60(b): included and deducted`"]
    n137["`s. 62`"]
      n138["`62(1): moving expenses`"]
      n139["`248(1): eligible relocation, the 40 km test`"]
    n140["`s. 63`"]
      n141["`63(1): child care expenses`"]
      n142["`63(2): the higher-income spouse`"]
    n143["`s. 60.03`"]
      n144["`60.03(1): split-pension amount`"]
      n145["`60(c), 56(1)(a.2): deducted and included`"]
    n146["`s. 256`"]
      n147["`256(1): associated corporations, (a) to (e)`"]
      n148["`256(1.2)(b)(i): a member's control is the group's`"]
      n149["`256(5.1): de facto control`"]
      n150["`256(2): through a third corporation`"]
    n151["`s. 117`"]
      n152["`117(2): the federal rates`"]
    n153["`s. 117.1`"]
      n154["`117.1(1), (4): indexing by the CPI`"]
      n155["`117.1(3): rounding`"]
    n156["`s. 118`"]
      n157["`118(1.1): basic personal amount`"]
      n158["`118(1)(a): spouse amount`"]
      n159["`118(1)(b): eligible dependant`"]
      n160["`118(1)(b.1), (d), (e): caregiver amounts`"]
      n161["`118(2): age credit`"]
      n162["`118(10): Canada employment credit`"]
      n163["`118(3), (7): pension credit`"]
    n164["`s. 118.2`"]
      n165["`118.2(1): the medical expense credit`"]
    n166["`s. 118.3`"]
      n167["`118.3(1): the disability credit`"]
      n168["`118.3(2): transfer to a supporting person`"]
    n169["`ss. 118.01 to 118.07`"]
      n170["`118.01: adoption`"]
      n171["`118.041: home accessibility`"]
      n172["`118.05: home buyers`"]
      n173["`118.06, 118.07: volunteers`"]
    n174["`s. 118.1`"]
      n175["`118.1(1): total gifts`"]
      n176["`118.1(3): the credit`"]
    n177["`ss. 118.5, 118.61, 118.81, 118.9`"]
      n178["`118.5(1)(a): tuition`"]
      n179["`118.61: carryforward`"]
      n180["`118.81, 118.9: transfer to a parent`"]
    n181["`s. 118.7`"]
      n182["`118.7: CPP and EI credits`"]
    n183["`s. 120.4`"]
      n184["`120.4(1): split income, excluded amounts`"]
      n185["`120.4(2), (3): the tax`"]
    n186["`s. 121`"]
      n187["`121: the dividend tax credit`"]
    n188["`ss. 127.5 to 127.531`"]
      n189["`127.51: the minimum amount`"]
      n190["`127.52(1): adjusted taxable income`"]
      n191["`127.531: the basic minimum tax credit`"]
      n192["`120.2: recovering minimum tax`"]
    n193["`ss. 123 to 125`"]
      n194["`123(1), 124(1): 38%, the abatement`"]
      n195["`123.4(2): general rate reduction`"]
      n196["`125(1): small business deduction`"]
    n197["`ss. 123.3, 129`"]
      n198["`123.3: refundable tax on investment income`"]
      n199["`129(1), (4): the dividend refund`"]
    n200["`s. 185.1`"]
      n201["`185.1(1): Part III.1 tax on excessive designations`"]
      n202["`185.1(2), (3): the election`"]
    n203["`s. 180.2`"]
      n204["`180.2(2): OAS recovery tax`"]
    n205["`s. 186`"]
      n206["`186(1): Part IV tax`"]
      n207["`186(4): connected corporations`"]
      n208["`186(2): control with non-arm's length persons`"]
    n209["`s. 248`"]
      n210["`248(1): majority-interest partner`"]
    n211["`s. 251`"]
      n212["`251(1): arm's length`"]
      n213["`251(2), (3): related persons`"]
      n214["`251(3.1), (3.2): amalgamations`"]
      n215["`251(6): blood, marriage, adoption`"]
    n216["`s. 251.1`"]
      n217["`251.1(1)(a) to (h): affiliated persons`"]
      n218["`251.1(2): amalgamations`"]
      n219["`251.1(3), (4): definitions and rules`"]
    n220["`s. 251.2`"]
      n221["`251.2(2)(a): loss restriction event`"]
    n222["`s. 256`"]
      n223["`256(7)(a): control not acquired`"]
```

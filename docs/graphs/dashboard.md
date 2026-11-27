# Dashboard

> Generated from the Lean sources by `scripts/blueprint.sh`. Do not edit by hand.

An overview of the project, drawn from the Lean.

## Statements by status

Every statement in every blueprint, by the status Lean computes for it.

```mermaid
pie showData title All 350 statements in the memos and blueprints, by status
    "encoded" : 62
    "proven" : 231
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
    n67["`s. 69`"]
      n68["`69(1): not at arm's length, gifts`"]
    n69["`s. 70`"]
      n70["`70(5): deemed disposition on death`"]
      n71["`70(6): rollover to a spouse or spousal trust`"]
    n72["`s. 73`"]
      n73["`73(1), (1.01): the spousal rollover`"]
    n74["`ss. 74.1, 74.2, 74.4, 74.5`"]
      n75["`74.1(1), (2): income attributed back`"]
      n76["`74.1(3): repaying debt`"]
      n77["`74.2(1): capital gains attributed back`"]
      n78["`74.4(2): corporate attribution`"]
      n79["`74.5(1) to (3): fair market value, loans for value, separation`"]
    n80["`s. 80.4`"]
      n81["`80.4(2): deemed interest on shareholder loans`"]
    n82["`s. 82`"]
      n83["`82(1): taxable dividends and the gross-up`"]
    n84["`s. 83`"]
      n85["`83(2): capital dividends`"]
    n86["`s. 84`"]
      n87["`84(1): paid-up capital increased`"]
      n88["`84(2): distributions on winding-up`"]
      n89["`84(3): redemptions, the deemed dividend`"]
      n90["`84(4), (4.1): returns of capital`"]
    n91["`s. 84.1`"]
      n92["`84.1(1): paid-up capital, and the deemed dividend`"]
      n93["`84.1(2): hard cost, arm's length`"]
    n94["`s. 85`"]
      n95["`85(1): the elected amount, and the cost of the consideration`"]
      n96["`85(2.1): paid-up capital`"]
    n97["`s. 86`"]
      n98["`86(1): share exchange in a reorganization`"]
      n99["`86(2): benefit to a related person`"]
    n100["`s. 87`"]
      n101["`87(1): amalgamation`"]
      n102["`87(2)(e): cost of capital property`"]
      n103["`87(4): shareholders`"]
    n104["`s. 88`"]
      n105["`88(1): winding up a subsidiary`"]
      n106["`88(1)(c), (d): the bump`"]
    n107["`s. 89`"]
      n108["`89(1): capital dividend account`"]
      n109["`89(1): general rate income pool`"]
    n110["`s. 110.1`"]
      n111["`110.1(1)(a): a corporation's gifts`"]
    n112["`s. 110.6`"]
      n113["`qualified small business corporation share`"]
      n114["`annual and cumulative gains limits`"]
      n115["`110.6(2.1): the deduction`"]
    n116["`s. 110`"]
      n117["`110(1)(d), (d.1): the option deduction`"]
    n118["`s. 111`"]
      n119["`111(8): net capital loss`"]
      n120["`111(1)(b), (1.1): deduction`"]
    n121["`s. 112`"]
      n122["`112(1): intercorporate dividend deduction`"]
      n123["`112(3), (3.01): the stop-loss on shares`"]
    n124["`ss. 56, 56.1, 60`"]
      n125["`56.1(4): support amount, child support`"]
      n126["`56(1)(b), 60(b): included and deducted`"]
    n127["`s. 62`"]
      n128["`62(1): moving expenses`"]
      n129["`248(1): eligible relocation, the 40 km test`"]
    n130["`s. 63`"]
      n131["`63(1): child care expenses`"]
      n132["`63(2): the higher-income spouse`"]
    n133["`s. 60.03`"]
      n134["`60.03(1): split-pension amount`"]
      n135["`60(c), 56(1)(a.2): deducted and included`"]
    n136["`s. 117`"]
      n137["`117(2): the federal rates`"]
    n138["`s. 117.1`"]
      n139["`117.1(1), (4): indexing by the CPI`"]
      n140["`117.1(3): rounding`"]
    n141["`s. 118`"]
      n142["`118(1.1): basic personal amount`"]
      n143["`118(1)(a): spouse amount`"]
      n144["`118(1)(b): eligible dependant`"]
      n145["`118(1)(b.1), (d), (e): caregiver amounts`"]
      n146["`118(2): age credit`"]
      n147["`118(10): Canada employment credit`"]
      n148["`118(3), (7): pension credit`"]
    n149["`s. 118.2`"]
      n150["`118.2(1): the medical expense credit`"]
    n151["`s. 118.3`"]
      n152["`118.3(1): the disability credit`"]
      n153["`118.3(2): transfer to a supporting person`"]
    n154["`ss. 118.01 to 118.07`"]
      n155["`118.01: adoption`"]
      n156["`118.041: home accessibility`"]
      n157["`118.05: home buyers`"]
      n158["`118.06, 118.07: volunteers`"]
    n159["`s. 118.1`"]
      n160["`118.1(1): total gifts`"]
      n161["`118.1(3): the credit`"]
    n162["`ss. 118.5, 118.61, 118.81, 118.9`"]
      n163["`118.5(1)(a): tuition`"]
      n164["`118.61: carryforward`"]
      n165["`118.81, 118.9: transfer to a parent`"]
    n166["`s. 118.7`"]
      n167["`118.7: CPP and EI credits`"]
    n168["`s. 120.4`"]
      n169["`120.4(1): split income, excluded amounts`"]
      n170["`120.4(2), (3): the tax`"]
    n171["`s. 121`"]
      n172["`121: the dividend tax credit`"]
    n173["`ss. 127.5 to 127.531`"]
      n174["`127.51: the minimum amount`"]
      n175["`127.52(1): adjusted taxable income`"]
      n176["`127.531: the basic minimum tax credit`"]
      n177["`120.2: recovering minimum tax`"]
    n178["`ss. 123 to 125`"]
      n179["`123(1), 124(1): 38%, the abatement`"]
      n180["`123.4(2): general rate reduction`"]
      n181["`125(1): small business deduction`"]
    n182["`ss. 123.3, 129`"]
      n183["`123.3: refundable tax on investment income`"]
      n184["`129(1), (4): the dividend refund`"]
    n185["`s. 185.1`"]
      n186["`185.1(1): Part III.1 tax on excessive designations`"]
      n187["`185.1(2), (3): the election`"]
    n188["`s. 180.2`"]
      n189["`180.2(2): OAS recovery tax`"]
    n190["`s. 186`"]
      n191["`186(1): Part IV tax`"]
      n192["`186(4): connected corporations`"]
      n193["`186(2): control with non-arm's length persons`"]
    n194["`s. 248`"]
      n195["`248(1): majority-interest partner`"]
    n196["`s. 251`"]
      n197["`251(1): arm's length`"]
      n198["`251(2), (3): related persons`"]
      n199["`251(3.1), (3.2): amalgamations`"]
      n200["`251(6): blood, marriage, adoption`"]
    n201["`s. 251.1`"]
      n202["`251.1(1)(a) to (h): affiliated persons`"]
      n203["`251.1(2): amalgamations`"]
      n204["`251.1(3), (4): definitions and rules`"]
    n205["`s. 251.2`"]
      n206["`251.2(2)(a): loss restriction event`"]
    n207["`s. 256`"]
      n208["`256(7)(a): control not acquired`"]
```

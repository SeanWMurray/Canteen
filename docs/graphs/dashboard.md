# Dashboard

> Generated from the Lean sources by `scripts/blueprint.sh`. Do not edit by hand.

An overview of the project, drawn from the Lean.

## Statements by status

Every statement in every blueprint, by the status Lean computes for it.

```mermaid
pie showData title All 339 statements in the memos and blueprints, by status
    "encoded" : 62
    "proven" : 220
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
    n3["`s. 13`"]
      n4["`13(21): undepreciated capital cost`"]
      n5["`13(1): recapture`"]
    n6["`s. 15`"]
      n7["`15(2), (2.6): shareholder loans`"]
    n8["`s. 20`"]
      n9["`20(16): terminal loss`"]
      n10["`20(1)(j): loan repaid`"]
      n11["`20(1)(c): interest`"]
      n12["`20(3): refinancing`"]
    n13["`ss. 38 to 41`"]
      n14["`38: inclusion rates`"]
      n15["`39(1): capital gains and losses`"]
      n16["`39(4): the Canadian securities election`"]
      n17["`40(1): gains and losses, reserves`"]
      n18["`41: listed personal property`"]
    n19["`s. 40`"]
      n20["`40(2)(b): the principal residence exemption`"]
      n21["`40(2)(g): losses that are nil`"]
        n22["`(i) superficial losses`"]
        n23["`(ii) debts`"]
        n24["`(iii) personal-use property`"]
        n25["`(iv) TFSAs, RRSPs and other plans`"]
      n26["`40(2)(e.1): debts within a related group`"]
      n27["`40(3.3) to (3.5): suspended losses`"]
      n28["`40(3.6): shares to an affiliated corporation`"]
      n29["`40(3): negative adjusted cost base`"]
    n30["`s. 43`"]
      n31["`43(1): part of a property`"]
    n32["`s. 44`"]
      n33["`44(1): replacement property`"]
    n34["`s. 45`"]
      n35["`45(1): change in use`"]
      n36["`45(2), (3), (4): the elections`"]
    n37["`s. 47`"]
      n38["`47(1): identical properties, average cost`"]
    n39["`s. 50`"]
      n40["`50(1): bad debts, worthless shares`"]
      n41["`50(2): bad personal-use debts`"]
    n42["`s. 51`"]
      n43["`51(1), (2): convertible property`"]
    n44["`s. 53`"]
      n45["`53(1)(f): cost of substituted property`"]
      n46["`53(1)(f.1), (f.2): cost after 40(2)(e.1), 40(3.6)`"]
    n47["`s. 54`"]
      n48["`superficial loss`"]
      n49["`principal residence`"]
      n50["`personal-use property`"]
      n51["`listed personal property`"]
    n52["`s. 55`"]
      n53["`55(2), (2.1): dividends over safe income`"]
      n54["`55(3): related parties, butterflies`"]
    n55["`s. 69`"]
      n56["`69(1): not at arm's length, gifts`"]
    n57["`s. 70`"]
      n58["`70(5): deemed disposition on death`"]
      n59["`70(6): rollover to a spouse or spousal trust`"]
    n60["`s. 73`"]
      n61["`73(1), (1.01): the spousal rollover`"]
    n62["`ss. 74.1, 74.2, 74.4, 74.5`"]
      n63["`74.1(1), (2): income attributed back`"]
      n64["`74.1(3): repaying debt`"]
      n65["`74.2(1): capital gains attributed back`"]
      n66["`74.4(2): corporate attribution`"]
      n67["`74.5(1) to (3): fair market value, loans for value, separation`"]
    n68["`s. 80.4`"]
      n69["`80.4(2): deemed interest on shareholder loans`"]
    n70["`s. 82`"]
      n71["`82(1): taxable dividends and the gross-up`"]
    n72["`s. 83`"]
      n73["`83(2): capital dividends`"]
    n74["`s. 84`"]
      n75["`84(1): paid-up capital increased`"]
      n76["`84(3): redemptions, the deemed dividend`"]
      n77["`84(4), (4.1): returns of capital`"]
    n78["`s. 84.1`"]
      n79["`84.1(1): paid-up capital, and the deemed dividend`"]
      n80["`84.1(2): hard cost, arm's length`"]
    n81["`s. 85`"]
      n82["`85(1): the elected amount, and the cost of the consideration`"]
      n83["`85(2.1): paid-up capital`"]
    n84["`s. 86`"]
      n85["`86(1): share exchange in a reorganization`"]
      n86["`86(2): benefit to a related person`"]
    n87["`s. 87`"]
      n88["`87(1): amalgamation`"]
      n89["`87(2)(e): cost of capital property`"]
      n90["`87(4): shareholders`"]
    n91["`s. 88`"]
      n92["`88(1): winding up a subsidiary`"]
      n93["`88(1)(c), (d): the bump`"]
    n94["`s. 89`"]
      n95["`89(1): capital dividend account`"]
      n96["`89(1): general rate income pool`"]
    n97["`s. 110.6`"]
      n98["`qualified small business corporation share`"]
      n99["`annual and cumulative gains limits`"]
      n100["`110.6(2.1): the deduction`"]
    n101["`s. 111`"]
      n102["`111(8): net capital loss`"]
      n103["`111(1)(b), (1.1): deduction`"]
    n104["`s. 112`"]
      n105["`112(1): intercorporate dividend deduction`"]
    n106["`ss. 56, 56.1, 60`"]
      n107["`56.1(4): support amount, child support`"]
      n108["`56(1)(b), 60(b): included and deducted`"]
    n109["`s. 60.03`"]
      n110["`60.03(1): split-pension amount`"]
      n111["`60(c), 56(1)(a.2): deducted and included`"]
    n112["`s. 117`"]
      n113["`117(2): the federal rates`"]
    n114["`s. 117.1`"]
      n115["`117.1(1), (4): indexing by the CPI`"]
      n116["`117.1(3): rounding`"]
    n117["`s. 118`"]
      n118["`118(1.1): basic personal amount`"]
      n119["`118(1)(a): spouse amount`"]
      n120["`118(1)(b): eligible dependant`"]
      n121["`118(1)(b.1), (d), (e): caregiver amounts`"]
      n122["`118(2): age credit`"]
      n123["`118(10): Canada employment credit`"]
      n124["`118(3), (7): pension credit`"]
    n125["`s. 118.2`"]
      n126["`118.2(1): the medical expense credit`"]
    n127["`s. 118.3`"]
      n128["`118.3(1): the disability credit`"]
      n129["`118.3(2): transfer to a supporting person`"]
    n130["`ss. 118.01 to 118.07`"]
      n131["`118.01: adoption`"]
      n132["`118.041: home accessibility`"]
      n133["`118.05: home buyers`"]
      n134["`118.06, 118.07: volunteers`"]
    n135["`s. 118.1`"]
      n136["`118.1(1): total gifts`"]
      n137["`118.1(3): the credit`"]
    n138["`ss. 118.5, 118.61, 118.81, 118.9`"]
      n139["`118.5(1)(a): tuition`"]
      n140["`118.61: carryforward`"]
      n141["`118.81, 118.9: transfer to a parent`"]
    n142["`s. 118.7`"]
      n143["`118.7: CPP and EI credits`"]
    n144["`s. 120.4`"]
      n145["`120.4(1): split income, excluded amounts`"]
      n146["`120.4(2), (3): the tax`"]
    n147["`s. 121`"]
      n148["`121: the dividend tax credit`"]
    n149["`ss. 127.5 to 127.531`"]
      n150["`127.51: the minimum amount`"]
      n151["`127.52(1): adjusted taxable income`"]
      n152["`127.531: the basic minimum tax credit`"]
      n153["`120.2: recovering minimum tax`"]
    n154["`ss. 123 to 125`"]
      n155["`123(1), 124(1): 38%, the abatement`"]
      n156["`123.4(2): general rate reduction`"]
      n157["`125(1): small business deduction`"]
    n158["`ss. 123.3, 129`"]
      n159["`123.3: refundable tax on investment income`"]
      n160["`129(1), (4): the dividend refund`"]
    n161["`s. 185.1`"]
      n162["`185.1(1): Part III.1 tax on excessive designations`"]
      n163["`185.1(2), (3): the election`"]
    n164["`s. 180.2`"]
      n165["`180.2(2): OAS recovery tax`"]
    n166["`s. 186`"]
      n167["`186(1): Part IV tax`"]
      n168["`186(4): connected corporations`"]
      n169["`186(2): control with non-arm's length persons`"]
    n170["`s. 248`"]
      n171["`248(1): majority-interest partner`"]
    n172["`s. 251`"]
      n173["`251(1): arm's length`"]
      n174["`251(2), (3): related persons`"]
      n175["`251(3.1), (3.2): amalgamations`"]
      n176["`251(6): blood, marriage, adoption`"]
    n177["`s. 251.1`"]
      n178["`251.1(1)(a) to (h): affiliated persons`"]
      n179["`251.1(2): amalgamations`"]
      n180["`251.1(3), (4): definitions and rules`"]
    n181["`s. 251.2`"]
      n182["`251.2(2)(a): loss restriction event`"]
    n183["`s. 256`"]
      n184["`256(7)(a): control not acquired`"]
```

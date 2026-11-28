# Provision map

> Generated from the Lean sources by `scripts/blueprint.sh`. Do not edit by hand.

Every encoded provision, with an arrow from a provision to each one whose encoding builds on it, read from the compiled modules (arrows already implied by others are left out). For example, 40(3.3) to (3.5) builds on the superficial loss definition (its period and exceptions), and section 251 on section 251.1 (its world of persons and the 251(6) connections).

```mermaid
flowchart BT
  v0["54 #quot;superficial loss#quot;"]:::prov
  v1["40(2)(g)(i) superficial losses"]:::prov
  v2["54 #quot;superficial loss#quot;, in statute form"]:::prov
  v3["53(1)(f) cost of substituted property"]:::prov
  v4["251.1(1)(a), two persons"]:::prov
  v5["251.1 affiliated persons, with 248(1) and 251(6)"]:::prov
  v6["251(1) to (6) related persons, arm's length"]:::prov
  v7["251.1(2), 251(3.1), (3.2) amalgamations"]:::prov
  v8["40(2)(g): the facts"]:::prov
  v9["40(2)(g)(ii) debts"]:::prov
  v10["40(2)(g)(iii) personal-use property, with 54 definitions"]:::prov
  v11["40(2)(g)(iv) registered plans"]:::prov
  v12["40(2)(g) as a whole"]:::prov
  v13["40(3.3) to (3.5) suspended losses"]:::prov
  v14["40(3.6), 53(1)(f.2) shares to an affiliated corporation"]:::prov
  v15["40(2)(e.1), 53(1)(f.1) debts within a related group"]:::prov
  v16["40(2)(b), 54 principal residence"]:::prov
  v17["38 to 41 capital gains and losses"]:::prov
  v18["3 income for the year"]:::prov
  v19["111 net capital losses, taxable income"]:::prov
  v20["111(1)(a), (3), (8) non-capital losses"]:::prov
  v21["69(1) not at arm's length, and gifts"]:::prov
  v22["73(1), (1.01) the spousal rollover"]:::prov
  v23["70(5), (6) death"]:::prov
  v24["74.2(1), 74.5 attribution of capital gains"]:::prov
  v25["45(1) to (4) change in use"]:::prov
  v26["85(1), (2.1) transfer to a corporation"]:::prov
  v27["84.1 shares to a non-arm's length corporation"]:::prov
  v28["110.6 the capital gains deduction"]:::prov
  v29["251.2(2)(a), 256(7)(a) loss restriction events"]:::prov
  v30["74.1, 74.5(2), (3)(a) attribution of income"]:::prov
  v31["82(1), 121 dividends, gross-up and credit"]:::prov
  v32["112(1), 55(2) intercorporate dividends"]:::prov
  v33["13(1), (21), 20(16) recapture and terminal loss"]:::prov
  v34["84(3) redemptions"]:::prov
  v35["83(2), 89(1) capital dividends"]:::prov
  v36["86 share exchanges, estate freezes"]:::prov
  v37["44(1) replacement property"]:::prov
  v38["47(1) identical properties"]:::prov
  v39["186(2), (4) connected corporations"]:::prov
  v40["84(4), (4.1), 40(3) returns of capital"]:::prov
  v41["88(1) winding-up and the bump"]:::prov
  v42["87(1), (2)(e), (4) amalgamations"]:::prov
  v43["51 convertible property"]:::prov
  v44["117(2) the federal rates"]:::prov
  v45["118(1), (1.1) personal amounts"]:::prov
  v46["118.1 the donation credit"]:::prov
  v47["120.4 tax on split income"]:::prov
  v48["20(1)(c), 20(3) interest on borrowed money"]:::prov
  v49["118.2(1) the medical expense credit"]:::prov
  v50["118.3(1), (2) the disability credit"]:::prov
  v51["118(2), (3), 60.03 pension income and splitting"]:::prov
  v52["180.2, 60(w) the OAS recovery tax"]:::prov
  v53["118(10), 118.7, 60(e.1) employment, CPP and EI"]:::prov
  v54["117.1 indexation, and each year's amounts"]:::prov
  v55["118.01 to 118.07 adoption, accessibility, home buyers', volunteers"]:::prov
  v56["118.5, 118.61, 118.81, 118.9 tuition"]:::prov
  v57["56(1)(b), 56.1(4), 60(b) support"]:::prov
  v58["63 child care expenses"]:::prov
  v59["62(1), 248(1) moving expenses"]:::prov
  v60["6(1)(e), 6(2) the standby charge"]:::prov
  v61["15(1) shareholder benefits"]:::prov
  v62["7, 110(1)(d), (d.1) employee stock options"]:::prov
  v63["118.62 the student loan interest credit"]:::prov
  v64["2(2), 3 an individual's year, to taxable income"]:::prov
  v65["39(4) to (6) the Canadian securities election"]:::prov
  v66["50(1) bad debts and worthless shares"]:::prov
  v67["43(1) part of a property"]:::prov
  v68["74.4(2) corporate attribution"]:::prov
  v69["123 to 125 corporate rates"]:::prov
  v70["123.3, 129, 186 refundable taxes"]:::prov
  v71["15(2), 80.4 shareholder loans"]:::prov
  v72["89(1), 185.1 the general rate income pool"]:::prov
  v73["127.5 to 127.531, 120.2 the minimum tax"]:::prov
  v74["84(1), 53(1)(b) an increase in paid-up capital"]:::prov
  v75["112(3), (3.01), (6.1) the stop-loss on shares"]:::prov
  v76["84(2) a distribution on winding-up"]:::prov
  v77["44.1 the small business investment rollover"]:::prov
  v78["46 personal-use property, the $1,000 rule"]:::prov
  v79["110.1(1)(a) a corporation's charitable gifts"]:::prov
  v80["125(2), (3), (5)(b), (5.1) the business limit, shared and ground"]:::prov
  v81["256(1), (2) associated corporations"]:::prov
  v82["67.1 meals and entertainment"]:::prov
  v83["20(1)(e), (e.1) financing expenses"]:::prov
  v84["18(12), 8(13) work space in the home"]:::prov
  v85["12(1)(d), (i), 20(1)(l), (p) doubtful and bad debts"]:::prov
  v86["12(1)(a), (e), 20(1)(m) amounts received in advance"]:::prov
  v87["20(1)(n), 20(8) the reserve for unpaid amounts on property sold"]:::prov
  v88["18(9) prepaid expenses"]:::prov
  v89["18(4), 214(16) thin capitalization and the deemed dividend"]:::prov
  v90["212(1)(a), (b), (2) Part XIII on management fees, interest and dividends"]:::prov
  v91["212(1)(d), 216(1), 120(1) a non-resident's rent and the election"]:::prov
  v92["248(1) taxable Canadian property"]:::prov
  v93["116(5), (5.3) buying from a non-resident"]:::prov
  v94["128.1(1), (4) becoming and ceasing to be resident"]:::prov
  v95["75(2), (3) reversionary trusts"]:::prov
  v96["107(2), (2.1), (4.1) distributions of trust property"]:::prov
  v97["104(4) the 21-year rule"]:::prov
  v98["104(6), (13), (19), (21), 122(1) a trust's income, paid out or taxed"]:::prov
  v99["146.01 the Home Buyers' Plan"]:::prov
  v100["146.6 the First Home Savings Account deduction"]:::prov
  v101["2(2), 3, 129(4) a corporation's year, to taxable income and tax"]:::prov
  v102["50(2) bad personal-use debts"]:::prov
  v0 --> v1
  v0 --> v2
  v0 --> v3
  v0 --> v4
  v0 --> v5
  v5 --> v6
  v6 --> v7
  v0 --> v8
  v8 --> v9
  v8 --> v10
  v8 --> v11
  v9 --> v12
  v10 --> v12
  v11 --> v12
  v1 --> v12
  v0 --> v13
  v5 --> v14
  v6 --> v15
  v12 --> v17
  v13 --> v17
  v14 --> v17
  v15 --> v17
  v16 --> v17
  v17 --> v18
  v18 --> v19
  v17 --> v20
  v17 --> v21
  v21 --> v22
  v17 --> v23
  v17 --> v24
  v17 --> v25
  v17 --> v26
  v26 --> v27
  v17 --> v28
  v6 --> v29
  v24 --> v30
  v17 --> v33
  v17 --> v34
  v31 --> v34
  v32 --> v34
  v17 --> v35
  v26 --> v36
  v17 --> v37
  v17 --> v38
  v6 --> v39
  v17 --> v40
  v17 --> v41
  v26 --> v42
  v26 --> v43
  v44 --> v45
  v44 --> v46
  v31 --> v47
  v44 --> v54
  v19 --> v64
  v28 --> v64
  v33 --> v64
  v30 --> v64
  v45 --> v64
  v46 --> v64
  v47 --> v64
  v48 --> v64
  v49 --> v64
  v50 --> v64
  v51 --> v64
  v52 --> v64
  v53 --> v64
  v54 --> v64
  v55 --> v64
  v56 --> v64
  v57 --> v64
  v58 --> v64
  v59 --> v64
  v60 --> v64
  v61 --> v64
  v62 --> v64
  v63 --> v64
  v17 --> v65
  v17 --> v66
  v17 --> v67
  v31 --> v68
  v69 --> v70
  v69 --> v72
  v64 --> v73
  v31 --> v74
  v17 --> v75
  v17 --> v76
  v31 --> v76
  v17 --> v78
  v6 --> v81
  v54 --> v91
  v92 --> v93
  v17 --> v94
  v92 --> v94
  v17 --> v95
  v17 --> v97
  v54 --> v98
  v31 --> v98
  v46 --> v98
  v19 --> v101
  v20 --> v101
  v32 --> v101
  v79 --> v101
  v70 --> v101
  v80 --> v101
  v72 --> v101
  v35 --> v101
  classDef prov fill:#bbdefb,stroke:#1565c0,color:#0d47a1
```

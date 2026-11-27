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
  v63["2(2), 3 an individual's year, to taxable income"]:::prov
  v64["39(4) to (6) the Canadian securities election"]:::prov
  v65["50(1) bad debts and worthless shares"]:::prov
  v66["43(1) part of a property"]:::prov
  v67["74.4(2) corporate attribution"]:::prov
  v68["123 to 125 corporate rates"]:::prov
  v69["123.3, 129, 186 refundable taxes"]:::prov
  v70["15(2), 80.4 shareholder loans"]:::prov
  v71["89(1), 185.1 the general rate income pool"]:::prov
  v72["127.5 to 127.531, 120.2 the minimum tax"]:::prov
  v73["84(1), 53(1)(b) an increase in paid-up capital"]:::prov
  v74["112(3), (3.01), (6.1) the stop-loss on shares"]:::prov
  v75["84(2) a distribution on winding-up"]:::prov
  v76["44.1 the small business investment rollover"]:::prov
  v77["46 personal-use property, the $1,000 rule"]:::prov
  v78["110.1(1)(a) a corporation's charitable gifts"]:::prov
  v79["2(2), 3, 129(4) a corporation's year, to taxable income and tax"]:::prov
  v80["50(2) bad personal-use debts"]:::prov
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
  v19 --> v63
  v28 --> v63
  v33 --> v63
  v30 --> v63
  v45 --> v63
  v46 --> v63
  v47 --> v63
  v48 --> v63
  v49 --> v63
  v50 --> v63
  v51 --> v63
  v52 --> v63
  v53 --> v63
  v54 --> v63
  v55 --> v63
  v56 --> v63
  v57 --> v63
  v58 --> v63
  v59 --> v63
  v60 --> v63
  v61 --> v63
  v62 --> v63
  v17 --> v64
  v17 --> v65
  v17 --> v66
  v31 --> v67
  v68 --> v69
  v68 --> v71
  v63 --> v72
  v31 --> v73
  v17 --> v74
  v17 --> v75
  v31 --> v75
  v17 --> v77
  v19 --> v79
  v20 --> v79
  v32 --> v79
  v78 --> v79
  v69 --> v79
  v71 --> v79
  v35 --> v79
  classDef prov fill:#bbdefb,stroke:#1565c0,color:#0d47a1
```

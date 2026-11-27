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
  v20["69(1) not at arm's length, and gifts"]:::prov
  v21["73(1), (1.01) the spousal rollover"]:::prov
  v22["70(5), (6) death"]:::prov
  v23["74.2(1), 74.5 attribution of capital gains"]:::prov
  v24["45(1) to (4) change in use"]:::prov
  v25["85(1), (2.1) transfer to a corporation"]:::prov
  v26["84.1 shares to a non-arm's length corporation"]:::prov
  v27["110.6 the capital gains deduction"]:::prov
  v28["251.2(2)(a), 256(7)(a) loss restriction events"]:::prov
  v29["74.1, 74.5(2), (3)(a) attribution of income"]:::prov
  v30["82(1), 121 dividends, gross-up and credit"]:::prov
  v31["112(1), 55(2) intercorporate dividends"]:::prov
  v32["13(1), (21), 20(16) recapture and terminal loss"]:::prov
  v33["84(3) redemptions"]:::prov
  v34["83(2), 89(1) capital dividends"]:::prov
  v35["86 share exchanges, estate freezes"]:::prov
  v36["44(1) replacement property"]:::prov
  v37["47(1) identical properties"]:::prov
  v38["186(2), (4) connected corporations"]:::prov
  v39["84(4), (4.1), 40(3) returns of capital"]:::prov
  v40["88(1) winding-up and the bump"]:::prov
  v41["87(1), (2)(e), (4) amalgamations"]:::prov
  v42["51 convertible property"]:::prov
  v43["117(2) the federal rates"]:::prov
  v44["118(1), (1.1) personal amounts"]:::prov
  v45["118.1 the donation credit"]:::prov
  v46["120.4 tax on split income"]:::prov
  v47["20(1)(c), 20(3) interest on borrowed money"]:::prov
  v48["118.2(1) the medical expense credit"]:::prov
  v49["118.3(1), (2) the disability credit"]:::prov
  v50["118(2), (3), 60.03 pension income and splitting"]:::prov
  v51["180.2, 60(w) the OAS recovery tax"]:::prov
  v52["118(10), 118.7, 60(e.1) employment, CPP and EI"]:::prov
  v53["117.1 indexation, and each year's amounts"]:::prov
  v54["118.01 to 118.07 adoption, accessibility, home buyers', volunteers"]:::prov
  v55["118.5, 118.61, 118.81, 118.9 tuition"]:::prov
  v56["56(1)(b), 56.1(4), 60(b) support"]:::prov
  v57["63 child care expenses"]:::prov
  v58["62(1), 248(1) moving expenses"]:::prov
  v59["6(1)(e), 6(2) the standby charge"]:::prov
  v60["15(1) shareholder benefits"]:::prov
  v61["7, 110(1)(d), (d.1) employee stock options"]:::prov
  v62["2(2), 3 an individual's year, to taxable income"]:::prov
  v63["39(4) to (6) the Canadian securities election"]:::prov
  v64["50(1) bad debts and worthless shares"]:::prov
  v65["43(1) part of a property"]:::prov
  v66["74.4(2) corporate attribution"]:::prov
  v67["123 to 125 corporate rates"]:::prov
  v68["123.3, 129, 186 refundable taxes"]:::prov
  v69["15(2), 80.4 shareholder loans"]:::prov
  v70["89(1), 185.1 the general rate income pool"]:::prov
  v71["127.5 to 127.531, 120.2 the minimum tax"]:::prov
  v72["84(1), 53(1)(b) an increase in paid-up capital"]:::prov
  v73["112(3), (3.01), (6.1) the stop-loss on shares"]:::prov
  v74["84(2) a distribution on winding-up"]:::prov
  v75["44.1 the small business investment rollover"]:::prov
  v76["46 personal-use property, the $1,000 rule"]:::prov
  v77["110.1(1)(a) a corporation's charitable gifts"]:::prov
  v78["2(2), 3, 129(4) a corporation's year, to taxable income and tax"]:::prov
  v79["50(2) bad personal-use debts"]:::prov
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
  v20 --> v21
  v17 --> v22
  v17 --> v23
  v17 --> v24
  v17 --> v25
  v25 --> v26
  v17 --> v27
  v6 --> v28
  v23 --> v29
  v17 --> v32
  v17 --> v33
  v30 --> v33
  v31 --> v33
  v17 --> v34
  v25 --> v35
  v17 --> v36
  v17 --> v37
  v6 --> v38
  v17 --> v39
  v17 --> v40
  v25 --> v41
  v25 --> v42
  v43 --> v44
  v43 --> v45
  v30 --> v46
  v43 --> v53
  v19 --> v62
  v27 --> v62
  v32 --> v62
  v29 --> v62
  v44 --> v62
  v45 --> v62
  v46 --> v62
  v47 --> v62
  v48 --> v62
  v49 --> v62
  v50 --> v62
  v51 --> v62
  v52 --> v62
  v53 --> v62
  v54 --> v62
  v55 --> v62
  v56 --> v62
  v57 --> v62
  v58 --> v62
  v59 --> v62
  v60 --> v62
  v61 --> v62
  v17 --> v63
  v17 --> v64
  v17 --> v65
  v30 --> v66
  v67 --> v68
  v67 --> v70
  v62 --> v71
  v30 --> v72
  v17 --> v73
  v17 --> v74
  v30 --> v74
  v17 --> v76
  v19 --> v78
  v31 --> v78
  v77 --> v78
  v68 --> v78
  v70 --> v78
  v34 --> v78
  classDef prov fill:#bbdefb,stroke:#1565c0,color:#0d47a1
```

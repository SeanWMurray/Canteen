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
  v8["50(2) bad personal-use debts"]:::prov
  v9["40(3.3) to (3.5) suspended losses"]:::prov
  v10["40(2)(g): the facts"]:::prov
  v11["40(2)(g)(ii) debts"]:::prov
  v12["40(2)(g)(iii) personal-use property, with 54 definitions"]:::prov
  v13["40(2)(g)(iv) registered plans"]:::prov
  v14["40(2)(g) as a whole"]:::prov
  v0 --> v1
  v0 --> v2
  v0 --> v3
  v0 --> v4
  v0 --> v5
  v5 --> v6
  v6 --> v7
  v0 --> v9
  v0 --> v10
  v10 --> v11
  v10 --> v12
  v10 --> v13
  v11 --> v14
  v12 --> v14
  v13 --> v14
  v1 --> v14
  classDef prov fill:#bbdefb,stroke:#1565c0,color:#0d47a1
```

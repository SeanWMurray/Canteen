# Who is related to whom

> Generated from the Lean sources by `scripts/blueprint.sh`. Do not edit by hand.

A family under section 251: children by blood (solid arrows), an adoption in fact (dotted), a marriage (thick line) and control of two companies (dashed). Each thin line is a related pair, labelled with its paragraph. Cousins, and an uncle and his nephew, are not related: blood relationship covers only descendants and brothers and sisters (251(6)(a)). A step-parent is, through marriage (251(6)(b)). Cousinco is related to Uncle, through Cousin (251(2)(b)(iii)), but not to Annco.

## Three generations

```mermaid
flowchart TB
  p0("Gran")
  p1("Ann")
  p2("Uncle")
  p3("Bob")
  p4("Kid")
  p5("Cousin")
  p6("Ward")
  p10["Annco"]
  p11["Cousinco"]
  p0 -->|child| p1
  p0 -->|child| p2
  p1 -->|child| p4
  p2 -->|child| p5
  p1 -.->|adopted| p6
  p1 ===|married| p3
  p1 -.->|"controls"| p10
  p5 -.->|"controls"| p11
  p0 ---|"251(2)(a), (6)"| p1
  p0 ---|"251(2)(a), (6)"| p2
  p0 ---|"251(2)(a), (6)"| p3
  p0 ---|"251(2)(a), (6)"| p4
  p0 ---|"251(2)(a), (6)"| p5
  p0 ---|"251(2)(a), (6)"| p6
  p1 ---|"251(2)(a), (6)"| p2
  p1 ---|"251(2)(a), (6)"| p3
  p1 ---|"251(2)(a), (6)"| p4
  p1 ---|"251(2)(a), (6)"| p6
  p2 ---|"251(2)(a), (6)"| p3
  p2 ---|"251(2)(a), (6)"| p5
  p3 ---|"251(2)(a), (6)"| p4
  p4 ---|"251(2)(a), (6)"| p6
  p10 ---|"251(2)(b)(i)"| p1
  p11 ---|"251(2)(b)(i)"| p5
  p10 ---|"251(2)(b)(iii)"| p0
  p10 ---|"251(2)(b)(iii)"| p2
  p10 ---|"251(2)(b)(iii)"| p3
  p10 ---|"251(2)(b)(iii)"| p4
  p10 ---|"251(2)(b)(iii)"| p6
  p11 ---|"251(2)(b)(iii)"| p0
  p11 ---|"251(2)(b)(iii)"| p2
```


# Who is affiliated with whom

> Generated from the Lean sources by `scripts/blueprint.sh`. Do not edit by hand.

Worlds of persons under section 251.1, drawn from the computed relation. Rounded boxes are individuals, boxes corporations, hexagons partnerships, cylinders trusts. Dashed arrows are control (orange where a judgment call); each solid line is an affiliated pair, labelled with the paragraph that makes it so. Affiliation is not transitive: Cy's company is affiliated with Cy, but not with Ann.

## A family group

```mermaid
flowchart LR
  p0("Ann")
  p1("Bob (Ann's spouse)")
  p2("Cy (a friend)")
  p10["Annco"]
  p11["Famco"]
  p12["Cyco"]
  p20{{"AB Partners"}}
  p30[("The Family Trust")]
  p0 -.->|"controls"| p10
  p0 -.->|"controls"| p11
  p1 -.->|"controls"| p11
  p2 -.->|"controls"| p12
  p0 ---|"(a)"| p1
  p10 ---|"(b)(i)"| p0
  p10 ---|"(b)(iii)"| p1
  p12 ---|"(b)(i)"| p2
  p11 ---|"(d)"| p20
  p0 ---|"(g)(ii)"| p30
  p1 ---|"(g)(i)"| p30
  p10 ---|"(g)(ii)"| p30
  p11 ---|"(g)(ii)"| p30
  p20 ---|"(g)(ii)"| p30
  p11 ---|"(b)(ii)"| p0
  p11 ---|"(b)(ii)"| p1
  p10 ---|"(c)(ii)"| p11
  p20 ---|"(e)"| p0
  p20 ---|"(e)"| p1
  p20 ---|"(e)"| p10
```

## Holdco, owned by the taxpayer and spouse

```mermaid
flowchart LR
  p0("the taxpayer")
  p1("the taxpayer's spouse")
  p2["Holdco"]
  p0 -.->|"controls"| p2
  p1 -.->|"controls"| p2
  p0 ---|"(a)"| p1
  p2 ---|"(b)(ii)"| p0
  p2 ---|"(b)(ii)"| p1
```

## An amalgamation: the hypothetical world of 251.1(2), with Newco supposed to exist immediately before

```mermaid
flowchart LR
  p0("Ann")
  p10["Pco"]
  p11["Sco"]
  p20["Newco (supposed)"]
  p0 -.->|"controls"| p10
  p10 -.->|"controls"| p11
  p0 -.->|"controls"| p20
  p10 ---|"(b)(i)"| p0
  p11 ---|"(b)(i)"| p10
  p20 ---|"(b)(i)"| p0
  p10 ---|"(c)(i)"| p20
  p11 ---|"(c)(i)"| p20
```

## Holdco, owned with a friend, if the taxpayer controls it de facto

```mermaid
flowchart LR
  p0("the taxpayer")
  p3("a friend")
  p2["Holdco"]
  p0 -.->|"controls"| p2
  p3 -.->|"controls"| p2
  p0 -.->|"controls (J-DEFACTO)"| p2
  p2 ---|"(b)(i)"| p0
  linkStyle 2 stroke:#ef6c00,color:#e65100
```


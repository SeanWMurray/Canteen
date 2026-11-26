# Flowcharts of the rules

> Generated from the Lean sources by `scripts/blueprint.sh`. Do not edit by hand.

Each rule written with the `statute` command, drawn from its outline: every condition must be met, and no exception may apply. Grey clauses are facts, orange clauses rest on a judgment call, and blue clauses are other rules. The explanation Lean gives cites a failure on the facts before one that rests on judgment.

## Section 54, "superficial loss"

```mermaid
flowchart TD
  S(["the superficial loss rule · ITA 54 #quot;superficial loss#quot;"]):::start
  C0["<b>opening words</b> The taxpayer has a loss from the disposition<br/>of the particular property<br/>[ITA 54 #quot;superficial loss#quot; opening words]"]:::fact
  C1["<b>(a), (b)</b> During the period that begins 30 days before<br/>and ends 30 days after the disposition, the<br/>taxpayer or a person affiliated with the<br/>taxpayer acquired a property that is, or is<br/>identical to, the particular property, and<br/>at the end of that period the taxpayer or a<br/>person affiliated with the taxpayer owned or<br/>had a right to acquire it<br/><i>judgment call: judgment calls computed from the facts</i><br/>[ITA 54 #quot;superficial loss#quot; (a), (b)]"]:::judgment
  E0["<b>(c)</b> The disposition was deemed to have been made<br/>by a provision listed in paragraph (c)<br/>[ITA 54 #quot;superficial loss#quot; (c)]"]:::fact
  E1["<b>(d)</b> The disposition was the expiry of an option<br/>[ITA 54 #quot;superficial loss#quot; (d)]"]:::fact
  E2["<b>(e)</b> Paragraph 40(2)(e.1) applies to the<br/>disposition<br/>[ITA 54 #quot;superficial loss#quot; (e)]"]:::fact
  E3["<b>(f)</b> The taxpayer was subject to a loss<br/>restriction event within 30 days after the<br/>disposition<br/>[ITA 54 #quot;superficial loss#quot; (f)]"]:::fact
  E4["<b>(g)</b> Within 30 days after the disposition, the<br/>taxpayer became or ceased to be exempt from<br/>tax under Part I on its taxable income<br/>[ITA 54 #quot;superficial loss#quot; (g)]"]:::fact
  E5["<b>(h)</b> Subsection 40(3.4) or 69(5) applies to the<br/>disposition<br/>[ITA 54 #quot;superficial loss#quot; (h)]"]:::fact
  Y(["the superficial loss rule applies"]):::yes
  N(["the superficial loss rule does not apply"]):::no
  S --> C0
  C0 -->|met| C1
  C0 -->|not met| N
  C1 -->|met| E0
  C1 -->|not met| N
  E0 -->|does not apply| E1
  E0 -->|applies| N
  E1 -->|does not apply| E2
  E1 -->|applies| N
  E2 -->|does not apply| E3
  E2 -->|applies| N
  E3 -->|does not apply| E4
  E3 -->|applies| N
  E4 -->|does not apply| E5
  E4 -->|applies| N
  E5 -->|does not apply| Y
  E5 -->|applies| N
  classDef fact fill:#eeeeee,stroke:#616161,color:#212121
  classDef judgment fill:#ffe0b2,stroke:#ef6c00,color:#e65100
  classDef rule fill:#bbdefb,stroke:#1565c0,color:#0d47a1
  classDef yes fill:#c8e6c9,stroke:#2e7d32,color:#1b5e20
  classDef no fill:#ffcdd2,stroke:#c62828,color:#b71c1c
  classDef start fill:#ffffff,stroke:#212121,color:#212121
```

## Subparagraph 40(2)(g)(i)

```mermaid
flowchart TD
  S(["subparagraph 40(2)(g)(i) · ITA 40(2)(g)"]):::start
  C0["<b>(i)</b> the superficial loss rule applies<br/>[ITA 54 #quot;superficial loss#quot;]"]:::rule
  E0["<b>opening words</b> For the purposes of computing the surplus or<br/>deficit of the taxpayer in respect of<br/>another taxpayer of which it is a foreign<br/>affiliate, the property is excluded property<br/>[ITA 40(2)(g) opening words]"]:::fact
  Y(["subparagraph 40(2)(g)(i) applies"]):::yes
  N(["subparagraph 40(2)(g)(i) does not apply"]):::no
  S --> C0
  C0 -->|met| E0
  C0 -->|not met| N
  E0 -->|does not apply| Y
  E0 -->|applies| N
  classDef fact fill:#eeeeee,stroke:#616161,color:#212121
  classDef judgment fill:#ffe0b2,stroke:#ef6c00,color:#e65100
  classDef rule fill:#bbdefb,stroke:#1565c0,color:#0d47a1
  classDef yes fill:#c8e6c9,stroke:#2e7d32,color:#1b5e20
  classDef no fill:#ffcdd2,stroke:#c62828,color:#b71c1c
  classDef start fill:#ffffff,stroke:#212121,color:#212121
```

## Paragraph 251.1(1)(a)

```mermaid
flowchart TD
  S(["paragraph 251.1(1)(a) · ITA 251.1(1)(a)"]):::start
  C0["The first person is an individual<br/>[ITA 251.1(1)(a)]"]:::fact
  C1["The second person is a spouse or common-law<br/>partner of the individual<br/>[ITA 251.1(1)(a)]"]:::fact
  Y(["paragraph 251.1(1)(a) applies"]):::yes
  N(["paragraph 251.1(1)(a) does not apply"]):::no
  S --> C0
  C0 -->|met| C1
  C0 -->|not met| N
  C1 -->|met| Y
  C1 -->|not met| N
  classDef fact fill:#eeeeee,stroke:#616161,color:#212121
  classDef judgment fill:#ffe0b2,stroke:#ef6c00,color:#e65100
  classDef rule fill:#bbdefb,stroke:#1565c0,color:#0d47a1
  classDef yes fill:#c8e6c9,stroke:#2e7d32,color:#1b5e20
  classDef no fill:#ffcdd2,stroke:#c62828,color:#b71c1c
  classDef start fill:#ffffff,stroke:#212121,color:#212121
```

## Rule X (the placeholder from the design)

```mermaid
flowchart TD
  S(["Rule X · s.X"]):::start
  C0["<b>(a)</b> Condition A is met<br/>[s.X(a)]"]:::fact
  C1["<b>(b)</b> Condition B is met<br/><i>judgment call: J-B</i><br/>[s.X(b)]"]:::judgment
  E0["<b>(c)</b> The exception applies<br/>[s.X(c)]"]:::fact
  Y(["Rule X applies"]):::yes
  N(["Rule X does not apply"]):::no
  S --> C0
  C0 -->|met| C1
  C0 -->|not met| N
  C1 -->|met| E0
  C1 -->|not met| N
  E0 -->|does not apply| Y
  E0 -->|applies| N
  classDef fact fill:#eeeeee,stroke:#616161,color:#212121
  classDef judgment fill:#ffe0b2,stroke:#ef6c00,color:#e65100
  classDef rule fill:#bbdefb,stroke:#1565c0,color:#0d47a1
  classDef yes fill:#c8e6c9,stroke:#2e7d32,color:#1b5e20
  classDef no fill:#ffcdd2,stroke:#c62828,color:#b71c1c
  classDef start fill:#ffffff,stroke:#212121,color:#212121
```


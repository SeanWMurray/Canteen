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

## Paragraph 40(2)(g) as a whole

```mermaid
flowchart TD
  S(["paragraph 40(2)(g) · ITA 40(2)(g)"]):::start
  C0["<b>(i) to (iv)</b> one of subparagraphs 40(2)(g)(i) to (iv)<br/>applies<br/>[ITA 40(2)(g)]"]:::rule
  E0["<b>opening words</b> For the purposes of computing the surplus or<br/>deficit of the taxpayer in respect of<br/>another taxpayer of which it is a foreign<br/>affiliate, the property is excluded property<br/>[ITA 40(2)(g) opening words]"]:::fact
  Y(["paragraph 40(2)(g) applies"]):::yes
  N(["paragraph 40(2)(g) does not apply"]):::no
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

## Subparagraph 40(2)(g)(ii): debts

```mermaid
flowchart TD
  S(["subparagraph 40(2)(g)(ii) · ITA 40(2)(g)(ii)"]):::start
  C0["<b>loss</b> The taxpayer has a loss from the disposition<br/>[ITA 40(2)(g)(ii) loss]"]:::fact
  C1["<b>debt</b> The property disposed of is a debt or other<br/>right to receive an amount<br/>[ITA 40(2)(g)(ii) debt]"]:::fact
  E0["<b>income purpose</b> The taxpayer acquired the debt or right for<br/>the purpose of gaining or producing income<br/>from a business or property (other than<br/>exempt income)<br/><i>judgment call: judgment calls computed from the facts</i><br/>[ITA 40(2)(g)(ii) income purpose]"]:::judgment
  E1["<b>arm's length sale</b> The taxpayer acquired the debt or right as<br/>consideration for the disposition of capital<br/>property to a person with whom the taxpayer<br/>was dealing at arm's length<br/><i>judgment call: judgment calls computed from the facts</i><br/>[ITA 40(2)(g)(ii) arm's length sale]"]:::judgment
  Y(["subparagraph 40(2)(g)(ii) applies"]):::yes
  N(["subparagraph 40(2)(g)(ii) does not apply"]):::no
  S --> C0
  C0 -->|met| C1
  C0 -->|not met| N
  C1 -->|met| E0
  C1 -->|not met| N
  E0 -->|does not apply| E1
  E0 -->|applies| N
  E1 -->|does not apply| Y
  E1 -->|applies| N
  classDef fact fill:#eeeeee,stroke:#616161,color:#212121
  classDef judgment fill:#ffe0b2,stroke:#ef6c00,color:#e65100
  classDef rule fill:#bbdefb,stroke:#1565c0,color:#0d47a1
  classDef yes fill:#c8e6c9,stroke:#2e7d32,color:#1b5e20
  classDef no fill:#ffcdd2,stroke:#c62828,color:#b71c1c
  classDef start fill:#ffffff,stroke:#212121,color:#212121
```

## Subparagraph 40(2)(g)(iii): personal-use property

```mermaid
flowchart TD
  S(["subparagraph 40(2)(g)(iii) · ITA 40(2)(g)(iii)"]):::start
  C0["<b>loss</b> The taxpayer has a loss from the disposition<br/>[ITA 40(2)(g)(iii) loss]"]:::fact
  C1["<b>personal-use property</b> personal-use property applies<br/>[ITA 54 #quot;personal-use property#quot;]"]:::rule
  E0["<b>listed personal property</b> The property is listed personal property:<br/>personal-use property that is, or is a<br/>portion of or an interest in or right to, a<br/>print, etching, drawing, painting, sculpture<br/>or other similar work of art, jewellery, a<br/>rare folio, rare manuscript or rare book, a<br/>stamp, or a coin<br/>[ITA 40(2)(g)(iii) listed personal property]"]:::fact
  E1["<b>debt under 50(2)</b> The property is a debt referred to in<br/>subsection 50(2)<br/>[ITA 40(2)(g)(iii) debt under 50(2)]"]:::fact
  Y(["subparagraph 40(2)(g)(iii) applies"]):::yes
  N(["subparagraph 40(2)(g)(iii) does not apply"]):::no
  S --> C0
  C0 -->|met| C1
  C0 -->|not met| N
  C1 -->|met| E0
  C1 -->|not met| N
  E0 -->|does not apply| E1
  E0 -->|applies| N
  E1 -->|does not apply| Y
  E1 -->|applies| N
  classDef fact fill:#eeeeee,stroke:#616161,color:#212121
  classDef judgment fill:#ffe0b2,stroke:#ef6c00,color:#e65100
  classDef rule fill:#bbdefb,stroke:#1565c0,color:#0d47a1
  classDef yes fill:#c8e6c9,stroke:#2e7d32,color:#1b5e20
  classDef no fill:#ffcdd2,stroke:#c62828,color:#b71c1c
  classDef start fill:#ffffff,stroke:#212121,color:#212121
```

## Section 54 "personal-use property"

```mermaid
flowchart TD
  S(["personal-use property · ITA 54 #quot;personal-use property#quot;"]):::start
  C0["<b>(a) to (c)</b> The property is personal-use property of the<br/>taxpayer: property used primarily for the<br/>personal use or enjoyment of the taxpayer or<br/>related individuals, a debt owing in respect<br/>of the disposition of personal-use property,<br/>or an option to acquire personal-use<br/>property<br/><i>judgment call: judgment calls computed from the facts</i><br/>[ITA 54 #quot;personal-use property#quot; (a) to (c)]"]:::judgment
  Y(["personal-use property applies"]):::yes
  N(["personal-use property does not apply"]):::no
  S --> C0
  C0 -->|met| Y
  C0 -->|not met| N
  classDef fact fill:#eeeeee,stroke:#616161,color:#212121
  classDef judgment fill:#ffe0b2,stroke:#ef6c00,color:#e65100
  classDef rule fill:#bbdefb,stroke:#1565c0,color:#0d47a1
  classDef yes fill:#c8e6c9,stroke:#2e7d32,color:#1b5e20
  classDef no fill:#ffcdd2,stroke:#c62828,color:#b71c1c
  classDef start fill:#ffffff,stroke:#212121,color:#212121
```

## Subsection 40(3.3): suspended losses

```mermaid
flowchart TD
  S(["subsection 40(3.3) · ITA 40(3.3)"]):::start
  C0["<b>(a)</b> The transferor is a corporation, trust or<br/>partnership<br/>[ITA 40(3.3)(a)]"]:::fact
  C1["<b>(a) property</b> It disposed of a capital property that is<br/>not depreciable property of a prescribed<br/>class<br/>[ITA 40(3.3)(a) property]"]:::fact
  C2["<b>(b), (c)</b> During the period that begins 30 days before<br/>and ends 30 days after the disposition, the<br/>transferor or a person affiliated with it<br/>acquired a property that is, or is identical<br/>to, the particular property, and at the end<br/>of that period the transferor or a person<br/>affiliated with it owns it<br/><i>judgment call: judgment calls computed from the facts</i><br/>[ITA 40(3.3)(b), (c)]"]:::judgment
  E0["<b>(a) surplus carve-out</b> For the purposes of computing a foreign<br/>affiliate's surplus or deficit, the property<br/>is excluded property<br/>[ITA 40(3.3)(a) surplus carve-out]"]:::fact
  E1["<b>(a) dispositions in 54 #quot;superficial loss#quot; (c) to (g)</b> The disposition is one described in<br/>paragraphs (c) to (g) of the definition<br/>#quot;superficial loss#quot; in section 54<br/>[ITA 40(3.3)(a) dispositions in 54 #quot;superficial loss#quot; (c) to (g)]"]:::fact
  Y(["subsection 40(3.3) applies"]):::yes
  N(["subsection 40(3.3) does not apply"]):::no
  S --> C0
  C0 -->|met| C1
  C0 -->|not met| N
  C1 -->|met| C2
  C1 -->|not met| N
  C2 -->|met| E0
  C2 -->|not met| N
  E0 -->|does not apply| E1
  E0 -->|applies| N
  E1 -->|does not apply| Y
  E1 -->|applies| N
  classDef fact fill:#eeeeee,stroke:#616161,color:#212121
  classDef judgment fill:#ffe0b2,stroke:#ef6c00,color:#e65100
  classDef rule fill:#bbdefb,stroke:#1565c0,color:#0d47a1
  classDef yes fill:#c8e6c9,stroke:#2e7d32,color:#1b5e20
  classDef no fill:#ffcdd2,stroke:#c62828,color:#b71c1c
  classDef start fill:#ffffff,stroke:#212121,color:#212121
```

## Subsection 50(2): a personal-use debt that goes bad

```mermaid
flowchart TD
  S(["subsection 50(2) · ITA 50(2)"]):::start
  C0["<b>personal-use property</b> The debt is personal-use property of the<br/>taxpayer<br/>[ITA 50(2) personal-use property]"]:::fact
  C1["<b>arm's length</b> It is owing by a person with whom the<br/>taxpayer deals at arm's length<br/><i>judgment call: judgment calls computed from the facts</i><br/>[ITA 50(2) arm's length]"]:::judgment
  C2["<b>bad debt</b> The taxpayer establishes that it became a<br/>bad debt in the year<br/><i>judgment call: judgment calls computed from the facts</i><br/>[ITA 50(2) bad debt]"]:::judgment
  Y(["subsection 50(2) applies"]):::yes
  N(["subsection 50(2) does not apply"]):::no
  S --> C0
  C0 -->|met| C1
  C0 -->|not met| N
  C1 -->|met| C2
  C1 -->|not met| N
  C2 -->|met| Y
  C2 -->|not met| N
  classDef fact fill:#eeeeee,stroke:#616161,color:#212121
  classDef judgment fill:#ffe0b2,stroke:#ef6c00,color:#e65100
  classDef rule fill:#bbdefb,stroke:#1565c0,color:#0d47a1
  classDef yes fill:#c8e6c9,stroke:#2e7d32,color:#1b5e20
  classDef no fill:#ffcdd2,stroke:#c62828,color:#b71c1c
  classDef start fill:#ffffff,stroke:#212121,color:#212121
```

## Subparagraph 40(2)(g)(iv): transfers to registered plans

```mermaid
flowchart TD
  S(["subparagraph 40(2)(g)(iv) · ITA 40(2)(g)(iv)"]):::start
  C0["<b>loss</b> The taxpayer has a loss from the disposition<br/>[ITA 40(2)(g)(iv) loss]"]:::fact
  C1["<b>(A) or (B)</b> clause (A) or (B) applies<br/>[ITA 40(2)(g)(iv)]"]:::rule
  Y(["subparagraph 40(2)(g)(iv) applies"]):::yes
  N(["subparagraph 40(2)(g)(iv) does not apply"]):::no
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

## Clause 40(2)(g)(iv)(A)

```mermaid
flowchart TD
  S(["clause 40(2)(g)(iv)(A) · ITA 40(2)(g)(iv)(A)"]):::start
  C0["<b>trust</b> The property was disposed of to a trust<br/>governed by a deferred profit sharing plan,<br/>an employees profit sharing plan, a FHSA, a<br/>registered disability savings plan, a<br/>registered retirement income fund or a TFSA<br/>[ITA 40(2)(g)(iv)(A) trust]"]:::fact
  C1["<b>beneficiary</b> The taxpayer is, or immediately after the<br/>disposition becomes, a beneficiary under it<br/>[ITA 40(2)(g)(iv)(A) beneficiary]"]:::fact
  Y(["clause 40(2)(g)(iv)(A) applies"]):::yes
  N(["clause 40(2)(g)(iv)(A) does not apply"]):::no
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

## Clause 40(2)(g)(iv)(B)

```mermaid
flowchart TD
  S(["clause 40(2)(g)(iv)(B) · ITA 40(2)(g)(iv)(B)"]):::start
  C0["<b>trust</b> The property was disposed of to a trust<br/>governed by a registered retirement savings<br/>plan<br/>[ITA 40(2)(g)(iv)(B) trust]"]:::fact
  C1["<b>annuitant</b> The taxpayer or the taxpayer's spouse or<br/>common-law partner is an annuitant under it,<br/>or becomes one within 60 days after the end<br/>of the taxation year<br/>[ITA 40(2)(g)(iv)(B) annuitant]"]:::fact
  Y(["clause 40(2)(g)(iv)(B) applies"]):::yes
  N(["clause 40(2)(g)(iv)(B) does not apply"]):::no
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


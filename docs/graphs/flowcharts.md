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

## Subsection 40(3.6): a share disposed of to an affiliated corporation

```mermaid
flowchart TD
  S(["subsection 40(3.6) · ITA 40(3.6)"]):::start
  C0["<b>share</b> The taxpayer disposed of a share of a class<br/>of the capital stock of the corporation to<br/>that corporation<br/>[ITA 40(3.6) share]"]:::fact
  C1["<b>affiliated immediately after</b> affiliation under subsection 251.1(1)<br/>applies<br/>[ITA 251.1(1)]"]:::rule
  E0["<b>distress preferred share</b> The share is a distress preferred share<br/>[ITA 40(3.6) distress preferred share]"]:::fact
  E1["<b>surplus carve-out</b> For the purposes of computing a foreign<br/>affiliate's surplus or deficit, the share is<br/>excluded property<br/>[ITA 40(3.6) surplus carve-out]"]:::fact
  Y(["subsection 40(3.6) applies"]):::yes
  N(["subsection 40(3.6) does not apply"]):::no
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

## Paragraph 40(2)(e.1): a debt within a related group

```mermaid
flowchart TD
  S(["paragraph 40(2)(e.1) · ITA 40(2)(e.1)"]):::start
  C0["<b>obligation</b> The taxpayer disposed of an obligation that,<br/>immediately after, was payable by another<br/>person or partnership to the person or<br/>partnership it was disposed of to<br/>[ITA 40(2)(e.1) obligation]"]:::fact
  C1["<b>related</b> the three related to each other applies<br/>[ITA 40(2)(e.1); 251(2)]"]:::rule
  E0["<b>surplus carve-out</b> For the purposes of computing a foreign<br/>affiliate's surplus or deficit, the<br/>obligation is excluded property<br/>[ITA 40(2)(e.1) surplus carve-out]"]:::fact
  Y(["paragraph 40(2)(e.1) applies"]):::yes
  N(["paragraph 40(2)(e.1) does not apply"]):::no
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

## Section 54 "principal residence", for an individual and a year

```mermaid
flowchart TD
  S(["the definition #quot;principal residence#quot; · ITA 54 #quot;principal residence#quot;"]):::start
  C0["<b>housing unit</b> The property is a housing unit, a leasehold<br/>interest in one, or a qualifying<br/>co-operative housing share<br/>[ITA 54 #quot;principal residence#quot; housing unit]"]:::fact
  C1["<b>owned</b> The taxpayer owned it in the year<br/>[ITA 54 #quot;principal residence#quot; owned]"]:::fact
  C2["<b>(a), (b)</b> It was ordinarily inhabited in the year by<br/>the taxpayer, the taxpayer's spouse or<br/>common-law partner or former one, or a child<br/>of the taxpayer, or an election under 45(2)<br/>or 45(3) covers the year<br/><i>judgment call: judgment calls computed from the facts</i><br/>[ITA 54 #quot;principal residence#quot; (a), (b)]"]:::judgment
  C3["<b>(c) designation</b> The taxpayer designated it as principal<br/>residence for the year<br/>[ITA 54 #quot;principal residence#quot; (c) designation]"]:::fact
  E0["<b>(c) other designations</b> Another property was designated for the year<br/>by the taxpayer or a member of the<br/>taxpayer's family unit<br/>[ITA 54 #quot;principal residence#quot; (c) other designations]"]:::fact
  E1["<b>(d)</b> It was not ordinarily inhabited in the year,<br/>and it would be the principal residence for<br/>the year solely because of a 45(2) or 45(3)<br/>election, as it would have been for 4 or<br/>more preceding years<br/><i>judgment call: judgment calls computed from the facts</i><br/>[ITA 54 #quot;principal residence#quot; (d)]"]:::judgment
  Y(["the definition #quot;principal residence#quot; applies"]):::yes
  N(["the definition #quot;principal residence#quot; does not apply"]):::no
  S --> C0
  C0 -->|met| C1
  C0 -->|not met| N
  C1 -->|met| C2
  C1 -->|not met| N
  C2 -->|met| C3
  C2 -->|not met| N
  C3 -->|met| E0
  C3 -->|not met| N
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

## Subsection 73(1): the spousal rollover

```mermaid
flowchart TD
  S(["subsection 73(1) · ITA 73(1)"]):::start
  C0["<b>capital property of an individual</b> The property is capital property of an<br/>individual who is not a trust<br/>[ITA 73(1) capital property of an individual]"]:::fact
  C1["<b>(1.01)</b> (1.01) applies<br/>[ITA 73(1.01)]"]:::rule
  C2["<b>resident</b> Both the individual and the transferee are<br/>resident in Canada at the time<br/>[ITA 73(1) resident]"]:::fact
  E0["<b>election</b> The individual elects that subsection 73(1)<br/>not apply<br/>[ITA 73(1) election]"]:::fact
  Y(["subsection 73(1) applies"]):::yes
  N(["subsection 73(1) does not apply"]):::no
  S --> C0
  C0 -->|met| C1
  C0 -->|not met| N
  C1 -->|met| C2
  C1 -->|not met| N
  C2 -->|met| E0
  C2 -->|not met| N
  E0 -->|does not apply| Y
  E0 -->|applies| N
  classDef fact fill:#eeeeee,stroke:#616161,color:#212121
  classDef judgment fill:#ffe0b2,stroke:#ef6c00,color:#e65100
  classDef rule fill:#bbdefb,stroke:#1565c0,color:#0d47a1
  classDef yes fill:#c8e6c9,stroke:#2e7d32,color:#1b5e20
  classDef no fill:#ffcdd2,stroke:#c62828,color:#b71c1c
  classDef start fill:#ffffff,stroke:#212121,color:#212121
```

## Subsection 70(6): rollover on death

```mermaid
flowchart TD
  S(["subsection 70(6) · ITA 70(6)"]):::start
  C0["<b>resident</b> The deceased was resident in Canada<br/>immediately before death<br/>[ITA 70(6) resident]"]:::fact
  C1["<b>(a), (b)</b> The property was transferred, as a<br/>consequence of the death, to the spouse or<br/>common-law partner, resident in Canada<br/>immediately before the death, or to a<br/>resident testamentary trust under which the<br/>spouse or common-law partner has all the<br/>income for life and no one else may use the<br/>income or capital<br/>[ITA 70(6)(a), (b)]"]:::fact
  C2["<b>vesting</b> It can be shown that the property vested<br/>indefeasibly in the spouse or trust within<br/>36 months after the death<br/>[ITA 70(6) vesting]"]:::fact
  E0["<b>election under 70(6.2)</b> The legal representative elects under<br/>subsection 70(6.2) that subsection 70(6) not<br/>apply to the property<br/>[ITA 70(6) election under 70(6.2)]"]:::fact
  Y(["subsection 70(6) applies"]):::yes
  N(["subsection 70(6) does not apply"]):::no
  S --> C0
  C0 -->|met| C1
  C0 -->|not met| N
  C1 -->|met| C2
  C1 -->|not met| N
  C2 -->|met| E0
  C2 -->|not met| N
  E0 -->|does not apply| Y
  E0 -->|applies| N
  classDef fact fill:#eeeeee,stroke:#616161,color:#212121
  classDef judgment fill:#ffe0b2,stroke:#ef6c00,color:#e65100
  classDef rule fill:#bbdefb,stroke:#1565c0,color:#0d47a1
  classDef yes fill:#c8e6c9,stroke:#2e7d32,color:#1b5e20
  classDef no fill:#ffcdd2,stroke:#c62828,color:#b71c1c
  classDef start fill:#ffffff,stroke:#212121,color:#212121
```

## Subsection 74.5(1): the fair market value exception to attribution

```mermaid
flowchart TD
  S(["subsection 74.5(1) · ITA 74.5(1)"]):::start
  C0["<b>(a)</b> The fair market value of the transferred<br/>property did not exceed the fair market<br/>value of the consideration<br/>[ITA 74.5(1)(a)]"]:::fact
  C1["<b>(b)</b> Any indebtedness taken as consideration bore<br/>interest at least at the lesser of the<br/>prescribed and an arm's length rate, paid<br/>within 30 days after each year-end<br/>[ITA 74.5(1)(b)]"]:::fact
  C2["<b>(c)</b> The transferor elected not to have<br/>subsection 73(1) apply (or the transfer was<br/>not to a spouse or common-law partner)<br/>[ITA 74.5(1)(c)]"]:::fact
  Y(["subsection 74.5(1) applies"]):::yes
  N(["subsection 74.5(1) does not apply"]):::no
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

## Subsection 45(1): change in use, with the elections

```mermaid
flowchart TD
  S(["subsection 45(1) · ITA 45(1)"]):::start
  C0["<b>(a), (c)</b> The use regularly made of the property<br/>changed between gaining or producing income<br/>and other purposes<br/>[ITA 45(1)(a), (c)]"]:::fact
  E0["<b>45(2)</b> 45(2) applies<br/>[ITA 45(2)(a), (b)]"]:::rule
  E1["<b>45(3)</b> 45(3) applies<br/>[ITA 45(3), (4)]"]:::rule
  Y(["subsection 45(1) applies"]):::yes
  N(["subsection 45(1) does not apply"]):::no
  S --> C0
  C0 -->|met| E0
  C0 -->|not met| N
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

## Subsection 85(1): transfer of property to a corporation

```mermaid
flowchart TD
  S(["subsection 85(1) · ITA 85(1)"]):::start
  C0["<b>eligible property</b> The property is eligible property (85(1.1))<br/>[ITA 85(1) eligible property]"]:::fact
  C1["<b>taxable Canadian corporation</b> It was disposed of to a taxable Canadian<br/>corporation<br/>[ITA 85(1) taxable Canadian corporation]"]:::fact
  C2["<b>shares</b> The consideration includes shares of the<br/>capital stock of the corporation<br/>[ITA 85(1) shares]"]:::fact
  C3["<b>election</b> The taxpayer and the corporation jointly<br/>elected in prescribed form and in time<br/>(85(6))<br/>[ITA 85(1) election]"]:::fact
  Y(["subsection 85(1) applies"]):::yes
  N(["subsection 85(1) does not apply"]):::no
  S --> C0
  C0 -->|met| C1
  C0 -->|not met| N
  C1 -->|met| C2
  C1 -->|not met| N
  C2 -->|met| C3
  C2 -->|not met| N
  C3 -->|met| Y
  C3 -->|not met| N
  classDef fact fill:#eeeeee,stroke:#616161,color:#212121
  classDef judgment fill:#ffe0b2,stroke:#ef6c00,color:#e65100
  classDef rule fill:#bbdefb,stroke:#1565c0,color:#0d47a1
  classDef yes fill:#c8e6c9,stroke:#2e7d32,color:#1b5e20
  classDef no fill:#ffcdd2,stroke:#c62828,color:#b71c1c
  classDef start fill:#ffffff,stroke:#212121,color:#212121
```

## Subsection 84.1(1): shares sold to a non-arm's length corporation

```mermaid
flowchart TD
  S(["subsection 84.1(1) · ITA 84.1(1)"]):::start
  C0["<b>taxpayer</b> The taxpayer is resident in Canada and is<br/>not a corporation<br/>[ITA 84.1(1) taxpayer]"]:::fact
  C1["<b>subject shares</b> The subject shares are capital property of<br/>the taxpayer, of a corporation resident in<br/>Canada<br/>[ITA 84.1(1) subject shares]"]:::fact
  C2["<b>not at arm's length</b> The taxpayer does not deal at arm's length<br/>with the purchaser corporation (or is deemed<br/>not to by 84.1(2)(b) or (d))<br/><i>judgment call: judgment calls computed from the facts</i><br/>[ITA 84.1(1) not at arm's length]"]:::judgment
  C3["<b>connected</b> Immediately after, the subject corporation<br/>is connected with the purchaser corporation<br/>(186(4))<br/>[ITA 84.1(1) connected]"]:::fact
  Y(["subsection 84.1(1) applies"]):::yes
  N(["subsection 84.1(1) does not apply"]):::no
  S --> C0
  C0 -->|met| C1
  C0 -->|not met| N
  C1 -->|met| C2
  C1 -->|not met| N
  C2 -->|met| C3
  C2 -->|not met| N
  C3 -->|met| Y
  C3 -->|not met| N
  classDef fact fill:#eeeeee,stroke:#616161,color:#212121
  classDef judgment fill:#ffe0b2,stroke:#ef6c00,color:#e65100
  classDef rule fill:#bbdefb,stroke:#1565c0,color:#0d47a1
  classDef yes fill:#c8e6c9,stroke:#2e7d32,color:#1b5e20
  classDef no fill:#ffcdd2,stroke:#c62828,color:#b71c1c
  classDef start fill:#ffffff,stroke:#212121,color:#212121
```

## Section 110.6 "qualified small business corporation share"

```mermaid
flowchart TD
  S(["the definition #quot;qualified small business corporation share#quot; · ITA 110.6(1) #quot;qualified small business corporation share#quot;"]):::start
  C0["<b>(a)</b> At the determination time it is a share of a<br/>small business corporation owned by the<br/>individual, the individual's spouse or<br/>common-law partner, or a related partnership<br/><i>judgment call: judgment calls computed from the facts</i><br/>[ITA 110.6(1) #quot;qualified small business corporation share#quot; (a)]"]:::judgment
  C1["<b>(b)</b> Throughout the 24 months before, no one but<br/>the individual or a related person or<br/>partnership owned it<br/>[ITA 110.6(1) #quot;qualified small business corporation share#quot; (b)]"]:::fact
  C2["<b>(c)</b> Throughout the part of the 24 months it was<br/>so owned, the corporation was a<br/>Canadian-controlled private corporation more<br/>than 50% of whose assets' value was in<br/>active business assets or qualifying<br/>connected shares and debt<br/>[ITA 110.6(1) #quot;qualified small business corporation share#quot; (c)]"]:::fact
  C3["<b>(e)</b> Any share it was substituted for met<br/>paragraphs (b) and (c) up to the<br/>substitution<br/>[ITA 110.6(1) #quot;qualified small business corporation share#quot; (e)]"]:::fact
  Y(["the definition #quot;qualified small business corporation share#quot; applies"]):::yes
  N(["the definition #quot;qualified small business corporation share#quot; does not apply"]):::no
  S --> C0
  C0 -->|met| C1
  C0 -->|not met| N
  C1 -->|met| C2
  C1 -->|not met| N
  C2 -->|met| C3
  C2 -->|not met| N
  C3 -->|met| Y
  C3 -->|not met| N
  classDef fact fill:#eeeeee,stroke:#616161,color:#212121
  classDef judgment fill:#ffe0b2,stroke:#ef6c00,color:#e65100
  classDef rule fill:#bbdefb,stroke:#1565c0,color:#0d47a1
  classDef yes fill:#c8e6c9,stroke:#2e7d32,color:#1b5e20
  classDef no fill:#ffcdd2,stroke:#c62828,color:#b71c1c
  classDef start fill:#ffffff,stroke:#212121,color:#212121
```

## Paragraph 251.2(2)(a), with 256(7)(a): loss restriction events

```mermaid
flowchart TD
  S(["paragraph 251.2(2)(a) · ITA 251.2(2)(a)"]):::start
  C0["<b>corporation</b> The taxpayer is a corporation<br/>[ITA 251.2(2)(a) corporation]"]:::fact
  C1["<b>control acquired</b> Control of the corporation is acquired by a<br/>person or group of persons: one controls it<br/>immediately after who did not immediately<br/>before<br/><i>judgment call: judgment calls computed from the facts</i><br/>[ITA 251.2(2)(a) control acquired]"]:::judgment
  E0["<b>256(7)(a)(i)(A)</b> 256(7)(a)(i)(A) applies<br/>[ITA 256(7)(a)(i)(A)]"]:::rule
  E1["<b>256(7)(a)(i)(B)</b> 256(7)(a)(i)(B) applies<br/>[ITA 256(7)(a)(i)(B)]"]:::rule
  E2["<b>256(7)(a)(i)(C), (D)</b> 256(7)(a)(i)(C), (D) applies<br/>[ITA 256(7)(a)(i)(C), (D)]"]:::rule
  E3["<b>256(7)(a)(ii)</b> 256(7)(a)(ii) applies<br/>[ITA 256(7)(a)(ii)]"]:::rule
  E4["<b>256(7)(a)(iii)</b> 256(7)(a)(iii) applies<br/>[ITA 256(7)(a)(iii)]"]:::rule
  Y(["paragraph 251.2(2)(a) applies"]):::yes
  N(["paragraph 251.2(2)(a) does not apply"]):::no
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
  E4 -->|does not apply| Y
  E4 -->|applies| N
  classDef fact fill:#eeeeee,stroke:#616161,color:#212121
  classDef judgment fill:#ffe0b2,stroke:#ef6c00,color:#e65100
  classDef rule fill:#bbdefb,stroke:#1565c0,color:#0d47a1
  classDef yes fill:#c8e6c9,stroke:#2e7d32,color:#1b5e20
  classDef no fill:#ffcdd2,stroke:#c62828,color:#b71c1c
  classDef start fill:#ffffff,stroke:#212121,color:#212121
```

## Subsections 74.1(1) and (2): income attribution

```mermaid
flowchart TD
  S(["subsection 74.1(1) or (2) · ITA 74.1(1), (2)"]):::start
  C0["<b>recipient</b> The property was transferred or lent to the<br/>individual's spouse or common-law partner,<br/>or to a minor not at arm's length with the<br/>individual or a niece or nephew<br/>[ITA 74.1(1), (2) recipient]"]:::fact
  E0["<b>turned 18</b> The minor attained 18 years of age before<br/>the end of the year (74.1(2))<br/>[ITA 74.1(1), (2) turned 18]"]:::fact
  E1["<b>74.5(1)</b> 74.5(1) applies<br/>[ITA 74.5(1)]"]:::rule
  E2["<b>74.5(2)</b> 74.5(2) applies<br/>[ITA 74.5(2)]"]:::rule
  Y(["subsection 74.1(1) or (2) applies"]):::yes
  N(["subsection 74.1(1) or (2) does not apply"]):::no
  S --> C0
  C0 -->|met| E0
  C0 -->|not met| N
  E0 -->|does not apply| E1
  E0 -->|applies| N
  E1 -->|does not apply| E2
  E1 -->|applies| N
  E2 -->|does not apply| Y
  E2 -->|applies| N
  classDef fact fill:#eeeeee,stroke:#616161,color:#212121
  classDef judgment fill:#ffe0b2,stroke:#ef6c00,color:#e65100
  classDef rule fill:#bbdefb,stroke:#1565c0,color:#0d47a1
  classDef yes fill:#c8e6c9,stroke:#2e7d32,color:#1b5e20
  classDef no fill:#ffcdd2,stroke:#c62828,color:#b71c1c
  classDef start fill:#ffffff,stroke:#212121,color:#212121
```

## Subsection 55(2): dividends over safe income

```mermaid
flowchart TD
  S(["subsection 55(2) · ITA 55(2)"]):::start
  C0["<b>(2.1) recipient</b> The dividend recipient is a corporation<br/>resident in Canada<br/>[ITA 55(2)(2.1) recipient]"]:::fact
  C1["<b>(2.1)(a)</b> (2.1)(a) applies<br/>[ITA 55(2.1)(a)]"]:::rule
  C2["<b>(2.1)(b)</b> (2.1)(b) applies<br/>[ITA 55(2.1)(b)]"]:::rule
  C3["<b>(2.1)(c), (5)(f)</b> (2.1)(c), (5)(f) applies<br/>[ITA 55(2.1)(c); 55(5)(f)]"]:::rule
  E0["<b>(3)(a)</b> (3)(a) applies<br/>[ITA 55(3)(a)]"]:::rule
  E1["<b>(3)(b)</b> (3)(b) applies<br/>[ITA 55(3)(b)]"]:::rule
  Y(["subsection 55(2) applies"]):::yes
  N(["subsection 55(2) does not apply"]):::no
  S --> C0
  C0 -->|met| C1
  C0 -->|not met| N
  C1 -->|met| C2
  C1 -->|not met| N
  C2 -->|met| C3
  C2 -->|not met| N
  C3 -->|met| E0
  C3 -->|not met| N
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

## Subsection 86(1): share exchanges

```mermaid
flowchart TD
  S(["subsection 86(1) · ITA 86(1)"]):::start
  C0["<b>reorganization</b> The shares were disposed of in the course of<br/>a reorganization of the capital of the<br/>corporation<br/>[ITA 86(1) reorganization]"]:::fact
  C1["<b>old shares</b> They were capital property, all the shares<br/>of their class the taxpayer owned<br/>[ITA 86(1) old shares]"]:::fact
  C2["<b>new shares</b> Property receivable for them includes other<br/>shares of the corporation<br/>[ITA 86(1) new shares]"]:::fact
  E0["<b>86(3)</b> 86(3) applies<br/>[ITA 86(3)]"]:::rule
  Y(["subsection 86(1) applies"]):::yes
  N(["subsection 86(1) does not apply"]):::no
  S --> C0
  C0 -->|met| C1
  C0 -->|not met| N
  C1 -->|met| C2
  C1 -->|not met| N
  C2 -->|met| E0
  C2 -->|not met| N
  E0 -->|does not apply| Y
  E0 -->|applies| N
  classDef fact fill:#eeeeee,stroke:#616161,color:#212121
  classDef judgment fill:#ffe0b2,stroke:#ef6c00,color:#e65100
  classDef rule fill:#bbdefb,stroke:#1565c0,color:#0d47a1
  classDef yes fill:#c8e6c9,stroke:#2e7d32,color:#1b5e20
  classDef no fill:#ffcdd2,stroke:#c62828,color:#b71c1c
  classDef start fill:#ffffff,stroke:#212121,color:#212121
```

## Subsection 44(1): replacement property

```mermaid
flowchart TD
  S(["subsection 44(1) · ITA 44(1)"]):::start
  C0["<b>former property</b> The former property is capital property (not<br/>a share) whose proceeds are compensation for<br/>its loss, destruction or expropriation, or a<br/>former business property<br/>[ITA 44(1) former property]"]:::fact
  C1["<b>(c), (d)</b> A replacement property was acquired in time<br/>(by the end of the second taxation year<br/>after the initial year for (a), the first<br/>for (b))<br/>[ITA 44(1)(c), (d)]"]:::fact
  C2["<b>election</b> The taxpayer elects under subsection 44(1)<br/>[ITA 44(1) election]"]:::fact
  Y(["subsection 44(1) applies"]):::yes
  N(["subsection 44(1) does not apply"]):::no
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

## Subsection 186(4): connected corporations

```mermaid
flowchart TD
  S(["subsection 186(4) · ITA 186(4)"]):::start
  C0["<b>(a) or (b)</b> The payer is controlled by the particular<br/>corporation (de jure, or by 186(2) with<br/>persons not at arm's length with it), or the<br/>particular corporation owns more than 10% of<br/>its voting shares and more than 10% of the<br/>value of all its shares<br/>[ITA 186(4)(a) or (b)]"]:::fact
  Y(["subsection 186(4) applies"]):::yes
  N(["subsection 186(4) does not apply"]):::no
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

## Subsection 88(1): winding up a subsidiary

```mermaid
flowchart TD
  S(["subsection 88(1) · ITA 88(1)"]):::start
  C0["<b>taxable Canadian corporations</b> The subsidiary and the parent are taxable<br/>Canadian corporations<br/>[ITA 88(1) taxable Canadian corporations]"]:::fact
  C1["<b>90%</b> The parent owned at least 90% of the issued<br/>shares of each class of the subsidiary<br/>immediately before the winding-up<br/>[ITA 88(1) 90%]"]:::fact
  C2["<b>minority</b> The other shares were owned by persons<br/>dealing at arm's length with the parent<br/>[ITA 88(1) minority]"]:::fact
  Y(["subsection 88(1) applies"]):::yes
  N(["subsection 88(1) does not apply"]):::no
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

## Subsection 87(1): amalgamation

```mermaid
flowchart TD
  S(["subsection 87(1) · ITA 87(1)"]):::start
  C0["<b>predecessors</b> Each merging corporation was a taxable<br/>Canadian corporation immediately before the<br/>merger<br/>[ITA 87(1) predecessors]"]:::fact
  C1["<b>(a)</b> All of the predecessors' property (other<br/>than intercompany receivables and shares)<br/>becomes the new corporation's<br/>[ITA 87(1)(a)]"]:::fact
  C2["<b>(b)</b> All of their liabilities (other than<br/>intercompany payables) become the new<br/>corporation's<br/>[ITA 87(1)(b)]"]:::fact
  C3["<b>(c)</b> All of their shareholders (other than<br/>predecessors) receive shares of the new<br/>corporation<br/>[ITA 87(1)(c)]"]:::fact
  C4["<b>not a purchase or winding-up</b> The property is not acquired by a purchase<br/>or on a winding-up<br/>[ITA 87(1) not a purchase or winding-up]"]:::fact
  Y(["subsection 87(1) applies"]):::yes
  N(["subsection 87(1) does not apply"]):::no
  S --> C0
  C0 -->|met| C1
  C0 -->|not met| N
  C1 -->|met| C2
  C1 -->|not met| N
  C2 -->|met| C3
  C2 -->|not met| N
  C3 -->|met| C4
  C3 -->|not met| N
  C4 -->|met| Y
  C4 -->|not met| N
  classDef fact fill:#eeeeee,stroke:#616161,color:#212121
  classDef judgment fill:#ffe0b2,stroke:#ef6c00,color:#e65100
  classDef rule fill:#bbdefb,stroke:#1565c0,color:#0d47a1
  classDef yes fill:#c8e6c9,stroke:#2e7d32,color:#1b5e20
  classDef no fill:#ffcdd2,stroke:#c62828,color:#b71c1c
  classDef start fill:#ffffff,stroke:#212121,color:#212121
```

## Subsection 39(4): the Canadian securities election

```mermaid
flowchart TD
  S(["subsection 39(4) · ITA 39(4)"]):::start
  C0["<b>(6) Canadian security</b> The property is a Canadian security<br/>[ITA 39(4)(6) Canadian security]"]:::fact
  C1["<b>election</b> The taxpayer elected under subsection 39(4)<br/>for this or an earlier year<br/>[ITA 39(4) election]"]:::fact
  E0["<b>(5)</b> The taxpayer is a trader or dealer in<br/>securities, a financial institution, a<br/>money-lending corporation, or a non-resident<br/><i>judgment call: judgment calls computed from the facts</i><br/>[ITA 39(4)(5)]"]:::judgment
  Y(["subsection 39(4) applies"]):::yes
  N(["subsection 39(4) does not apply"]):::no
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

## Subsection 50(1): bad debts and worthless shares

```mermaid
flowchart TD
  S(["subsection 50(1) · ITA 50(1)"]):::start
  C0["<b>(a), (b)</b> The debt is established to have become bad<br/>in the year, or the corporation became<br/>bankrupt, was wound up insolvent, or is<br/>insolvent, dormant, its shares worthless and<br/>its dissolution expected<br/><i>judgment call: judgment calls computed from the facts</i><br/>[ITA 50(1)(a), (b)]"]:::judgment
  C1["<b>held</b> The taxpayer held it at the end of the year<br/>[ITA 50(1) held]"]:::fact
  C2["<b>not personal-use</b> It did not arise from a disposition of<br/>personal-use property<br/>[ITA 50(1) not personal-use]"]:::fact
  C3["<b>election</b> The taxpayer elects to have subsection 50(1)<br/>apply<br/>[ITA 50(1) election]"]:::fact
  Y(["subsection 50(1) applies"]):::yes
  N(["subsection 50(1) does not apply"]):::no
  S --> C0
  C0 -->|met| C1
  C0 -->|not met| N
  C1 -->|met| C2
  C1 -->|not met| N
  C2 -->|met| C3
  C2 -->|not met| N
  C3 -->|met| Y
  C3 -->|not met| N
  classDef fact fill:#eeeeee,stroke:#616161,color:#212121
  classDef judgment fill:#ffe0b2,stroke:#ef6c00,color:#e65100
  classDef rule fill:#bbdefb,stroke:#1565c0,color:#0d47a1
  classDef yes fill:#c8e6c9,stroke:#2e7d32,color:#1b5e20
  classDef no fill:#ffcdd2,stroke:#c62828,color:#b71c1c
  classDef start fill:#ffffff,stroke:#212121,color:#212121
```

## Subsection 74.4(2): corporate attribution

```mermaid
flowchart TD
  S(["subsection 74.4(2) · ITA 74.4(2)"]):::start
  C0["<b>main purpose</b> One of the main purposes of the transfer or<br/>loan may reasonably be considered to be to<br/>reduce the individual's income and benefit a<br/>designated person<br/><i>judgment call: judgment calls computed from the facts</i><br/>[ITA 74.4(2) main purpose]"]:::judgment
  C1["<b>(a)</b> A designated person (a spouse or common-law<br/>partner, or a minor child, niece or nephew)<br/>is a specified shareholder of the<br/>corporation<br/>[ITA 74.4(2)(a)]"]:::fact
  C2["<b>(b)</b> The individual was resident in Canada<br/>[ITA 74.4(2)(b)]"]:::fact
  E0["<b>(c)</b> The corporation was a small business<br/>corporation throughout the period<br/><i>judgment call: judgment calls computed from the facts</i><br/>[ITA 74.4(2)(c)]"]:::judgment
  Y(["subsection 74.4(2) applies"]):::yes
  N(["subsection 74.4(2) does not apply"]):::no
  S --> C0
  C0 -->|met| C1
  C0 -->|not met| N
  C1 -->|met| C2
  C1 -->|not met| N
  C2 -->|met| E0
  C2 -->|not met| N
  E0 -->|does not apply| Y
  E0 -->|applies| N
  classDef fact fill:#eeeeee,stroke:#616161,color:#212121
  classDef judgment fill:#ffe0b2,stroke:#ef6c00,color:#e65100
  classDef rule fill:#bbdefb,stroke:#1565c0,color:#0d47a1
  classDef yes fill:#c8e6c9,stroke:#2e7d32,color:#1b5e20
  classDef no fill:#ffcdd2,stroke:#c62828,color:#b71c1c
  classDef start fill:#ffffff,stroke:#212121,color:#212121
```

## Subsection 15(2): shareholder loans

```mermaid
flowchart TD
  S(["subsection 15(2) · ITA 15(2)"]):::start
  C0["<b>(a)–(c)</b> The borrower is a shareholder (or connected<br/>with one, or a partner or beneficiary of<br/>one), not a corporation resident in Canada<br/>[ITA 15(2)(a)–(c)]"]:::fact
  C1["<b>loan</b> It received a loan from the corporation, a<br/>related corporation or a partnership of<br/>either, not a pertinent loan<br/>[ITA 15(2) loan]"]:::fact
  E0["<b>15(2.6)</b> 15(2.6) applies<br/>[ITA 15(2.6)]"]:::rule
  Y(["subsection 15(2) applies"]):::yes
  N(["subsection 15(2) does not apply"]):::no
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


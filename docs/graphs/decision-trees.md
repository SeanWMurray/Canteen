# Decision trees over the judgment calls

> Generated from the Lean sources by `scripts/blueprint.sh`. Do not edit by hand.

Every way of answering a rule's judgment calls, with the conclusion and its risk at each leaf. A tree whose leaves all agree is a judgment call that doesn't matter.

## Spouse repurchase: are the shares identical?

```mermaid
flowchart LR
  B{"J-ID<br/>Are the spouse's 100 common shares<br/>of ABC Ltd. identical to the 100<br/>common shares of ABC Ltd. the<br/>taxpayer sold?"}:::judgment
  B -->|"yes (risk low)"| By
  B -->|"no (risk high)"| Bn
  By(["The superficial loss rule applies<br/>risk: low"]):::yes
  Bn(["The superficial loss rule does not apply<br/>risk: high"]):::no
  classDef fact fill:#eeeeee,stroke:#616161,color:#212121
  classDef judgment fill:#ffe0b2,stroke:#ef6c00,color:#e65100
  classDef rule fill:#bbdefb,stroke:#1565c0,color:#0d47a1
  classDef yes fill:#c8e6c9,stroke:#2e7d32,color:#1b5e20
  classDef no fill:#ffcdd2,stroke:#c62828,color:#b71c1c
  classDef start fill:#ffffff,stroke:#212121,color:#212121
```

## Sibling and day-31 repurchase: two judgment calls, one answer

```mermaid
flowchart LR
  B{"J-SIB<br/>Are the sibling's shares identical<br/>to the shares sold?"}:::judgment
  B -->|"yes (risk low)"| By
  B -->|"no (risk high)"| Bn
  By{"J-LATE<br/>Are the shares bought back identical<br/>to the shares sold?"}:::judgment
  By -->|"yes (risk low)"| Byy
  By -->|"no (risk high)"| Byn
  Byy(["The superficial loss rule does not apply<br/>risk: low"]):::no
  Byn(["The superficial loss rule does not apply<br/>risk: low"]):::no
  Bn{"J-LATE<br/>Are the shares bought back identical<br/>to the shares sold?"}:::judgment
  Bn -->|"yes (risk low)"| Bny
  Bn -->|"no (risk high)"| Bnn
  Bny(["The superficial loss rule does not apply<br/>risk: low"]):::no
  Bnn(["The superficial loss rule does not apply<br/>risk: low"]):::no
  classDef fact fill:#eeeeee,stroke:#616161,color:#212121
  classDef judgment fill:#ffe0b2,stroke:#ef6c00,color:#e65100
  classDef rule fill:#bbdefb,stroke:#1565c0,color:#0d47a1
  classDef yes fill:#c8e6c9,stroke:#2e7d32,color:#1b5e20
  classDef no fill:#ffcdd2,stroke:#c62828,color:#b71c1c
  classDef start fill:#ffffff,stroke:#212121,color:#212121
```

## TFSA contribution: paragraph 40(2)(g) on both answers to J-AFF

```mermaid
flowchart LR
  B{"J-AFF<br/>Is the trust governed by the<br/>taxpayer's TFSA affiliated with the<br/>taxpayer under one of paragraphs<br/>251.1(1)(b) to (g)?"}:::judgment
  B -->|"yes (risk medium)"| By
  B -->|"no (risk medium)"| Bn
  By(["Paragraph 40(2)(g) applies<br/>risk: low"]):::yes
  Bn(["Paragraph 40(2)(g) applies<br/>risk: low"]):::yes
  classDef fact fill:#eeeeee,stroke:#616161,color:#212121
  classDef judgment fill:#ffe0b2,stroke:#ef6c00,color:#e65100
  classDef rule fill:#bbdefb,stroke:#1565c0,color:#0d47a1
  classDef yes fill:#c8e6c9,stroke:#2e7d32,color:#1b5e20
  classDef no fill:#ffcdd2,stroke:#c62828,color:#b71c1c
  classDef start fill:#ffffff,stroke:#212121,color:#212121
```

## A debt sold at a loss: income purpose and arm's length dealing both judged

```mermaid
flowchart LR
  B{"J-PURPOSE<br/>Was the debt acquired to gain or<br/>produce income from a business or<br/>property?"}:::judgment
  B -->|"yes (risk medium)"| By
  B -->|"no (risk medium)"| Bn
  By{"J-ARM<br/>Was the taxpayer dealing at arm's<br/>length with the buyer?"}:::judgment
  By -->|"yes (risk medium)"| Byy
  By -->|"no (risk low)"| Byn
  Byy(["Subparagraph 40(2)(g)(ii) does not apply<br/>risk: medium"]):::no
  Byn(["Subparagraph 40(2)(g)(ii) does not apply<br/>risk: medium"]):::no
  Bn{"J-ARM<br/>Was the taxpayer dealing at arm's<br/>length with the buyer?"}:::judgment
  Bn -->|"yes (risk medium)"| Bny
  Bn -->|"no (risk low)"| Bnn
  Bny(["Subparagraph 40(2)(g)(ii) does not apply<br/>risk: medium"]):::no
  Bnn(["Subparagraph 40(2)(g)(ii) applies<br/>risk: medium"]):::yes
  classDef fact fill:#eeeeee,stroke:#616161,color:#212121
  classDef judgment fill:#ffe0b2,stroke:#ef6c00,color:#e65100
  classDef rule fill:#bbdefb,stroke:#1565c0,color:#0d47a1
  classDef yes fill:#c8e6c9,stroke:#2e7d32,color:#1b5e20
  classDef no fill:#ffcdd2,stroke:#c62828,color:#b71c1c
  classDef start fill:#ffffff,stroke:#212121,color:#212121
```

## Rule X with condition B and the exception both left to judgment

```mermaid
flowchart LR
  B{"J-B<br/>Is condition B met?"}:::judgment
  B -->|"yes (risk medium)"| By
  B -->|"no (risk low)"| Bn
  By{"J-E<br/>Does the exception apply?"}:::judgment
  By -->|"yes (risk high)"| Byy
  By -->|"no (risk low)"| Byn
  Byy(["Rule X does not apply<br/>risk: low"]):::no
  Byn(["Rule X applies<br/>risk: medium"]):::yes
  Bn{"J-E<br/>Does the exception apply?"}:::judgment
  Bn -->|"yes (risk high)"| Bny
  Bn -->|"no (risk low)"| Bnn
  Bny(["Rule X does not apply<br/>risk: low"]):::no
  Bnn(["Rule X does not apply<br/>risk: low"]):::no
  classDef fact fill:#eeeeee,stroke:#616161,color:#212121
  classDef judgment fill:#ffe0b2,stroke:#ef6c00,color:#e65100
  classDef rule fill:#bbdefb,stroke:#1565c0,color:#0d47a1
  classDef yes fill:#c8e6c9,stroke:#2e7d32,color:#1b5e20
  classDef no fill:#ffcdd2,stroke:#c62828,color:#b71c1c
  classDef start fill:#ffffff,stroke:#212121,color:#212121
```


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


# Architecture

> Generated from the Lean sources by `scripts/blueprint.sh`. Do not edit by hand.

Every module of the library (tests left out), grouped by layer, with an arrow from a module to each module that builds on it. Imports already implied by others are left out. Read from the compiled modules.

```mermaid
flowchart BT
  subgraph Core["Layer 0: core language"]
    m0["Core.Risk"]
    m1["Core.Date"]
    m2["Core.Money"]
    m3["Core.Judgment"]
    m4["Core.Finding"]
    m5["Core.Rule"]
    m6["Core.Render"]
    m7["Core.Argument"]
    m8["Core.Combine"]
    m9["Core.Statute"]
    m10["Core.StatuteSyntax"]
    m11["Core.Branch"]
    m12["Core.Series"]
    m13["Core.SeriesReport"]
    m14["Core.Audit"]
    m15["Core.Blueprint"]
    m16["Core.Graphs"]
    m17["Core.LeanGraph"]
  end
  subgraph ITA["Layer 1: statute encoding"]
    m22["ITA.S54.SuperficialLoss"]
    m23["ITA.S40.LossDenial"]
    m24["ITA.S54.SuperficialLossStatute"]
    m25["ITA.S40.LossDenialStatute"]
    m26["ITA.S53.CostAddition"]
    m27["ITA.S251_1.Affiliation"]
    m28["ITA.S54.Timeline"]
  end
  subgraph Lemmas["Layer 2: reusable lemmas"]
    m29["Lemmas.SuperficialLoss"]
  end
  subgraph Transactions["Layer 3: transactions"]
    m30["Transactions.SpouseRepurchase"]
    m31["Transactions.SiblingAndLateRepurchase"]
  end
  subgraph Blueprints["Blueprints"]
    m32["Blueprints.SuperficialLoss"]
    m33["Blueprints.SpouseRepurchase"]
    m34["Blueprints.SiblingAndLateRepurchase"]
    m35["Blueprints.All"]
  end
  subgraph Examples["Examples"]
    m18["Examples.RuleX"]
    m19["Examples.RuleZ"]
    m20["Examples.ToySeries"]
    m21["Examples.RuleXStatute"]
  end
  subgraph Graphs["Graphs"]
    m36["Graphs.All"]
  end
  subgraph Root["Root"]
    m37["Canteen"]
  end
  m0 --> m3
  m3 --> m4
  m4 --> m5
  m5 --> m6
  m6 --> m7
  m5 --> m8
  m8 --> m9
  m9 --> m10
  m7 --> m11
  m7 --> m13
  m12 --> m13
  m4 --> m15
  m14 --> m15
  m9 --> m16
  m11 --> m16
  m13 --> m16
  m16 --> m17
  m7 --> m18
  m18 --> m19
  m8 --> m19
  m18 --> m20
  m8 --> m20
  m11 --> m20
  m13 --> m20
  m10 --> m21
  m18 --> m21
  m7 --> m22
  m1 --> m22
  m2 --> m22
  m22 --> m23
  m8 --> m23
  m10 --> m24
  m22 --> m24
  m23 --> m25
  m24 --> m25
  m22 --> m26
  m10 --> m27
  m22 --> m27
  m22 --> m28
  m22 --> m29
  m23 --> m30
  m29 --> m30
  m11 --> m30
  m26 --> m30
  m27 --> m30
  m23 --> m31
  m27 --> m31
  m29 --> m31
  m11 --> m31
  m15 --> m32
  m29 --> m32
  m25 --> m32
  m26 --> m32
  m27 --> m32
  m15 --> m33
  m16 --> m33
  m30 --> m33
  m24 --> m33
  m28 --> m33
  m15 --> m34
  m16 --> m34
  m31 --> m34
  m28 --> m34
  m32 --> m35
  m33 --> m35
  m34 --> m35
  m16 --> m36
  m21 --> m36
  m20 --> m36
  m28 --> m36
  m25 --> m36
  m30 --> m36
  m31 --> m36
  m17 --> m37
  m19 --> m37
  m35 --> m37
  m36 --> m37
```

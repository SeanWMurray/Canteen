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
    m9["Core.Branch"]
    m10["Core.Answer"]
    m11["Core.Statute"]
    m12["Core.StatuteSyntax"]
    m13["Core.Series"]
    m14["Core.SeriesReport"]
    m15["Core.Audit"]
    m16["Core.Blueprint"]
    m17["Core.Graphs"]
    m18["Core.LeanGraph"]
  end
  subgraph ITA["Layer 1: statute encoding"]
    m23["ITA.S54.SuperficialLoss"]
    m24["ITA.S40.LossDenial"]
    m25["ITA.S54.SuperficialLossStatute"]
    m26["ITA.S40.LossDenialStatute"]
    m27["ITA.S53.CostAddition"]
    m28["ITA.S251_1.Affiliation"]
    m29["ITA.S54.Timeline"]
    m30["ITA.S40.Paragraph40_2_g_Facts"]
    m31["ITA.S40.DebtLoss"]
    m32["ITA.S40.PersonalUseLoss"]
    m33["ITA.S40.PlanTransferLoss"]
    m34["ITA.S40.Paragraph40_2_g"]
  end
  subgraph Lemmas["Layer 2: reusable lemmas"]
    m35["Lemmas.SuperficialLoss"]
  end
  subgraph Transactions["Layer 3: transactions"]
    m36["Transactions.SpouseRepurchase"]
    m37["Transactions.SiblingAndLateRepurchase"]
    m38["Transactions.TfsaContribution"]
  end
  subgraph Blueprints["Blueprints"]
    m39["Blueprints.SuperficialLoss"]
    m40["Blueprints.SpouseRepurchase"]
    m41["Blueprints.SiblingAndLateRepurchase"]
    m42["Blueprints.TfsaContribution"]
    m43["Blueprints.All"]
  end
  subgraph Examples["Examples"]
    m19["Examples.RuleX"]
    m20["Examples.RuleZ"]
    m21["Examples.ToySeries"]
    m22["Examples.RuleXStatute"]
  end
  subgraph Graphs["Graphs"]
    m44["Graphs.All"]
  end
  subgraph Root["Root"]
    m45["Canteen"]
  end
  m0 --> m3
  m3 --> m4
  m4 --> m5
  m5 --> m6
  m6 --> m7
  m5 --> m8
  m7 --> m9
  m9 --> m10
  m8 --> m11
  m11 --> m12
  m7 --> m14
  m13 --> m14
  m4 --> m16
  m15 --> m16
  m11 --> m17
  m9 --> m17
  m14 --> m17
  m17 --> m18
  m7 --> m19
  m19 --> m20
  m8 --> m20
  m19 --> m21
  m8 --> m21
  m9 --> m21
  m14 --> m21
  m12 --> m22
  m19 --> m22
  m7 --> m23
  m1 --> m23
  m2 --> m23
  m23 --> m24
  m8 --> m24
  m12 --> m25
  m23 --> m25
  m24 --> m26
  m25 --> m26
  m23 --> m27
  m12 --> m28
  m23 --> m28
  m10 --> m28
  m23 --> m29
  m10 --> m30
  m23 --> m30
  m12 --> m31
  m30 --> m31
  m12 --> m32
  m30 --> m32
  m12 --> m33
  m30 --> m33
  m31 --> m34
  m32 --> m34
  m33 --> m34
  m24 --> m34
  m23 --> m35
  m24 --> m36
  m35 --> m36
  m27 --> m36
  m28 --> m36
  m24 --> m37
  m28 --> m37
  m35 --> m37
  m34 --> m38
  m28 --> m38
  m16 --> m39
  m35 --> m39
  m26 --> m39
  m27 --> m39
  m28 --> m39
  m34 --> m39
  m16 --> m40
  m17 --> m40
  m36 --> m40
  m25 --> m40
  m29 --> m40
  m16 --> m41
  m17 --> m41
  m37 --> m41
  m29 --> m41
  m16 --> m42
  m17 --> m42
  m38 --> m42
  m29 --> m42
  m39 --> m43
  m40 --> m43
  m41 --> m43
  m42 --> m43
  m17 --> m44
  m22 --> m44
  m21 --> m44
  m29 --> m44
  m26 --> m44
  m36 --> m44
  m37 --> m44
  m38 --> m44
  m18 --> m45
  m20 --> m45
  m43 --> m45
  m44 --> m45
```

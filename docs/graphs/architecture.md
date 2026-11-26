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
    m29["ITA.S251_1.AffiliatedPersons"]
    m30["ITA.S251.RelatedPersons"]
    m31["ITA.S54.Timeline"]
    m32["ITA.S40.Paragraph40_2_g_Facts"]
    m33["ITA.S40.DebtLoss"]
    m34["ITA.S40.PersonalUseLoss"]
    m35["ITA.S40.PlanTransferLoss"]
    m36["ITA.S40.Paragraph40_2_g"]
  end
  subgraph Lemmas["Layer 2: reusable lemmas"]
    m37["Lemmas.SuperficialLoss"]
  end
  subgraph Transactions["Layer 3: transactions"]
    m38["Transactions.SpouseRepurchase"]
    m39["Transactions.SiblingAndLateRepurchase"]
    m40["Transactions.TfsaContribution"]
    m41["Transactions.HoldcoRepurchase"]
  end
  subgraph Blueprints["Blueprints"]
    m42["Blueprints.SuperficialLoss"]
    m43["Blueprints.SpouseRepurchase"]
    m44["Blueprints.SiblingAndLateRepurchase"]
    m45["Blueprints.TfsaContribution"]
    m46["Blueprints.HoldcoRepurchase"]
    m47["Blueprints.All"]
  end
  subgraph Examples["Examples"]
    m19["Examples.RuleX"]
    m20["Examples.RuleZ"]
    m21["Examples.ToySeries"]
    m22["Examples.RuleXStatute"]
  end
  subgraph Graphs["Graphs"]
    m48["Graphs.All"]
  end
  subgraph Root["Root"]
    m49["Canteen"]
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
  m10 --> m29
  m23 --> m29
  m17 --> m29
  m29 --> m30
  m23 --> m31
  m10 --> m32
  m23 --> m32
  m12 --> m33
  m32 --> m33
  m12 --> m34
  m32 --> m34
  m12 --> m35
  m32 --> m35
  m33 --> m36
  m34 --> m36
  m35 --> m36
  m24 --> m36
  m23 --> m37
  m24 --> m38
  m37 --> m38
  m27 --> m38
  m28 --> m38
  m24 --> m39
  m28 --> m39
  m37 --> m39
  m36 --> m40
  m28 --> m40
  m36 --> m41
  m27 --> m41
  m29 --> m41
  m16 --> m42
  m37 --> m42
  m26 --> m42
  m27 --> m42
  m28 --> m42
  m30 --> m42
  m36 --> m42
  m16 --> m43
  m17 --> m43
  m38 --> m43
  m25 --> m43
  m31 --> m43
  m16 --> m44
  m17 --> m44
  m39 --> m44
  m31 --> m44
  m16 --> m45
  m17 --> m45
  m40 --> m45
  m31 --> m45
  m16 --> m46
  m41 --> m46
  m31 --> m46
  m42 --> m47
  m43 --> m47
  m44 --> m47
  m45 --> m47
  m46 --> m47
  m22 --> m48
  m21 --> m48
  m31 --> m48
  m26 --> m48
  m38 --> m48
  m39 --> m48
  m40 --> m48
  m41 --> m48
  m30 --> m48
  m18 --> m49
  m20 --> m49
  m47 --> m49
  m48 --> m49
```

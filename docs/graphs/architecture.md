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
    m31["ITA.S50.BadDebtPersonalUse"]
    m32["ITA.S40.SuspendedLoss"]
    m33["ITA.S54.Timeline"]
    m34["ITA.S40.Paragraph40_2_g_Facts"]
    m35["ITA.S40.DebtLoss"]
    m36["ITA.S40.PersonalUseLoss"]
    m37["ITA.S40.PlanTransferLoss"]
    m38["ITA.S40.Paragraph40_2_g"]
  end
  subgraph Lemmas["Layer 2: reusable lemmas"]
    m39["Lemmas.SuperficialLoss"]
    m40["Lemmas.SuspendedLoss"]
  end
  subgraph Transactions["Layer 3: transactions"]
    m41["Transactions.SpouseRepurchase"]
    m42["Transactions.SiblingAndLateRepurchase"]
    m43["Transactions.TfsaContribution"]
    m44["Transactions.HoldcoRepurchase"]
    m45["Transactions.SisterCompanyRepurchase"]
  end
  subgraph Blueprints["Blueprints"]
    m46["Blueprints.SuperficialLoss"]
    m47["Blueprints.SpouseRepurchase"]
    m48["Blueprints.SiblingAndLateRepurchase"]
    m49["Blueprints.TfsaContribution"]
    m50["Blueprints.HoldcoRepurchase"]
    m51["Blueprints.SisterCompanyRepurchase"]
    m52["Blueprints.All"]
  end
  subgraph Examples["Examples"]
    m19["Examples.RuleX"]
    m20["Examples.RuleZ"]
    m21["Examples.ToySeries"]
    m22["Examples.RuleXStatute"]
  end
  subgraph Graphs["Graphs"]
    m53["Graphs.All"]
  end
  subgraph Root["Root"]
    m54["Canteen"]
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
  m16 --> m18
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
  m12 --> m31
  m10 --> m31
  m2 --> m31
  m12 --> m32
  m23 --> m32
  m23 --> m33
  m10 --> m34
  m23 --> m34
  m12 --> m35
  m34 --> m35
  m12 --> m36
  m34 --> m36
  m12 --> m37
  m34 --> m37
  m35 --> m38
  m36 --> m38
  m37 --> m38
  m24 --> m38
  m23 --> m39
  m32 --> m40
  m24 --> m41
  m39 --> m41
  m27 --> m41
  m28 --> m41
  m24 --> m42
  m28 --> m42
  m39 --> m42
  m38 --> m43
  m28 --> m43
  m38 --> m44
  m27 --> m44
  m29 --> m44
  m32 --> m45
  m29 --> m45
  m16 --> m46
  m39 --> m46
  m26 --> m46
  m27 --> m46
  m28 --> m46
  m30 --> m46
  m31 --> m46
  m40 --> m46
  m38 --> m46
  m16 --> m47
  m17 --> m47
  m41 --> m47
  m25 --> m47
  m33 --> m47
  m16 --> m48
  m17 --> m48
  m42 --> m48
  m33 --> m48
  m16 --> m49
  m17 --> m49
  m43 --> m49
  m33 --> m49
  m16 --> m50
  m44 --> m50
  m33 --> m50
  m16 --> m51
  m45 --> m51
  m46 --> m52
  m47 --> m52
  m48 --> m52
  m49 --> m52
  m50 --> m52
  m51 --> m52
  m22 --> m53
  m21 --> m53
  m33 --> m53
  m26 --> m53
  m41 --> m53
  m42 --> m53
  m43 --> m53
  m44 --> m53
  m30 --> m53
  m31 --> m53
  m45 --> m53
  m18 --> m54
  m20 --> m54
  m52 --> m54
  m53 --> m54
```

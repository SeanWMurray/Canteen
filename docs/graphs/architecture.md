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
    m31["ITA.S251.Amalgamation"]
    m32["ITA.S50.BadDebtPersonalUse"]
    m33["ITA.S40.SuspendedLoss"]
    m34["ITA.S54.Timeline"]
    m35["ITA.S40.Paragraph40_2_g_Facts"]
    m36["ITA.S40.DebtLoss"]
    m37["ITA.S40.PersonalUseLoss"]
    m38["ITA.S40.PlanTransferLoss"]
    m39["ITA.S40.Paragraph40_2_g"]
  end
  subgraph Lemmas["Layer 2: reusable lemmas"]
    m40["Lemmas.SuperficialLoss"]
    m41["Lemmas.SuspendedLoss"]
  end
  subgraph Transactions["Layer 3: transactions"]
    m42["Transactions.SpouseRepurchase"]
    m43["Transactions.SiblingAndLateRepurchase"]
    m44["Transactions.TfsaContribution"]
    m45["Transactions.HoldcoRepurchase"]
    m46["Transactions.SisterCompanyRepurchase"]
  end
  subgraph Blueprints["Blueprints"]
    m47["Blueprints.SuperficialLoss"]
    m48["Blueprints.SpouseRepurchase"]
    m49["Blueprints.SiblingAndLateRepurchase"]
    m50["Blueprints.TfsaContribution"]
    m51["Blueprints.HoldcoRepurchase"]
    m52["Blueprints.SisterCompanyRepurchase"]
    m53["Blueprints.All"]
  end
  subgraph Examples["Examples"]
    m19["Examples.RuleX"]
    m20["Examples.RuleZ"]
    m21["Examples.ToySeries"]
    m22["Examples.RuleXStatute"]
  end
  subgraph Graphs["Graphs"]
    m54["Graphs.All"]
  end
  subgraph Root["Root"]
    m55["Canteen"]
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
  m30 --> m31
  m12 --> m32
  m10 --> m32
  m2 --> m32
  m12 --> m33
  m23 --> m33
  m23 --> m34
  m10 --> m35
  m23 --> m35
  m12 --> m36
  m35 --> m36
  m12 --> m37
  m35 --> m37
  m12 --> m38
  m35 --> m38
  m36 --> m39
  m37 --> m39
  m38 --> m39
  m24 --> m39
  m23 --> m40
  m33 --> m41
  m24 --> m42
  m40 --> m42
  m27 --> m42
  m28 --> m42
  m24 --> m43
  m28 --> m43
  m40 --> m43
  m39 --> m44
  m28 --> m44
  m39 --> m45
  m27 --> m45
  m29 --> m45
  m33 --> m46
  m29 --> m46
  m16 --> m47
  m40 --> m47
  m26 --> m47
  m27 --> m47
  m28 --> m47
  m31 --> m47
  m32 --> m47
  m41 --> m47
  m39 --> m47
  m16 --> m48
  m17 --> m48
  m42 --> m48
  m25 --> m48
  m34 --> m48
  m16 --> m49
  m17 --> m49
  m43 --> m49
  m34 --> m49
  m16 --> m50
  m17 --> m50
  m44 --> m50
  m34 --> m50
  m16 --> m51
  m45 --> m51
  m34 --> m51
  m16 --> m52
  m46 --> m52
  m47 --> m53
  m48 --> m53
  m49 --> m53
  m50 --> m53
  m51 --> m53
  m52 --> m53
  m22 --> m54
  m21 --> m54
  m34 --> m54
  m26 --> m54
  m42 --> m54
  m43 --> m54
  m44 --> m54
  m45 --> m54
  m31 --> m54
  m32 --> m54
  m46 --> m54
  m18 --> m55
  m20 --> m55
  m53 --> m55
  m54 --> m55
```

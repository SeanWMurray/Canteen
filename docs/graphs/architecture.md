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
    m32["ITA.S40.Paragraph40_2_g_Facts"]
    m33["ITA.S40.DebtLoss"]
    m34["ITA.S40.PersonalUseLoss"]
    m35["ITA.S40.PlanTransferLoss"]
    m36["ITA.S40.Paragraph40_2_g"]
    m37["ITA.S40.SuspendedLoss"]
    m38["ITA.S38.CapitalGains"]
    m39["ITA.S3.Income"]
    m40["ITA.S111.NetCapitalLoss"]
    m41["ITA.S50.BadDebtPersonalUse"]
    m42["ITA.S54.Timeline"]
  end
  subgraph Lemmas["Layer 2: reusable lemmas"]
    m43["Lemmas.SuperficialLoss"]
    m44["Lemmas.SuspendedLoss"]
  end
  subgraph Transactions["Layer 3: transactions"]
    m45["Transactions.SpouseRepurchase"]
    m46["Transactions.SiblingAndLateRepurchase"]
    m47["Transactions.TfsaContribution"]
    m48["Transactions.HoldcoRepurchase"]
    m49["Transactions.SisterCompanyRepurchase"]
  end
  subgraph Blueprints["Blueprints"]
    m50["Blueprints.SuperficialLoss"]
    m51["Blueprints.SpouseRepurchase"]
    m52["Blueprints.SiblingAndLateRepurchase"]
    m53["Blueprints.TfsaContribution"]
    m54["Blueprints.HoldcoRepurchase"]
    m55["Blueprints.SisterCompanyRepurchase"]
    m56["Blueprints.All"]
  end
  subgraph Examples["Examples"]
    m19["Examples.RuleX"]
    m20["Examples.RuleZ"]
    m21["Examples.ToySeries"]
    m22["Examples.RuleXStatute"]
  end
  subgraph Graphs["Graphs"]
    m57["Graphs.All"]
  end
  subgraph Root["Root"]
    m58["Canteen"]
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
  m12 --> m37
  m23 --> m37
  m36 --> m38
  m37 --> m38
  m38 --> m39
  m39 --> m40
  m12 --> m41
  m10 --> m41
  m2 --> m41
  m23 --> m42
  m23 --> m43
  m37 --> m44
  m24 --> m45
  m43 --> m45
  m27 --> m45
  m28 --> m45
  m24 --> m46
  m28 --> m46
  m43 --> m46
  m36 --> m47
  m28 --> m47
  m36 --> m48
  m27 --> m48
  m29 --> m48
  m37 --> m49
  m29 --> m49
  m16 --> m50
  m43 --> m50
  m26 --> m50
  m27 --> m50
  m28 --> m50
  m31 --> m50
  m40 --> m50
  m41 --> m50
  m44 --> m50
  m16 --> m51
  m17 --> m51
  m45 --> m51
  m25 --> m51
  m42 --> m51
  m39 --> m51
  m16 --> m52
  m17 --> m52
  m46 --> m52
  m42 --> m52
  m16 --> m53
  m17 --> m53
  m47 --> m53
  m42 --> m53
  m16 --> m54
  m48 --> m54
  m42 --> m54
  m16 --> m55
  m49 --> m55
  m50 --> m56
  m51 --> m56
  m52 --> m56
  m53 --> m56
  m54 --> m56
  m55 --> m56
  m22 --> m57
  m21 --> m57
  m42 --> m57
  m26 --> m57
  m45 --> m57
  m46 --> m57
  m47 --> m57
  m48 --> m57
  m31 --> m57
  m41 --> m57
  m49 --> m57
  m18 --> m58
  m20 --> m58
  m56 --> m58
  m57 --> m58
```

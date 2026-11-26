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
    m38["ITA.S40.ShareToAffiliate"]
    m39["ITA.S40.RelatedDebt"]
    m40["ITA.S38.CapitalGains"]
    m41["ITA.S3.Income"]
    m42["ITA.S111.NetCapitalLoss"]
    m43["ITA.S50.BadDebtPersonalUse"]
    m44["ITA.S54.Timeline"]
  end
  subgraph Lemmas["Layer 2: reusable lemmas"]
    m45["Lemmas.SuperficialLoss"]
    m46["Lemmas.SuspendedLoss"]
  end
  subgraph Transactions["Layer 3: transactions"]
    m47["Transactions.SpouseRepurchase"]
    m48["Transactions.SiblingAndLateRepurchase"]
    m49["Transactions.TfsaContribution"]
    m50["Transactions.HoldcoRepurchase"]
    m51["Transactions.SisterCompanyRepurchase"]
  end
  subgraph Blueprints["Blueprints"]
    m52["Blueprints.SuperficialLoss"]
    m53["Blueprints.SpouseRepurchase"]
    m54["Blueprints.SiblingAndLateRepurchase"]
    m55["Blueprints.TfsaContribution"]
    m56["Blueprints.HoldcoRepurchase"]
    m57["Blueprints.SisterCompanyRepurchase"]
    m58["Blueprints.All"]
  end
  subgraph Examples["Examples"]
    m19["Examples.RuleX"]
    m20["Examples.RuleZ"]
    m21["Examples.ToySeries"]
    m22["Examples.RuleXStatute"]
  end
  subgraph Graphs["Graphs"]
    m59["Graphs.All"]
  end
  subgraph Root["Root"]
    m60["Canteen"]
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
  m12 --> m38
  m29 --> m38
  m12 --> m39
  m30 --> m39
  m36 --> m40
  m37 --> m40
  m38 --> m40
  m39 --> m40
  m40 --> m41
  m41 --> m42
  m12 --> m43
  m10 --> m43
  m2 --> m43
  m23 --> m44
  m23 --> m45
  m37 --> m46
  m24 --> m47
  m45 --> m47
  m27 --> m47
  m28 --> m47
  m24 --> m48
  m28 --> m48
  m45 --> m48
  m36 --> m49
  m28 --> m49
  m36 --> m50
  m27 --> m50
  m29 --> m50
  m37 --> m51
  m29 --> m51
  m16 --> m52
  m45 --> m52
  m26 --> m52
  m27 --> m52
  m28 --> m52
  m31 --> m52
  m42 --> m52
  m43 --> m52
  m46 --> m52
  m16 --> m53
  m47 --> m53
  m25 --> m53
  m44 --> m53
  m41 --> m53
  m16 --> m54
  m17 --> m54
  m48 --> m54
  m44 --> m54
  m16 --> m55
  m17 --> m55
  m49 --> m55
  m44 --> m55
  m16 --> m56
  m50 --> m56
  m44 --> m56
  m16 --> m57
  m51 --> m57
  m52 --> m58
  m53 --> m58
  m54 --> m58
  m55 --> m58
  m56 --> m58
  m57 --> m58
  m22 --> m59
  m21 --> m59
  m44 --> m59
  m26 --> m59
  m47 --> m59
  m48 --> m59
  m49 --> m59
  m50 --> m59
  m31 --> m59
  m43 --> m59
  m38 --> m59
  m39 --> m59
  m51 --> m59
  m18 --> m60
  m20 --> m60
  m58 --> m60
  m59 --> m60
```

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
    m40["ITA.S40.PrincipalResidence"]
    m41["ITA.S38.CapitalGains"]
    m42["ITA.S3.Income"]
    m43["ITA.S111.NetCapitalLoss"]
    m44["ITA.S69.NonArmsLength"]
    m45["ITA.S73.SpousalRollover"]
    m46["ITA.S70.Death"]
    m47["ITA.S74.Attribution"]
    m48["ITA.S45.ChangeInUse"]
    m49["ITA.S85.TransferToCorporation"]
    m50["ITA.S84_1.SurplusStripping"]
    m51["ITA.S110_6.CapitalGainsDeduction"]
    m52["ITA.S251_2.LossRestrictionEvent"]
    m53["ITA.S74.IncomeAttribution"]
    m54["ITA.S50.BadDebtPersonalUse"]
    m55["ITA.S54.Timeline"]
  end
  subgraph Lemmas["Layer 2: reusable lemmas"]
    m56["Lemmas.SuperficialLoss"]
    m57["Lemmas.SuspendedLoss"]
  end
  subgraph Transactions["Layer 3: transactions"]
    m58["Transactions.SpouseRepurchase"]
    m59["Transactions.SiblingAndLateRepurchase"]
    m60["Transactions.TfsaContribution"]
    m61["Transactions.HoldcoRepurchase"]
    m62["Transactions.Crystallization"]
    m63["Transactions.SisterCompanyRepurchase"]
  end
  subgraph Blueprints["Blueprints"]
    m64["Blueprints.SuperficialLoss"]
    m65["Blueprints.SpouseRepurchase"]
    m66["Blueprints.SiblingAndLateRepurchase"]
    m67["Blueprints.TfsaContribution"]
    m68["Blueprints.HoldcoRepurchase"]
    m69["Blueprints.Crystallization"]
    m70["Blueprints.SisterCompanyRepurchase"]
    m71["Blueprints.All"]
  end
  subgraph Examples["Examples"]
    m19["Examples.RuleX"]
    m20["Examples.RuleZ"]
    m21["Examples.ToySeries"]
    m22["Examples.RuleXStatute"]
  end
  subgraph Graphs["Graphs"]
    m72["Graphs.All"]
  end
  subgraph Root["Root"]
    m73["Canteen"]
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
  m12 --> m40
  m10 --> m40
  m1 --> m40
  m2 --> m40
  m36 --> m41
  m37 --> m41
  m38 --> m41
  m39 --> m41
  m40 --> m41
  m41 --> m42
  m42 --> m43
  m41 --> m44
  m44 --> m45
  m41 --> m46
  m41 --> m47
  m41 --> m48
  m41 --> m49
  m49 --> m50
  m41 --> m51
  m12 --> m52
  m30 --> m52
  m47 --> m53
  m12 --> m54
  m10 --> m54
  m2 --> m54
  m23 --> m55
  m23 --> m56
  m37 --> m57
  m24 --> m58
  m56 --> m58
  m27 --> m58
  m28 --> m58
  m24 --> m59
  m28 --> m59
  m56 --> m59
  m36 --> m60
  m28 --> m60
  m36 --> m61
  m27 --> m61
  m29 --> m61
  m50 --> m62
  m51 --> m62
  m27 --> m62
  m37 --> m63
  m29 --> m63
  m16 --> m64
  m56 --> m64
  m26 --> m64
  m27 --> m64
  m28 --> m64
  m31 --> m64
  m43 --> m64
  m45 --> m64
  m46 --> m64
  m48 --> m64
  m50 --> m64
  m51 --> m64
  m52 --> m64
  m53 --> m64
  m54 --> m64
  m57 --> m64
  m16 --> m65
  m58 --> m65
  m25 --> m65
  m55 --> m65
  m42 --> m65
  m16 --> m66
  m17 --> m66
  m59 --> m66
  m55 --> m66
  m16 --> m67
  m17 --> m67
  m60 --> m67
  m55 --> m67
  m16 --> m68
  m61 --> m68
  m55 --> m68
  m16 --> m69
  m62 --> m69
  m16 --> m70
  m63 --> m70
  m64 --> m71
  m65 --> m71
  m66 --> m71
  m67 --> m71
  m68 --> m71
  m70 --> m71
  m69 --> m71
  m22 --> m72
  m21 --> m72
  m55 --> m72
  m26 --> m72
  m58 --> m72
  m59 --> m72
  m60 --> m72
  m61 --> m72
  m31 --> m72
  m54 --> m72
  m45 --> m72
  m46 --> m72
  m48 --> m72
  m52 --> m72
  m53 --> m72
  m63 --> m72
  m62 --> m72
  m18 --> m73
  m20 --> m73
  m71 --> m73
  m72 --> m73
```

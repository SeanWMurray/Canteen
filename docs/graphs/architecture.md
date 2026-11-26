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
    m54["ITA.S82.Dividends"]
    m55["ITA.S55.IntercorporateDividends"]
    m56["ITA.S13.Depreciable"]
    m57["ITA.S84.Redemption"]
    m58["ITA.S50.BadDebtPersonalUse"]
    m59["ITA.S54.Timeline"]
  end
  subgraph Lemmas["Layer 2: reusable lemmas"]
    m60["Lemmas.SuperficialLoss"]
    m61["Lemmas.SuspendedLoss"]
  end
  subgraph Transactions["Layer 3: transactions"]
    m62["Transactions.SpouseRepurchase"]
    m63["Transactions.SiblingAndLateRepurchase"]
    m64["Transactions.TfsaContribution"]
    m65["Transactions.HoldcoRepurchase"]
    m66["Transactions.Crystallization"]
    m67["Transactions.SisterCompanyRepurchase"]
  end
  subgraph Blueprints["Blueprints"]
    m68["Blueprints.SuperficialLoss"]
    m69["Blueprints.SpouseRepurchase"]
    m70["Blueprints.SiblingAndLateRepurchase"]
    m71["Blueprints.TfsaContribution"]
    m72["Blueprints.HoldcoRepurchase"]
    m73["Blueprints.Crystallization"]
    m74["Blueprints.SisterCompanyRepurchase"]
    m75["Blueprints.All"]
  end
  subgraph Examples["Examples"]
    m19["Examples.RuleX"]
    m20["Examples.RuleZ"]
    m21["Examples.ToySeries"]
    m22["Examples.RuleXStatute"]
  end
  subgraph Graphs["Graphs"]
    m76["Graphs.All"]
  end
  subgraph Root["Root"]
    m77["Canteen"]
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
  m2 --> m54
  m12 --> m55
  m10 --> m55
  m2 --> m55
  m41 --> m56
  m41 --> m57
  m54 --> m57
  m55 --> m57
  m12 --> m58
  m10 --> m58
  m2 --> m58
  m23 --> m59
  m23 --> m60
  m37 --> m61
  m24 --> m62
  m60 --> m62
  m27 --> m62
  m28 --> m62
  m24 --> m63
  m28 --> m63
  m60 --> m63
  m36 --> m64
  m28 --> m64
  m36 --> m65
  m27 --> m65
  m29 --> m65
  m50 --> m66
  m51 --> m66
  m54 --> m66
  m27 --> m66
  m37 --> m67
  m29 --> m67
  m16 --> m68
  m60 --> m68
  m26 --> m68
  m27 --> m68
  m28 --> m68
  m31 --> m68
  m43 --> m68
  m45 --> m68
  m46 --> m68
  m48 --> m68
  m50 --> m68
  m51 --> m68
  m52 --> m68
  m53 --> m68
  m56 --> m68
  m57 --> m68
  m58 --> m68
  m61 --> m68
  m16 --> m69
  m62 --> m69
  m25 --> m69
  m59 --> m69
  m42 --> m69
  m16 --> m70
  m17 --> m70
  m63 --> m70
  m59 --> m70
  m16 --> m71
  m17 --> m71
  m64 --> m71
  m59 --> m71
  m16 --> m72
  m65 --> m72
  m59 --> m72
  m16 --> m73
  m66 --> m73
  m16 --> m74
  m67 --> m74
  m68 --> m75
  m69 --> m75
  m70 --> m75
  m71 --> m75
  m72 --> m75
  m74 --> m75
  m73 --> m75
  m22 --> m76
  m21 --> m76
  m59 --> m76
  m26 --> m76
  m62 --> m76
  m63 --> m76
  m64 --> m76
  m65 --> m76
  m31 --> m76
  m58 --> m76
  m45 --> m76
  m46 --> m76
  m48 --> m76
  m52 --> m76
  m53 --> m76
  m55 --> m76
  m67 --> m76
  m66 --> m76
  m18 --> m77
  m20 --> m77
  m75 --> m77
  m76 --> m77
```

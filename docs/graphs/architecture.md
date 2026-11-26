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
    m58["ITA.S89.CapitalDividendAccount"]
    m59["ITA.S86.ShareExchange"]
    m60["ITA.S44.ReplacementProperty"]
    m61["ITA.S47.IdenticalProperties"]
    m62["ITA.S186.Connected"]
    m63["ITA.S50.BadDebtPersonalUse"]
    m64["ITA.S54.Timeline"]
  end
  subgraph Lemmas["Layer 2: reusable lemmas"]
    m65["Lemmas.SuperficialLoss"]
    m66["Lemmas.SuspendedLoss"]
  end
  subgraph Transactions["Layer 3: transactions"]
    m67["Transactions.SpouseRepurchase"]
    m68["Transactions.SiblingAndLateRepurchase"]
    m69["Transactions.TfsaContribution"]
    m70["Transactions.HoldcoRepurchase"]
    m71["Transactions.Crystallization"]
    m72["Transactions.SaleThroughHoldco"]
    m73["Transactions.SisterCompanyRepurchase"]
  end
  subgraph Blueprints["Blueprints"]
    m74["Blueprints.SuperficialLoss"]
    m75["Blueprints.SpouseRepurchase"]
    m76["Blueprints.SiblingAndLateRepurchase"]
    m77["Blueprints.TfsaContribution"]
    m78["Blueprints.HoldcoRepurchase"]
    m79["Blueprints.Crystallization"]
    m80["Blueprints.SaleThroughHoldco"]
    m81["Blueprints.SisterCompanyRepurchase"]
    m82["Blueprints.All"]
  end
  subgraph Examples["Examples"]
    m19["Examples.RuleX"]
    m20["Examples.RuleZ"]
    m21["Examples.ToySeries"]
    m22["Examples.RuleXStatute"]
  end
  subgraph Graphs["Graphs"]
    m83["Graphs.All"]
  end
  subgraph Root["Root"]
    m84["Canteen"]
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
  m41 --> m58
  m49 --> m59
  m41 --> m60
  m41 --> m61
  m12 --> m62
  m30 --> m62
  m12 --> m63
  m10 --> m63
  m2 --> m63
  m23 --> m64
  m23 --> m65
  m37 --> m66
  m24 --> m67
  m65 --> m67
  m27 --> m67
  m28 --> m67
  m24 --> m68
  m28 --> m68
  m65 --> m68
  m36 --> m69
  m28 --> m69
  m36 --> m70
  m27 --> m70
  m29 --> m70
  m50 --> m71
  m51 --> m71
  m54 --> m71
  m27 --> m71
  m55 --> m72
  m58 --> m72
  m37 --> m73
  m29 --> m73
  m16 --> m74
  m65 --> m74
  m26 --> m74
  m27 --> m74
  m28 --> m74
  m31 --> m74
  m43 --> m74
  m45 --> m74
  m46 --> m74
  m48 --> m74
  m50 --> m74
  m51 --> m74
  m52 --> m74
  m53 --> m74
  m56 --> m74
  m57 --> m74
  m58 --> m74
  m59 --> m74
  m60 --> m74
  m61 --> m74
  m62 --> m74
  m63 --> m74
  m66 --> m74
  m16 --> m75
  m67 --> m75
  m25 --> m75
  m64 --> m75
  m42 --> m75
  m16 --> m76
  m17 --> m76
  m68 --> m76
  m64 --> m76
  m16 --> m77
  m17 --> m77
  m69 --> m77
  m64 --> m77
  m16 --> m78
  m70 --> m78
  m64 --> m78
  m16 --> m79
  m71 --> m79
  m16 --> m80
  m72 --> m80
  m16 --> m81
  m73 --> m81
  m74 --> m82
  m75 --> m82
  m76 --> m82
  m77 --> m82
  m78 --> m82
  m81 --> m82
  m79 --> m82
  m80 --> m82
  m22 --> m83
  m21 --> m83
  m64 --> m83
  m26 --> m83
  m67 --> m83
  m68 --> m83
  m69 --> m83
  m70 --> m83
  m31 --> m83
  m63 --> m83
  m45 --> m83
  m46 --> m83
  m48 --> m83
  m52 --> m83
  m53 --> m83
  m59 --> m83
  m60 --> m83
  m62 --> m83
  m73 --> m83
  m71 --> m83
  m72 --> m83
  m18 --> m84
  m20 --> m84
  m82 --> m84
  m83 --> m84
```

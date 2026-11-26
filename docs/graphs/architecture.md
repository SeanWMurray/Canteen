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
    m63["ITA.S84.ReturnOfCapital"]
    m64["ITA.S88.WindingUp"]
    m65["ITA.S87.Amalgamation"]
    m66["ITA.S51.ConvertibleProperty"]
    m67["ITA.S50.BadDebtPersonalUse"]
    m68["ITA.S54.Timeline"]
  end
  subgraph Lemmas["Layer 2: reusable lemmas"]
    m69["Lemmas.SuperficialLoss"]
    m70["Lemmas.SuspendedLoss"]
  end
  subgraph Transactions["Layer 3: transactions"]
    m71["Transactions.SpouseRepurchase"]
    m72["Transactions.SiblingAndLateRepurchase"]
    m73["Transactions.TfsaContribution"]
    m74["Transactions.HoldcoRepurchase"]
    m75["Transactions.Crystallization"]
    m76["Transactions.SaleThroughHoldco"]
    m77["Transactions.PostMortemPipeline"]
    m78["Transactions.SisterCompanyRepurchase"]
  end
  subgraph Blueprints["Blueprints"]
    m79["Blueprints.SuperficialLoss"]
    m80["Blueprints.SpouseRepurchase"]
    m81["Blueprints.SiblingAndLateRepurchase"]
    m82["Blueprints.TfsaContribution"]
    m83["Blueprints.HoldcoRepurchase"]
    m84["Blueprints.Crystallization"]
    m85["Blueprints.SaleThroughHoldco"]
    m86["Blueprints.PostMortemPipeline"]
    m87["Blueprints.SisterCompanyRepurchase"]
    m88["Blueprints.All"]
  end
  subgraph Examples["Examples"]
    m19["Examples.RuleX"]
    m20["Examples.RuleZ"]
    m21["Examples.ToySeries"]
    m22["Examples.RuleXStatute"]
  end
  subgraph Graphs["Graphs"]
    m89["Graphs.All"]
  end
  subgraph Root["Root"]
    m90["Canteen"]
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
  m41 --> m63
  m41 --> m64
  m49 --> m65
  m49 --> m66
  m12 --> m67
  m10 --> m67
  m2 --> m67
  m23 --> m68
  m23 --> m69
  m37 --> m70
  m24 --> m71
  m69 --> m71
  m27 --> m71
  m28 --> m71
  m24 --> m72
  m28 --> m72
  m69 --> m72
  m36 --> m73
  m28 --> m73
  m36 --> m74
  m27 --> m74
  m29 --> m74
  m50 --> m75
  m51 --> m75
  m54 --> m75
  m27 --> m75
  m55 --> m76
  m58 --> m76
  m46 --> m77
  m50 --> m77
  m54 --> m77
  m37 --> m78
  m29 --> m78
  m16 --> m79
  m69 --> m79
  m26 --> m79
  m27 --> m79
  m28 --> m79
  m31 --> m79
  m43 --> m79
  m45 --> m79
  m46 --> m79
  m48 --> m79
  m50 --> m79
  m51 --> m79
  m52 --> m79
  m53 --> m79
  m56 --> m79
  m57 --> m79
  m58 --> m79
  m59 --> m79
  m60 --> m79
  m61 --> m79
  m62 --> m79
  m63 --> m79
  m64 --> m79
  m65 --> m79
  m66 --> m79
  m67 --> m79
  m70 --> m79
  m16 --> m80
  m71 --> m80
  m25 --> m80
  m68 --> m80
  m42 --> m80
  m16 --> m81
  m17 --> m81
  m72 --> m81
  m68 --> m81
  m16 --> m82
  m17 --> m82
  m73 --> m82
  m68 --> m82
  m16 --> m83
  m74 --> m83
  m68 --> m83
  m16 --> m84
  m75 --> m84
  m16 --> m85
  m76 --> m85
  m16 --> m86
  m77 --> m86
  m16 --> m87
  m78 --> m87
  m79 --> m88
  m80 --> m88
  m81 --> m88
  m82 --> m88
  m83 --> m88
  m87 --> m88
  m84 --> m88
  m85 --> m88
  m86 --> m88
  m22 --> m89
  m21 --> m89
  m68 --> m89
  m26 --> m89
  m71 --> m89
  m72 --> m89
  m73 --> m89
  m74 --> m89
  m31 --> m89
  m67 --> m89
  m45 --> m89
  m46 --> m89
  m48 --> m89
  m52 --> m89
  m53 --> m89
  m59 --> m89
  m60 --> m89
  m62 --> m89
  m64 --> m89
  m65 --> m89
  m78 --> m89
  m75 --> m89
  m76 --> m89
  m18 --> m90
  m20 --> m90
  m88 --> m90
  m89 --> m90
```

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
    m67["ITA.S3.IndividualYear"]
    m68["ITA.S39.CanadianSecurities"]
    m69["ITA.S50.BadDebtOrShare"]
    m70["ITA.S50.BadDebtPersonalUse"]
    m71["ITA.S54.Timeline"]
  end
  subgraph Lemmas["Layer 2: reusable lemmas"]
    m72["Lemmas.SuperficialLoss"]
    m73["Lemmas.SuspendedLoss"]
  end
  subgraph Transactions["Layer 3: transactions"]
    m74["Transactions.SpouseRepurchase"]
    m75["Transactions.SiblingAndLateRepurchase"]
    m76["Transactions.TfsaContribution"]
    m77["Transactions.HoldcoRepurchase"]
    m78["Transactions.Crystallization"]
    m79["Transactions.SaleThroughHoldco"]
    m80["Transactions.PostMortemPipeline"]
    m81["Transactions.SisterCompanyRepurchase"]
  end
  subgraph Blueprints["Blueprints"]
    m82["Blueprints.SuperficialLoss"]
    m83["Blueprints.SpouseRepurchase"]
    m84["Blueprints.SiblingAndLateRepurchase"]
    m85["Blueprints.TfsaContribution"]
    m86["Blueprints.HoldcoRepurchase"]
    m87["Blueprints.Crystallization"]
    m88["Blueprints.SaleThroughHoldco"]
    m89["Blueprints.PostMortemPipeline"]
    m90["Blueprints.SisterCompanyRepurchase"]
    m91["Blueprints.All"]
  end
  subgraph Examples["Examples"]
    m19["Examples.RuleX"]
    m20["Examples.RuleZ"]
    m21["Examples.ToySeries"]
    m22["Examples.RuleXStatute"]
  end
  subgraph Graphs["Graphs"]
    m92["Graphs.All"]
  end
  subgraph Root["Root"]
    m93["Canteen"]
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
  m43 --> m67
  m51 --> m67
  m54 --> m67
  m56 --> m67
  m53 --> m67
  m41 --> m68
  m41 --> m69
  m12 --> m70
  m10 --> m70
  m2 --> m70
  m23 --> m71
  m23 --> m72
  m37 --> m73
  m24 --> m74
  m72 --> m74
  m27 --> m74
  m28 --> m74
  m24 --> m75
  m28 --> m75
  m72 --> m75
  m36 --> m76
  m28 --> m76
  m36 --> m77
  m27 --> m77
  m29 --> m77
  m50 --> m78
  m51 --> m78
  m54 --> m78
  m27 --> m78
  m55 --> m79
  m58 --> m79
  m46 --> m80
  m50 --> m80
  m54 --> m80
  m37 --> m81
  m29 --> m81
  m16 --> m82
  m72 --> m82
  m26 --> m82
  m27 --> m82
  m28 --> m82
  m31 --> m82
  m45 --> m82
  m46 --> m82
  m48 --> m82
  m50 --> m82
  m52 --> m82
  m57 --> m82
  m58 --> m82
  m59 --> m82
  m60 --> m82
  m61 --> m82
  m62 --> m82
  m63 --> m82
  m64 --> m82
  m65 --> m82
  m66 --> m82
  m67 --> m82
  m68 --> m82
  m69 --> m82
  m70 --> m82
  m73 --> m82
  m16 --> m83
  m74 --> m83
  m25 --> m83
  m71 --> m83
  m42 --> m83
  m16 --> m84
  m17 --> m84
  m75 --> m84
  m71 --> m84
  m16 --> m85
  m17 --> m85
  m76 --> m85
  m71 --> m85
  m16 --> m86
  m77 --> m86
  m71 --> m86
  m16 --> m87
  m78 --> m87
  m16 --> m88
  m79 --> m88
  m16 --> m89
  m80 --> m89
  m16 --> m90
  m81 --> m90
  m82 --> m91
  m83 --> m91
  m84 --> m91
  m85 --> m91
  m86 --> m91
  m90 --> m91
  m87 --> m91
  m88 --> m91
  m89 --> m91
  m22 --> m92
  m21 --> m92
  m71 --> m92
  m26 --> m92
  m74 --> m92
  m75 --> m92
  m76 --> m92
  m77 --> m92
  m31 --> m92
  m70 --> m92
  m45 --> m92
  m46 --> m92
  m48 --> m92
  m52 --> m92
  m53 --> m92
  m59 --> m92
  m60 --> m92
  m62 --> m92
  m64 --> m92
  m65 --> m92
  m68 --> m92
  m69 --> m92
  m81 --> m92
  m78 --> m92
  m79 --> m92
  m18 --> m93
  m20 --> m93
  m91 --> m93
  m92 --> m93
```

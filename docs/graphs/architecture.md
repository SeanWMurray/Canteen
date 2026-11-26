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
    m70["ITA.S43.PartialDisposition"]
    m71["ITA.S50.BadDebtPersonalUse"]
    m72["ITA.S54.Timeline"]
  end
  subgraph Lemmas["Layer 2: reusable lemmas"]
    m73["Lemmas.SuperficialLoss"]
    m74["Lemmas.SuspendedLoss"]
  end
  subgraph Transactions["Layer 3: transactions"]
    m75["Transactions.SpouseRepurchase"]
    m76["Transactions.SiblingAndLateRepurchase"]
    m77["Transactions.TfsaContribution"]
    m78["Transactions.HoldcoRepurchase"]
    m79["Transactions.Crystallization"]
    m80["Transactions.SaleThroughHoldco"]
    m81["Transactions.PostMortemPipeline"]
    m82["Transactions.SisterCompanyRepurchase"]
  end
  subgraph Blueprints["Blueprints"]
    m83["Blueprints.SuperficialLoss"]
    m84["Blueprints.SpouseRepurchase"]
    m85["Blueprints.SiblingAndLateRepurchase"]
    m86["Blueprints.TfsaContribution"]
    m87["Blueprints.HoldcoRepurchase"]
    m88["Blueprints.Crystallization"]
    m89["Blueprints.SaleThroughHoldco"]
    m90["Blueprints.PostMortemPipeline"]
    m91["Blueprints.SisterCompanyRepurchase"]
    m92["Blueprints.All"]
  end
  subgraph Examples["Examples"]
    m19["Examples.RuleX"]
    m20["Examples.RuleZ"]
    m21["Examples.ToySeries"]
    m22["Examples.RuleXStatute"]
  end
  subgraph Graphs["Graphs"]
    m93["Graphs.All"]
  end
  subgraph Root["Root"]
    m94["Canteen"]
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
  m41 --> m70
  m12 --> m71
  m10 --> m71
  m2 --> m71
  m23 --> m72
  m23 --> m73
  m37 --> m74
  m24 --> m75
  m73 --> m75
  m27 --> m75
  m28 --> m75
  m24 --> m76
  m28 --> m76
  m73 --> m76
  m36 --> m77
  m28 --> m77
  m36 --> m78
  m27 --> m78
  m29 --> m78
  m50 --> m79
  m51 --> m79
  m54 --> m79
  m27 --> m79
  m55 --> m80
  m58 --> m80
  m46 --> m81
  m50 --> m81
  m54 --> m81
  m37 --> m82
  m29 --> m82
  m16 --> m83
  m73 --> m83
  m26 --> m83
  m27 --> m83
  m28 --> m83
  m31 --> m83
  m45 --> m83
  m46 --> m83
  m48 --> m83
  m50 --> m83
  m52 --> m83
  m57 --> m83
  m58 --> m83
  m59 --> m83
  m60 --> m83
  m61 --> m83
  m62 --> m83
  m63 --> m83
  m64 --> m83
  m65 --> m83
  m66 --> m83
  m67 --> m83
  m68 --> m83
  m69 --> m83
  m70 --> m83
  m71 --> m83
  m74 --> m83
  m16 --> m84
  m75 --> m84
  m25 --> m84
  m72 --> m84
  m42 --> m84
  m16 --> m85
  m17 --> m85
  m76 --> m85
  m72 --> m85
  m16 --> m86
  m17 --> m86
  m77 --> m86
  m72 --> m86
  m16 --> m87
  m78 --> m87
  m72 --> m87
  m16 --> m88
  m79 --> m88
  m16 --> m89
  m80 --> m89
  m16 --> m90
  m81 --> m90
  m16 --> m91
  m82 --> m91
  m83 --> m92
  m84 --> m92
  m85 --> m92
  m86 --> m92
  m87 --> m92
  m91 --> m92
  m88 --> m92
  m89 --> m92
  m90 --> m92
  m22 --> m93
  m21 --> m93
  m72 --> m93
  m26 --> m93
  m75 --> m93
  m76 --> m93
  m77 --> m93
  m78 --> m93
  m31 --> m93
  m71 --> m93
  m45 --> m93
  m46 --> m93
  m48 --> m93
  m52 --> m93
  m53 --> m93
  m59 --> m93
  m60 --> m93
  m62 --> m93
  m64 --> m93
  m65 --> m93
  m68 --> m93
  m69 --> m93
  m82 --> m93
  m79 --> m93
  m80 --> m93
  m18 --> m94
  m20 --> m94
  m92 --> m94
  m93 --> m94
```

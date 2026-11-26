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
    m67["ITA.S117.Rates"]
    m68["ITA.S118.PersonalCredits"]
    m69["ITA.S120_4.SplitIncome"]
    m70["ITA.S3.IndividualYear"]
    m71["ITA.S39.CanadianSecurities"]
    m72["ITA.S50.BadDebtOrShare"]
    m73["ITA.S43.PartialDisposition"]
    m74["ITA.S74.CorporateAttribution"]
    m75["ITA.S50.BadDebtPersonalUse"]
    m76["ITA.S54.Timeline"]
  end
  subgraph Lemmas["Layer 2: reusable lemmas"]
    m77["Lemmas.SuperficialLoss"]
    m78["Lemmas.SuspendedLoss"]
  end
  subgraph Transactions["Layer 3: transactions"]
    m79["Transactions.SpouseRepurchase"]
    m80["Transactions.SiblingAndLateRepurchase"]
    m81["Transactions.TfsaContribution"]
    m82["Transactions.HoldcoRepurchase"]
    m83["Transactions.Crystallization"]
    m84["Transactions.SaleThroughHoldco"]
    m85["Transactions.PostMortemPipeline"]
    m86["Transactions.EstateFreeze"]
    m87["Transactions.SisterCompanyRepurchase"]
  end
  subgraph Blueprints["Blueprints"]
    m88["Blueprints.SuperficialLoss"]
    m89["Blueprints.SpouseRepurchase"]
    m90["Blueprints.SiblingAndLateRepurchase"]
    m91["Blueprints.TfsaContribution"]
    m92["Blueprints.HoldcoRepurchase"]
    m93["Blueprints.Crystallization"]
    m94["Blueprints.SaleThroughHoldco"]
    m95["Blueprints.PostMortemPipeline"]
    m96["Blueprints.EstateFreeze"]
    m97["Blueprints.SisterCompanyRepurchase"]
    m98["Blueprints.All"]
  end
  subgraph Examples["Examples"]
    m19["Examples.RuleX"]
    m20["Examples.RuleZ"]
    m21["Examples.ToySeries"]
    m22["Examples.RuleXStatute"]
  end
  subgraph Graphs["Graphs"]
    m99["Graphs.All"]
  end
  subgraph Root["Root"]
    m100["Canteen"]
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
  m4 --> m67
  m2 --> m67
  m67 --> m68
  m54 --> m69
  m10 --> m69
  m43 --> m70
  m51 --> m70
  m56 --> m70
  m53 --> m70
  m68 --> m70
  m69 --> m70
  m41 --> m71
  m41 --> m72
  m41 --> m73
  m54 --> m74
  m10 --> m74
  m12 --> m75
  m10 --> m75
  m2 --> m75
  m23 --> m76
  m23 --> m77
  m37 --> m78
  m24 --> m79
  m77 --> m79
  m27 --> m79
  m28 --> m79
  m24 --> m80
  m28 --> m80
  m77 --> m80
  m36 --> m81
  m28 --> m81
  m36 --> m82
  m27 --> m82
  m29 --> m82
  m50 --> m83
  m51 --> m83
  m54 --> m83
  m27 --> m83
  m55 --> m84
  m58 --> m84
  m46 --> m85
  m50 --> m85
  m54 --> m85
  m59 --> m86
  m74 --> m86
  m37 --> m87
  m29 --> m87
  m16 --> m88
  m77 --> m88
  m26 --> m88
  m27 --> m88
  m28 --> m88
  m31 --> m88
  m45 --> m88
  m46 --> m88
  m48 --> m88
  m50 --> m88
  m52 --> m88
  m57 --> m88
  m58 --> m88
  m59 --> m88
  m60 --> m88
  m61 --> m88
  m62 --> m88
  m63 --> m88
  m64 --> m88
  m65 --> m88
  m66 --> m88
  m70 --> m88
  m71 --> m88
  m72 --> m88
  m73 --> m88
  m74 --> m88
  m75 --> m88
  m78 --> m88
  m16 --> m89
  m79 --> m89
  m25 --> m89
  m76 --> m89
  m42 --> m89
  m16 --> m90
  m17 --> m90
  m80 --> m90
  m76 --> m90
  m16 --> m91
  m17 --> m91
  m81 --> m91
  m76 --> m91
  m16 --> m92
  m82 --> m92
  m76 --> m92
  m16 --> m93
  m83 --> m93
  m16 --> m94
  m84 --> m94
  m16 --> m95
  m85 --> m95
  m16 --> m96
  m86 --> m96
  m16 --> m97
  m87 --> m97
  m88 --> m98
  m89 --> m98
  m90 --> m98
  m91 --> m98
  m92 --> m98
  m97 --> m98
  m93 --> m98
  m94 --> m98
  m95 --> m98
  m96 --> m98
  m22 --> m99
  m21 --> m99
  m76 --> m99
  m26 --> m99
  m79 --> m99
  m80 --> m99
  m81 --> m99
  m82 --> m99
  m31 --> m99
  m75 --> m99
  m45 --> m99
  m46 --> m99
  m48 --> m99
  m52 --> m99
  m53 --> m99
  m60 --> m99
  m62 --> m99
  m64 --> m99
  m65 --> m99
  m71 --> m99
  m72 --> m99
  m87 --> m99
  m83 --> m99
  m84 --> m99
  m86 --> m99
  m18 --> m100
  m20 --> m100
  m98 --> m100
  m99 --> m100
```

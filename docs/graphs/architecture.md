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
    m69["ITA.S118_1.Donations"]
    m70["ITA.S120_4.SplitIncome"]
    m71["ITA.S3.IndividualYear"]
    m72["ITA.S39.CanadianSecurities"]
    m73["ITA.S50.BadDebtOrShare"]
    m74["ITA.S43.PartialDisposition"]
    m75["ITA.S74.CorporateAttribution"]
    m76["ITA.S123.CorporateRates"]
    m77["ITA.S129.RefundableTax"]
    m78["ITA.S15.ShareholderLoans"]
    m79["ITA.S89.GeneralRateIncomePool"]
    m80["ITA.S127_5.MinimumTax"]
    m81["ITA.S50.BadDebtPersonalUse"]
    m82["ITA.S54.Timeline"]
  end
  subgraph Lemmas["Layer 2: reusable lemmas"]
    m83["Lemmas.SuperficialLoss"]
    m84["Lemmas.SuspendedLoss"]
  end
  subgraph Transactions["Layer 3: transactions"]
    m85["Transactions.SpouseRepurchase"]
    m86["Transactions.SiblingAndLateRepurchase"]
    m87["Transactions.TfsaContribution"]
    m88["Transactions.HoldcoRepurchase"]
    m89["Transactions.Crystallization"]
    m90["Transactions.SaleThroughHoldco"]
    m91["Transactions.PostMortemPipeline"]
    m92["Transactions.EstateFreeze"]
    m93["Transactions.DonatingShares"]
    m94["Transactions.InvestmentIncomeIntegration"]
    m95["Transactions.EligibleDesignation"]
    m96["Transactions.CrystallizationMinimumTax"]
    m97["Transactions.SisterCompanyRepurchase"]
  end
  subgraph Blueprints["Blueprints"]
    m98["Blueprints.SuperficialLoss"]
    m99["Blueprints.SpouseRepurchase"]
    m100["Blueprints.SiblingAndLateRepurchase"]
    m101["Blueprints.TfsaContribution"]
    m102["Blueprints.HoldcoRepurchase"]
    m103["Blueprints.Crystallization"]
    m104["Blueprints.SaleThroughHoldco"]
    m105["Blueprints.PostMortemPipeline"]
    m106["Blueprints.EstateFreeze"]
    m107["Blueprints.DonatingShares"]
    m108["Blueprints.InvestmentIncomeIntegration"]
    m109["Blueprints.EligibleDesignation"]
    m110["Blueprints.CrystallizationMinimumTax"]
    m111["Blueprints.SisterCompanyRepurchase"]
    m112["Blueprints.All"]
  end
  subgraph Examples["Examples"]
    m19["Examples.RuleX"]
    m20["Examples.RuleZ"]
    m21["Examples.ToySeries"]
    m22["Examples.RuleXStatute"]
  end
  subgraph Graphs["Graphs"]
    m113["Graphs.All"]
  end
  subgraph Root["Root"]
    m114["Canteen"]
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
  m67 --> m69
  m54 --> m70
  m10 --> m70
  m43 --> m71
  m51 --> m71
  m56 --> m71
  m53 --> m71
  m68 --> m71
  m69 --> m71
  m70 --> m71
  m41 --> m72
  m41 --> m73
  m41 --> m74
  m54 --> m75
  m10 --> m75
  m4 --> m76
  m2 --> m76
  m76 --> m77
  m12 --> m78
  m10 --> m78
  m1 --> m78
  m2 --> m78
  m76 --> m79
  m10 --> m79
  m71 --> m80
  m12 --> m81
  m10 --> m81
  m2 --> m81
  m23 --> m82
  m23 --> m83
  m37 --> m84
  m24 --> m85
  m83 --> m85
  m27 --> m85
  m28 --> m85
  m24 --> m86
  m28 --> m86
  m83 --> m86
  m36 --> m87
  m28 --> m87
  m36 --> m88
  m27 --> m88
  m29 --> m88
  m50 --> m89
  m51 --> m89
  m54 --> m89
  m27 --> m89
  m55 --> m90
  m58 --> m90
  m46 --> m91
  m50 --> m91
  m54 --> m91
  m59 --> m92
  m75 --> m92
  m71 --> m93
  m71 --> m94
  m77 --> m94
  m71 --> m95
  m79 --> m95
  m80 --> m96
  m37 --> m97
  m29 --> m97
  m16 --> m98
  m83 --> m98
  m26 --> m98
  m27 --> m98
  m28 --> m98
  m31 --> m98
  m45 --> m98
  m46 --> m98
  m48 --> m98
  m50 --> m98
  m52 --> m98
  m57 --> m98
  m58 --> m98
  m59 --> m98
  m60 --> m98
  m61 --> m98
  m62 --> m98
  m63 --> m98
  m64 --> m98
  m65 --> m98
  m66 --> m98
  m72 --> m98
  m73 --> m98
  m74 --> m98
  m75 --> m98
  m77 --> m98
  m78 --> m98
  m79 --> m98
  m80 --> m98
  m81 --> m98
  m84 --> m98
  m16 --> m99
  m85 --> m99
  m25 --> m99
  m82 --> m99
  m42 --> m99
  m16 --> m100
  m17 --> m100
  m86 --> m100
  m82 --> m100
  m16 --> m101
  m17 --> m101
  m87 --> m101
  m82 --> m101
  m16 --> m102
  m88 --> m102
  m82 --> m102
  m16 --> m103
  m89 --> m103
  m16 --> m104
  m90 --> m104
  m16 --> m105
  m91 --> m105
  m16 --> m106
  m92 --> m106
  m16 --> m107
  m93 --> m107
  m16 --> m108
  m94 --> m108
  m16 --> m109
  m95 --> m109
  m16 --> m110
  m96 --> m110
  m16 --> m111
  m97 --> m111
  m98 --> m112
  m99 --> m112
  m100 --> m112
  m101 --> m112
  m102 --> m112
  m111 --> m112
  m103 --> m112
  m104 --> m112
  m105 --> m112
  m106 --> m112
  m107 --> m112
  m108 --> m112
  m109 --> m112
  m110 --> m112
  m22 --> m113
  m21 --> m113
  m82 --> m113
  m26 --> m113
  m85 --> m113
  m86 --> m113
  m87 --> m113
  m88 --> m113
  m31 --> m113
  m81 --> m113
  m45 --> m113
  m46 --> m113
  m48 --> m113
  m52 --> m113
  m60 --> m113
  m62 --> m113
  m64 --> m113
  m78 --> m113
  m79 --> m113
  m80 --> m113
  m65 --> m113
  m72 --> m113
  m73 --> m113
  m97 --> m113
  m89 --> m113
  m90 --> m113
  m92 --> m113
  m18 --> m114
  m20 --> m114
  m112 --> m114
  m113 --> m114
```

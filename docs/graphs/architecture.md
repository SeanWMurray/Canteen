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
    m71["ITA.S20.InterestDeductibility"]
    m72["ITA.S3.IndividualYear"]
    m73["ITA.S39.CanadianSecurities"]
    m74["ITA.S50.BadDebtOrShare"]
    m75["ITA.S43.PartialDisposition"]
    m76["ITA.S74.CorporateAttribution"]
    m77["ITA.S123.CorporateRates"]
    m78["ITA.S129.RefundableTax"]
    m79["ITA.S15.ShareholderLoans"]
    m80["ITA.S89.GeneralRateIncomePool"]
    m81["ITA.S127_5.MinimumTax"]
    m82["ITA.S50.BadDebtPersonalUse"]
    m83["ITA.S54.Timeline"]
  end
  subgraph Lemmas["Layer 2: reusable lemmas"]
    m84["Lemmas.SuperficialLoss"]
    m85["Lemmas.SuspendedLoss"]
  end
  subgraph Transactions["Layer 3: transactions"]
    m86["Transactions.SpouseRepurchase"]
    m87["Transactions.SiblingAndLateRepurchase"]
    m88["Transactions.TfsaContribution"]
    m89["Transactions.HoldcoRepurchase"]
    m90["Transactions.Crystallization"]
    m91["Transactions.SaleThroughHoldco"]
    m92["Transactions.PostMortemPipeline"]
    m93["Transactions.EstateFreeze"]
    m94["Transactions.DonatingShares"]
    m95["Transactions.InvestmentIncomeIntegration"]
    m96["Transactions.EligibleDesignation"]
    m97["Transactions.CrystallizationMinimumTax"]
    m98["Transactions.DebtSwap"]
    m99["Transactions.SisterCompanyRepurchase"]
  end
  subgraph Blueprints["Blueprints"]
    m100["Blueprints.SuperficialLoss"]
    m101["Blueprints.SpouseRepurchase"]
    m102["Blueprints.SiblingAndLateRepurchase"]
    m103["Blueprints.TfsaContribution"]
    m104["Blueprints.HoldcoRepurchase"]
    m105["Blueprints.Crystallization"]
    m106["Blueprints.SaleThroughHoldco"]
    m107["Blueprints.PostMortemPipeline"]
    m108["Blueprints.EstateFreeze"]
    m109["Blueprints.DonatingShares"]
    m110["Blueprints.InvestmentIncomeIntegration"]
    m111["Blueprints.EligibleDesignation"]
    m112["Blueprints.CrystallizationMinimumTax"]
    m113["Blueprints.DebtSwap"]
    m114["Blueprints.SisterCompanyRepurchase"]
    m115["Blueprints.All"]
  end
  subgraph Examples["Examples"]
    m19["Examples.RuleX"]
    m20["Examples.RuleZ"]
    m21["Examples.ToySeries"]
    m22["Examples.RuleXStatute"]
  end
  subgraph Graphs["Graphs"]
    m116["Graphs.All"]
  end
  subgraph Root["Root"]
    m117["Canteen"]
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
  m12 --> m71
  m10 --> m71
  m2 --> m71
  m43 --> m72
  m51 --> m72
  m56 --> m72
  m53 --> m72
  m68 --> m72
  m69 --> m72
  m70 --> m72
  m71 --> m72
  m41 --> m73
  m41 --> m74
  m41 --> m75
  m54 --> m76
  m10 --> m76
  m4 --> m77
  m2 --> m77
  m77 --> m78
  m12 --> m79
  m10 --> m79
  m1 --> m79
  m2 --> m79
  m77 --> m80
  m10 --> m80
  m72 --> m81
  m12 --> m82
  m10 --> m82
  m2 --> m82
  m23 --> m83
  m23 --> m84
  m37 --> m85
  m24 --> m86
  m84 --> m86
  m27 --> m86
  m28 --> m86
  m24 --> m87
  m28 --> m87
  m84 --> m87
  m36 --> m88
  m28 --> m88
  m36 --> m89
  m27 --> m89
  m29 --> m89
  m50 --> m90
  m51 --> m90
  m54 --> m90
  m27 --> m90
  m55 --> m91
  m58 --> m91
  m46 --> m92
  m50 --> m92
  m54 --> m92
  m59 --> m93
  m76 --> m93
  m81 --> m94
  m72 --> m95
  m78 --> m95
  m72 --> m96
  m80 --> m96
  m81 --> m97
  m81 --> m98
  m27 --> m98
  m37 --> m99
  m29 --> m99
  m16 --> m100
  m84 --> m100
  m26 --> m100
  m27 --> m100
  m28 --> m100
  m31 --> m100
  m45 --> m100
  m46 --> m100
  m48 --> m100
  m50 --> m100
  m52 --> m100
  m57 --> m100
  m58 --> m100
  m59 --> m100
  m60 --> m100
  m61 --> m100
  m62 --> m100
  m63 --> m100
  m64 --> m100
  m65 --> m100
  m66 --> m100
  m73 --> m100
  m74 --> m100
  m75 --> m100
  m76 --> m100
  m78 --> m100
  m79 --> m100
  m80 --> m100
  m81 --> m100
  m82 --> m100
  m85 --> m100
  m16 --> m101
  m86 --> m101
  m25 --> m101
  m83 --> m101
  m42 --> m101
  m16 --> m102
  m17 --> m102
  m87 --> m102
  m83 --> m102
  m16 --> m103
  m17 --> m103
  m88 --> m103
  m83 --> m103
  m16 --> m104
  m89 --> m104
  m83 --> m104
  m16 --> m105
  m90 --> m105
  m16 --> m106
  m91 --> m106
  m16 --> m107
  m92 --> m107
  m16 --> m108
  m93 --> m108
  m16 --> m109
  m94 --> m109
  m16 --> m110
  m95 --> m110
  m16 --> m111
  m96 --> m111
  m16 --> m112
  m97 --> m112
  m16 --> m113
  m98 --> m113
  m16 --> m114
  m99 --> m114
  m100 --> m115
  m101 --> m115
  m102 --> m115
  m103 --> m115
  m104 --> m115
  m114 --> m115
  m105 --> m115
  m106 --> m115
  m107 --> m115
  m108 --> m115
  m109 --> m115
  m110 --> m115
  m111 --> m115
  m112 --> m115
  m113 --> m115
  m22 --> m116
  m21 --> m116
  m83 --> m116
  m26 --> m116
  m86 --> m116
  m87 --> m116
  m88 --> m116
  m89 --> m116
  m31 --> m116
  m82 --> m116
  m45 --> m116
  m46 --> m116
  m48 --> m116
  m52 --> m116
  m60 --> m116
  m62 --> m116
  m64 --> m116
  m79 --> m116
  m80 --> m116
  m98 --> m116
  m65 --> m116
  m73 --> m116
  m74 --> m116
  m99 --> m116
  m90 --> m116
  m91 --> m116
  m93 --> m116
  m18 --> m117
  m20 --> m117
  m115 --> m117
  m116 --> m117
```

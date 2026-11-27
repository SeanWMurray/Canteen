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
    m72["ITA.S118_2.MedicalExpenses"]
    m73["ITA.S118_3.Disability"]
    m74["ITA.S60_03.PensionSplitting"]
    m75["ITA.S180_2.OasRecovery"]
    m76["ITA.S3.IndividualYear"]
    m77["ITA.S39.CanadianSecurities"]
    m78["ITA.S50.BadDebtOrShare"]
    m79["ITA.S43.PartialDisposition"]
    m80["ITA.S74.CorporateAttribution"]
    m81["ITA.S123.CorporateRates"]
    m82["ITA.S129.RefundableTax"]
    m83["ITA.S15.ShareholderLoans"]
    m84["ITA.S89.GeneralRateIncomePool"]
    m85["ITA.S127_5.MinimumTax"]
    m86["ITA.S50.BadDebtPersonalUse"]
    m87["ITA.S54.Timeline"]
  end
  subgraph Lemmas["Layer 2: reusable lemmas"]
    m88["Lemmas.SuperficialLoss"]
    m89["Lemmas.SuspendedLoss"]
  end
  subgraph Transactions["Layer 3: transactions"]
    m90["Transactions.SpouseRepurchase"]
    m91["Transactions.SiblingAndLateRepurchase"]
    m92["Transactions.TfsaContribution"]
    m93["Transactions.HoldcoRepurchase"]
    m94["Transactions.Crystallization"]
    m95["Transactions.SaleThroughHoldco"]
    m96["Transactions.PostMortemPipeline"]
    m97["Transactions.EstateFreeze"]
    m98["Transactions.DonatingShares"]
    m99["Transactions.InvestmentIncomeIntegration"]
    m100["Transactions.EligibleDesignation"]
    m101["Transactions.CrystallizationMinimumTax"]
    m102["Transactions.DebtSwap"]
    m103["Transactions.AttendantCare"]
    m104["Transactions.PensionSplit"]
    m105["Transactions.SisterCompanyRepurchase"]
  end
  subgraph Blueprints["Blueprints"]
    m106["Blueprints.SuperficialLoss"]
    m107["Blueprints.SpouseRepurchase"]
    m108["Blueprints.SiblingAndLateRepurchase"]
    m109["Blueprints.TfsaContribution"]
    m110["Blueprints.HoldcoRepurchase"]
    m111["Blueprints.Crystallization"]
    m112["Blueprints.SaleThroughHoldco"]
    m113["Blueprints.PostMortemPipeline"]
    m114["Blueprints.EstateFreeze"]
    m115["Blueprints.DonatingShares"]
    m116["Blueprints.InvestmentIncomeIntegration"]
    m117["Blueprints.EligibleDesignation"]
    m118["Blueprints.CrystallizationMinimumTax"]
    m119["Blueprints.DebtSwap"]
    m120["Blueprints.AttendantCare"]
    m121["Blueprints.PensionSplit"]
    m122["Blueprints.SisterCompanyRepurchase"]
    m123["Blueprints.All"]
  end
  subgraph Examples["Examples"]
    m19["Examples.RuleX"]
    m20["Examples.RuleZ"]
    m21["Examples.ToySeries"]
    m22["Examples.RuleXStatute"]
  end
  subgraph Graphs["Graphs"]
    m124["Graphs.All"]
  end
  subgraph Root["Root"]
    m125["Canteen"]
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
  m10 --> m72
  m2 --> m72
  m12 --> m73
  m10 --> m73
  m2 --> m73
  m2 --> m74
  m2 --> m75
  m43 --> m76
  m51 --> m76
  m56 --> m76
  m53 --> m76
  m68 --> m76
  m69 --> m76
  m70 --> m76
  m71 --> m76
  m72 --> m76
  m73 --> m76
  m74 --> m76
  m75 --> m76
  m41 --> m77
  m41 --> m78
  m41 --> m79
  m54 --> m80
  m10 --> m80
  m4 --> m81
  m2 --> m81
  m81 --> m82
  m12 --> m83
  m10 --> m83
  m1 --> m83
  m2 --> m83
  m81 --> m84
  m10 --> m84
  m76 --> m85
  m12 --> m86
  m10 --> m86
  m2 --> m86
  m23 --> m87
  m23 --> m88
  m37 --> m89
  m24 --> m90
  m88 --> m90
  m27 --> m90
  m28 --> m90
  m24 --> m91
  m28 --> m91
  m88 --> m91
  m36 --> m92
  m28 --> m92
  m36 --> m93
  m27 --> m93
  m29 --> m93
  m50 --> m94
  m51 --> m94
  m54 --> m94
  m27 --> m94
  m55 --> m95
  m58 --> m95
  m46 --> m96
  m50 --> m96
  m54 --> m96
  m59 --> m97
  m80 --> m97
  m85 --> m98
  m76 --> m99
  m82 --> m99
  m76 --> m100
  m84 --> m100
  m85 --> m101
  m85 --> m102
  m27 --> m102
  m85 --> m103
  m85 --> m104
  m37 --> m105
  m29 --> m105
  m16 --> m106
  m88 --> m106
  m26 --> m106
  m27 --> m106
  m28 --> m106
  m31 --> m106
  m45 --> m106
  m46 --> m106
  m48 --> m106
  m50 --> m106
  m52 --> m106
  m57 --> m106
  m58 --> m106
  m59 --> m106
  m60 --> m106
  m61 --> m106
  m62 --> m106
  m63 --> m106
  m64 --> m106
  m65 --> m106
  m66 --> m106
  m77 --> m106
  m78 --> m106
  m79 --> m106
  m80 --> m106
  m82 --> m106
  m83 --> m106
  m84 --> m106
  m85 --> m106
  m86 --> m106
  m89 --> m106
  m16 --> m107
  m90 --> m107
  m25 --> m107
  m87 --> m107
  m42 --> m107
  m16 --> m108
  m17 --> m108
  m91 --> m108
  m87 --> m108
  m16 --> m109
  m17 --> m109
  m92 --> m109
  m87 --> m109
  m16 --> m110
  m93 --> m110
  m87 --> m110
  m16 --> m111
  m94 --> m111
  m16 --> m112
  m95 --> m112
  m16 --> m113
  m96 --> m113
  m16 --> m114
  m97 --> m114
  m16 --> m115
  m98 --> m115
  m16 --> m116
  m99 --> m116
  m16 --> m117
  m100 --> m117
  m16 --> m118
  m101 --> m118
  m16 --> m119
  m102 --> m119
  m16 --> m120
  m103 --> m120
  m16 --> m121
  m104 --> m121
  m16 --> m122
  m105 --> m122
  m106 --> m123
  m107 --> m123
  m108 --> m123
  m109 --> m123
  m110 --> m123
  m122 --> m123
  m111 --> m123
  m112 --> m123
  m113 --> m123
  m114 --> m123
  m115 --> m123
  m116 --> m123
  m117 --> m123
  m118 --> m123
  m119 --> m123
  m120 --> m123
  m121 --> m123
  m22 --> m124
  m21 --> m124
  m87 --> m124
  m26 --> m124
  m90 --> m124
  m91 --> m124
  m92 --> m124
  m93 --> m124
  m31 --> m124
  m86 --> m124
  m45 --> m124
  m46 --> m124
  m48 --> m124
  m52 --> m124
  m60 --> m124
  m62 --> m124
  m64 --> m124
  m83 --> m124
  m84 --> m124
  m102 --> m124
  m65 --> m124
  m77 --> m124
  m78 --> m124
  m105 --> m124
  m94 --> m124
  m95 --> m124
  m97 --> m124
  m18 --> m125
  m20 --> m125
  m123 --> m125
  m124 --> m125
```

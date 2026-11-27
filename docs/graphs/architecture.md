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
    m76["ITA.S118_7.EmploymentCredits"]
    m77["ITA.S117_1.Cpi"]
    m78["ITA.S117_1.Indexation"]
    m79["ITA.S117_1.YearAmounts"]
    m80["ITA.S118_01.SmallCredits"]
    m81["ITA.S118_5.Tuition"]
    m82["ITA.S56.Support"]
    m83["ITA.S63.ChildCare"]
    m84["ITA.S62.MovingExpenses"]
    m85["ITA.S6.StandbyCharge"]
    m86["ITA.S3.IndividualYear"]
    m87["ITA.S39.CanadianSecurities"]
    m88["ITA.S50.BadDebtOrShare"]
    m89["ITA.S43.PartialDisposition"]
    m90["ITA.S74.CorporateAttribution"]
    m91["ITA.S123.CorporateRates"]
    m92["ITA.S129.RefundableTax"]
    m93["ITA.S15.ShareholderLoans"]
    m94["ITA.S89.GeneralRateIncomePool"]
    m95["ITA.S127_5.MinimumTax"]
    m96["ITA.S84.PaidUpCapitalIncrease"]
    m97["ITA.S112.StopLoss"]
    m98["ITA.S50.BadDebtPersonalUse"]
    m99["ITA.S54.Timeline"]
  end
  subgraph Lemmas["Layer 2: reusable lemmas"]
    m100["Lemmas.SuperficialLoss"]
    m101["Lemmas.SuspendedLoss"]
  end
  subgraph Transactions["Layer 3: transactions"]
    m102["Transactions.SpouseRepurchase"]
    m103["Transactions.SiblingAndLateRepurchase"]
    m104["Transactions.TfsaContribution"]
    m105["Transactions.HoldcoRepurchase"]
    m106["Transactions.Crystallization"]
    m107["Transactions.SaleThroughHoldco"]
    m108["Transactions.PostMortemPipeline"]
    m109["Transactions.EstateFreeze"]
    m110["Transactions.DonatingShares"]
    m111["Transactions.InvestmentIncomeIntegration"]
    m112["Transactions.EligibleDesignation"]
    m113["Transactions.CrystallizationMinimumTax"]
    m114["Transactions.DebtSwap"]
    m115["Transactions.AttendantCare"]
    m116["Transactions.PensionSplit"]
    m117["Transactions.SalaryOrDividend"]
    m118["Transactions.SupportArrears"]
    m119["Transactions.SisterCompanyRepurchase"]
  end
  subgraph Blueprints["Blueprints"]
    m120["Blueprints.SuperficialLoss"]
    m121["Blueprints.SpouseRepurchase"]
    m122["Blueprints.SiblingAndLateRepurchase"]
    m123["Blueprints.TfsaContribution"]
    m124["Blueprints.HoldcoRepurchase"]
    m125["Blueprints.Crystallization"]
    m126["Blueprints.SaleThroughHoldco"]
    m127["Blueprints.PostMortemPipeline"]
    m128["Blueprints.EstateFreeze"]
    m129["Blueprints.DonatingShares"]
    m130["Blueprints.InvestmentIncomeIntegration"]
    m131["Blueprints.EligibleDesignation"]
    m132["Blueprints.CrystallizationMinimumTax"]
    m133["Blueprints.DebtSwap"]
    m134["Blueprints.AttendantCare"]
    m135["Blueprints.PensionSplit"]
    m136["Blueprints.SalaryOrDividend"]
    m137["Blueprints.SupportArrears"]
    m138["Blueprints.SisterCompanyRepurchase"]
    m139["Blueprints.All"]
  end
  subgraph Examples["Examples"]
    m19["Examples.RuleX"]
    m20["Examples.RuleZ"]
    m21["Examples.ToySeries"]
    m22["Examples.RuleXStatute"]
  end
  subgraph Graphs["Graphs"]
    m140["Graphs.All"]
  end
  subgraph Root["Root"]
    m141["Canteen"]
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
  m12 --> m68
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
  m2 --> m76
  m77 --> m78
  m2 --> m78
  m78 --> m79
  m67 --> m79
  m2 --> m80
  m2 --> m81
  m12 --> m82
  m10 --> m82
  m2 --> m82
  m2 --> m83
  m4 --> m83
  m12 --> m84
  m2 --> m84
  m2 --> m85
  m4 --> m85
  m43 --> m86
  m51 --> m86
  m56 --> m86
  m53 --> m86
  m68 --> m86
  m69 --> m86
  m70 --> m86
  m71 --> m86
  m72 --> m86
  m73 --> m86
  m74 --> m86
  m75 --> m86
  m76 --> m86
  m79 --> m86
  m80 --> m86
  m81 --> m86
  m82 --> m86
  m83 --> m86
  m84 --> m86
  m85 --> m86
  m41 --> m87
  m41 --> m88
  m41 --> m89
  m54 --> m90
  m10 --> m90
  m4 --> m91
  m2 --> m91
  m91 --> m92
  m12 --> m93
  m10 --> m93
  m1 --> m93
  m2 --> m93
  m91 --> m94
  m10 --> m94
  m86 --> m95
  m54 --> m96
  m41 --> m97
  m12 --> m98
  m10 --> m98
  m2 --> m98
  m23 --> m99
  m23 --> m100
  m37 --> m101
  m24 --> m102
  m100 --> m102
  m27 --> m102
  m28 --> m102
  m24 --> m103
  m28 --> m103
  m100 --> m103
  m36 --> m104
  m28 --> m104
  m36 --> m105
  m27 --> m105
  m29 --> m105
  m50 --> m106
  m51 --> m106
  m54 --> m106
  m27 --> m106
  m55 --> m107
  m58 --> m107
  m46 --> m108
  m50 --> m108
  m54 --> m108
  m59 --> m109
  m90 --> m109
  m95 --> m110
  m86 --> m111
  m92 --> m111
  m86 --> m112
  m94 --> m112
  m95 --> m113
  m95 --> m114
  m27 --> m114
  m95 --> m115
  m95 --> m116
  m95 --> m117
  m91 --> m117
  m95 --> m118
  m37 --> m119
  m29 --> m119
  m16 --> m120
  m100 --> m120
  m26 --> m120
  m27 --> m120
  m28 --> m120
  m31 --> m120
  m45 --> m120
  m46 --> m120
  m48 --> m120
  m50 --> m120
  m52 --> m120
  m57 --> m120
  m58 --> m120
  m59 --> m120
  m60 --> m120
  m61 --> m120
  m62 --> m120
  m63 --> m120
  m64 --> m120
  m65 --> m120
  m66 --> m120
  m87 --> m120
  m88 --> m120
  m89 --> m120
  m90 --> m120
  m92 --> m120
  m93 --> m120
  m94 --> m120
  m95 --> m120
  m96 --> m120
  m97 --> m120
  m98 --> m120
  m101 --> m120
  m16 --> m121
  m102 --> m121
  m25 --> m121
  m99 --> m121
  m42 --> m121
  m16 --> m122
  m17 --> m122
  m103 --> m122
  m99 --> m122
  m16 --> m123
  m17 --> m123
  m104 --> m123
  m99 --> m123
  m16 --> m124
  m105 --> m124
  m99 --> m124
  m16 --> m125
  m106 --> m125
  m16 --> m126
  m107 --> m126
  m16 --> m127
  m108 --> m127
  m16 --> m128
  m109 --> m128
  m16 --> m129
  m110 --> m129
  m16 --> m130
  m111 --> m130
  m16 --> m131
  m112 --> m131
  m16 --> m132
  m113 --> m132
  m16 --> m133
  m114 --> m133
  m16 --> m134
  m115 --> m134
  m16 --> m135
  m116 --> m135
  m16 --> m136
  m117 --> m136
  m16 --> m137
  m118 --> m137
  m16 --> m138
  m119 --> m138
  m120 --> m139
  m121 --> m139
  m122 --> m139
  m123 --> m139
  m124 --> m139
  m138 --> m139
  m125 --> m139
  m126 --> m139
  m127 --> m139
  m128 --> m139
  m129 --> m139
  m130 --> m139
  m131 --> m139
  m132 --> m139
  m133 --> m139
  m134 --> m139
  m135 --> m139
  m136 --> m139
  m137 --> m139
  m22 --> m140
  m21 --> m140
  m99 --> m140
  m26 --> m140
  m102 --> m140
  m103 --> m140
  m104 --> m140
  m105 --> m140
  m31 --> m140
  m98 --> m140
  m45 --> m140
  m46 --> m140
  m48 --> m140
  m52 --> m140
  m60 --> m140
  m62 --> m140
  m64 --> m140
  m93 --> m140
  m94 --> m140
  m96 --> m140
  m97 --> m140
  m114 --> m140
  m65 --> m140
  m87 --> m140
  m88 --> m140
  m119 --> m140
  m106 --> m140
  m107 --> m140
  m109 --> m140
  m18 --> m141
  m20 --> m141
  m139 --> m141
  m140 --> m141
```

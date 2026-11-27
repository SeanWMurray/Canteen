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
    m44["ITA.S111.NonCapitalLoss"]
    m45["ITA.S69.NonArmsLength"]
    m46["ITA.S73.SpousalRollover"]
    m47["ITA.S70.Death"]
    m48["ITA.S74.Attribution"]
    m49["ITA.S45.ChangeInUse"]
    m50["ITA.S85.TransferToCorporation"]
    m51["ITA.S84_1.SurplusStripping"]
    m52["ITA.S110_6.CapitalGainsDeduction"]
    m53["ITA.S251_2.LossRestrictionEvent"]
    m54["ITA.S74.IncomeAttribution"]
    m55["ITA.S82.Dividends"]
    m56["ITA.S55.IntercorporateDividends"]
    m57["ITA.S13.Depreciable"]
    m58["ITA.S84.Redemption"]
    m59["ITA.S89.CapitalDividendAccount"]
    m60["ITA.S86.ShareExchange"]
    m61["ITA.S44.ReplacementProperty"]
    m62["ITA.S47.IdenticalProperties"]
    m63["ITA.S186.Connected"]
    m64["ITA.S84.ReturnOfCapital"]
    m65["ITA.S88.WindingUp"]
    m66["ITA.S87.Amalgamation"]
    m67["ITA.S51.ConvertibleProperty"]
    m68["ITA.S117.Rates"]
    m69["ITA.S118.PersonalCredits"]
    m70["ITA.S118_1.Donations"]
    m71["ITA.S120_4.SplitIncome"]
    m72["ITA.S20.InterestDeductibility"]
    m73["ITA.S118_2.MedicalExpenses"]
    m74["ITA.S118_3.Disability"]
    m75["ITA.S60_03.PensionSplitting"]
    m76["ITA.S180_2.OasRecovery"]
    m77["ITA.S118_7.EmploymentCredits"]
    m78["ITA.S117_1.Cpi"]
    m79["ITA.S117_1.Indexation"]
    m80["ITA.S117_1.YearAmounts"]
    m81["ITA.S118_01.SmallCredits"]
    m82["ITA.S118_5.Tuition"]
    m83["ITA.S56.Support"]
    m84["ITA.S63.ChildCare"]
    m85["ITA.S62.MovingExpenses"]
    m86["ITA.S6.StandbyCharge"]
    m87["ITA.S15.ShareholderBenefit"]
    m88["ITA.S7.StockOptions"]
    m89["ITA.S3.IndividualYear"]
    m90["ITA.S39.CanadianSecurities"]
    m91["ITA.S50.BadDebtOrShare"]
    m92["ITA.S43.PartialDisposition"]
    m93["ITA.S74.CorporateAttribution"]
    m94["ITA.S123.CorporateRates"]
    m95["ITA.S129.RefundableTax"]
    m96["ITA.S15.ShareholderLoans"]
    m97["ITA.S89.GeneralRateIncomePool"]
    m98["ITA.S127_5.MinimumTax"]
    m99["ITA.S84.PaidUpCapitalIncrease"]
    m100["ITA.S112.StopLoss"]
    m101["ITA.S84.WindingUpDividend"]
    m102["ITA.S44_1.SmallBusinessRollover"]
    m103["ITA.S46.PersonalUse"]
    m104["ITA.S110_1.CorporateDonations"]
    m105["ITA.S3.CorporateYear"]
    m106["ITA.S50.BadDebtPersonalUse"]
    m107["ITA.S54.Timeline"]
  end
  subgraph Lemmas["Layer 2: reusable lemmas"]
    m108["Lemmas.SuperficialLoss"]
    m109["Lemmas.SuspendedLoss"]
  end
  subgraph Transactions["Layer 3: transactions"]
    m110["Transactions.SpouseRepurchase"]
    m111["Transactions.SiblingAndLateRepurchase"]
    m112["Transactions.TfsaContribution"]
    m113["Transactions.HoldcoRepurchase"]
    m114["Transactions.Crystallization"]
    m115["Transactions.SaleThroughHoldco"]
    m116["Transactions.PostMortemPipeline"]
    m117["Transactions.EstateFreeze"]
    m118["Transactions.DonatingShares"]
    m119["Transactions.InvestmentIncomeIntegration"]
    m120["Transactions.EligibleDesignation"]
    m121["Transactions.CrystallizationMinimumTax"]
    m122["Transactions.DebtSwap"]
    m123["Transactions.AttendantCare"]
    m124["Transactions.PensionSplit"]
    m125["Transactions.SalaryOrDividend"]
    m126["Transactions.SupportArrears"]
    m127["Transactions.SisterCompanyRepurchase"]
  end
  subgraph Blueprints["Blueprints"]
    m128["Blueprints.SuperficialLoss"]
    m129["Blueprints.SpouseRepurchase"]
    m130["Blueprints.SiblingAndLateRepurchase"]
    m131["Blueprints.TfsaContribution"]
    m132["Blueprints.HoldcoRepurchase"]
    m133["Blueprints.Crystallization"]
    m134["Blueprints.SaleThroughHoldco"]
    m135["Blueprints.PostMortemPipeline"]
    m136["Blueprints.EstateFreeze"]
    m137["Blueprints.DonatingShares"]
    m138["Blueprints.InvestmentIncomeIntegration"]
    m139["Blueprints.EligibleDesignation"]
    m140["Blueprints.CrystallizationMinimumTax"]
    m141["Blueprints.DebtSwap"]
    m142["Blueprints.AttendantCare"]
    m143["Blueprints.PensionSplit"]
    m144["Blueprints.SalaryOrDividend"]
    m145["Blueprints.SupportArrears"]
    m146["Blueprints.SisterCompanyRepurchase"]
    m147["Blueprints.All"]
  end
  subgraph Examples["Examples"]
    m19["Examples.RuleX"]
    m20["Examples.RuleZ"]
    m21["Examples.ToySeries"]
    m22["Examples.RuleXStatute"]
  end
  subgraph Graphs["Graphs"]
    m148["Graphs.All"]
  end
  subgraph Root["Root"]
    m149["Canteen"]
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
  m41 --> m45
  m45 --> m46
  m41 --> m47
  m41 --> m48
  m41 --> m49
  m41 --> m50
  m50 --> m51
  m41 --> m52
  m12 --> m53
  m30 --> m53
  m48 --> m54
  m12 --> m55
  m2 --> m55
  m12 --> m56
  m10 --> m56
  m2 --> m56
  m41 --> m57
  m41 --> m58
  m55 --> m58
  m56 --> m58
  m41 --> m59
  m50 --> m60
  m41 --> m61
  m41 --> m62
  m12 --> m63
  m30 --> m63
  m41 --> m64
  m41 --> m65
  m50 --> m66
  m50 --> m67
  m4 --> m68
  m2 --> m68
  m68 --> m69
  m12 --> m69
  m68 --> m70
  m55 --> m71
  m10 --> m71
  m12 --> m72
  m10 --> m72
  m2 --> m72
  m10 --> m73
  m2 --> m73
  m12 --> m74
  m10 --> m74
  m2 --> m74
  m2 --> m75
  m2 --> m76
  m2 --> m77
  m78 --> m79
  m2 --> m79
  m79 --> m80
  m68 --> m80
  m2 --> m81
  m2 --> m82
  m12 --> m83
  m10 --> m83
  m2 --> m83
  m2 --> m84
  m4 --> m84
  m12 --> m85
  m2 --> m85
  m2 --> m86
  m4 --> m86
  m12 --> m87
  m10 --> m87
  m2 --> m87
  m2 --> m88
  m1 --> m88
  m4 --> m88
  m43 --> m89
  m52 --> m89
  m57 --> m89
  m54 --> m89
  m69 --> m89
  m70 --> m89
  m71 --> m89
  m72 --> m89
  m73 --> m89
  m74 --> m89
  m75 --> m89
  m76 --> m89
  m77 --> m89
  m80 --> m89
  m81 --> m89
  m82 --> m89
  m83 --> m89
  m84 --> m89
  m85 --> m89
  m86 --> m89
  m87 --> m89
  m88 --> m89
  m41 --> m90
  m41 --> m91
  m41 --> m92
  m55 --> m93
  m10 --> m93
  m4 --> m94
  m2 --> m94
  m94 --> m95
  m12 --> m96
  m10 --> m96
  m1 --> m96
  m2 --> m96
  m94 --> m97
  m10 --> m97
  m89 --> m98
  m55 --> m99
  m41 --> m100
  m41 --> m101
  m55 --> m101
  m12 --> m102
  m10 --> m102
  m2 --> m102
  m1 --> m102
  m41 --> m103
  m2 --> m104
  m4 --> m104
  m43 --> m105
  m44 --> m105
  m56 --> m105
  m104 --> m105
  m95 --> m105
  m97 --> m105
  m59 --> m105
  m12 --> m106
  m10 --> m106
  m2 --> m106
  m23 --> m107
  m23 --> m108
  m37 --> m109
  m24 --> m110
  m108 --> m110
  m27 --> m110
  m28 --> m110
  m24 --> m111
  m28 --> m111
  m108 --> m111
  m36 --> m112
  m28 --> m112
  m36 --> m113
  m27 --> m113
  m29 --> m113
  m51 --> m114
  m52 --> m114
  m55 --> m114
  m27 --> m114
  m56 --> m115
  m59 --> m115
  m47 --> m116
  m51 --> m116
  m55 --> m116
  m60 --> m117
  m93 --> m117
  m98 --> m118
  m89 --> m119
  m95 --> m119
  m89 --> m120
  m97 --> m120
  m98 --> m121
  m98 --> m122
  m27 --> m122
  m98 --> m123
  m98 --> m124
  m98 --> m125
  m94 --> m125
  m98 --> m126
  m37 --> m127
  m29 --> m127
  m16 --> m128
  m108 --> m128
  m26 --> m128
  m27 --> m128
  m28 --> m128
  m31 --> m128
  m46 --> m128
  m47 --> m128
  m49 --> m128
  m51 --> m128
  m53 --> m128
  m58 --> m128
  m60 --> m128
  m61 --> m128
  m62 --> m128
  m63 --> m128
  m64 --> m128
  m65 --> m128
  m66 --> m128
  m67 --> m128
  m90 --> m128
  m91 --> m128
  m92 --> m128
  m93 --> m128
  m96 --> m128
  m98 --> m128
  m99 --> m128
  m100 --> m128
  m101 --> m128
  m102 --> m128
  m103 --> m128
  m105 --> m128
  m106 --> m128
  m109 --> m128
  m16 --> m129
  m110 --> m129
  m25 --> m129
  m107 --> m129
  m42 --> m129
  m16 --> m130
  m17 --> m130
  m111 --> m130
  m107 --> m130
  m16 --> m131
  m17 --> m131
  m112 --> m131
  m107 --> m131
  m16 --> m132
  m113 --> m132
  m107 --> m132
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
  m16 --> m139
  m120 --> m139
  m16 --> m140
  m121 --> m140
  m16 --> m141
  m122 --> m141
  m16 --> m142
  m123 --> m142
  m16 --> m143
  m124 --> m143
  m16 --> m144
  m125 --> m144
  m16 --> m145
  m126 --> m145
  m16 --> m146
  m127 --> m146
  m128 --> m147
  m129 --> m147
  m130 --> m147
  m131 --> m147
  m132 --> m147
  m146 --> m147
  m133 --> m147
  m134 --> m147
  m135 --> m147
  m136 --> m147
  m137 --> m147
  m138 --> m147
  m139 --> m147
  m140 --> m147
  m141 --> m147
  m142 --> m147
  m143 --> m147
  m144 --> m147
  m145 --> m147
  m22 --> m148
  m21 --> m148
  m107 --> m148
  m26 --> m148
  m110 --> m148
  m111 --> m148
  m112 --> m148
  m113 --> m148
  m31 --> m148
  m106 --> m148
  m46 --> m148
  m47 --> m148
  m49 --> m148
  m53 --> m148
  m61 --> m148
  m63 --> m148
  m65 --> m148
  m96 --> m148
  m99 --> m148
  m100 --> m148
  m101 --> m148
  m102 --> m148
  m103 --> m148
  m105 --> m148
  m122 --> m148
  m66 --> m148
  m90 --> m148
  m91 --> m148
  m127 --> m148
  m114 --> m148
  m115 --> m148
  m117 --> m148
  m18 --> m149
  m20 --> m149
  m147 --> m149
  m148 --> m149
```

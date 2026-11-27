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
    m86["ITA.S15.ShareholderBenefit"]
    m87["ITA.S7.StockOptions"]
    m88["ITA.S3.IndividualYear"]
    m89["ITA.S39.CanadianSecurities"]
    m90["ITA.S50.BadDebtOrShare"]
    m91["ITA.S43.PartialDisposition"]
    m92["ITA.S74.CorporateAttribution"]
    m93["ITA.S123.CorporateRates"]
    m94["ITA.S129.RefundableTax"]
    m95["ITA.S15.ShareholderLoans"]
    m96["ITA.S89.GeneralRateIncomePool"]
    m97["ITA.S127_5.MinimumTax"]
    m98["ITA.S84.PaidUpCapitalIncrease"]
    m99["ITA.S112.StopLoss"]
    m100["ITA.S84.WindingUpDividend"]
    m101["ITA.S44_1.SmallBusinessRollover"]
    m102["ITA.S46.PersonalUse"]
    m103["ITA.S110_1.CorporateDonations"]
    m104["ITA.S3.CorporateYear"]
    m105["ITA.S50.BadDebtPersonalUse"]
    m106["ITA.S54.Timeline"]
  end
  subgraph Lemmas["Layer 2: reusable lemmas"]
    m107["Lemmas.SuperficialLoss"]
    m108["Lemmas.SuspendedLoss"]
  end
  subgraph Transactions["Layer 3: transactions"]
    m109["Transactions.SpouseRepurchase"]
    m110["Transactions.SiblingAndLateRepurchase"]
    m111["Transactions.TfsaContribution"]
    m112["Transactions.HoldcoRepurchase"]
    m113["Transactions.Crystallization"]
    m114["Transactions.SaleThroughHoldco"]
    m115["Transactions.PostMortemPipeline"]
    m116["Transactions.EstateFreeze"]
    m117["Transactions.DonatingShares"]
    m118["Transactions.InvestmentIncomeIntegration"]
    m119["Transactions.EligibleDesignation"]
    m120["Transactions.CrystallizationMinimumTax"]
    m121["Transactions.DebtSwap"]
    m122["Transactions.AttendantCare"]
    m123["Transactions.PensionSplit"]
    m124["Transactions.SalaryOrDividend"]
    m125["Transactions.SupportArrears"]
    m126["Transactions.SisterCompanyRepurchase"]
  end
  subgraph Blueprints["Blueprints"]
    m127["Blueprints.SuperficialLoss"]
    m128["Blueprints.SpouseRepurchase"]
    m129["Blueprints.SiblingAndLateRepurchase"]
    m130["Blueprints.TfsaContribution"]
    m131["Blueprints.HoldcoRepurchase"]
    m132["Blueprints.Crystallization"]
    m133["Blueprints.SaleThroughHoldco"]
    m134["Blueprints.PostMortemPipeline"]
    m135["Blueprints.EstateFreeze"]
    m136["Blueprints.DonatingShares"]
    m137["Blueprints.InvestmentIncomeIntegration"]
    m138["Blueprints.EligibleDesignation"]
    m139["Blueprints.CrystallizationMinimumTax"]
    m140["Blueprints.DebtSwap"]
    m141["Blueprints.AttendantCare"]
    m142["Blueprints.PensionSplit"]
    m143["Blueprints.SalaryOrDividend"]
    m144["Blueprints.SupportArrears"]
    m145["Blueprints.SisterCompanyRepurchase"]
    m146["Blueprints.All"]
  end
  subgraph Examples["Examples"]
    m19["Examples.RuleX"]
    m20["Examples.RuleZ"]
    m21["Examples.ToySeries"]
    m22["Examples.RuleXStatute"]
  end
  subgraph Graphs["Graphs"]
    m147["Graphs.All"]
  end
  subgraph Root["Root"]
    m148["Canteen"]
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
  m12 --> m86
  m10 --> m86
  m2 --> m86
  m2 --> m87
  m1 --> m87
  m4 --> m87
  m43 --> m88
  m51 --> m88
  m56 --> m88
  m53 --> m88
  m68 --> m88
  m69 --> m88
  m70 --> m88
  m71 --> m88
  m72 --> m88
  m73 --> m88
  m74 --> m88
  m75 --> m88
  m76 --> m88
  m79 --> m88
  m80 --> m88
  m81 --> m88
  m82 --> m88
  m83 --> m88
  m84 --> m88
  m85 --> m88
  m86 --> m88
  m87 --> m88
  m41 --> m89
  m41 --> m90
  m41 --> m91
  m54 --> m92
  m10 --> m92
  m4 --> m93
  m2 --> m93
  m93 --> m94
  m12 --> m95
  m10 --> m95
  m1 --> m95
  m2 --> m95
  m93 --> m96
  m10 --> m96
  m88 --> m97
  m54 --> m98
  m41 --> m99
  m41 --> m100
  m54 --> m100
  m12 --> m101
  m10 --> m101
  m2 --> m101
  m1 --> m101
  m41 --> m102
  m2 --> m103
  m4 --> m103
  m43 --> m104
  m55 --> m104
  m103 --> m104
  m94 --> m104
  m96 --> m104
  m58 --> m104
  m12 --> m105
  m10 --> m105
  m2 --> m105
  m23 --> m106
  m23 --> m107
  m37 --> m108
  m24 --> m109
  m107 --> m109
  m27 --> m109
  m28 --> m109
  m24 --> m110
  m28 --> m110
  m107 --> m110
  m36 --> m111
  m28 --> m111
  m36 --> m112
  m27 --> m112
  m29 --> m112
  m50 --> m113
  m51 --> m113
  m54 --> m113
  m27 --> m113
  m55 --> m114
  m58 --> m114
  m46 --> m115
  m50 --> m115
  m54 --> m115
  m59 --> m116
  m92 --> m116
  m97 --> m117
  m88 --> m118
  m94 --> m118
  m88 --> m119
  m96 --> m119
  m97 --> m120
  m97 --> m121
  m27 --> m121
  m97 --> m122
  m97 --> m123
  m97 --> m124
  m93 --> m124
  m97 --> m125
  m37 --> m126
  m29 --> m126
  m16 --> m127
  m107 --> m127
  m26 --> m127
  m27 --> m127
  m28 --> m127
  m31 --> m127
  m45 --> m127
  m46 --> m127
  m48 --> m127
  m50 --> m127
  m52 --> m127
  m57 --> m127
  m59 --> m127
  m60 --> m127
  m61 --> m127
  m62 --> m127
  m63 --> m127
  m64 --> m127
  m65 --> m127
  m66 --> m127
  m89 --> m127
  m90 --> m127
  m91 --> m127
  m92 --> m127
  m95 --> m127
  m97 --> m127
  m98 --> m127
  m99 --> m127
  m100 --> m127
  m101 --> m127
  m102 --> m127
  m104 --> m127
  m105 --> m127
  m108 --> m127
  m16 --> m128
  m109 --> m128
  m25 --> m128
  m106 --> m128
  m42 --> m128
  m16 --> m129
  m17 --> m129
  m110 --> m129
  m106 --> m129
  m16 --> m130
  m17 --> m130
  m111 --> m130
  m106 --> m130
  m16 --> m131
  m112 --> m131
  m106 --> m131
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
  m127 --> m146
  m128 --> m146
  m129 --> m146
  m130 --> m146
  m131 --> m146
  m145 --> m146
  m132 --> m146
  m133 --> m146
  m134 --> m146
  m135 --> m146
  m136 --> m146
  m137 --> m146
  m138 --> m146
  m139 --> m146
  m140 --> m146
  m141 --> m146
  m142 --> m146
  m143 --> m146
  m144 --> m146
  m22 --> m147
  m21 --> m147
  m106 --> m147
  m26 --> m147
  m109 --> m147
  m110 --> m147
  m111 --> m147
  m112 --> m147
  m31 --> m147
  m105 --> m147
  m45 --> m147
  m46 --> m147
  m48 --> m147
  m52 --> m147
  m60 --> m147
  m62 --> m147
  m64 --> m147
  m95 --> m147
  m98 --> m147
  m99 --> m147
  m100 --> m147
  m101 --> m147
  m102 --> m147
  m104 --> m147
  m121 --> m147
  m65 --> m147
  m89 --> m147
  m90 --> m147
  m126 --> m147
  m113 --> m147
  m114 --> m147
  m116 --> m147
  m18 --> m148
  m20 --> m148
  m146 --> m148
  m147 --> m148
```

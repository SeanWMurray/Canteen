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
    m105["ITA.S125.BusinessLimit"]
    m106["ITA.S256.Associated"]
    m107["ITA.S67_1.MealsEntertainment"]
    m108["ITA.S20.FinancingExpenses"]
    m109["ITA.S18.WorkSpace"]
    m110["ITA.S20.DoubtfulDebts"]
    m111["ITA.S20.AdvancePayments"]
    m112["ITA.S20.InstalmentSales"]
    m113["ITA.S3.CorporateYear"]
    m114["ITA.S50.BadDebtPersonalUse"]
    m115["ITA.S54.Timeline"]
  end
  subgraph Lemmas["Layer 2: reusable lemmas"]
    m116["Lemmas.SuperficialLoss"]
    m117["Lemmas.SuspendedLoss"]
  end
  subgraph Transactions["Layer 3: transactions"]
    m118["Transactions.SpouseRepurchase"]
    m119["Transactions.SiblingAndLateRepurchase"]
    m120["Transactions.TfsaContribution"]
    m121["Transactions.HoldcoRepurchase"]
    m122["Transactions.Crystallization"]
    m123["Transactions.SaleThroughHoldco"]
    m124["Transactions.PostMortemPipeline"]
    m125["Transactions.EstateFreeze"]
    m126["Transactions.DonatingShares"]
    m127["Transactions.InvestmentIncomeIntegration"]
    m128["Transactions.EligibleDesignation"]
    m129["Transactions.CrystallizationMinimumTax"]
    m130["Transactions.DebtSwap"]
    m131["Transactions.AttendantCare"]
    m132["Transactions.PensionSplit"]
    m133["Transactions.SalaryOrDividend"]
    m134["Transactions.SupportArrears"]
    m135["Transactions.SisterCompanyRepurchase"]
  end
  subgraph Blueprints["Blueprints"]
    m136["Blueprints.SuperficialLoss"]
    m137["Blueprints.SpouseRepurchase"]
    m138["Blueprints.SiblingAndLateRepurchase"]
    m139["Blueprints.TfsaContribution"]
    m140["Blueprints.HoldcoRepurchase"]
    m141["Blueprints.Crystallization"]
    m142["Blueprints.SaleThroughHoldco"]
    m143["Blueprints.PostMortemPipeline"]
    m144["Blueprints.EstateFreeze"]
    m145["Blueprints.DonatingShares"]
    m146["Blueprints.InvestmentIncomeIntegration"]
    m147["Blueprints.EligibleDesignation"]
    m148["Blueprints.CrystallizationMinimumTax"]
    m149["Blueprints.DebtSwap"]
    m150["Blueprints.AttendantCare"]
    m151["Blueprints.PensionSplit"]
    m152["Blueprints.SalaryOrDividend"]
    m153["Blueprints.SupportArrears"]
    m154["Blueprints.SisterCompanyRepurchase"]
    m155["Blueprints.All"]
  end
  subgraph Examples["Examples"]
    m19["Examples.RuleX"]
    m20["Examples.RuleZ"]
    m21["Examples.ToySeries"]
    m22["Examples.RuleXStatute"]
  end
  subgraph Graphs["Graphs"]
    m156["Graphs.All"]
  end
  subgraph Root["Root"]
    m157["Canteen"]
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
  m2 --> m105
  m4 --> m105
  m30 --> m106
  m2 --> m107
  m10 --> m107
  m2 --> m108
  m4 --> m108
  m2 --> m109
  m10 --> m109
  m2 --> m110
  m10 --> m110
  m2 --> m111
  m4 --> m111
  m2 --> m112
  m4 --> m112
  m1 --> m112
  m43 --> m113
  m44 --> m113
  m56 --> m113
  m104 --> m113
  m95 --> m113
  m105 --> m113
  m97 --> m113
  m59 --> m113
  m12 --> m114
  m10 --> m114
  m2 --> m114
  m23 --> m115
  m23 --> m116
  m37 --> m117
  m24 --> m118
  m116 --> m118
  m27 --> m118
  m28 --> m118
  m24 --> m119
  m28 --> m119
  m116 --> m119
  m36 --> m120
  m28 --> m120
  m36 --> m121
  m27 --> m121
  m29 --> m121
  m51 --> m122
  m52 --> m122
  m55 --> m122
  m27 --> m122
  m56 --> m123
  m59 --> m123
  m47 --> m124
  m51 --> m124
  m55 --> m124
  m60 --> m125
  m93 --> m125
  m98 --> m126
  m89 --> m127
  m95 --> m127
  m89 --> m128
  m97 --> m128
  m98 --> m129
  m98 --> m130
  m27 --> m130
  m98 --> m131
  m98 --> m132
  m98 --> m133
  m94 --> m133
  m98 --> m134
  m37 --> m135
  m29 --> m135
  m16 --> m136
  m116 --> m136
  m26 --> m136
  m27 --> m136
  m28 --> m136
  m31 --> m136
  m46 --> m136
  m47 --> m136
  m49 --> m136
  m51 --> m136
  m53 --> m136
  m58 --> m136
  m60 --> m136
  m61 --> m136
  m62 --> m136
  m63 --> m136
  m64 --> m136
  m65 --> m136
  m66 --> m136
  m67 --> m136
  m90 --> m136
  m91 --> m136
  m92 --> m136
  m93 --> m136
  m96 --> m136
  m98 --> m136
  m99 --> m136
  m100 --> m136
  m101 --> m136
  m102 --> m136
  m103 --> m136
  m106 --> m136
  m107 --> m136
  m108 --> m136
  m109 --> m136
  m110 --> m136
  m111 --> m136
  m112 --> m136
  m113 --> m136
  m114 --> m136
  m117 --> m136
  m16 --> m137
  m118 --> m137
  m25 --> m137
  m115 --> m137
  m42 --> m137
  m16 --> m138
  m17 --> m138
  m119 --> m138
  m115 --> m138
  m16 --> m139
  m17 --> m139
  m120 --> m139
  m115 --> m139
  m16 --> m140
  m121 --> m140
  m115 --> m140
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
  m16 --> m147
  m128 --> m147
  m16 --> m148
  m129 --> m148
  m16 --> m149
  m130 --> m149
  m16 --> m150
  m131 --> m150
  m16 --> m151
  m132 --> m151
  m16 --> m152
  m133 --> m152
  m16 --> m153
  m134 --> m153
  m16 --> m154
  m135 --> m154
  m136 --> m155
  m137 --> m155
  m138 --> m155
  m139 --> m155
  m140 --> m155
  m154 --> m155
  m141 --> m155
  m142 --> m155
  m143 --> m155
  m144 --> m155
  m145 --> m155
  m146 --> m155
  m147 --> m155
  m148 --> m155
  m149 --> m155
  m150 --> m155
  m151 --> m155
  m152 --> m155
  m153 --> m155
  m22 --> m156
  m21 --> m156
  m115 --> m156
  m26 --> m156
  m118 --> m156
  m119 --> m156
  m120 --> m156
  m121 --> m156
  m31 --> m156
  m114 --> m156
  m46 --> m156
  m47 --> m156
  m49 --> m156
  m53 --> m156
  m61 --> m156
  m63 --> m156
  m65 --> m156
  m96 --> m156
  m99 --> m156
  m100 --> m156
  m101 --> m156
  m102 --> m156
  m103 --> m156
  m106 --> m156
  m107 --> m156
  m108 --> m156
  m109 --> m156
  m110 --> m156
  m111 --> m156
  m112 --> m156
  m113 --> m156
  m130 --> m156
  m66 --> m156
  m90 --> m156
  m91 --> m156
  m135 --> m156
  m122 --> m156
  m123 --> m156
  m125 --> m156
  m18 --> m157
  m20 --> m157
  m155 --> m157
  m156 --> m157
```

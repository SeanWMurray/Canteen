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
    m113["ITA.S18.PrepaidExpenses"]
    m114["ITA.S18.ThinCapitalization"]
    m115["ITA.S212.Withholding"]
    m116["ITA.S3.CorporateYear"]
    m117["ITA.S50.BadDebtPersonalUse"]
    m118["ITA.S54.Timeline"]
  end
  subgraph Lemmas["Layer 2: reusable lemmas"]
    m119["Lemmas.SuperficialLoss"]
    m120["Lemmas.SuspendedLoss"]
  end
  subgraph Transactions["Layer 3: transactions"]
    m121["Transactions.SpouseRepurchase"]
    m122["Transactions.SiblingAndLateRepurchase"]
    m123["Transactions.TfsaContribution"]
    m124["Transactions.HoldcoRepurchase"]
    m125["Transactions.Crystallization"]
    m126["Transactions.SaleThroughHoldco"]
    m127["Transactions.PostMortemPipeline"]
    m128["Transactions.EstateFreeze"]
    m129["Transactions.DonatingShares"]
    m130["Transactions.InvestmentIncomeIntegration"]
    m131["Transactions.EligibleDesignation"]
    m132["Transactions.CrystallizationMinimumTax"]
    m133["Transactions.DebtSwap"]
    m134["Transactions.AttendantCare"]
    m135["Transactions.PensionSplit"]
    m136["Transactions.SalaryOrDividend"]
    m137["Transactions.SupportArrears"]
    m138["Transactions.SisterCompanyRepurchase"]
  end
  subgraph Blueprints["Blueprints"]
    m139["Blueprints.SuperficialLoss"]
    m140["Blueprints.SpouseRepurchase"]
    m141["Blueprints.SiblingAndLateRepurchase"]
    m142["Blueprints.TfsaContribution"]
    m143["Blueprints.HoldcoRepurchase"]
    m144["Blueprints.Crystallization"]
    m145["Blueprints.SaleThroughHoldco"]
    m146["Blueprints.PostMortemPipeline"]
    m147["Blueprints.EstateFreeze"]
    m148["Blueprints.DonatingShares"]
    m149["Blueprints.InvestmentIncomeIntegration"]
    m150["Blueprints.EligibleDesignation"]
    m151["Blueprints.CrystallizationMinimumTax"]
    m152["Blueprints.DebtSwap"]
    m153["Blueprints.AttendantCare"]
    m154["Blueprints.PensionSplit"]
    m155["Blueprints.SalaryOrDividend"]
    m156["Blueprints.SupportArrears"]
    m157["Blueprints.SisterCompanyRepurchase"]
    m158["Blueprints.All"]
  end
  subgraph Examples["Examples"]
    m19["Examples.RuleX"]
    m20["Examples.RuleZ"]
    m21["Examples.ToySeries"]
    m22["Examples.RuleXStatute"]
  end
  subgraph Graphs["Graphs"]
    m159["Graphs.All"]
  end
  subgraph Root["Root"]
    m160["Canteen"]
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
  m2 --> m113
  m4 --> m113
  m1 --> m113
  m2 --> m114
  m4 --> m114
  m2 --> m115
  m4 --> m115
  m43 --> m116
  m44 --> m116
  m56 --> m116
  m104 --> m116
  m95 --> m116
  m105 --> m116
  m97 --> m116
  m59 --> m116
  m12 --> m117
  m10 --> m117
  m2 --> m117
  m23 --> m118
  m23 --> m119
  m37 --> m120
  m24 --> m121
  m119 --> m121
  m27 --> m121
  m28 --> m121
  m24 --> m122
  m28 --> m122
  m119 --> m122
  m36 --> m123
  m28 --> m123
  m36 --> m124
  m27 --> m124
  m29 --> m124
  m51 --> m125
  m52 --> m125
  m55 --> m125
  m27 --> m125
  m56 --> m126
  m59 --> m126
  m47 --> m127
  m51 --> m127
  m55 --> m127
  m60 --> m128
  m93 --> m128
  m98 --> m129
  m89 --> m130
  m95 --> m130
  m89 --> m131
  m97 --> m131
  m98 --> m132
  m98 --> m133
  m27 --> m133
  m98 --> m134
  m98 --> m135
  m98 --> m136
  m94 --> m136
  m98 --> m137
  m37 --> m138
  m29 --> m138
  m16 --> m139
  m119 --> m139
  m26 --> m139
  m27 --> m139
  m28 --> m139
  m31 --> m139
  m46 --> m139
  m47 --> m139
  m49 --> m139
  m51 --> m139
  m53 --> m139
  m58 --> m139
  m60 --> m139
  m61 --> m139
  m62 --> m139
  m63 --> m139
  m64 --> m139
  m65 --> m139
  m66 --> m139
  m67 --> m139
  m90 --> m139
  m91 --> m139
  m92 --> m139
  m93 --> m139
  m96 --> m139
  m98 --> m139
  m99 --> m139
  m100 --> m139
  m101 --> m139
  m102 --> m139
  m103 --> m139
  m106 --> m139
  m107 --> m139
  m108 --> m139
  m109 --> m139
  m110 --> m139
  m111 --> m139
  m112 --> m139
  m113 --> m139
  m114 --> m139
  m115 --> m139
  m116 --> m139
  m117 --> m139
  m120 --> m139
  m16 --> m140
  m121 --> m140
  m25 --> m140
  m118 --> m140
  m42 --> m140
  m16 --> m141
  m17 --> m141
  m122 --> m141
  m118 --> m141
  m16 --> m142
  m17 --> m142
  m123 --> m142
  m118 --> m142
  m16 --> m143
  m124 --> m143
  m118 --> m143
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
  m16 --> m155
  m136 --> m155
  m16 --> m156
  m137 --> m156
  m16 --> m157
  m138 --> m157
  m139 --> m158
  m140 --> m158
  m141 --> m158
  m142 --> m158
  m143 --> m158
  m157 --> m158
  m144 --> m158
  m145 --> m158
  m146 --> m158
  m147 --> m158
  m148 --> m158
  m149 --> m158
  m150 --> m158
  m151 --> m158
  m152 --> m158
  m153 --> m158
  m154 --> m158
  m155 --> m158
  m156 --> m158
  m22 --> m159
  m21 --> m159
  m118 --> m159
  m26 --> m159
  m121 --> m159
  m122 --> m159
  m123 --> m159
  m124 --> m159
  m31 --> m159
  m117 --> m159
  m46 --> m159
  m47 --> m159
  m49 --> m159
  m53 --> m159
  m61 --> m159
  m63 --> m159
  m65 --> m159
  m96 --> m159
  m99 --> m159
  m100 --> m159
  m101 --> m159
  m102 --> m159
  m103 --> m159
  m106 --> m159
  m107 --> m159
  m108 --> m159
  m109 --> m159
  m110 --> m159
  m111 --> m159
  m112 --> m159
  m113 --> m159
  m114 --> m159
  m115 --> m159
  m116 --> m159
  m133 --> m159
  m66 --> m159
  m90 --> m159
  m91 --> m159
  m138 --> m159
  m125 --> m159
  m126 --> m159
  m128 --> m159
  m18 --> m160
  m20 --> m160
  m158 --> m160
  m159 --> m160
```

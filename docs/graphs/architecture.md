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
    m89["ITA.S118_62.StudentLoanInterest"]
    m90["ITA.S3.IndividualYear"]
    m91["ITA.S39.CanadianSecurities"]
    m92["ITA.S50.BadDebtOrShare"]
    m93["ITA.S43.PartialDisposition"]
    m94["ITA.S74.CorporateAttribution"]
    m95["ITA.S123.CorporateRates"]
    m96["ITA.S129.RefundableTax"]
    m97["ITA.S15.ShareholderLoans"]
    m98["ITA.S89.GeneralRateIncomePool"]
    m99["ITA.S127_5.MinimumTax"]
    m100["ITA.S84.PaidUpCapitalIncrease"]
    m101["ITA.S112.StopLoss"]
    m102["ITA.S84.WindingUpDividend"]
    m103["ITA.S44_1.SmallBusinessRollover"]
    m104["ITA.S46.PersonalUse"]
    m105["ITA.S110_1.CorporateDonations"]
    m106["ITA.S125.BusinessLimit"]
    m107["ITA.S256.Associated"]
    m108["ITA.S67_1.MealsEntertainment"]
    m109["ITA.S20.FinancingExpenses"]
    m110["ITA.S18.WorkSpace"]
    m111["ITA.S20.DoubtfulDebts"]
    m112["ITA.S20.AdvancePayments"]
    m113["ITA.S20.InstalmentSales"]
    m114["ITA.S18.PrepaidExpenses"]
    m115["ITA.S18.ThinCapitalization"]
    m116["ITA.S212.Withholding"]
    m117["ITA.S216.RentalElection"]
    m118["ITA.S248.TaxableCanadianProperty"]
    m119["ITA.S116.Purchaser"]
    m120["ITA.S128_1.Emigration"]
    m121["ITA.S75.ReversionaryTrust"]
    m122["ITA.S107.TrustDistribution"]
    m123["ITA.S3.CorporateYear"]
    m124["ITA.S50.BadDebtPersonalUse"]
    m125["ITA.S54.Timeline"]
  end
  subgraph Lemmas["Layer 2: reusable lemmas"]
    m126["Lemmas.SuperficialLoss"]
    m127["Lemmas.SuspendedLoss"]
  end
  subgraph Transactions["Layer 3: transactions"]
    m128["Transactions.SpouseRepurchase"]
    m129["Transactions.SiblingAndLateRepurchase"]
    m130["Transactions.TfsaContribution"]
    m131["Transactions.HoldcoRepurchase"]
    m132["Transactions.Crystallization"]
    m133["Transactions.SaleThroughHoldco"]
    m134["Transactions.PostMortemPipeline"]
    m135["Transactions.EstateFreeze"]
    m136["Transactions.DonatingShares"]
    m137["Transactions.InvestmentIncomeIntegration"]
    m138["Transactions.EligibleDesignation"]
    m139["Transactions.CrystallizationMinimumTax"]
    m140["Transactions.DebtSwap"]
    m141["Transactions.AttendantCare"]
    m142["Transactions.PensionSplit"]
    m143["Transactions.SalaryOrDividend"]
    m144["Transactions.SupportArrears"]
    m145["Transactions.SisterCompanyRepurchase"]
  end
  subgraph Blueprints["Blueprints"]
    m146["Blueprints.SuperficialLoss"]
    m147["Blueprints.SpouseRepurchase"]
    m148["Blueprints.SiblingAndLateRepurchase"]
    m149["Blueprints.TfsaContribution"]
    m150["Blueprints.HoldcoRepurchase"]
    m151["Blueprints.Crystallization"]
    m152["Blueprints.SaleThroughHoldco"]
    m153["Blueprints.PostMortemPipeline"]
    m154["Blueprints.EstateFreeze"]
    m155["Blueprints.DonatingShares"]
    m156["Blueprints.InvestmentIncomeIntegration"]
    m157["Blueprints.EligibleDesignation"]
    m158["Blueprints.CrystallizationMinimumTax"]
    m159["Blueprints.DebtSwap"]
    m160["Blueprints.AttendantCare"]
    m161["Blueprints.PensionSplit"]
    m162["Blueprints.SalaryOrDividend"]
    m163["Blueprints.SupportArrears"]
    m164["Blueprints.SisterCompanyRepurchase"]
    m165["Blueprints.All"]
  end
  subgraph Examples["Examples"]
    m19["Examples.RuleX"]
    m20["Examples.RuleZ"]
    m21["Examples.ToySeries"]
    m22["Examples.RuleXStatute"]
  end
  subgraph Graphs["Graphs"]
    m166["Graphs.All"]
  end
  subgraph Root["Root"]
    m167["Canteen"]
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
  m2 --> m89
  m4 --> m89
  m43 --> m90
  m52 --> m90
  m57 --> m90
  m54 --> m90
  m69 --> m90
  m70 --> m90
  m71 --> m90
  m72 --> m90
  m73 --> m90
  m74 --> m90
  m75 --> m90
  m76 --> m90
  m77 --> m90
  m80 --> m90
  m81 --> m90
  m82 --> m90
  m83 --> m90
  m84 --> m90
  m85 --> m90
  m86 --> m90
  m87 --> m90
  m88 --> m90
  m89 --> m90
  m41 --> m91
  m41 --> m92
  m41 --> m93
  m55 --> m94
  m10 --> m94
  m4 --> m95
  m2 --> m95
  m95 --> m96
  m12 --> m97
  m10 --> m97
  m1 --> m97
  m2 --> m97
  m95 --> m98
  m10 --> m98
  m90 --> m99
  m55 --> m100
  m41 --> m101
  m41 --> m102
  m55 --> m102
  m12 --> m103
  m10 --> m103
  m2 --> m103
  m1 --> m103
  m41 --> m104
  m2 --> m105
  m4 --> m105
  m2 --> m106
  m4 --> m106
  m30 --> m107
  m2 --> m108
  m10 --> m108
  m2 --> m109
  m4 --> m109
  m2 --> m110
  m10 --> m110
  m2 --> m111
  m10 --> m111
  m2 --> m112
  m4 --> m112
  m2 --> m113
  m4 --> m113
  m1 --> m113
  m2 --> m114
  m4 --> m114
  m1 --> m114
  m2 --> m115
  m4 --> m115
  m2 --> m116
  m4 --> m116
  m80 --> m117
  m4 --> m118
  m2 --> m119
  m10 --> m119
  m118 --> m119
  m41 --> m120
  m118 --> m120
  m41 --> m121
  m2 --> m122
  m4 --> m122
  m43 --> m123
  m44 --> m123
  m56 --> m123
  m105 --> m123
  m96 --> m123
  m106 --> m123
  m98 --> m123
  m59 --> m123
  m12 --> m124
  m10 --> m124
  m2 --> m124
  m23 --> m125
  m23 --> m126
  m37 --> m127
  m24 --> m128
  m126 --> m128
  m27 --> m128
  m28 --> m128
  m24 --> m129
  m28 --> m129
  m126 --> m129
  m36 --> m130
  m28 --> m130
  m36 --> m131
  m27 --> m131
  m29 --> m131
  m51 --> m132
  m52 --> m132
  m55 --> m132
  m27 --> m132
  m56 --> m133
  m59 --> m133
  m47 --> m134
  m51 --> m134
  m55 --> m134
  m60 --> m135
  m94 --> m135
  m99 --> m136
  m90 --> m137
  m96 --> m137
  m90 --> m138
  m98 --> m138
  m99 --> m139
  m99 --> m140
  m27 --> m140
  m99 --> m141
  m99 --> m142
  m99 --> m143
  m95 --> m143
  m99 --> m144
  m37 --> m145
  m29 --> m145
  m16 --> m146
  m126 --> m146
  m26 --> m146
  m27 --> m146
  m28 --> m146
  m31 --> m146
  m46 --> m146
  m47 --> m146
  m49 --> m146
  m51 --> m146
  m53 --> m146
  m58 --> m146
  m60 --> m146
  m61 --> m146
  m62 --> m146
  m63 --> m146
  m64 --> m146
  m65 --> m146
  m66 --> m146
  m67 --> m146
  m91 --> m146
  m92 --> m146
  m93 --> m146
  m94 --> m146
  m97 --> m146
  m99 --> m146
  m100 --> m146
  m101 --> m146
  m102 --> m146
  m103 --> m146
  m104 --> m146
  m107 --> m146
  m108 --> m146
  m109 --> m146
  m110 --> m146
  m111 --> m146
  m112 --> m146
  m113 --> m146
  m114 --> m146
  m115 --> m146
  m116 --> m146
  m117 --> m146
  m119 --> m146
  m120 --> m146
  m121 --> m146
  m122 --> m146
  m123 --> m146
  m124 --> m146
  m127 --> m146
  m16 --> m147
  m128 --> m147
  m25 --> m147
  m125 --> m147
  m42 --> m147
  m16 --> m148
  m17 --> m148
  m129 --> m148
  m125 --> m148
  m16 --> m149
  m17 --> m149
  m130 --> m149
  m125 --> m149
  m16 --> m150
  m131 --> m150
  m125 --> m150
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
  m16 --> m158
  m139 --> m158
  m16 --> m159
  m140 --> m159
  m16 --> m160
  m141 --> m160
  m16 --> m161
  m142 --> m161
  m16 --> m162
  m143 --> m162
  m16 --> m163
  m144 --> m163
  m16 --> m164
  m145 --> m164
  m146 --> m165
  m147 --> m165
  m148 --> m165
  m149 --> m165
  m150 --> m165
  m164 --> m165
  m151 --> m165
  m152 --> m165
  m153 --> m165
  m154 --> m165
  m155 --> m165
  m156 --> m165
  m157 --> m165
  m158 --> m165
  m159 --> m165
  m160 --> m165
  m161 --> m165
  m162 --> m165
  m163 --> m165
  m22 --> m166
  m21 --> m166
  m125 --> m166
  m26 --> m166
  m128 --> m166
  m129 --> m166
  m130 --> m166
  m131 --> m166
  m31 --> m166
  m124 --> m166
  m46 --> m166
  m47 --> m166
  m49 --> m166
  m53 --> m166
  m61 --> m166
  m63 --> m166
  m65 --> m166
  m97 --> m166
  m100 --> m166
  m101 --> m166
  m102 --> m166
  m103 --> m166
  m104 --> m166
  m107 --> m166
  m108 --> m166
  m109 --> m166
  m110 --> m166
  m111 --> m166
  m112 --> m166
  m113 --> m166
  m114 --> m166
  m115 --> m166
  m116 --> m166
  m117 --> m166
  m119 --> m166
  m120 --> m166
  m121 --> m166
  m122 --> m166
  m123 --> m166
  m140 --> m166
  m66 --> m166
  m91 --> m166
  m92 --> m166
  m145 --> m166
  m132 --> m166
  m133 --> m166
  m135 --> m166
  m18 --> m167
  m20 --> m167
  m165 --> m167
  m166 --> m167
```

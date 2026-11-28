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
    m123["ITA.S104.TwentyOneYear"]
    m124["ITA.S3.CorporateYear"]
    m125["ITA.S50.BadDebtPersonalUse"]
    m126["ITA.S54.Timeline"]
  end
  subgraph Lemmas["Layer 2: reusable lemmas"]
    m127["Lemmas.SuperficialLoss"]
    m128["Lemmas.SuspendedLoss"]
  end
  subgraph Transactions["Layer 3: transactions"]
    m129["Transactions.SpouseRepurchase"]
    m130["Transactions.SiblingAndLateRepurchase"]
    m131["Transactions.TfsaContribution"]
    m132["Transactions.HoldcoRepurchase"]
    m133["Transactions.Crystallization"]
    m134["Transactions.SaleThroughHoldco"]
    m135["Transactions.PostMortemPipeline"]
    m136["Transactions.EstateFreeze"]
    m137["Transactions.DonatingShares"]
    m138["Transactions.InvestmentIncomeIntegration"]
    m139["Transactions.EligibleDesignation"]
    m140["Transactions.CrystallizationMinimumTax"]
    m141["Transactions.DebtSwap"]
    m142["Transactions.AttendantCare"]
    m143["Transactions.PensionSplit"]
    m144["Transactions.SalaryOrDividend"]
    m145["Transactions.SupportArrears"]
    m146["Transactions.SisterCompanyRepurchase"]
  end
  subgraph Blueprints["Blueprints"]
    m147["Blueprints.SuperficialLoss"]
    m148["Blueprints.SpouseRepurchase"]
    m149["Blueprints.SiblingAndLateRepurchase"]
    m150["Blueprints.TfsaContribution"]
    m151["Blueprints.HoldcoRepurchase"]
    m152["Blueprints.Crystallization"]
    m153["Blueprints.SaleThroughHoldco"]
    m154["Blueprints.PostMortemPipeline"]
    m155["Blueprints.EstateFreeze"]
    m156["Blueprints.DonatingShares"]
    m157["Blueprints.InvestmentIncomeIntegration"]
    m158["Blueprints.EligibleDesignation"]
    m159["Blueprints.CrystallizationMinimumTax"]
    m160["Blueprints.DebtSwap"]
    m161["Blueprints.AttendantCare"]
    m162["Blueprints.PensionSplit"]
    m163["Blueprints.SalaryOrDividend"]
    m164["Blueprints.SupportArrears"]
    m165["Blueprints.SisterCompanyRepurchase"]
    m166["Blueprints.All"]
  end
  subgraph Examples["Examples"]
    m19["Examples.RuleX"]
    m20["Examples.RuleZ"]
    m21["Examples.ToySeries"]
    m22["Examples.RuleXStatute"]
  end
  subgraph Graphs["Graphs"]
    m167["Graphs.All"]
  end
  subgraph Root["Root"]
    m168["Canteen"]
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
  m41 --> m123
  m43 --> m124
  m44 --> m124
  m56 --> m124
  m105 --> m124
  m96 --> m124
  m106 --> m124
  m98 --> m124
  m59 --> m124
  m12 --> m125
  m10 --> m125
  m2 --> m125
  m23 --> m126
  m23 --> m127
  m37 --> m128
  m24 --> m129
  m127 --> m129
  m27 --> m129
  m28 --> m129
  m24 --> m130
  m28 --> m130
  m127 --> m130
  m36 --> m131
  m28 --> m131
  m36 --> m132
  m27 --> m132
  m29 --> m132
  m51 --> m133
  m52 --> m133
  m55 --> m133
  m27 --> m133
  m56 --> m134
  m59 --> m134
  m47 --> m135
  m51 --> m135
  m55 --> m135
  m60 --> m136
  m94 --> m136
  m99 --> m137
  m90 --> m138
  m96 --> m138
  m90 --> m139
  m98 --> m139
  m99 --> m140
  m99 --> m141
  m27 --> m141
  m99 --> m142
  m99 --> m143
  m99 --> m144
  m95 --> m144
  m99 --> m145
  m37 --> m146
  m29 --> m146
  m16 --> m147
  m127 --> m147
  m26 --> m147
  m27 --> m147
  m28 --> m147
  m31 --> m147
  m46 --> m147
  m47 --> m147
  m49 --> m147
  m51 --> m147
  m53 --> m147
  m58 --> m147
  m60 --> m147
  m61 --> m147
  m62 --> m147
  m63 --> m147
  m64 --> m147
  m65 --> m147
  m66 --> m147
  m67 --> m147
  m91 --> m147
  m92 --> m147
  m93 --> m147
  m94 --> m147
  m97 --> m147
  m99 --> m147
  m100 --> m147
  m101 --> m147
  m102 --> m147
  m103 --> m147
  m104 --> m147
  m107 --> m147
  m108 --> m147
  m109 --> m147
  m110 --> m147
  m111 --> m147
  m112 --> m147
  m113 --> m147
  m114 --> m147
  m115 --> m147
  m116 --> m147
  m117 --> m147
  m119 --> m147
  m120 --> m147
  m121 --> m147
  m122 --> m147
  m123 --> m147
  m124 --> m147
  m125 --> m147
  m128 --> m147
  m16 --> m148
  m129 --> m148
  m25 --> m148
  m126 --> m148
  m42 --> m148
  m16 --> m149
  m17 --> m149
  m130 --> m149
  m126 --> m149
  m16 --> m150
  m17 --> m150
  m131 --> m150
  m126 --> m150
  m16 --> m151
  m132 --> m151
  m126 --> m151
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
  m16 --> m165
  m146 --> m165
  m147 --> m166
  m148 --> m166
  m149 --> m166
  m150 --> m166
  m151 --> m166
  m165 --> m166
  m152 --> m166
  m153 --> m166
  m154 --> m166
  m155 --> m166
  m156 --> m166
  m157 --> m166
  m158 --> m166
  m159 --> m166
  m160 --> m166
  m161 --> m166
  m162 --> m166
  m163 --> m166
  m164 --> m166
  m22 --> m167
  m21 --> m167
  m126 --> m167
  m26 --> m167
  m129 --> m167
  m130 --> m167
  m131 --> m167
  m132 --> m167
  m31 --> m167
  m125 --> m167
  m46 --> m167
  m47 --> m167
  m49 --> m167
  m53 --> m167
  m61 --> m167
  m63 --> m167
  m65 --> m167
  m97 --> m167
  m100 --> m167
  m101 --> m167
  m102 --> m167
  m103 --> m167
  m104 --> m167
  m107 --> m167
  m108 --> m167
  m109 --> m167
  m110 --> m167
  m111 --> m167
  m112 --> m167
  m113 --> m167
  m114 --> m167
  m115 --> m167
  m116 --> m167
  m117 --> m167
  m119 --> m167
  m120 --> m167
  m121 --> m167
  m122 --> m167
  m123 --> m167
  m124 --> m167
  m141 --> m167
  m66 --> m167
  m91 --> m167
  m92 --> m167
  m146 --> m167
  m133 --> m167
  m134 --> m167
  m136 --> m167
  m18 --> m168
  m20 --> m168
  m166 --> m168
  m167 --> m168
```

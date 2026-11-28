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
    m124["ITA.S104.TrustIncome"]
    m125["ITA.S3.CorporateYear"]
    m126["ITA.S50.BadDebtPersonalUse"]
    m127["ITA.S54.Timeline"]
  end
  subgraph Lemmas["Layer 2: reusable lemmas"]
    m128["Lemmas.SuperficialLoss"]
    m129["Lemmas.SuspendedLoss"]
  end
  subgraph Transactions["Layer 3: transactions"]
    m130["Transactions.SpouseRepurchase"]
    m131["Transactions.SiblingAndLateRepurchase"]
    m132["Transactions.TfsaContribution"]
    m133["Transactions.HoldcoRepurchase"]
    m134["Transactions.Crystallization"]
    m135["Transactions.SaleThroughHoldco"]
    m136["Transactions.PostMortemPipeline"]
    m137["Transactions.EstateFreeze"]
    m138["Transactions.DonatingShares"]
    m139["Transactions.InvestmentIncomeIntegration"]
    m140["Transactions.EligibleDesignation"]
    m141["Transactions.CrystallizationMinimumTax"]
    m142["Transactions.DebtSwap"]
    m143["Transactions.AttendantCare"]
    m144["Transactions.PensionSplit"]
    m145["Transactions.SalaryOrDividend"]
    m146["Transactions.SupportArrears"]
    m147["Transactions.SisterCompanyRepurchase"]
  end
  subgraph Blueprints["Blueprints"]
    m148["Blueprints.SuperficialLoss"]
    m149["Blueprints.SpouseRepurchase"]
    m150["Blueprints.SiblingAndLateRepurchase"]
    m151["Blueprints.TfsaContribution"]
    m152["Blueprints.HoldcoRepurchase"]
    m153["Blueprints.Crystallization"]
    m154["Blueprints.SaleThroughHoldco"]
    m155["Blueprints.PostMortemPipeline"]
    m156["Blueprints.EstateFreeze"]
    m157["Blueprints.DonatingShares"]
    m158["Blueprints.InvestmentIncomeIntegration"]
    m159["Blueprints.EligibleDesignation"]
    m160["Blueprints.CrystallizationMinimumTax"]
    m161["Blueprints.DebtSwap"]
    m162["Blueprints.AttendantCare"]
    m163["Blueprints.PensionSplit"]
    m164["Blueprints.SalaryOrDividend"]
    m165["Blueprints.SupportArrears"]
    m166["Blueprints.SisterCompanyRepurchase"]
    m167["Blueprints.All"]
  end
  subgraph Examples["Examples"]
    m19["Examples.RuleX"]
    m20["Examples.RuleZ"]
    m21["Examples.ToySeries"]
    m22["Examples.RuleXStatute"]
  end
  subgraph Graphs["Graphs"]
    m168["Graphs.All"]
  end
  subgraph Root["Root"]
    m169["Canteen"]
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
  m80 --> m124
  m55 --> m124
  m70 --> m124
  m43 --> m125
  m44 --> m125
  m56 --> m125
  m105 --> m125
  m96 --> m125
  m106 --> m125
  m98 --> m125
  m59 --> m125
  m12 --> m126
  m10 --> m126
  m2 --> m126
  m23 --> m127
  m23 --> m128
  m37 --> m129
  m24 --> m130
  m128 --> m130
  m27 --> m130
  m28 --> m130
  m24 --> m131
  m28 --> m131
  m128 --> m131
  m36 --> m132
  m28 --> m132
  m36 --> m133
  m27 --> m133
  m29 --> m133
  m51 --> m134
  m52 --> m134
  m55 --> m134
  m27 --> m134
  m56 --> m135
  m59 --> m135
  m47 --> m136
  m51 --> m136
  m55 --> m136
  m60 --> m137
  m94 --> m137
  m99 --> m138
  m90 --> m139
  m96 --> m139
  m90 --> m140
  m98 --> m140
  m99 --> m141
  m99 --> m142
  m27 --> m142
  m99 --> m143
  m99 --> m144
  m99 --> m145
  m95 --> m145
  m99 --> m146
  m37 --> m147
  m29 --> m147
  m16 --> m148
  m128 --> m148
  m26 --> m148
  m27 --> m148
  m28 --> m148
  m31 --> m148
  m46 --> m148
  m47 --> m148
  m49 --> m148
  m51 --> m148
  m53 --> m148
  m58 --> m148
  m60 --> m148
  m61 --> m148
  m62 --> m148
  m63 --> m148
  m64 --> m148
  m65 --> m148
  m66 --> m148
  m67 --> m148
  m91 --> m148
  m92 --> m148
  m93 --> m148
  m94 --> m148
  m97 --> m148
  m99 --> m148
  m100 --> m148
  m101 --> m148
  m102 --> m148
  m103 --> m148
  m104 --> m148
  m107 --> m148
  m108 --> m148
  m109 --> m148
  m110 --> m148
  m111 --> m148
  m112 --> m148
  m113 --> m148
  m114 --> m148
  m115 --> m148
  m116 --> m148
  m117 --> m148
  m119 --> m148
  m120 --> m148
  m121 --> m148
  m122 --> m148
  m123 --> m148
  m124 --> m148
  m125 --> m148
  m126 --> m148
  m129 --> m148
  m16 --> m149
  m130 --> m149
  m25 --> m149
  m127 --> m149
  m42 --> m149
  m16 --> m150
  m17 --> m150
  m131 --> m150
  m127 --> m150
  m16 --> m151
  m17 --> m151
  m132 --> m151
  m127 --> m151
  m16 --> m152
  m133 --> m152
  m127 --> m152
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
  m16 --> m166
  m147 --> m166
  m148 --> m167
  m149 --> m167
  m150 --> m167
  m151 --> m167
  m152 --> m167
  m166 --> m167
  m153 --> m167
  m154 --> m167
  m155 --> m167
  m156 --> m167
  m157 --> m167
  m158 --> m167
  m159 --> m167
  m160 --> m167
  m161 --> m167
  m162 --> m167
  m163 --> m167
  m164 --> m167
  m165 --> m167
  m22 --> m168
  m21 --> m168
  m127 --> m168
  m26 --> m168
  m130 --> m168
  m131 --> m168
  m132 --> m168
  m133 --> m168
  m31 --> m168
  m126 --> m168
  m46 --> m168
  m47 --> m168
  m49 --> m168
  m53 --> m168
  m61 --> m168
  m63 --> m168
  m65 --> m168
  m97 --> m168
  m100 --> m168
  m101 --> m168
  m102 --> m168
  m103 --> m168
  m104 --> m168
  m107 --> m168
  m108 --> m168
  m109 --> m168
  m110 --> m168
  m111 --> m168
  m112 --> m168
  m113 --> m168
  m114 --> m168
  m115 --> m168
  m116 --> m168
  m117 --> m168
  m119 --> m168
  m120 --> m168
  m121 --> m168
  m122 --> m168
  m123 --> m168
  m124 --> m168
  m125 --> m168
  m142 --> m168
  m66 --> m168
  m91 --> m168
  m92 --> m168
  m147 --> m168
  m134 --> m168
  m135 --> m168
  m137 --> m168
  m18 --> m169
  m20 --> m169
  m167 --> m169
  m168 --> m169
```

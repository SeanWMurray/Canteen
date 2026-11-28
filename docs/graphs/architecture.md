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
    m90["ITA.S146.RRSP"]
    m91["ITA.S3.IndividualYear"]
    m92["ITA.S39.CanadianSecurities"]
    m93["ITA.S50.BadDebtOrShare"]
    m94["ITA.S43.PartialDisposition"]
    m95["ITA.S74.CorporateAttribution"]
    m96["ITA.S123.CorporateRates"]
    m97["ITA.S129.RefundableTax"]
    m98["ITA.S15.ShareholderLoans"]
    m99["ITA.S89.GeneralRateIncomePool"]
    m100["ITA.S127_5.MinimumTax"]
    m101["ITA.S84.PaidUpCapitalIncrease"]
    m102["ITA.S112.StopLoss"]
    m103["ITA.S84.WindingUpDividend"]
    m104["ITA.S44_1.SmallBusinessRollover"]
    m105["ITA.S46.PersonalUse"]
    m106["ITA.S110_1.CorporateDonations"]
    m107["ITA.S125.BusinessLimit"]
    m108["ITA.S256.Associated"]
    m109["ITA.S67_1.MealsEntertainment"]
    m110["ITA.S20.FinancingExpenses"]
    m111["ITA.S18.WorkSpace"]
    m112["ITA.S20.DoubtfulDebts"]
    m113["ITA.S20.AdvancePayments"]
    m114["ITA.S20.InstalmentSales"]
    m115["ITA.S18.PrepaidExpenses"]
    m116["ITA.S18.ThinCapitalization"]
    m117["ITA.S212.Withholding"]
    m118["ITA.S216.RentalElection"]
    m119["ITA.S248.TaxableCanadianProperty"]
    m120["ITA.S116.Purchaser"]
    m121["ITA.S128_1.Emigration"]
    m122["ITA.S75.ReversionaryTrust"]
    m123["ITA.S107.TrustDistribution"]
    m124["ITA.S104.TwentyOneYear"]
    m125["ITA.S104.TrustIncome"]
    m126["ITA.S146_01.HomeBuyersPlan"]
    m127["ITA.S146_6.FirstHomeSavings"]
    m128["ITA.S146_3.RRIFMinimum"]
    m129["ITA.S13.CapitalCostAllowance"]
    m130["ITA.S3.CorporateYear"]
    m131["ITA.S50.BadDebtPersonalUse"]
    m132["ITA.S54.Timeline"]
  end
  subgraph Lemmas["Layer 2: reusable lemmas"]
    m133["Lemmas.SuperficialLoss"]
    m134["Lemmas.SuspendedLoss"]
  end
  subgraph Transactions["Layer 3: transactions"]
    m135["Transactions.SpouseRepurchase"]
    m136["Transactions.SiblingAndLateRepurchase"]
    m137["Transactions.TfsaContribution"]
    m138["Transactions.HoldcoRepurchase"]
    m139["Transactions.Crystallization"]
    m140["Transactions.SaleThroughHoldco"]
    m141["Transactions.PostMortemPipeline"]
    m142["Transactions.EstateFreeze"]
    m143["Transactions.DonatingShares"]
    m144["Transactions.InvestmentIncomeIntegration"]
    m145["Transactions.EligibleDesignation"]
    m146["Transactions.CrystallizationMinimumTax"]
    m147["Transactions.DebtSwap"]
    m148["Transactions.AttendantCare"]
    m149["Transactions.PensionSplit"]
    m150["Transactions.SalaryOrDividend"]
    m151["Transactions.SupportArrears"]
    m152["Transactions.SisterCompanyRepurchase"]
  end
  subgraph Blueprints["Blueprints"]
    m153["Blueprints.SuperficialLoss"]
    m154["Blueprints.SpouseRepurchase"]
    m155["Blueprints.SiblingAndLateRepurchase"]
    m156["Blueprints.TfsaContribution"]
    m157["Blueprints.HoldcoRepurchase"]
    m158["Blueprints.Crystallization"]
    m159["Blueprints.SaleThroughHoldco"]
    m160["Blueprints.PostMortemPipeline"]
    m161["Blueprints.EstateFreeze"]
    m162["Blueprints.DonatingShares"]
    m163["Blueprints.InvestmentIncomeIntegration"]
    m164["Blueprints.EligibleDesignation"]
    m165["Blueprints.CrystallizationMinimumTax"]
    m166["Blueprints.DebtSwap"]
    m167["Blueprints.AttendantCare"]
    m168["Blueprints.PensionSplit"]
    m169["Blueprints.SalaryOrDividend"]
    m170["Blueprints.SupportArrears"]
    m171["Blueprints.SisterCompanyRepurchase"]
    m172["Blueprints.All"]
  end
  subgraph Examples["Examples"]
    m19["Examples.RuleX"]
    m20["Examples.RuleZ"]
    m21["Examples.ToySeries"]
    m22["Examples.RuleXStatute"]
  end
  subgraph Graphs["Graphs"]
    m173["Graphs.All"]
  end
  subgraph Root["Root"]
    m174["Canteen"]
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
  m2 --> m90
  m4 --> m90
  m43 --> m91
  m52 --> m91
  m57 --> m91
  m54 --> m91
  m69 --> m91
  m70 --> m91
  m71 --> m91
  m72 --> m91
  m73 --> m91
  m74 --> m91
  m75 --> m91
  m76 --> m91
  m77 --> m91
  m80 --> m91
  m81 --> m91
  m82 --> m91
  m83 --> m91
  m84 --> m91
  m85 --> m91
  m86 --> m91
  m87 --> m91
  m88 --> m91
  m89 --> m91
  m90 --> m91
  m41 --> m92
  m41 --> m93
  m41 --> m94
  m55 --> m95
  m10 --> m95
  m4 --> m96
  m2 --> m96
  m96 --> m97
  m12 --> m98
  m10 --> m98
  m1 --> m98
  m2 --> m98
  m96 --> m99
  m10 --> m99
  m91 --> m100
  m55 --> m101
  m41 --> m102
  m41 --> m103
  m55 --> m103
  m12 --> m104
  m10 --> m104
  m2 --> m104
  m1 --> m104
  m41 --> m105
  m2 --> m106
  m4 --> m106
  m2 --> m107
  m4 --> m107
  m30 --> m108
  m2 --> m109
  m10 --> m109
  m2 --> m110
  m4 --> m110
  m2 --> m111
  m10 --> m111
  m2 --> m112
  m10 --> m112
  m2 --> m113
  m4 --> m113
  m2 --> m114
  m4 --> m114
  m1 --> m114
  m2 --> m115
  m4 --> m115
  m1 --> m115
  m2 --> m116
  m4 --> m116
  m2 --> m117
  m4 --> m117
  m80 --> m118
  m4 --> m119
  m2 --> m120
  m10 --> m120
  m119 --> m120
  m41 --> m121
  m119 --> m121
  m41 --> m122
  m2 --> m123
  m4 --> m123
  m41 --> m124
  m80 --> m125
  m55 --> m125
  m70 --> m125
  m2 --> m126
  m4 --> m126
  m2 --> m127
  m4 --> m127
  m2 --> m128
  m4 --> m128
  m2 --> m129
  m4 --> m129
  m43 --> m130
  m44 --> m130
  m56 --> m130
  m106 --> m130
  m97 --> m130
  m107 --> m130
  m99 --> m130
  m59 --> m130
  m12 --> m131
  m10 --> m131
  m2 --> m131
  m23 --> m132
  m23 --> m133
  m37 --> m134
  m24 --> m135
  m133 --> m135
  m27 --> m135
  m28 --> m135
  m24 --> m136
  m28 --> m136
  m133 --> m136
  m36 --> m137
  m28 --> m137
  m36 --> m138
  m27 --> m138
  m29 --> m138
  m51 --> m139
  m52 --> m139
  m55 --> m139
  m27 --> m139
  m56 --> m140
  m59 --> m140
  m47 --> m141
  m51 --> m141
  m55 --> m141
  m60 --> m142
  m95 --> m142
  m100 --> m143
  m91 --> m144
  m97 --> m144
  m91 --> m145
  m99 --> m145
  m100 --> m146
  m100 --> m147
  m27 --> m147
  m100 --> m148
  m100 --> m149
  m100 --> m150
  m96 --> m150
  m100 --> m151
  m37 --> m152
  m29 --> m152
  m16 --> m153
  m133 --> m153
  m26 --> m153
  m27 --> m153
  m28 --> m153
  m31 --> m153
  m46 --> m153
  m47 --> m153
  m49 --> m153
  m51 --> m153
  m53 --> m153
  m58 --> m153
  m60 --> m153
  m61 --> m153
  m62 --> m153
  m63 --> m153
  m64 --> m153
  m65 --> m153
  m66 --> m153
  m67 --> m153
  m92 --> m153
  m93 --> m153
  m94 --> m153
  m95 --> m153
  m98 --> m153
  m100 --> m153
  m101 --> m153
  m102 --> m153
  m103 --> m153
  m104 --> m153
  m105 --> m153
  m108 --> m153
  m109 --> m153
  m110 --> m153
  m111 --> m153
  m112 --> m153
  m113 --> m153
  m114 --> m153
  m115 --> m153
  m116 --> m153
  m117 --> m153
  m118 --> m153
  m120 --> m153
  m121 --> m153
  m122 --> m153
  m123 --> m153
  m124 --> m153
  m125 --> m153
  m126 --> m153
  m127 --> m153
  m128 --> m153
  m129 --> m153
  m130 --> m153
  m131 --> m153
  m134 --> m153
  m16 --> m154
  m135 --> m154
  m25 --> m154
  m132 --> m154
  m42 --> m154
  m16 --> m155
  m17 --> m155
  m136 --> m155
  m132 --> m155
  m16 --> m156
  m17 --> m156
  m137 --> m156
  m132 --> m156
  m16 --> m157
  m138 --> m157
  m132 --> m157
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
  m16 --> m167
  m148 --> m167
  m16 --> m168
  m149 --> m168
  m16 --> m169
  m150 --> m169
  m16 --> m170
  m151 --> m170
  m16 --> m171
  m152 --> m171
  m153 --> m172
  m154 --> m172
  m155 --> m172
  m156 --> m172
  m157 --> m172
  m171 --> m172
  m158 --> m172
  m159 --> m172
  m160 --> m172
  m161 --> m172
  m162 --> m172
  m163 --> m172
  m164 --> m172
  m165 --> m172
  m166 --> m172
  m167 --> m172
  m168 --> m172
  m169 --> m172
  m170 --> m172
  m22 --> m173
  m21 --> m173
  m132 --> m173
  m26 --> m173
  m135 --> m173
  m136 --> m173
  m137 --> m173
  m138 --> m173
  m31 --> m173
  m131 --> m173
  m46 --> m173
  m47 --> m173
  m49 --> m173
  m53 --> m173
  m61 --> m173
  m63 --> m173
  m65 --> m173
  m98 --> m173
  m101 --> m173
  m102 --> m173
  m103 --> m173
  m104 --> m173
  m105 --> m173
  m108 --> m173
  m109 --> m173
  m110 --> m173
  m111 --> m173
  m112 --> m173
  m113 --> m173
  m114 --> m173
  m115 --> m173
  m116 --> m173
  m117 --> m173
  m118 --> m173
  m120 --> m173
  m121 --> m173
  m122 --> m173
  m123 --> m173
  m124 --> m173
  m125 --> m173
  m126 --> m173
  m127 --> m173
  m128 --> m173
  m129 --> m173
  m130 --> m173
  m147 --> m173
  m66 --> m173
  m92 --> m173
  m93 --> m173
  m152 --> m173
  m139 --> m173
  m140 --> m173
  m142 --> m173
  m18 --> m174
  m20 --> m174
  m172 --> m174
  m173 --> m174
```

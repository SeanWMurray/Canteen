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
    m130["ITA.S13.PassengerVehicles"]
    m131["ITA.Reg4301.PrescribedRate"]
    m132["ITA.S122_7.WorkersBenefit"]
    m133["ITA.S122_5.GstCredit"]
    m134["ITA.S96.Partnership"]
    m135["ITA.S96.TransferToPartnership"]
    m136["ITA.S100.PartnershipInterestSale"]
    m137["ITA.S3.CorporateYear"]
    m138["ITA.S50.BadDebtPersonalUse"]
    m139["ITA.S54.Timeline"]
  end
  subgraph Lemmas["Layer 2: reusable lemmas"]
    m140["Lemmas.SuperficialLoss"]
    m141["Lemmas.SuspendedLoss"]
  end
  subgraph Transactions["Layer 3: transactions"]
    m142["Transactions.SpouseRepurchase"]
    m143["Transactions.SiblingAndLateRepurchase"]
    m144["Transactions.TfsaContribution"]
    m145["Transactions.HoldcoRepurchase"]
    m146["Transactions.Crystallization"]
    m147["Transactions.SaleThroughHoldco"]
    m148["Transactions.PostMortemPipeline"]
    m149["Transactions.EstateFreeze"]
    m150["Transactions.DonatingShares"]
    m151["Transactions.InvestmentIncomeIntegration"]
    m152["Transactions.EligibleDesignation"]
    m153["Transactions.CrystallizationMinimumTax"]
    m154["Transactions.DebtSwap"]
    m155["Transactions.AttendantCare"]
    m156["Transactions.PensionSplit"]
    m157["Transactions.SalaryOrDividend"]
    m158["Transactions.SupportArrears"]
    m159["Transactions.SisterCompanyRepurchase"]
  end
  subgraph Blueprints["Blueprints"]
    m160["Blueprints.SuperficialLoss"]
    m161["Blueprints.SpouseRepurchase"]
    m162["Blueprints.SiblingAndLateRepurchase"]
    m163["Blueprints.TfsaContribution"]
    m164["Blueprints.HoldcoRepurchase"]
    m165["Blueprints.Crystallization"]
    m166["Blueprints.SaleThroughHoldco"]
    m167["Blueprints.PostMortemPipeline"]
    m168["Blueprints.EstateFreeze"]
    m169["Blueprints.DonatingShares"]
    m170["Blueprints.InvestmentIncomeIntegration"]
    m171["Blueprints.EligibleDesignation"]
    m172["Blueprints.CrystallizationMinimumTax"]
    m173["Blueprints.DebtSwap"]
    m174["Blueprints.AttendantCare"]
    m175["Blueprints.PensionSplit"]
    m176["Blueprints.SalaryOrDividend"]
    m177["Blueprints.SupportArrears"]
    m178["Blueprints.SisterCompanyRepurchase"]
    m179["Blueprints.All"]
  end
  subgraph Examples["Examples"]
    m19["Examples.RuleX"]
    m20["Examples.RuleZ"]
    m21["Examples.ToySeries"]
    m22["Examples.RuleXStatute"]
  end
  subgraph Graphs["Graphs"]
    m180["Graphs.All"]
  end
  subgraph Root["Root"]
    m181["Canteen"]
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
  m2 --> m130
  m4 --> m130
  m4 --> m131
  m79 --> m132
  m4 --> m132
  m79 --> m133
  m4 --> m133
  m2 --> m134
  m4 --> m134
  m50 --> m135
  m2 --> m136
  m4 --> m136
  m43 --> m137
  m44 --> m137
  m56 --> m137
  m106 --> m137
  m97 --> m137
  m107 --> m137
  m99 --> m137
  m59 --> m137
  m12 --> m138
  m10 --> m138
  m2 --> m138
  m23 --> m139
  m23 --> m140
  m37 --> m141
  m24 --> m142
  m140 --> m142
  m27 --> m142
  m28 --> m142
  m24 --> m143
  m28 --> m143
  m140 --> m143
  m36 --> m144
  m28 --> m144
  m36 --> m145
  m27 --> m145
  m29 --> m145
  m51 --> m146
  m52 --> m146
  m55 --> m146
  m27 --> m146
  m56 --> m147
  m59 --> m147
  m47 --> m148
  m51 --> m148
  m55 --> m148
  m60 --> m149
  m95 --> m149
  m100 --> m150
  m91 --> m151
  m97 --> m151
  m91 --> m152
  m99 --> m152
  m100 --> m153
  m100 --> m154
  m27 --> m154
  m100 --> m155
  m100 --> m156
  m100 --> m157
  m96 --> m157
  m100 --> m158
  m37 --> m159
  m29 --> m159
  m16 --> m160
  m140 --> m160
  m26 --> m160
  m27 --> m160
  m28 --> m160
  m31 --> m160
  m46 --> m160
  m47 --> m160
  m49 --> m160
  m51 --> m160
  m53 --> m160
  m58 --> m160
  m60 --> m160
  m61 --> m160
  m62 --> m160
  m63 --> m160
  m64 --> m160
  m65 --> m160
  m66 --> m160
  m67 --> m160
  m92 --> m160
  m93 --> m160
  m94 --> m160
  m95 --> m160
  m98 --> m160
  m100 --> m160
  m101 --> m160
  m102 --> m160
  m103 --> m160
  m104 --> m160
  m105 --> m160
  m108 --> m160
  m109 --> m160
  m110 --> m160
  m111 --> m160
  m112 --> m160
  m113 --> m160
  m114 --> m160
  m115 --> m160
  m116 --> m160
  m117 --> m160
  m118 --> m160
  m120 --> m160
  m121 --> m160
  m122 --> m160
  m123 --> m160
  m124 --> m160
  m125 --> m160
  m126 --> m160
  m127 --> m160
  m128 --> m160
  m129 --> m160
  m130 --> m160
  m131 --> m160
  m132 --> m160
  m133 --> m160
  m134 --> m160
  m135 --> m160
  m136 --> m160
  m137 --> m160
  m138 --> m160
  m141 --> m160
  m16 --> m161
  m142 --> m161
  m25 --> m161
  m139 --> m161
  m42 --> m161
  m16 --> m162
  m17 --> m162
  m143 --> m162
  m139 --> m162
  m16 --> m163
  m17 --> m163
  m144 --> m163
  m139 --> m163
  m16 --> m164
  m145 --> m164
  m139 --> m164
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
  m16 --> m172
  m153 --> m172
  m16 --> m173
  m154 --> m173
  m16 --> m174
  m155 --> m174
  m16 --> m175
  m156 --> m175
  m16 --> m176
  m157 --> m176
  m16 --> m177
  m158 --> m177
  m16 --> m178
  m159 --> m178
  m160 --> m179
  m161 --> m179
  m162 --> m179
  m163 --> m179
  m164 --> m179
  m178 --> m179
  m165 --> m179
  m166 --> m179
  m167 --> m179
  m168 --> m179
  m169 --> m179
  m170 --> m179
  m171 --> m179
  m172 --> m179
  m173 --> m179
  m174 --> m179
  m175 --> m179
  m176 --> m179
  m177 --> m179
  m22 --> m180
  m21 --> m180
  m139 --> m180
  m26 --> m180
  m142 --> m180
  m143 --> m180
  m144 --> m180
  m145 --> m180
  m31 --> m180
  m138 --> m180
  m46 --> m180
  m47 --> m180
  m49 --> m180
  m53 --> m180
  m61 --> m180
  m63 --> m180
  m65 --> m180
  m98 --> m180
  m101 --> m180
  m102 --> m180
  m103 --> m180
  m104 --> m180
  m105 --> m180
  m108 --> m180
  m109 --> m180
  m110 --> m180
  m111 --> m180
  m112 --> m180
  m113 --> m180
  m114 --> m180
  m115 --> m180
  m116 --> m180
  m117 --> m180
  m118 --> m180
  m120 --> m180
  m121 --> m180
  m122 --> m180
  m123 --> m180
  m124 --> m180
  m125 --> m180
  m126 --> m180
  m127 --> m180
  m128 --> m180
  m129 --> m180
  m130 --> m180
  m131 --> m180
  m132 --> m180
  m133 --> m180
  m134 --> m180
  m135 --> m180
  m136 --> m180
  m137 --> m180
  m154 --> m180
  m66 --> m180
  m92 --> m180
  m93 --> m180
  m159 --> m180
  m146 --> m180
  m147 --> m180
  m149 --> m180
  m18 --> m181
  m20 --> m181
  m179 --> m181
  m180 --> m181
```

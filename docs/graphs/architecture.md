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
    m121["ITA.S3.CorporateYear"]
    m122["ITA.S50.BadDebtPersonalUse"]
    m123["ITA.S54.Timeline"]
  end
  subgraph Lemmas["Layer 2: reusable lemmas"]
    m124["Lemmas.SuperficialLoss"]
    m125["Lemmas.SuspendedLoss"]
  end
  subgraph Transactions["Layer 3: transactions"]
    m126["Transactions.SpouseRepurchase"]
    m127["Transactions.SiblingAndLateRepurchase"]
    m128["Transactions.TfsaContribution"]
    m129["Transactions.HoldcoRepurchase"]
    m130["Transactions.Crystallization"]
    m131["Transactions.SaleThroughHoldco"]
    m132["Transactions.PostMortemPipeline"]
    m133["Transactions.EstateFreeze"]
    m134["Transactions.DonatingShares"]
    m135["Transactions.InvestmentIncomeIntegration"]
    m136["Transactions.EligibleDesignation"]
    m137["Transactions.CrystallizationMinimumTax"]
    m138["Transactions.DebtSwap"]
    m139["Transactions.AttendantCare"]
    m140["Transactions.PensionSplit"]
    m141["Transactions.SalaryOrDividend"]
    m142["Transactions.SupportArrears"]
    m143["Transactions.SisterCompanyRepurchase"]
  end
  subgraph Blueprints["Blueprints"]
    m144["Blueprints.SuperficialLoss"]
    m145["Blueprints.SpouseRepurchase"]
    m146["Blueprints.SiblingAndLateRepurchase"]
    m147["Blueprints.TfsaContribution"]
    m148["Blueprints.HoldcoRepurchase"]
    m149["Blueprints.Crystallization"]
    m150["Blueprints.SaleThroughHoldco"]
    m151["Blueprints.PostMortemPipeline"]
    m152["Blueprints.EstateFreeze"]
    m153["Blueprints.DonatingShares"]
    m154["Blueprints.InvestmentIncomeIntegration"]
    m155["Blueprints.EligibleDesignation"]
    m156["Blueprints.CrystallizationMinimumTax"]
    m157["Blueprints.DebtSwap"]
    m158["Blueprints.AttendantCare"]
    m159["Blueprints.PensionSplit"]
    m160["Blueprints.SalaryOrDividend"]
    m161["Blueprints.SupportArrears"]
    m162["Blueprints.SisterCompanyRepurchase"]
    m163["Blueprints.All"]
  end
  subgraph Examples["Examples"]
    m19["Examples.RuleX"]
    m20["Examples.RuleZ"]
    m21["Examples.ToySeries"]
    m22["Examples.RuleXStatute"]
  end
  subgraph Graphs["Graphs"]
    m164["Graphs.All"]
  end
  subgraph Root["Root"]
    m165["Canteen"]
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
  m43 --> m121
  m44 --> m121
  m56 --> m121
  m105 --> m121
  m96 --> m121
  m106 --> m121
  m98 --> m121
  m59 --> m121
  m12 --> m122
  m10 --> m122
  m2 --> m122
  m23 --> m123
  m23 --> m124
  m37 --> m125
  m24 --> m126
  m124 --> m126
  m27 --> m126
  m28 --> m126
  m24 --> m127
  m28 --> m127
  m124 --> m127
  m36 --> m128
  m28 --> m128
  m36 --> m129
  m27 --> m129
  m29 --> m129
  m51 --> m130
  m52 --> m130
  m55 --> m130
  m27 --> m130
  m56 --> m131
  m59 --> m131
  m47 --> m132
  m51 --> m132
  m55 --> m132
  m60 --> m133
  m94 --> m133
  m99 --> m134
  m90 --> m135
  m96 --> m135
  m90 --> m136
  m98 --> m136
  m99 --> m137
  m99 --> m138
  m27 --> m138
  m99 --> m139
  m99 --> m140
  m99 --> m141
  m95 --> m141
  m99 --> m142
  m37 --> m143
  m29 --> m143
  m16 --> m144
  m124 --> m144
  m26 --> m144
  m27 --> m144
  m28 --> m144
  m31 --> m144
  m46 --> m144
  m47 --> m144
  m49 --> m144
  m51 --> m144
  m53 --> m144
  m58 --> m144
  m60 --> m144
  m61 --> m144
  m62 --> m144
  m63 --> m144
  m64 --> m144
  m65 --> m144
  m66 --> m144
  m67 --> m144
  m91 --> m144
  m92 --> m144
  m93 --> m144
  m94 --> m144
  m97 --> m144
  m99 --> m144
  m100 --> m144
  m101 --> m144
  m102 --> m144
  m103 --> m144
  m104 --> m144
  m107 --> m144
  m108 --> m144
  m109 --> m144
  m110 --> m144
  m111 --> m144
  m112 --> m144
  m113 --> m144
  m114 --> m144
  m115 --> m144
  m116 --> m144
  m117 --> m144
  m119 --> m144
  m120 --> m144
  m121 --> m144
  m122 --> m144
  m125 --> m144
  m16 --> m145
  m126 --> m145
  m25 --> m145
  m123 --> m145
  m42 --> m145
  m16 --> m146
  m17 --> m146
  m127 --> m146
  m123 --> m146
  m16 --> m147
  m17 --> m147
  m128 --> m147
  m123 --> m147
  m16 --> m148
  m129 --> m148
  m123 --> m148
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
  m144 --> m163
  m145 --> m163
  m146 --> m163
  m147 --> m163
  m148 --> m163
  m162 --> m163
  m149 --> m163
  m150 --> m163
  m151 --> m163
  m152 --> m163
  m153 --> m163
  m154 --> m163
  m155 --> m163
  m156 --> m163
  m157 --> m163
  m158 --> m163
  m159 --> m163
  m160 --> m163
  m161 --> m163
  m22 --> m164
  m21 --> m164
  m123 --> m164
  m26 --> m164
  m126 --> m164
  m127 --> m164
  m128 --> m164
  m129 --> m164
  m31 --> m164
  m122 --> m164
  m46 --> m164
  m47 --> m164
  m49 --> m164
  m53 --> m164
  m61 --> m164
  m63 --> m164
  m65 --> m164
  m97 --> m164
  m100 --> m164
  m101 --> m164
  m102 --> m164
  m103 --> m164
  m104 --> m164
  m107 --> m164
  m108 --> m164
  m109 --> m164
  m110 --> m164
  m111 --> m164
  m112 --> m164
  m113 --> m164
  m114 --> m164
  m115 --> m164
  m116 --> m164
  m117 --> m164
  m119 --> m164
  m120 --> m164
  m121 --> m164
  m138 --> m164
  m66 --> m164
  m91 --> m164
  m92 --> m164
  m143 --> m164
  m130 --> m164
  m131 --> m164
  m133 --> m164
  m18 --> m165
  m20 --> m165
  m163 --> m165
  m164 --> m165
```

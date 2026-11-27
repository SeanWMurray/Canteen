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
    m87["ITA.S3.IndividualYear"]
    m88["ITA.S39.CanadianSecurities"]
    m89["ITA.S50.BadDebtOrShare"]
    m90["ITA.S43.PartialDisposition"]
    m91["ITA.S74.CorporateAttribution"]
    m92["ITA.S123.CorporateRates"]
    m93["ITA.S129.RefundableTax"]
    m94["ITA.S15.ShareholderLoans"]
    m95["ITA.S89.GeneralRateIncomePool"]
    m96["ITA.S127_5.MinimumTax"]
    m97["ITA.S84.PaidUpCapitalIncrease"]
    m98["ITA.S112.StopLoss"]
    m99["ITA.S84.WindingUpDividend"]
    m100["ITA.S44_1.SmallBusinessRollover"]
    m101["ITA.S50.BadDebtPersonalUse"]
    m102["ITA.S54.Timeline"]
  end
  subgraph Lemmas["Layer 2: reusable lemmas"]
    m103["Lemmas.SuperficialLoss"]
    m104["Lemmas.SuspendedLoss"]
  end
  subgraph Transactions["Layer 3: transactions"]
    m105["Transactions.SpouseRepurchase"]
    m106["Transactions.SiblingAndLateRepurchase"]
    m107["Transactions.TfsaContribution"]
    m108["Transactions.HoldcoRepurchase"]
    m109["Transactions.Crystallization"]
    m110["Transactions.SaleThroughHoldco"]
    m111["Transactions.PostMortemPipeline"]
    m112["Transactions.EstateFreeze"]
    m113["Transactions.DonatingShares"]
    m114["Transactions.InvestmentIncomeIntegration"]
    m115["Transactions.EligibleDesignation"]
    m116["Transactions.CrystallizationMinimumTax"]
    m117["Transactions.DebtSwap"]
    m118["Transactions.AttendantCare"]
    m119["Transactions.PensionSplit"]
    m120["Transactions.SalaryOrDividend"]
    m121["Transactions.SupportArrears"]
    m122["Transactions.SisterCompanyRepurchase"]
  end
  subgraph Blueprints["Blueprints"]
    m123["Blueprints.SuperficialLoss"]
    m124["Blueprints.SpouseRepurchase"]
    m125["Blueprints.SiblingAndLateRepurchase"]
    m126["Blueprints.TfsaContribution"]
    m127["Blueprints.HoldcoRepurchase"]
    m128["Blueprints.Crystallization"]
    m129["Blueprints.SaleThroughHoldco"]
    m130["Blueprints.PostMortemPipeline"]
    m131["Blueprints.EstateFreeze"]
    m132["Blueprints.DonatingShares"]
    m133["Blueprints.InvestmentIncomeIntegration"]
    m134["Blueprints.EligibleDesignation"]
    m135["Blueprints.CrystallizationMinimumTax"]
    m136["Blueprints.DebtSwap"]
    m137["Blueprints.AttendantCare"]
    m138["Blueprints.PensionSplit"]
    m139["Blueprints.SalaryOrDividend"]
    m140["Blueprints.SupportArrears"]
    m141["Blueprints.SisterCompanyRepurchase"]
    m142["Blueprints.All"]
  end
  subgraph Examples["Examples"]
    m19["Examples.RuleX"]
    m20["Examples.RuleZ"]
    m21["Examples.ToySeries"]
    m22["Examples.RuleXStatute"]
  end
  subgraph Graphs["Graphs"]
    m143["Graphs.All"]
  end
  subgraph Root["Root"]
    m144["Canteen"]
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
  m43 --> m87
  m51 --> m87
  m56 --> m87
  m53 --> m87
  m68 --> m87
  m69 --> m87
  m70 --> m87
  m71 --> m87
  m72 --> m87
  m73 --> m87
  m74 --> m87
  m75 --> m87
  m76 --> m87
  m79 --> m87
  m80 --> m87
  m81 --> m87
  m82 --> m87
  m83 --> m87
  m84 --> m87
  m85 --> m87
  m86 --> m87
  m41 --> m88
  m41 --> m89
  m41 --> m90
  m54 --> m91
  m10 --> m91
  m4 --> m92
  m2 --> m92
  m92 --> m93
  m12 --> m94
  m10 --> m94
  m1 --> m94
  m2 --> m94
  m92 --> m95
  m10 --> m95
  m87 --> m96
  m54 --> m97
  m41 --> m98
  m41 --> m99
  m54 --> m99
  m12 --> m100
  m10 --> m100
  m2 --> m100
  m1 --> m100
  m12 --> m101
  m10 --> m101
  m2 --> m101
  m23 --> m102
  m23 --> m103
  m37 --> m104
  m24 --> m105
  m103 --> m105
  m27 --> m105
  m28 --> m105
  m24 --> m106
  m28 --> m106
  m103 --> m106
  m36 --> m107
  m28 --> m107
  m36 --> m108
  m27 --> m108
  m29 --> m108
  m50 --> m109
  m51 --> m109
  m54 --> m109
  m27 --> m109
  m55 --> m110
  m58 --> m110
  m46 --> m111
  m50 --> m111
  m54 --> m111
  m59 --> m112
  m91 --> m112
  m96 --> m113
  m87 --> m114
  m93 --> m114
  m87 --> m115
  m95 --> m115
  m96 --> m116
  m96 --> m117
  m27 --> m117
  m96 --> m118
  m96 --> m119
  m96 --> m120
  m92 --> m120
  m96 --> m121
  m37 --> m122
  m29 --> m122
  m16 --> m123
  m103 --> m123
  m26 --> m123
  m27 --> m123
  m28 --> m123
  m31 --> m123
  m45 --> m123
  m46 --> m123
  m48 --> m123
  m50 --> m123
  m52 --> m123
  m57 --> m123
  m58 --> m123
  m59 --> m123
  m60 --> m123
  m61 --> m123
  m62 --> m123
  m63 --> m123
  m64 --> m123
  m65 --> m123
  m66 --> m123
  m88 --> m123
  m89 --> m123
  m90 --> m123
  m91 --> m123
  m93 --> m123
  m94 --> m123
  m95 --> m123
  m96 --> m123
  m97 --> m123
  m98 --> m123
  m99 --> m123
  m100 --> m123
  m101 --> m123
  m104 --> m123
  m16 --> m124
  m105 --> m124
  m25 --> m124
  m102 --> m124
  m42 --> m124
  m16 --> m125
  m17 --> m125
  m106 --> m125
  m102 --> m125
  m16 --> m126
  m17 --> m126
  m107 --> m126
  m102 --> m126
  m16 --> m127
  m108 --> m127
  m102 --> m127
  m16 --> m128
  m109 --> m128
  m16 --> m129
  m110 --> m129
  m16 --> m130
  m111 --> m130
  m16 --> m131
  m112 --> m131
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
  m123 --> m142
  m124 --> m142
  m125 --> m142
  m126 --> m142
  m127 --> m142
  m141 --> m142
  m128 --> m142
  m129 --> m142
  m130 --> m142
  m131 --> m142
  m132 --> m142
  m133 --> m142
  m134 --> m142
  m135 --> m142
  m136 --> m142
  m137 --> m142
  m138 --> m142
  m139 --> m142
  m140 --> m142
  m22 --> m143
  m21 --> m143
  m102 --> m143
  m26 --> m143
  m105 --> m143
  m106 --> m143
  m107 --> m143
  m108 --> m143
  m31 --> m143
  m101 --> m143
  m45 --> m143
  m46 --> m143
  m48 --> m143
  m52 --> m143
  m60 --> m143
  m62 --> m143
  m64 --> m143
  m94 --> m143
  m95 --> m143
  m97 --> m143
  m98 --> m143
  m99 --> m143
  m100 --> m143
  m117 --> m143
  m65 --> m143
  m88 --> m143
  m89 --> m143
  m122 --> m143
  m109 --> m143
  m110 --> m143
  m112 --> m143
  m18 --> m144
  m20 --> m144
  m142 --> m144
  m143 --> m144
```

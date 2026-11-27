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
    m86["ITA.S3.IndividualYear"]
    m87["ITA.S39.CanadianSecurities"]
    m88["ITA.S50.BadDebtOrShare"]
    m89["ITA.S43.PartialDisposition"]
    m90["ITA.S74.CorporateAttribution"]
    m91["ITA.S123.CorporateRates"]
    m92["ITA.S129.RefundableTax"]
    m93["ITA.S15.ShareholderLoans"]
    m94["ITA.S89.GeneralRateIncomePool"]
    m95["ITA.S127_5.MinimumTax"]
    m96["ITA.S84.PaidUpCapitalIncrease"]
    m97["ITA.S50.BadDebtPersonalUse"]
    m98["ITA.S54.Timeline"]
  end
  subgraph Lemmas["Layer 2: reusable lemmas"]
    m99["Lemmas.SuperficialLoss"]
    m100["Lemmas.SuspendedLoss"]
  end
  subgraph Transactions["Layer 3: transactions"]
    m101["Transactions.SpouseRepurchase"]
    m102["Transactions.SiblingAndLateRepurchase"]
    m103["Transactions.TfsaContribution"]
    m104["Transactions.HoldcoRepurchase"]
    m105["Transactions.Crystallization"]
    m106["Transactions.SaleThroughHoldco"]
    m107["Transactions.PostMortemPipeline"]
    m108["Transactions.EstateFreeze"]
    m109["Transactions.DonatingShares"]
    m110["Transactions.InvestmentIncomeIntegration"]
    m111["Transactions.EligibleDesignation"]
    m112["Transactions.CrystallizationMinimumTax"]
    m113["Transactions.DebtSwap"]
    m114["Transactions.AttendantCare"]
    m115["Transactions.PensionSplit"]
    m116["Transactions.SalaryOrDividend"]
    m117["Transactions.SupportArrears"]
    m118["Transactions.SisterCompanyRepurchase"]
  end
  subgraph Blueprints["Blueprints"]
    m119["Blueprints.SuperficialLoss"]
    m120["Blueprints.SpouseRepurchase"]
    m121["Blueprints.SiblingAndLateRepurchase"]
    m122["Blueprints.TfsaContribution"]
    m123["Blueprints.HoldcoRepurchase"]
    m124["Blueprints.Crystallization"]
    m125["Blueprints.SaleThroughHoldco"]
    m126["Blueprints.PostMortemPipeline"]
    m127["Blueprints.EstateFreeze"]
    m128["Blueprints.DonatingShares"]
    m129["Blueprints.InvestmentIncomeIntegration"]
    m130["Blueprints.EligibleDesignation"]
    m131["Blueprints.CrystallizationMinimumTax"]
    m132["Blueprints.DebtSwap"]
    m133["Blueprints.AttendantCare"]
    m134["Blueprints.PensionSplit"]
    m135["Blueprints.SalaryOrDividend"]
    m136["Blueprints.SupportArrears"]
    m137["Blueprints.SisterCompanyRepurchase"]
    m138["Blueprints.All"]
  end
  subgraph Examples["Examples"]
    m19["Examples.RuleX"]
    m20["Examples.RuleZ"]
    m21["Examples.ToySeries"]
    m22["Examples.RuleXStatute"]
  end
  subgraph Graphs["Graphs"]
    m139["Graphs.All"]
  end
  subgraph Root["Root"]
    m140["Canteen"]
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
  m43 --> m86
  m51 --> m86
  m56 --> m86
  m53 --> m86
  m68 --> m86
  m69 --> m86
  m70 --> m86
  m71 --> m86
  m72 --> m86
  m73 --> m86
  m74 --> m86
  m75 --> m86
  m76 --> m86
  m79 --> m86
  m80 --> m86
  m81 --> m86
  m82 --> m86
  m83 --> m86
  m84 --> m86
  m85 --> m86
  m41 --> m87
  m41 --> m88
  m41 --> m89
  m54 --> m90
  m10 --> m90
  m4 --> m91
  m2 --> m91
  m91 --> m92
  m12 --> m93
  m10 --> m93
  m1 --> m93
  m2 --> m93
  m91 --> m94
  m10 --> m94
  m86 --> m95
  m54 --> m96
  m12 --> m97
  m10 --> m97
  m2 --> m97
  m23 --> m98
  m23 --> m99
  m37 --> m100
  m24 --> m101
  m99 --> m101
  m27 --> m101
  m28 --> m101
  m24 --> m102
  m28 --> m102
  m99 --> m102
  m36 --> m103
  m28 --> m103
  m36 --> m104
  m27 --> m104
  m29 --> m104
  m50 --> m105
  m51 --> m105
  m54 --> m105
  m27 --> m105
  m55 --> m106
  m58 --> m106
  m46 --> m107
  m50 --> m107
  m54 --> m107
  m59 --> m108
  m90 --> m108
  m95 --> m109
  m86 --> m110
  m92 --> m110
  m86 --> m111
  m94 --> m111
  m95 --> m112
  m95 --> m113
  m27 --> m113
  m95 --> m114
  m95 --> m115
  m95 --> m116
  m91 --> m116
  m95 --> m117
  m37 --> m118
  m29 --> m118
  m16 --> m119
  m99 --> m119
  m26 --> m119
  m27 --> m119
  m28 --> m119
  m31 --> m119
  m45 --> m119
  m46 --> m119
  m48 --> m119
  m50 --> m119
  m52 --> m119
  m57 --> m119
  m58 --> m119
  m59 --> m119
  m60 --> m119
  m61 --> m119
  m62 --> m119
  m63 --> m119
  m64 --> m119
  m65 --> m119
  m66 --> m119
  m87 --> m119
  m88 --> m119
  m89 --> m119
  m90 --> m119
  m92 --> m119
  m93 --> m119
  m94 --> m119
  m95 --> m119
  m96 --> m119
  m97 --> m119
  m100 --> m119
  m16 --> m120
  m101 --> m120
  m25 --> m120
  m98 --> m120
  m42 --> m120
  m16 --> m121
  m17 --> m121
  m102 --> m121
  m98 --> m121
  m16 --> m122
  m17 --> m122
  m103 --> m122
  m98 --> m122
  m16 --> m123
  m104 --> m123
  m98 --> m123
  m16 --> m124
  m105 --> m124
  m16 --> m125
  m106 --> m125
  m16 --> m126
  m107 --> m126
  m16 --> m127
  m108 --> m127
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
  m119 --> m138
  m120 --> m138
  m121 --> m138
  m122 --> m138
  m123 --> m138
  m137 --> m138
  m124 --> m138
  m125 --> m138
  m126 --> m138
  m127 --> m138
  m128 --> m138
  m129 --> m138
  m130 --> m138
  m131 --> m138
  m132 --> m138
  m133 --> m138
  m134 --> m138
  m135 --> m138
  m136 --> m138
  m22 --> m139
  m21 --> m139
  m98 --> m139
  m26 --> m139
  m101 --> m139
  m102 --> m139
  m103 --> m139
  m104 --> m139
  m31 --> m139
  m97 --> m139
  m45 --> m139
  m46 --> m139
  m48 --> m139
  m52 --> m139
  m60 --> m139
  m62 --> m139
  m64 --> m139
  m93 --> m139
  m94 --> m139
  m96 --> m139
  m113 --> m139
  m65 --> m139
  m87 --> m139
  m88 --> m139
  m118 --> m139
  m105 --> m139
  m106 --> m139
  m108 --> m139
  m18 --> m140
  m20 --> m140
  m138 --> m140
  m139 --> m140
```

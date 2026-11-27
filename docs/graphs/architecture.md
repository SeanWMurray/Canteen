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
    m84["ITA.S3.IndividualYear"]
    m85["ITA.S39.CanadianSecurities"]
    m86["ITA.S50.BadDebtOrShare"]
    m87["ITA.S43.PartialDisposition"]
    m88["ITA.S74.CorporateAttribution"]
    m89["ITA.S123.CorporateRates"]
    m90["ITA.S129.RefundableTax"]
    m91["ITA.S15.ShareholderLoans"]
    m92["ITA.S89.GeneralRateIncomePool"]
    m93["ITA.S127_5.MinimumTax"]
    m94["ITA.S84.PaidUpCapitalIncrease"]
    m95["ITA.S50.BadDebtPersonalUse"]
    m96["ITA.S54.Timeline"]
  end
  subgraph Lemmas["Layer 2: reusable lemmas"]
    m97["Lemmas.SuperficialLoss"]
    m98["Lemmas.SuspendedLoss"]
  end
  subgraph Transactions["Layer 3: transactions"]
    m99["Transactions.SpouseRepurchase"]
    m100["Transactions.SiblingAndLateRepurchase"]
    m101["Transactions.TfsaContribution"]
    m102["Transactions.HoldcoRepurchase"]
    m103["Transactions.Crystallization"]
    m104["Transactions.SaleThroughHoldco"]
    m105["Transactions.PostMortemPipeline"]
    m106["Transactions.EstateFreeze"]
    m107["Transactions.DonatingShares"]
    m108["Transactions.InvestmentIncomeIntegration"]
    m109["Transactions.EligibleDesignation"]
    m110["Transactions.CrystallizationMinimumTax"]
    m111["Transactions.DebtSwap"]
    m112["Transactions.AttendantCare"]
    m113["Transactions.PensionSplit"]
    m114["Transactions.SalaryOrDividend"]
    m115["Transactions.SupportArrears"]
    m116["Transactions.SisterCompanyRepurchase"]
  end
  subgraph Blueprints["Blueprints"]
    m117["Blueprints.SuperficialLoss"]
    m118["Blueprints.SpouseRepurchase"]
    m119["Blueprints.SiblingAndLateRepurchase"]
    m120["Blueprints.TfsaContribution"]
    m121["Blueprints.HoldcoRepurchase"]
    m122["Blueprints.Crystallization"]
    m123["Blueprints.SaleThroughHoldco"]
    m124["Blueprints.PostMortemPipeline"]
    m125["Blueprints.EstateFreeze"]
    m126["Blueprints.DonatingShares"]
    m127["Blueprints.InvestmentIncomeIntegration"]
    m128["Blueprints.EligibleDesignation"]
    m129["Blueprints.CrystallizationMinimumTax"]
    m130["Blueprints.DebtSwap"]
    m131["Blueprints.AttendantCare"]
    m132["Blueprints.PensionSplit"]
    m133["Blueprints.SalaryOrDividend"]
    m134["Blueprints.SupportArrears"]
    m135["Blueprints.SisterCompanyRepurchase"]
    m136["Blueprints.All"]
  end
  subgraph Examples["Examples"]
    m19["Examples.RuleX"]
    m20["Examples.RuleZ"]
    m21["Examples.ToySeries"]
    m22["Examples.RuleXStatute"]
  end
  subgraph Graphs["Graphs"]
    m137["Graphs.All"]
  end
  subgraph Root["Root"]
    m138["Canteen"]
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
  m43 --> m84
  m51 --> m84
  m56 --> m84
  m53 --> m84
  m68 --> m84
  m69 --> m84
  m70 --> m84
  m71 --> m84
  m72 --> m84
  m73 --> m84
  m74 --> m84
  m75 --> m84
  m76 --> m84
  m79 --> m84
  m80 --> m84
  m81 --> m84
  m82 --> m84
  m83 --> m84
  m41 --> m85
  m41 --> m86
  m41 --> m87
  m54 --> m88
  m10 --> m88
  m4 --> m89
  m2 --> m89
  m89 --> m90
  m12 --> m91
  m10 --> m91
  m1 --> m91
  m2 --> m91
  m89 --> m92
  m10 --> m92
  m84 --> m93
  m54 --> m94
  m12 --> m95
  m10 --> m95
  m2 --> m95
  m23 --> m96
  m23 --> m97
  m37 --> m98
  m24 --> m99
  m97 --> m99
  m27 --> m99
  m28 --> m99
  m24 --> m100
  m28 --> m100
  m97 --> m100
  m36 --> m101
  m28 --> m101
  m36 --> m102
  m27 --> m102
  m29 --> m102
  m50 --> m103
  m51 --> m103
  m54 --> m103
  m27 --> m103
  m55 --> m104
  m58 --> m104
  m46 --> m105
  m50 --> m105
  m54 --> m105
  m59 --> m106
  m88 --> m106
  m93 --> m107
  m84 --> m108
  m90 --> m108
  m84 --> m109
  m92 --> m109
  m93 --> m110
  m93 --> m111
  m27 --> m111
  m93 --> m112
  m93 --> m113
  m93 --> m114
  m89 --> m114
  m93 --> m115
  m37 --> m116
  m29 --> m116
  m16 --> m117
  m97 --> m117
  m26 --> m117
  m27 --> m117
  m28 --> m117
  m31 --> m117
  m45 --> m117
  m46 --> m117
  m48 --> m117
  m50 --> m117
  m52 --> m117
  m57 --> m117
  m58 --> m117
  m59 --> m117
  m60 --> m117
  m61 --> m117
  m62 --> m117
  m63 --> m117
  m64 --> m117
  m65 --> m117
  m66 --> m117
  m85 --> m117
  m86 --> m117
  m87 --> m117
  m88 --> m117
  m90 --> m117
  m91 --> m117
  m92 --> m117
  m93 --> m117
  m94 --> m117
  m95 --> m117
  m98 --> m117
  m16 --> m118
  m99 --> m118
  m25 --> m118
  m96 --> m118
  m42 --> m118
  m16 --> m119
  m17 --> m119
  m100 --> m119
  m96 --> m119
  m16 --> m120
  m17 --> m120
  m101 --> m120
  m96 --> m120
  m16 --> m121
  m102 --> m121
  m96 --> m121
  m16 --> m122
  m103 --> m122
  m16 --> m123
  m104 --> m123
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
  m117 --> m136
  m118 --> m136
  m119 --> m136
  m120 --> m136
  m121 --> m136
  m135 --> m136
  m122 --> m136
  m123 --> m136
  m124 --> m136
  m125 --> m136
  m126 --> m136
  m127 --> m136
  m128 --> m136
  m129 --> m136
  m130 --> m136
  m131 --> m136
  m132 --> m136
  m133 --> m136
  m134 --> m136
  m22 --> m137
  m21 --> m137
  m96 --> m137
  m26 --> m137
  m99 --> m137
  m100 --> m137
  m101 --> m137
  m102 --> m137
  m31 --> m137
  m95 --> m137
  m45 --> m137
  m46 --> m137
  m48 --> m137
  m52 --> m137
  m60 --> m137
  m62 --> m137
  m64 --> m137
  m91 --> m137
  m92 --> m137
  m94 --> m137
  m111 --> m137
  m65 --> m137
  m85 --> m137
  m86 --> m137
  m116 --> m137
  m103 --> m137
  m104 --> m137
  m106 --> m137
  m18 --> m138
  m20 --> m138
  m136 --> m138
  m137 --> m138
```

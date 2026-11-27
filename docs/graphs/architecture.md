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
    m85["ITA.S3.IndividualYear"]
    m86["ITA.S39.CanadianSecurities"]
    m87["ITA.S50.BadDebtOrShare"]
    m88["ITA.S43.PartialDisposition"]
    m89["ITA.S74.CorporateAttribution"]
    m90["ITA.S123.CorporateRates"]
    m91["ITA.S129.RefundableTax"]
    m92["ITA.S15.ShareholderLoans"]
    m93["ITA.S89.GeneralRateIncomePool"]
    m94["ITA.S127_5.MinimumTax"]
    m95["ITA.S84.PaidUpCapitalIncrease"]
    m96["ITA.S50.BadDebtPersonalUse"]
    m97["ITA.S54.Timeline"]
  end
  subgraph Lemmas["Layer 2: reusable lemmas"]
    m98["Lemmas.SuperficialLoss"]
    m99["Lemmas.SuspendedLoss"]
  end
  subgraph Transactions["Layer 3: transactions"]
    m100["Transactions.SpouseRepurchase"]
    m101["Transactions.SiblingAndLateRepurchase"]
    m102["Transactions.TfsaContribution"]
    m103["Transactions.HoldcoRepurchase"]
    m104["Transactions.Crystallization"]
    m105["Transactions.SaleThroughHoldco"]
    m106["Transactions.PostMortemPipeline"]
    m107["Transactions.EstateFreeze"]
    m108["Transactions.DonatingShares"]
    m109["Transactions.InvestmentIncomeIntegration"]
    m110["Transactions.EligibleDesignation"]
    m111["Transactions.CrystallizationMinimumTax"]
    m112["Transactions.DebtSwap"]
    m113["Transactions.AttendantCare"]
    m114["Transactions.PensionSplit"]
    m115["Transactions.SalaryOrDividend"]
    m116["Transactions.SupportArrears"]
    m117["Transactions.SisterCompanyRepurchase"]
  end
  subgraph Blueprints["Blueprints"]
    m118["Blueprints.SuperficialLoss"]
    m119["Blueprints.SpouseRepurchase"]
    m120["Blueprints.SiblingAndLateRepurchase"]
    m121["Blueprints.TfsaContribution"]
    m122["Blueprints.HoldcoRepurchase"]
    m123["Blueprints.Crystallization"]
    m124["Blueprints.SaleThroughHoldco"]
    m125["Blueprints.PostMortemPipeline"]
    m126["Blueprints.EstateFreeze"]
    m127["Blueprints.DonatingShares"]
    m128["Blueprints.InvestmentIncomeIntegration"]
    m129["Blueprints.EligibleDesignation"]
    m130["Blueprints.CrystallizationMinimumTax"]
    m131["Blueprints.DebtSwap"]
    m132["Blueprints.AttendantCare"]
    m133["Blueprints.PensionSplit"]
    m134["Blueprints.SalaryOrDividend"]
    m135["Blueprints.SupportArrears"]
    m136["Blueprints.SisterCompanyRepurchase"]
    m137["Blueprints.All"]
  end
  subgraph Examples["Examples"]
    m19["Examples.RuleX"]
    m20["Examples.RuleZ"]
    m21["Examples.ToySeries"]
    m22["Examples.RuleXStatute"]
  end
  subgraph Graphs["Graphs"]
    m138["Graphs.All"]
  end
  subgraph Root["Root"]
    m139["Canteen"]
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
  m43 --> m85
  m51 --> m85
  m56 --> m85
  m53 --> m85
  m68 --> m85
  m69 --> m85
  m70 --> m85
  m71 --> m85
  m72 --> m85
  m73 --> m85
  m74 --> m85
  m75 --> m85
  m76 --> m85
  m79 --> m85
  m80 --> m85
  m81 --> m85
  m82 --> m85
  m83 --> m85
  m84 --> m85
  m41 --> m86
  m41 --> m87
  m41 --> m88
  m54 --> m89
  m10 --> m89
  m4 --> m90
  m2 --> m90
  m90 --> m91
  m12 --> m92
  m10 --> m92
  m1 --> m92
  m2 --> m92
  m90 --> m93
  m10 --> m93
  m85 --> m94
  m54 --> m95
  m12 --> m96
  m10 --> m96
  m2 --> m96
  m23 --> m97
  m23 --> m98
  m37 --> m99
  m24 --> m100
  m98 --> m100
  m27 --> m100
  m28 --> m100
  m24 --> m101
  m28 --> m101
  m98 --> m101
  m36 --> m102
  m28 --> m102
  m36 --> m103
  m27 --> m103
  m29 --> m103
  m50 --> m104
  m51 --> m104
  m54 --> m104
  m27 --> m104
  m55 --> m105
  m58 --> m105
  m46 --> m106
  m50 --> m106
  m54 --> m106
  m59 --> m107
  m89 --> m107
  m94 --> m108
  m85 --> m109
  m91 --> m109
  m85 --> m110
  m93 --> m110
  m94 --> m111
  m94 --> m112
  m27 --> m112
  m94 --> m113
  m94 --> m114
  m94 --> m115
  m90 --> m115
  m94 --> m116
  m37 --> m117
  m29 --> m117
  m16 --> m118
  m98 --> m118
  m26 --> m118
  m27 --> m118
  m28 --> m118
  m31 --> m118
  m45 --> m118
  m46 --> m118
  m48 --> m118
  m50 --> m118
  m52 --> m118
  m57 --> m118
  m58 --> m118
  m59 --> m118
  m60 --> m118
  m61 --> m118
  m62 --> m118
  m63 --> m118
  m64 --> m118
  m65 --> m118
  m66 --> m118
  m86 --> m118
  m87 --> m118
  m88 --> m118
  m89 --> m118
  m91 --> m118
  m92 --> m118
  m93 --> m118
  m94 --> m118
  m95 --> m118
  m96 --> m118
  m99 --> m118
  m16 --> m119
  m100 --> m119
  m25 --> m119
  m97 --> m119
  m42 --> m119
  m16 --> m120
  m17 --> m120
  m101 --> m120
  m97 --> m120
  m16 --> m121
  m17 --> m121
  m102 --> m121
  m97 --> m121
  m16 --> m122
  m103 --> m122
  m97 --> m122
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
  m16 --> m136
  m117 --> m136
  m118 --> m137
  m119 --> m137
  m120 --> m137
  m121 --> m137
  m122 --> m137
  m136 --> m137
  m123 --> m137
  m124 --> m137
  m125 --> m137
  m126 --> m137
  m127 --> m137
  m128 --> m137
  m129 --> m137
  m130 --> m137
  m131 --> m137
  m132 --> m137
  m133 --> m137
  m134 --> m137
  m135 --> m137
  m22 --> m138
  m21 --> m138
  m97 --> m138
  m26 --> m138
  m100 --> m138
  m101 --> m138
  m102 --> m138
  m103 --> m138
  m31 --> m138
  m96 --> m138
  m45 --> m138
  m46 --> m138
  m48 --> m138
  m52 --> m138
  m60 --> m138
  m62 --> m138
  m64 --> m138
  m92 --> m138
  m93 --> m138
  m95 --> m138
  m112 --> m138
  m65 --> m138
  m86 --> m138
  m87 --> m138
  m117 --> m138
  m104 --> m138
  m105 --> m138
  m107 --> m138
  m18 --> m139
  m20 --> m139
  m137 --> m139
  m138 --> m139
```

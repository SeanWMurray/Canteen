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
    m83["ITA.S3.IndividualYear"]
    m84["ITA.S39.CanadianSecurities"]
    m85["ITA.S50.BadDebtOrShare"]
    m86["ITA.S43.PartialDisposition"]
    m87["ITA.S74.CorporateAttribution"]
    m88["ITA.S123.CorporateRates"]
    m89["ITA.S129.RefundableTax"]
    m90["ITA.S15.ShareholderLoans"]
    m91["ITA.S89.GeneralRateIncomePool"]
    m92["ITA.S127_5.MinimumTax"]
    m93["ITA.S84.PaidUpCapitalIncrease"]
    m94["ITA.S50.BadDebtPersonalUse"]
    m95["ITA.S54.Timeline"]
  end
  subgraph Lemmas["Layer 2: reusable lemmas"]
    m96["Lemmas.SuperficialLoss"]
    m97["Lemmas.SuspendedLoss"]
  end
  subgraph Transactions["Layer 3: transactions"]
    m98["Transactions.SpouseRepurchase"]
    m99["Transactions.SiblingAndLateRepurchase"]
    m100["Transactions.TfsaContribution"]
    m101["Transactions.HoldcoRepurchase"]
    m102["Transactions.Crystallization"]
    m103["Transactions.SaleThroughHoldco"]
    m104["Transactions.PostMortemPipeline"]
    m105["Transactions.EstateFreeze"]
    m106["Transactions.DonatingShares"]
    m107["Transactions.InvestmentIncomeIntegration"]
    m108["Transactions.EligibleDesignation"]
    m109["Transactions.CrystallizationMinimumTax"]
    m110["Transactions.DebtSwap"]
    m111["Transactions.AttendantCare"]
    m112["Transactions.PensionSplit"]
    m113["Transactions.SalaryOrDividend"]
    m114["Transactions.SupportArrears"]
    m115["Transactions.SisterCompanyRepurchase"]
  end
  subgraph Blueprints["Blueprints"]
    m116["Blueprints.SuperficialLoss"]
    m117["Blueprints.SpouseRepurchase"]
    m118["Blueprints.SiblingAndLateRepurchase"]
    m119["Blueprints.TfsaContribution"]
    m120["Blueprints.HoldcoRepurchase"]
    m121["Blueprints.Crystallization"]
    m122["Blueprints.SaleThroughHoldco"]
    m123["Blueprints.PostMortemPipeline"]
    m124["Blueprints.EstateFreeze"]
    m125["Blueprints.DonatingShares"]
    m126["Blueprints.InvestmentIncomeIntegration"]
    m127["Blueprints.EligibleDesignation"]
    m128["Blueprints.CrystallizationMinimumTax"]
    m129["Blueprints.DebtSwap"]
    m130["Blueprints.AttendantCare"]
    m131["Blueprints.PensionSplit"]
    m132["Blueprints.SalaryOrDividend"]
    m133["Blueprints.SupportArrears"]
    m134["Blueprints.SisterCompanyRepurchase"]
    m135["Blueprints.All"]
  end
  subgraph Examples["Examples"]
    m19["Examples.RuleX"]
    m20["Examples.RuleZ"]
    m21["Examples.ToySeries"]
    m22["Examples.RuleXStatute"]
  end
  subgraph Graphs["Graphs"]
    m136["Graphs.All"]
  end
  subgraph Root["Root"]
    m137["Canteen"]
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
  m43 --> m83
  m51 --> m83
  m56 --> m83
  m53 --> m83
  m68 --> m83
  m69 --> m83
  m70 --> m83
  m71 --> m83
  m72 --> m83
  m73 --> m83
  m74 --> m83
  m75 --> m83
  m76 --> m83
  m79 --> m83
  m80 --> m83
  m81 --> m83
  m82 --> m83
  m41 --> m84
  m41 --> m85
  m41 --> m86
  m54 --> m87
  m10 --> m87
  m4 --> m88
  m2 --> m88
  m88 --> m89
  m12 --> m90
  m10 --> m90
  m1 --> m90
  m2 --> m90
  m88 --> m91
  m10 --> m91
  m83 --> m92
  m54 --> m93
  m12 --> m94
  m10 --> m94
  m2 --> m94
  m23 --> m95
  m23 --> m96
  m37 --> m97
  m24 --> m98
  m96 --> m98
  m27 --> m98
  m28 --> m98
  m24 --> m99
  m28 --> m99
  m96 --> m99
  m36 --> m100
  m28 --> m100
  m36 --> m101
  m27 --> m101
  m29 --> m101
  m50 --> m102
  m51 --> m102
  m54 --> m102
  m27 --> m102
  m55 --> m103
  m58 --> m103
  m46 --> m104
  m50 --> m104
  m54 --> m104
  m59 --> m105
  m87 --> m105
  m92 --> m106
  m83 --> m107
  m89 --> m107
  m83 --> m108
  m91 --> m108
  m92 --> m109
  m92 --> m110
  m27 --> m110
  m92 --> m111
  m92 --> m112
  m92 --> m113
  m88 --> m113
  m92 --> m114
  m37 --> m115
  m29 --> m115
  m16 --> m116
  m96 --> m116
  m26 --> m116
  m27 --> m116
  m28 --> m116
  m31 --> m116
  m45 --> m116
  m46 --> m116
  m48 --> m116
  m50 --> m116
  m52 --> m116
  m57 --> m116
  m58 --> m116
  m59 --> m116
  m60 --> m116
  m61 --> m116
  m62 --> m116
  m63 --> m116
  m64 --> m116
  m65 --> m116
  m66 --> m116
  m84 --> m116
  m85 --> m116
  m86 --> m116
  m87 --> m116
  m89 --> m116
  m90 --> m116
  m91 --> m116
  m92 --> m116
  m93 --> m116
  m94 --> m116
  m97 --> m116
  m16 --> m117
  m98 --> m117
  m25 --> m117
  m95 --> m117
  m42 --> m117
  m16 --> m118
  m17 --> m118
  m99 --> m118
  m95 --> m118
  m16 --> m119
  m17 --> m119
  m100 --> m119
  m95 --> m119
  m16 --> m120
  m101 --> m120
  m95 --> m120
  m16 --> m121
  m102 --> m121
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
  m116 --> m135
  m117 --> m135
  m118 --> m135
  m119 --> m135
  m120 --> m135
  m134 --> m135
  m121 --> m135
  m122 --> m135
  m123 --> m135
  m124 --> m135
  m125 --> m135
  m126 --> m135
  m127 --> m135
  m128 --> m135
  m129 --> m135
  m130 --> m135
  m131 --> m135
  m132 --> m135
  m133 --> m135
  m22 --> m136
  m21 --> m136
  m95 --> m136
  m26 --> m136
  m98 --> m136
  m99 --> m136
  m100 --> m136
  m101 --> m136
  m31 --> m136
  m94 --> m136
  m45 --> m136
  m46 --> m136
  m48 --> m136
  m52 --> m136
  m60 --> m136
  m62 --> m136
  m64 --> m136
  m90 --> m136
  m91 --> m136
  m93 --> m136
  m110 --> m136
  m65 --> m136
  m84 --> m136
  m85 --> m136
  m115 --> m136
  m102 --> m136
  m103 --> m136
  m105 --> m136
  m18 --> m137
  m20 --> m137
  m135 --> m137
  m136 --> m137
```

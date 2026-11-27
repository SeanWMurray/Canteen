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
    m82["ITA.S3.IndividualYear"]
    m83["ITA.S39.CanadianSecurities"]
    m84["ITA.S50.BadDebtOrShare"]
    m85["ITA.S43.PartialDisposition"]
    m86["ITA.S74.CorporateAttribution"]
    m87["ITA.S123.CorporateRates"]
    m88["ITA.S129.RefundableTax"]
    m89["ITA.S15.ShareholderLoans"]
    m90["ITA.S89.GeneralRateIncomePool"]
    m91["ITA.S127_5.MinimumTax"]
    m92["ITA.S84.PaidUpCapitalIncrease"]
    m93["ITA.S50.BadDebtPersonalUse"]
    m94["ITA.S54.Timeline"]
  end
  subgraph Lemmas["Layer 2: reusable lemmas"]
    m95["Lemmas.SuperficialLoss"]
    m96["Lemmas.SuspendedLoss"]
  end
  subgraph Transactions["Layer 3: transactions"]
    m97["Transactions.SpouseRepurchase"]
    m98["Transactions.SiblingAndLateRepurchase"]
    m99["Transactions.TfsaContribution"]
    m100["Transactions.HoldcoRepurchase"]
    m101["Transactions.Crystallization"]
    m102["Transactions.SaleThroughHoldco"]
    m103["Transactions.PostMortemPipeline"]
    m104["Transactions.EstateFreeze"]
    m105["Transactions.DonatingShares"]
    m106["Transactions.InvestmentIncomeIntegration"]
    m107["Transactions.EligibleDesignation"]
    m108["Transactions.CrystallizationMinimumTax"]
    m109["Transactions.DebtSwap"]
    m110["Transactions.AttendantCare"]
    m111["Transactions.PensionSplit"]
    m112["Transactions.SalaryOrDividend"]
    m113["Transactions.SisterCompanyRepurchase"]
  end
  subgraph Blueprints["Blueprints"]
    m114["Blueprints.SuperficialLoss"]
    m115["Blueprints.SpouseRepurchase"]
    m116["Blueprints.SiblingAndLateRepurchase"]
    m117["Blueprints.TfsaContribution"]
    m118["Blueprints.HoldcoRepurchase"]
    m119["Blueprints.Crystallization"]
    m120["Blueprints.SaleThroughHoldco"]
    m121["Blueprints.PostMortemPipeline"]
    m122["Blueprints.EstateFreeze"]
    m123["Blueprints.DonatingShares"]
    m124["Blueprints.InvestmentIncomeIntegration"]
    m125["Blueprints.EligibleDesignation"]
    m126["Blueprints.CrystallizationMinimumTax"]
    m127["Blueprints.DebtSwap"]
    m128["Blueprints.AttendantCare"]
    m129["Blueprints.PensionSplit"]
    m130["Blueprints.SalaryOrDividend"]
    m131["Blueprints.SisterCompanyRepurchase"]
    m132["Blueprints.All"]
  end
  subgraph Examples["Examples"]
    m19["Examples.RuleX"]
    m20["Examples.RuleZ"]
    m21["Examples.ToySeries"]
    m22["Examples.RuleXStatute"]
  end
  subgraph Graphs["Graphs"]
    m133["Graphs.All"]
  end
  subgraph Root["Root"]
    m134["Canteen"]
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
  m43 --> m82
  m51 --> m82
  m56 --> m82
  m53 --> m82
  m68 --> m82
  m69 --> m82
  m70 --> m82
  m71 --> m82
  m72 --> m82
  m73 --> m82
  m74 --> m82
  m75 --> m82
  m76 --> m82
  m79 --> m82
  m80 --> m82
  m81 --> m82
  m41 --> m83
  m41 --> m84
  m41 --> m85
  m54 --> m86
  m10 --> m86
  m4 --> m87
  m2 --> m87
  m87 --> m88
  m12 --> m89
  m10 --> m89
  m1 --> m89
  m2 --> m89
  m87 --> m90
  m10 --> m90
  m82 --> m91
  m54 --> m92
  m12 --> m93
  m10 --> m93
  m2 --> m93
  m23 --> m94
  m23 --> m95
  m37 --> m96
  m24 --> m97
  m95 --> m97
  m27 --> m97
  m28 --> m97
  m24 --> m98
  m28 --> m98
  m95 --> m98
  m36 --> m99
  m28 --> m99
  m36 --> m100
  m27 --> m100
  m29 --> m100
  m50 --> m101
  m51 --> m101
  m54 --> m101
  m27 --> m101
  m55 --> m102
  m58 --> m102
  m46 --> m103
  m50 --> m103
  m54 --> m103
  m59 --> m104
  m86 --> m104
  m91 --> m105
  m82 --> m106
  m88 --> m106
  m82 --> m107
  m90 --> m107
  m91 --> m108
  m91 --> m109
  m27 --> m109
  m91 --> m110
  m91 --> m111
  m91 --> m112
  m87 --> m112
  m37 --> m113
  m29 --> m113
  m16 --> m114
  m95 --> m114
  m26 --> m114
  m27 --> m114
  m28 --> m114
  m31 --> m114
  m45 --> m114
  m46 --> m114
  m48 --> m114
  m50 --> m114
  m52 --> m114
  m57 --> m114
  m58 --> m114
  m59 --> m114
  m60 --> m114
  m61 --> m114
  m62 --> m114
  m63 --> m114
  m64 --> m114
  m65 --> m114
  m66 --> m114
  m83 --> m114
  m84 --> m114
  m85 --> m114
  m86 --> m114
  m88 --> m114
  m89 --> m114
  m90 --> m114
  m91 --> m114
  m92 --> m114
  m93 --> m114
  m96 --> m114
  m16 --> m115
  m97 --> m115
  m25 --> m115
  m94 --> m115
  m42 --> m115
  m16 --> m116
  m17 --> m116
  m98 --> m116
  m94 --> m116
  m16 --> m117
  m17 --> m117
  m99 --> m117
  m94 --> m117
  m16 --> m118
  m100 --> m118
  m94 --> m118
  m16 --> m119
  m101 --> m119
  m16 --> m120
  m102 --> m120
  m16 --> m121
  m103 --> m121
  m16 --> m122
  m104 --> m122
  m16 --> m123
  m105 --> m123
  m16 --> m124
  m106 --> m124
  m16 --> m125
  m107 --> m125
  m16 --> m126
  m108 --> m126
  m16 --> m127
  m109 --> m127
  m16 --> m128
  m110 --> m128
  m16 --> m129
  m111 --> m129
  m16 --> m130
  m112 --> m130
  m16 --> m131
  m113 --> m131
  m114 --> m132
  m115 --> m132
  m116 --> m132
  m117 --> m132
  m118 --> m132
  m131 --> m132
  m119 --> m132
  m120 --> m132
  m121 --> m132
  m122 --> m132
  m123 --> m132
  m124 --> m132
  m125 --> m132
  m126 --> m132
  m127 --> m132
  m128 --> m132
  m129 --> m132
  m130 --> m132
  m22 --> m133
  m21 --> m133
  m94 --> m133
  m26 --> m133
  m97 --> m133
  m98 --> m133
  m99 --> m133
  m100 --> m133
  m31 --> m133
  m93 --> m133
  m45 --> m133
  m46 --> m133
  m48 --> m133
  m52 --> m133
  m60 --> m133
  m62 --> m133
  m64 --> m133
  m89 --> m133
  m90 --> m133
  m92 --> m133
  m109 --> m133
  m65 --> m133
  m83 --> m133
  m84 --> m133
  m113 --> m133
  m101 --> m133
  m102 --> m133
  m104 --> m133
  m18 --> m134
  m20 --> m134
  m132 --> m134
  m133 --> m134
```

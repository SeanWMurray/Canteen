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
    m80["ITA.S3.IndividualYear"]
    m81["ITA.S39.CanadianSecurities"]
    m82["ITA.S50.BadDebtOrShare"]
    m83["ITA.S43.PartialDisposition"]
    m84["ITA.S74.CorporateAttribution"]
    m85["ITA.S123.CorporateRates"]
    m86["ITA.S129.RefundableTax"]
    m87["ITA.S15.ShareholderLoans"]
    m88["ITA.S89.GeneralRateIncomePool"]
    m89["ITA.S127_5.MinimumTax"]
    m90["ITA.S84.PaidUpCapitalIncrease"]
    m91["ITA.S50.BadDebtPersonalUse"]
    m92["ITA.S54.Timeline"]
  end
  subgraph Lemmas["Layer 2: reusable lemmas"]
    m93["Lemmas.SuperficialLoss"]
    m94["Lemmas.SuspendedLoss"]
  end
  subgraph Transactions["Layer 3: transactions"]
    m95["Transactions.SpouseRepurchase"]
    m96["Transactions.SiblingAndLateRepurchase"]
    m97["Transactions.TfsaContribution"]
    m98["Transactions.HoldcoRepurchase"]
    m99["Transactions.Crystallization"]
    m100["Transactions.SaleThroughHoldco"]
    m101["Transactions.PostMortemPipeline"]
    m102["Transactions.EstateFreeze"]
    m103["Transactions.DonatingShares"]
    m104["Transactions.InvestmentIncomeIntegration"]
    m105["Transactions.EligibleDesignation"]
    m106["Transactions.CrystallizationMinimumTax"]
    m107["Transactions.DebtSwap"]
    m108["Transactions.AttendantCare"]
    m109["Transactions.PensionSplit"]
    m110["Transactions.SalaryOrDividend"]
    m111["Transactions.SisterCompanyRepurchase"]
  end
  subgraph Blueprints["Blueprints"]
    m112["Blueprints.SuperficialLoss"]
    m113["Blueprints.SpouseRepurchase"]
    m114["Blueprints.SiblingAndLateRepurchase"]
    m115["Blueprints.TfsaContribution"]
    m116["Blueprints.HoldcoRepurchase"]
    m117["Blueprints.Crystallization"]
    m118["Blueprints.SaleThroughHoldco"]
    m119["Blueprints.PostMortemPipeline"]
    m120["Blueprints.EstateFreeze"]
    m121["Blueprints.DonatingShares"]
    m122["Blueprints.InvestmentIncomeIntegration"]
    m123["Blueprints.EligibleDesignation"]
    m124["Blueprints.CrystallizationMinimumTax"]
    m125["Blueprints.DebtSwap"]
    m126["Blueprints.AttendantCare"]
    m127["Blueprints.PensionSplit"]
    m128["Blueprints.SalaryOrDividend"]
    m129["Blueprints.SisterCompanyRepurchase"]
    m130["Blueprints.All"]
  end
  subgraph Examples["Examples"]
    m19["Examples.RuleX"]
    m20["Examples.RuleZ"]
    m21["Examples.ToySeries"]
    m22["Examples.RuleXStatute"]
  end
  subgraph Graphs["Graphs"]
    m131["Graphs.All"]
  end
  subgraph Root["Root"]
    m132["Canteen"]
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
  m43 --> m80
  m51 --> m80
  m56 --> m80
  m53 --> m80
  m68 --> m80
  m69 --> m80
  m70 --> m80
  m71 --> m80
  m72 --> m80
  m73 --> m80
  m74 --> m80
  m75 --> m80
  m76 --> m80
  m79 --> m80
  m41 --> m81
  m41 --> m82
  m41 --> m83
  m54 --> m84
  m10 --> m84
  m4 --> m85
  m2 --> m85
  m85 --> m86
  m12 --> m87
  m10 --> m87
  m1 --> m87
  m2 --> m87
  m85 --> m88
  m10 --> m88
  m80 --> m89
  m54 --> m90
  m12 --> m91
  m10 --> m91
  m2 --> m91
  m23 --> m92
  m23 --> m93
  m37 --> m94
  m24 --> m95
  m93 --> m95
  m27 --> m95
  m28 --> m95
  m24 --> m96
  m28 --> m96
  m93 --> m96
  m36 --> m97
  m28 --> m97
  m36 --> m98
  m27 --> m98
  m29 --> m98
  m50 --> m99
  m51 --> m99
  m54 --> m99
  m27 --> m99
  m55 --> m100
  m58 --> m100
  m46 --> m101
  m50 --> m101
  m54 --> m101
  m59 --> m102
  m84 --> m102
  m89 --> m103
  m80 --> m104
  m86 --> m104
  m80 --> m105
  m88 --> m105
  m89 --> m106
  m89 --> m107
  m27 --> m107
  m89 --> m108
  m89 --> m109
  m89 --> m110
  m85 --> m110
  m37 --> m111
  m29 --> m111
  m16 --> m112
  m93 --> m112
  m26 --> m112
  m27 --> m112
  m28 --> m112
  m31 --> m112
  m45 --> m112
  m46 --> m112
  m48 --> m112
  m50 --> m112
  m52 --> m112
  m57 --> m112
  m58 --> m112
  m59 --> m112
  m60 --> m112
  m61 --> m112
  m62 --> m112
  m63 --> m112
  m64 --> m112
  m65 --> m112
  m66 --> m112
  m81 --> m112
  m82 --> m112
  m83 --> m112
  m84 --> m112
  m86 --> m112
  m87 --> m112
  m88 --> m112
  m89 --> m112
  m90 --> m112
  m91 --> m112
  m94 --> m112
  m16 --> m113
  m95 --> m113
  m25 --> m113
  m92 --> m113
  m42 --> m113
  m16 --> m114
  m17 --> m114
  m96 --> m114
  m92 --> m114
  m16 --> m115
  m17 --> m115
  m97 --> m115
  m92 --> m115
  m16 --> m116
  m98 --> m116
  m92 --> m116
  m16 --> m117
  m99 --> m117
  m16 --> m118
  m100 --> m118
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
  m112 --> m130
  m113 --> m130
  m114 --> m130
  m115 --> m130
  m116 --> m130
  m129 --> m130
  m117 --> m130
  m118 --> m130
  m119 --> m130
  m120 --> m130
  m121 --> m130
  m122 --> m130
  m123 --> m130
  m124 --> m130
  m125 --> m130
  m126 --> m130
  m127 --> m130
  m128 --> m130
  m22 --> m131
  m21 --> m131
  m92 --> m131
  m26 --> m131
  m95 --> m131
  m96 --> m131
  m97 --> m131
  m98 --> m131
  m31 --> m131
  m91 --> m131
  m45 --> m131
  m46 --> m131
  m48 --> m131
  m52 --> m131
  m60 --> m131
  m62 --> m131
  m64 --> m131
  m87 --> m131
  m88 --> m131
  m90 --> m131
  m107 --> m131
  m65 --> m131
  m81 --> m131
  m82 --> m131
  m111 --> m131
  m99 --> m131
  m100 --> m131
  m102 --> m131
  m18 --> m132
  m20 --> m132
  m130 --> m132
  m131 --> m132
```

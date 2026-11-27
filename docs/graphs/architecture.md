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
    m81["ITA.S3.IndividualYear"]
    m82["ITA.S39.CanadianSecurities"]
    m83["ITA.S50.BadDebtOrShare"]
    m84["ITA.S43.PartialDisposition"]
    m85["ITA.S74.CorporateAttribution"]
    m86["ITA.S123.CorporateRates"]
    m87["ITA.S129.RefundableTax"]
    m88["ITA.S15.ShareholderLoans"]
    m89["ITA.S89.GeneralRateIncomePool"]
    m90["ITA.S127_5.MinimumTax"]
    m91["ITA.S84.PaidUpCapitalIncrease"]
    m92["ITA.S50.BadDebtPersonalUse"]
    m93["ITA.S54.Timeline"]
  end
  subgraph Lemmas["Layer 2: reusable lemmas"]
    m94["Lemmas.SuperficialLoss"]
    m95["Lemmas.SuspendedLoss"]
  end
  subgraph Transactions["Layer 3: transactions"]
    m96["Transactions.SpouseRepurchase"]
    m97["Transactions.SiblingAndLateRepurchase"]
    m98["Transactions.TfsaContribution"]
    m99["Transactions.HoldcoRepurchase"]
    m100["Transactions.Crystallization"]
    m101["Transactions.SaleThroughHoldco"]
    m102["Transactions.PostMortemPipeline"]
    m103["Transactions.EstateFreeze"]
    m104["Transactions.DonatingShares"]
    m105["Transactions.InvestmentIncomeIntegration"]
    m106["Transactions.EligibleDesignation"]
    m107["Transactions.CrystallizationMinimumTax"]
    m108["Transactions.DebtSwap"]
    m109["Transactions.AttendantCare"]
    m110["Transactions.PensionSplit"]
    m111["Transactions.SalaryOrDividend"]
    m112["Transactions.SisterCompanyRepurchase"]
  end
  subgraph Blueprints["Blueprints"]
    m113["Blueprints.SuperficialLoss"]
    m114["Blueprints.SpouseRepurchase"]
    m115["Blueprints.SiblingAndLateRepurchase"]
    m116["Blueprints.TfsaContribution"]
    m117["Blueprints.HoldcoRepurchase"]
    m118["Blueprints.Crystallization"]
    m119["Blueprints.SaleThroughHoldco"]
    m120["Blueprints.PostMortemPipeline"]
    m121["Blueprints.EstateFreeze"]
    m122["Blueprints.DonatingShares"]
    m123["Blueprints.InvestmentIncomeIntegration"]
    m124["Blueprints.EligibleDesignation"]
    m125["Blueprints.CrystallizationMinimumTax"]
    m126["Blueprints.DebtSwap"]
    m127["Blueprints.AttendantCare"]
    m128["Blueprints.PensionSplit"]
    m129["Blueprints.SalaryOrDividend"]
    m130["Blueprints.SisterCompanyRepurchase"]
    m131["Blueprints.All"]
  end
  subgraph Examples["Examples"]
    m19["Examples.RuleX"]
    m20["Examples.RuleZ"]
    m21["Examples.ToySeries"]
    m22["Examples.RuleXStatute"]
  end
  subgraph Graphs["Graphs"]
    m132["Graphs.All"]
  end
  subgraph Root["Root"]
    m133["Canteen"]
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
  m43 --> m81
  m51 --> m81
  m56 --> m81
  m53 --> m81
  m68 --> m81
  m69 --> m81
  m70 --> m81
  m71 --> m81
  m72 --> m81
  m73 --> m81
  m74 --> m81
  m75 --> m81
  m76 --> m81
  m79 --> m81
  m80 --> m81
  m41 --> m82
  m41 --> m83
  m41 --> m84
  m54 --> m85
  m10 --> m85
  m4 --> m86
  m2 --> m86
  m86 --> m87
  m12 --> m88
  m10 --> m88
  m1 --> m88
  m2 --> m88
  m86 --> m89
  m10 --> m89
  m81 --> m90
  m54 --> m91
  m12 --> m92
  m10 --> m92
  m2 --> m92
  m23 --> m93
  m23 --> m94
  m37 --> m95
  m24 --> m96
  m94 --> m96
  m27 --> m96
  m28 --> m96
  m24 --> m97
  m28 --> m97
  m94 --> m97
  m36 --> m98
  m28 --> m98
  m36 --> m99
  m27 --> m99
  m29 --> m99
  m50 --> m100
  m51 --> m100
  m54 --> m100
  m27 --> m100
  m55 --> m101
  m58 --> m101
  m46 --> m102
  m50 --> m102
  m54 --> m102
  m59 --> m103
  m85 --> m103
  m90 --> m104
  m81 --> m105
  m87 --> m105
  m81 --> m106
  m89 --> m106
  m90 --> m107
  m90 --> m108
  m27 --> m108
  m90 --> m109
  m90 --> m110
  m90 --> m111
  m86 --> m111
  m37 --> m112
  m29 --> m112
  m16 --> m113
  m94 --> m113
  m26 --> m113
  m27 --> m113
  m28 --> m113
  m31 --> m113
  m45 --> m113
  m46 --> m113
  m48 --> m113
  m50 --> m113
  m52 --> m113
  m57 --> m113
  m58 --> m113
  m59 --> m113
  m60 --> m113
  m61 --> m113
  m62 --> m113
  m63 --> m113
  m64 --> m113
  m65 --> m113
  m66 --> m113
  m82 --> m113
  m83 --> m113
  m84 --> m113
  m85 --> m113
  m87 --> m113
  m88 --> m113
  m89 --> m113
  m90 --> m113
  m91 --> m113
  m92 --> m113
  m95 --> m113
  m16 --> m114
  m96 --> m114
  m25 --> m114
  m93 --> m114
  m42 --> m114
  m16 --> m115
  m17 --> m115
  m97 --> m115
  m93 --> m115
  m16 --> m116
  m17 --> m116
  m98 --> m116
  m93 --> m116
  m16 --> m117
  m99 --> m117
  m93 --> m117
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
  m16 --> m130
  m112 --> m130
  m113 --> m131
  m114 --> m131
  m115 --> m131
  m116 --> m131
  m117 --> m131
  m130 --> m131
  m118 --> m131
  m119 --> m131
  m120 --> m131
  m121 --> m131
  m122 --> m131
  m123 --> m131
  m124 --> m131
  m125 --> m131
  m126 --> m131
  m127 --> m131
  m128 --> m131
  m129 --> m131
  m22 --> m132
  m21 --> m132
  m93 --> m132
  m26 --> m132
  m96 --> m132
  m97 --> m132
  m98 --> m132
  m99 --> m132
  m31 --> m132
  m92 --> m132
  m45 --> m132
  m46 --> m132
  m48 --> m132
  m52 --> m132
  m60 --> m132
  m62 --> m132
  m64 --> m132
  m88 --> m132
  m89 --> m132
  m91 --> m132
  m108 --> m132
  m65 --> m132
  m82 --> m132
  m83 --> m132
  m112 --> m132
  m100 --> m132
  m101 --> m132
  m103 --> m132
  m18 --> m133
  m20 --> m133
  m131 --> m133
  m132 --> m133
```

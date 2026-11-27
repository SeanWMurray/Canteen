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
    m77["ITA.S3.IndividualYear"]
    m78["ITA.S39.CanadianSecurities"]
    m79["ITA.S50.BadDebtOrShare"]
    m80["ITA.S43.PartialDisposition"]
    m81["ITA.S74.CorporateAttribution"]
    m82["ITA.S123.CorporateRates"]
    m83["ITA.S129.RefundableTax"]
    m84["ITA.S15.ShareholderLoans"]
    m85["ITA.S89.GeneralRateIncomePool"]
    m86["ITA.S127_5.MinimumTax"]
    m87["ITA.S84.PaidUpCapitalIncrease"]
    m88["ITA.S50.BadDebtPersonalUse"]
    m89["ITA.S54.Timeline"]
  end
  subgraph Lemmas["Layer 2: reusable lemmas"]
    m90["Lemmas.SuperficialLoss"]
    m91["Lemmas.SuspendedLoss"]
  end
  subgraph Transactions["Layer 3: transactions"]
    m92["Transactions.SpouseRepurchase"]
    m93["Transactions.SiblingAndLateRepurchase"]
    m94["Transactions.TfsaContribution"]
    m95["Transactions.HoldcoRepurchase"]
    m96["Transactions.Crystallization"]
    m97["Transactions.SaleThroughHoldco"]
    m98["Transactions.PostMortemPipeline"]
    m99["Transactions.EstateFreeze"]
    m100["Transactions.DonatingShares"]
    m101["Transactions.InvestmentIncomeIntegration"]
    m102["Transactions.EligibleDesignation"]
    m103["Transactions.CrystallizationMinimumTax"]
    m104["Transactions.DebtSwap"]
    m105["Transactions.AttendantCare"]
    m106["Transactions.PensionSplit"]
    m107["Transactions.SalaryOrDividend"]
    m108["Transactions.SisterCompanyRepurchase"]
  end
  subgraph Blueprints["Blueprints"]
    m109["Blueprints.SuperficialLoss"]
    m110["Blueprints.SpouseRepurchase"]
    m111["Blueprints.SiblingAndLateRepurchase"]
    m112["Blueprints.TfsaContribution"]
    m113["Blueprints.HoldcoRepurchase"]
    m114["Blueprints.Crystallization"]
    m115["Blueprints.SaleThroughHoldco"]
    m116["Blueprints.PostMortemPipeline"]
    m117["Blueprints.EstateFreeze"]
    m118["Blueprints.DonatingShares"]
    m119["Blueprints.InvestmentIncomeIntegration"]
    m120["Blueprints.EligibleDesignation"]
    m121["Blueprints.CrystallizationMinimumTax"]
    m122["Blueprints.DebtSwap"]
    m123["Blueprints.AttendantCare"]
    m124["Blueprints.PensionSplit"]
    m125["Blueprints.SalaryOrDividend"]
    m126["Blueprints.SisterCompanyRepurchase"]
    m127["Blueprints.All"]
  end
  subgraph Examples["Examples"]
    m19["Examples.RuleX"]
    m20["Examples.RuleZ"]
    m21["Examples.ToySeries"]
    m22["Examples.RuleXStatute"]
  end
  subgraph Graphs["Graphs"]
    m128["Graphs.All"]
  end
  subgraph Root["Root"]
    m129["Canteen"]
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
  m43 --> m77
  m51 --> m77
  m56 --> m77
  m53 --> m77
  m68 --> m77
  m69 --> m77
  m70 --> m77
  m71 --> m77
  m72 --> m77
  m73 --> m77
  m74 --> m77
  m75 --> m77
  m76 --> m77
  m41 --> m78
  m41 --> m79
  m41 --> m80
  m54 --> m81
  m10 --> m81
  m4 --> m82
  m2 --> m82
  m82 --> m83
  m12 --> m84
  m10 --> m84
  m1 --> m84
  m2 --> m84
  m82 --> m85
  m10 --> m85
  m77 --> m86
  m54 --> m87
  m12 --> m88
  m10 --> m88
  m2 --> m88
  m23 --> m89
  m23 --> m90
  m37 --> m91
  m24 --> m92
  m90 --> m92
  m27 --> m92
  m28 --> m92
  m24 --> m93
  m28 --> m93
  m90 --> m93
  m36 --> m94
  m28 --> m94
  m36 --> m95
  m27 --> m95
  m29 --> m95
  m50 --> m96
  m51 --> m96
  m54 --> m96
  m27 --> m96
  m55 --> m97
  m58 --> m97
  m46 --> m98
  m50 --> m98
  m54 --> m98
  m59 --> m99
  m81 --> m99
  m86 --> m100
  m77 --> m101
  m83 --> m101
  m77 --> m102
  m85 --> m102
  m86 --> m103
  m86 --> m104
  m27 --> m104
  m86 --> m105
  m86 --> m106
  m86 --> m107
  m82 --> m107
  m37 --> m108
  m29 --> m108
  m16 --> m109
  m90 --> m109
  m26 --> m109
  m27 --> m109
  m28 --> m109
  m31 --> m109
  m45 --> m109
  m46 --> m109
  m48 --> m109
  m50 --> m109
  m52 --> m109
  m57 --> m109
  m58 --> m109
  m59 --> m109
  m60 --> m109
  m61 --> m109
  m62 --> m109
  m63 --> m109
  m64 --> m109
  m65 --> m109
  m66 --> m109
  m78 --> m109
  m79 --> m109
  m80 --> m109
  m81 --> m109
  m83 --> m109
  m84 --> m109
  m85 --> m109
  m86 --> m109
  m87 --> m109
  m88 --> m109
  m91 --> m109
  m16 --> m110
  m92 --> m110
  m25 --> m110
  m89 --> m110
  m42 --> m110
  m16 --> m111
  m17 --> m111
  m93 --> m111
  m89 --> m111
  m16 --> m112
  m17 --> m112
  m94 --> m112
  m89 --> m112
  m16 --> m113
  m95 --> m113
  m89 --> m113
  m16 --> m114
  m96 --> m114
  m16 --> m115
  m97 --> m115
  m16 --> m116
  m98 --> m116
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
  m109 --> m127
  m110 --> m127
  m111 --> m127
  m112 --> m127
  m113 --> m127
  m126 --> m127
  m114 --> m127
  m115 --> m127
  m116 --> m127
  m117 --> m127
  m118 --> m127
  m119 --> m127
  m120 --> m127
  m121 --> m127
  m122 --> m127
  m123 --> m127
  m124 --> m127
  m125 --> m127
  m22 --> m128
  m21 --> m128
  m89 --> m128
  m26 --> m128
  m92 --> m128
  m93 --> m128
  m94 --> m128
  m95 --> m128
  m31 --> m128
  m88 --> m128
  m45 --> m128
  m46 --> m128
  m48 --> m128
  m52 --> m128
  m60 --> m128
  m62 --> m128
  m64 --> m128
  m84 --> m128
  m85 --> m128
  m87 --> m128
  m104 --> m128
  m65 --> m128
  m78 --> m128
  m79 --> m128
  m108 --> m128
  m96 --> m128
  m97 --> m128
  m99 --> m128
  m18 --> m129
  m20 --> m129
  m127 --> m129
  m128 --> m129
```

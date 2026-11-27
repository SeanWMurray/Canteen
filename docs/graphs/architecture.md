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
    m76["ITA.S3.IndividualYear"]
    m77["ITA.S39.CanadianSecurities"]
    m78["ITA.S50.BadDebtOrShare"]
    m79["ITA.S43.PartialDisposition"]
    m80["ITA.S74.CorporateAttribution"]
    m81["ITA.S123.CorporateRates"]
    m82["ITA.S129.RefundableTax"]
    m83["ITA.S15.ShareholderLoans"]
    m84["ITA.S89.GeneralRateIncomePool"]
    m85["ITA.S127_5.MinimumTax"]
    m86["ITA.S84.PaidUpCapitalIncrease"]
    m87["ITA.S50.BadDebtPersonalUse"]
    m88["ITA.S54.Timeline"]
  end
  subgraph Lemmas["Layer 2: reusable lemmas"]
    m89["Lemmas.SuperficialLoss"]
    m90["Lemmas.SuspendedLoss"]
  end
  subgraph Transactions["Layer 3: transactions"]
    m91["Transactions.SpouseRepurchase"]
    m92["Transactions.SiblingAndLateRepurchase"]
    m93["Transactions.TfsaContribution"]
    m94["Transactions.HoldcoRepurchase"]
    m95["Transactions.Crystallization"]
    m96["Transactions.SaleThroughHoldco"]
    m97["Transactions.PostMortemPipeline"]
    m98["Transactions.EstateFreeze"]
    m99["Transactions.DonatingShares"]
    m100["Transactions.InvestmentIncomeIntegration"]
    m101["Transactions.EligibleDesignation"]
    m102["Transactions.CrystallizationMinimumTax"]
    m103["Transactions.DebtSwap"]
    m104["Transactions.AttendantCare"]
    m105["Transactions.PensionSplit"]
    m106["Transactions.SisterCompanyRepurchase"]
  end
  subgraph Blueprints["Blueprints"]
    m107["Blueprints.SuperficialLoss"]
    m108["Blueprints.SpouseRepurchase"]
    m109["Blueprints.SiblingAndLateRepurchase"]
    m110["Blueprints.TfsaContribution"]
    m111["Blueprints.HoldcoRepurchase"]
    m112["Blueprints.Crystallization"]
    m113["Blueprints.SaleThroughHoldco"]
    m114["Blueprints.PostMortemPipeline"]
    m115["Blueprints.EstateFreeze"]
    m116["Blueprints.DonatingShares"]
    m117["Blueprints.InvestmentIncomeIntegration"]
    m118["Blueprints.EligibleDesignation"]
    m119["Blueprints.CrystallizationMinimumTax"]
    m120["Blueprints.DebtSwap"]
    m121["Blueprints.AttendantCare"]
    m122["Blueprints.PensionSplit"]
    m123["Blueprints.SisterCompanyRepurchase"]
    m124["Blueprints.All"]
  end
  subgraph Examples["Examples"]
    m19["Examples.RuleX"]
    m20["Examples.RuleZ"]
    m21["Examples.ToySeries"]
    m22["Examples.RuleXStatute"]
  end
  subgraph Graphs["Graphs"]
    m125["Graphs.All"]
  end
  subgraph Root["Root"]
    m126["Canteen"]
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
  m43 --> m76
  m51 --> m76
  m56 --> m76
  m53 --> m76
  m68 --> m76
  m69 --> m76
  m70 --> m76
  m71 --> m76
  m72 --> m76
  m73 --> m76
  m74 --> m76
  m75 --> m76
  m41 --> m77
  m41 --> m78
  m41 --> m79
  m54 --> m80
  m10 --> m80
  m4 --> m81
  m2 --> m81
  m81 --> m82
  m12 --> m83
  m10 --> m83
  m1 --> m83
  m2 --> m83
  m81 --> m84
  m10 --> m84
  m76 --> m85
  m54 --> m86
  m12 --> m87
  m10 --> m87
  m2 --> m87
  m23 --> m88
  m23 --> m89
  m37 --> m90
  m24 --> m91
  m89 --> m91
  m27 --> m91
  m28 --> m91
  m24 --> m92
  m28 --> m92
  m89 --> m92
  m36 --> m93
  m28 --> m93
  m36 --> m94
  m27 --> m94
  m29 --> m94
  m50 --> m95
  m51 --> m95
  m54 --> m95
  m27 --> m95
  m55 --> m96
  m58 --> m96
  m46 --> m97
  m50 --> m97
  m54 --> m97
  m59 --> m98
  m80 --> m98
  m85 --> m99
  m76 --> m100
  m82 --> m100
  m76 --> m101
  m84 --> m101
  m85 --> m102
  m85 --> m103
  m27 --> m103
  m85 --> m104
  m85 --> m105
  m37 --> m106
  m29 --> m106
  m16 --> m107
  m89 --> m107
  m26 --> m107
  m27 --> m107
  m28 --> m107
  m31 --> m107
  m45 --> m107
  m46 --> m107
  m48 --> m107
  m50 --> m107
  m52 --> m107
  m57 --> m107
  m58 --> m107
  m59 --> m107
  m60 --> m107
  m61 --> m107
  m62 --> m107
  m63 --> m107
  m64 --> m107
  m65 --> m107
  m66 --> m107
  m77 --> m107
  m78 --> m107
  m79 --> m107
  m80 --> m107
  m82 --> m107
  m83 --> m107
  m84 --> m107
  m85 --> m107
  m86 --> m107
  m87 --> m107
  m90 --> m107
  m16 --> m108
  m91 --> m108
  m25 --> m108
  m88 --> m108
  m42 --> m108
  m16 --> m109
  m17 --> m109
  m92 --> m109
  m88 --> m109
  m16 --> m110
  m17 --> m110
  m93 --> m110
  m88 --> m110
  m16 --> m111
  m94 --> m111
  m88 --> m111
  m16 --> m112
  m95 --> m112
  m16 --> m113
  m96 --> m113
  m16 --> m114
  m97 --> m114
  m16 --> m115
  m98 --> m115
  m16 --> m116
  m99 --> m116
  m16 --> m117
  m100 --> m117
  m16 --> m118
  m101 --> m118
  m16 --> m119
  m102 --> m119
  m16 --> m120
  m103 --> m120
  m16 --> m121
  m104 --> m121
  m16 --> m122
  m105 --> m122
  m16 --> m123
  m106 --> m123
  m107 --> m124
  m108 --> m124
  m109 --> m124
  m110 --> m124
  m111 --> m124
  m123 --> m124
  m112 --> m124
  m113 --> m124
  m114 --> m124
  m115 --> m124
  m116 --> m124
  m117 --> m124
  m118 --> m124
  m119 --> m124
  m120 --> m124
  m121 --> m124
  m122 --> m124
  m22 --> m125
  m21 --> m125
  m88 --> m125
  m26 --> m125
  m91 --> m125
  m92 --> m125
  m93 --> m125
  m94 --> m125
  m31 --> m125
  m87 --> m125
  m45 --> m125
  m46 --> m125
  m48 --> m125
  m52 --> m125
  m60 --> m125
  m62 --> m125
  m64 --> m125
  m83 --> m125
  m84 --> m125
  m86 --> m125
  m103 --> m125
  m65 --> m125
  m77 --> m125
  m78 --> m125
  m106 --> m125
  m95 --> m125
  m96 --> m125
  m98 --> m125
  m18 --> m126
  m20 --> m126
  m124 --> m126
  m125 --> m126
```

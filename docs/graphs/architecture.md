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
    m75["ITA.S3.IndividualYear"]
    m76["ITA.S39.CanadianSecurities"]
    m77["ITA.S50.BadDebtOrShare"]
    m78["ITA.S43.PartialDisposition"]
    m79["ITA.S74.CorporateAttribution"]
    m80["ITA.S123.CorporateRates"]
    m81["ITA.S129.RefundableTax"]
    m82["ITA.S15.ShareholderLoans"]
    m83["ITA.S89.GeneralRateIncomePool"]
    m84["ITA.S127_5.MinimumTax"]
    m85["ITA.S50.BadDebtPersonalUse"]
    m86["ITA.S54.Timeline"]
  end
  subgraph Lemmas["Layer 2: reusable lemmas"]
    m87["Lemmas.SuperficialLoss"]
    m88["Lemmas.SuspendedLoss"]
  end
  subgraph Transactions["Layer 3: transactions"]
    m89["Transactions.SpouseRepurchase"]
    m90["Transactions.SiblingAndLateRepurchase"]
    m91["Transactions.TfsaContribution"]
    m92["Transactions.HoldcoRepurchase"]
    m93["Transactions.Crystallization"]
    m94["Transactions.SaleThroughHoldco"]
    m95["Transactions.PostMortemPipeline"]
    m96["Transactions.EstateFreeze"]
    m97["Transactions.DonatingShares"]
    m98["Transactions.InvestmentIncomeIntegration"]
    m99["Transactions.EligibleDesignation"]
    m100["Transactions.CrystallizationMinimumTax"]
    m101["Transactions.DebtSwap"]
    m102["Transactions.AttendantCare"]
    m103["Transactions.PensionSplit"]
    m104["Transactions.SisterCompanyRepurchase"]
  end
  subgraph Blueprints["Blueprints"]
    m105["Blueprints.SuperficialLoss"]
    m106["Blueprints.SpouseRepurchase"]
    m107["Blueprints.SiblingAndLateRepurchase"]
    m108["Blueprints.TfsaContribution"]
    m109["Blueprints.HoldcoRepurchase"]
    m110["Blueprints.Crystallization"]
    m111["Blueprints.SaleThroughHoldco"]
    m112["Blueprints.PostMortemPipeline"]
    m113["Blueprints.EstateFreeze"]
    m114["Blueprints.DonatingShares"]
    m115["Blueprints.InvestmentIncomeIntegration"]
    m116["Blueprints.EligibleDesignation"]
    m117["Blueprints.CrystallizationMinimumTax"]
    m118["Blueprints.DebtSwap"]
    m119["Blueprints.AttendantCare"]
    m120["Blueprints.PensionSplit"]
    m121["Blueprints.SisterCompanyRepurchase"]
    m122["Blueprints.All"]
  end
  subgraph Examples["Examples"]
    m19["Examples.RuleX"]
    m20["Examples.RuleZ"]
    m21["Examples.ToySeries"]
    m22["Examples.RuleXStatute"]
  end
  subgraph Graphs["Graphs"]
    m123["Graphs.All"]
  end
  subgraph Root["Root"]
    m124["Canteen"]
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
  m43 --> m75
  m51 --> m75
  m56 --> m75
  m53 --> m75
  m68 --> m75
  m69 --> m75
  m70 --> m75
  m71 --> m75
  m72 --> m75
  m73 --> m75
  m74 --> m75
  m41 --> m76
  m41 --> m77
  m41 --> m78
  m54 --> m79
  m10 --> m79
  m4 --> m80
  m2 --> m80
  m80 --> m81
  m12 --> m82
  m10 --> m82
  m1 --> m82
  m2 --> m82
  m80 --> m83
  m10 --> m83
  m75 --> m84
  m12 --> m85
  m10 --> m85
  m2 --> m85
  m23 --> m86
  m23 --> m87
  m37 --> m88
  m24 --> m89
  m87 --> m89
  m27 --> m89
  m28 --> m89
  m24 --> m90
  m28 --> m90
  m87 --> m90
  m36 --> m91
  m28 --> m91
  m36 --> m92
  m27 --> m92
  m29 --> m92
  m50 --> m93
  m51 --> m93
  m54 --> m93
  m27 --> m93
  m55 --> m94
  m58 --> m94
  m46 --> m95
  m50 --> m95
  m54 --> m95
  m59 --> m96
  m79 --> m96
  m84 --> m97
  m75 --> m98
  m81 --> m98
  m75 --> m99
  m83 --> m99
  m84 --> m100
  m84 --> m101
  m27 --> m101
  m84 --> m102
  m84 --> m103
  m37 --> m104
  m29 --> m104
  m16 --> m105
  m87 --> m105
  m26 --> m105
  m27 --> m105
  m28 --> m105
  m31 --> m105
  m45 --> m105
  m46 --> m105
  m48 --> m105
  m50 --> m105
  m52 --> m105
  m57 --> m105
  m58 --> m105
  m59 --> m105
  m60 --> m105
  m61 --> m105
  m62 --> m105
  m63 --> m105
  m64 --> m105
  m65 --> m105
  m66 --> m105
  m76 --> m105
  m77 --> m105
  m78 --> m105
  m79 --> m105
  m81 --> m105
  m82 --> m105
  m83 --> m105
  m84 --> m105
  m85 --> m105
  m88 --> m105
  m16 --> m106
  m89 --> m106
  m25 --> m106
  m86 --> m106
  m42 --> m106
  m16 --> m107
  m17 --> m107
  m90 --> m107
  m86 --> m107
  m16 --> m108
  m17 --> m108
  m91 --> m108
  m86 --> m108
  m16 --> m109
  m92 --> m109
  m86 --> m109
  m16 --> m110
  m93 --> m110
  m16 --> m111
  m94 --> m111
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
  m105 --> m122
  m106 --> m122
  m107 --> m122
  m108 --> m122
  m109 --> m122
  m121 --> m122
  m110 --> m122
  m111 --> m122
  m112 --> m122
  m113 --> m122
  m114 --> m122
  m115 --> m122
  m116 --> m122
  m117 --> m122
  m118 --> m122
  m119 --> m122
  m120 --> m122
  m22 --> m123
  m21 --> m123
  m86 --> m123
  m26 --> m123
  m89 --> m123
  m90 --> m123
  m91 --> m123
  m92 --> m123
  m31 --> m123
  m85 --> m123
  m45 --> m123
  m46 --> m123
  m48 --> m123
  m52 --> m123
  m60 --> m123
  m62 --> m123
  m64 --> m123
  m82 --> m123
  m83 --> m123
  m101 --> m123
  m65 --> m123
  m76 --> m123
  m77 --> m123
  m104 --> m123
  m93 --> m123
  m94 --> m123
  m96 --> m123
  m18 --> m124
  m20 --> m124
  m122 --> m124
  m123 --> m124
```

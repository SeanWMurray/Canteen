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
    m74["ITA.S3.IndividualYear"]
    m75["ITA.S39.CanadianSecurities"]
    m76["ITA.S50.BadDebtOrShare"]
    m77["ITA.S43.PartialDisposition"]
    m78["ITA.S74.CorporateAttribution"]
    m79["ITA.S123.CorporateRates"]
    m80["ITA.S129.RefundableTax"]
    m81["ITA.S15.ShareholderLoans"]
    m82["ITA.S89.GeneralRateIncomePool"]
    m83["ITA.S127_5.MinimumTax"]
    m84["ITA.S50.BadDebtPersonalUse"]
    m85["ITA.S54.Timeline"]
  end
  subgraph Lemmas["Layer 2: reusable lemmas"]
    m86["Lemmas.SuperficialLoss"]
    m87["Lemmas.SuspendedLoss"]
  end
  subgraph Transactions["Layer 3: transactions"]
    m88["Transactions.SpouseRepurchase"]
    m89["Transactions.SiblingAndLateRepurchase"]
    m90["Transactions.TfsaContribution"]
    m91["Transactions.HoldcoRepurchase"]
    m92["Transactions.Crystallization"]
    m93["Transactions.SaleThroughHoldco"]
    m94["Transactions.PostMortemPipeline"]
    m95["Transactions.EstateFreeze"]
    m96["Transactions.DonatingShares"]
    m97["Transactions.InvestmentIncomeIntegration"]
    m98["Transactions.EligibleDesignation"]
    m99["Transactions.CrystallizationMinimumTax"]
    m100["Transactions.DebtSwap"]
    m101["Transactions.SisterCompanyRepurchase"]
  end
  subgraph Blueprints["Blueprints"]
    m102["Blueprints.SuperficialLoss"]
    m103["Blueprints.SpouseRepurchase"]
    m104["Blueprints.SiblingAndLateRepurchase"]
    m105["Blueprints.TfsaContribution"]
    m106["Blueprints.HoldcoRepurchase"]
    m107["Blueprints.Crystallization"]
    m108["Blueprints.SaleThroughHoldco"]
    m109["Blueprints.PostMortemPipeline"]
    m110["Blueprints.EstateFreeze"]
    m111["Blueprints.DonatingShares"]
    m112["Blueprints.InvestmentIncomeIntegration"]
    m113["Blueprints.EligibleDesignation"]
    m114["Blueprints.CrystallizationMinimumTax"]
    m115["Blueprints.DebtSwap"]
    m116["Blueprints.SisterCompanyRepurchase"]
    m117["Blueprints.All"]
  end
  subgraph Examples["Examples"]
    m19["Examples.RuleX"]
    m20["Examples.RuleZ"]
    m21["Examples.ToySeries"]
    m22["Examples.RuleXStatute"]
  end
  subgraph Graphs["Graphs"]
    m118["Graphs.All"]
  end
  subgraph Root["Root"]
    m119["Canteen"]
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
  m43 --> m74
  m51 --> m74
  m56 --> m74
  m53 --> m74
  m68 --> m74
  m69 --> m74
  m70 --> m74
  m71 --> m74
  m72 --> m74
  m73 --> m74
  m41 --> m75
  m41 --> m76
  m41 --> m77
  m54 --> m78
  m10 --> m78
  m4 --> m79
  m2 --> m79
  m79 --> m80
  m12 --> m81
  m10 --> m81
  m1 --> m81
  m2 --> m81
  m79 --> m82
  m10 --> m82
  m74 --> m83
  m12 --> m84
  m10 --> m84
  m2 --> m84
  m23 --> m85
  m23 --> m86
  m37 --> m87
  m24 --> m88
  m86 --> m88
  m27 --> m88
  m28 --> m88
  m24 --> m89
  m28 --> m89
  m86 --> m89
  m36 --> m90
  m28 --> m90
  m36 --> m91
  m27 --> m91
  m29 --> m91
  m50 --> m92
  m51 --> m92
  m54 --> m92
  m27 --> m92
  m55 --> m93
  m58 --> m93
  m46 --> m94
  m50 --> m94
  m54 --> m94
  m59 --> m95
  m78 --> m95
  m83 --> m96
  m74 --> m97
  m80 --> m97
  m74 --> m98
  m82 --> m98
  m83 --> m99
  m83 --> m100
  m27 --> m100
  m37 --> m101
  m29 --> m101
  m16 --> m102
  m86 --> m102
  m26 --> m102
  m27 --> m102
  m28 --> m102
  m31 --> m102
  m45 --> m102
  m46 --> m102
  m48 --> m102
  m50 --> m102
  m52 --> m102
  m57 --> m102
  m58 --> m102
  m59 --> m102
  m60 --> m102
  m61 --> m102
  m62 --> m102
  m63 --> m102
  m64 --> m102
  m65 --> m102
  m66 --> m102
  m75 --> m102
  m76 --> m102
  m77 --> m102
  m78 --> m102
  m80 --> m102
  m81 --> m102
  m82 --> m102
  m83 --> m102
  m84 --> m102
  m87 --> m102
  m16 --> m103
  m88 --> m103
  m25 --> m103
  m85 --> m103
  m42 --> m103
  m16 --> m104
  m17 --> m104
  m89 --> m104
  m85 --> m104
  m16 --> m105
  m17 --> m105
  m90 --> m105
  m85 --> m105
  m16 --> m106
  m91 --> m106
  m85 --> m106
  m16 --> m107
  m92 --> m107
  m16 --> m108
  m93 --> m108
  m16 --> m109
  m94 --> m109
  m16 --> m110
  m95 --> m110
  m16 --> m111
  m96 --> m111
  m16 --> m112
  m97 --> m112
  m16 --> m113
  m98 --> m113
  m16 --> m114
  m99 --> m114
  m16 --> m115
  m100 --> m115
  m16 --> m116
  m101 --> m116
  m102 --> m117
  m103 --> m117
  m104 --> m117
  m105 --> m117
  m106 --> m117
  m116 --> m117
  m107 --> m117
  m108 --> m117
  m109 --> m117
  m110 --> m117
  m111 --> m117
  m112 --> m117
  m113 --> m117
  m114 --> m117
  m115 --> m117
  m22 --> m118
  m21 --> m118
  m85 --> m118
  m26 --> m118
  m88 --> m118
  m89 --> m118
  m90 --> m118
  m91 --> m118
  m31 --> m118
  m84 --> m118
  m45 --> m118
  m46 --> m118
  m48 --> m118
  m52 --> m118
  m60 --> m118
  m62 --> m118
  m64 --> m118
  m81 --> m118
  m82 --> m118
  m100 --> m118
  m65 --> m118
  m75 --> m118
  m76 --> m118
  m101 --> m118
  m92 --> m118
  m93 --> m118
  m95 --> m118
  m18 --> m119
  m20 --> m119
  m117 --> m119
  m118 --> m119
```

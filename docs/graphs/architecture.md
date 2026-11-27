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
    m73["ITA.S3.IndividualYear"]
    m74["ITA.S39.CanadianSecurities"]
    m75["ITA.S50.BadDebtOrShare"]
    m76["ITA.S43.PartialDisposition"]
    m77["ITA.S74.CorporateAttribution"]
    m78["ITA.S123.CorporateRates"]
    m79["ITA.S129.RefundableTax"]
    m80["ITA.S15.ShareholderLoans"]
    m81["ITA.S89.GeneralRateIncomePool"]
    m82["ITA.S127_5.MinimumTax"]
    m83["ITA.S50.BadDebtPersonalUse"]
    m84["ITA.S54.Timeline"]
  end
  subgraph Lemmas["Layer 2: reusable lemmas"]
    m85["Lemmas.SuperficialLoss"]
    m86["Lemmas.SuspendedLoss"]
  end
  subgraph Transactions["Layer 3: transactions"]
    m87["Transactions.SpouseRepurchase"]
    m88["Transactions.SiblingAndLateRepurchase"]
    m89["Transactions.TfsaContribution"]
    m90["Transactions.HoldcoRepurchase"]
    m91["Transactions.Crystallization"]
    m92["Transactions.SaleThroughHoldco"]
    m93["Transactions.PostMortemPipeline"]
    m94["Transactions.EstateFreeze"]
    m95["Transactions.DonatingShares"]
    m96["Transactions.InvestmentIncomeIntegration"]
    m97["Transactions.EligibleDesignation"]
    m98["Transactions.CrystallizationMinimumTax"]
    m99["Transactions.DebtSwap"]
    m100["Transactions.SisterCompanyRepurchase"]
  end
  subgraph Blueprints["Blueprints"]
    m101["Blueprints.SuperficialLoss"]
    m102["Blueprints.SpouseRepurchase"]
    m103["Blueprints.SiblingAndLateRepurchase"]
    m104["Blueprints.TfsaContribution"]
    m105["Blueprints.HoldcoRepurchase"]
    m106["Blueprints.Crystallization"]
    m107["Blueprints.SaleThroughHoldco"]
    m108["Blueprints.PostMortemPipeline"]
    m109["Blueprints.EstateFreeze"]
    m110["Blueprints.DonatingShares"]
    m111["Blueprints.InvestmentIncomeIntegration"]
    m112["Blueprints.EligibleDesignation"]
    m113["Blueprints.CrystallizationMinimumTax"]
    m114["Blueprints.DebtSwap"]
    m115["Blueprints.SisterCompanyRepurchase"]
    m116["Blueprints.All"]
  end
  subgraph Examples["Examples"]
    m19["Examples.RuleX"]
    m20["Examples.RuleZ"]
    m21["Examples.ToySeries"]
    m22["Examples.RuleXStatute"]
  end
  subgraph Graphs["Graphs"]
    m117["Graphs.All"]
  end
  subgraph Root["Root"]
    m118["Canteen"]
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
  m43 --> m73
  m51 --> m73
  m56 --> m73
  m53 --> m73
  m68 --> m73
  m69 --> m73
  m70 --> m73
  m71 --> m73
  m72 --> m73
  m41 --> m74
  m41 --> m75
  m41 --> m76
  m54 --> m77
  m10 --> m77
  m4 --> m78
  m2 --> m78
  m78 --> m79
  m12 --> m80
  m10 --> m80
  m1 --> m80
  m2 --> m80
  m78 --> m81
  m10 --> m81
  m73 --> m82
  m12 --> m83
  m10 --> m83
  m2 --> m83
  m23 --> m84
  m23 --> m85
  m37 --> m86
  m24 --> m87
  m85 --> m87
  m27 --> m87
  m28 --> m87
  m24 --> m88
  m28 --> m88
  m85 --> m88
  m36 --> m89
  m28 --> m89
  m36 --> m90
  m27 --> m90
  m29 --> m90
  m50 --> m91
  m51 --> m91
  m54 --> m91
  m27 --> m91
  m55 --> m92
  m58 --> m92
  m46 --> m93
  m50 --> m93
  m54 --> m93
  m59 --> m94
  m77 --> m94
  m82 --> m95
  m73 --> m96
  m79 --> m96
  m73 --> m97
  m81 --> m97
  m82 --> m98
  m82 --> m99
  m27 --> m99
  m37 --> m100
  m29 --> m100
  m16 --> m101
  m85 --> m101
  m26 --> m101
  m27 --> m101
  m28 --> m101
  m31 --> m101
  m45 --> m101
  m46 --> m101
  m48 --> m101
  m50 --> m101
  m52 --> m101
  m57 --> m101
  m58 --> m101
  m59 --> m101
  m60 --> m101
  m61 --> m101
  m62 --> m101
  m63 --> m101
  m64 --> m101
  m65 --> m101
  m66 --> m101
  m74 --> m101
  m75 --> m101
  m76 --> m101
  m77 --> m101
  m79 --> m101
  m80 --> m101
  m81 --> m101
  m82 --> m101
  m83 --> m101
  m86 --> m101
  m16 --> m102
  m87 --> m102
  m25 --> m102
  m84 --> m102
  m42 --> m102
  m16 --> m103
  m17 --> m103
  m88 --> m103
  m84 --> m103
  m16 --> m104
  m17 --> m104
  m89 --> m104
  m84 --> m104
  m16 --> m105
  m90 --> m105
  m84 --> m105
  m16 --> m106
  m91 --> m106
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
  m101 --> m116
  m102 --> m116
  m103 --> m116
  m104 --> m116
  m105 --> m116
  m115 --> m116
  m106 --> m116
  m107 --> m116
  m108 --> m116
  m109 --> m116
  m110 --> m116
  m111 --> m116
  m112 --> m116
  m113 --> m116
  m114 --> m116
  m22 --> m117
  m21 --> m117
  m84 --> m117
  m26 --> m117
  m87 --> m117
  m88 --> m117
  m89 --> m117
  m90 --> m117
  m31 --> m117
  m83 --> m117
  m45 --> m117
  m46 --> m117
  m48 --> m117
  m52 --> m117
  m60 --> m117
  m62 --> m117
  m64 --> m117
  m80 --> m117
  m81 --> m117
  m99 --> m117
  m65 --> m117
  m74 --> m117
  m75 --> m117
  m100 --> m117
  m91 --> m117
  m92 --> m117
  m94 --> m117
  m18 --> m118
  m20 --> m118
  m116 --> m118
  m117 --> m118
```

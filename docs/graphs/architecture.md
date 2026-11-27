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
    m101["Transactions.AttendantCare"]
    m102["Transactions.SisterCompanyRepurchase"]
  end
  subgraph Blueprints["Blueprints"]
    m103["Blueprints.SuperficialLoss"]
    m104["Blueprints.SpouseRepurchase"]
    m105["Blueprints.SiblingAndLateRepurchase"]
    m106["Blueprints.TfsaContribution"]
    m107["Blueprints.HoldcoRepurchase"]
    m108["Blueprints.Crystallization"]
    m109["Blueprints.SaleThroughHoldco"]
    m110["Blueprints.PostMortemPipeline"]
    m111["Blueprints.EstateFreeze"]
    m112["Blueprints.DonatingShares"]
    m113["Blueprints.InvestmentIncomeIntegration"]
    m114["Blueprints.EligibleDesignation"]
    m115["Blueprints.CrystallizationMinimumTax"]
    m116["Blueprints.DebtSwap"]
    m117["Blueprints.AttendantCare"]
    m118["Blueprints.SisterCompanyRepurchase"]
    m119["Blueprints.All"]
  end
  subgraph Examples["Examples"]
    m19["Examples.RuleX"]
    m20["Examples.RuleZ"]
    m21["Examples.ToySeries"]
    m22["Examples.RuleXStatute"]
  end
  subgraph Graphs["Graphs"]
    m120["Graphs.All"]
  end
  subgraph Root["Root"]
    m121["Canteen"]
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
  m83 --> m101
  m37 --> m102
  m29 --> m102
  m16 --> m103
  m86 --> m103
  m26 --> m103
  m27 --> m103
  m28 --> m103
  m31 --> m103
  m45 --> m103
  m46 --> m103
  m48 --> m103
  m50 --> m103
  m52 --> m103
  m57 --> m103
  m58 --> m103
  m59 --> m103
  m60 --> m103
  m61 --> m103
  m62 --> m103
  m63 --> m103
  m64 --> m103
  m65 --> m103
  m66 --> m103
  m75 --> m103
  m76 --> m103
  m77 --> m103
  m78 --> m103
  m80 --> m103
  m81 --> m103
  m82 --> m103
  m83 --> m103
  m84 --> m103
  m87 --> m103
  m16 --> m104
  m88 --> m104
  m25 --> m104
  m85 --> m104
  m42 --> m104
  m16 --> m105
  m17 --> m105
  m89 --> m105
  m85 --> m105
  m16 --> m106
  m17 --> m106
  m90 --> m106
  m85 --> m106
  m16 --> m107
  m91 --> m107
  m85 --> m107
  m16 --> m108
  m92 --> m108
  m16 --> m109
  m93 --> m109
  m16 --> m110
  m94 --> m110
  m16 --> m111
  m95 --> m111
  m16 --> m112
  m96 --> m112
  m16 --> m113
  m97 --> m113
  m16 --> m114
  m98 --> m114
  m16 --> m115
  m99 --> m115
  m16 --> m116
  m100 --> m116
  m16 --> m117
  m101 --> m117
  m16 --> m118
  m102 --> m118
  m103 --> m119
  m104 --> m119
  m105 --> m119
  m106 --> m119
  m107 --> m119
  m118 --> m119
  m108 --> m119
  m109 --> m119
  m110 --> m119
  m111 --> m119
  m112 --> m119
  m113 --> m119
  m114 --> m119
  m115 --> m119
  m116 --> m119
  m117 --> m119
  m22 --> m120
  m21 --> m120
  m85 --> m120
  m26 --> m120
  m88 --> m120
  m89 --> m120
  m90 --> m120
  m91 --> m120
  m31 --> m120
  m84 --> m120
  m45 --> m120
  m46 --> m120
  m48 --> m120
  m52 --> m120
  m60 --> m120
  m62 --> m120
  m64 --> m120
  m81 --> m120
  m82 --> m120
  m100 --> m120
  m65 --> m120
  m75 --> m120
  m76 --> m120
  m102 --> m120
  m92 --> m120
  m93 --> m120
  m95 --> m120
  m18 --> m121
  m20 --> m121
  m119 --> m121
  m120 --> m121
```

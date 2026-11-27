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
    m71["ITA.S3.IndividualYear"]
    m72["ITA.S39.CanadianSecurities"]
    m73["ITA.S50.BadDebtOrShare"]
    m74["ITA.S43.PartialDisposition"]
    m75["ITA.S74.CorporateAttribution"]
    m76["ITA.S123.CorporateRates"]
    m77["ITA.S129.RefundableTax"]
    m78["ITA.S15.ShareholderLoans"]
    m79["ITA.S89.GeneralRateIncomePool"]
    m80["ITA.S50.BadDebtPersonalUse"]
    m81["ITA.S54.Timeline"]
  end
  subgraph Lemmas["Layer 2: reusable lemmas"]
    m82["Lemmas.SuperficialLoss"]
    m83["Lemmas.SuspendedLoss"]
  end
  subgraph Transactions["Layer 3: transactions"]
    m84["Transactions.SpouseRepurchase"]
    m85["Transactions.SiblingAndLateRepurchase"]
    m86["Transactions.TfsaContribution"]
    m87["Transactions.HoldcoRepurchase"]
    m88["Transactions.Crystallization"]
    m89["Transactions.SaleThroughHoldco"]
    m90["Transactions.PostMortemPipeline"]
    m91["Transactions.EstateFreeze"]
    m92["Transactions.DonatingShares"]
    m93["Transactions.InvestmentIncomeIntegration"]
    m94["Transactions.SisterCompanyRepurchase"]
  end
  subgraph Blueprints["Blueprints"]
    m95["Blueprints.SuperficialLoss"]
    m96["Blueprints.SpouseRepurchase"]
    m97["Blueprints.SiblingAndLateRepurchase"]
    m98["Blueprints.TfsaContribution"]
    m99["Blueprints.HoldcoRepurchase"]
    m100["Blueprints.Crystallization"]
    m101["Blueprints.SaleThroughHoldco"]
    m102["Blueprints.PostMortemPipeline"]
    m103["Blueprints.EstateFreeze"]
    m104["Blueprints.DonatingShares"]
    m105["Blueprints.InvestmentIncomeIntegration"]
    m106["Blueprints.SisterCompanyRepurchase"]
    m107["Blueprints.All"]
  end
  subgraph Examples["Examples"]
    m19["Examples.RuleX"]
    m20["Examples.RuleZ"]
    m21["Examples.ToySeries"]
    m22["Examples.RuleXStatute"]
  end
  subgraph Graphs["Graphs"]
    m108["Graphs.All"]
  end
  subgraph Root["Root"]
    m109["Canteen"]
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
  m43 --> m71
  m51 --> m71
  m56 --> m71
  m53 --> m71
  m68 --> m71
  m69 --> m71
  m70 --> m71
  m41 --> m72
  m41 --> m73
  m41 --> m74
  m54 --> m75
  m10 --> m75
  m4 --> m76
  m2 --> m76
  m76 --> m77
  m12 --> m78
  m10 --> m78
  m1 --> m78
  m2 --> m78
  m76 --> m79
  m10 --> m79
  m12 --> m80
  m10 --> m80
  m2 --> m80
  m23 --> m81
  m23 --> m82
  m37 --> m83
  m24 --> m84
  m82 --> m84
  m27 --> m84
  m28 --> m84
  m24 --> m85
  m28 --> m85
  m82 --> m85
  m36 --> m86
  m28 --> m86
  m36 --> m87
  m27 --> m87
  m29 --> m87
  m50 --> m88
  m51 --> m88
  m54 --> m88
  m27 --> m88
  m55 --> m89
  m58 --> m89
  m46 --> m90
  m50 --> m90
  m54 --> m90
  m59 --> m91
  m75 --> m91
  m71 --> m92
  m71 --> m93
  m77 --> m93
  m37 --> m94
  m29 --> m94
  m16 --> m95
  m82 --> m95
  m26 --> m95
  m27 --> m95
  m28 --> m95
  m31 --> m95
  m45 --> m95
  m46 --> m95
  m48 --> m95
  m50 --> m95
  m52 --> m95
  m57 --> m95
  m58 --> m95
  m59 --> m95
  m60 --> m95
  m61 --> m95
  m62 --> m95
  m63 --> m95
  m64 --> m95
  m65 --> m95
  m66 --> m95
  m71 --> m95
  m72 --> m95
  m73 --> m95
  m74 --> m95
  m75 --> m95
  m77 --> m95
  m78 --> m95
  m79 --> m95
  m80 --> m95
  m83 --> m95
  m16 --> m96
  m84 --> m96
  m25 --> m96
  m81 --> m96
  m42 --> m96
  m16 --> m97
  m17 --> m97
  m85 --> m97
  m81 --> m97
  m16 --> m98
  m17 --> m98
  m86 --> m98
  m81 --> m98
  m16 --> m99
  m87 --> m99
  m81 --> m99
  m16 --> m100
  m88 --> m100
  m16 --> m101
  m89 --> m101
  m16 --> m102
  m90 --> m102
  m16 --> m103
  m91 --> m103
  m16 --> m104
  m92 --> m104
  m16 --> m105
  m93 --> m105
  m16 --> m106
  m94 --> m106
  m95 --> m107
  m96 --> m107
  m97 --> m107
  m98 --> m107
  m99 --> m107
  m106 --> m107
  m100 --> m107
  m101 --> m107
  m102 --> m107
  m103 --> m107
  m104 --> m107
  m105 --> m107
  m22 --> m108
  m21 --> m108
  m81 --> m108
  m26 --> m108
  m84 --> m108
  m85 --> m108
  m86 --> m108
  m87 --> m108
  m31 --> m108
  m80 --> m108
  m45 --> m108
  m46 --> m108
  m48 --> m108
  m52 --> m108
  m53 --> m108
  m60 --> m108
  m62 --> m108
  m64 --> m108
  m78 --> m108
  m79 --> m108
  m65 --> m108
  m72 --> m108
  m73 --> m108
  m94 --> m108
  m88 --> m108
  m89 --> m108
  m91 --> m108
  m18 --> m109
  m20 --> m109
  m107 --> m109
  m108 --> m109
```

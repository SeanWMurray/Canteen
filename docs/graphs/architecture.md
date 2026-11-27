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
    m77["ITA.S50.BadDebtPersonalUse"]
    m78["ITA.S54.Timeline"]
  end
  subgraph Lemmas["Layer 2: reusable lemmas"]
    m79["Lemmas.SuperficialLoss"]
    m80["Lemmas.SuspendedLoss"]
  end
  subgraph Transactions["Layer 3: transactions"]
    m81["Transactions.SpouseRepurchase"]
    m82["Transactions.SiblingAndLateRepurchase"]
    m83["Transactions.TfsaContribution"]
    m84["Transactions.HoldcoRepurchase"]
    m85["Transactions.Crystallization"]
    m86["Transactions.SaleThroughHoldco"]
    m87["Transactions.PostMortemPipeline"]
    m88["Transactions.EstateFreeze"]
    m89["Transactions.DonatingShares"]
    m90["Transactions.SisterCompanyRepurchase"]
  end
  subgraph Blueprints["Blueprints"]
    m91["Blueprints.SuperficialLoss"]
    m92["Blueprints.SpouseRepurchase"]
    m93["Blueprints.SiblingAndLateRepurchase"]
    m94["Blueprints.TfsaContribution"]
    m95["Blueprints.HoldcoRepurchase"]
    m96["Blueprints.Crystallization"]
    m97["Blueprints.SaleThroughHoldco"]
    m98["Blueprints.PostMortemPipeline"]
    m99["Blueprints.EstateFreeze"]
    m100["Blueprints.DonatingShares"]
    m101["Blueprints.SisterCompanyRepurchase"]
    m102["Blueprints.All"]
  end
  subgraph Examples["Examples"]
    m19["Examples.RuleX"]
    m20["Examples.RuleZ"]
    m21["Examples.ToySeries"]
    m22["Examples.RuleXStatute"]
  end
  subgraph Graphs["Graphs"]
    m103["Graphs.All"]
  end
  subgraph Root["Root"]
    m104["Canteen"]
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
  m12 --> m77
  m10 --> m77
  m2 --> m77
  m23 --> m78
  m23 --> m79
  m37 --> m80
  m24 --> m81
  m79 --> m81
  m27 --> m81
  m28 --> m81
  m24 --> m82
  m28 --> m82
  m79 --> m82
  m36 --> m83
  m28 --> m83
  m36 --> m84
  m27 --> m84
  m29 --> m84
  m50 --> m85
  m51 --> m85
  m54 --> m85
  m27 --> m85
  m55 --> m86
  m58 --> m86
  m46 --> m87
  m50 --> m87
  m54 --> m87
  m59 --> m88
  m75 --> m88
  m71 --> m89
  m37 --> m90
  m29 --> m90
  m16 --> m91
  m79 --> m91
  m26 --> m91
  m27 --> m91
  m28 --> m91
  m31 --> m91
  m45 --> m91
  m46 --> m91
  m48 --> m91
  m50 --> m91
  m52 --> m91
  m57 --> m91
  m58 --> m91
  m59 --> m91
  m60 --> m91
  m61 --> m91
  m62 --> m91
  m63 --> m91
  m64 --> m91
  m65 --> m91
  m66 --> m91
  m71 --> m91
  m72 --> m91
  m73 --> m91
  m74 --> m91
  m75 --> m91
  m76 --> m91
  m77 --> m91
  m80 --> m91
  m16 --> m92
  m81 --> m92
  m25 --> m92
  m78 --> m92
  m42 --> m92
  m16 --> m93
  m17 --> m93
  m82 --> m93
  m78 --> m93
  m16 --> m94
  m17 --> m94
  m83 --> m94
  m78 --> m94
  m16 --> m95
  m84 --> m95
  m78 --> m95
  m16 --> m96
  m85 --> m96
  m16 --> m97
  m86 --> m97
  m16 --> m98
  m87 --> m98
  m16 --> m99
  m88 --> m99
  m16 --> m100
  m89 --> m100
  m16 --> m101
  m90 --> m101
  m91 --> m102
  m92 --> m102
  m93 --> m102
  m94 --> m102
  m95 --> m102
  m101 --> m102
  m96 --> m102
  m97 --> m102
  m98 --> m102
  m99 --> m102
  m100 --> m102
  m22 --> m103
  m21 --> m103
  m78 --> m103
  m26 --> m103
  m81 --> m103
  m82 --> m103
  m83 --> m103
  m84 --> m103
  m31 --> m103
  m77 --> m103
  m45 --> m103
  m46 --> m103
  m48 --> m103
  m52 --> m103
  m53 --> m103
  m60 --> m103
  m62 --> m103
  m64 --> m103
  m65 --> m103
  m72 --> m103
  m73 --> m103
  m90 --> m103
  m85 --> m103
  m86 --> m103
  m88 --> m103
  m18 --> m104
  m20 --> m104
  m102 --> m104
  m103 --> m104
```

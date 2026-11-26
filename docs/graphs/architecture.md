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
    m76["ITA.S50.BadDebtPersonalUse"]
    m77["ITA.S54.Timeline"]
  end
  subgraph Lemmas["Layer 2: reusable lemmas"]
    m78["Lemmas.SuperficialLoss"]
    m79["Lemmas.SuspendedLoss"]
  end
  subgraph Transactions["Layer 3: transactions"]
    m80["Transactions.SpouseRepurchase"]
    m81["Transactions.SiblingAndLateRepurchase"]
    m82["Transactions.TfsaContribution"]
    m83["Transactions.HoldcoRepurchase"]
    m84["Transactions.Crystallization"]
    m85["Transactions.SaleThroughHoldco"]
    m86["Transactions.PostMortemPipeline"]
    m87["Transactions.EstateFreeze"]
    m88["Transactions.DonatingShares"]
    m89["Transactions.SisterCompanyRepurchase"]
  end
  subgraph Blueprints["Blueprints"]
    m90["Blueprints.SuperficialLoss"]
    m91["Blueprints.SpouseRepurchase"]
    m92["Blueprints.SiblingAndLateRepurchase"]
    m93["Blueprints.TfsaContribution"]
    m94["Blueprints.HoldcoRepurchase"]
    m95["Blueprints.Crystallization"]
    m96["Blueprints.SaleThroughHoldco"]
    m97["Blueprints.PostMortemPipeline"]
    m98["Blueprints.EstateFreeze"]
    m99["Blueprints.DonatingShares"]
    m100["Blueprints.SisterCompanyRepurchase"]
    m101["Blueprints.All"]
  end
  subgraph Examples["Examples"]
    m19["Examples.RuleX"]
    m20["Examples.RuleZ"]
    m21["Examples.ToySeries"]
    m22["Examples.RuleXStatute"]
  end
  subgraph Graphs["Graphs"]
    m102["Graphs.All"]
  end
  subgraph Root["Root"]
    m103["Canteen"]
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
  m12 --> m76
  m10 --> m76
  m2 --> m76
  m23 --> m77
  m23 --> m78
  m37 --> m79
  m24 --> m80
  m78 --> m80
  m27 --> m80
  m28 --> m80
  m24 --> m81
  m28 --> m81
  m78 --> m81
  m36 --> m82
  m28 --> m82
  m36 --> m83
  m27 --> m83
  m29 --> m83
  m50 --> m84
  m51 --> m84
  m54 --> m84
  m27 --> m84
  m55 --> m85
  m58 --> m85
  m46 --> m86
  m50 --> m86
  m54 --> m86
  m59 --> m87
  m75 --> m87
  m71 --> m88
  m37 --> m89
  m29 --> m89
  m16 --> m90
  m78 --> m90
  m26 --> m90
  m27 --> m90
  m28 --> m90
  m31 --> m90
  m45 --> m90
  m46 --> m90
  m48 --> m90
  m50 --> m90
  m52 --> m90
  m57 --> m90
  m58 --> m90
  m59 --> m90
  m60 --> m90
  m61 --> m90
  m62 --> m90
  m63 --> m90
  m64 --> m90
  m65 --> m90
  m66 --> m90
  m71 --> m90
  m72 --> m90
  m73 --> m90
  m74 --> m90
  m75 --> m90
  m76 --> m90
  m79 --> m90
  m16 --> m91
  m80 --> m91
  m25 --> m91
  m77 --> m91
  m42 --> m91
  m16 --> m92
  m17 --> m92
  m81 --> m92
  m77 --> m92
  m16 --> m93
  m17 --> m93
  m82 --> m93
  m77 --> m93
  m16 --> m94
  m83 --> m94
  m77 --> m94
  m16 --> m95
  m84 --> m95
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
  m90 --> m101
  m91 --> m101
  m92 --> m101
  m93 --> m101
  m94 --> m101
  m100 --> m101
  m95 --> m101
  m96 --> m101
  m97 --> m101
  m98 --> m101
  m99 --> m101
  m22 --> m102
  m21 --> m102
  m77 --> m102
  m26 --> m102
  m80 --> m102
  m81 --> m102
  m82 --> m102
  m83 --> m102
  m31 --> m102
  m76 --> m102
  m45 --> m102
  m46 --> m102
  m48 --> m102
  m52 --> m102
  m53 --> m102
  m60 --> m102
  m62 --> m102
  m64 --> m102
  m65 --> m102
  m72 --> m102
  m73 --> m102
  m89 --> m102
  m84 --> m102
  m85 --> m102
  m87 --> m102
  m18 --> m103
  m20 --> m103
  m101 --> m103
  m102 --> m103
```

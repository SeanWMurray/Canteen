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
    m78["ITA.S50.BadDebtPersonalUse"]
    m79["ITA.S54.Timeline"]
  end
  subgraph Lemmas["Layer 2: reusable lemmas"]
    m80["Lemmas.SuperficialLoss"]
    m81["Lemmas.SuspendedLoss"]
  end
  subgraph Transactions["Layer 3: transactions"]
    m82["Transactions.SpouseRepurchase"]
    m83["Transactions.SiblingAndLateRepurchase"]
    m84["Transactions.TfsaContribution"]
    m85["Transactions.HoldcoRepurchase"]
    m86["Transactions.Crystallization"]
    m87["Transactions.SaleThroughHoldco"]
    m88["Transactions.PostMortemPipeline"]
    m89["Transactions.EstateFreeze"]
    m90["Transactions.DonatingShares"]
    m91["Transactions.SisterCompanyRepurchase"]
  end
  subgraph Blueprints["Blueprints"]
    m92["Blueprints.SuperficialLoss"]
    m93["Blueprints.SpouseRepurchase"]
    m94["Blueprints.SiblingAndLateRepurchase"]
    m95["Blueprints.TfsaContribution"]
    m96["Blueprints.HoldcoRepurchase"]
    m97["Blueprints.Crystallization"]
    m98["Blueprints.SaleThroughHoldco"]
    m99["Blueprints.PostMortemPipeline"]
    m100["Blueprints.EstateFreeze"]
    m101["Blueprints.DonatingShares"]
    m102["Blueprints.SisterCompanyRepurchase"]
    m103["Blueprints.All"]
  end
  subgraph Examples["Examples"]
    m19["Examples.RuleX"]
    m20["Examples.RuleZ"]
    m21["Examples.ToySeries"]
    m22["Examples.RuleXStatute"]
  end
  subgraph Graphs["Graphs"]
    m104["Graphs.All"]
  end
  subgraph Root["Root"]
    m105["Canteen"]
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
  m2 --> m78
  m23 --> m79
  m23 --> m80
  m37 --> m81
  m24 --> m82
  m80 --> m82
  m27 --> m82
  m28 --> m82
  m24 --> m83
  m28 --> m83
  m80 --> m83
  m36 --> m84
  m28 --> m84
  m36 --> m85
  m27 --> m85
  m29 --> m85
  m50 --> m86
  m51 --> m86
  m54 --> m86
  m27 --> m86
  m55 --> m87
  m58 --> m87
  m46 --> m88
  m50 --> m88
  m54 --> m88
  m59 --> m89
  m75 --> m89
  m71 --> m90
  m37 --> m91
  m29 --> m91
  m16 --> m92
  m80 --> m92
  m26 --> m92
  m27 --> m92
  m28 --> m92
  m31 --> m92
  m45 --> m92
  m46 --> m92
  m48 --> m92
  m50 --> m92
  m52 --> m92
  m57 --> m92
  m58 --> m92
  m59 --> m92
  m60 --> m92
  m61 --> m92
  m62 --> m92
  m63 --> m92
  m64 --> m92
  m65 --> m92
  m66 --> m92
  m71 --> m92
  m72 --> m92
  m73 --> m92
  m74 --> m92
  m75 --> m92
  m77 --> m92
  m78 --> m92
  m81 --> m92
  m16 --> m93
  m82 --> m93
  m25 --> m93
  m79 --> m93
  m42 --> m93
  m16 --> m94
  m17 --> m94
  m83 --> m94
  m79 --> m94
  m16 --> m95
  m17 --> m95
  m84 --> m95
  m79 --> m95
  m16 --> m96
  m85 --> m96
  m79 --> m96
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
  m16 --> m102
  m91 --> m102
  m92 --> m103
  m93 --> m103
  m94 --> m103
  m95 --> m103
  m96 --> m103
  m102 --> m103
  m97 --> m103
  m98 --> m103
  m99 --> m103
  m100 --> m103
  m101 --> m103
  m22 --> m104
  m21 --> m104
  m79 --> m104
  m26 --> m104
  m82 --> m104
  m83 --> m104
  m84 --> m104
  m85 --> m104
  m31 --> m104
  m78 --> m104
  m45 --> m104
  m46 --> m104
  m48 --> m104
  m52 --> m104
  m53 --> m104
  m60 --> m104
  m62 --> m104
  m64 --> m104
  m65 --> m104
  m72 --> m104
  m73 --> m104
  m91 --> m104
  m86 --> m104
  m87 --> m104
  m89 --> m104
  m18 --> m105
  m20 --> m105
  m103 --> m105
  m104 --> m105
```

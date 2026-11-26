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
    m62["ITA.S50.BadDebtPersonalUse"]
    m63["ITA.S54.Timeline"]
  end
  subgraph Lemmas["Layer 2: reusable lemmas"]
    m64["Lemmas.SuperficialLoss"]
    m65["Lemmas.SuspendedLoss"]
  end
  subgraph Transactions["Layer 3: transactions"]
    m66["Transactions.SpouseRepurchase"]
    m67["Transactions.SiblingAndLateRepurchase"]
    m68["Transactions.TfsaContribution"]
    m69["Transactions.HoldcoRepurchase"]
    m70["Transactions.Crystallization"]
    m71["Transactions.SaleThroughHoldco"]
    m72["Transactions.SisterCompanyRepurchase"]
  end
  subgraph Blueprints["Blueprints"]
    m73["Blueprints.SuperficialLoss"]
    m74["Blueprints.SpouseRepurchase"]
    m75["Blueprints.SiblingAndLateRepurchase"]
    m76["Blueprints.TfsaContribution"]
    m77["Blueprints.HoldcoRepurchase"]
    m78["Blueprints.Crystallization"]
    m79["Blueprints.SaleThroughHoldco"]
    m80["Blueprints.SisterCompanyRepurchase"]
    m81["Blueprints.All"]
  end
  subgraph Examples["Examples"]
    m19["Examples.RuleX"]
    m20["Examples.RuleZ"]
    m21["Examples.ToySeries"]
    m22["Examples.RuleXStatute"]
  end
  subgraph Graphs["Graphs"]
    m82["Graphs.All"]
  end
  subgraph Root["Root"]
    m83["Canteen"]
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
  m10 --> m62
  m2 --> m62
  m23 --> m63
  m23 --> m64
  m37 --> m65
  m24 --> m66
  m64 --> m66
  m27 --> m66
  m28 --> m66
  m24 --> m67
  m28 --> m67
  m64 --> m67
  m36 --> m68
  m28 --> m68
  m36 --> m69
  m27 --> m69
  m29 --> m69
  m50 --> m70
  m51 --> m70
  m54 --> m70
  m27 --> m70
  m55 --> m71
  m58 --> m71
  m37 --> m72
  m29 --> m72
  m16 --> m73
  m64 --> m73
  m26 --> m73
  m27 --> m73
  m28 --> m73
  m31 --> m73
  m43 --> m73
  m45 --> m73
  m46 --> m73
  m48 --> m73
  m50 --> m73
  m51 --> m73
  m52 --> m73
  m53 --> m73
  m56 --> m73
  m57 --> m73
  m58 --> m73
  m59 --> m73
  m60 --> m73
  m61 --> m73
  m62 --> m73
  m65 --> m73
  m16 --> m74
  m66 --> m74
  m25 --> m74
  m63 --> m74
  m42 --> m74
  m16 --> m75
  m17 --> m75
  m67 --> m75
  m63 --> m75
  m16 --> m76
  m17 --> m76
  m68 --> m76
  m63 --> m76
  m16 --> m77
  m69 --> m77
  m63 --> m77
  m16 --> m78
  m70 --> m78
  m16 --> m79
  m71 --> m79
  m16 --> m80
  m72 --> m80
  m73 --> m81
  m74 --> m81
  m75 --> m81
  m76 --> m81
  m77 --> m81
  m80 --> m81
  m78 --> m81
  m79 --> m81
  m22 --> m82
  m21 --> m82
  m63 --> m82
  m26 --> m82
  m66 --> m82
  m67 --> m82
  m68 --> m82
  m69 --> m82
  m31 --> m82
  m62 --> m82
  m45 --> m82
  m46 --> m82
  m48 --> m82
  m52 --> m82
  m53 --> m82
  m59 --> m82
  m60 --> m82
  m72 --> m82
  m70 --> m82
  m71 --> m82
  m18 --> m83
  m20 --> m83
  m81 --> m83
  m82 --> m83
```

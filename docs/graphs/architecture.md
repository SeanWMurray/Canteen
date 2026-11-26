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
    m64["ITA.S50.BadDebtPersonalUse"]
    m65["ITA.S54.Timeline"]
  end
  subgraph Lemmas["Layer 2: reusable lemmas"]
    m66["Lemmas.SuperficialLoss"]
    m67["Lemmas.SuspendedLoss"]
  end
  subgraph Transactions["Layer 3: transactions"]
    m68["Transactions.SpouseRepurchase"]
    m69["Transactions.SiblingAndLateRepurchase"]
    m70["Transactions.TfsaContribution"]
    m71["Transactions.HoldcoRepurchase"]
    m72["Transactions.Crystallization"]
    m73["Transactions.SaleThroughHoldco"]
    m74["Transactions.SisterCompanyRepurchase"]
  end
  subgraph Blueprints["Blueprints"]
    m75["Blueprints.SuperficialLoss"]
    m76["Blueprints.SpouseRepurchase"]
    m77["Blueprints.SiblingAndLateRepurchase"]
    m78["Blueprints.TfsaContribution"]
    m79["Blueprints.HoldcoRepurchase"]
    m80["Blueprints.Crystallization"]
    m81["Blueprints.SaleThroughHoldco"]
    m82["Blueprints.SisterCompanyRepurchase"]
    m83["Blueprints.All"]
  end
  subgraph Examples["Examples"]
    m19["Examples.RuleX"]
    m20["Examples.RuleZ"]
    m21["Examples.ToySeries"]
    m22["Examples.RuleXStatute"]
  end
  subgraph Graphs["Graphs"]
    m84["Graphs.All"]
  end
  subgraph Root["Root"]
    m85["Canteen"]
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
  m12 --> m64
  m10 --> m64
  m2 --> m64
  m23 --> m65
  m23 --> m66
  m37 --> m67
  m24 --> m68
  m66 --> m68
  m27 --> m68
  m28 --> m68
  m24 --> m69
  m28 --> m69
  m66 --> m69
  m36 --> m70
  m28 --> m70
  m36 --> m71
  m27 --> m71
  m29 --> m71
  m50 --> m72
  m51 --> m72
  m54 --> m72
  m27 --> m72
  m55 --> m73
  m58 --> m73
  m37 --> m74
  m29 --> m74
  m16 --> m75
  m66 --> m75
  m26 --> m75
  m27 --> m75
  m28 --> m75
  m31 --> m75
  m43 --> m75
  m45 --> m75
  m46 --> m75
  m48 --> m75
  m50 --> m75
  m51 --> m75
  m52 --> m75
  m53 --> m75
  m56 --> m75
  m57 --> m75
  m58 --> m75
  m59 --> m75
  m60 --> m75
  m61 --> m75
  m62 --> m75
  m63 --> m75
  m64 --> m75
  m67 --> m75
  m16 --> m76
  m68 --> m76
  m25 --> m76
  m65 --> m76
  m42 --> m76
  m16 --> m77
  m17 --> m77
  m69 --> m77
  m65 --> m77
  m16 --> m78
  m17 --> m78
  m70 --> m78
  m65 --> m78
  m16 --> m79
  m71 --> m79
  m65 --> m79
  m16 --> m80
  m72 --> m80
  m16 --> m81
  m73 --> m81
  m16 --> m82
  m74 --> m82
  m75 --> m83
  m76 --> m83
  m77 --> m83
  m78 --> m83
  m79 --> m83
  m82 --> m83
  m80 --> m83
  m81 --> m83
  m22 --> m84
  m21 --> m84
  m65 --> m84
  m26 --> m84
  m68 --> m84
  m69 --> m84
  m70 --> m84
  m71 --> m84
  m31 --> m84
  m64 --> m84
  m45 --> m84
  m46 --> m84
  m48 --> m84
  m52 --> m84
  m53 --> m84
  m59 --> m84
  m60 --> m84
  m62 --> m84
  m74 --> m84
  m72 --> m84
  m73 --> m84
  m18 --> m85
  m20 --> m85
  m83 --> m85
  m84 --> m85
```

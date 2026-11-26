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
    m60["ITA.S50.BadDebtPersonalUse"]
    m61["ITA.S54.Timeline"]
  end
  subgraph Lemmas["Layer 2: reusable lemmas"]
    m62["Lemmas.SuperficialLoss"]
    m63["Lemmas.SuspendedLoss"]
  end
  subgraph Transactions["Layer 3: transactions"]
    m64["Transactions.SpouseRepurchase"]
    m65["Transactions.SiblingAndLateRepurchase"]
    m66["Transactions.TfsaContribution"]
    m67["Transactions.HoldcoRepurchase"]
    m68["Transactions.Crystallization"]
    m69["Transactions.SaleThroughHoldco"]
    m70["Transactions.SisterCompanyRepurchase"]
  end
  subgraph Blueprints["Blueprints"]
    m71["Blueprints.SuperficialLoss"]
    m72["Blueprints.SpouseRepurchase"]
    m73["Blueprints.SiblingAndLateRepurchase"]
    m74["Blueprints.TfsaContribution"]
    m75["Blueprints.HoldcoRepurchase"]
    m76["Blueprints.Crystallization"]
    m77["Blueprints.SaleThroughHoldco"]
    m78["Blueprints.SisterCompanyRepurchase"]
    m79["Blueprints.All"]
  end
  subgraph Examples["Examples"]
    m19["Examples.RuleX"]
    m20["Examples.RuleZ"]
    m21["Examples.ToySeries"]
    m22["Examples.RuleXStatute"]
  end
  subgraph Graphs["Graphs"]
    m80["Graphs.All"]
  end
  subgraph Root["Root"]
    m81["Canteen"]
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
  m12 --> m60
  m10 --> m60
  m2 --> m60
  m23 --> m61
  m23 --> m62
  m37 --> m63
  m24 --> m64
  m62 --> m64
  m27 --> m64
  m28 --> m64
  m24 --> m65
  m28 --> m65
  m62 --> m65
  m36 --> m66
  m28 --> m66
  m36 --> m67
  m27 --> m67
  m29 --> m67
  m50 --> m68
  m51 --> m68
  m54 --> m68
  m27 --> m68
  m55 --> m69
  m58 --> m69
  m37 --> m70
  m29 --> m70
  m16 --> m71
  m62 --> m71
  m26 --> m71
  m27 --> m71
  m28 --> m71
  m31 --> m71
  m43 --> m71
  m45 --> m71
  m46 --> m71
  m48 --> m71
  m50 --> m71
  m51 --> m71
  m52 --> m71
  m53 --> m71
  m56 --> m71
  m57 --> m71
  m58 --> m71
  m59 --> m71
  m60 --> m71
  m63 --> m71
  m16 --> m72
  m64 --> m72
  m25 --> m72
  m61 --> m72
  m42 --> m72
  m16 --> m73
  m17 --> m73
  m65 --> m73
  m61 --> m73
  m16 --> m74
  m17 --> m74
  m66 --> m74
  m61 --> m74
  m16 --> m75
  m67 --> m75
  m61 --> m75
  m16 --> m76
  m68 --> m76
  m16 --> m77
  m69 --> m77
  m16 --> m78
  m70 --> m78
  m71 --> m79
  m72 --> m79
  m73 --> m79
  m74 --> m79
  m75 --> m79
  m78 --> m79
  m76 --> m79
  m77 --> m79
  m22 --> m80
  m21 --> m80
  m61 --> m80
  m26 --> m80
  m64 --> m80
  m65 --> m80
  m66 --> m80
  m67 --> m80
  m31 --> m80
  m60 --> m80
  m45 --> m80
  m46 --> m80
  m48 --> m80
  m52 --> m80
  m53 --> m80
  m59 --> m80
  m70 --> m80
  m68 --> m80
  m69 --> m80
  m18 --> m81
  m20 --> m81
  m79 --> m81
  m80 --> m81
```

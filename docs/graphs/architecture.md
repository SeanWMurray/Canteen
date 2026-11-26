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
    m56["ITA.S50.BadDebtPersonalUse"]
    m57["ITA.S54.Timeline"]
  end
  subgraph Lemmas["Layer 2: reusable lemmas"]
    m58["Lemmas.SuperficialLoss"]
    m59["Lemmas.SuspendedLoss"]
  end
  subgraph Transactions["Layer 3: transactions"]
    m60["Transactions.SpouseRepurchase"]
    m61["Transactions.SiblingAndLateRepurchase"]
    m62["Transactions.TfsaContribution"]
    m63["Transactions.HoldcoRepurchase"]
    m64["Transactions.Crystallization"]
    m65["Transactions.SisterCompanyRepurchase"]
  end
  subgraph Blueprints["Blueprints"]
    m66["Blueprints.SuperficialLoss"]
    m67["Blueprints.SpouseRepurchase"]
    m68["Blueprints.SiblingAndLateRepurchase"]
    m69["Blueprints.TfsaContribution"]
    m70["Blueprints.HoldcoRepurchase"]
    m71["Blueprints.Crystallization"]
    m72["Blueprints.SisterCompanyRepurchase"]
    m73["Blueprints.All"]
  end
  subgraph Examples["Examples"]
    m19["Examples.RuleX"]
    m20["Examples.RuleZ"]
    m21["Examples.ToySeries"]
    m22["Examples.RuleXStatute"]
  end
  subgraph Graphs["Graphs"]
    m74["Graphs.All"]
  end
  subgraph Root["Root"]
    m75["Canteen"]
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
  m12 --> m56
  m10 --> m56
  m2 --> m56
  m23 --> m57
  m23 --> m58
  m37 --> m59
  m24 --> m60
  m58 --> m60
  m27 --> m60
  m28 --> m60
  m24 --> m61
  m28 --> m61
  m58 --> m61
  m36 --> m62
  m28 --> m62
  m36 --> m63
  m27 --> m63
  m29 --> m63
  m50 --> m64
  m51 --> m64
  m54 --> m64
  m27 --> m64
  m37 --> m65
  m29 --> m65
  m16 --> m66
  m58 --> m66
  m26 --> m66
  m27 --> m66
  m28 --> m66
  m31 --> m66
  m43 --> m66
  m45 --> m66
  m46 --> m66
  m48 --> m66
  m50 --> m66
  m51 --> m66
  m52 --> m66
  m53 --> m66
  m54 --> m66
  m55 --> m66
  m56 --> m66
  m59 --> m66
  m16 --> m67
  m60 --> m67
  m25 --> m67
  m57 --> m67
  m42 --> m67
  m16 --> m68
  m17 --> m68
  m61 --> m68
  m57 --> m68
  m16 --> m69
  m17 --> m69
  m62 --> m69
  m57 --> m69
  m16 --> m70
  m63 --> m70
  m57 --> m70
  m16 --> m71
  m64 --> m71
  m16 --> m72
  m65 --> m72
  m66 --> m73
  m67 --> m73
  m68 --> m73
  m69 --> m73
  m70 --> m73
  m72 --> m73
  m71 --> m73
  m22 --> m74
  m21 --> m74
  m57 --> m74
  m26 --> m74
  m60 --> m74
  m61 --> m74
  m62 --> m74
  m63 --> m74
  m31 --> m74
  m56 --> m74
  m45 --> m74
  m46 --> m74
  m48 --> m74
  m52 --> m74
  m53 --> m74
  m55 --> m74
  m65 --> m74
  m64 --> m74
  m18 --> m75
  m20 --> m75
  m73 --> m75
  m74 --> m75
```

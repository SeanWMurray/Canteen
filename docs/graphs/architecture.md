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
    m55["ITA.S50.BadDebtPersonalUse"]
    m56["ITA.S54.Timeline"]
  end
  subgraph Lemmas["Layer 2: reusable lemmas"]
    m57["Lemmas.SuperficialLoss"]
    m58["Lemmas.SuspendedLoss"]
  end
  subgraph Transactions["Layer 3: transactions"]
    m59["Transactions.SpouseRepurchase"]
    m60["Transactions.SiblingAndLateRepurchase"]
    m61["Transactions.TfsaContribution"]
    m62["Transactions.HoldcoRepurchase"]
    m63["Transactions.Crystallization"]
    m64["Transactions.SisterCompanyRepurchase"]
  end
  subgraph Blueprints["Blueprints"]
    m65["Blueprints.SuperficialLoss"]
    m66["Blueprints.SpouseRepurchase"]
    m67["Blueprints.SiblingAndLateRepurchase"]
    m68["Blueprints.TfsaContribution"]
    m69["Blueprints.HoldcoRepurchase"]
    m70["Blueprints.Crystallization"]
    m71["Blueprints.SisterCompanyRepurchase"]
    m72["Blueprints.All"]
  end
  subgraph Examples["Examples"]
    m19["Examples.RuleX"]
    m20["Examples.RuleZ"]
    m21["Examples.ToySeries"]
    m22["Examples.RuleXStatute"]
  end
  subgraph Graphs["Graphs"]
    m73["Graphs.All"]
  end
  subgraph Root["Root"]
    m74["Canteen"]
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
  m23 --> m56
  m23 --> m57
  m37 --> m58
  m24 --> m59
  m57 --> m59
  m27 --> m59
  m28 --> m59
  m24 --> m60
  m28 --> m60
  m57 --> m60
  m36 --> m61
  m28 --> m61
  m36 --> m62
  m27 --> m62
  m29 --> m62
  m50 --> m63
  m51 --> m63
  m54 --> m63
  m27 --> m63
  m37 --> m64
  m29 --> m64
  m16 --> m65
  m57 --> m65
  m26 --> m65
  m27 --> m65
  m28 --> m65
  m31 --> m65
  m43 --> m65
  m45 --> m65
  m46 --> m65
  m48 --> m65
  m50 --> m65
  m51 --> m65
  m52 --> m65
  m53 --> m65
  m54 --> m65
  m55 --> m65
  m58 --> m65
  m16 --> m66
  m59 --> m66
  m25 --> m66
  m56 --> m66
  m42 --> m66
  m16 --> m67
  m17 --> m67
  m60 --> m67
  m56 --> m67
  m16 --> m68
  m17 --> m68
  m61 --> m68
  m56 --> m68
  m16 --> m69
  m62 --> m69
  m56 --> m69
  m16 --> m70
  m63 --> m70
  m16 --> m71
  m64 --> m71
  m65 --> m72
  m66 --> m72
  m67 --> m72
  m68 --> m72
  m69 --> m72
  m71 --> m72
  m70 --> m72
  m22 --> m73
  m21 --> m73
  m56 --> m73
  m26 --> m73
  m59 --> m73
  m60 --> m73
  m61 --> m73
  m62 --> m73
  m31 --> m73
  m55 --> m73
  m45 --> m73
  m46 --> m73
  m48 --> m73
  m52 --> m73
  m53 --> m73
  m64 --> m73
  m63 --> m73
  m18 --> m74
  m20 --> m74
  m72 --> m74
  m73 --> m74
```

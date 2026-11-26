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
    m52["ITA.S50.BadDebtPersonalUse"]
    m53["ITA.S54.Timeline"]
  end
  subgraph Lemmas["Layer 2: reusable lemmas"]
    m54["Lemmas.SuperficialLoss"]
    m55["Lemmas.SuspendedLoss"]
  end
  subgraph Transactions["Layer 3: transactions"]
    m56["Transactions.SpouseRepurchase"]
    m57["Transactions.SiblingAndLateRepurchase"]
    m58["Transactions.TfsaContribution"]
    m59["Transactions.HoldcoRepurchase"]
    m60["Transactions.SisterCompanyRepurchase"]
  end
  subgraph Blueprints["Blueprints"]
    m61["Blueprints.SuperficialLoss"]
    m62["Blueprints.SpouseRepurchase"]
    m63["Blueprints.SiblingAndLateRepurchase"]
    m64["Blueprints.TfsaContribution"]
    m65["Blueprints.HoldcoRepurchase"]
    m66["Blueprints.SisterCompanyRepurchase"]
    m67["Blueprints.All"]
  end
  subgraph Examples["Examples"]
    m19["Examples.RuleX"]
    m20["Examples.RuleZ"]
    m21["Examples.ToySeries"]
    m22["Examples.RuleXStatute"]
  end
  subgraph Graphs["Graphs"]
    m68["Graphs.All"]
  end
  subgraph Root["Root"]
    m69["Canteen"]
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
  m10 --> m52
  m2 --> m52
  m23 --> m53
  m23 --> m54
  m37 --> m55
  m24 --> m56
  m54 --> m56
  m27 --> m56
  m28 --> m56
  m24 --> m57
  m28 --> m57
  m54 --> m57
  m36 --> m58
  m28 --> m58
  m36 --> m59
  m27 --> m59
  m29 --> m59
  m37 --> m60
  m29 --> m60
  m16 --> m61
  m54 --> m61
  m26 --> m61
  m27 --> m61
  m28 --> m61
  m31 --> m61
  m43 --> m61
  m45 --> m61
  m46 --> m61
  m47 --> m61
  m48 --> m61
  m50 --> m61
  m51 --> m61
  m52 --> m61
  m55 --> m61
  m16 --> m62
  m56 --> m62
  m25 --> m62
  m53 --> m62
  m42 --> m62
  m16 --> m63
  m17 --> m63
  m57 --> m63
  m53 --> m63
  m16 --> m64
  m17 --> m64
  m58 --> m64
  m53 --> m64
  m16 --> m65
  m59 --> m65
  m53 --> m65
  m16 --> m66
  m60 --> m66
  m61 --> m67
  m62 --> m67
  m63 --> m67
  m64 --> m67
  m65 --> m67
  m66 --> m67
  m22 --> m68
  m21 --> m68
  m53 --> m68
  m26 --> m68
  m56 --> m68
  m57 --> m68
  m58 --> m68
  m59 --> m68
  m31 --> m68
  m52 --> m68
  m45 --> m68
  m46 --> m68
  m47 --> m68
  m48 --> m68
  m50 --> m68
  m51 --> m68
  m60 --> m68
  m18 --> m69
  m20 --> m69
  m67 --> m69
  m68 --> m69
```

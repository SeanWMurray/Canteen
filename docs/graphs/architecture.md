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
    m53["ITA.S50.BadDebtPersonalUse"]
    m54["ITA.S54.Timeline"]
  end
  subgraph Lemmas["Layer 2: reusable lemmas"]
    m55["Lemmas.SuperficialLoss"]
    m56["Lemmas.SuspendedLoss"]
  end
  subgraph Transactions["Layer 3: transactions"]
    m57["Transactions.SpouseRepurchase"]
    m58["Transactions.SiblingAndLateRepurchase"]
    m59["Transactions.TfsaContribution"]
    m60["Transactions.HoldcoRepurchase"]
    m61["Transactions.SisterCompanyRepurchase"]
  end
  subgraph Blueprints["Blueprints"]
    m62["Blueprints.SuperficialLoss"]
    m63["Blueprints.SpouseRepurchase"]
    m64["Blueprints.SiblingAndLateRepurchase"]
    m65["Blueprints.TfsaContribution"]
    m66["Blueprints.HoldcoRepurchase"]
    m67["Blueprints.SisterCompanyRepurchase"]
    m68["Blueprints.All"]
  end
  subgraph Examples["Examples"]
    m19["Examples.RuleX"]
    m20["Examples.RuleZ"]
    m21["Examples.ToySeries"]
    m22["Examples.RuleXStatute"]
  end
  subgraph Graphs["Graphs"]
    m69["Graphs.All"]
  end
  subgraph Root["Root"]
    m70["Canteen"]
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
  m12 --> m53
  m10 --> m53
  m2 --> m53
  m23 --> m54
  m23 --> m55
  m37 --> m56
  m24 --> m57
  m55 --> m57
  m27 --> m57
  m28 --> m57
  m24 --> m58
  m28 --> m58
  m55 --> m58
  m36 --> m59
  m28 --> m59
  m36 --> m60
  m27 --> m60
  m29 --> m60
  m37 --> m61
  m29 --> m61
  m16 --> m62
  m55 --> m62
  m26 --> m62
  m27 --> m62
  m28 --> m62
  m31 --> m62
  m43 --> m62
  m45 --> m62
  m46 --> m62
  m47 --> m62
  m48 --> m62
  m50 --> m62
  m51 --> m62
  m52 --> m62
  m53 --> m62
  m56 --> m62
  m16 --> m63
  m57 --> m63
  m25 --> m63
  m54 --> m63
  m42 --> m63
  m16 --> m64
  m17 --> m64
  m58 --> m64
  m54 --> m64
  m16 --> m65
  m17 --> m65
  m59 --> m65
  m54 --> m65
  m16 --> m66
  m60 --> m66
  m54 --> m66
  m16 --> m67
  m61 --> m67
  m62 --> m68
  m63 --> m68
  m64 --> m68
  m65 --> m68
  m66 --> m68
  m67 --> m68
  m22 --> m69
  m21 --> m69
  m54 --> m69
  m26 --> m69
  m57 --> m69
  m58 --> m69
  m59 --> m69
  m60 --> m69
  m31 --> m69
  m53 --> m69
  m45 --> m69
  m46 --> m69
  m47 --> m69
  m48 --> m69
  m50 --> m69
  m51 --> m69
  m52 --> m69
  m61 --> m69
  m18 --> m70
  m20 --> m70
  m68 --> m70
  m69 --> m70
```

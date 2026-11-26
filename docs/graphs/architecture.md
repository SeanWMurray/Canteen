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
    m46["ITA.S50.BadDebtPersonalUse"]
    m47["ITA.S54.Timeline"]
  end
  subgraph Lemmas["Layer 2: reusable lemmas"]
    m48["Lemmas.SuperficialLoss"]
    m49["Lemmas.SuspendedLoss"]
  end
  subgraph Transactions["Layer 3: transactions"]
    m50["Transactions.SpouseRepurchase"]
    m51["Transactions.SiblingAndLateRepurchase"]
    m52["Transactions.TfsaContribution"]
    m53["Transactions.HoldcoRepurchase"]
    m54["Transactions.SisterCompanyRepurchase"]
  end
  subgraph Blueprints["Blueprints"]
    m55["Blueprints.SuperficialLoss"]
    m56["Blueprints.SpouseRepurchase"]
    m57["Blueprints.SiblingAndLateRepurchase"]
    m58["Blueprints.TfsaContribution"]
    m59["Blueprints.HoldcoRepurchase"]
    m60["Blueprints.SisterCompanyRepurchase"]
    m61["Blueprints.All"]
  end
  subgraph Examples["Examples"]
    m19["Examples.RuleX"]
    m20["Examples.RuleZ"]
    m21["Examples.ToySeries"]
    m22["Examples.RuleXStatute"]
  end
  subgraph Graphs["Graphs"]
    m62["Graphs.All"]
  end
  subgraph Root["Root"]
    m63["Canteen"]
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
  m12 --> m46
  m10 --> m46
  m2 --> m46
  m23 --> m47
  m23 --> m48
  m37 --> m49
  m24 --> m50
  m48 --> m50
  m27 --> m50
  m28 --> m50
  m24 --> m51
  m28 --> m51
  m48 --> m51
  m36 --> m52
  m28 --> m52
  m36 --> m53
  m27 --> m53
  m29 --> m53
  m37 --> m54
  m29 --> m54
  m16 --> m55
  m48 --> m55
  m26 --> m55
  m27 --> m55
  m28 --> m55
  m31 --> m55
  m43 --> m55
  m45 --> m55
  m46 --> m55
  m49 --> m55
  m16 --> m56
  m50 --> m56
  m25 --> m56
  m47 --> m56
  m42 --> m56
  m16 --> m57
  m17 --> m57
  m51 --> m57
  m47 --> m57
  m16 --> m58
  m17 --> m58
  m52 --> m58
  m47 --> m58
  m16 --> m59
  m53 --> m59
  m47 --> m59
  m16 --> m60
  m54 --> m60
  m55 --> m61
  m56 --> m61
  m57 --> m61
  m58 --> m61
  m59 --> m61
  m60 --> m61
  m22 --> m62
  m21 --> m62
  m47 --> m62
  m26 --> m62
  m50 --> m62
  m51 --> m62
  m52 --> m62
  m53 --> m62
  m31 --> m62
  m46 --> m62
  m45 --> m62
  m54 --> m62
  m18 --> m63
  m20 --> m63
  m61 --> m63
  m62 --> m63
```

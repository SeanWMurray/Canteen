-- Layer 0: core language
import Canteen.Core.Risk
import Canteen.Core.Date
import Canteen.Core.Money
import Canteen.Core.Judgment
import Canteen.Core.Finding
import Canteen.Core.Rule
import Canteen.Core.Render
import Canteen.Core.Argument
import Canteen.Core.Combine
import Canteen.Core.Answer
import Canteen.Core.Statute
import Canteen.Core.StatuteSyntax
import Canteen.Core.Branch
import Canteen.Core.Series
import Canteen.Core.SeriesReport
import Canteen.Core.Audit
import Canteen.Core.Blueprint
import Canteen.Core.Graphs
import Canteen.Core.LeanGraph

-- Worked examples (placeholders, not real provisions)
import Canteen.Examples.RuleX
import Canteen.Examples.RuleZ
import Canteen.Examples.ToySeries
import Canteen.Examples.RuleXStatute

-- Layer 1: statute encoding
import Canteen.ITA.S54.SuperficialLoss
import Canteen.ITA.S40.LossDenial
import Canteen.ITA.S54.SuperficialLossStatute
import Canteen.ITA.S40.LossDenialStatute
import Canteen.ITA.S53.CostAddition
import Canteen.ITA.S251_1.Affiliation
import Canteen.ITA.S251_1.AffiliatedPersons
import Canteen.ITA.S251.RelatedPersons
import Canteen.ITA.S251.Amalgamation
import Canteen.ITA.S38.CapitalGains
import Canteen.ITA.S3.Income
import Canteen.ITA.S111.NetCapitalLoss
import Canteen.ITA.S69.NonArmsLength
import Canteen.ITA.S73.SpousalRollover
import Canteen.ITA.S70.Death
import Canteen.ITA.S74.Attribution
import Canteen.ITA.S45.ChangeInUse
import Canteen.ITA.S85.TransferToCorporation
import Canteen.ITA.S84_1.SurplusStripping
import Canteen.ITA.S110_6.CapitalGainsDeduction
import Canteen.ITA.S251_2.LossRestrictionEvent
import Canteen.ITA.S74.IncomeAttribution
import Canteen.ITA.S82.Dividends
import Canteen.ITA.S55.IntercorporateDividends
import Canteen.ITA.S13.Depreciable
import Canteen.ITA.S84.Redemption
import Canteen.ITA.S89.CapitalDividendAccount
import Canteen.ITA.S86.ShareExchange
import Canteen.ITA.S44.ReplacementProperty
import Canteen.ITA.S47.IdenticalProperties
import Canteen.ITA.S186.Connected
import Canteen.ITA.S84.ReturnOfCapital
import Canteen.ITA.S88.WindingUp
import Canteen.ITA.S87.Amalgamation
import Canteen.ITA.S51.ConvertibleProperty
import Canteen.ITA.S3.IndividualYear
import Canteen.ITA.S50.BadDebtPersonalUse
import Canteen.ITA.S40.SuspendedLoss
import Canteen.ITA.S40.ShareToAffiliate
import Canteen.ITA.S40.RelatedDebt
import Canteen.ITA.S40.PrincipalResidence
import Canteen.ITA.S54.Timeline
import Canteen.ITA.S40.Paragraph40_2_g_Facts
import Canteen.ITA.S40.DebtLoss
import Canteen.ITA.S40.PersonalUseLoss
import Canteen.ITA.S40.PlanTransferLoss
import Canteen.ITA.S40.Paragraph40_2_g

-- Layer 2: reusable lemmas
import Canteen.Lemmas.SuperficialLoss
import Canteen.Lemmas.SuspendedLoss

-- Layer 3: transactions
import Canteen.Transactions.SpouseRepurchase
import Canteen.Transactions.SiblingAndLateRepurchase
import Canteen.Transactions.TfsaContribution
import Canteen.Transactions.HoldcoRepurchase
import Canteen.Transactions.Crystallization
import Canteen.Transactions.SaleThroughHoldco
import Canteen.Transactions.PostMortemPipeline
import Canteen.Transactions.SisterCompanyRepurchase

-- Blueprints: memos linked to Lean
import Canteen.Blueprints.SuperficialLoss
import Canteen.Blueprints.SpouseRepurchase
import Canteen.Blueprints.SiblingAndLateRepurchase
import Canteen.Blueprints.TfsaContribution
import Canteen.Blueprints.HoldcoRepurchase
import Canteen.Blueprints.Crystallization
import Canteen.Blueprints.SaleThroughHoldco
import Canteen.Blueprints.PostMortemPipeline
import Canteen.Blueprints.SisterCompanyRepurchase
import Canteen.Blueprints.All

-- Graph pages
import Canteen.Graphs.All

-- Tests (known-answer, sanity, non-vacuity, read-back)
import Canteen.Tests.Core
import Canteen.Tests.RuleX
import Canteen.Tests.Series
import Canteen.Tests.Chaining
import Canteen.Tests.Branch
import Canteen.Tests.ToySeries
import Canteen.Tests.Date
import Canteen.Tests.SuperficialLoss
import Canteen.Tests.Blueprint
import Canteen.Tests.Statute
import Canteen.Tests.Related
import Canteen.Tests.Graphs
import Canteen.Tests.Paragraph40_2_g
import Canteen.Tests.AffiliatedPersons
import Canteen.Tests.RelatedPersons
import Canteen.Tests.BadDebt
import Canteen.Tests.SuspendedLoss
import Canteen.Tests.Amalgamation
import Canteen.Tests.Income
import Canteen.Tests.NetCapitalLoss
import Canteen.Tests.ShareAndDebt
import Canteen.Tests.PrincipalResidence
import Canteen.Tests.NonArmsLength
import Canteen.Tests.SpousalRollover
import Canteen.Tests.Death
import Canteen.Tests.Attribution
import Canteen.Tests.ChangeInUse
import Canteen.Tests.TransferToCorporation
import Canteen.Tests.SurplusStripping
import Canteen.Tests.CapitalGainsDeduction
import Canteen.Tests.LossRestrictionEvent
import Canteen.Tests.IncomeAttribution
import Canteen.Tests.Dividends
import Canteen.Tests.IntercorporateDividends
import Canteen.Tests.Depreciable
import Canteen.Tests.Redemption
import Canteen.Tests.CapitalDividendAccount
import Canteen.Tests.ShareExchange
import Canteen.Tests.ReplacementProperty
import Canteen.Tests.IdenticalProperties
import Canteen.Tests.Connected
import Canteen.Tests.ReturnOfCapital
import Canteen.Tests.WindingUp
import Canteen.Tests.Amalgamation87
import Canteen.Tests.ConvertibleProperty
import Canteen.Tests.IndividualYear

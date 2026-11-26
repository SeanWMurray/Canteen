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
import Canteen.ITA.S54.Timeline
import Canteen.ITA.S40.Paragraph40_2_g_Facts
import Canteen.ITA.S40.DebtLoss
import Canteen.ITA.S40.PersonalUseLoss
import Canteen.ITA.S40.PlanTransferLoss
import Canteen.ITA.S40.Paragraph40_2_g

-- Layer 2: reusable lemmas
import Canteen.Lemmas.SuperficialLoss

-- Layer 3: transactions
import Canteen.Transactions.SpouseRepurchase
import Canteen.Transactions.SiblingAndLateRepurchase
import Canteen.Transactions.TfsaContribution

-- Blueprints: memos linked to Lean
import Canteen.Blueprints.SuperficialLoss
import Canteen.Blueprints.SpouseRepurchase
import Canteen.Blueprints.SiblingAndLateRepurchase
import Canteen.Blueprints.TfsaContribution
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

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
import Canteen.Core.Branch
import Canteen.Core.Series
import Canteen.Core.SeriesReport
import Canteen.Core.Audit

-- Worked examples (placeholders, not real provisions)
import Canteen.Examples.RuleX
import Canteen.Examples.RuleZ
import Canteen.Examples.ToySeries

-- Layer 1: statute encoding
import Canteen.ITA.S54.SuperficialLoss
import Canteen.ITA.S40.LossDenial

-- Layer 2: reusable lemmas
import Canteen.Lemmas.SuperficialLoss

-- Tests (known-answer, sanity, non-vacuity, read-back)
import Canteen.Tests.Core
import Canteen.Tests.RuleX
import Canteen.Tests.Series
import Canteen.Tests.Chaining
import Canteen.Tests.Branch
import Canteen.Tests.ToySeries
import Canteen.Tests.Date
import Canteen.Tests.SuperficialLoss

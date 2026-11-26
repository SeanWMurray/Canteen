import Canteen.Blueprints.SuperficialLoss
import Canteen.Blueprints.SpouseRepurchase
import Canteen.Blueprints.SiblingAndLateRepurchase
import Canteen.Blueprints.TfsaContribution
import Canteen.Blueprints.HoldcoRepurchase
import Canteen.Blueprints.SisterCompanyRepurchase
import Canteen.Blueprints.Crystallization
import Canteen.Blueprints.SaleThroughHoldco
import Canteen.Blueprints.PostMortemPipeline
import Canteen.Blueprints.EstateFreeze
import Canteen.Blueprints.DonatingShares

/-!
# Every blueprint, and the file each is rendered to

`scripts/blueprint.sh` renders each to `docs/blueprint/<file>.md`.
-/

namespace Canteen.Blueprints

def all : List (String × Blueprint.Blueprint) :=
  [("superficial-loss", SuperficialLoss.blueprint),
   ("spouse-repurchase", SpouseRepurchase.memo),
   ("sibling-and-late-repurchase", SiblingAndLateRepurchase.memo),
   ("tfsa-contribution", TfsaContribution.memo),
   ("holdco-repurchase", HoldcoRepurchase.memo),
   ("sister-company-repurchase", SisterCompanyRepurchase.memo),
   ("crystallization", Crystallization.memo),
   ("sale-through-holdco", SaleThroughHoldco.memo),
   ("post-mortem-pipeline", PostMortemPipeline.memo),
   ("estate-freeze", EstateFreeze.memo),
   ("donating-shares", DonatingShares.memo)]

end Canteen.Blueprints

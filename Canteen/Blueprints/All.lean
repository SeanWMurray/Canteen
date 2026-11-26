import Canteen.Blueprints.SuperficialLoss
import Canteen.Blueprints.SpouseRepurchase
import Canteen.Blueprints.SiblingAndLateRepurchase
import Canteen.Blueprints.TfsaContribution
import Canteen.Blueprints.HoldcoRepurchase
import Canteen.Blueprints.SisterCompanyRepurchase
import Canteen.Blueprints.Crystallization

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
   ("crystallization", Crystallization.memo)]

end Canteen.Blueprints

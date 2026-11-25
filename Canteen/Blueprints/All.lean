import Canteen.Blueprints.SuperficialLoss
import Canteen.Blueprints.SpouseRepurchase

/-!
# Every blueprint, and the file each is rendered to

`scripts/blueprint.sh` renders each to `docs/blueprint/<file>.md`.
-/

namespace Canteen.Blueprints

def all : List (String × Blueprint.Blueprint) :=
  [("superficial-loss", SuperficialLoss.blueprint),
   ("spouse-repurchase", SpouseRepurchase.memo)]

end Canteen.Blueprints

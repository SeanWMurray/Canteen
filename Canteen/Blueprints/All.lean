import Canteen.Blueprints.SuperficialLoss
import Canteen.Blueprints.SpouseRepurchase
import Canteen.Blueprints.SiblingAndLateRepurchase

/-!
# Every blueprint, and the file each is rendered to

`scripts/blueprint.sh` renders each to `docs/blueprint/<file>.md`.
-/

namespace Canteen.Blueprints

def all : List (String × Blueprint.Blueprint) :=
  [("superficial-loss", SuperficialLoss.blueprint),
   ("spouse-repurchase", SpouseRepurchase.memo),
   ("sibling-and-late-repurchase", SiblingAndLateRepurchase.memo)]

end Canteen.Blueprints

import 'package:bonfire/bonfire.dart';
import 'package:flublade_project/data/global.dart';
import 'package:provider/provider.dart';

class NPCWizard extends SimpleNpc with ObjectCollision {
  bool stopLoading = false;
  NPCWizard(Vector2 position)
      : super(
          position: Vector2(100, 32),
          size: Vector2(32, 32),
          animation: SimpleDirectionAnimation(
            idleRight: SpriteAnimation.load(
              "npc/wizard.png",
              SpriteAnimationData.sequenced(
                amount: 1,
                stepTime: 0.1,
                textureSize: Vector2(16, 16),
              ),
            ),
            runRight: SpriteAnimation.load(
              "npc/wizard.png",
              SpriteAnimationData.sequenced(
                amount: 1,
                stepTime: 0.1,
                textureSize: Vector2(16, 16),
              ),
            ),
          ),
        ) {
    setupCollision(
      CollisionConfig(
        collisions: [CollisionArea.circle(radius: 17, align: Vector2(-2.5,0))],
      ),
    );
  }
  @override
  void update(double dt) {
    seePlayer(
        observed: (player) {
          //Start seeing
          if(!stopLoading){
            Provider.of<Gameplay>(context, listen: false).changeIsTalkable(true, 'dialog_npc_wizard_prologue1');
          }
          stopLoading = true;
        },
        radiusVision: 50,
        notObserved: () {
          //Stop seeing
          if(stopLoading){
            Provider.of<Gameplay>(context, listen: false).changeIsTalkable(false, 'dialog_npc_wizard_prologue1');
          }
          stopLoading = false;
        });
    super.update(dt);
  }
}

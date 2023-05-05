import 'package:bonfire/bonfire.dart';
import 'package:flublade_project/data/global.dart';
import 'package:provider/provider.dart';

class NPCWizard extends SimpleNpc with ObjectCollision {
  bool stopLoading = false;
  late String talk;
  NPCWizard(Vector2 position, languageText)
      : super(
          position: position,
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
    talk = languageText;
    setupCollision(
      CollisionConfig(
        collisions: [CollisionArea.circle(radius: 17, align: Vector2(-2.5, 0))],
      ),
    );
  }

  @override
  void update(double dt) {
    seePlayer(
        observed: (player) {
          //Start seeing
          if (!stopLoading) {
            Provider.of<Gameplay>(context, listen: false)
                .changeIsTalkable(true, talk);
          }
          stopLoading = true;
        },
        radiusVision: 50,
        notObserved: () {
          //Stop seeing
          if (stopLoading) {
            Provider.of<Gameplay>(context, listen: false)
                .changeIsTalkable(false, talk);
          }
          stopLoading = false;
        });
    super.update(dt);
  }
}

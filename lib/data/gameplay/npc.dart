import 'package:bonfire/bonfire.dart';
import 'package:flublade_project/data/global.dart';
import 'package:provider/provider.dart';

class NPC extends SimpleNpc with ObjectCollision {
  bool stopLoading = false;
  // ignore: prefer_typing_uninitialized_variables
  final npc;
  NPC(
    Vector2 position,
    this.npc,
  ) : super(
          position: position,
          size: Vector2(48, 48),
          animation: SimpleDirectionAnimation(
            idleRight: SpriteAnimation.load(
              "npc/${npc['name']}.png",
              SpriteAnimationData.sequenced(
                amount: 1,
                stepTime: 0.1,
                textureSize: Vector2(256, 256),
              ),
            ),
            runRight: SpriteAnimation.load(
              "npc/${npc['name']}.png",
              SpriteAnimationData.sequenced(
                amount: 1,
                stepTime: 0.1,
                textureSize: Vector2(48, 48),
              ),
            ),
          ),
        ) {
    setupCollision(
      CollisionConfig(
        collisions: [CollisionArea.circle(radius: 22, align: Vector2(2.0, 4))],
      ),
    );
  }

  @override
  void update(double dt) {
    seePlayer(
        observed: (player) {
          //Start seeing
          if (!stopLoading) {
            Provider.of<Gameplay>(context, listen: false).changeIsTalkable(true, npc);
          }
          stopLoading = true;
        },
        radiusVision: 50,
        notObserved: () {
          //Stop seeing
          if (stopLoading) {
            Provider.of<Gameplay>(context, listen: false).changeIsTalkable(false, npc);
          }
          stopLoading = false;
        });
    super.update(dt);
  }
}

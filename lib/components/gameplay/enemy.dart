import 'package:flame/collisions.dart';
import 'package:flame/components.dart';

class Enemy extends SpriteAnimationComponent with HasGameRef, HasCollisionDetection, CollisionCallbacks {
  //Engine Declarations
  int ticksDelays = 0;
  bool leftDirection = false;
  bool rightDirection = false;
  bool lastAnimation = false;
  bool animationLoad = false;
  bool alreadyInBattle = false;

  //Info Declarations
  int enemyID;
  String enemyName;

  //Sprite Declarations
  late final SpriteAnimation spriteIdle;
  late final SpriteAnimation spriteRun;

  Enemy(this.enemyID, this.enemyName);

  @override
  Future<void> onLoad() async {}
}

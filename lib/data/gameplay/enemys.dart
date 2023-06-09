import 'package:bonfire/bonfire.dart';
import 'package:flublade_project/data/global.dart';
import 'package:flublade_project/pages/gameplay/battle_scene.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ENEMY extends SimpleEnemy with ObjectCollision {
  bool stopLoading = false;
  late int enemyID;
  late String enemyName;
  late double enemyLife;
  late double enemyMana;
  late double enemyDamage;
  late double enemyArmor;
  late int enemyLevel;
  late double enemyXP;
  late List enemyBuffs;
  late List enemySkills;
  ENEMY({
    required int id,
    required Vector2 position,
    required String name,
    required double life,
    required double mana,
    required double damage,
    required double armor,
    required int level,
    required double xp,
    required List buffs,
    required List skills,
  }) : super(
          position: position,
          size: Vector2(32, 32),
          life: 100,
          speed: 30,
          initDirection: Direction.right,
          animation: SimpleDirectionAnimation(
            idleRight: SpriteAnimation.load(
              "enemys/${name}_sprite_right.png",
              SpriteAnimationData.sequenced(
                amount: 1,
                stepTime: 0.1,
                textureSize: Vector2(16, 16),
              ),
            ),
            idleLeft: SpriteAnimation.load(
              "enemys/${name}_sprite_left.png",
              SpriteAnimationData.sequenced(
                amount: 1,
                stepTime: 0.1,
                textureSize: Vector2(16, 16),
              ),
            ),
            idleUp: SpriteAnimation.load(
              "enemys/${name}_sprite_up.png",
              SpriteAnimationData.sequenced(
                amount: 1,
                stepTime: 0.1,
                textureSize: Vector2(16, 16),
              ),
            ),
            idleUpLeft: SpriteAnimation.load(
              "enemys/${name}_sprite_up.png",
              SpriteAnimationData.sequenced(
                amount: 1,
                stepTime: 0.1,
                textureSize: Vector2(16, 16),
              ),
            ),
            idleUpRight: SpriteAnimation.load(
              "enemys/${name}_sprite_up.png",
              SpriteAnimationData.sequenced(
                amount: 1,
                stepTime: 0.1,
                textureSize: Vector2(16, 16),
              ),
            ),
            idleDown: SpriteAnimation.load(
              "enemys/${name}_sprite_down.png",
              SpriteAnimationData.sequenced(
                amount: 1,
                stepTime: 0.1,
                textureSize: Vector2(16, 16),
              ),
            ),
            idleDownLeft: SpriteAnimation.load(
              "enemys/${name}_sprite_down.png",
              SpriteAnimationData.sequenced(
                amount: 1,
                stepTime: 0.1,
                textureSize: Vector2(16, 16),
              ),
            ),
            idleDownRight: SpriteAnimation.load(
              "enemys/${name}_sprite_down.png",
              SpriteAnimationData.sequenced(
                amount: 1,
                stepTime: 0.1,
                textureSize: Vector2(16, 16),
              ),
            ),
            runUp: SpriteAnimation.load(
              "enemys/${name}_sprite_up.png",
              SpriteAnimationData.sequenced(
                amount: 1,
                stepTime: 0.1,
                textureSize: Vector2(16, 16),
              ),
            ),
            runUpLeft: SpriteAnimation.load(
              "enemys/${name}_sprite_up.png",
              SpriteAnimationData.sequenced(
                amount: 1,
                stepTime: 0.1,
                textureSize: Vector2(16, 16),
              ),
            ),
            runUpRight: SpriteAnimation.load(
              "enemys/${name}_sprite_up.png",
              SpriteAnimationData.sequenced(
                amount: 1,
                stepTime: 0.1,
                textureSize: Vector2(16, 16),
              ),
            ),
            runDown: SpriteAnimation.load(
              "enemys/${name}_sprite_down.png",
              SpriteAnimationData.sequenced(
                amount: 1,
                stepTime: 0.1,
                textureSize: Vector2(16, 16),
              ),
            ),
            runDownLeft: SpriteAnimation.load(
              "enemys/${name}_sprite_down.png",
              SpriteAnimationData.sequenced(
                amount: 1,
                stepTime: 0.1,
                textureSize: Vector2(16, 16),
              ),
            ),
            runDownRight: SpriteAnimation.load(
              "enemys/${name}_sprite_down.png",
              SpriteAnimationData.sequenced(
                amount: 1,
                stepTime: 0.1,
                textureSize: Vector2(16, 16),
              ),
            ),
            runLeft: SpriteAnimation.load(
              "enemys/${name}_sprite_left.png",
              SpriteAnimationData.sequenced(
                amount: 1,
                stepTime: 0.1,
                textureSize: Vector2(16, 16),
              ),
            ),
            runRight: SpriteAnimation.load(
              "enemys/${name}_sprite_right.png",
              SpriteAnimationData.sequenced(
                amount: 1,
                stepTime: 0.1,
                textureSize: Vector2(16, 16),
              ),
            ),
          ),
        ) {
    enemyID = id;
    enemyName = name;
    enemyLife = life;
    enemyMana = mana;
    enemyDamage = damage;
    enemyArmor = armor;
    enemyLevel = level;
    enemyXP = xp;
    enemyBuffs = buffs;
    enemySkills = skills;
    setupCollision(
      CollisionConfig(
        collisions: [CollisionArea.circle(radius: 16)],
      ),
    );
  }

  @override
  void update(double dt) {
    super.update(dt);
    final gameplay = Provider.of<Gameplay>(context, listen: false);
    final options = Provider.of<Options>(context, listen: false);
    //Update player posistion
    position = Vector2(
      double.parse(gameplay.enemiesInWorld['enemy$enemyID']['positionX'].toString()),
      double.parse(gameplay.enemiesInWorld['enemy$enemyID']['positionY'].toString()),
    );
    seePlayer(
      radiusVision: 80,
      notObserved: () {
        options.websocketOnlySend({
          'message': 'enemyMoving',
          'id': options.id,
          'location': gameplay.characters['character${gameplay.selectedCharacter}']['location'],
          'enemyID': enemyID,
          'isSee': false,
        }, context);
      },
      observed: (player) async {
        //Check if collided
        isCollision();
        //Send message to the server
        await options.websocketOnlySend({
          'message': 'enemyMoving',
          'id': options.id,
          'location': gameplay.characters['character${gameplay.selectedCharacter}']['location'],
          'enemyID': enemyID,
          'isSee': true,
        }, context);
      },
    );
  }

  @override
  bool onCollision(GameComponent component, bool active) {
    final gameplay = Provider.of<Gameplay>(context, listen: false);
    if (component is Player) {
      //Freeze Other Enemys
      gameplay.changeEnemyMove(false);
      //Add Enemy Stats
      gameplay.changeEnemyName(enemyName);
      gameplay.changeStats(value: enemyLife, stats: 'elife');
      gameplay.changeStats(value: enemyMana, stats: 'emana');
      gameplay.changeStats(value: enemyDamage, stats: 'edamage');
      gameplay.changeStats(value: enemyArmor, stats: 'earmor');
      gameplay.changeStats(value: enemyLevel, stats: 'elevel');
      gameplay.changeStats(value: enemyXP, stats: 'exp');
      gameplay.changeStats(value: enemyBuffs, stats: 'ebuffs');
      gameplay.changeStats(value: enemySkills, stats: 'eskills');
      //Push to battle scene
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => BattleScene(
                  backContext: gameRef.context,
                  enemyMaxLife: gameplay.enemyLife,
                  enemyMaxMana: gameplay.enemyMana,
                )),
      );
      stopLoading = true;
      die();
    }
    return super.onCollision(component, active);
  }

  @override
  void die() {
    removeFromParent();
    super.die();
  }
}

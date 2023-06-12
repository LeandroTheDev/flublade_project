import 'package:bonfire/bonfire.dart';
import 'package:flublade_project/data/global.dart';
import 'package:flublade_project/pages/gameplay/battle_scene.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ENEMY extends SimpleEnemy with ObjectCollision {
  int ticksDelays = 0;
  bool leftDirection = false;
  bool rightDirection = false;
  bool lastAnimation = false;
  bool animationLoad = false;
  bool alreadyInBattle = false;
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
    //Verify if is dead
    if (gameplay.enemiesInWorld['enemy$enemyID']['isDead']) {
      die();
      return;
    }

    //Update enemy position
    position = Vector2(
      double.parse(gameplay.enemiesInWorld['enemy$enemyID']['positionX'].toString()),
      double.parse(gameplay.enemiesInWorld['enemy$enemyID']['positionY'].toString()),
    );

    //If see the player
    if (!alreadyInBattle) {
      seePlayer(
        radiusVision: 80,
        notObserved: () {
          options.websocketOnlySendIngame({
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
          await options.websocketOnlySendIngame({
            'message': 'enemyMoving',
            'id': options.id,
            'location': gameplay.characters['character${gameplay.selectedCharacter}']['location'],
            'enemyID': enemyID,
            'isSee': true,
          }, context);
        },
      );
    }

    //Animations
    if (ticksDelays >= 1) {
      ticksDelays = 0;
      switch (gameplay.enemiesInWorld["enemy$enemyID"]['direction']) {
        case 'Direction.left':
          {
            if (!animationLoad) {
              animation?.play(SimpleAnimationEnum.runLeft);
              Future.delayed(const Duration(milliseconds: 400)).then((value) => animationLoad = false);
              animationLoad = true;
              lastAnimation = true;
            }
            return;
          }
        case 'Direction.downLeft':
          {
            if (!animationLoad) {
              animation?.play(SimpleAnimationEnum.runDown);
              Future.delayed(const Duration(milliseconds: 400)).then((value) => animationLoad = false);
              animationLoad = true;
              lastAnimation = true;
            }
            return;
          }
        case 'Direction.upLeft':
          {
            if (!animationLoad) {
              animation?.play(SimpleAnimationEnum.runUp);
              Future.delayed(const Duration(milliseconds: 400)).then((value) => animationLoad = false);
              animationLoad = true;
              lastAnimation = true;
            }
            return;
          }
        case 'Direction.right':
          {
            if (!animationLoad) {
              animation?.play(SimpleAnimationEnum.runRight);
              Future.delayed(const Duration(milliseconds: 400)).then((value) => animationLoad = false);
              animationLoad = true;
              lastAnimation = false;
            }
            return;
          }
        case 'Direction.downRight':
          {
            if (!animationLoad) {
              animation?.play(SimpleAnimationEnum.runDown);
              Future.delayed(const Duration(milliseconds: 400)).then((value) => animationLoad = false);
              animationLoad = true;
              lastAnimation = false;
            }
            return;
          }
        case 'Direction.upRight':
          {
            if (!animationLoad) {
              animation?.play(SimpleAnimationEnum.runUp);
              Future.delayed(const Duration(milliseconds: 400)).then((value) => animationLoad = false);
              animationLoad = true;
              lastAnimation = false;
            }
            return;
          }
        case 'Direction.idle':
          {
            if (lastAnimation) {
              animation!.play(SimpleAnimationEnum.idleLeft);
            } else {
              animation!.play(SimpleAnimationEnum.idleRight);
            }
            return;
          }
      }
    }
    ticksDelays += 1;
  }

  @override
  bool onCollision(GameComponent component, bool active) {
    final options = Provider.of<Options>(context, listen: false);
    final gameplay = Provider.of<Gameplay>(context, listen: false);
    //If not in battle
    if (component is Player && !alreadyInBattle && !gameplay.alreadyInBattle) {
      gameplay.changeAlreadyInBattle(true);
      //Remove enemy from the world
      options.websocketOnlySendIngame({
        'message': 'playerCollide',
        'id': options.id,
        'location': gameplay.characters['character${gameplay.selectedCharacter}']['location'],
        'enemyID': enemyID,
      }, context);
      alreadyInBattle = true;
      //Push to battle scene
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => BattleScene(backContext: gameRef.context, enemyID: enemyID)),
      );
    }
    //If in battle
    else if (component is Player && !alreadyInBattle) {
      gameplay.changeAlreadyInBattle(true);
      //Remove enemy from the world
      options.websocketOnlySendIngame({
        'message': 'playerCollide',
        'id': options.id,
        'location': gameplay.characters['character${gameplay.selectedCharacter}']['location'],
        'enemyID': enemyID,
      }, context);
      //Add enemy to the lobby
      options.websocketOnlySendBattle({
        'message': 'newEnemy',
        'enemyID': enemyID,
      }, context);
      alreadyInBattle = true;
    }
    return super.onCollision(component, active);
  }

  @override
  void die() {
    removeFromParent();
    super.die();
  }
}

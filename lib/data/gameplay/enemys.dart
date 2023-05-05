import 'package:bonfire/bonfire.dart';
import 'package:flublade_project/data/global.dart';
import 'package:flublade_project/pages/gameplay/battle_scene.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EnemySmallSpider extends SimpleEnemy {
  bool stopLoading = false;
  late String enemyName;
  late double enemyLife;
  late double enemyMana;
  late double enemyDamage;
  late double enemyArmor;
  late int enemyLevel;
  late double enemyXP;
  late List enemyBuffs;
  late List enemySkills;
  EnemySmallSpider({
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
              "enemys/small_spider_sprite_right.png",
              SpriteAnimationData.sequenced(
                amount: 1,
                stepTime: 0.1,
                textureSize: Vector2(16, 16),
              ),
            ),
            idleLeft: SpriteAnimation.load(
              "enemys/small_spider_sprite_left.png",
              SpriteAnimationData.sequenced(
                amount: 1,
                stepTime: 0.1,
                textureSize: Vector2(16, 16),
              ),
            ),
            idleUp: SpriteAnimation.load(
              "enemys/small_spider_sprite_up.png",
              SpriteAnimationData.sequenced(
                amount: 1,
                stepTime: 0.1,
                textureSize: Vector2(16, 16),
              ),
            ),
            idleUpLeft: SpriteAnimation.load(
              "enemys/small_spider_sprite_up.png",
              SpriteAnimationData.sequenced(
                amount: 1,
                stepTime: 0.1,
                textureSize: Vector2(16, 16),
              ),
            ),
            idleUpRight: SpriteAnimation.load(
              "enemys/small_spider_sprite_up.png",
              SpriteAnimationData.sequenced(
                amount: 1,
                stepTime: 0.1,
                textureSize: Vector2(16, 16),
              ),
            ),
            idleDown: SpriteAnimation.load(
              "enemys/small_spider_sprite_down.png",
              SpriteAnimationData.sequenced(
                amount: 1,
                stepTime: 0.1,
                textureSize: Vector2(16, 16),
              ),
            ),
            idleDownLeft: SpriteAnimation.load(
              "enemys/small_spider_sprite_down.png",
              SpriteAnimationData.sequenced(
                amount: 1,
                stepTime: 0.1,
                textureSize: Vector2(16, 16),
              ),
            ),
            idleDownRight: SpriteAnimation.load(
              "enemys/small_spider_sprite_down.png",
              SpriteAnimationData.sequenced(
                amount: 1,
                stepTime: 0.1,
                textureSize: Vector2(16, 16),
              ),
            ),
            runUp: SpriteAnimation.load(
              "enemys/small_spider_sprite_up.png",
              SpriteAnimationData.sequenced(
                amount: 1,
                stepTime: 0.1,
                textureSize: Vector2(16, 16),
              ),
            ),
            runUpLeft: SpriteAnimation.load(
              "enemys/small_spider_sprite_up.png",
              SpriteAnimationData.sequenced(
                amount: 1,
                stepTime: 0.1,
                textureSize: Vector2(16, 16),
              ),
            ),
            runUpRight: SpriteAnimation.load(
              "enemys/small_spider_sprite_up.png",
              SpriteAnimationData.sequenced(
                amount: 1,
                stepTime: 0.1,
                textureSize: Vector2(16, 16),
              ),
            ),
            runDown: SpriteAnimation.load(
              "enemys/small_spider_sprite_down.png",
              SpriteAnimationData.sequenced(
                amount: 1,
                stepTime: 0.1,
                textureSize: Vector2(16, 16),
              ),
            ),
            runDownLeft: SpriteAnimation.load(
              "enemys/small_spider_sprite_down.png",
              SpriteAnimationData.sequenced(
                amount: 1,
                stepTime: 0.1,
                textureSize: Vector2(16, 16),
              ),
            ),
            runDownRight: SpriteAnimation.load(
              "enemys/small_spider_sprite_down.png",
              SpriteAnimationData.sequenced(
                amount: 1,
                stepTime: 0.1,
                textureSize: Vector2(16, 16),
              ),
            ),
            runLeft: SpriteAnimation.load(
              "enemys/small_spider_sprite_left.png",
              SpriteAnimationData.sequenced(
                amount: 1,
                stepTime: 0.1,
                textureSize: Vector2(16, 16),
              ),
            ),
            runRight: SpriteAnimation.load(
              "enemys/small_spider_sprite_right.png",
              SpriteAnimationData.sequenced(
                amount: 1,
                stepTime: 0.1,
                textureSize: Vector2(16, 16),
              ),
            ),
          ),
        ) {
    enemyName = name;
    enemyLife = life;
    enemyMana = mana;
    enemyDamage = damage;
    enemyArmor = armor;
    enemyLevel = level;
    enemyXP = xp;
    enemyBuffs = buffs;
    enemySkills = skills;
  }

  @override
  void update(double dt) {
    final gameplay = Provider.of<Gameplay>(context, listen: false);
    seeAndMoveToPlayer(
        radiusVision:
            Provider.of<Gameplay>(context, listen: false).enemysMove ? 100 : 0,
        margin: 0,
        closePlayer: (_) {
          //Start seeing
          if (!stopLoading) {
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
        },
        notObserved: () {
          //Stop seeing
          if (stopLoading) {
            stopLoading = false;
          }
        });
    super.update(dt);
  }

  @override
  void die() {
    removeFromParent();
    super.die();
  }
}

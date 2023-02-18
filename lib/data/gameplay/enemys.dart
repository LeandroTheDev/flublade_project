import 'package:bonfire/bonfire.dart';
import 'package:flublade_project/data/global.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EnemySmallSpider extends SimpleEnemy {
  bool stopLoading = false;
  late double enemyLife;
  late double enemyMana;
  late double enemyArmor;
  late int enemyLevel;
  EnemySmallSpider({
    required Vector2 position,
    required double life,
    required double mana,
    required double armor,
    required int level,
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
    enemyLife = life;
    enemyMana = mana;
    enemyArmor = armor;
    enemyLevel = level;
  }

  @override
  void update(double dt) {
    seeAndMoveToPlayer(
        radiusVision:
            Provider.of<Gameplay>(context, listen: false).enemysMove ? 100 : 0,
        margin: 0,
        closePlayer: (_) {
          //Start seeing
          if (!stopLoading) {
            //Freeze Other Enemys
            Provider.of<Gameplay>(context, listen: false)
                .changeEnemyMove(false);
            //Add Enemy Stats
            Provider.of<Gameplay>(context, listen: false)
                .changeStats(value: enemyLife, stats: 'elife');
            Provider.of<Gameplay>(context, listen: false)
                .changeStats(value: enemyMana, stats: 'emana');
            Provider.of<Gameplay>(context, listen: false)
                .changeStats(value: enemyArmor, stats: 'earmor');
            Provider.of<Gameplay>(context, listen: false)
                .changeStats(value: enemyLevel, stats: 'elevel');
            //Push to battle scene
            Navigator.pushNamed(gameRef.context, '/battlescene');
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

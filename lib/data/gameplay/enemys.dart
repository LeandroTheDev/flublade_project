import 'package:bonfire/bonfire.dart';
import 'package:flutter/material.dart';

class EnemySmallSpider extends SimpleEnemy {
  bool stopLoading = false;
  EnemySmallSpider(Vector2 position)
      : super(
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
        );

  @override
  void update(double dt) {
    seeAndMoveToPlayer(
        radiusVision: 100,
        margin: 0,
        closePlayer: (_) {
          //Start seeing
          if (!stopLoading) {
            Navigator.pushNamed(gameRef.context, '/battlescene');
            stopLoading = true;
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
    /// Called when the enemy die
    super.die();
  }
}

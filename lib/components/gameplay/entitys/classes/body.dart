import 'dart:async';

import 'package:flame/components.dart';
import 'package:flutter/material.dart';

/// The brute body of the entity,
///
/// The First sprite in the list will be considered as idle,
/// you can also add the idle quantity in sprite
class BodySprite extends SpriteAnimationComponent with HasGameRef {
  final int idleSpriteQuantity;
  final List<String> sprites;
  final Color color;
  BodySprite({
    this.idleSpriteQuantity = 1,
    required this.sprites,
    required Vector2 bodySize,
    this.color = Colors.black,
  }) : super(size: bodySize, position: Vector2(-(bodySize[0] / 2), -(bodySize[1] / 2)), priority: 100);
  SpriteAnimation? spriteIdle;
  SpriteAnimation? spriteRunning;

  @override
  FutureOr<void> onLoad() async {
    List<String> idleSprite = sprites.sublist(0, idleSpriteQuantity);
    //Idle
    Future.wait(
      //Load Sprites
      idleSprite.map((path) => Sprite.load(path)),
    ).then(
      //Sprites Loaded
      (spriteLoaded) => {
        //Update Animation Variable
        spriteIdle = SpriteAnimation.spriteList(
          spriteLoaded,
          stepTime: 0.2,
        ),
        animation = spriteIdle,
      },
    );
    List<String> runningSprite = sprites.sublist(idleSpriteQuantity);
    //Running
    Future.wait(
      //Load Sprites
      runningSprite.map((path) => Sprite.load(path)),
    ).then(
      //Sprites Loaded
      (spriteLoaded) => spriteRunning = SpriteAnimation.spriteList(
        spriteLoaded,
        stepTime: 0.2,
      ),
    );
    return super.onLoad();
  }

  void changeToRunning() => animation = spriteRunning;

  void changeToIdle() => animation = spriteIdle;
}

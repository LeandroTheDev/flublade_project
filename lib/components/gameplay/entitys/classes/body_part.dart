import 'dart:async';

import 'package:flame/components.dart';
import 'package:flutter/material.dart';

///Handles all body parts from the entity
///
///Use the BodyPartGenerator to generate the sprites datas,
///"BodyPartGenerator(...).generateBodyPart"
class BodyPart extends PositionComponent {
  BodyPartSprite? hairSprite;
  BodyPartSprite? eyesSprite;
  BodyPartSprite? mouthSprite;
  BodyPartSprite? skinSprite;

  Map? hairData;
  Map? eyesData;
  Map? mouthData;
  Map? skinData;
  BodyPart({
    this.hairData,
    this.eyesData,
    this.mouthData,
    this.skinData,
    required Vector2 bodySize,
  }) : super(size: bodySize, position: Vector2(-(bodySize[0] / 2), -(bodySize[1] / 2)), priority: 150);

  @override
  FutureOr<void> onLoad() {
    //Load Hair
    if (hairData != null) {
      hairSprite = BodyPartSprite(
        sprites: hairData!["sprites"],
        color: hairData!["color"],
        idleSpriteQuantity: hairData!["idleSpriteQuantity"],
        animationTicks: hairData!["animationTicks"],
        spriteSize: size,
        spritePriority: 200,
      );
      add(hairSprite!);
    }
    //Load Eyes
    if (eyesData != null) {
      eyesSprite = BodyPartSprite(
        sprites: eyesData!["sprites"],
        color: eyesData!["color"],
        idleSpriteQuantity: eyesData!["idleSpriteQuantity"],
        animationTicks: eyesData!["animationTicks"],
        spriteSize: size,
        spritePriority: 150,
      );
      add(eyesSprite!);
    }
    //Load Mouth
    if (mouthData != null) {
      mouthSprite = BodyPartSprite(
        sprites: mouthData!["sprites"],
        color: mouthData!["color"],
        idleSpriteQuantity: mouthData!["idleSpriteQuantity"],
        animationTicks: mouthData!["animationTicks"],
        spriteSize: size,
        spritePriority: 150,
      );
      add(mouthSprite!);
    }
    //Load Skin
    if (skinData != null) {
      skinSprite = BodyPartSprite(
        sprites: skinData!["sprites"],
        color: skinData!["color"],
        idleSpriteQuantity: skinData!["idleSpriteQuantity"],
        animationTicks: skinData!["animationTicks"],
        spriteSize: size,
        spritePriority: 120,
      );
      add(skinSprite!);
    }
    return super.onLoad();
  }

  void changeToIdle() {
    if (hairSprite != null) {
      hairSprite!.changeToIdle();
    }
    if (eyesSprite != null) {
      eyesSprite!.changeToIdle();
    }
    if (mouthSprite != null) {
      mouthSprite!.changeToIdle();
    }
    if (skinSprite != null) {
      skinSprite!.changeToIdle();
    }
  }

  void changeToRunning() {
    if (hairSprite != null) {
      hairSprite!.changeToRunning();
    }
    if (eyesSprite != null) {
      eyesSprite!.changeToRunning();
    }
    if (mouthSprite != null) {
      mouthSprite!.changeToRunning();
    }
    if (skinSprite != null) {
      skinSprite!.changeToRunning();
    }
  }
}

class BodyPartSprite extends SpriteAnimationComponent {
  final List<String> sprites;
  final Color color;
  final int idleSpriteQuantity;
  final double animationTicks;
  BodyPartSprite({
    required this.sprites,
    required this.color,
    this.idleSpriteQuantity = 1,
    this.animationTicks = 0.2,
    required Vector2 spriteSize,
    required int spritePriority,
  }) : super(size: spriteSize, priority: spritePriority);

  SpriteAnimation? spriteIdle;
  SpriteAnimation? spriteRunning;
  @override
  FutureOr<void> onLoad() {
    List<String> idleSprite = sprites.length == 1 ? sprites : sprites.sublist(0, idleSpriteQuantity);
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
          stepTime: animationTicks,
        ),
        animation = spriteIdle,
      },
    );
    List<String> runningSprite = sprites.length == 1 ? sprites : sprites.sublist(idleSpriteQuantity);
    //Running
    Future.wait(
      //Load Sprites
      runningSprite.map((path) => Sprite.load(path)),
    ).then(
      //Sprites Loaded
      (spriteLoaded) => spriteRunning = SpriteAnimation.spriteList(
        spriteLoaded,
        stepTime: animationTicks,
      ),
    );

    return super.onLoad();
  }

  void changeToRunning() => animation = spriteRunning;

  void changeToIdle() => animation = spriteIdle;
}

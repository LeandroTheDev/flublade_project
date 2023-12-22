import 'dart:async';

import 'package:flame/components.dart';
import 'package:flublade_project/components/gameplay/entitys/Classes/Entity.dart';
import 'package:flublade_project/data/base.dart';

class PlayerEntity extends Entity with HasGameRef {
  //Player Declarations
  Map playerBody;
  PlayerEntity({
    required super.entityPosition,
    required super.entitySize,
    required this.playerBody,
    onFinishMount,
  }) : super(onFinishMount: onFinishMount ?? () {});

  //Player Sprites
  late SpriteAnimation spriteIdle;

  @override
  FutureOr<void> onLoad() {
    //String Values
    final bodySprite = Base.convertBodyOptionAssetToEngine(Base.returnBodyOptionAsset(raceID: Base.returnRaceIDbyName(playerBody["race"]), bodyOption: 'body', gender: playerBody["body"]["gender"], selectedSprite: 'idle'));
    //Load the body sprite
    gameRef.images.load(bodySprite).then((loadedSprite) {
      spriteIdle = SpriteAnimation.fromFrameData(
        loadedSprite,
        SpriteAnimationData.sequenced(
          amount: 1,
          textureSize: entitySize * 2,
          stepTime: 0.1,
        ),
      );
      animation = spriteIdle;
    });
    //Idle Sprite
    return super.onLoad();
  }
}

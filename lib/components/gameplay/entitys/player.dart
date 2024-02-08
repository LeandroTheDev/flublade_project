import 'dart:async';

import 'package:flame/components.dart';
import 'package:flublade_project/components/gameplay/entitys/Classes/Entity.dart';
import 'package:flublade_project/components/gameplay/entitys/classes/body.dart';
import 'package:flublade_project/data/base.dart';
import 'package:flutter/material.dart';

class PlayerEntity extends Entity with HasGameRef {
  //Player Declarations
  Map playerBody;
  PlayerEntity({
    required super.entityPosition,
    required super.entitySize,
    required this.playerBody,
  });

  //Player Sprites
  late BodySprite bodySprite;

  @override
  FutureOr<void> onLoad() {
    //Load Body Sprite
    bodySprite = BodySprite(
      sprites: getPlayerBodyAnimations(),
      bodySize: Vector2(22, 44),
      color: Color.fromRGBO(
        playerBody["body"]["skinColor"]["red"],
        playerBody["body"]["skinColor"]["green"],
        playerBody["body"]["skinColor"]["blue"],
        100,
      ),
    );
    //Add Body Sprite
    add(bodySprite);
    return super.onLoad();
  }

  ///Get player sprites for body
  List<String> getPlayerBodyAnimations() {
    List<String> sprites = [];
    //Idle
    sprites.add(Base.convertBodyOptionAssetToEngine(
      Base.returnBodyOptionAsset(
        raceID: Base.returnRaceIDbyName(playerBody["race"]),
        bodyOption: 'body',
        gender: playerBody["body"]["gender"],
        selectedSprite: 'idle',
      ),
    ));
    //Running, running have 4 sprites in total
    for (int i = 0; i <= 3; i++) {
      sprites.add(Base.convertBodyOptionAssetToEngine(
        Base.returnBodyOptionAsset(
          raceID: Base.returnRaceIDbyName(playerBody["race"]),
          bodyOption: 'body',
          gender: playerBody["body"]["gender"],
          selectedSprite: 'running$i',
        ),
      ));
    }
    return sprites;
  }
}

import 'dart:async';

import 'package:flame/components.dart';
import 'package:flublade_project/components/gameplay/entitys/Classes/Entity.dart';
import 'package:flublade_project/components/gameplay/entitys/classes/body.dart';
import 'package:flublade_project/components/gameplay/entitys/classes/body_part.dart';
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
  late BodyPart bodyParts;

  @override
  FutureOr<void> onLoad() {
    final bodySize = Vector2(22, 44);
    //Get body sprite
    bodySprite = BodySprite(
      sprites: getPlayerBodyAnimations(),
      bodySize: bodySize,
      color: Color.fromRGBO(
        playerBody["body"]["skinColor"]["red"],
        playerBody["body"]["skinColor"]["green"],
        playerBody["body"]["skinColor"]["blue"],
        100,
      ),
    );
    //Add body sprite
    add(bodySprite);
    //Get body parts data
    final bodyPartsAnimations = getPlayerBodyPartsAnimations();
    bodyParts = BodyPart(
      bodySize: bodySize,
      hairData: bodyPartsAnimations[0],
      eyesData: bodyPartsAnimations[1],
      mouthData: bodyPartsAnimations[2],
      skinData: bodyPartsAnimations[3],
    );
    //Add body parts
    add(bodyParts);
    return super.onLoad();
  }

  ///Get player sprites for body, the bodyType is for "body" or "skin"
  List<String> getPlayerBodyAnimations({bodyType = "body"}) {
    List<String> sprites = [];
    //Idle
    sprites.add(Base.convertBodyOptionAssetToEngine(
      Base.returnBodyOptionAsset(
        raceID: Base.returnRaceIDbyName(playerBody["race"]),
        bodyOption: bodyType,
        gender: playerBody["body"]["gender"],
        selectedSprite: 'idle',
      ),
    ));
    //Running, running have 4 sprites in total
    for (int i = 0; i <= 3; i++) {
      sprites.add(Base.convertBodyOptionAssetToEngine(
        Base.returnBodyOptionAsset(
          raceID: Base.returnRaceIDbyName(playerBody["race"]),
          bodyOption: bodyType,
          gender: playerBody["body"]["gender"],
          selectedSprite: 'running$i',
        ),
      ));
    }
    return sprites;
  }

  ///Get a list of player parts,
  ///0: hair,
  ///1: eyes,
  ///2: mouth,
  ///3: skin
  List<Map<String, dynamic>> getPlayerBodyPartsAnimations() {
    //Translate Sprites to List<String> and remove the assets/images to engine work with it
    List<String> getSprites(List spriteTemplate) {
      List<String> spriteReference = [];
      for (int i = 0; i < spriteTemplate.length; i++) {
        spriteReference.add(Base.convertBodyOptionAssetToEngine(spriteTemplate[i]));
      }
      return spriteReference;
    }

    List<Map<String, dynamic>> bodyParts = [];
    //Hair
    bodyParts.add({
      "color": Color.fromRGBO(playerBody["body"]["hairColor"]["red"], playerBody["body"]["hairColor"]["green"], playerBody["body"]["hairColor"]["blue"], 100),
      "sprites": getSprites(Base.returnBodyOptionAsset(
        raceID: Base.returnRaceIDbyName(playerBody["race"]),
        bodyOption: "hair",
        gender: playerBody["body"]["gender"] != "male",
        selectedOption: playerBody["body"]["hair"],
      )),
      "idleSpriteQuantity": 1,
      "animationTicks": 0.2,
    });
    //Eyes
    bodyParts.add({
      "color": Color.fromRGBO(playerBody["body"]["eyesColor"]["red"], playerBody["body"]["eyesColor"]["green"], playerBody["body"]["eyesColor"]["blue"], 100),
      "sprites": getSprites(Base.returnBodyOptionAsset(
        raceID: Base.returnRaceIDbyName(playerBody["race"]),
        bodyOption: "eyes",
        gender: playerBody["body"]["gender"] != "male",
        selectedOption: playerBody["body"]["eyes"],
      )),
      "idleSpriteQuantity": 1,
      "animationTicks": 0.2,
    });
    //Mouth
    bodyParts.add({
      "color": Color.fromRGBO(playerBody["body"]["mouthColor"]["red"], playerBody["body"]["mouthColor"]["green"], playerBody["body"]["mouthColor"]["blue"], 100),
      "sprites": getSprites(Base.returnBodyOptionAsset(
        raceID: Base.returnRaceIDbyName(playerBody["race"]),
        bodyOption: "mouth",
        gender: playerBody["body"]["gender"] != "male",
        selectedOption: playerBody["body"]["mouth"],
      )),
      "idleSpriteQuantity": 1,
      "animationTicks": 0.2,
    });
    //Skin
    bodyParts.add({
      "color": Color.fromRGBO(playerBody["body"]["skinColor"]["red"], playerBody["body"]["skinColor"]["green"], playerBody["body"]["skinColor"]["blue"], 100),
      "sprites": getSprites(getPlayerBodyAnimations(bodyType: "skin")),
      "idleSpriteQuantity": 1,
      "animationTicks": 0.2,
    });
    return bodyParts;
  }
}

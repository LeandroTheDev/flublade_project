// ignore_for_file: use_build_context_synchronously

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flublade_project/components/engine.dart';
import 'package:flublade_project/components/gameplay/game_engine.dart';
import 'package:flublade_project/components/gameplay/world_generation.dart';
import 'package:flublade_project/data/gameplay.dart';
import 'package:flublade_project/data/mysql.dart';
import 'package:flublade_project/data/options.dart';
import 'package:flublade_project/data/settings.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

//
//  DOCS
//
// Player
// ---------------
// Player will be the main character that client will control;
//
//
//
// PlayerClient
// ---------------
// This is the others players connected in the world.
//
//
// PlayerEquipment
// ---------------
// Receive from Player or PlayerClient equipment infos;
// this is a component to create the sprite armor for the respective equipped item.

class Player extends SpriteAnimationComponent with HasGameRef, CollisionCallbacks, ChangeNotifier {
  //Engine Declarations
  final BuildContext context;
  final Vector2 playerPosition;
  late Vector2 cameraPosition;
  late final GameEngine engine;
  late final Gameplay gameplay;
  late final Options options;
  late final Websocket websocket;
  late final Settings settings;

  //Sprite Declarations
  late final SpriteAnimation spriteIdle;
  late final SpriteAnimation spriteRun;

  //Moviment Declarations
  String lastDirection = 'left';
  WorldTile lastCollision = WorldTile('tilesets/overworld/grass.png', Vector2(0.0, 0.0), Vector2(0.0, 0.0));
  double defaultSpeed = 0.5;
  double maxSpeed = 0.5;
  //left,right,up,down
  List<bool> collisionDirection = [false, false, false, false];

  //Equipment Declarations
  late List<PlayerEquipment> loadedIngameEquipments;
  late List loadedEquipment;

  //Player Declaration
  Player(this.context, this.playerPosition)
      : super(
          size: Vector2.all(32.0),
          position: playerPosition,
        ) {
    cameraPosition = playerPosition;
  }

  @override
  void onMount() {
    super.onMount();
    engine = Provider.of<GameEngine>(context, listen: false);
    gameplay = Provider.of<Gameplay>(context, listen: false);
    options = Provider.of<Options>(context, listen: false);
    websocket = Provider.of<Websocket>(context, listen: false);
    settings = Provider.of<Settings>(context, listen: false);
    loadedIngameEquipments = [
      PlayerEquipment("none", 0, context),
      PlayerEquipment("none", 1, context),
      PlayerEquipment("none", 2, context),
      PlayerEquipment("none", 3, context),
      PlayerEquipment("none", 4, context),
      PlayerEquipment("none", 5, context),
      PlayerEquipment("none", 6, context),
      PlayerEquipment("none", 7, context),
      PlayerEquipment("none", 8, context),
      PlayerEquipment("none", 9, context),
      PlayerEquipment("none", 10, context),
    ];
    loadedEquipment = gameplay.playerEquips;
  }

  @override
  Future<void> onLoad() async {
    //Define the player on top of everthing
    priority = 100;

    final imageLocation = 'players/${MySQL.returnInfo(context, returned: 'class')}/${MySQL.returnInfo(context, returned: 'class')}';
    //Idle Sprite
    gameRef.images.load('${imageLocation}_ingame_idleright.png').then((loadedSprite) {
      spriteIdle = SpriteAnimation.fromFrameData(
        loadedSprite,
        SpriteAnimationData.sequenced(
          amount: 1,
          textureSize: Vector2(16.0, 16.0),
          stepTime: 0.1,
        ),
      );
      animation = spriteIdle;
    });
    //Run Sprite
    gameRef.images.load('${imageLocation}_ingame_runright.png').then((loadedSprite) {
      spriteRun = SpriteAnimation.fromFrameData(
        loadedSprite,
        SpriteAnimationData.sequenced(
          amount: 4,
          textureSize: Vector2(16.0, 16.0),
          stepTime: 0.1,
        ),
      );
    });

    //Create a collision circle
    add(CircleHitbox(radius: 16, anchor: Anchor.center, position: size / 2, isSolid: true));
  }

  @override
  void update(double dt) async {
    super.update(dt);
    //Moviment Handler
    if (true) {
      //Moviment Speed
      double xSpeed = maxSpeed;
      double ySpeed = maxSpeed;
      //X Collision Check
      if (engine.joystickPosition[0] < 0 && collisionDirection[0]) {
        xSpeed = 0.0;
      }
      if (engine.joystickPosition[0] > 0 && collisionDirection[1]) {
        xSpeed = 0.0;
      }
      //Y Collision Check
      if (engine.joystickPosition[1] < 0 && collisionDirection[2]) {
        ySpeed = 0.0;
      }
      if (engine.joystickPosition[1] > 0 && collisionDirection[3]) {
        ySpeed = 0.0;
      }
      //Check joystick moviment
      if (!(engine.joystickPosition[0] == 0.0 && engine.joystickPosition[1] == 0.0)) {
        animation = spriteRun;
        final moviment = Vector2(engine.joystickPosition[0] * xSpeed, engine.joystickPosition[1] * ySpeed);
        position.add(moviment);
        cameraPosition.add(moviment);

        //Run Animation
        final actualDirection = engine.joystickPosition[0] > 0 ? 'left' : 'right';
        if (actualDirection != lastDirection) {
          lastDirection = actualDirection;
          if (!isFlippedHorizontally) {
            flipHorizontally();
            position = position + Vector2(32.0, 0.0);
          } else {
            flipHorizontally();
            position = position + Vector2(-32.0, 0.0);
          }
        }
      }
      //Idle Animation
      else {
        animation = spriteIdle;
      }
    }

    //Verify Equipments Update
    // if (loadedEquipment != gameplay.playerEquips) {
    //   for (int i = 0; i < gameplay.playerEquips.length; i++) {
    //     //Update
    //     loadedEquipment[i] = gameplay.playerEquips[i];

    //     //Verify if the armor is already displayed
    //     if (loadedIngameEquipments[i].equipmentName != gameplay.playerEquips[i]) {
    //       //Remove
    //       loadedIngameEquipments[i].removeFromParent();
    //       //Update
    //       loadedIngameEquipments[i] = PlayerEquipment(gameplay.playerEquips[i], i, context);
    //       //Add
    //       add(loadedIngameEquipments[i]);
    //     }
    //   }
    // }
  }

  @override
  void onCollisionStart(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollisionStart(intersectionPoints, other);
    //Check World Collisions
    if (other is WorldTile) {
      //Add Collisions
      collisionDirection = [
        engine.joystickPosition[0] < 0,
        engine.joystickPosition[0] > 0,
        engine.joystickPosition[1] < 0,
        engine.joystickPosition[1] > 0,
      ];
      lastCollision = other;
    }
  }

  @override
  void onCollisionEnd(PositionComponent other) {
    super.onCollisionEnd(other);
    if (other == lastCollision) {
      //Disable All Collisions
      collisionDirection = [
        false,
        false,
        false,
        false,
      ];
    }
  }
}

class PlayerClient extends SpriteAnimationComponent with HasGameRef, CollisionCallbacks {
  //Engine Declarations
  final BuildContext context;
  final String id;
  late final Gameplay gameplay;

  //Sprite Declarations
  late final SpriteAnimation spriteIdle;
  late final SpriteAnimation spriteRun;

  //Animation Declarations
  late String lastAnimation;
  bool animationLoad = false;

  PlayerClient(
    this.id,
    Vector2 playerPosition,
    this.context,
  ) : super(position: playerPosition, size: Vector2.all(32.0));

  @override
  void onMount() {
    super.onMount();
    gameplay = Provider.of<Gameplay>(context, listen: false);
  }

  @override
  Future<void> onLoad() async {
    priority = 50;
    //SPRITE HERE
    final imageLocation = 'players/${MySQL.returnInfo(context, returned: 'class')}/${MySQL.returnInfo(context, returned: 'class')}';
    //Idle Sprite
    gameRef.images.load('${imageLocation}_ingame_idleright.png').then((loadedSprite) {
      spriteIdle = SpriteAnimation.fromFrameData(
        loadedSprite,
        SpriteAnimationData.sequenced(
          amount: 1,
          textureSize: Vector2(16.0, 16.0),
          stepTime: 0.1,
        ),
      );
      animation = spriteIdle;
    });
    //Run Sprite
    gameRef.images.load('${imageLocation}_ingame_runright.png').then((loadedSprite) {
      spriteRun = SpriteAnimation.fromFrameData(
        loadedSprite,
        SpriteAnimationData.sequenced(
          amount: 4,
          textureSize: Vector2(16.0, 16.0),
          stepTime: 0.1,
        ),
      );
    });
    //First Direction
    lastAnimation = Provider.of<Gameplay>(context, listen: false).usersInWorld[id]['direction'];
  }

  @override
  void update(double dt) {
    super.update(dt);
    Vector2 newPosition =
        Vector2(double.parse(gameplay.usersInWorld[id]['positionX'].toString()), double.parse(gameplay.usersInWorld[id]['positionY'].toString()));
    //Check if disconnected
    if (gameplay.usersInWorld[id] == null) {
      removeFromParent();
      return;
    }
    //Animation Handle
    if (true) {
      switch (gameplay.usersInWorld[id]['direction']) {
        case 'Direction.left':
          {
            if (!animationLoad) {
              //PLACE ANIMATION HERE
              if (lastAnimation != 'Direction.left') {
                flipHorizontally();
              }
              position = newPosition;
              animation = spriteRun;
              Future.delayed(const Duration(milliseconds: 400)).then((value) => animationLoad = false);
              animationLoad = true;
              lastAnimation = 'Direction.left';
            }
            return;
          }
        case 'Direction.right':
          {
            if (!animationLoad) {
              //PLACE ANIMATION HERE
              if (lastAnimation != 'Direction.right') {
                flipHorizontally();
              }
              position = newPosition;
              animation = spriteRun;
              Future.delayed(const Duration(milliseconds: 400)).then((value) => animationLoad = false);
              animationLoad = true;
              lastAnimation = 'Direction.right';
            }
            return;
          }
        case 'Direction.idle':
          {
            position = newPosition;
            animation = spriteIdle;
            return;
          }
      }

      //Update player posistion
      position = Vector2(
        double.parse(Provider.of<Gameplay>(context, listen: false).usersInWorld[id]['positionX'].toString()),
        double.parse(Provider.of<Gameplay>(context, listen: false).usersInWorld[id]['positionY'].toString()),
      );
    }
  }
}

class PlayerEquipment extends SpriteAnimationComponent with HasGameRef {
  //Engine Declarations
  final String equipmentName;
  late final String equipmentNameWithoutTier;
  final int equipmentFatherID;
  final BuildContext context;
  late final Settings settings;

  //Sprite Declarations
  late final SpriteAnimation spriteIdle;
  late final SpriteAnimation spriteRun;

  PlayerEquipment(this.equipmentName, this.equipmentFatherID, this.context)
      : super(
          anchor: Anchor.center,
          //Pickup size by configuration
          size: Provider.of<Settings>(context, listen: false).equipmentSettings[Settings.tierCheck(equipmentName)]["size"],
        );

  @override
  void onMount() {
    super.onMount();
    settings = Provider.of<Settings>(context, listen: false);
    equipmentNameWithoutTier = Settings.tierCheck(equipmentName);
  }

  @override
  Future<void> onLoad() async {
    position = settings.equipmentSettings[equipmentNameWithoutTier]["position"];
    //Idle Sprite
    gameRef.images.load('items/$equipmentNameWithoutTier.png').then((loadedSprite) {
      spriteIdle = SpriteAnimation.fromFrameData(
        loadedSprite,
        SpriteAnimationData.sequenced(
          amount: settings.equipmentSettings[equipmentNameWithoutTier]["idleAmount"],
          textureSize: settings.equipmentSettings[equipmentNameWithoutTier]["textureSize"],
          stepTime: settings.equipmentSettings[equipmentNameWithoutTier]["idleStep"],
        ),
      );
      animation = spriteIdle;
    });
    //Run Sprite
    gameRef.images.load('items/$equipmentNameWithoutTier.png').then((loadedSprite) {
      spriteRun = SpriteAnimation.fromFrameData(
        loadedSprite,
        SpriteAnimationData.sequenced(
          amount: settings.equipmentSettings[equipmentNameWithoutTier]["runAmount"],
          textureSize: settings.equipmentSettings[equipmentNameWithoutTier]["textureSize"],
          stepTime: settings.equipmentSettings[equipmentNameWithoutTier]["runStep"],
        ),
      );
    });
  }
}

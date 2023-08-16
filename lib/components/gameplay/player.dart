// ignore_for_file: use_build_context_synchronously

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flublade_project/components/engine.dart';
import 'package:flublade_project/components/gameplay/game_engine.dart';
import 'package:flublade_project/components/gameplay/world_generation.dart';
import 'package:flublade_project/data/gameplay.dart';
import 'package:flublade_project/data/mysql.dart';
import 'package:flublade_project/data/options.dart';
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

class Player extends SpriteAnimationComponent with HasGameRef, CollisionCallbacks {
  //Engine Declarations
  final BuildContext context;
  final Vector2 playerPosition;
  late Vector2 cameraPosition;
  late final GameEngine engine;
  late final Gameplay gameplay;
  late final Options options;
  late final Websocket websocket;

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
  List loadedEquipments = [];

  //Player Declaration
  Player(
    this.context,
    this.playerPosition,
  ) : super(
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
  }

  //Loading
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
    //Change Player Position
    engine.changePlayerPosition(position);

    //Verify Equipments Update
    if (loadedEquipments != gameplay.playerEquips) {
      List newEquipments = [];
      for (int i = 0; i < gameplay.playerEquips.length; i++) {
        //Add
      }
    }
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

  //Animation Declarations
  String lastAnimation = 'Direction.left';
  bool animationLoad = false;

  PlayerClient(
    this.id,
    Vector2 playerPosition,
    this.context,
  ) : super(position: playerPosition);

  @override
  Future<void> onLoad() async {
    priority = 50;
    //SPRITE HERE
  }

  @override
  void update(double dt) {
    super.update(dt);

    //Verify if the user is alive
    final gameplay = Provider.of<Gameplay>(context, listen: false);
    List users = [];
    gameplay.usersInWorld.forEach((key, value) => users.add(value));
    bool remove = true;
    for (int i = 0; i < users.length; i++) {
      if (id == users[i]['id'].toString()) {
        remove = false;
      }
    }
    //Check is player disconnected
    if (!remove) {
      //Animation Handle
      if (true) {
        switch (gameplay.usersInWorld[id]['direction']) {
          case 'Direction.left':
            {
              if (!animationLoad) {
                //PLACE ANIMATION HERE
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
                Future.delayed(const Duration(milliseconds: 400)).then((value) => animationLoad = false);
                animationLoad = true;
                lastAnimation = 'Direction.right';
              }
              return;
            }
          case 'Direction.idle':
            {
              if (lastAnimation == 'Direction.left') {
                //PLACE ANIMATION HERE
              } else {
                //PLACE ANIMATION HERE
              }
              return;
            }
        }
      }

      //Update player posistion
      position = Vector2(
        double.parse(Provider.of<Gameplay>(context, listen: false).usersInWorld[id]['positionX'].toString()),
        double.parse(Provider.of<Gameplay>(context, listen: false).usersInWorld[id]['positionY'].toString()),
      );
    } else {
      removeFromParent();
    }
  }
}

class PlayerEquipment extends SpriteAnimationComponent {
  //Engine Declarations
  final equipmentName;
  final equipmentFatherID;

  PlayerEquipment(this.equipmentName, this.equipmentFatherID)
      : super(
          anchor: Anchor.center,
          size: Vector2.all(32.0),
        );

  @override
  Future<void> onLoad() async {
    position = size / 2;
  }
}

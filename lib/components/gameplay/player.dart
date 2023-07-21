// ignore_for_file: use_build_context_synchronously

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flublade_project/components/gameplay/world_generation.dart';
import 'package:flublade_project/data/mysqldata.dart';
import 'package:flutter/material.dart';

//
//  DOCS
//
// Player
// ---------------
// position -- variable that defines the player exact position (position.add() will increment the position like moving)
//
// joystick -- component receive from the game engine display a single joystick for moving the character
// and receives parameters for joystick position
//
// Moviment Declarations (xP,xN) will say if player can move or not

class Player extends SpriteAnimationComponent with HasGameRef, CollisionCallbacks {
  //Engine Declarations
  final BuildContext context;
  final JoystickComponent joystick;
  final Vector2 playerPosition;
  static const maxSpeed = 0.5;

  //Sprite Declarations
  late final SpriteAnimation spriteIdle;
  late final SpriteAnimation spriteRun;
  JoystickDirection spriteUpdate = JoystickDirection.idle;

  //Moviment Declarations
  bool xNegative = true;
  bool xPositive = true;
  bool yNegative = true;
  bool yPositive = true;

  //Player Declaration
  Player(
    this.joystick,
    this.context,
    this.playerPosition,
  ) : super(
          size: Vector2.all(32.0),
        );

  //Loading
  @override
  Future<void> onLoad() async {
    //Define the player on top of everthing
    priority = 99;

    // final imageLocation = 'players/${MySQL.returnInfo(context, returned: 'class')}/${MySQL.returnInfo(context, returned: 'class')}';
    const imageLocation = 'players/berserk/berserk';
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
    //Initial Position
    position = playerPosition;
    //Create a collision circle
    add(CircleHitbox(radius: 20, anchor: Anchor.center, position: size / 2, isSolid: true));
  }

  //Tick Update
  @override
  void update(double dt) {
    super.update(dt);
    //Moviment Handler
    if (true) {
      switch (joystick.direction) {
        //Down
        case JoystickDirection.down:
          //Moviment
          yPositive ? position.add(Vector2(0.0, maxSpeed)) : null;
          //Animation
          if (spriteUpdate != joystick.direction) {
            spriteUpdate = JoystickDirection.down;
            animation = spriteRun;
          }
          break;
        //Down Left
        case JoystickDirection.downLeft:
          //Moviment
          xNegative ? position.add(Vector2(-(maxSpeed / 1.5), maxSpeed / 1.5)) : null;
          //Animation
          if (spriteUpdate != joystick.direction) {
            spriteUpdate = JoystickDirection.downLeft;
            animation = spriteRun;
            if (!isFlippedHorizontally) {
              flipHorizontally();
              position = position + Vector2(32.0, 0.0);
            }
          }
          break;
        //Downn Right
        case JoystickDirection.downRight:
          //Moviment
          xNegative ? position.add(Vector2(maxSpeed / 1.5, maxSpeed / 1.5)) : null;
          //Animation
          if (spriteUpdate != joystick.direction) {
            spriteUpdate = JoystickDirection.downRight;
            animation = spriteRun;
            if (isFlippedHorizontally) {
              flipHorizontally();
              position = position - Vector2(32.0, 0.0);
            }
          }
          break;
        //Left
        case JoystickDirection.left:
          //Moviment
          xNegative ? position.add(Vector2(-maxSpeed, 0.0)) : null;
          //Animation
          if (spriteUpdate != joystick.direction) {
            spriteUpdate = JoystickDirection.left;
            animation = spriteRun;
            if (!isFlippedHorizontally) {
              flipHorizontally();
              position = position + Vector2(32.0, 0.0);
            }
          }
          break;
        //Right
        case JoystickDirection.right:
          //Moviment
          xPositive ? position.add(Vector2(maxSpeed, 0.0)) : null;
          //Animation
          if (spriteUpdate != joystick.direction) {
            spriteUpdate = JoystickDirection.right;
            animation = spriteRun;
            if (isFlippedHorizontally) {
              flipHorizontally();
              position = position - Vector2(32.0, 0.0);
            }
          }
          break;
        //Up
        case JoystickDirection.up:
          //Moviment
          yNegative ? position.add(Vector2(0.0, -maxSpeed)) : null;
          //Animation
          if (spriteUpdate != joystick.direction) {
            spriteUpdate = JoystickDirection.up;
            animation = spriteRun;
          }
          break;
        case JoystickDirection.upLeft:
          //Moviment
          xPositive ? position.add(Vector2(-(maxSpeed / 1.5), -(maxSpeed / 1.5))) : null;
          //Animation
          if (spriteUpdate != joystick.direction) {
            spriteUpdate = JoystickDirection.upLeft;
            animation = spriteRun;
            if (!isFlippedHorizontally) {
              flipHorizontally();
              position = position + Vector2(32.0, 0.0);
            }
          }
          break;
        case JoystickDirection.upRight:
          //Moviment
          xPositive ? position.add(Vector2(maxSpeed / 1.5, -(maxSpeed / 1.5))) : null;
          //Animation
          if (spriteUpdate != joystick.direction) {
            spriteUpdate = JoystickDirection.upRight;
            animation = spriteRun;
            if (isFlippedHorizontally) {
              flipHorizontally();
              position = position - Vector2(32.0, 0.0);
            }
          }
          break;
        case JoystickDirection.idle:
          if (spriteUpdate != joystick.direction) {
            animation = spriteIdle;
          }
          break;
      }
    }
  }

  @override
  void onCollisionStart(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollisionStart(intersectionPoints, other);
    //Check World Collisions
    if (other is WorldTile) {}
  }
}

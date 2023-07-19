// ignore_for_file: use_build_context_synchronously

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
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

class Player extends SpriteAnimationComponent with HasGameRef, HasCollisionDetection, CollisionCallbacks {
  //Engine Declarations
  final BuildContext context;
  final JoystickComponent joystick;
  static const maxSpeed = 0.5;

  //Sprite Declarations
  late final SpriteAnimation spriteIdle;
  late final SpriteAnimation spriteRun;
  bool spriteFacingRight = true;

  //Player Declaration
  Player(this.joystick, this.context)
      : super(
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
          textureSize: Vector2(32.0, 32.0),
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
          amount: 3,
          textureSize: Vector2(32.0, 32.0),
          stepTime: 0.1,
        ),
      );
    });
    //Initial Position
    position = Vector2(34.0, 1.0);
    //Create a collision circle
    add(CircleHitbox(radius: 10, isSolid: true, anchor: Anchor.center));
  }

  //Tick Update
  @override
  void update(double dt) {
    super.update(dt);
    //Moviment Handler
    if (true) {
      switch (joystick.direction) {
        case JoystickDirection.down:
          position.add(Vector2(0.0, maxSpeed));
          if (!spriteFacingRight) {
            animation = spriteRun.reversed();
          } else {
            animation = spriteRun;
          }
          break;
        case JoystickDirection.downLeft:
          position.add(Vector2(-(maxSpeed / 1.5), maxSpeed / 1.5));
          spriteFacingRight = false;
          animation = spriteRun.reversed();
          break;
        case JoystickDirection.downRight:
          position.add(Vector2(maxSpeed / 1.5, maxSpeed / 1.5));
          spriteFacingRight = true;
          animation = spriteRun;
          break;
        case JoystickDirection.left:
          position.add(Vector2(-maxSpeed, 0.0));
          spriteFacingRight = false;
          animation = spriteRun.reversed();
          break;
        case JoystickDirection.right:
          position.add(Vector2(maxSpeed, 0.0));
          spriteFacingRight = true;
          animation = spriteRun;
          break;
        case JoystickDirection.up:
          position.add(Vector2(0.0, -maxSpeed));
          if (!spriteFacingRight) {
            animation = spriteRun.reversed();
          } else {
            animation = spriteRun;
          }
          break;
        case JoystickDirection.upLeft:
          position.add(Vector2(-(maxSpeed / 1.5), -(maxSpeed / 1.5)));
          spriteFacingRight = false;
          animation = spriteRun.reversed();
          break;
        case JoystickDirection.upRight:
          position.add(Vector2(maxSpeed / 1.5, -(maxSpeed / 1.5)));
          spriteFacingRight = true;
          animation = spriteRun;
          break;
        case JoystickDirection.idle:
          if (!spriteFacingRight) {
            animation = spriteIdle.reversed();
          } else {
            animation = spriteIdle;
          }
          break;
      }
    }
  }

  //Collision Detector
  @override
  void onCollisionStart(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollisionStart(intersectionPoints, other);
    print("player collided");
  }
}

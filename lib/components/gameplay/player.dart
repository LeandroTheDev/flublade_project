// ignore_for_file: use_build_context_synchronously

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

class Player extends SpriteComponent with ChangeNotifier {
  //Declarations
  final BuildContext context;
  final JoystickComponent joystick;
  static const maxSpeed = 0.5;

  //Player Declaration
  Player(this.joystick, this.context)
      : super(
          size: Vector2.all(32.0),
        );

  @override
  Future<void> onLoad() async {
    //Sprite
    sprite = await Sprite.load('players/${MySQL.returnInfo(context, returned: 'class')}/${MySQL.returnInfo(context, returned: 'class')}_ingame_idleright.png');
    //Initial Position
    position = Vector2(1.0, 1.0);
  }

  @override
  void update(double dt) {
    switch (joystick.direction) {
      case JoystickDirection.down:
        position.add(Vector2(0.0, maxSpeed));
        break;
      case JoystickDirection.downLeft:
        position.add(Vector2(-(maxSpeed / 1.5), maxSpeed / 1.5));
        break;
      case JoystickDirection.downRight:
        position.add(Vector2(maxSpeed / 1.5, maxSpeed / 1.5));
        break;
      case JoystickDirection.left:
        position.add(Vector2(-maxSpeed, 0.0));
        break;
      case JoystickDirection.right:
        position.add(Vector2(maxSpeed, 0.0));
        break;
      case JoystickDirection.up:
        position.add(Vector2(0.0, -maxSpeed));
        break;
      case JoystickDirection.upLeft:
        position.add(Vector2(-(maxSpeed / 1.5), -(maxSpeed / 1.5)));
        break;
      case JoystickDirection.upRight:
        position.add(Vector2(maxSpeed / 1.5, -(maxSpeed / 1.5)));
        break;
      case JoystickDirection.idle:
        break;
    }
  }
}

import 'package:flame/components.dart';
import 'package:flublade_project/data/mysqldata.dart';
import 'package:flutter/material.dart';

class Player extends SpriteComponent with HasGameRef, ChangeNotifier {
  //Declarations
  final BuildContext context;
  final JoystickComponent joystick;
  static const maxSpeed = 0.5;

  //Player Declaration
  Player(this.joystick, this.context)
      : super(
          anchor: Anchor.center,
          size: Vector2.all(32.0),
        );

  @override
  Future<void> onLoad() async {
    sprite = await Sprite.load(
        'players/${MySQL.returnInfo(context, returned: 'class')}/${MySQL.returnInfo(context, returned: 'class')}_ingame_idleright.png');
    position = gameRef.size / 2;
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

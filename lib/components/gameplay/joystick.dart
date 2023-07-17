import 'package:flame/components.dart';
import 'package:flutter/material.dart';

class Player extends SpriteComponent with HasGameRef, ChangeNotifier {
  double _actualSpeed = 0;
  static const maxSpeed = 300.0;

  double get actualSpeed => _actualSpeed;

  Player(this.joystick)
      : super(
          anchor: Anchor.center,
          size: Vector2.all(100.0),
        );

  final JoystickComponent joystick;

  @override
  Future<void> onLoad() async {
    sprite = await gameRef.loadSprite('players/berserk/berserk.ingame.idleright.png');
    position = gameRef.size / 2;
  }

  @override
  void update(double dt) {
    if (joystick.direction != JoystickDirection.idle) {
      _actualSpeed = maxSpeed;
      angle = joystick.delta.screenAngle();
    } else {
      _actualSpeed = 0;
    }
  }
}

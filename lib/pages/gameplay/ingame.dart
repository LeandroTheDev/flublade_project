import 'package:bonfire/bonfire.dart';
import 'package:flutter/material.dart';

class InGame extends StatelessWidget {
  const InGame({super.key});

  @override
  Widget build(BuildContext context) {
    return BonfireWidget(
      joystick: Joystick(
        directional: JoystickDirectional(),
      ),
      map: WorldMapByTiled(
        'prologue/prologue.json',
        forceTileSize: Vector2(32,32),
      ),
    );
  }
}

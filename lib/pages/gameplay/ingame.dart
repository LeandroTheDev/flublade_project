import 'package:bonfire/bonfire.dart';
import 'package:flublade_project/data/gameplay/characters.dart';
import 'package:flublade_project/data/gameplay/interface.dart';
import 'package:flublade_project/data/global.dart';
import 'package:flublade_project/data/mysqldata.dart';
import 'package:flutter/material.dart';

class InGame extends StatelessWidget {
  const InGame({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      //Level Load
      future: MySQLGameplay.returnLevel(
        context: context,
        level: MySQL.returnInfo(context, returned: 'location'),
      ),
      builder: (context, future) {
        if (future.hasData) {
          return BonfireWidget(
            showCollisionArea: true,
            //JoyStick
            joystick: Joystick(
              directional: JoystickDirectional(),
            ),
            //Generate Map
            map: MatrixMapGenerator.generate(
              axisInverted: true,
              //Load Tiles Position
              matrix: future.data![0],
              //Load Tiles Images
              builder: (ItemMatrixProperties prop) => Gameplay.loadTiles(prop),
            ),
            //Player Call
            player: PlayerClient(
              Vector2(32, 32),
              context,
            ),
            //Npcs
            components: future.data![1],
            //Loots
            decorations: const [],
            //Enemies
            enemies: const [],
            overlayBuilderMap: {
              'pause': (BuildContext context, BonfireGame game) {
                return const IngameInterface();
              }
            },
            initialActiveOverlays: const ['pause'],
          );
          //Loading Widget
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}

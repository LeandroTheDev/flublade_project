import 'package:flublade_project/data/gameplay/characters.dart';
import 'package:flublade_project/data/gameplay/interface.dart';
import 'package:flublade_project/data/global.dart';
import 'package:flublade_project/data/mysqldata.dart';

import 'package:bonfire/bonfire.dart';
import 'package:flutter/material.dart';

class InGame extends StatelessWidget {
  const InGame({super.key});

  @override
  Widget build(BuildContext context) {
    //Screen Resolution
    double zoomResolution() {
      if(MediaQuery.of(context).size.height <= 320) {
        if(MediaQuery.of(context).size.width <= 240) {
          return 0.5;
        } else if (MediaQuery.of(context).size.width >= 480) {
          return 0.7;
        } else {
          return 0.6;
        }
      }
      if (MediaQuery.of(context).size.height <= 854) {
         if(MediaQuery.of(context).size.width <= 480) {
          return 1.35;
         } else {
          return 1.60;
         }
      }
      if(MediaQuery.of(context).size.height <= 1280) {
        if (MediaQuery.of(context).size.width <= 720) {
          return 1.9;
        } else {
          return 2.2;
        }
      }
      if(MediaQuery.of(context).size.height <= 1920){
        if(MediaQuery.of(context).size.width <= 1080) {
          return 2.5;
        } else {
          return 2.7;
        }
      } else {
        return 3.0;
      }
    }
    
    return FutureBuilder(
      //Level Load
      future: MySQLGameplay.returnLevel(
        context: context,
        level: MySQL.returnInfo(context, returned: 'location'),
      ),
      builder: (context, future) {
        if (future.hasData) {
          return Scaffold(
            body: BonfireWidget(
              showCollisionArea: true,
              //Camera
              cameraConfig: CameraConfig(
                moveOnlyMapArea: true,
                sizeMovementWindow: Vector2(1, 1),
                smoothCameraEnabled: true,
                smoothCameraSpeed: 3.0,
                zoom: zoomResolution(),
              ),
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
              enemies: future.data![2],
              overlayBuilderMap: {
                'pause': (BuildContext context, BonfireGame game) {
                  return const IngameInterface();
                }
              },
              initialActiveOverlays: const ['pause'],
            ),
          );
          //Loading Widget
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}

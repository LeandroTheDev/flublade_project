import 'package:flublade_project/data/gameplay/characters.dart';
import 'package:flublade_project/data/gameplay/interface.dart';
import 'package:flublade_project/data/global.dart';
import 'package:flublade_project/data/mysqldata.dart';

import 'package:bonfire/bonfire.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class InGame extends StatefulWidget {
  const InGame({super.key});

  @override
  State<InGame> createState() => _InGameState();
}

class _InGameState extends State<InGame> {
  Future<void> connectionSignal(context) async {
    final options = Provider.of<Options>(context, listen: false);
    final gameplay = Provider.of<Gameplay>(context, listen: false);
    await options.websocketSendIngame(
      {
        'message': 'login',
        'id': options.id,
        'location': gameplay.characters['character${gameplay.selectedCharacter}']['location'],
        'class': gameplay.characters['character${gameplay.selectedCharacter}']['class'],
        'selectedCharacter': gameplay.selectedCharacter,
        'token': options.token,
      },
      context,
    );
  }

  //Initialize Variables
  @override
  void initState() {
    super.initState();
    final options = Provider.of<Options>(context, listen: false);
    final gameplay = Provider.of<Gameplay>(context, listen: false);
    //Reset Game State
    gameplay.usersHandle('clean');
    gameplay.enemyHandle('clean');
    //Init WebSocket
    options.websocketInitIngame(context);
    options.changeGameController(GameController());
  }

  @override
  Widget build(BuildContext context) {
    final options = Provider.of<Options>(context, listen: false);
    final gameplay = Provider.of<Gameplay>(context, listen: false);
    //Screen Resolution
    double zoomResolution() {
      if (MediaQuery.of(context).size.height <= 320) {
        if (MediaQuery.of(context).size.width <= 240) {
          return 0.5;
        } else if (MediaQuery.of(context).size.width >= 480) {
          return 0.7;
        } else {
          return 0.6;
        }
      }
      if (MediaQuery.of(context).size.height <= 854) {
        if (MediaQuery.of(context).size.width <= 480) {
          return 1.35;
        } else {
          return 1.60;
        }
      }
      if (MediaQuery.of(context).size.height <= 1280) {
        if (MediaQuery.of(context).size.width <= 720) {
          return 1.9;
        } else {
          return 2.2;
        }
      }
      if (MediaQuery.of(context).size.height <= 1920) {
        if (MediaQuery.of(context).size.width <= 1080) {
          return 2.5;
        } else {
          return 2.7;
        }
      } else {
        return 3.0;
      }
    }

    return FutureBuilder<List>(
      //Level Load
      future: MySQLGameplay.returnLevel(
        context: context,
        level: MySQL.returnInfo(context, returned: 'location'),
      ),
      builder: (context, future) {
        if (future.hasData) {
          return Scaffold(
            body: BonfireWidget(
              //Game Controller
              gameController: options.gameController,
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
                future.data![2],
                context,
              ),
              //Npcs
              components: future.data![1],
              //HUD
              overlayBuilderMap: {
                'pause': (BuildContext context, BonfireGame game) {
                  return const IngameInterface();
                }
              },
              //Events
              decorations: const [],
              //After Loads everthing
              onReady: (gameRef) {
                //Send a message for the server that you are in
                connectionSignal(context);
                gameplay.usersHandle('clean');
              },
              //?
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

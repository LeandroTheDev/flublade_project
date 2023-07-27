import 'package:flame/game.dart';

import 'package:flublade_project/components/gameplay/player.dart';
import 'package:flublade_project/components/gameplay/world_generation.dart';
import 'package:flublade_project/components/engine.dart';
import 'package:flublade_project/data/gameplay.dart';
import 'package:flublade_project/data/global.dart';
import 'package:flublade_project/data/mysqldata.dart';

import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

class GameEngine extends FlameGame with HasCollisionDetection, ChangeNotifier {
  late BuildContext context;
  GameEngine();

  //Provider
  Vector2 _joystickPosition = Vector2(0.0, 0.0);
  get joystickPosition => _joystickPosition;

  //Set Joystick Position
  void setjoystickPosition(value) {
    _joystickPosition = value;
  }

  //Set Context
  void setContext(value) {
    context = value;
  }

  @override
  void onMount() async {
    super.onMount();
    Future<void> connectionSignal(context) async {
      final websocket = Provider.of<Websocket>(context, listen: false);
      final options = Provider.of<Options>(context, listen: false);
      final gameplay = Provider.of<Gameplay>(context, listen: false);
      await websocket.websocketSendIngame(
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

    await connectionSignal(context);
  }

  @override
  Future<void> onLoad() async {
    final engine = Provider.of<Engine>(context, listen: false);
    //Joystick and Player Creation
    //Load Sprite
    images.load('interface/joystick.png').then((value) {
      //Player Creation
      final player = Player(context, Vector2(48.0, 180.0));

      //Add Components
      add(player);
      //Camera
      // ignore: deprecated_member_use
      camera.followVector2(player.cameraPosition);
    });
    //World Loading
    MySQLGameplay.returnLevel(context: context, level: MySQL.returnInfo(context, returned: 'location')).then((value) {
      final worldGeneration = WorldGeneration();
      worldGeneration.generateWorld(value, engine.gameController);
    });
    //Test
    // final worldGeneration = WorldGeneration();
    // worldGeneration.generateWorld([
    //   [
    //     [1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 1],
    //     [1, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 1],
    //     [1, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 1],
    //     [1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 1],
    //     [1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1],
    //     [1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1],
    //     [1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1],
    //     [1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1],
    //   ]
    // ], engine.gameController);
  }
}

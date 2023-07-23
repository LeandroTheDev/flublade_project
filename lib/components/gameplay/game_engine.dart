import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/sprite.dart';

import 'package:flublade_project/components/gameplay/player.dart';
import 'package:flublade_project/components/gameplay/world_generation.dart';
import 'package:flublade_project/components/engine.dart';
import 'package:flublade_project/data/gameplay.dart';
import 'package:flublade_project/data/global.dart';

import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

class GameEngine extends FlameGame with HasCollisionDetection {
  final BuildContext context;
  GameEngine(this.context);

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
    debugMode = false;
    //Joystick and Player Creation
    //Load Sprite
    images.load('interface/joystick.png').then((value) {
      final sheet = SpriteSheet.fromColumnsAndRows(
        image: value,
        columns: 6,
        rows: 1,
      );

      //Joystick Creation
      final joystick = JoystickComponent(
        priority: 100,
        knob: SpriteComponent(
          sprite: sheet.getSpriteById(1),
          size: Vector2.all(100),
        ),
        background: SpriteComponent(
          sprite: sheet.getSpriteById(0),
          size: Vector2.all(150),
        ),
        margin: const EdgeInsets.only(left: 40, bottom: 40),
      );

      //Player Creation
      final player = Player(joystick, context, Vector2(48.0, 180.0));

      //Add Components
      add(player);
      add(joystick);
    });
    //World Loading
    // MySQLGameplay.returnLevel(context: context, level: MySQL.returnInfo(context, returned: 'location')).then((value) {
    //   final worldGeneration = WorldGeneration();
    //   worldGeneration.generateWorld(value, engine.gameController);
    // });
    //Test
    final worldGeneration = WorldGeneration();
    worldGeneration.generateWorld([
      [
        [1, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 1],
        [1, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 1],
        [1, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 1],
        [1, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 1],
        [1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1],
        [1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1],
        [1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1],
        [1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1],
      ]
    ], engine.gameController);
  }
}

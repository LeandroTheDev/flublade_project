import 'package:flame/game.dart';
import 'package:flublade_project/components/interface.dart';
import 'package:flublade_project/components/engine.dart';
import 'package:flublade_project/data/gameplay.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class InGame extends StatefulWidget {
  const InGame({super.key});

  @override
  State<InGame> createState() => _InGameState();
}

class _InGameState extends State<InGame> {
  //Initialize Variables
  @override
  void initState() {
    super.initState();
    final engine = Provider.of<Engine>(context, listen: false);
    final websocket = Provider.of<Websocket>(context, listen: false);
    final gameplay = Provider.of<Gameplay>(context, listen: false);
    //Reset Game State
    gameplay.usersHandle('clean');
    gameplay.enemyHandle('clean');
    //Init WebSocket
    websocket.websocketInitIngame(context);
    //Init gameController
    engine.initGameController(context);
  }

  @override
  Widget build(BuildContext context) {
    final engine = Provider.of<Engine>(context, listen: false);

    return GameWidget(
      //Game Controller
      game: engine.gameController,
      //Loading
      loadingBuilder: (p0) => const Center(child: CircularProgressIndicator()),
      //HUD
      overlayBuilderMap: {
        'IngameInterface': (context, game) {
          return const IngameInterface();
        }
      },
      initialActiveOverlays: const ["IngameInterface"],
    );
  }
}

import 'package:flame/game.dart';
import 'package:flublade_project/components/engine.dart';
import 'package:flublade_project/components/gameplay/game_engine.dart';
import 'package:flublade_project/components/widget/navigator_interface_widget.dart';
import 'package:flutter/material.dart';

class GameplayNavigator extends StatelessWidget {
  final Engine engine;
  const GameplayNavigator(this.engine, {super.key});

  @override
  Widget build(BuildContext context) {
    return GameWidget(
      game: GameEngine(context, Engine()),
      //Loading
      loadingBuilder: (p0) => const Center(child: CircularProgressIndicator()),
      //Main Interface
      overlayBuilderMap: {
        'IngameInterface': (context, game) {
          return const NavigatorInterface();
        }
      },
      initialActiveOverlays: const ["IngameInterface"],
    );
  }
}

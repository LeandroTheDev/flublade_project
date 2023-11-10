import 'package:flame/game.dart';
import 'package:flublade_project/components/connection_engine.dart';
import 'package:flublade_project/components/navigator_engine.dart';
import 'package:flublade_project/components/widget/navigator_interface_widget.dart';
import 'package:flutter/material.dart';

class GameplayNavigator extends StatelessWidget {
  final ConnectionEngine engine;
  const GameplayNavigator(this.engine, {super.key});

  @override
  Widget build(BuildContext context) {
    return GameWidget(
      game: NavigatorEngine(context, engine),
      //Loading
      loadingBuilder: (p0) => const Center(child: CircularProgressIndicator()),
      //Main Interface
      overlayBuilderMap: {
        'IngameInterface': (context, game) {
          return NavigatorInterface(engine);
        }
      },
      initialActiveOverlays: const ["IngameInterface"],
    );
  }
}

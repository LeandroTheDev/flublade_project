import 'package:flame/game.dart';
import 'package:flublade_project/components/engine.dart';
import 'package:flublade_project/data/gameplay.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class GameEngine extends FlameGame {
  late final BuildContext context;
  late final Engine engine;
  GameEngine(this.context, this.engine);

  //Providers
  late final Gameplay gameplay;

  //Game Engine Initialization
  @override
  void onMount() {
    super.onMount();
    //Providers Declaration
    gameplay = Provider.of<Gameplay>(context, listen: false);
  }
}

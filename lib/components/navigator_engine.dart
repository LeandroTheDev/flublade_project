import 'package:flame/game.dart';
import 'package:flublade_project/components/connection_engine.dart';
import 'package:flublade_project/data/gameplay.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class NavigatorEngine extends FlameGame {
  late final BuildContext context;
  late final ConnectionEngine engine;
  NavigatorEngine(this.context, this.engine);

  //Providers
  late final Gameplay gameplay;

  loadWorldData(data) {
    print(data);
  }

  //Game Engine Initialization
  @override
  void onMount() {
    super.onMount();
    //Providers Declaration
    gameplay = Provider.of<Gameplay>(context, listen: false);
    //Ask for the server to receive world datas
    engine.startNavigatorSocket(context, loadWorldData);
  }
}

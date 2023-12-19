import 'dart:convert';

import 'package:flame/game.dart';
import 'package:flublade_project/components/connection_engine.dart';
import 'package:flublade_project/components/gameplay/world_generation.dart';
import 'package:flublade_project/data/gameplay.dart';
import 'package:flublade_project/data/server.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class NavigatorEngine extends FlameGame {
  final BuildContext context;
  final ConnectionEngine engine;
  NavigatorEngine(this.context, this.engine);

  //Providers
  late final Gameplay gameplay;

  ///World Tiles, stores all the tiles in actual area
  List worldTiles = [];

  ///Load all world tiles
  void loadAllWorldTiles(data) {
    //Remove old worlds from the render
    WorldGeneration().removeAllComponents(worldTiles, this);
    //Add new worlds to the render
    worldTiles = WorldGeneration().generateWorld(data, this, Vector2(0, 0));
  }

  ///Handle the socket messages provides by the server
  void navigatorMessageHandler(String data) {
    final Map response = jsonDecode(data);
    //Check Errors
    if (response["error"]) {
      if (!Server.errorTreatment(json.decode(data)["message"], context)) {
        engine.closeNavigatorSocket();
        gameplay.resetVariables();
        Navigator.pushNamedAndRemoveUntil(context, '/authenticationpage', (route) => false);
        return;
      }
    }
    //Handle Message
    switch (response["message"]) {
      case "All Chunks Update":
        loadAllWorldTiles(response["chunks"]);
        break;
    }
  }

  //Game Engine Initialization
  @override
  void onMount() {
    super.onMount();
    //Providers Declaration
    gameplay = Provider.of<Gameplay>(context, listen: false);
    //Ask for the server to receive world datas
    engine.startNavigatorSocket(context, (data) => navigatorMessageHandler(data));
  }
}

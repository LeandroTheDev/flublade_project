import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flublade_project/components/gameplay/characters.dart';
import 'package:flutter/widgets.dart';

class Flublade extends FlameGame with TapCallbacks {
  final BuildContext context;
  Flublade(this.context);

  @override
  Future<void> onLoad() async {
    //Components
    //Player Component
    add(Player(context));
  }
}

import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flublade_project/components/gameplay/characters.dart';
import 'package:flutter/widgets.dart';

/// This example simply adds a rotating white square on the screen.
/// If you press on a square, it will be removed.
/// If you press anywhere else, another square will be added.
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

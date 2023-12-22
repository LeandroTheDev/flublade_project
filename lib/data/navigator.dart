import 'package:flame/components.dart';
import 'package:flublade_project/components/gameplay/entitys/player.dart';
import 'package:flutter/foundation.dart';

class NavigatorData extends ChangeNotifier {
  ///Character ID of the selected characters
  late PlayerEntity _player;
  PlayerEntity get player => _player;
  void changePlayer(PlayerEntity player) {
    _player = player;
  }

  void changePlayerPosition(Vector2 position) {
    player.position = position;
  }
}

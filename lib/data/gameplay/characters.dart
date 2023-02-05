import 'package:flublade_project/data/gameplay/characters_sprites.dart';
import 'package:flublade_project/data/global.dart';

import 'package:bonfire/bonfire.dart';
import 'package:flutter/material.dart';

class PlayerClient extends SimplePlayer {
  PlayerClient(
    Vector2 position,
    BuildContext context,
  ) : super(
          position: position,
          size: Vector2(32, 32),
          animation: SimpleDirectionAnimation(
            idleRight: ClassSpriteSheet
                .characterClass['${Gameplay.returnClass()}idle'],
            runRight:
                ClassSpriteSheet.characterClass['${Gameplay.returnClass()}run'],
          ),
        );
}

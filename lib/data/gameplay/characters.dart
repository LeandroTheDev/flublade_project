import 'package:flublade_project/data/gameplay/characters_sprites.dart';

import 'package:bonfire/bonfire.dart';
import 'package:flublade_project/data/mysqldata.dart';
import 'package:flutter/material.dart';

class PlayerClient extends SimplePlayer with ObjectCollision {
  PlayerClient(
    Vector2 position,
    BuildContext context,
  ) : super(
          position: position,
          size: Vector2(32, 32),
          animation: SimpleDirectionAnimation(
            idleRight: ClassSpriteSheet.characterClass[
                '${MySQL.returnInfo(context, returned: 'class')}idle'],
            runRight: ClassSpriteSheet.characterClass[
                '${MySQL.returnInfo(context, returned: 'class')}run'],
          ),
        ) {
    setupCollision(
      CollisionConfig(
        collisions: [CollisionArea.rectangle(size: Vector2(32, 32))],
      ),
    );
  }
}

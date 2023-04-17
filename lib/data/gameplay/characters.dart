import 'package:flublade_project/data/mysqldata.dart';

import 'package:bonfire/bonfire.dart';
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

class ClassSpriteSheet {
  static final Map characterClass = {
    //Berserk
    'berserkidle': SpriteAnimation.load(
      "players/berserk/berserk_ingame_idleright.png",
      SpriteAnimationData.sequenced(
        amount: 1,
        stepTime: 0.1,
        textureSize: Vector2(16, 16),
      ),
    ),
    'berserkrun': SpriteAnimation.load(
      "players/berserk/berserk_ingame_runright.png",
      SpriteAnimationData.sequenced(
        amount: 4,
        stepTime: 0.1,
        textureSize: Vector2(16, 16),
      ),
    ),
    //Archer
    'archeridle': SpriteAnimation.load(
      "players/archer/archer_ingame_idleright.png",
      SpriteAnimationData.sequenced(
        amount: 1,
        stepTime: 0.1,
        textureSize: Vector2(16, 16),
      ),
    ),
    'archerrun': SpriteAnimation.load(
      "players/archer/archer_ingame_runright.png",
      SpriteAnimationData.sequenced(
        amount: 4,
        stepTime: 0.1,
        textureSize: Vector2(16, 16),
      ),
    ),
    //Assassin
    'assassinidle': SpriteAnimation.load(
      "players/assassin/assassin_ingame_idleright.png",
      SpriteAnimationData.sequenced(
        amount: 1,
        stepTime: 0.1,
        textureSize: Vector2(16, 16),
      ),
    ),
    'assassinrun': SpriteAnimation.load(
      "players/assassin/assassin_ingame_runright.png",
      SpriteAnimationData.sequenced(
        amount: 4,
        stepTime: 0.1,
        textureSize: Vector2(16, 16),
      ),
    ),
  };
}


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

class BaseCharacters {
  static const baseAtributes = {
    'archer': {
      'life': 8,
      'mana': 8,
      'armor': 2,
      'strength': 5,
      'agility': 13,
      'intelligence': 5,
      'buffs': {},
    },
    'assassin': {
      'life': 7,
      'mana': 12,
      'armor': 2,
      'strength': 2,
      'agility': 15,
      'intelligence': 8,
      'buffs': {},
    },
    'berserk': {
      'life': 20,
      'mana': 5,
      'armor': 0,
      'armorLevel': 1,
      'strength': 12,
      'strengthLevel': 2,
      'agility': 6,
      'agilityLevel': 1,
      'intelligence': 2,
      'intelligenceLevel': 0.5,
      'buffs': {
        'healthTurbo': {
          'name': 'healthTurbo',
          'rounds': 'racial',
        },
        'damageTurbo': {
          'name': 'damageTurbo',
          'rounds': 'racial',
        },
        'magicalBlock': {
          'name': 'magicalBlock',
          'rounds': 'racial',
        },
        'petsBlock': {
          'name': 'petsBlock',
          'rounds': 'racial',
        },
        'noisy': {
          'name': 'noisy',
          'rounds': 'racial',
        },
      },
    }
  };
  static const levelCaps = {
    1: 25,
    2: 50,
    3: 100,
    4: 150,
    5: 200,
    6: 250,
    7: 300,
    8: 350,
    9: 400,
    10: 500,
    11: 600,
    12: 700,
    13: 800,
    14: 900,
    15: 1000,
    16: 1100,
    17: 1200,
    18: 1300,
    19: 1400,
    20: 1500,
    21: 2000,
    22: 2500,
    23: 3000,
    24: 3500,
    25: 4000,
    26: 4500,
    27: 5000,
    28: 5500,
    29: 6000,
    30: 8000,
    31: 10000,
    32: 12000,
    33: 14000,
    34: 16000,
    35: 18000,
    36: 20000,
    37: 22000,
    38: 24000,
    39: 26000,
    40: 30000,
  };
}

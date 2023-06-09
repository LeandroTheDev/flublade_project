import 'dart:convert';

import 'package:flublade_project/data/gameplay/enemys.dart';
import 'package:flublade_project/data/global.dart';
import 'package:flublade_project/data/mysqldata.dart';

import 'package:bonfire/bonfire.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PlayerClient extends SimplePlayer with ObjectCollision {
  PlayerClient(
    Vector2 position,
    BuildContext context,
  ) : super(
          position: position,
          size: Vector2(32, 32),
          animation: SimpleDirectionAnimation(
            idleRight: ClassSpriteSheet.characterClass['${MySQL.returnInfo(context, returned: 'class')}idle'],
            runRight: ClassSpriteSheet.characterClass['${MySQL.returnInfo(context, returned: 'class')}run'],
          ),
          speed: 80,
        ) {
    setupCollision(
      CollisionConfig(
        collisions: [CollisionArea.circle(radius: 16, align: Vector2(-1, -1))],
      ),
    );
  }

  @override
  void update(double dt) async {
    super.update(dt);
    final gameplay = Provider.of<Gameplay>(context, listen: false);
    final options = Provider.of<Options>(context, listen: false);
    final position = jsonDecode(gameRef.player!.position.toString());

    final websocketMessage = await options.websocketSend({
      'message': 'playersPosition',
      'id': options.id,
      'positionX': position[0],
      'positionY': position[1],
      'direction': isIdle ? 'Direction.idle' : gameRef.player!.lastDirection.toString(),
      'location': gameplay.characters['character${gameplay.selectedCharacter}']['location'],
      'class': gameplay.characters['character${gameplay.selectedCharacter}']['class'],
    }, context);

    //Loading Check
    if (websocketMessage == "OK" || websocketMessage == "{}") {
      return;
    }
    //Result
    final players = jsonDecode(websocketMessage);
    players.remove("enemy");
    final enemy = jsonDecode(websocketMessage)['enemy'];

    //Update Users
    if (players != {}) {
      //Store old Values
      List oldUsers = [];
      gameplay.usersInWorld.forEach((key, value) => oldUsers.add(value));

      //Clean
      gameplay.usersHandle('replace', players);

      // Load New Values
      List users = [];
      gameplay.usersInWorld.forEach((key, value) => users.add(value));
      List idRemove = [];
      List idAdd = [];
      //Verify changes
      if (oldUsers.length != users.length) {
        //Sweep Users
        for (int i = 0; i < users.length; i++) {
          bool add = true;
          //Add Sweep
          if (oldUsers.length < users.length) {
            for (int j = 0; j < oldUsers.length; j++) {
              //If already exist
              if (users[i]['id'] == oldUsers[j]['id']) {
                add = false;
                break;
              }
            }
          } else {
            add = false;
          }
          //Add if not exist
          if (add && users[i]['positionX'] != null && users[i]['positionY'] != null) {
            idAdd.add(users[i]['id']);
            final positionX = double.parse(users[i]['positionX'].toString());
            final positionY = double.parse(users[i]['positionY'].toString());
            if (users[i]['id'] != options.id) {
              options.gameController.addGameComponent(
                  // ignore: use_build_context_synchronously
                  UserClient(users[i]['id'].toString(), Vector2(positionX, positionY), Direction.right, users[i]['class'], context));
            }
          }
        }
        //Sweep Old Users
        for (int i = 0; i < oldUsers.length; i++) {
          //Find if no longer online
          bool remove = true;
          for (int j = 0; j < users.length; j++) {
            if (oldUsers[i]['id'] == users[j]['id']) {
              remove = false;
              break;
            }
          }
          //Remove if no longer online
          if (remove) {
            idRemove.add(oldUsers[i]['id']);
          }
        }
      }
    }
    //Update Enemies
    if (enemy != {}) {
      //Store old Values
      List oldEnemies = [];
      gameplay.enemiesInWorld.forEach((key, value) => oldEnemies.add(value));

      //Clean
      gameplay.enemyHandle('replace', enemy);

      // Load New Values
      List enemies = [];
      gameplay.enemiesInWorld.forEach((key, value) => enemies.add(value));
      List idRemove = [];
      List idAdd = [];
      //Verify changes
      if (oldEnemies.length != enemies.length) {
        try {
          //Sweep enemies
          for (int i = 0; i < enemies.length; i++) {
            bool add = true;
            //Add Sweep
            if (oldEnemies.length < enemies.length) {
              for (int j = 0; j < oldEnemies.length; j++) {
                //If already exist
                if (enemies[i]['id'] == oldEnemies[j]['id']) {
                  add = false;
                  break;
                }
              }
            } else {
              add = false;
            }
            //Add if not exist
            if (add && enemies[i]['positionX'] != null && enemies[i]['positionY'] != null) {
              idAdd.add(enemies[i]['id']);
              final positionX = double.parse(enemies[i]['positionX'].toString());
              final positionY = double.parse(enemies[i]['positionY'].toString());
              if (enemies[i]['id'] != options.id) {
                options.gameController.addGameComponent(
                    // ignore: use_build_context_synchronously
                    ENEMY(
                        id: int.parse(enemies[i]['id'].toString()),
                        position: Vector2(positionX, positionY),
                        name: enemies[i]['name'],
                        life: double.parse(enemies[i]['life'].toString()),
                        mana: double.parse(enemies[i]['mana'].toString()),
                        damage: double.parse(enemies[i]['damage'].toString()),
                        armor: double.parse(enemies[i]['armor'].toString()),
                        level: enemies[i]['level'],
                        xp: double.parse(enemies[i]['xp'].toString()),
                        buffs: enemies[i]['buffs'],
                        skills: enemies[i]['skills']));
              }
            }
          }
          // //Sweep Old enemies
          // for (int i = 0; i < oldEnemies.length; i++) {
          //   //Find if no longer online
          //   bool remove = true;
          //   for (int j = 0; j < enemies.length; j++) {
          //     if (oldEnemies[i]['id'] == enemies[j]['id']) {
          //       remove = false;
          //       break;
          //     }
          //   }
          //   //Remove if no longer online
          //   if (remove) {
          //     idRemove.add(oldEnemies[i]['id']);
          //   }
          // }
        } catch (_) {}
      }
    }
  }
}

class UserClient extends SimpleEnemy {
  bool leftDirection = false;
  bool rightDirection = false;
  bool lastAnimation = false;
  bool animationLoad = false;
  int ticksDelays = 0;
  late final String id;
  late final String userClass;
  UserClient(
    this.id,
    Vector2 position,
    Direction direction,
    this.userClass,
    BuildContext context,
  ) : super(
          initDirection: direction,
          position: position,
          size: Vector2(32, 32),
          animation: SimpleDirectionAnimation(
            idleRight: ClassSpriteSheet.characterClass['${userClass}idle'],
            runRight: ClassSpriteSheet.characterClass['${userClass}run'],
          ),
        );

  @override
  void update(double dt) async {
    super.update(dt);
    //Verify if the user is alive
    final gameplay = Provider.of<Gameplay>(context, listen: false);
    List users = [];
    gameplay.usersInWorld.forEach((key, value) => users.add(value));
    bool remove = true;
    for (int i = 0; i < users.length; i++) {
      if (id == users[i]['id'].toString()) {
        remove = false;
      }
    }
    //Check is player disconnected
    if (remove) {
      die();
    } else {
      if (ticksDelays >= 1) {
        ticksDelays = 0;
        switch (gameplay.usersInWorld[id]['direction']) {
          case 'Direction.left':
            {
              if (!animationLoad) {
                animation?.play(SimpleAnimationEnum.runLeft);
                Future.delayed(const Duration(milliseconds: 400)).then((value) => animationLoad = false);
                animationLoad = true;
                lastAnimation = true;
              }
              return;
            }
          case 'Direction.downLeft':
            {
              if (!animationLoad) {
                animation?.play(SimpleAnimationEnum.runLeft);
                Future.delayed(const Duration(milliseconds: 400)).then((value) => animationLoad = false);
                animationLoad = true;
                lastAnimation = true;
              }
              return;
            }
          case 'Direction.upLeft':
            {
              if (!animationLoad) {
                animation?.play(SimpleAnimationEnum.runLeft);
                Future.delayed(const Duration(milliseconds: 400)).then((value) => animationLoad = false);
                animationLoad = true;
                lastAnimation = true;
              }
              return;
            }
          case 'Direction.right':
            {
              if (!animationLoad) {
                animation?.play(SimpleAnimationEnum.runRight);
                Future.delayed(const Duration(milliseconds: 400)).then((value) => animationLoad = false);
                animationLoad = true;
                lastAnimation = false;
              }
              return;
            }
          case 'Direction.downRight':
            {
              if (!animationLoad) {
                animation?.play(SimpleAnimationEnum.runRight);
                Future.delayed(const Duration(milliseconds: 400)).then((value) => animationLoad = false);
                animationLoad = true;
                lastAnimation = false;
              }
              return;
            }
          case 'Direction.upRight':
            {
              if (!animationLoad) {
                animation?.play(SimpleAnimationEnum.runRight);
                Future.delayed(const Duration(milliseconds: 400)).then((value) => animationLoad = false);
                animationLoad = true;
                lastAnimation = false;
              }
              return;
            }
          case 'Direction.idle':
            {
              if (lastAnimation) {
                animation!.play(SimpleAnimationEnum.idleLeft);
              } else {
                animation!.play(SimpleAnimationEnum.idleRight);
              }
              return;
            }
        }
      }
      //Update player posistion
      position = Vector2(
        double.parse(Provider.of<Gameplay>(context, listen: false).usersInWorld[id]['positionX'].toString()),
        double.parse(Provider.of<Gameplay>(context, listen: false).usersInWorld[id]['positionY'].toString()),
      );
    }
    ticksDelays += 1;
  }

  @override
  void die() {
    removeFromParent();
    super.die();
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
    'berserkidleL': SpriteAnimation.load(
      "players/berserk/berserk_ingame_idlerightL.png",
      SpriteAnimationData.sequenced(
        amount: 1,
        stepTime: 0.1,
        textureSize: Vector2(16, 16),
      ),
    ),
    'berserkrunL': SpriteAnimation.load(
      "players/berserk/berserk_ingame_runrightL.png",
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

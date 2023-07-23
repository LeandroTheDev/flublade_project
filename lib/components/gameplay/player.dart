// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flublade_project/components/engine.dart';
import 'package:flublade_project/components/gameplay/enemy.dart';
import 'package:flublade_project/components/gameplay/world_generation.dart';
import 'package:flublade_project/data/gameplay.dart';
import 'package:flublade_project/data/global.dart';
import 'package:flublade_project/data/mysqldata.dart';
import 'package:flublade_project/pages/mainmenu/main_menu.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

//
//  DOCS
//
// Player
// ---------------
// position -- variable that defines the player exact position (position.add() will increment the position like moving)
//
// joystick -- component receive from the game engine display a single joystick for moving the character
// and receives parameters for joystick position
//
// Moviment Declarations (xP,xN) will say if player can move or not

class Player extends SpriteAnimationComponent with HasGameRef, CollisionCallbacks {
  //Engine Declarations
  final BuildContext context;
  final JoystickComponent joystick;
  final Vector2 playerPosition;
  static const maxSpeed = 0.5;
  int timeoutHandle = 0;

  //Sprite Declarations
  late final SpriteAnimation spriteIdle;
  late final SpriteAnimation spriteRun;
  JoystickDirection spriteUpdate = JoystickDirection.idle;

  //Player Declaration
  Player(
    this.joystick,
    this.context,
    this.playerPosition,
  ) : super(
          size: Vector2.all(32.0),
        );

  //Loading
  @override
  Future<void> onLoad() async {
    //Define the player on top of everthing
    priority = 99;

    final imageLocation = 'players/${MySQL.returnInfo(context, returned: 'class')}/${MySQL.returnInfo(context, returned: 'class')}';
    //Idle Sprite
    gameRef.images.load('${imageLocation}_ingame_idleright.png').then((loadedSprite) {
      spriteIdle = SpriteAnimation.fromFrameData(
        loadedSprite,
        SpriteAnimationData.sequenced(
          amount: 1,
          textureSize: Vector2(16.0, 16.0),
          stepTime: 0.1,
        ),
      );
      animation = spriteIdle;
    });
    //Run Sprite
    gameRef.images.load('${imageLocation}_ingame_runright.png').then((loadedSprite) {
      spriteRun = SpriteAnimation.fromFrameData(
        loadedSprite,
        SpriteAnimationData.sequenced(
          amount: 4,
          textureSize: Vector2(16.0, 16.0),
          stepTime: 0.1,
        ),
      );
    });
    //Initial Position
    position = playerPosition;
    //Create a collision circle
    add(CircleHitbox(radius: 20, anchor: Anchor.center, position: size / 2, isSolid: true));
  }

  //Tick Update
  @override
  void update(double dt) async {
    super.update(dt);
    //Moviment Handler
    if (true) {
      switch (joystick.direction) {
        //Down
        case JoystickDirection.down:
          //Moviment
          position.add(Vector2(0.0, maxSpeed));
          animation = spriteRun;
          //Animation
          if (spriteUpdate != joystick.direction) {
            spriteUpdate = JoystickDirection.down;
          }
          break;
        //Down Left
        case JoystickDirection.downLeft:
          //Moviment
          position.add(Vector2(-(maxSpeed / 1.5), maxSpeed / 1.5));
          //Animation
          if (spriteUpdate != joystick.direction) {
            spriteUpdate = JoystickDirection.downLeft;
            animation = spriteRun;
            if (!isFlippedHorizontally) {
              flipHorizontally();
              position = position + Vector2(32.0, 0.0);
            }
          }
          break;
        //Downn Right
        case JoystickDirection.downRight:
          //Moviment
          position.add(Vector2(maxSpeed / 1.5, maxSpeed / 1.5));
          //Animation
          if (spriteUpdate != joystick.direction) {
            spriteUpdate = JoystickDirection.downRight;
            animation = spriteRun;
            if (isFlippedHorizontally) {
              flipHorizontally();
              position = position - Vector2(32.0, 0.0);
            }
          }
          break;
        //Left
        case JoystickDirection.left:
          //Moviment
          position.add(Vector2(-maxSpeed, 0.0));
          //Animation
          if (spriteUpdate != joystick.direction) {
            spriteUpdate = JoystickDirection.left;
            animation = spriteRun;
            if (!isFlippedHorizontally) {
              flipHorizontally();
              position = position + Vector2(32.0, 0.0);
            }
          }
          break;
        //Right
        case JoystickDirection.right:
          //Moviment
          position.add(Vector2(maxSpeed, 0.0));
          //Animation
          if (spriteUpdate != joystick.direction) {
            spriteUpdate = JoystickDirection.right;
            animation = spriteRun;
            if (isFlippedHorizontally) {
              flipHorizontally();
              position = position - Vector2(32.0, 0.0);
            }
          }
          break;
        //Up
        case JoystickDirection.up:
          //Moviment
          position.add(Vector2(0.0, -maxSpeed));
          animation = spriteRun;
          //Animation
          if (spriteUpdate != joystick.direction) {
            spriteUpdate = JoystickDirection.up;
          }
          break;
        case JoystickDirection.upLeft:
          //Moviment
          position.add(Vector2(-(maxSpeed / 1.5), -(maxSpeed / 1.5)));
          //Animation
          if (spriteUpdate != joystick.direction) {
            spriteUpdate = JoystickDirection.upLeft;
            animation = spriteRun;
            if (!isFlippedHorizontally) {
              flipHorizontally();
              position = position + Vector2(32.0, 0.0);
            }
          }
          break;
        case JoystickDirection.upRight:
          //Moviment
          position.add(Vector2(maxSpeed / 1.5, -(maxSpeed / 1.5)));
          //Animation
          if (spriteUpdate != joystick.direction) {
            spriteUpdate = JoystickDirection.upRight;
            animation = spriteRun;
            if (isFlippedHorizontally) {
              flipHorizontally();
              position = position - Vector2(32.0, 0.0);
            }
          }
          break;
        case JoystickDirection.idle:
          if (spriteUpdate != joystick.direction) {
            animation = spriteIdle;
          }
          break;
      }
    }
    //Connection
    if (true) {
      final gameplay = Provider.of<Gameplay>(context, listen: false);
      final options = Provider.of<Options>(context, listen: false);
      final websocket = Provider.of<Websocket>(context, listen: false);

      final websocketMessage = await websocket.websocketSendIngame({
        'message': 'playersPosition',
        'id': options.id,
        'positionX': position[0],
        'positionY': position[1],
        'direction': joystick.direction.toString(),
        'location': gameplay.characters['character${gameplay.selectedCharacter}']['location'],
        'class': gameplay.characters['character${gameplay.selectedCharacter}']['class'],
      }, context);
      //Loading Check
      if (websocketMessage == "OK" || websocketMessage == "timeout") {
        timeoutHandle += 1;
        if (timeoutHandle >= 300 && timeoutHandle < 900) {
          timeoutHandle = 1000;
          Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => const MainMenu()), (route) => false);
          websocket.disconnectWebsockets(context);
          GlobalFunctions.errorDialog(
            errorMsgTitle: 'authentication_lost_connection',
            errorMsgContext: 'You have lost connection to the servers.',
            context: context,
          );
          return;
        }
        return;
      }
      timeoutHandle = 0;
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

        //Load New Values
        List users = [];
        gameplay.usersInWorld.forEach((key, value) => users.add(value));
        List idRemove = [];
        List idAdd = [];
        //Add Function
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
              // final positionX = double.parse(users[i]['positionX'].toString());
              // final positionY = double.parse(users[i]['positionY'].toString());
              if (users[i]['id'] != options.id) {
                // gameRef
                //     .add(UserClient(users[i]['id'].toString(), Vector2(positionX, positionY), JoystickDirection.right, users[i]['class'], context));
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

        //Load New Values
        List enemies = [];
        gameplay.enemiesInWorld.forEach((key, value) => enemies.add(value));

        //Add Function
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
                //Add
                gameRef.add(
                  EnemyWithVision(
                    context,
                    int.parse(enemies[i]['id'].toString()),
                    enemies[i]['name'],
                    80.0,
                    20.0,
                    size: Vector2.all(32.0),
                  ),
                );
              }
            }
          } catch (_) {}
        }
      }
    }
  }

  @override
  void onCollisionStart(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollisionStart(intersectionPoints, other);
    //Check World Collisions
    if (other is WorldTile) {
      const speedMult = 2;
      switch (joystick.direction) {
        //Down
        case JoystickDirection.down:
          //Moviment
          position.add(Vector2(0.0, -maxSpeed * speedMult));
          break;
        //Down Left
        case JoystickDirection.downLeft:
          //Moviment
          position.add(Vector2(maxSpeed / 1.5 * 2, -maxSpeed / 1.5 * speedMult));
          break;
        //Downn Right
        case JoystickDirection.downRight:
          //Moviment
          position.add(Vector2(-maxSpeed / 1.5 * speedMult, -(maxSpeed / 1.5) * speedMult));
          break;
        //Left
        case JoystickDirection.left:
          //Moviment
          position.add(Vector2(maxSpeed * speedMult, 0.0));
          break;
        //Right
        case JoystickDirection.right:
          //Moviment
          position.add(Vector2(-maxSpeed * speedMult, 0.0));
          break;
        //Up
        case JoystickDirection.up:
          //Moviment
          position.add(Vector2(0.0, maxSpeed * speedMult));
          break;
        case JoystickDirection.upLeft:
          //Moviment
          position.add(Vector2(maxSpeed / 1.5 * speedMult, maxSpeed / 1.5 * speedMult));
          break;
        case JoystickDirection.upRight:
          //Moviment
          position.add(Vector2(-(maxSpeed / 1.5) * speedMult, maxSpeed / 1.5 * speedMult));
          break;
        case JoystickDirection.idle:
          break;
      }
    }
  }
}

// ignore_for_file: use_build_context_synchronously

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flublade_project/components/engine_deprecated.dart';
import 'package:flublade_project/components/gameplay/game_engine.dart';
import 'package:flublade_project/components/gameplay/world_generation.dart';
import 'package:flublade_project/data/gameplay.dart';
import 'package:flublade_project/data/server.dart';
import 'package:flublade_project/data/options.dart';
import 'package:flublade_project/data/settings.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

//Player Component will be the client player that provides the character moviment and colissions
class Player extends SpriteAnimationComponent with HasGameRef, CollisionCallbacks, ChangeNotifier {
  //Engine Declarations
  final BuildContext context;
  final Vector2 playerPosition;
  late Vector2 cameraPosition;
  late final GameEngine engine;
  late final Gameplay gameplay;
  late final Options options;
  late final Websocket websocket;
  late final Settings settings;

  //Moviment Declarations
  WorldTile lastCollision = WorldTile('tilesets/overworld/grass.png', Vector2(0.0, 0.0), Vector2(0.0, 0.0));
  double defaultSpeed = 0.5;
  double maxSpeed = 0.5;
  //left,right,up,down
  List<bool> collisionDirection = [false, false, false, false];

  //Player Declaration
  Player(this.context, this.playerPosition)
      : super(
          size: Vector2.all(32.0),
          position: playerPosition,
        ) {
    cameraPosition = playerPosition;
  }

  @override
  void onMount() {
    super.onMount();
    engine = Provider.of<GameEngine>(context, listen: false);
    gameplay = Provider.of<Gameplay>(context, listen: false);
    options = Provider.of<Options>(context, listen: false);
    websocket = Provider.of<Websocket>(context, listen: false);
    settings = Provider.of<Settings>(context, listen: false);
  }

  @override
  Future<void> onLoad() async {
    //Define the player on top of everthing
    priority = 100;
    //Create a collision circle
    add(CircleHitbox(radius: 16, anchor: Anchor.center, position: size / 2, isSolid: true));
    //-1 means that is the actual client
    add(PlayerSprite(context));
  }

  @override
  void update(double dt) async {
    super.update(dt);
    //Moviment Handler
    if (true) {
      //Moviment Speed
      double xSpeed = maxSpeed;
      double ySpeed = maxSpeed;
      //X Collision Check
      if (gameplay.joystickPosition[0] < 0 && collisionDirection[0]) {
        xSpeed = 0.0;
      }
      if (gameplay.joystickPosition[0] > 0 && collisionDirection[1]) {
        xSpeed = 0.0;
      }
      //Y Collision Check
      if (gameplay.joystickPosition[1] < 0 && collisionDirection[2]) {
        ySpeed = 0.0;
      }
      if (gameplay.joystickPosition[1] > 0 && collisionDirection[3]) {
        ySpeed = 0.0;
      }
      final moviment = Vector2(gameplay.joystickPosition[0] * xSpeed, gameplay.joystickPosition[1] * ySpeed);
      position.add(moviment);
      cameraPosition.add(moviment);
    }
  }

  @override
  void onCollisionStart(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollisionStart(intersectionPoints, other);
    //Check World Collisions
    if (other is WorldTile) {
      //Add Collisions
      collisionDirection = [
        gameplay.joystickPosition[0] < 0,
        gameplay.joystickPosition[0] > 0,
        gameplay.joystickPosition[1] < 0,
        gameplay.joystickPosition[1] > 0,
      ];
      lastCollision = other;
    }
  }

  @override
  void onCollisionEnd(PositionComponent other) {
    super.onCollisionEnd(other);
    if (other == lastCollision) {
      //Disable All Collisions
      collisionDirection = [
        false,
        false,
        false,
        false,
      ];
    }
  }
}

//Player Client are all the other players in the same world providing the position
class PlayerClient extends SpriteAnimationComponent with HasGameRef, CollisionCallbacks {
  //Engine Declarations
  final BuildContext context;
  final String id;
  late final Gameplay gameplay;

  //Animation Declarations
  String lastAnimation = 'Direction.right';
  bool animationLoad = false;

  PlayerClient(this.id, Vector2 playerPosition, this.context) : super(position: playerPosition, size: Vector2.all(32.0));

  @override
  void onMount() {
    super.onMount();
    gameplay = Provider.of<Gameplay>(context, listen: false);
  }

  @override
  Future<void> onLoad() async {
    priority = 50;
    add(PlayerClientSprite(context, id));
  }

  @override
  void update(double dt) {
    super.update(dt);
    //Check if disconnected
    if (gameplay.usersInWorld[id] == null) {
      removeFromParent();
      return;
    }
    //Animation Handle
    if (true) {
      //Position
      final positionX = double.parse(gameplay.usersInWorld[id]['positionX']);
      final positionY = double.parse(gameplay.usersInWorld[id]['positionY']);
      position = Vector2(positionX, positionY);
    }
  }
}

//Sprite Specific only for the Actual Player
class PlayerSprite extends SpriteAnimationComponent with HasGameRef {
  //Engine Declaration
  final BuildContext context;
  late final Gameplay gameplay;

  //Sprite Declarations
  late final SpriteAnimation spriteIdle;
  late final SpriteAnimation spriteRun;
  String lastDirection = 'left';

  PlayerSprite(this.context) : super(size: Vector2.all(32));

  @override
  void onMount() {
    super.onMount();
    gameplay = Provider.of<Gameplay>(context, listen: false);
  }

  @override
  Future<void> onLoad() async {
    final imageLocation = 'players/${Server.returnInfo(context, returned: 'class')}/${Server.returnInfo(context, returned: 'class')}';
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
  }

  @override
  void update(double dt) async {
    super.update(dt);
    //Check joystick moviment
    if (!(gameplay.joystickPosition[0] == 0.0 && gameplay.joystickPosition[1] == 0.0)) {
      animation = spriteRun;

      //Run Animation
      final actualDirection = gameplay.joystickPosition[0] > 0 ? 'left' : 'right';
      if (actualDirection != lastDirection) {
        lastDirection = actualDirection;
        if (!isFlippedHorizontally) {
          flipHorizontally();
          position = position + Vector2(32.0, 0.0);
        } else {
          flipHorizontally();
          position = position + Vector2(-32.0, 0.0);
        }
      }
    }
    //Idle Animation
    else {
      animation = spriteIdle;
    }
  }
}

//Sprite for the Player Client
class PlayerClientSprite extends SpriteAnimationComponent with HasGameRef {
  //Engine Declaration
  final BuildContext context;
  final String clientID;
  late final Gameplay gameplay;

  //Sprite Declarations
  late final SpriteAnimation spriteIdle;
  late final SpriteAnimation spriteRun;
  late final SpriteComponent inBattleSprite;
  bool isBattle = false;
  String lastDirection = 'Direction.right';

  PlayerClientSprite(this.context, this.clientID) : super(size: Vector2.all(32));

  @override
  void onMount() {
    super.onMount();
    gameplay = Provider.of<Gameplay>(context, listen: false);
  }

  @override
  Future<void> onLoad() async {
    final imageLocation = 'players/${Server.returnInfo(context, returned: 'class')}/${Server.returnInfo(context, returned: 'class')}';
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
    //Battle Image
    gameRef.images.load('interface/inBattle.png').then((loadedSprite) {
      inBattleSprite = SpriteComponent(sprite: Sprite(loadedSprite), size: Vector2.all(32));
    });
  }

  @override
  void update(double dt) async {
    super.update(dt);
    if (gameplay.usersInWorld[clientID] == null) {
      removeFromParent();
      return;
    }
    //Check if Client is in Battle
    if (gameplay.usersInWorld[clientID]['battleID'] > -1 && isBattle == false) {
      isBattle = true;
      add(inBattleSprite);
    } else if (gameplay.usersInWorld[clientID]['battleID'] < 0 && isBattle == true) {
      isBattle = false;
      remove(inBattleSprite);
    }

    //Check joystick moviment
    animation = spriteRun;
    //Run Animation
    final actualDirection = gameplay.usersInWorld[clientID]['direction'];
    //Change Sprite Position
    if (actualDirection != lastDirection && actualDirection != "Direction.idle") {
      lastDirection = actualDirection;
      if (!isFlippedHorizontally) {
        flipHorizontally();
        position = position + Vector2(32.0, 0.0);
      } else {
        flipHorizontally();
        position = position + Vector2(-32.0, 0.0);
      }
    }
    //Verifiy if is idle
    if (actualDirection == "Direction.idle") {
      animation = spriteIdle;
    }
  }
}

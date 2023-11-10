// import 'dart:async';
// import 'dart:convert';

// import 'package:flame/collisions.dart';
// import 'package:flame/components.dart';
// import 'package:flublade_project/components/engine_deprecated.dart';
// import 'package:flublade_project/data/gameplay.dart';
// import 'package:flublade_project/data/options.dart';
// import 'package:flublade_project/pages/gameplay/battle_scene.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';

// class Enemy extends SpriteAnimationComponent with HasGameRef, CollisionCallbacks {
//   //Engine Declarations
//   final BuildContext context;
//   late final Websocket websocket;
//   late final Options options;
//   late final Gameplay gameplay;
//   //Engine Animation Declarations
//   int ticksDelays = 0;
//   bool animationLoad = false;

//   //Info Declarations
//   final int enemyID;
//   final String enemyName;
//   final double enemyCollideRadius;

//   //Sprite Declarations
//   late final SpriteAnimation spriteLeft;
//   late final SpriteAnimation spriteRight;
//   late final SpriteAnimation spriteUp;
//   late final SpriteAnimation spriteDown;

//   Enemy(this.context, this.enemyID, this.enemyName, this.enemyCollideRadius)
//       : super(
//           size: Vector2.all(32.0),
//         );

//   @override
//   void onMount() {
//     super.onMount();
//     //Provider Declarations
//     websocket = Provider.of<Websocket>(context, listen: false);
//     options = Provider.of<Options>(context, listen: false);
//     gameplay = Provider.of<Gameplay>(context, listen: false);
//   }

//   @override
//   Future<void> onLoad() async {
//     //Sprite Right
//     gameRef.images.load("enemys/${enemyName}_sprite_right.png").then((loadedSprite) {
//       spriteRight = SpriteAnimation.fromFrameData(
//         loadedSprite,
//         SpriteAnimationData.sequenced(
//           amount: 1,
//           textureSize: Vector2(16.0, 16.0),
//           stepTime: 0.1,
//         ),
//       );
//       animation = spriteRight;
//     });
//     //Sprite Left
//     gameRef.images.load("enemys/${enemyName}_sprite_left.png").then((loadedSprite) {
//       spriteLeft = SpriteAnimation.fromFrameData(
//         loadedSprite,
//         SpriteAnimationData.sequenced(
//           amount: 1,
//           textureSize: Vector2(16.0, 16.0),
//           stepTime: 0.1,
//         ),
//       );
//     });
//     //Sprite Up
//     gameRef.images.load("enemys/${enemyName}_sprite_up.png").then((loadedSprite) {
//       spriteUp = SpriteAnimation.fromFrameData(
//         loadedSprite,
//         SpriteAnimationData.sequenced(
//           amount: 1,
//           textureSize: Vector2(16.0, 16.0),
//           stepTime: 0.1,
//         ),
//       );
//     });
//     //Sprite Down
//     gameRef.images.load("enemys/${enemyName}_sprite_down.png").then((loadedSprite) {
//       spriteDown = SpriteAnimation.fromFrameData(
//         loadedSprite,
//         SpriteAnimationData.sequenced(
//           amount: 1,
//           textureSize: Vector2(16.0, 16.0),
//           stepTime: 0.1,
//         ),
//       );
//     });

//     //Touch Hibox
//     add(CircleHitbox(radius: enemyCollideRadius, anchor: Anchor.center, position: size / 2));
//   }

//   @override
//   void update(double dt) {
//     super.update(dt);
//     //Provider Declarations
//     final gameplay = Provider.of<Gameplay>(context, listen: false);

//     //Animation
//     if (ticksDelays >= 1) {
//       ticksDelays = 0;
//       switch (gameplay.enemiesInWorld["enemy$enemyID"]['direction']) {
//         case 'Direction.left':
//           if (!animationLoad) {
//             animation = spriteLeft;
//             animationLoad = true;
//             Future.delayed(const Duration(milliseconds: 400)).then((value) => animationLoad = false);
//           }
//           break;
//         case 'Direction.downLeft':
//           if (!animationLoad) {
//             animation = spriteDown;
//             animationLoad = true;
//             Future.delayed(const Duration(milliseconds: 400)).then((value) => animationLoad = false);
//           }
//           break;
//         case 'Direction.upLeft':
//           if (!animationLoad) {
//             animation = spriteUp;
//             animationLoad = true;
//             Future.delayed(const Duration(milliseconds: 400)).then((value) => animationLoad = false);
//           }
//           break;
//         case 'Direction.right':
//           if (!animationLoad) {
//             animation = spriteRight;
//             Future.delayed(const Duration(milliseconds: 400)).then((value) => animationLoad = false);
//             animationLoad = true;
//           }
//           break;
//         case 'Direction.downRight':
//           if (!animationLoad) {
//             animation = spriteDown;
//             animationLoad = true;
//             Future.delayed(const Duration(milliseconds: 400)).then((value) => animationLoad = false);
//           }
//           break;
//         case 'Direction.upRight':
//           if (!animationLoad) {
//             animation = spriteUp;
//             animationLoad = true;
//             Future.delayed(const Duration(milliseconds: 400)).then((value) => animationLoad = false);
//           }
//           break;
//         case 'Direction.idle':
//           break;
//       }
//     }
//     ticksDelays += 1;
//   }

//   @override
//   void onCollisionStart(Set<Vector2> intersectionPoints, PositionComponent other) {
//     super.onCollisionStart(intersectionPoints, other);
//     //If not in battle
//     //String = Player
//     if (other is String && !gameplay.alreadyInBattle) {
//       //Remove from world
//       gameplay.enemiesInWorld['enemy$enemyID']['isDead'] = true;
//       gameplay.changeAlreadyInBattle(true);
//       //Remove enemy from the world
//       websocket.websocketOnlySendIngame({
//         'message': 'playerCollide',
//         'id': options.id,
//         'location': gameplay.characters['character${gameplay.selectedCharacter}']['location'],
//         'enemyID': enemyID,
//       }, context);
//       //Push to battle scene
//       Navigator.push(
//         context,
//         MaterialPageRoute(builder: (context) => BattleScene(enemyID: enemyID)),
//       );
//     }
//     //If in battle
//     //Strig = Player
//     else if (other is String && gameplay.alreadyInBattle) {
//       //Remove from world
//       gameplay.enemiesInWorld['enemy$enemyID']['isDead'] = true;
//       Future.delayed(const Duration(seconds: 1)).then((value) => {
//             //Remove enemy from the world
//             websocket.websocketOnlySendIngame({
//               'message': 'playerCollide',
//               'id': options.id,
//               'location': gameplay.characters['character${gameplay.selectedCharacter}']['location'],
//               'enemyID': enemyID,
//             }, context),
//             //Add enemy to the lobby
//             websocket.websocketOnlySendBattle({
//               'message': 'newEnemy',
//               'enemyID': enemyID,
//             }, context),
//           });
//       gameplay.changeAlreadyInBattle(true);
//     }
//   }
// }

// class EnemyWithVision extends PositionComponent with CollisionCallbacks {
//   //Engine Declarations
//   final BuildContext context;
//   late final Websocket websocket;
//   late final Options options;
//   late final Gameplay gameplay;
//   int collisionQuantity = 0;

//   //Info Declarations
//   final int enemyID;
//   final String enemyName;
//   final double enemyVisionRadius;
//   final double enemyCollisionRadius;
//   int indexChasing = -1;

//   EnemyWithVision(this.context, this.enemyID, this.enemyName, this.enemyVisionRadius, this.enemyCollisionRadius, {required Vector2 size}) : super(size: size);

//   @override
//   void onMount() {
//     super.onMount();
//     websocket = Provider.of<Websocket>(context, listen: false);
//     options = Provider.of<Options>(context, listen: false);
//     gameplay = Provider.of<Gameplay>(context, listen: false);
//   }

//   @override
//   Future<void> onLoad() async {
//     //View HitBox
//     add(CircleHitbox(radius: enemyVisionRadius, anchor: Anchor.center, position: size / 2));
//     add(CircleHitbox(radius: enemyVisionRadius * 0.7, anchor: Anchor.center, position: size / 2));
//     add(CircleHitbox(radius: enemyVisionRadius * 0.4, anchor: Anchor.center, position: size / 2));

//     //Enemy in Child
//     add(
//       Enemy(context, enemyID, enemyName, enemyCollisionRadius),
//     );
//   }

//   @override
//   void update(double dt) {
//     super.update(dt);
//     //Provider Declarations
//     final gameplay = Provider.of<Gameplay>(context, listen: false);
//     //Verify if is dead
//     if (gameplay.enemiesInWorld['enemy$enemyID']['isDead']) {
//       removeFromParent();
//       return;
//     }
//     //Update enemy position
//     position = Vector2(
//       double.parse(gameplay.enemiesInWorld['enemy$enemyID']['positionX'].toString()),
//       double.parse(gameplay.enemiesInWorld['enemy$enemyID']['positionY'].toString()),
//     );
//   }

//   @override
//   void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
//     super.onCollision(intersectionPoints, other);
//     //String = Player
//     if (other is String) {
//       //Error Treatment
//       try {
//         //Verify if is wrong id and throw error
//         if (gameplay.enemiesChasing[indexChasing] != enemyID) {
//           throw Exception("different_id");
//         }
//       } catch (e) {
//         //Verify if is wrong id
//         if (e.toString().contains("different_id")) {
//           //Fix wrong id
//           gameplay.updateSpecificEnemiesChasing(indexChasing, enemyID);
//         } else {
//           final newIndex = gameplay.findSpecificEnemiesChasing(enemyID);
//           //Verify if is in wrong index
//           if (newIndex >= 0) {
//             //Fix wrong index
//             indexChasing = newIndex;
//           } else {
//             //Unkown Error Remove Enemy
//             removeFromParent();
//           }
//         }
//       }
//       //Message The Server
//       websocket.websocketOnlySendIngame({
//         'message': 'enemyMoving',
//         'id': options.id,
//         'location': gameplay.characters['character${gameplay.selectedCharacter}']['location'],
//         'enemyID': jsonEncode(gameplay.enemiesChasing),
//         'isSee': true,
//       }, context);
//     }
//   }

//   @override
//   void onCollisionStart(Set<Vector2> intersectionPoints, PositionComponent other) {
//     super.onCollisionStart(intersectionPoints, other);
//     //String = Player
//     if (other is String) {
//       //Add enemy into chasing array
//       if (collisionQuantity == 0) {
//         indexChasing = gameplay.addEnemiesChasing(enemyID);
//       }
//       collisionQuantity++;
//     }
//   }

//   @override
//   void onCollisionEnd(PositionComponent other) {
//     super.onCollisionEnd(other);
//     //String = Player
//     if (other is String) {
//       collisionQuantity--;
//       //Remove enemy from chasing array
//       if (collisionQuantity == 0) {
//         gameplay.removeSpecificEnemiesChasing(indexChasing);
//       }
//       //Message The Server
//       websocket.websocketOnlySendIngame({
//         'message': 'enemyMoving',
//         'id': options.id,
//         'location': gameplay.characters['character${gameplay.selectedCharacter}']['location'],
//         'enemyID': enemyID,
//         'isSee': false,
//       }, context);
//     }
//   }
// }

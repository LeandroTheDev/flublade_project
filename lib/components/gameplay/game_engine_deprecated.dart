// // ignore_for_file: use_build_context_synchronously

// import 'package:flame/components.dart';
// import 'package:flame/game.dart';
// import 'dart:async' as dart;
// import 'dart:convert';

// import 'package:flublade_project/components/gameplay/world_generation.dart';
// import 'package:flublade_project/components/engine_deprecated.dart';
// import 'package:flublade_project/components/system/dialogs.dart';
// import 'package:flublade_project/data/gameplay.dart';
// import 'package:flublade_project/data/server.dart';
// import 'package:flublade_project/data/options.dart';
// import 'package:flublade_project/pages/mainmenu/main_menu.dart';
// import 'package:flutter/material.dart';

// import 'package:provider/provider.dart';

// class NavigatorEngineDeprecated extends FlameGame with HasCollisionDetection, ChangeNotifier, HasGameRef {
//   //Engine Declarations
//   late final BuildContext context;
//   late final Engine baseEngine;
//   late final NavigatorEngineDeprecated engine;
//   late final Gameplay gameplay;
//   late final Options options;
//   late final Websocket websocket;
//   bool engineLoaded = false;

//   //-----
//   // PROVIDER VARIABLES
//   //-----

//   //Player Joystick Position
//   Vector2 _joystickPosition = Vector2(0.0, 0.0);
//   get joystickPosition => _joystickPosition;

//   //Player in the world
//   //SpriteComponent = Player
//   late SpriteComponent player;

//   //Ingame Connection Variables
//   bool _stopConnection = false;
//   get pauseConnection => _stopConnection;
//   late dart.Timer _connection;
//   get connection => _connection;
//   int _msLag = 0;
//   get msLag => _msLag;

//   //-----
//   // PROVIDER FUNCTIONS
//   //-----

//   //Change Pause Ingame Connection
//   void changeStopIngameConnection(bool value) {
//     _stopConnection = value;
//   }

//   //Close Connection
//   void closeConnection() {
//     _connection.cancel();
//   }

//   //Set Joystick Position
//   void setjoystickPosition(value) {
//     _joystickPosition = value;
//   }

//   //Set Context
//   void setContext(BuildContext value) {
//     context = value;
//   }

//   //-----
//   // STARTING ENGINE
//   //-----

//   @override
//   void onMount() async {
//     super.onMount();
//     baseEngine = Provider.of<Engine>(context, listen: false);
//     engine = Provider.of<NavigatorEngineDeprecated>(context, listen: false);
//     websocket = Provider.of<Websocket>(context, listen: false);
//     options = Provider.of<Options>(context, listen: false);
//     gameplay = Provider.of<Gameplay>(context, listen: false);
//     //Connection Signal
//     Future<void> connectionSignal(context) async {
//       await websocket.websocketSendIngame(
//         {
//           'message': 'login',
//           'id': options.id,
//           'location': gameplay.characters['character${gameplay.selectedCharacter}']['location'],
//           'class': gameplay.characters['character${gameplay.selectedCharacter}']['class'],
//           'selectedCharacter': gameplay.selectedCharacter,
//           'token': options.token,
//         },
//         context,
//       ).then((value) {
//         //Connection Repeater
//         int timeoutHandle = 0;
//         bool waitConnectionSignal = false;
//         String direction = 'Direction.right';
//         _connection = dart.Timer.periodic(const Duration(milliseconds: 1), (timer) async {
//           //Signal to the server and update the game
//           if ((!_stopConnection && engineLoaded) && !waitConnectionSignal) {
//             waitConnectionSignal = true;
//             //Ping Delay Declaration
//             int connectionDelay = 0;
//             final connetionTimer = dart.Timer.periodic(const Duration(milliseconds: 1), (timer) {
//               connectionDelay++;
//             });
//             //Direction Translate
//             if (engine.joystickPosition[0] < 0.0) {
//               direction = 'Direction.left';
//             } else if (engine.joystickPosition[0] > 0.0) {
//               direction = 'Direction.right';
//             } else {
//               direction = 'Direction.idle';
//             }
//             //Server Signal
//             final websocketMessage = await websocket.websocketSendIngame({
//               'message': 'playersPosition',
//               'id': options.id,
//               'positionX': player.position[0],
//               'positionY': player.position[1],
//               'direction': direction,
//               'location': gameplay.characters['character${gameplay.selectedCharacter}']['location'],
//               'class': gameplay.characters['character${gameplay.selectedCharacter}']['class'],
//             }, context);

//             //Lost Connection Check
//             if (websocketMessage == "OK" || websocketMessage == "timeout") {
//               timeoutHandle++;
//               if (timeoutHandle > 500) {
//                 if (_connection.isActive) {
//                   try {
//                     Dialogs.alertDialog(
//                         context: context,
//                         message: 'authentication_lost_connection',
//                         cancel: false,
//                         returnFunction: (BuildContext context) {
//                           //Close Dialog
//                           Navigator.pop(context);

//                           closeConnection();
//                           Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => const MainMenu()), (route) => false);
//                           websocket.disconnectWebsockets(context);
//                         });
//                     return;
//                   } catch (_) {}
//                 }
//               }
//               waitConnectionSignal = false;
//               return;
//             }
//             //Disconnection Check
//             else if (websocketMessage == "disconnected") {
//               closeConnection();
//               websocket.disconnectWebsockets(context);
//               return;
//             }

//             //Result
//             final players = jsonDecode(websocketMessage);
//             final enemy = jsonDecode(websocketMessage)['enemy'];
//             //Update Users
//             if (players != {}) {
//               players.remove("enemy");
//               //Store old Values
//               List oldUsers = [];
//               gameplay.usersInWorld.forEach((key, value) => oldUsers.add(value));

//               //Clean
//               gameplay.usersHandle('replace', players);

//               //Load New Values
//               List users = [];
//               gameplay.usersInWorld.forEach((key, value) => users.add(value));
//               List idRemove = [];
//               List idAdd = [];
//               //Add Function
//               if (oldUsers.length != users.length) {
//                 //Sweep Users
//                 for (int i = 0; i < users.length; i++) {
//                   bool add = true;
//                   //Add Sweep
//                   if (oldUsers.length < users.length) {
//                     for (int j = 0; j < oldUsers.length; j++) {
//                       //If already exist
//                       if (users[i]['id'] == oldUsers[j]['id']) {
//                         add = false;
//                         break;
//                       }
//                     }
//                   } else {
//                     add = false;
//                   }
//                   //Add if not exist
//                   if (add && users[i]['positionX'] != null && users[i]['positionY'] != null) {
//                     idAdd.add(users[i]['id']);
//                     // final positionX = double.parse(users[i]['positionX'].toString());
//                     // final positionY = double.parse(users[i]['positionY'].toString());
//                     if (users[i]['id'] != options.id) {
//                       // gameRef.add(PlayerClient(users[i]['id'].toString(), Vector2(positionX, positionY), context));
//                     }
//                   }
//                 }
//                 //Sweep Old Users
//                 for (int i = 0; i < oldUsers.length; i++) {
//                   //Find if no longer online
//                   bool remove = true;
//                   for (int j = 0; j < users.length; j++) {
//                     if (oldUsers[i]['id'] == users[j]['id']) {
//                       remove = false;
//                       break;
//                     }
//                   }
//                   //Remove if no longer online
//                   if (remove) {
//                     idRemove.add(oldUsers[i]['id']);
//                   }
//                 }
//               }
//             }
//             //Update Enemies
//             if (enemy != {} && enemy != null) {
//               //Store old Values
//               List oldEnemies = [];
//               gameplay.enemiesInWorld.forEach((key, value) => oldEnemies.add(value));

//               //Clean
//               gameplay.enemyHandle('replace', enemy);

//               //Load New Values
//               List enemies = [];
//               gameplay.enemiesInWorld.forEach((key, value) => enemies.add(value));

//               //Add Function
//               if (oldEnemies.length != enemies.length) {
//                 try {
//                   //Sweep enemies
//                   for (int i = 0; i < enemies.length; i++) {
//                     bool add = true;
//                     //Add Sweep
//                     if (oldEnemies.length < enemies.length) {
//                       for (int j = 0; j < oldEnemies.length; j++) {
//                         //If already exist
//                         if (enemies[i]['id'] == oldEnemies[j]['id']) {
//                           add = false;
//                           break;
//                         }
//                       }
//                     } else {
//                       add = false;
//                     }
//                     //Add if not exist
//                     if (add && enemies[i]['positionX'] != null && enemies[i]['positionY'] != null) {
//                       //Add
//                       // gameRef.add(
//                       //   EnemyWithVision(
//                       //     context,
//                       //     int.parse(enemies[i]['id'].toString()),
//                       //     enemies[i]['name'],
//                       //     80.0,
//                       //     20.0,
//                       //     size: Vector2.all(32.0),
//                       //   ),
//                       // );
//                     }
//                   }
//                 } catch (_) {}
//               }
//             }

//             //Ping Delay Update
//             connetionTimer.cancel();
//             _msLag = connectionDelay;
//             waitConnectionSignal = false;
//           }
//           //Cancels the Repeater
//           else if (_stopConnection) {
//             _connection.cancel();
//           }
//         });
//       });
//     }

//     await connectionSignal(context);
//   }

//   @override
//   Future<void> onLoad() async {
//     //Player Creation
//     // player = Player(context, Vector2(48.0, 180.0));
//     //Add Components
//     add(player);
//     //Camera
//     camera.follow(player);
//     //World Loading
//     ServerGameplay.returnLevel(context: context, level: Server.returnInfo(context, returned: 'location')).then((value) {
//       final worldGeneration = WorldGeneration();
//       worldGeneration.generateWorld(value, baseEngine.gameController);
//     });
//     engineLoaded = true;
//   }
// }

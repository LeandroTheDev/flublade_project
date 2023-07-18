// ignore_for_file: use_build_context_synchronously

import 'dart:async';
import 'dart:convert';

import 'package:flublade_project/components/gameplay/game_engine.dart';

import 'package:flutter/material.dart';
import 'package:web_socket_channel/io.dart';

import '../data/global.dart';

class Engine with ChangeNotifier {
  //Declaration
  late GameEngine _gameController;
  late BuildContext _context;

  //Receive
  GameEngine get gameController => _gameController;
  BuildContext get context => _context;

  void initGameController(context) {
    _gameController = GameEngine(context);
    _context = context;
  }
}

class Websocket with ChangeNotifier {
  //Declaration
  late IOWebSocketChannel _websocketIngame;
  late StreamSubscription _broadcastIngame;
  late IOWebSocketChannel _websocketBattle;
  late StreamSubscription _broadcastBattle;
  bool _disconnectIngame = false;
  bool _disconnectBattle = false;

  //Receive
  IOWebSocketChannel get websocketIngame => _websocketIngame;
  StreamSubscription get broadcastIngame => _broadcastIngame;
  IOWebSocketChannel get websocketBattle => _websocketBattle;
  StreamSubscription get broadcastBattle => _broadcastBattle;
  bool get disconnectIngame => _disconnectIngame;
  bool get disconnectBattle => _disconnectBattle;

  //Disconnect the websockets
  void disconnectWebsockets(context) {
    websocketDisconnectBattle(context);
    websocketDisconnectIngame(context);
  }

  //--------------------------------------------------------

  //Websocket Ingame Initialize
  void websocketInitIngame(context) {
    _disconnectIngame = false;
    _websocketIngame = IOWebSocketChannel.connect(
      'ws://${SaveDatas.getServerAddress()}:8081',
    );

    //Listen from the server
    _broadcastIngame = _websocketIngame.stream.asBroadcastStream().listen(
          (data) {},
          onError: (error) => GlobalFunctions.errorDialog(
            errorMsgTitle: ':(',
            errorMsgContext: 'authentication_invalidlogin',
            context: context,
            popUntil: "/authenticationpage",
          ),
        );
  }

  //Websocket Ingame Send Mensage
  Future<String> websocketSendIngame(value, context) async {
    if (_disconnectIngame) {
      return "timeout";
    }
    _websocketIngame.sink.add(jsonEncode(value));
    final result = await websocketListenIngame(context);
    return result;
  }

  //Websocket Ingame Send Mensage
  Future<void> websocketOnlySendIngame(value, context) async {
    if (_disconnectIngame) {
      return;
    }
    _websocketIngame.sink.add(jsonEncode(value));
  }

  //Websocket Ingame Receive Mensage
  Future<String> websocketListenIngame(context) async {
    String result = '';
    int ticks = 0;
    _broadcastIngame.onData((data) {
      result = data;
    });
    //Latency waiter
    while (true) {
      //Result
      if (result != '') {
        return result;
      }
      await Future.delayed(const Duration(milliseconds: 1));
      //Timeout
      ticks += 1;
      if (ticks > 200) {
        return 'timeout';
      }
    }
  }

  //Websocket Ingame Disconnect
  void websocketDisconnectIngame(context) async {
    try {
      _disconnectIngame = true;
      _websocketIngame.sink.close();
    } catch (_) {
      return;
    }
  }

  //--------------------------------------------------------

  //Websocket Battle Initialize
  void websocketInitBattle(context) {
    _disconnectBattle = false;
    _websocketBattle = IOWebSocketChannel.connect(
      'ws://${SaveDatas.getServerAddress()}:8082',
    );

    //Listen from the server
    _broadcastBattle = _websocketBattle.stream.asBroadcastStream().listen((data) {}, onError: (error) => GlobalFunctions.errorDialog(errorMsgTitle: ':(', errorMsgContext: 'authentication_invalidlogin', context: context, popUntil: "/authenticationpage"));
  }

  //Websocket Battle Send Mensage
  Future<String> websocketSendBattle(value, context) async {
    if (_disconnectBattle) {
      return "timeout";
    }
    _websocketBattle.sink.add(jsonEncode(value));
    final result = await websocketListenBattle(context);
    return result;
  }

  //Websocket Battle Send Mensage
  Future<void> websocketOnlySendBattle(value, context) async {
    if (_disconnectBattle) {
      return;
    }
    _websocketBattle.sink.add(jsonEncode(value));
  }

  //Websocket Battle Receive Mensage
  Future<String> websocketListenBattle(context, [bool wait = false]) async {
    String result = '';
    int ticks = 0;
    _broadcastBattle.onData((data) {
      result = data;
    });
    //Latency waiter
    while (true) {
      //Result
      if (result != '') {
        return result;
      }
      await Future.delayed(const Duration(milliseconds: 1));
      //Timeout
      ticks += 1;
      if (ticks > 2000 && !wait || _disconnectBattle) {
        return 'timeout';
      }
    }
  }

  //Websocket Battle Disconnect
  void websocketDisconnectBattle(context) async {
    try {
      _disconnectBattle = true;
      _websocketBattle.sink.close();
    } catch (_) {
      return;
    }
  }
}

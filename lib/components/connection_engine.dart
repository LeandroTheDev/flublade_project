import 'dart:async';
import 'dart:convert';

import 'package:flublade_project/components/system/dialogs.dart';
import 'package:flublade_project/data/savedatas.dart';
import 'package:flublade_project/data/options.dart';
import 'package:flublade_project/data/server.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:web_socket_channel/io.dart';

import '../pages/gameplay/navigator.dart';

class ConnectionEngine {
  ///Navigator Socket
  late final IOWebSocketChannel navigatorSocket;

  ///Navigator Broadcast to listen the listenNavigator
  late final StreamSubscription navigatorBroadcast;

  ///User credentials to check account validation
  late final Map userConnectionData;

  ///This function is called every time the navigator socket returns a value
  late Function listenNavigator;

  ///Check if connection is lost or if the client asked for disconnection
  bool manuallyClosed = false;

  ///Initialize the navigator socket
  ///
  ///context = buildcontext of your actual application
  ///
  ///success = is the function called when the server returns the handshake
  void initNavigatorSocket(BuildContext context, Function success) {
    listenNavigator = success;
    final options = Provider.of<Options>(context, listen: false);
    //HandShake with Navigator
    try {
      navigatorSocket = IOWebSocketChannel.connect(
        'ws://${SaveDatas.getServerAddress()}:8081',
      );
    } catch (error) {
      Dialogs.errorDialog(errorMsg: 'authentication_lost_connection', context: context);
      return;
    }
    //Start Listening
    navigatorBroadcast = navigatorSocket.stream.asBroadcastStream().listen(
          (data) => listenNavigator(data),
          onError: (error) => Dialogs.errorDialog(errorMsg: 'authentication_invalidlogin', context: context),
          onDone: () {
            if (!manuallyClosed) {
              Dialogs.errorDialog(errorMsg: 'authentication_lost_connection', context: context);
            }
          },
        );
    //Send Login Message
    userConnectionData = {
      "job": "authenticate",
      "id": options.id,
      "token": options.token,
    };
    navigatorSocket.sink.add(json.encode(userConnectionData));
  }

  ///Procceed Navigator Initilization sending a message to the server indicanting that you are ready
  ///to receive world data
  void startNavigatorSocket() {
    listenNavigator = (data) {};
    userConnectionData["job"] = "receiveDatas";
    navigatorSocket.sink.add(json.encode(userConnectionData));
  }

  ///Close the Navigator Socket
  void closeNavigatorSocket() {
    manuallyClosed = true;
    navigatorSocket.sink.close();
  }

  ///Start the Gameplay
  void start(BuildContext context, int selectedCharacterIndex) {
    Dialogs.loadingDialog(context: context);
    initNavigatorSocket(context, (data) {
      //Check Errors
      if (!Server.errorTreatment(json.decode(data)["message"], context)) return;

      // //Remove Loading Dialog
      Navigator.pop(context);
      //Change Page to Gameplay
      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => GameplayNavigator(this)), (route) => false);
    });
  }
}

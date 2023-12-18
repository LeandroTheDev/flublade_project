import 'dart:async';
import 'dart:convert';

import 'package:flublade_project/components/system/dialogs.dart';
import 'package:flublade_project/data/gameplay.dart';
import 'package:flublade_project/data/savedatas.dart';
import 'package:flublade_project/data/options.dart';
import 'package:flublade_project/data/server.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:web_socket_channel/io.dart';

import '../pages/gameplay/navigator.dart';

class ConnectionEngine {
  ///Gameplay Provider
  late final Gameplay gameplay;

  ///Navigator Socket
  late final IOWebSocketChannel navigatorSocket;

  ///Navigator Broadcast to listen the listenNavigator
  late final StreamSubscription navigatorBroadcast;

  ///User credentials to check account validation
  late final Map userConnectionData;

  ///Check if connection is lost or if the client asked for disconnection
  bool manuallyClosed = false;

  ///Initialize the navigator socket to estabilish connection,
  ///this doesnt need to be called at any time, the "start" function already call this.
  ///
  ///context = buildcontext of your actual application
  ///
  ///success = is the function called when the server returns the handshake
  void initNavigatorSocket(BuildContext context, Function success) {
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
          null,
          onError: (error) => Dialogs.errorDialog(errorMsg: 'authentication_invalidlogin', context: context),
          onDone: () {
            if (!manuallyClosed) {
              Dialogs.errorDialog(errorMsg: 'authentication_lost_connection', context: context);
            }
          },
        );
    navigatorBroadcast.onData((data) => success(data));
    //Send Login Message
    userConnectionData = {
      "job": "authenticate",
      "id": options.id,
      "token": options.token,
    };
    navigatorSocket.sink.add(json.encode(userConnectionData));
  }

  ///Procceed Navigator Initilization sending a message to the server indicanting that you are ready
  ///to receive world data, the listen function will be called every time the server returns the world data,
  ///the function have a data parameter containing the Map from world data
  void startNavigatorSocket(BuildContext context, Function listen) {
    navigatorBroadcast.onData((data) => listen(data));
    //Create the Data to send
    userConnectionData["job"] = "receiveDatas";
    final sendData = {"selectedCharacter": gameplay.selectedCharacter};
    //Convert and Send to the Server
    navigatorSocket.sink.add(json.encode({...userConnectionData, ...sendData}));
  }

  ///Close the Navigator Socket
  void closeNavigatorSocket() {
    manuallyClosed = true;
    navigatorSocket.sink.close();
  }

  ///Start the Gameplay
  void start(BuildContext context, int selectedCharacterIndex) {
    gameplay = Provider.of<Gameplay>(context, listen: false);
    //Change Selected Character ID
    gameplay.changeCharacterId(selectedCharacterIndex);

    //Loading Dialog
    Dialogs.loadingDialog(context: context);

    //Start Socket
    initNavigatorSocket(context, (data) {
      //Check Errors
      if (!Server.errorTreatment(json.decode(data)["message"], context)) {
        closeNavigatorSocket();
        gameplay.resetVariables();
        return;
      }
      //Remove Loading Dialog
      Navigator.pop(context);
      //Change Page to Gameplay
      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => GameplayNavigator(this)), (route) => false);
    });
  }
}

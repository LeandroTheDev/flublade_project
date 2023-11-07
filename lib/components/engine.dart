import 'dart:async';
import 'dart:convert';

import 'package:flublade_project/components/system/dialogs.dart';
import 'package:flublade_project/data/savedatas.dart';
import 'package:flublade_project/data/options.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:web_socket_channel/io.dart';

class Engine {
  late final IOWebSocketChannel navigatorSocket;
  late final StreamSubscription navigatorBroadcast;
  late final Map userConnectionData;
  late Function listen;
  bool manuallyClosed = false;

  ///Initialize the navigator socket
  ///
  ///context = buildcontext of your actual application
  ///
  ///success = is the function called when the server returns the handshake
  void initNavigatorSocket(BuildContext context, Function success) {
    listen = success;
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
          (data) => listen(data),
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

  ///Close the Navigator Socket
  void closeNavigatorSocket() {
    manuallyClosed = true;
    navigatorSocket.sink.close();
  }
}

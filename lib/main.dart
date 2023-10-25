// ignore_for_file: use_build_context_synchronously
import 'dart:convert';

import 'package:flublade_project/components/engine.dart';
import 'package:flublade_project/components/gameplay/game_engine.dart';
import 'package:flublade_project/components/system/dialogs.dart';
import 'package:flublade_project/data/global.dart';
import 'package:flublade_project/data/server.dart';

import 'package:flublade_project/data/gameplay.dart';
import 'package:flublade_project/data/options.dart';
import 'package:flublade_project/data/settings.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

void main() async {
  //SaveDatas Loading
  WidgetsFlutterBinding.ensureInitialized();
  await SaveDatas.init();

  runApp(
    MultiProvider(
      //Providers Call
      providers: [
        ChangeNotifierProvider(
          create: (_) => Options(),
        ),
        ChangeNotifierProvider(
          create: (_) => Settings(),
        ),
        ChangeNotifierProvider(
          create: (_) => Gameplay(),
        ),
        ChangeNotifierProvider(
          create: (_) => Server(),
        ),
        ChangeNotifierProvider(
          create: (_) => Engine(),
        ),
        ChangeNotifierProvider(
          create: (_) => Websocket(),
        ),
        ChangeNotifierProvider(
          create: (_) => GameEngine(),
        ),
      ],
      child: const FluBlade(),
    ),
  );
}

class FluBlade extends StatelessWidget {
  const FluBlade({super.key});

  //Program Call
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primaryColor: Colors.white,
        colorScheme: ColorScheme.fromSwatch().copyWith(
          primary: const Color.fromARGB(255, 92, 17, 17),
          secondary: const Color.fromARGB(255, 58, 55, 55),
        ),
        scaffoldBackgroundColor: const Color.fromARGB(255, 53, 49, 49),
      ),
      debugShowCheckedModeBanner: false,
      title: 'Flublade Project',
      home: const FlubladeProject(),
      routes: GlobalFunctions.routes,
    );
  }
}

class FlubladeProject extends StatefulWidget {
  const FlubladeProject({super.key});

  @override
  State<FlubladeProject> createState() => _FlubladeProjectState();
}

class _FlubladeProjectState extends State<FlubladeProject> {
  //Load Datas & Auto Login
  @override
  void initState() {
    super.initState();
    final options = Provider.of<Options>(context, listen: false);
    final server = Provider.of<Server>(context, listen: false);
    //Load Datas
    server.changeServerAddress(SaveDatas.getServerAddress() ?? '0.0.0.0:8080');
    server.changeServerName("");
    options.changeUsername(SaveDatas.getUsername() ?? '');
    options.changeToken(SaveDatas.getToken() ?? '');
    options.changeId(SaveDatas.getId() ?? 0);
    options.changeLanguage(SaveDatas.getLanguage() ?? 'en_US');
    options.changeTextSpeed(SaveDatas.getTextSpeed() ?? 700);
    options.changeRemember(value: SaveDatas.getRemember() ?? false, notify: false);
    //Auto Login Function
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      //Check Remember Box
      if (options.remember) {
        //Login
        dynamic result;
        try {
          //Credentials Check
          result = await http.post(Uri.http(server.serverAddress, '/loginRemember'),
              headers: Server.headers,
              body: jsonEncode({
                'id': options.id,
                'token': options.token,
              }));
        } catch (error) {
          Dialogs.errorDialog(errorMsg: 'authentication_register_problem_connection', context: context);
          return;
        }
        result = jsonDecode(result.body);
        if (result['message'] == 'Success') {
          //Reload infos
          options.changeId(result['id']);
          options.changeUsername(result['username']);
          options.changeLanguage(result['language']);
          options.changeToken(result['token']);
          //Save reload
          SaveDatas.setId(options.id);
          SaveDatas.setUsername(options.username);
          SaveDatas.setLanguage(options.language);
          SaveDatas.setToken(options.token);
          Navigator.pushReplacementNamed(context, '/mainmenu');
        } else if (result['message'] == 'Invalid Login') {
          Dialogs.errorDialog(errorMsg: 'authentication_invalidlogin', context: context);
        } else {
          Dialogs.errorDialog(errorMsg: 'authentication_register_problem_connection', context: context);
        }
      } else {
        Navigator.of(context).pushReplacementNamed('/authenticationpage');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        children: [
          SizedBox(
            width: screenSize.width,
            height: screenSize.height,
            child: Stack(
              children: [
                //Background
                FittedBox(
                  child: SizedBox(
                    width: screenSize.width,
                    height: screenSize.height,
                    child: Image.asset(
                      'assets/loading_cover_background.png',
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                //Logo
                Center(
                  child: FittedBox(
                    child: Padding(
                      padding: const EdgeInsets.all(100.0),
                      child: SizedBox(
                        width: 2300,
                        height: 3900,
                        child: Image.asset(
                          'assets/logo.png',
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const Center(
            child: CircularProgressIndicator(),
          ),
        ],
      ),
    );
  }
}

import 'dart:convert';

import 'package:flublade_project/data/global.dart';
import 'package:flublade_project/data/mysqldata.dart';

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
      //Change This
      //To
      //Bypass login
      //Default FlubladeProject()
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
    final gameplay = Provider.of<Gameplay>(context, listen: false);
    //Load Datas
    options.changeUsername(SaveDatas.getUsername() ?? '');
    options.changeToken(SaveDatas.getToken() ?? '');
    options.changeId(SaveDatas.getId() ?? 0);
    options.changeLanguage(SaveDatas.getLanguage() ?? 'en_US');
    gameplay.changeCharacters(SaveDatas.getCharacters() ?? '{}');
    Future.delayed(const Duration(seconds: 1), () async {
      options.changeRemember(value: SaveDatas.getRemember() ?? false);
      await Future.delayed(const Duration(milliseconds: 1));
      //Check Remember Box
      if (options.remember) {
        //Login
        dynamic result;
        try {
          //Credentials Check
          result = await http.post(Uri.http(MySQL.url, '/loginRemember'),
              headers: MySQL.headers,
              body: jsonEncode({
                'id': options.id,
                'token': options.token,
              }));
        } catch (error) {
          // ignore: use_build_context_synchronously
          Navigator.of(context).pushReplacementNamed('/authenticationpage');
          GlobalFunctions.errorDialog(
              errorMsgTitle: 'authentication_register_problem_connection',
              errorMsgContext: 'Failed to connect to the Servers',
              context: context);
        }
        result = jsonDecode(result.body);
        if (result['message'] == 'Success') {
          //Reload infos
          options.changeId(result['id']);
          options.changeUsername(result['username']);
          options.changeLanguage(result['language']);
          options.changeToken(result['token']);
          gameplay.changeCharacters(result['characters']);
          //Save reload
          SaveDatas.setId(options.id);
          SaveDatas.setUsername(options.username);
          SaveDatas.setLanguage(options.language);
          SaveDatas.setToken(options.token);
          SaveDatas.setCharacters(gameplay.characters);
          // ignore: use_build_context_synchronously
          Navigator.pushReplacementNamed(context, '/mainmenu');
        } else if (result['message'] == 'Invalid Login') {
          // ignore: use_build_context_synchronously
          Navigator.of(context).pushReplacementNamed('/authenticationpage');
          GlobalFunctions.errorDialog(
              errorMsgTitle: 'authentication_invalidlogin',
              errorMsgContext: 'Invalid Session',
              context: context);
        } else {
          // ignore: use_build_context_synchronously
          Navigator.of(context).pushReplacementNamed('/authenticationpage');
          GlobalFunctions.errorDialog(
              errorMsgTitle: 'authentication_register_problem_connection',
              errorMsgContext: 'Failed to connect to the Servers',
              context: context);
        }
      } else {
        // ignore: use_build_context_synchronously
        Navigator.of(context).pushReplacementNamed('/authenticationpage');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}

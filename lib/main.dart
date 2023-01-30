// ignore_for_file: unused_local_variable
import 'package:flublade_project/data/global.dart';
import 'package:flublade_project/data/language.dart';
import 'package:flublade_project/pages/authenticationpage.dart';
import 'package:flublade_project/data/mysqldata.dart';
import 'package:flublade_project/pages/mainmenu/main_menu.dart';
import 'package:flublade_project/pages/mainmenu/options_menu.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'pages/mainmenu/characters_menu.dart';

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
        )
      ],
      child: const FluBlade(),
    ),
  );
}

class FluBlade extends StatelessWidget {
  const FluBlade({super.key});

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
      routes: {
        '/authenticationpage': (context) => const AuthenticationPage(),
        '/mainmenu': (context) => const MainMenu(),
        '/optionsmenu': (context) => const OptionsMenu(),
        '/charactersmenu': (context) => const CharactersMenu(),
      },
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
    //Load Datas
    options.changeUsername(SaveDatas.getUsername() ?? '');
    options.changePassword(SaveDatas.getPassword() ?? '');
    options.changeId(SaveDatas.getId() ?? 0);
    options.changeLanguage(SaveDatas.getLanguage() ?? 'en_US');
    Future.delayed(const Duration(seconds: 1), () => options.changeRemember(value: SaveDatas.getRemember() ?? false));
    //Connection
    Future database = MySQL.database.then(
      (database) async {
        await Future.delayed(const Duration(seconds: 1));
        //Check Remember Box
        if (options.remember) {
          final result = await MySQL.login(
              username: options.username,
              password: options.password,
              context: context);
          if (result == 'success') {
            // ignore: use_build_context_synchronously
            Navigator.pushReplacementNamed(context, '/mainmenu');
          } else {
            // ignore: use_build_context_synchronously
            Navigator.of(context).pushReplacementNamed('/authenticationpage');
            showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: const Text(':('),
                    content: Text(Language.Translate(
                            'authentication_register_problem_connection',
                            options.language) ??
                        'Failed to connect to the Servers'),
                  );
                });
          }
        } else {
          // ignore: use_build_context_synchronously
          Navigator.of(context).pushReplacementNamed('/authenticationpage');
        }
      },
      //Connection Error
    ).catchError((error) {
      Navigator.of(context).pushReplacementNamed('/authenticationpage');
      //Connection Error
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text(':('),
              content: Text(Language.Translate(
                      'authentication_register_problem_connection',
                      options.language) ??
                  'Failed to connect to the Servers'),
            );
          });
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

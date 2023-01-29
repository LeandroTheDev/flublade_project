// ignore_for_file: unused_local_variable
import 'package:flublade_project/data/global.dart';
import 'package:flublade_project/pages/authenticationpage.dart';
import 'package:flublade_project/data/mysqldata.dart';
import 'package:flublade_project/pages/main_menu.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
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
          secondary: const Color.fromARGB(255, 0, 0, 0),
        ),
        scaffoldBackgroundColor: const Color.fromARGB(255, 53, 49, 49),
      ),
      debugShowCheckedModeBanner: false,
      title: 'Flublade Project',
      home: const FlubladeProject(),
      routes: {
        '/authenticationpage': (context) => const AuthenticationPage(),
        '/mainmenu': (context) => const MainMenu(),
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
  @override
  void initState() {
    super.initState();
    //Connection
    Future database = MySQL.database.then(
      (database) async {
        Navigator.pushReplacementNamed(context, '/authenticationpage');
      },
      //Connection Error
    ).catchError((error) {
      Navigator.of(context).pushReplacementNamed('/authenticationpage');
      showDialog(
          context: context,
          builder: (context) {
            return const AlertDialog(
              title: Text(':('),
              content: Text('Sem conexão com o servidor'),
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

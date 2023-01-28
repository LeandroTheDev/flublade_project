// ignore_for_file: unused_local_variable
import 'package:flublade_project/data/global.dart';
import 'package:flublade_project/pages/authentication_page.dart';
import 'package:flublade_project/data/mysqldata.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => Options(),
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
          scaffoldBackgroundColor: const Color.fromARGB(255, 53, 49, 49)),
      debugShowCheckedModeBanner: false,
      title: 'Flublade Project',
      home: const FlubladeProject(),
      routes: {'/authenticationpage': (context) => const AuthenticationPage()},
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

import 'package:flublade_project/data/global.dart';
import 'package:flublade_project/data/language.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CharactersMenu extends StatefulWidget {
  const CharactersMenu({super.key});

  @override
  State<CharactersMenu> createState() => _CharactersMenuState();
}

class _CharactersMenuState extends State<CharactersMenu> {
  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final options = Provider.of<Options>(context);
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Stack(
        children: [
          //Background Image
          SizedBox(
            width: screenSize.width,
            height: screenSize.height,
            child: Image.asset(
              'assets/main_menu_background.png',
              fit: BoxFit.cover,
            ),
          ),
          // Characters
          Column(
            children: [
              SizedBox(height: screenSize.height * 0.1),
              FittedBox(
                child: Padding(
                  padding: const EdgeInsets.all(500.0),
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pushNamed("/charactercreation").then((value) => setState(() {}));
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(200.0),
                      child: Text(
                        Language.Translate(
                                'characters_create', options.language) ??
                            'characters_create',
                        style: const TextStyle(
                            fontSize: 500, fontFamily: 'PressStart'),
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}

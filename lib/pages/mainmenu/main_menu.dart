import 'package:flublade_project/data/global.dart';
import 'package:flublade_project/data/language.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MainMenu extends StatefulWidget {
  const MainMenu({super.key});

  @override
  State<MainMenu> createState() => _MainMenuState();
}

class _MainMenuState extends State<MainMenu> {
  @override
  Widget build(BuildContext context) {
    final options = Provider.of<Options>(context);
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
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
          SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: screenSize.height * 0.1),
                //Flublade Text
                FittedBox(
                  child: Padding(
                    padding: const EdgeInsets.all(150.0),
                    child: Stack(children: [
                      Text(
                        'FLUBLADE',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontFamily: 'PressStart',
                            fontSize: 500,
                            color: Theme.of(context).primaryColor),
                      ),
                      Text(
                        'FLUBLADE',
                        style: TextStyle(
                            fontFamily: 'PressStart',
                            fontSize: 500,
                            color: Theme.of(context).colorScheme.primary),
                      ),
                    ]),
                  ),
                ),
                //Menu Buttons
                FittedBox(
                  child: Padding(
                    padding: const EdgeInsets.all(400.0),
                    child: Column(
                      children: [
                        const SizedBox(height: 100),
                        //Play Button
                        TextButton(
                          onPressed: () {
                            Navigator.pushNamed(context, '/characterselection');
                          },
                          child: FittedBox(
                            child: Text(
                              Language.Translate(
                                      'mainmenu_play', options.language) ??
                                  'Play',
                              style: TextStyle(
                                  fontFamily: 'PressStart',
                                  fontSize: 500,
                                  color: Theme.of(context).primaryColor),
                            ),
                          ),
                        ),
                        const SizedBox(height: 400),
                        //Characters Button
                        TextButton(
                          onPressed: () {
                            Navigator.pushNamed(context, '/charactersmenu');
                          },
                          child: FittedBox(
                            child: Text(
                              Language.Translate('mainmenu_characters',
                                      options.language) ??
                                  'Personagens',
                              style: TextStyle(
                                  fontFamily: 'PressStart',
                                  fontSize: 500,
                                  color: Theme.of(context).primaryColor),
                            ),
                          ),
                        ),
                        const SizedBox(height: 400),
                        //Options
                        TextButton(
                          onPressed: () {
                            Navigator.of(context)
                                .pushNamed("/optionsmenu")
                                .then((value) => setState(() {}));
                          },
                          child: FittedBox(
                            child: Text(
                              Language.Translate(
                                      'mainmenu_options', options.language) ??
                                  'Options',
                              style: TextStyle(
                                  fontFamily: 'PressStart',
                                  fontSize: 500,
                                  color: Theme.of(context).primaryColor),
                            ),
                          ),
                        ),
                        const SizedBox(height: 400),
                        //Logout
                        TextButton(
                          onPressed: () async {
                            GlobalFunctions.confirmationDialog(
                              errorMsgTitle: 'response_confirmation',
                              errorMsgContext: 'mainmenu_confirmation',
                              context: context,
                            );
                          },
                          child: FittedBox(
                            child: Text(
                              Language.Translate(
                                      'mainmenu_logout', options.language) ??
                                  'Logout',
                              style: TextStyle(
                                  fontFamily: 'PressStart',
                                  fontSize: 500,
                                  color: Theme.of(context).primaryColor),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ignore_for_file: use_build_context_synchronously

import 'package:flublade_project/data/global.dart';
import 'package:flublade_project/data/language.dart';
import 'package:flublade_project/data/mysqldata.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MainMenu extends StatefulWidget {
  const MainMenu({super.key});

  @override
  State<MainMenu> createState() => _MainMenuState();
}

class _MainMenuState extends State<MainMenu> {
  bool isLoading = false;
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
                        style: TextStyle(fontWeight: FontWeight.bold, fontFamily: 'PressStart', fontSize: 500, color: Theme.of(context).primaryColor),
                      ),
                      Text(
                        'FLUBLADE',
                        style: TextStyle(fontFamily: 'PressStart', fontSize: 500, color: Theme.of(context).colorScheme.primary),
                      ),
                    ]),
                  ),
                ),
                //Menu Buttons
                isLoading
                    ? Column(
                        children: [
                          SizedBox(height: screenSize.height * 0.2),
                          const CircularProgressIndicator(),
                        ],
                      )
                    : FittedBox(
                        child: Padding(
                          padding: const EdgeInsets.all(400.0),
                          child: Column(
                            children: [
                              const SizedBox(height: 100),
                              //Play Button
                              TextButton(
                                onPressed: () async {
                                  setState(() {
                                    isLoading = true;
                                  });
                                  await Future.delayed(const Duration(milliseconds: 50));
                                  //Refresh
                                  await MySQL.pushCharacters(context: context);
                                  Navigator.pushNamed(context, '/characterselection');
                                  Future.delayed(const Duration(milliseconds: 200)).then((value) => setState(() {
                                        isLoading = false;
                                      }));
                                },
                                child: FittedBox(
                                  child: Text(
                                    Language.Translate('mainmenu_play', options.language) ?? 'Play',
                                    style: TextStyle(fontFamily: 'PressStart', fontSize: 500, color: Theme.of(context).primaryColor),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 400),
                              //Characters Button
                              TextButton(
                                onPressed: () async {
                                  //Loading
                                  setState(() {
                                    isLoading = true;
                                  });
                                  //Refresh
                                  await MySQL.pushCharacters(context: context);
                                  Navigator.pushNamed(context, '/charactersmenu');
                                  Future.delayed(const Duration(milliseconds: 200)).then((value) => setState(() {
                                        isLoading = false;
                                      }));
                                },
                                child: FittedBox(
                                  child: Text(
                                    Language.Translate('mainmenu_characters', options.language) ?? 'Characters',
                                    style: TextStyle(fontFamily: 'PressStart', fontSize: 500, color: Theme.of(context).primaryColor),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 400),
                              //Options
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pushNamed("/optionsmenu").then((value) => setState(() {}));
                                },
                                child: FittedBox(
                                  child: Text(
                                    Language.Translate('mainmenu_options', options.language) ?? 'Options',
                                    style: TextStyle(fontFamily: 'PressStart', fontSize: 500, color: Theme.of(context).primaryColor),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 400),
                              //Logout
                              TextButton(
                                onPressed: () {
                                  GlobalFunctions.disconnectDialog(
                                    errorMsgTitle: 'response_confirmation',
                                    errorMsgContext: 'mainmenu_confirmation',
                                    context: context,
                                  );
                                },
                                child: FittedBox(
                                  child: Text(
                                    Language.Translate('mainmenu_logout', options.language) ?? 'Logout',
                                    style: TextStyle(fontFamily: 'PressStart', fontSize: 500, color: Theme.of(context).primaryColor),
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

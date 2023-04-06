import 'dart:convert';

import 'package:flublade_project/data/global.dart';
import 'package:flublade_project/data/language.dart';
import 'package:flublade_project/data/mysqldata.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CharacterSelection extends StatelessWidget {
  const CharacterSelection({super.key});

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final options = Provider.of<Options>(context);
    final characters = jsonDecode(Provider.of<Gameplay>(context).characters);

    returnGold(index) {
      try {
        return characters['character$index']['inventory']['gold']['quantity'];
      } catch (error) {
        return '0';
      }
    }

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
          SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: screenSize.height * 0.1),
                //Character List
                ListView.builder(
                    //Disable Scroll List View
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: characters.length,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      return FittedBox(
                        child: Stack(
                          children: [
                            //Board Image
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 85.0),
                              child: SizedBox(
                                width: 2800,
                                height: 1800,
                                child: Image.asset(
                                  'assets/character.png',
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            //Name
                            Padding(
                              padding: const EdgeInsets.only(left: 900),
                              child: SizedBox(
                                height: 450,
                                width: 970,
                                child: Center(
                                  child: FittedBox(
                                    child: Text(
                                      characters['character$index']['name'],
                                      style: const TextStyle(
                                          fontFamily: 'Explora',
                                          fontSize: 400,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            //Character Infos
                            Padding(
                              padding:
                                  const EdgeInsets.only(top: 380, left: 230),
                              child: SizedBox(
                                height: 1600,
                                width: 1450,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    //Class
                                    FittedBox(
                                      child: Text(
                                        '${Language.Translate('characters_create_class', options.language) ?? 'Class'}:  ${Language.Translate('characters_class_${characters['character$index']['class']}', options.language) ?? 'Language Error'}',
                                        maxLines: 1,
                                        style: TextStyle(
                                            fontFamily: 'Explora',
                                            fontSize: 250,
                                            fontWeight: FontWeight.bold,
                                            color:
                                                Theme.of(context).primaryColor,
                                            overflow: TextOverflow.ellipsis),
                                      ),
                                    ),
                                    //Level
                                    Text(
                                      '${Language.Translate('characters_create_level', options.language) ?? 'Level'}:  ${characters['character$index']['level']}',
                                      maxLines: 1,
                                      style: TextStyle(
                                          fontFamily: 'Explora',
                                          fontSize: 250,
                                          fontWeight: FontWeight.bold,
                                          color: Theme.of(context).primaryColor,
                                          overflow: TextOverflow.ellipsis),
                                    ),
                                    //Gold
                                    Text(
                                      '${Language.Translate('characters_create_gold', options.language) ?? 'Ouro'}:  ${returnGold(index)}',
                                      maxLines: 1,
                                      style: TextStyle(
                                          fontFamily: 'Explora',
                                          fontSize: 250,
                                          fontWeight: FontWeight.bold,
                                          color: Theme.of(context).primaryColor,
                                          overflow: TextOverflow.ellipsis),
                                    ),
                                    //Location
                                    Text(
                                      '${Language.Translate('characters_create_location', options.language) ?? 'Location'}:  ${Language.Translate('locations_${characters['character$index']['location']}', options.language) ?? 'Language Error'}',
                                      maxLines: 1,
                                      style: TextStyle(
                                          fontFamily: 'Explora',
                                          fontSize: 250,
                                          fontWeight: FontWeight.bold,
                                          color: Theme.of(context).primaryColor,
                                          overflow: TextOverflow.ellipsis),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            //Class Image
                            Padding(
                              padding:
                                  const EdgeInsets.only(top: 400.0, left: 1440),
                              child: SizedBox(
                                width: 1150,
                                height: 1300,
                                child: Image.asset(
                                  'assets/characters/${characters['character$index']['class']}.png',
                                  fit: BoxFit.fill,
                                ),
                              ),
                            ),
                            //Select Button
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 1100.0, top: 1673),
                              child: SizedBox(
                                  width: 600,
                                  height: 170,
                                  child: ElevatedButton(
                                      onPressed: () async {
                                        MySQL.loadingWidget(
                                            context: context,
                                            language: options.language);
                                        final result =
                                            await MySQL.pushCharacters(
                                                context: context);
                                        //Check if connection success
                                        if (result != false) {
                                          // ignore: use_build_context_synchronously
                                          Provider.of<Gameplay>(context,
                                                  listen: false)
                                              .changeSelectedCharacter(index);
                                          // ignore: use_build_context_synchronously
                                          await MySQL.returnPlayerStats(
                                              context);
                                          // ignore: use_build_context_synchronously
                                          Navigator.of(context)
                                              .pushNamedAndRemoveUntil(
                                                  '/ingame',
                                                  (Route route) => false);
                                        } else {
                                          GlobalFunctions.errorDialog(
                                            errorMsgTitle:
                                                'authentication_register_problem_connection',
                                            errorMsgContext:
                                                'Failed to connect to the Servers',
                                            context: context,
                                          );
                                        }
                                      },
                                      child: FittedBox(
                                          child: Padding(
                                        padding: const EdgeInsets.all(200.0),
                                        child: Text(
                                          Language.Translate('response_select',
                                                  options.language) ??
                                              'Select',
                                          style: const TextStyle(
                                              fontFamily: 'PressStart',
                                              fontSize: 500),
                                        ),
                                      )))),
                            )
                          ],
                        ),
                      );
                    })
              ],
            ),
          ),
        ],
      ),
    );
  }
}

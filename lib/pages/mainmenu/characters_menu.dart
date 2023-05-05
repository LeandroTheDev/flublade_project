import 'dart:convert';

import 'package:flublade_project/data/global.dart';
import 'package:flublade_project/data/language.dart';
import 'package:flublade_project/data/mysqldata.dart';

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
    final characters = jsonDecode(Provider.of<Gameplay>(context).characters);

    //Remove Character
    removeCharacterDialog(int index) {
      TextEditingController input = TextEditingController();
      showDialog(
          barrierColor: const Color.fromARGB(167, 0, 0, 0),
          context: context,
          builder: (context) {
            return FittedBox(
              child: AlertDialog(
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(32.0))),
                backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                //Confirmation Text
                title: Text(
                  Language.Translate(
                          'response_confirmation', options.language) ??
                      'Are you Sure?',
                  style: TextStyle(color: Theme.of(context).primaryColor),
                ),
                //Text and Input
                content: Column(
                  children: [
                    //Text
                    Text(
                      Language.Translate(
                              'characters_remove', options.language) ??
                          'Type "Delete" to remove the character',
                      style: TextStyle(color: Theme.of(context).primaryColor),
                    ),
                    const SizedBox(height: 10),
                    //Input
                    Stack(
                      children: [
                        //Background Box Color and Decoration
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Container(
                            decoration: BoxDecoration(
                              color: const Color.fromARGB(255, 209, 209, 209),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            width: 300,
                            height: 40,
                          ),
                        ),
                        //Input
                        Container(
                          padding: const EdgeInsets.all(5),
                          alignment: Alignment.topLeft,
                          width: 300,
                          height: 47,
                          child: TextFormField(
                            controller: input,
                          ),
                        ),
                      ],
                    )
                  ],
                ),
                actions: [
                  Row(
                    children: [
                      const Spacer(),
                      ElevatedButton(
                        onPressed: () async {
                          if (input.text != 'DELETE') {
                            GlobalFunctions.errorDialog(
                              errorMsgTitle: 'response_incorrect',
                              errorMsgContext: 'Incorrect',
                              context: context,
                            );
                          } else {
                            MySQL.loadingWidget(
                                context: context, language: options.language);
                            await MySQL.removeCharacters(
                              index: index,
                              context: context,
                            );
                            // ignore: use_build_context_synchronously
                            Navigator.pop(context);
                            // ignore: use_build_context_synchronously
                            Navigator.pop(context);
                            // ignore: use_build_context_synchronously
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        super.widget));
                          }
                        },
                        child: Text(Language.Translate(
                                'response_remove', options.language) ??
                            'Remove'),
                      ),
                      const Spacer(),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text(Language.Translate(
                                'response_back', options.language) ??
                            'Back'),
                      ),
                      const Spacer(),
                    ],
                  ),
                ],
              ),
            );
          });
    }

    //Return Character Gold
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
                //Character Create Button
                FittedBox(
                  child: Padding(
                    padding: const EdgeInsets.all(500.0),
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context)
                            .pushNamed("/charactercreation")
                            .then((value) => setState(() {}));
                      },
                      style: ButtonStyle(
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(300.0),
                            side: const BorderSide(color: Colors.black),
                          ),
                        ),
                      ),
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
                ),
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
                                      '${Language.Translate('characters_create_location', options.language) ?? 'Location'}:  ${Language.Translate('locations_${characters['character$index']['location'].substring(0, characters['character$index']['location'].length - 3)}', options.language) ?? 'Language Error'}',
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
                            //Remove Button
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 1100.0, top: 1673),
                              child: SizedBox(
                                width: 600,
                                height: 170,
                                child: ElevatedButton(
                                  onPressed: () {
                                    removeCharacterDialog(index);
                                  },
                                  style: ButtonStyle(
                                    shape: MaterialStateProperty.all<
                                        RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(40.0),
                                        side: const BorderSide(
                                            color: Colors.black),
                                      ),
                                    ),
                                  ),
                                  child: FittedBox(
                                    child: Padding(
                                      padding: const EdgeInsets.all(200.0),
                                      child: Text(
                                        Language.Translate('response_remove',
                                                options.language) ??
                                            'remove',
                                        style: const TextStyle(
                                            fontFamily: 'PressStart',
                                            fontSize: 500),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
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

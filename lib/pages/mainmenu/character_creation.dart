// ignore_for_file: use_build_context_synchronously
import 'dart:convert';

import 'package:flublade_project/components/system/dialogs.dart';
import 'package:flublade_project/data/global.dart';
import 'package:flublade_project/data/language.dart';
import 'package:flublade_project/data/server.dart';
import 'package:flublade_project/data/gameplay.dart';
import 'package:flublade_project/data/options.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

class CharacterCreation extends StatefulWidget {
  const CharacterCreation({super.key});

  @override
  State<CharacterCreation> createState() => _CharacterCreationState();
}

class _CharacterCreationState extends State<CharacterCreation> {
  int selectedClass = 0;
  List<int> playableClasses = [4];
  TextEditingController createName = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final options = Provider.of<Options>(context);
    final gameplay = Provider.of<Gameplay>(context, listen: false);
    final server = Provider.of<Server>(context, listen: false);

    //Change Class Button
    void changeClass(bool value) {
      if (value) {
        if (selectedClass > 10) {
          setState(() {
            selectedClass = 0;
          });
        } else {
          setState(() {
            selectedClass++;
          });
        }
      } else {
        if (selectedClass < 1) {
          setState(() {
            selectedClass = 11;
          });
        } else {
          setState(() {
            selectedClass--;
          });
        }
      }
    }

    //Select Username Dialog
    void usernameSelect() {
      showDialog(
        context: context,
        builder: (context) {
          return FittedBox(
            child: AlertDialog(
              shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(32.0))),
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              //Title
              title: Text(
                Language.Translate('characters_create_name', options.language) ?? 'Character Name',
                style: TextStyle(color: Theme.of(context).primaryColor),
              ),
              //Text and Input
              content: Stack(
                children: [
                  //Background Box Color and Decoration
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 209, 209, 209),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      width: 250,
                      height: 40,
                    ),
                  ),
                  //Input
                  Container(
                    padding: const EdgeInsets.all(5),
                    alignment: Alignment.topLeft,
                    width: 250,
                    height: 47,
                    child: TextFormField(controller: createName),
                  ),
                ],
              ),
              //Butons
              actions: [
                Row(
                  children: [
                    const Spacer(),
                    //Create Button
                    ElevatedButton(
                      onPressed: () async {
                        //Class declaration
                        String characterClass = Gameplay.classes[selectedClass].substring(18);
                        characterClass = characterClass.substring(0, characterClass.length - 4);
                        //Loading Widget
                        GlobalFunctions.loadingWidget(context: context, language: options.language);
                        dynamic result;
                        try {
                          //Load Stats
                          await ServerGameplay.returnGameplayStats(context);
                          //Server Creation
                          result = await http.post(Uri.http(server.serverAddress, '/createCharacters'),
                              headers: Server.headers,
                              body: jsonEncode({
                                'id': options.id,
                                'token': options.token,
                                'name': createName.text,
                                'class': characterClass,
                              }));
                        } catch (error) {
                          Navigator.pop(context);
                          //Connection Error
                          Dialogs.alertDialog(context: context, message: 'characters_create_error');
                          return;
                        }
                        result = jsonDecode(result.body);
                        //Empty Text
                        if (result['message'] == 'Empty') {
                          Navigator.pop(context);
                          Dialogs.alertDialog(context: context, message: 'characters_create_error_empty');
                          return;
                        }
                        //Too big Text
                        if (result['message'] == 'Too big') {
                          Navigator.pop(context);
                          Dialogs.alertDialog(context: context, message: 'characters_create_error_namelimit');
                          return;
                        }
                        //Success
                        if (result['message'] == 'Success') {
                          gameplay.changeCharacters(result['characters']);
                          Navigator.pop(context);
                          Navigator.pop(context);
                          Navigator.pop(context);
                        } else {
                          Navigator.pop(context);
                          //Connection Error
                          Dialogs.alertDialog(context: context, message: 'characters_create_error');
                          return;
                        }
                      },
                      child: Text(
                        Language.Translate('response_create', options.language) ?? 'Language',
                        style: TextStyle(color: Theme.of(context).primaryColor),
                      ),
                    ),

                    const Spacer(),
                    //Back Button
                    ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text(
                        Language.Translate('response_back', options.language) ?? 'Language',
                        style: TextStyle(color: Theme.of(context).primaryColor),
                      ),
                    ),
                    const Spacer(),
                  ],
                ),
              ],
            ),
          );
        },
      );
    }

    //Verifiy if class is playable
    bool verifyPlayableClass() {
      for (int i = 0; i <= playableClasses.length - 1; i++) {
        if (selectedClass == playableClasses[i]) {
          return true;
        }
      }
      return false;
    }

    //Return Class Info By Index
    String returnClassInfo(int index, String language) {
      Map classesInfo = {
        0: 'characters_class_archer_info',
        1: 'characters_class_assassin_info',
        2: 'characters_class_bard_info',
        3: 'characters_class_beastmaster_info',
        4: 'characters_class_berserk_info',
        5: 'characters_class_druid_info',
        6: 'characters_class_mage_info',
        7: 'characters_class_paladin_info',
        8: 'characters_class_priest_info',
        9: 'characters_class_trickmagician_info',
        10: 'characters_class_weaponsmith_info',
        11: 'characters_class_witch_info',
      };
      return Language.Translate(classesInfo[index], language) ?? 'Language Error';
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
              'assets/tavern.png',
              fit: BoxFit.cover,
            ),
          ),
          //Creation
          SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: screenSize.height * 0.07),
                //Book Selection
                FittedBox(
                  child: Stack(
                    children: [
                      //Book Image
                      SizedBox(
                        width: 2800,
                        height: 2800,
                        child: Image.asset(
                          'assets/open_book.png',
                          fit: BoxFit.fill,
                        ),
                      ),
                      //Class Text
                      SizedBox(
                        width: 950,
                        height: 580,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 510.0, top: 500),
                          child: FittedBox(
                            child: Text(
                              Language.Translate('characters_create_class', options.language) ?? 'Class',
                              maxLines: 1,
                              style: const TextStyle(fontFamily: 'PressStart'),
                            ),
                          ),
                        ),
                      ),
                      //Info Text
                      SizedBox(
                        width: 2180,
                        height: 580,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 1810.0, top: 500),
                          child: FittedBox(
                            child: Text(
                              Language.Translate('characters_create_info', options.language) ?? 'Info',
                              maxLines: 1,
                              style: const TextStyle(fontFamily: 'PressStart'),
                            ),
                          ),
                        ),
                      ),
                      //Class Image
                      SizedBox(
                        width: 1140,
                        height: 2110,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 350.0, top: 770),
                          child: Image.asset(
                            Gameplay.classes[selectedClass],
                            fit: BoxFit.fill,
                          ),
                        ),
                      ),
                      //Class Info
                      Padding(
                        padding: const EdgeInsets.only(left: 1700.0, top: 750),
                        child: SizedBox(
                          width: 650,
                          height: 1350,
                          child: SingleChildScrollView(
                            child: Column(
                              children: [
                                Text(
                                  returnClassInfo(selectedClass, options.language),
                                  style: const TextStyle(fontFamily: 'Explora', fontSize: 200, fontWeight: FontWeight.bold, letterSpacing: 10),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                //Next & Back Button
                SizedBox(
                  width: screenSize.width,
                  child: FittedBox(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        //Back Button
                        TextButton(
                          onPressed: () {
                            changeClass(false);
                          },
                          child: Text(
                            Language.Translate('response_back', options.language) ?? 'Back',
                            style: TextStyle(fontSize: 20, fontFamily: 'PressStart', color: Theme.of(context).primaryColor),
                          ),
                        ),
                        const SizedBox(width: 30),
                        //Next Button
                        TextButton(
                          onPressed: () {
                            changeClass(true);
                          },
                          child: Text(
                            Language.Translate('response_next', options.language) ?? 'Next',
                            style: TextStyle(fontSize: 20, fontFamily: 'PressStart', color: Theme.of(context).primaryColor),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                //Select Button
                verifyPlayableClass()
                    ? FittedBox(
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: SizedBox(
                              height: screenSize.height * 0.15,
                              width: screenSize.width,
                              child: ElevatedButton(
                                  onPressed: () {
                                    usernameSelect();
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: FittedBox(
                                      child: Text(
                                        Language.Translate('response_select', options.language) ?? 'Select',
                                        style: const TextStyle(fontSize: 500, fontFamily: 'PressStart'),
                                      ),
                                    ),
                                  ))),
                        ),
                      )
                    : FittedBox(
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: SizedBox(
                              height: screenSize.height * 0.15,
                              width: screenSize.width,
                              child: ElevatedButton(
                                  onPressed: null,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: FittedBox(
                                      child: Text(
                                        Language.Translate('response_select', options.language) ?? 'Select',
                                        style: const TextStyle(fontSize: 500, fontFamily: 'PressStart'),
                                      ),
                                    ),
                                  ))),
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

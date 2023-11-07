// ignore_for_file: use_build_context_synchronously

import 'package:flublade_project/components/engine.dart';
import 'package:flublade_project/components/widget/character_widget.dart';
import 'package:flublade_project/data/language.dart';
import 'package:flublade_project/data/server.dart';
import 'package:flublade_project/data/gameplay.dart';
import 'package:flublade_project/data/options.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CharacterSelection extends StatefulWidget {
  const CharacterSelection({super.key});

  @override
  State<CharacterSelection> createState() => _CharacterSelectionState();
}

class _CharacterSelectionState extends State<CharacterSelection> {
  bool isLoading = true;
  late final Map characters;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
      //Get the Characters from Server
      (_) => Server.getCharacters(context: context).then(
        (value) => setState(
          () {
            //Update
            characters = value;
            isLoading = false;
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final options = Provider.of<Options>(context);

    selectCharacter(int index) async {
      final gameplay = Provider.of<Gameplay>(context, listen: false);
      gameplay.start(context);
      //Initializing the Navigator Socket

      //Check if connection success
      // if (result != false) {
      //   Navigator.of(context).pushNamedAndRemoveUntil('/ingame', (Route route) => false);
      // } else {
      //   Dialogs.alertDialog(context: context, message: 'authentication_register_problem_connection');
      // }
    }

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
              'assets/images/menu/main_menu_background.png',
              fit: BoxFit.cover,
            ),
          ),
          // Characters
          SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: screenSize.height * 0.1),
                //Character List
                isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : ListView.builder(
                        //Disable Scroll List View
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: characters.length,
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          final raceID = Gameplay.returnRaceIDbyName(characters['character$index']['race']);
                          final gender = characters['character$index']['body']['gender'] == 'female';
                          return FittedBox(
                            child: Stack(
                              children: [
                                //Board Image
                                Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 85.0),
                                  child: SizedBox(
                                    width: 2800,
                                    height: 1800,
                                    child: Image.asset(
                                      'assets/images/menu/board_view.png',
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
                                          style: const TextStyle(fontFamily: 'Explora', fontSize: 400, fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                //Character Infos
                                Padding(
                                  padding: const EdgeInsets.only(top: 380, left: 230),
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
                                            style: TextStyle(fontFamily: 'Explora', fontSize: 250, fontWeight: FontWeight.bold, color: Theme.of(context).primaryColor, overflow: TextOverflow.ellipsis),
                                          ),
                                        ),
                                        //Level
                                        Text(
                                          '${Language.Translate('characters_create_level', options.language) ?? 'Level'}:  ${characters['character$index']['level']}',
                                          maxLines: 1,
                                          style: TextStyle(fontFamily: 'Explora', fontSize: 250, fontWeight: FontWeight.bold, color: Theme.of(context).primaryColor, overflow: TextOverflow.ellipsis),
                                        ),
                                        //Gold
                                        Text(
                                          '${Language.Translate('characters_create_gold', options.language) ?? 'Ouro'}:  ${returnGold(index)}',
                                          maxLines: 1,
                                          style: TextStyle(fontFamily: 'Explora', fontSize: 250, fontWeight: FontWeight.bold, color: Theme.of(context).primaryColor, overflow: TextOverflow.ellipsis),
                                        ),
                                        //Location
                                        Text(
                                          '${Language.Translate('characters_create_location', options.language) ?? 'Location'}:  ${Language.Translate('locations_${characters['character$index']['location'].substring(0, characters['character$index']['location'].length - 3)}', options.language) ?? 'Language Error'}',
                                          maxLines: 1,
                                          style: TextStyle(fontFamily: 'Explora', fontSize: 250, fontWeight: FontWeight.bold, color: Theme.of(context).primaryColor, overflow: TextOverflow.ellipsis),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                //Character Preview
                                Padding(
                                  padding: const EdgeInsets.only(top: 400.0, left: 1840),
                                  child: SizedBox(
                                    width: 800,
                                    height: 1300,
                                    child: CharacterWidget(
                                      scale: 20,
                                      body: Gameplay.returnBodyOptionAsset(raceID: raceID, bodyOption: 'body', gender: gender, selectedSprite: 'idle'),
                                      skin: Gameplay.returnBodyOptionAsset(raceID: raceID, bodyOption: 'skin', gender: gender, selectedSprite: 'idle'),
                                      skinColor: Color.fromARGB(
                                        255,
                                        characters['character$index']['body']['skinColor']['red'],
                                        characters['character$index']['body']['skinColor']['green'],
                                        characters['character$index']['body']['skinColor']['blue'],
                                      ),
                                      hair: Gameplay.returnBodyOptionAsset(raceID: raceID, bodyOption: 'hair', selectedOption: characters['character$index']['body']['hair']),
                                      hairColor: Color.fromARGB(
                                        255,
                                        characters['character$index']['body']['hairColor']['red'],
                                        characters['character$index']['body']['hairColor']['green'],
                                        characters['character$index']['body']['hairColor']['blue'],
                                      ),
                                      eyes: Gameplay.returnBodyOptionAsset(raceID: raceID, bodyOption: 'eyes', selectedOption: characters['character$index']['body']['eyes']),
                                      eyesColor: Color.fromARGB(
                                        255,
                                        characters['character$index']['body']['eyesColor']['red'],
                                        characters['character$index']['body']['eyesColor']['green'],
                                        characters['character$index']['body']['eyesColor']['blue'],
                                      ),
                                      mouth: Gameplay.returnBodyOptionAsset(raceID: raceID, bodyOption: 'mouth', selectedOption: characters['character$index']['body']['mouth']),
                                      mouthColor: Color.fromARGB(
                                        255,
                                        characters['character$index']['body']['mouthColor']['red'],
                                        characters['character$index']['body']['mouthColor']['green'],
                                        characters['character$index']['body']['mouthColor']['blue'],
                                      ),
                                    ),
                                  ),
                                ),
                                //Select Button
                                Padding(
                                  padding: const EdgeInsets.only(left: 1100.0, top: 1673),
                                  child: SizedBox(
                                    width: 600,
                                    height: 170,
                                    child: ElevatedButton(
                                      onPressed: () => selectCharacter(index),
                                      style: ButtonStyle(
                                        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                          RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(40.0),
                                            side: const BorderSide(color: Colors.black),
                                          ),
                                        ),
                                      ),
                                      child: FittedBox(
                                        child: Padding(
                                          padding: const EdgeInsets.all(200.0),
                                          child: Text(
                                            Language.Translate('response_select', options.language) ?? 'Select',
                                            style: const TextStyle(fontFamily: 'PressStart', fontSize: 500),
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

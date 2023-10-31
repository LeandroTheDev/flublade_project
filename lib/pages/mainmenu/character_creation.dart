// ignore_for_file: use_build_context_synchronously
import 'package:flublade_project/components/system/dialogs.dart';
import 'package:flublade_project/components/widget/character_widget.dart';
import 'package:flublade_project/components/widget/color_widget.dart';
import 'package:flublade_project/data/language.dart';
import 'package:flublade_project/data/server.dart';
import 'package:flublade_project/data/gameplay.dart';
import 'package:flublade_project/data/options.dart';
import 'package:flublade_project/pages/mainmenu/characters_menu.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CharacterCreation extends StatefulWidget {
  const CharacterCreation({super.key});

  @override
  State<CharacterCreation> createState() => _CharacterCreationState();
}

class _CharacterCreationState extends State<CharacterCreation> {
  int selectedClass = 0;

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final options = Provider.of<Options>(context);

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
              'assets/images/menu/character_creation/tavern.png',
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
                          'assets/images/menu/character_creation/book_view.png',
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
                            'assets/images/menu/classes/${Gameplay.classes[selectedClass]}.png',
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
                FittedBox(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: SizedBox(
                        height: screenSize.height * 0.15,
                        width: screenSize.width,
                        child: ElevatedButton(
                            onPressed: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => CharacterBody(selectedClass: selectedClass),
                                  ),
                                ),
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

class CharacterBody extends StatefulWidget {
  final int selectedClass;
  const CharacterBody({super.key, required this.selectedClass});

  @override
  State<CharacterBody> createState() => _CharacterBodyState();
}

class _CharacterBodyState extends State<CharacterBody> {
  TextEditingController createName = TextEditingController();
  //Page Declarations
  Map<String, Color> bodyColors = {
    "hairColor": const Color.fromARGB(255, 0, 0, 0),
    "eyesColor": const Color.fromARGB(255, 0, 0, 0),
    "mouthColor": const Color.fromARGB(255, 0, 0, 0),
    "skinColor": const Color.fromARGB(255, 0, 0, 0),
  };
  Map<String, dynamic> bodyOptions = {
    'gender': 0,
    'race': 0,
    'hair': 0,
    'eyes': 0,
    'mouth': 0,
    'skin': 0,
  };

  @override
  Widget build(BuildContext context) {
    //System Declarations
    final screenSize = MediaQuery.of(context).size;
    final options = Provider.of<Options>(context);

    //Change Body Options Button
    void changeBodyOptions(bool value, String selectedOption) {
      //Changing that is not a part of body
      //Race Changing
      raceChange() {
        if (value) {
          if (bodyOptions[selectedOption] == Gameplay.races.length - 1) {
            setState(() {
              bodyOptions[selectedOption] = 0;
            });
          } else {
            setState(() {
              bodyOptions[selectedOption] = bodyOptions[selectedOption]! + 1;
            });
          }
        } else {
          if (bodyOptions[selectedOption]! < 1) {
            setState(() {
              bodyOptions[selectedOption] = Gameplay.races.length - 1;
            });
          } else {
            setState(() {
              bodyOptions[selectedOption] = bodyOptions[selectedOption]! - 1;
            });
          }
        }
      }

      //Gender Changing
      genderChange() {
        switch (value) {
          case false:
            bodyOptions['gender'] = 0;
            return;
          case true:
            bodyOptions['gender'] = 1;
            return;
        }
      }

      if (value) {
        //Check if options is Race
        if (selectedOption == 'race') {
          raceChange();
          return;
        }
        //Check if options is Gender
        if (selectedOption == 'gender') {
          genderChange();
          return;
        }
        //Body Changing
        if (bodyOptions[selectedOption] == Gameplay.bodyOptions[Gameplay.races[bodyOptions['race']]][selectedOption].length - 1) {
          setState(() {
            bodyOptions[selectedOption] = 0;
          });
        } else {
          setState(() {
            bodyOptions[selectedOption] = bodyOptions[selectedOption]! + 1;
          });
        }
      } else {
        //Check if options is Race
        if (selectedOption == 'race') {
          raceChange();
          return;
        }
        //Check if options is Gender
        if (selectedOption == 'gender') {
          genderChange();
          return;
        }
        //Body Changing
        if (bodyOptions[selectedOption]! < 1) {
          setState(() {
            bodyOptions[selectedOption] = Gameplay.bodyOptions[Gameplay.races[bodyOptions['race']]][selectedOption].length - 1;
          });
        } else {
          setState(() {
            bodyOptions[selectedOption] = bodyOptions[selectedOption]! - 1;
          });
        }
      }
    }

    //Select Color Dialog for compatible items
    void selectColor(String body) {
      showDialog(
        context: context,
        builder: (context) => FittedBox(
          child: AlertDialog(
            shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(32.0))),
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            //Title
            title: Text(
              Language.Translate("characters_create_${body}_color", options.language) ?? "Language Error",
              style: TextStyle(color: Theme.of(context).primaryColor),
            ),
            //Color Select
            content: ColorSelect(
              onColorSelected: (Color color, BuildContext context) {
                setState(() {
                  bodyColors["${body}Color"] = color;
                });
                Navigator.pop(context);
              },
              previousColor: bodyColors["${body}Color"]!,
            ),
          ),
        ),
      );
    }

    //Select Username Dialog
    void usernameSelect() {
      createCharacter() async {
        //Class declaration
        String characterClass = Gameplay.classes[widget.selectedClass];
        //Loading Widget
        Dialogs.loadingDialog(context: context);
        //Creating body response
        Map bodyResponse = bodyOptions;
        bodyResponse['gender'] = bodyOptions['gender'] == 0 ? 'male' : 'female';
        bodyResponse['race'] = Gameplay.races[bodyOptions['race']];
        //Colors
        bodyResponse['hairColor'] = {
          'red': bodyColors['hairColor']!.red,
          'green': bodyColors['hairColor']!.green,
          'blue': bodyColors['hairColor']!.blue,
        };
        bodyResponse['eyesColor'] = {
          'red': bodyColors['eyesColor']!.red,
          'green': bodyColors['eyesColor']!.green,
          'blue': bodyColors['eyesColor']!.blue,
        };
        bodyResponse['mouthColor'] = {
          'red': bodyColors['mouthColor']!.red,
          'green': bodyColors['mouthColor']!.green,
          'blue': bodyColors['mouthColor']!.blue,
        };
        bodyResponse['skinColor'] = {
          'red': bodyColors['skinColor']!.red,
          'green': bodyColors['skinColor']!.green,
          'blue': bodyColors['skinColor']!.blue,
        };

        final Map result = await Server.sendMessage(
          context,
          address: '/createCharacters',
          body: {
            'id': options.id,
            'token': options.token,
            'name': createName.text,
            'class': characterClass,
            'body': bodyResponse,
          },
        );
        //Success
        if (result['message'] == 'Success') {
          Navigator.pop(context);
          Navigator.pop(context);
          Navigator.pop(context);
          Navigator.pop(context);
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => const CharactersMenu()));
        } else {
          Navigator.pop(context);
          Server.errorTreatment(result['message'], context);
          return;
        }
      }

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
                      onPressed: () => createCharacter(),
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
              'assets/images/menu/character_creation/tavern.png',
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
                          'assets/images/menu/character_creation/book_view.png',
                          fit: BoxFit.fill,
                        ),
                      ),
                      //You Text
                      SizedBox(
                        width: 950,
                        height: 580,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 510.0, top: 500),
                          child: FittedBox(
                            child: Text(
                              Language.Translate('characters_create_you', options.language) ?? 'You',
                              maxLines: 1,
                              style: const TextStyle(fontFamily: 'PressStart'),
                            ),
                          ),
                        ),
                      ),
                      //Type Text
                      SizedBox(
                        width: 2180,
                        height: 580,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 1810.0, top: 500),
                          child: FittedBox(
                            child: Text(
                              Language.Translate('characters_create_type', options.language) ?? 'Type',
                              maxLines: 1,
                              style: const TextStyle(fontFamily: 'PressStart'),
                            ),
                          ),
                        ),
                      ),
                      //Body View
                      Padding(
                        padding: const EdgeInsets.only(left: 350.0, top: 770),
                        child: CharacterWidget(
                          scale: 10.5,
                          body: Gameplay.returnBodyOptionAsset(raceID: bodyOptions['race'], bodyOption: 'body', gender: bodyOptions['gender'] == 1, selectedSprite: 'idle'),
                          skin: Gameplay.returnBodyOptionAsset(raceID: bodyOptions['race'], bodyOption: 'skin', gender: bodyOptions['gender'] == 1, selectedSprite: 'idle'),
                          skinColor: bodyColors['skinColor']!,
                          hair: Gameplay.returnBodyOptionAsset(raceID: bodyOptions['race'], bodyOption: 'hair', selectedOption: bodyOptions['hair']),
                          hairColor: bodyColors['hairColor']!,
                          eyes: Gameplay.returnBodyOptionAsset(raceID: bodyOptions['race'], bodyOption: 'eyes', selectedOption: bodyOptions['eyes']),
                          eyesColor: bodyColors['eyesColor']!,
                          mouth: Gameplay.returnBodyOptionAsset(raceID: bodyOptions['race'], bodyOption: 'mouth', selectedOption: bodyOptions['mouth']),
                          mouthColor: bodyColors['mouthColor']!,
                        ),
                      ),
                      //Body Customization
                      Padding(
                        padding: const EdgeInsets.only(left: 1700.0, top: 750),
                        child: SizedBox(
                          width: 650,
                          height: 1350,
                          child: SingleChildScrollView(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                //Gender
                                Column(
                                  children: [
                                    Text(
                                      Language.Translate('characters_create_gender', options.language) ?? 'Gender',
                                      style: const TextStyle(fontFamily: 'Explora', fontSize: 200, fontWeight: FontWeight.bold, letterSpacing: 10),
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        TextButton(
                                          onPressed: () => changeBodyOptions(false, 'gender'),
                                          child: const Icon(Icons.male, size: 175),
                                        ),
                                        TextButton(
                                          onPressed: () => changeBodyOptions(false, 'gender'),
                                          child: const Icon(Icons.female, size: 175),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                //Spacer
                                const SizedBox(height: 100),
                                //Race
                                Column(
                                  children: [
                                    Text(
                                      Language.Translate('characters_race_${Gameplay.races[bodyOptions['race']]}', options.language) ?? 'Race',
                                      style: const TextStyle(fontFamily: 'Explora', fontSize: 200, fontWeight: FontWeight.bold, letterSpacing: 10),
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        TextButton(
                                          onPressed: () => changeBodyOptions(false, 'race'),
                                          child: const Icon(Icons.arrow_back, size: 175),
                                        ),
                                        TextButton(
                                          onPressed: () => changeBodyOptions(true, 'race'),
                                          child: const Icon(Icons.arrow_forward, size: 175),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                //Spacer
                                const SizedBox(height: 100),
                                //Hair
                                Column(
                                  children: [
                                    Text(
                                      Language.Translate('characters_create_hair', options.language) ?? 'Hair',
                                      style: const TextStyle(fontFamily: 'Explora', fontSize: 200, fontWeight: FontWeight.bold, letterSpacing: 10),
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        TextButton(
                                          onPressed: () => changeBodyOptions(false, 'hair'),
                                          child: const Icon(Icons.arrow_back, size: 175),
                                        ),
                                        TextButton(
                                          onPressed: () => changeBodyOptions(true, 'hair'),
                                          child: const Icon(Icons.arrow_forward, size: 175),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                //Hair Color
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    //Change Color Button
                                    TextButton(
                                      onPressed: () => selectColor("hair"),
                                      child: Text(
                                        Language.Translate('characters_create_hair_color', options.language) ?? 'Hair Color',
                                        style: const TextStyle(fontFamily: 'Explora', fontSize: 130, fontWeight: FontWeight.bold, letterSpacing: 10),
                                      ),
                                    ),
                                    //Color Preview
                                    Container(
                                      width: 80,
                                      height: 80,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: bodyColors["hairColor"],
                                      ),
                                    )
                                  ],
                                ),
                                //Spacer
                                const SizedBox(height: 100),
                                //Eyes
                                Column(
                                  children: [
                                    Text(
                                      Language.Translate('chatacters_create_eyes', options.language) ?? 'Eyes',
                                      style: const TextStyle(fontFamily: 'Explora', fontSize: 200, fontWeight: FontWeight.bold, letterSpacing: 10),
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        TextButton(
                                          onPressed: () => changeBodyOptions(false, 'eyes'),
                                          child: const Icon(Icons.arrow_back, size: 175),
                                        ),
                                        TextButton(
                                          onPressed: () => changeBodyOptions(true, 'eyes'),
                                          child: const Icon(Icons.arrow_forward, size: 175),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                //Eyes Color
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    //Change Color Button
                                    TextButton(
                                      onPressed: () => selectColor("eyes"),
                                      child: Text(
                                        Language.Translate('characters_create_eyes_color', options.language) ?? 'Eyes Color',
                                        style: const TextStyle(fontFamily: 'Explora', fontSize: 130, fontWeight: FontWeight.bold, letterSpacing: 10),
                                      ),
                                    ),
                                    //Color Preview
                                    Container(
                                      width: 80,
                                      height: 80,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: bodyColors["eyesColor"],
                                      ),
                                    )
                                  ],
                                ),
                                //Spacer
                                const SizedBox(height: 100),
                                //Mouth
                                Column(
                                  children: [
                                    Text(
                                      Language.Translate('chatacters_create_mouth', options.language) ?? 'Mouth',
                                      style: const TextStyle(fontFamily: 'Explora', fontSize: 200, fontWeight: FontWeight.bold, letterSpacing: 10),
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        TextButton(
                                          onPressed: () => changeBodyOptions(false, 'mouth'),
                                          child: const Icon(Icons.arrow_back, size: 175),
                                        ),
                                        TextButton(
                                          onPressed: () => changeBodyOptions(true, 'mouth'),
                                          child: const Icon(Icons.arrow_forward, size: 175),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                //Mouth Color
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    //Change Color Button
                                    TextButton(
                                      onPressed: () => selectColor("mouth"),
                                      child: Text(
                                        Language.Translate('characters_create_mouth_color', options.language) ?? 'Mouth Color',
                                        style: const TextStyle(fontFamily: 'Explora', fontSize: 130, fontWeight: FontWeight.bold, letterSpacing: 10),
                                      ),
                                    ),
                                    //Color Preview
                                    Container(
                                      width: 80,
                                      height: 80,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: bodyColors["mouthColor"],
                                      ),
                                    )
                                  ],
                                ),
                                //Spacer
                                const SizedBox(height: 100),
                                //Skin
                                Column(
                                  children: [
                                    Text(
                                      Language.Translate('chatacters_create_skin', options.language) ?? 'Skin',
                                      style: const TextStyle(fontFamily: 'Explora', fontSize: 200, fontWeight: FontWeight.bold, letterSpacing: 10),
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        TextButton(
                                          onPressed: () => changeBodyOptions(false, 'skin'),
                                          child: const Icon(Icons.arrow_back, size: 175),
                                        ),
                                        TextButton(
                                          onPressed: () => changeBodyOptions(true, 'skin'),
                                          child: const Icon(Icons.arrow_forward, size: 175),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                //Skin Color
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    //Change Color Button
                                    TextButton(
                                      onPressed: () => selectColor("skin"),
                                      child: Text(
                                        Language.Translate('characters_create_mouth_skin', options.language) ?? 'Skin Color',
                                        style: const TextStyle(fontFamily: 'Explora', fontSize: 130, fontWeight: FontWeight.bold, letterSpacing: 10),
                                      ),
                                    ),
                                    //Color Preview
                                    Container(
                                      width: 80,
                                      height: 80,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: bodyColors["skinColor"],
                                      ),
                                    )
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                //Confirm
                FittedBox(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: SizedBox(
                        height: screenSize.height * 0.15,
                        width: screenSize.width,
                        child: ElevatedButton(
                            onPressed: () => usernameSelect(),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: FittedBox(
                                child: Text(
                                  Language.Translate('response_confirm', options.language) ?? 'Confirm',
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

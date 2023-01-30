import 'package:flublade_project/data/global.dart';
import 'package:flublade_project/data/language.dart';
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
                              Language.Translate('characters_create_class',
                                      options.language) ??
                                  'Class',
                              maxLines: 1,
                              style: const TextStyle(fontFamily: 'PressStart'),
                            ),
                          ),
                        ),
                      ),
                      //Class Text
                      SizedBox(
                        width: 2180,
                        height: 580,
                        child: Padding(
                          padding:
                              const EdgeInsets.only(left: 1810.0, top: 500),
                          child: FittedBox(
                            child: Text(
                              Language.Translate('characters_create_info',
                                      options.language) ??
                                  'Info',
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
                                  Gameplay.returnClassInfo(
                                      selectedClass, options.language),
                                  style: const TextStyle(
                                      fontFamily: 'Explora',
                                      fontSize: 200,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 10),
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
                            Language.Translate(
                                    'response_back', options.language) ??
                                'Back',
                            style: TextStyle(
                                fontSize: 20,
                                fontFamily: 'PressStart',
                                color: Theme.of(context).primaryColor),
                          ),
                        ),
                        SizedBox(width: 30),
                        //Next Button
                        TextButton(
                          onPressed: () {
                            changeClass(true);
                          },
                          child: Text(
                            Language.Translate(
                                    'response_next', options.language) ??
                                'Next',
                            style: TextStyle(
                                fontSize: 20,
                                fontFamily: 'PressStart',
                                color: Theme.of(context).primaryColor),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                FittedBox(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: SizedBox(
                        height: screenSize.height * 0.15,
                        width: screenSize.width,
                        child: ElevatedButton(
                            onPressed: () {},
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
              ],
            ),
          ),
        ],
      ),
    );
  }
}

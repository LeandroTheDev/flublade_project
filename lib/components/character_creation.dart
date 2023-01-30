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
          Column(
            children: [
              SizedBox(height: screenSize.height * 0.07),
              //Book Selection
              FittedBox(
                child: Stack(
                  children: [
                    //Book Image
                    SizedBox(
                      width: 2800,
                      height: 2400,
                      child: Image.asset(
                        'assets/open_book.png',
                        fit: BoxFit.fill,
                      ),
                    ),
                    //Class Text
                    SizedBox(
                      width: 950,
                      height: 500,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 510.0, top: 400),
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
                      height: 500,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 1810.0, top: 400),
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
                      height: 1780,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 350.0, top: 670),
                        child: Image.asset(
                          Gameplay.classes[selectedClass],
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),
                    //Next Button
                    Padding(
                      padding: const EdgeInsets.only(left: 1820.0, top: 1850),
                      child: SizedBox(
                          width: 400,
                          height: 130,
                          child: TextButton(
                              onPressed: () {
                                changeClass(true);
                              },
                              child: Center(
                                child: FittedBox(
                                  child: Text(
                                    Language.Translate('response_next', options.language) ?? 'Next',
                                    style: TextStyle(
                                        fontSize: 80,
                                        fontFamily: 'PressStart',
                                        color: Theme.of(context).primaryColor),
                                  ),
                                ),
                              ))),
                    ),
                    //Back Button
                    Padding(
                      padding: const EdgeInsets.only(left: 590.0, top: 1850),
                      child: SizedBox(
                          width: 400,
                          height: 130,
                          child: TextButton(
                              onPressed: () {
                                changeClass(false);
                              },
                              child: Center(
                                child: FittedBox(
                                  child: Text(
                                    Language.Translate('response_back', options.language) ?? 'Back',
                                    style: TextStyle(
                                        fontSize: 80,
                                        fontFamily: 'PressStart',
                                        color: Theme.of(context).primaryColor),
                                  ),
                                ),
                              ))),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

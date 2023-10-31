import 'package:flublade_project/components/system/dialogs.dart';
import 'package:flublade_project/data/global.dart';
import 'package:flublade_project/data/language.dart';
import 'package:flublade_project/data/options.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class OptionsMenu extends StatefulWidget {
  const OptionsMenu({super.key});

  @override
  State<OptionsMenu> createState() => _OptionsMenuState();
}

class _OptionsMenuState extends State<OptionsMenu> {
  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final options = Provider.of<Options>(context);

    //Change Text Speed
    changeTextSpeed(context) {
      final screenSize = MediaQuery.of(context).size;
      final options = Provider.of<Options>(context, listen: false);

      showDialog(
          barrierColor: const Color.fromARGB(167, 0, 0, 0),
          context: context,
          builder: (context) {
            return FittedBox(
              child: AlertDialog(
                shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(32.0))),
                backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                //Language Text
                title: Text(
                  Language.Translate('options_fasttext', options.language) ?? 'Text Speed',
                  style: TextStyle(color: Theme.of(context).primaryColor),
                ),
                content: SizedBox(
                  width: screenSize.width * 0.5,
                  height: screenSize.height * 0.3,
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        //Very Small
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: ElevatedButton(
                            onPressed: () {
                              options.changeTextSpeed(1500);
                              SaveDatas.setTextSpeed(options.textSpeed);
                              Navigator.pop(context);
                            },
                            child: Text(
                              Language.Translate('options_fasttext_verySmall', options.language) ?? 'Very Small',
                            ),
                          ),
                        ),
                        //Small
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: ElevatedButton(
                            onPressed: () {
                              options.changeTextSpeed(700);
                              SaveDatas.setTextSpeed(options.textSpeed);
                              Navigator.pop(context);
                            },
                            child: Text(
                              Language.Translate('options_fasttext_small', options.language) ?? 'Small',
                            ),
                          ),
                        ),
                        //Medium
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: ElevatedButton(
                            onPressed: () {
                              options.changeTextSpeed(300);
                              SaveDatas.setTextSpeed(options.textSpeed);
                              Navigator.pop(context);
                            },
                            child: Text(
                              Language.Translate('options_fasttext_medium', options.language) ?? 'Medium',
                            ),
                          ),
                        ),
                        //High
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: ElevatedButton(
                            onPressed: () {
                              options.changeTextSpeed(50);
                              SaveDatas.setTextSpeed(options.textSpeed);
                              Navigator.pop(context);
                            },
                            child: Text(
                              Language.Translate('options_fasttext_high', options.language) ?? 'High',
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          });
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
          SingleChildScrollView(
            child: Column(
              children: [
                //Change Language
                Padding(
                  padding: const EdgeInsets.only(top: 100),
                  child: Center(
                    child: TextButton(
                      onPressed: () {
                        setState(() {
                          Dialogs.changeLanguage(context, super.widget);
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.all(20),
                        height: screenSize.height * 0.2,
                        width: screenSize.width * 0.8,
                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(20), color: Theme.of(context).colorScheme.secondary),
                        child: FittedBox(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              //Icon and Text
                              Row(
                                children: [
                                  Icon(Icons.language, color: Theme.of(context).primaryColor),
                                  const SizedBox(width: 5),
                                  Text(
                                    Language.Translate('options_language', options.language) ?? 'Change Language',
                                    style: TextStyle(color: Theme.of(context).primaryColor),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                //Change Text Speed
                Padding(
                  padding: const EdgeInsets.only(top: 50),
                  child: Center(
                    child: TextButton(
                      onPressed: () {
                        setState(() {
                          changeTextSpeed(context);
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.all(20),
                        height: screenSize.height * 0.2,
                        width: screenSize.width * 0.8,
                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(20), color: Theme.of(context).colorScheme.secondary),
                        child: FittedBox(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              //Icon and Text
                              Row(
                                children: [
                                  Icon(Icons.text_fields, color: Theme.of(context).primaryColor),
                                  const SizedBox(width: 5),
                                  Text(
                                    Language.Translate('options_fasttext', options.language) ?? 'Change Language',
                                    style: TextStyle(color: Theme.of(context).primaryColor),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

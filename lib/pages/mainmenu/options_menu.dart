import 'package:flublade_project/data/global.dart';
import 'package:flublade_project/data/language.dart';
import 'package:flublade_project/data/mysqldata.dart';

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
          Column(
            children: [
              //Change Language
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 100),
                child: Center(
                  child: TextButton(
                    onPressed: () {
                      MySQL.changeLanguage(context, super.widget);
                    },
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      height: screenSize.height * 0.2,
                      width: screenSize.width * 0.8,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Theme.of(context).colorScheme.secondary),
                      child: FittedBox(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            //Icon and Text
                            Row(
                              children: [
                                Icon(Icons.language,
                                    color: Theme.of(context).primaryColor),
                                const SizedBox(width: 5),
                                Text(
                                  Language.Translate('options_language',
                                          options.language) ??
                                      'Change Language',
                                  style: TextStyle(
                                      color: Theme.of(context).primaryColor),
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
          )
        ],
      ),
    );
  }
}

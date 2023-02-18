import 'package:flublade_project/data/global.dart';
import 'package:flublade_project/data/language.dart';
import 'package:flublade_project/data/mysqldata.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BattleScene extends StatefulWidget {
  const BattleScene({super.key});

  @override
  State<BattleScene> createState() => _BattleSceneState();
}

class _BattleSceneState extends State<BattleScene> {
  @override
  Widget build(BuildContext context) {
    final options = Provider.of<Options>(context, listen: false);
    final gameplay = Provider.of<Gameplay>(context);
    final screenSize = MediaQuery.of(context).size;
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
          body: FutureBuilder(
        future: MySQLGameplay.returnEnemyStats(context),
        builder: (context, future) {
          if (future.hasData) {
            return SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(height: screenSize.height * 0.07,),
                  //Top Side Screen
                  Row(
                    children: [
                      //Life & Mana
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Column(
                          children: [
                            //Life
                            SizedBox(
                              width: screenSize.width * 0.5,
                              child: FittedBox(
                                child: Row(
                                  children: [
                                    //Life Image
                                    Padding(
                                      padding: const EdgeInsets.all(150.0),
                                      child: SizedBox(
                                        width: 1000,
                                        height: 1000,
                                        child: Image.asset(
                                          'assets/images/interface/hearth.png',
                                          fit: BoxFit.fill,
                                        ),
                                      ),
                                    ),
                                    //Life
                                    SizedBox(
                                      width: 5500,
                                      height: 500,
                                      child: Text(
                                        '${Language.Translate('life', options.language) ?? 'Life'}: ${gameplay.playerLife}',
                                        style: const TextStyle(
                                            fontFamily: 'PressStart',
                                            fontSize: 500),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            //Mana
                            SizedBox(
                              width: screenSize.width * 0.5,
                              child: FittedBox(
                                child: Row(
                                  children: [
                                    //Mana Image
                                    Padding(
                                      padding: const EdgeInsets.all(150.0),
                                      child: SizedBox(
                                        width: 1000,
                                        height: 1000,
                                        child: Image.asset(
                                          'assets/images/interface/mana.png',
                                          fit: BoxFit.fill,
                                        ),
                                      ),
                                    ),
                                    //Mana
                                    SizedBox(
                                      width: 5500,
                                      height: 500,
                                      child: Text(
                                        '${Language.Translate('mana', options.language) ?? 'Mana'}: ${gameplay.playerMana}',
                                        style: const TextStyle(
                                            fontFamily: 'PressStart',
                                            fontSize: 500),
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
                  //Image
                  SizedBox(
                    width: screenSize.width,
                    height: screenSize.height * 0.35,
                    child: Stack(
                      children: [
                        //Background image
                        SizedBox(
                          width: screenSize.width,
                          height: screenSize.height * 0.45,
                          child: Image.asset(
                              'assets/locations/prologue/paradise.png',
                              fit: BoxFit.cover),
                        ),
                        //Enemy image
                        SizedBox(
                          width: screenSize.width,
                          height: screenSize.height * 0.45,
                          child: Center(
                            child: Image.asset(
                              'assets/images/enemys/infight/small_spider.png',
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  //Buttons
                  SizedBox(
                    height: screenSize.height * 0.30,
                    width: screenSize.width,
                    child: Column(
                      children: [
                        const Spacer(),
                        //Attack & Defence
                        Container(
                          padding: const EdgeInsets.all(20),
                          width: screenSize.width,
                          height: screenSize.height * 0.2,
                          child: FittedBox(
                            child: Row(
                              children: [
                                ElevatedButton(
                                  onPressed: () {},
                                  child: Text(Language.Translate(
                                          'attack', options.language) ??
                                      'Attack'),
                                ),
                                const SizedBox(width: 20),
                                ElevatedButton(
                                  onPressed: () {},
                                  child: Text(Language.Translate(
                                          'defence', options.language) ??
                                      'Defence'),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const Spacer(),
                        //Inventory & Magics
                        SizedBox(
                          width: screenSize.width,
                          height: screenSize.height * 0.10,
                          child: FittedBox(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                //Inventory
                                TextButton(
                                  onPressed: () {
                                    Navigator.pushNamed(context, '/inventory');
                                  },
                                  child: Container(
                                    width: 70,
                                    height: 50,
                                    decoration: BoxDecoration(
                                      color:
                                          Theme.of(context).colorScheme.secondary,
                                      borderRadius: BorderRadius.circular(100),
                                    ),
                                    child: const Icon(Icons.inventory_2_outlined),
                                  ),
                                ),
                                SizedBox(
                                  width: screenSize.width * 0.3,
                                ),
                                //Magics
                                TextButton(
                                  onPressed: () {
                                    Navigator.pushNamed(context, '/inventory');
                                  },
                                  child: Container(
                                    width: 70,
                                    height: 50,
                                    decoration: BoxDecoration(
                                      color:
                                          Theme.of(context).colorScheme.secondary,
                                      borderRadius: BorderRadius.circular(100),
                                    ),
                                    child: const Icon(Icons.menu_book),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            );
            //Loading Widget
          } else {
            return Center(
                child: SizedBox(
              width: screenSize.width,
              height: screenSize.height * 0.2,
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: FittedBox(
                  child: Column(
                    children: [
                      //Circular Loading
                      const CircularProgressIndicator(),
                      //Loading Please Wait
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 25.0),
                        child: Text(
                          Language.Translate(
                                  'response_loading', options.language) ??
                              'Loading Please Wait',
                          style: const TextStyle(fontFamily: 'PressStart'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ));
          }
        },
      )),
    );
  }
}

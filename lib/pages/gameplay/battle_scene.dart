import 'package:flublade_project/data/global.dart';
import 'package:flublade_project/data/language.dart';
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
          body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: screenSize.height * 0.07),
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
                                  '${Language.Translate('battle_life', options.language) ?? 'Life'}: ${gameplay.playerLife}',
                                  style: const TextStyle(
                                      fontFamily: 'PressStart', fontSize: 500),
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
                                  '${Language.Translate('battle_mana', options.language) ?? 'Mana'}: ${gameplay.playerMana}',
                                  style: const TextStyle(
                                      fontFamily: 'PressStart', fontSize: 500),
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
            //Enemy Show
            Stack(
              children: [
                //Background image
                SizedBox(
                  width: screenSize.width,
                  height: screenSize.height * 0.45,
                  child: Image.asset('assets/locations/prologue/paradise.png',
                      fit: BoxFit.cover),
                ),
                //Enemy image
                SizedBox(
                  width: screenSize.width,
                  height: screenSize.height * 0.45,
                  child: FittedBox(
                    child: Stack(
                      children: [
                        //Enemy Image
                        SizedBox(
                          width: 5000,
                          height: 3000,
                          child: Image.asset(
                            'assets/images/enemys/infight/small_spider.png',
                            fit: BoxFit.fitWidth,
                          ),
                        ),
                        //Enemy Level
                        Padding(
                          padding: const EdgeInsets.only(
                            top: 200,
                            left: 2000,
                          ),
                          child: SizedBox(
                            width: 1100,
                            height: 600,
                            child: Center(
                              child: Stack(
                                children: [
                                  //Border
                                  Text(
                                    gameplay.enemyLevel.toString(),
                                    style: TextStyle(
                                      fontSize: 500,
                                      fontFamily: 'PressStart',
                                      letterSpacing: 5,
                                      fontWeight: FontWeight.bold,
                                      foreground: Paint()
                                        ..style = PaintingStyle.stroke
                                        ..strokeWidth = 40
                                        ..color = Colors.white,
                                    ),
                                  ),
                                  //Text
                                  Text(
                                    gameplay.enemyLevel.toString(),
                                    style: const TextStyle(
                                        fontSize: 500,
                                        fontFamily: 'PressStart'),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                //Life & Mana
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: SizedBox(
                    width: screenSize.width,
                    height: screenSize.height * 0.45,
                    child: Column(
                      children: [
                        FittedBox(
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 500.0),
                            child: Row(
                              children: [
                                //ELife Image
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 200.0),
                                  child: SizedBox(
                                    width: 1000,
                                    height: 1000,
                                    child: Image.asset(
                                      'assets/images/interface/ehearth.png',
                                      fit: BoxFit.fill,
                                    ),
                                  ),
                                ),
                                //ELife Text
                                Stack(
                                  children: [
                                    Text(
                                      '${Language.Translate('battle_life', options.language) ?? 'Life'}: ${gameplay.enemyLife}',
                                      style: TextStyle(
                                        fontSize: 500,
                                        fontFamily: 'PressStart',
                                        letterSpacing: 5,
                                        fontWeight: FontWeight.bold,
                                        foreground: Paint()
                                          ..style = PaintingStyle.stroke
                                          ..strokeWidth = 35
                                          ..color = Colors.white,
                                      ),
                                    ),
                                    Text(
                                      '${Language.Translate('battle_life', options.language) ?? 'Life'}: ${gameplay.enemyLife}',
                                      style: const TextStyle(
                                        fontSize: 500,
                                        letterSpacing: 5,
                                        fontFamily: 'PressStart',
                                      ),
                                    ),
                                  ],
                                ),
                                //Spacer
                                const SizedBox(
                                  width: 1200,
                                ),
                                //EMana Image
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 200.0),
                                  child: SizedBox(
                                    width: 1000,
                                    height: 1000,
                                    child: Image.asset(
                                      'assets/images/interface/emana.png',
                                      fit: BoxFit.fill,
                                    ),
                                  ),
                                ),
                                //EMana Text
                                Stack(
                                  children: [
                                    Text(
                                      '${Language.Translate('battle_mana', options.language) ?? 'Mana'}: ${gameplay.enemyMana}',
                                      style: TextStyle(
                                        fontSize: 500,
                                        fontFamily: 'PressStart',
                                        letterSpacing: 5,
                                        fontWeight: FontWeight.bold,
                                        foreground: Paint()
                                          ..style = PaintingStyle.stroke
                                          ..strokeWidth = 35
                                          ..color = Colors.white,
                                      ),
                                    ),
                                    Text(
                                      '${Language.Translate('battle_mana', options.language) ?? 'Mana'}: ${gameplay.enemyMana}',
                                      style: const TextStyle(
                                        fontSize: 500,
                                        letterSpacing: 5,
                                        fontFamily: 'PressStart',
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
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
                          //Attack Button
                          ElevatedButton(
                            onPressed: () {
                              Gameplay.classTranslation(
                                  playerDamageCalculationInEnemy: true,
                                  values: null,
                                  context: context);
                              if (gameplay.enemyLife <= 0) {
                                GlobalFunctions.lootDialog(
                                  errorMsgTitle: 'battle_loot',
                                  errorMsgContext: '',
                                  context: context,
                                  enemySpecialLoot: [],
                                );
                              }
                            },
                            child: Text(Language.Translate(
                                    'attack', options.language) ??
                                'Attack'),
                          ),
                          const SizedBox(width: 20),
                          //Defence Button
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
                                color: Theme.of(context).colorScheme.secondary,
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
                                color: Theme.of(context).colorScheme.secondary,
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
      )),
    );
  }
}

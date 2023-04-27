import 'dart:convert';

import 'package:flublade_project/data/global.dart';
import 'package:flublade_project/data/language.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

import '../../data/mysqldata.dart';

class BattleScene extends StatefulWidget {
  final BuildContext backContext;
  const BattleScene({required this.backContext, super.key});

  @override
  State<BattleScene> createState() => _BattleSceneState();
}

class _BattleSceneState extends State<BattleScene> {
  bool isFighting = false;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    //Start battle in last log
    Future.delayed(const Duration(milliseconds: 1)).then((value) =>
        _scrollController.animateTo(_scrollController.position.maxScrollExtent,
            duration: const Duration(milliseconds: 1), curve: Curves.linear));
  }

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
            //Buttons & Inventory
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
                          !isFighting
                              ? ElevatedButton(
                                  onPressed: () async {
                                    setState(() {
                                      isFighting = true;
                                    });
                                    //Attack Enemy
                                    dynamic result = await http.post(
                                        Uri.http(MySQL.url, 'attackEnemy'),
                                        headers: MySQL.headers,
                                        body: jsonEncode({
                                          'enemyLife': gameplay.enemyLife,
                                          'enemyArmor': gameplay.enemyArmor,
                                          'enemyMana': gameplay.enemyMana,
                                          'enemyDamage': gameplay.enemyDamage,
                                          'enemyXP': gameplay.enemyXP,
                                          'enemyLevel': gameplay.enemyLevel,
                                          'playerSkill':
                                              gameplay.playerSelectedSkill,
                                          'selectedCharacter':
                                              gameplay.selectedCharacter,
                                          'enemyName': gameplay.enemyName,
                                          'id': options.id,
                                          'token': options.token,
                                        }));
                                    result = jsonDecode(result.body);
                                    //Continue Battle
                                    for (int i = 0;
                                        i < result['battleLog'].length;
                                        i++) {
                                      // ignore: use_build_context_synchronously
                                      gameplay.addBattleLog(
                                          result['battleLog'][i], context);
                                      //Animation
                                      Future.delayed(
                                              const Duration(milliseconds: 10))
                                          .then((value) => //Animation
                                              _scrollController.animateTo(
                                                  _scrollController
                                                      .position.maxScrollExtent,
                                                  duration: const Duration(
                                                      milliseconds: 300),
                                                  curve: Curves.easeOut));
                                      await Future.delayed(Duration(
                                          milliseconds: options.textSpeed));
                                    }
                                    //Update Enemy
                                    if (true) {
                                      gameplay.changeStats(
                                          value: result['enemyLife'],
                                          stats: 'elife');
                                      gameplay.changeStats(
                                          value: result['enemyMana'],
                                          stats: 'emana');
                                      gameplay.changeStats(
                                          value: result['enemyArmor'],
                                          stats: 'earmor');
                                    }
                                    //Player Dead
                                    if (result['message'] == 'Player Dead') {
                                      gameplay.changeStats(
                                          value: 0.0, stats: 'life');
                                      await Future.delayed(
                                          const Duration(seconds: 1));
                                      // ignore: use_build_context_synchronously
                                      Navigator.pop(context);
                                      // ignore: use_build_context_synchronously
                                      Navigator.pop(context);
                                      // ignore: use_build_context_synchronously
                                      Navigator.pushNamed(context, '/mainmenu');
                                      gameplay.changeEnemyMove(true);
                                    }
                                    // ignore: use_build_context_synchronously
                                    await MySQL.returnPlayerStats(context);
                                    //Enemy Dead
                                    if (result['message'] == 'Enemy Dead') {
                                      GlobalFunctions.lootDialog(
                                          context: context,
                                          loots: result['loots'],
                                          xp: result['earnedXP']);
                                    }
                                    setState(() {
                                      isFighting = false;
                                    });
                                  },
                                  child: Text(Language.Translate(
                                          'magics_${gameplay.playerSelectedSkill}',
                                          options.language) ??
                                      'Attack'),
                                )
                              : ElevatedButton(
                                  onPressed: null,
                                  child: Text(Language.Translate(
                                          'magics_${gameplay.playerSelectedSkill}',
                                          options.language) ??
                                      'Attack'),
                                ),
                          const SizedBox(width: 20),
                          //Defence Button
                          !isFighting
                              ? ElevatedButton(
                                  onPressed: () {
                                    isFighting = true;
                                  },
                                  child: Text(Language.Translate(
                                          'battle_defence', options.language) ??
                                      'Defence'),
                                )
                              : ElevatedButton(
                                  onPressed: null,
                                  child: Text(Language.Translate(
                                          'battle_defence', options.language) ??
                                      'Defence'),
                                ),
                        ],
                      ),
                    ),
                  ),
                  const Spacer(),
                  //Inventory & Magics & Log
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
                              width: screenSize.width * 0.2,
                              height: screenSize.height * 0.1,
                              decoration: BoxDecoration(
                                color: Theme.of(context).colorScheme.secondary,
                                borderRadius: BorderRadius.circular(100),
                              ),
                              child: const FittedBox(
                                  child: Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Icon(Icons.inventory_2_outlined),
                              )),
                            ),
                          ),
                          //Battle Log
                          Container(
                            padding: const EdgeInsets.all(5),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: Theme.of(context).colorScheme.secondary),
                            width: screenSize.width * 0.6,
                            height: screenSize.height * 0.1,
                            child: FittedBox(
                              child: SizedBox(
                                width: screenSize.width * 0.6,
                                height: screenSize.height * 0.1,
                                child: ListView.builder(
                                    controller: _scrollController,
                                    itemCount: gameplay.battleLog.length,
                                    shrinkWrap: true,
                                    itemBuilder: (context, index) {
                                      return Text(
                                        gameplay.battleLog[index],
                                        style: const TextStyle(
                                            color: Colors.white, fontSize: 18),
                                      );
                                    }),
                              ),
                            ),
                          ),
                          //Magics
                          TextButton(
                            onPressed: () {
                              Navigator.pushNamed(context, '/magics')
                                  .then((value) => setState(() {}));
                            },
                            child: Container(
                              width: screenSize.width * 0.2,
                              height: screenSize.height * 0.1,
                              decoration: BoxDecoration(
                                color: Theme.of(context).colorScheme.secondary,
                                borderRadius: BorderRadius.circular(100),
                              ),
                              child: const FittedBox(
                                  child: Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Icon(Icons.menu_book),
                              )),
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

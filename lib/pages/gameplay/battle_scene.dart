import 'package:flublade_project/data/gameplay/skills.dart';
import 'package:flublade_project/data/global.dart';
import 'package:flublade_project/data/language.dart';
import 'package:flublade_project/pages/mainmenu/main_menu.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BattleScene extends StatefulWidget {
  const BattleScene({super.key});

  @override
  State<BattleScene> createState() => _BattleSceneState();
}

class _BattleSceneState extends State<BattleScene> {
  bool isFighting = false;
  final ScrollController _scrollController = ScrollController();

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
                                    final resultPlayer =
                                        await ClassAtributes.battleFunctions(
                                            playerDamageCalculationInEnemy:
                                                true,
                                            values: 'playerTurn',
                                            context: context);
                                    //Add battlelog
                                    setState(() {
                                      gameplay.addBattleLog(
                                          '${Language.Translate('battle_log_playerAttack1', options.language) ?? 'You did'} ${resultPlayer[0]} ${Language.Translate('battle_log_playerAttack2', options.language) ?? 'damage to'} ${Language.Translate('enemy_${gameplay.enemyName}', options.language) ?? 'Language Error'}');
                                    });
                                    //Delay to fix animation bug
                                    await Future.delayed(
                                        const Duration(milliseconds: 10));
                                    //Animation
                                    _scrollController.animateTo(
                                        _scrollController
                                            .position.maxScrollExtent,
                                        duration:
                                            const Duration(milliseconds: 300),
                                        curve: Curves.easeOut);
                                    //Verification if the player is dead
                                    if (resultPlayer == 'dead') {
                                      // ignore: use_build_context_synchronously
                                      Navigator.of(context).pushAndRemoveUntil(
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  const MainMenu()),
                                          (Route<dynamic> route) => false);
                                      gameplay.changeEnemyMove(true);
                                    }
                                    final resultEnemy =
                                        await ClassAtributes.battleFunctions(
                                            playerDamageCalculationInEnemy:
                                                true,
                                            values: 'enemyTurn',
                                            context: context);
                                    //Add battlelog
                                    setState(() {
                                      gameplay.addBattleLog(
                                          '${Language.Translate('battle_log_enemyAttack1', options.language) ?? 'You received'} ${resultEnemy[0]} ${Language.Translate('battle_log_enemyAttack2', options.language) ?? 'damage from'} ${Language.Translate('enemy_${gameplay.enemyName}', options.language) ?? 'Language Error'}');
                                    });
                                    //Delay to fix animation bug
                                    await Future.delayed(
                                        const Duration(milliseconds: 10));
                                    //Animation
                                    _scrollController.animateTo(
                                        _scrollController
                                            .position.maxScrollExtent,
                                        duration:
                                            const Duration(milliseconds: 300),
                                        curve: Curves.easeOut);
                                    //Verification if the enemy is dead
                                    if (gameplay.enemyLife <= 0) {
                                      GlobalFunctions.lootDialog(
                                        errorMsgTitle: 'battle_loot',
                                        errorMsgContext: '',
                                        context: context,
                                        enemySpecialLoot: [],
                                      );
                                    }
                                    await Future.delayed(
                                        const Duration(milliseconds: 100));
                                    //Enable buttons
                                    setState(() {
                                      isFighting = false;
                                    });
                                  },
                                  child: Text(Language.Translate(
                                          'battle_attack', options.language) ??
                                      'Attack'),
                                )
                              : ElevatedButton(
                                  onPressed: null,
                                  child: Text(Language.Translate(
                                          'battle_attack', options.language) ??
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
                                padding: const EdgeInsets.all(8.0),
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

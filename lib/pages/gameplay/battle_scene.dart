// ignore_for_file: use_build_context_synchronously

import 'dart:async';
import 'dart:convert';

import 'package:flublade_project/data/global.dart';
import 'package:flublade_project/data/language.dart';
import 'package:flublade_project/pages/mainmenu/main_menu.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../data/mysqldata.dart';

class BattleScene extends StatefulWidget {
  final int enemyID;
  const BattleScene({
    super.key,
    required this.enemyID,
  });

  @override
  State<BattleScene> createState() => _BattleSceneState();
}

class _BattleSceneState extends State<BattleScene> {
  int timeoutHandle = 0;
  bool isFighting = false;
  bool isLoading = true;
  String oldEnemyStats = "{}";
  List actualEnemies = [];
  int selectedEnemy = 0;
  bool enemyNotification = false;
  bool playerNotification = false;
  late final Timer timer;
  late final Future future;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    final options = Provider.of<Options>(context, listen: false);
    //Initialize connection
    options.websocketInitBattle(context);
    future = firstLoad(context);
    timer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
      try {
        update(context);
      } catch (_) {}
    });
  }

  //First load
  Future firstLoad(context) async {
    final options = Provider.of<Options>(context, listen: false);
    final gameplay = Provider.of<Gameplay>(context, listen: false);
    final result = jsonDecode(await options.websocketSendBattle({
      "message": "startBattle",
      "id": options.id,
      "location": gameplay.location,
      "enemyID": widget.enemyID,
      "token": options.token,
    }, context));
    final enemies = [];
    result['enemies'].forEach((key, value) => enemies.add(value));
    for (int i = 0; i < enemies.length; i++) {
      final id = enemies[0]['id'];
      //Add Enemy Stats
      gameplay.changeStats(value: enemies[i]['id'], stats: 'eid', enemyNumber: id);
      gameplay.changeStats(value: enemies[i]['name'], stats: 'ename', enemyNumber: id);
      gameplay.changeStats(value: enemies[i]['life'], stats: 'elife', enemyNumber: id);
      gameplay.changeStats(value: enemies[i]['mana'], stats: 'emana', enemyNumber: id);
      gameplay.changeStats(value: enemies[i]['damage'], stats: 'edamage', enemyNumber: id);
      gameplay.changeStats(value: enemies[i]['armor'], stats: 'earmor', enemyNumber: id);
      gameplay.changeStats(value: enemies[i]['level'], stats: 'elevel', enemyNumber: id);
      gameplay.changeStats(value: enemies[i]['xp'], stats: 'exp', enemyNumber: id);
      gameplay.changeStats(value: enemies[i]['buffs'], stats: 'ebuffs', enemyNumber: id);
      gameplay.changeStats(value: enemies[i]['skills'], stats: 'eskills', enemyNumber: id);
    }
    actualEnemies = enemies;
    isLoading = false;
  }

  //Update every message received
  Future update(context, [message = "updateBattle"]) async {
    final options = Provider.of<Options>(context, listen: false);
    final gameplay = Provider.of<Gameplay>(context, listen: false);
    await Future.delayed(const Duration(seconds: 1));
    late final String result;
    //Stop sending updates if are attacking
    if (isFighting == false || message != "updateBattle") {
      result = await options.websocketSendBattle({"message": message}, context);
    } else {
      result = oldEnemyStats;
    }

    //Check if updated
    if (oldEnemyStats == result || options.disconnectBattle) {
      return;
    }

    //Check if lost connection
    if (result == "timeout") {
      timeoutHandle += 1;
      if (timeoutHandle >= 50 && timeoutHandle < 100) {
        timer.cancel();
        timeoutHandle = 200;
        gameplay.changeAlreadyInBattle(false);
        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => const MainMenu()), (route) => false);
        options.disconnectWebsockets(context);
        GlobalFunctions.errorDialog(
          errorMsgTitle: 'authentication_lost_connection',
          errorMsgContext: 'You have lost connection to the servers.',
          context: context,
        );
        gameplay.resetBattleLog();
      }
      return;
    }
    timeoutHandle = 0;

    //Update old stats for next update
    oldEnemyStats = result;
    final stats = jsonDecode(result);

    //Update Enemies
    if (stats['enemies'] != null) {
      //Add new enemy stats
      final enemies = [];
      stats['enemies'].forEach((key, value) => enemies.add(value));
      for (int i = 0; i < enemies.length; i++) {
        final id = enemies[i]['id'];
        //Add Enemy Stats
        gameplay.changeStats(value: enemies[i]['name'], stats: 'ename', enemyNumber: id);
        gameplay.changeStats(value: enemies[i]['life'], stats: 'elife', enemyNumber: id);
        gameplay.changeStats(value: enemies[i]['mana'], stats: 'emana', enemyNumber: id);
        gameplay.changeStats(value: enemies[i]['damage'], stats: 'edamage', enemyNumber: id);
        gameplay.changeStats(value: enemies[i]['armor'], stats: 'earmor', enemyNumber: id);
        gameplay.changeStats(value: enemies[i]['level'], stats: 'elevel', enemyNumber: id);
        gameplay.changeStats(value: enemies[i]['xp'], stats: 'exp', enemyNumber: id);
        gameplay.changeStats(value: enemies[i]['buffs'], stats: 'ebuffs', enemyNumber: id);
        gameplay.changeStats(value: enemies[i]['skills'], stats: 'eskills', enemyNumber: id);
      }
      actualEnemies = enemies;
      if (actualEnemies.length > 1) {
        enemyNotification = true;
      }
    }

    //Update Player
    if (stats['updatePlayer'] == true) {
      await MySQL.returnPlayerStats(context);
      //Battle Log
      if (true) {
        for (int i = 0; i < stats['battleLog'].length; i++) {
          gameplay.addBattleLog(stats['battleLog'][i], context);
          //Animation
          Future.delayed(const Duration(milliseconds: 100)).then((value) => _scrollController.animateTo(_scrollController.position.maxScrollExtent,
              duration: const Duration(milliseconds: 300), curve: Curves.easeOut));
          await Future.delayed(Duration(milliseconds: options.textSpeed));
        }
      }
      //Player Dead
      if (stats['gameover'] == true) {
        timer.cancel();
        gameplay.changeStats(value: 0.0, stats: 'life');
        await Future.delayed(const Duration(seconds: 1));
        Navigator.pop(context);
        Navigator.pop(context);
        Navigator.pushNamed(context, '/mainmenu');
        gameplay.changeAlreadyInBattle(false);
        gameplay.resetBattleLog();
      }
      //Enemy Dead
      if (stats['win'] == true) {
        timer.cancel();
        options.websocketDisconnectBattle(context);
        GlobalFunctions.lootDialog(context: context, loots: stats['loots'], xp: stats['earnedXP'], levelUpDialog: stats['levelUpDialog']);
        gameplay.changeAlreadyInBattle(false);
        gameplay.resetBattleLog();
      }
      //Update button
      setState(() {
        isFighting = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final options = Provider.of<Options>(context, listen: false);
    final gameplay = Provider.of<Gameplay>(context);
    final screenSize = MediaQuery.of(context).size;

    return WillPopScope(
      onWillPop: () async => false,
      child: FutureBuilder(
          future: future,
          builder: (context, future) {
            //Battle
            if (!isLoading) {
              return Scaffold(
                //Party View
                drawer: Theme(
                    data: Theme.of(context).copyWith(
                      canvasColor: Colors.transparent,
                    ),
                    child: Drawer(
                      width: screenSize.width * 0.5,
                      child: Column(
                        children: const [],
                      ),
                    )),
                //Enemies View
                endDrawer: Theme(
                  data: Theme.of(context).copyWith(
                    canvasColor: Colors.transparent,
                  ),
                  child: Drawer(
                    width: screenSize.width * 0.5,
                    child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: actualEnemies.length,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                selectedEnemy = index;
                              });
                            },
                            child: Column(
                              children: [
                                //Enemy Image
                                Padding(
                                  padding: const EdgeInsets.only(top: 20.0, left: 20, right: 20),
                                  child: Container(
                                    width: screenSize.width * 0.5 - 40,
                                    height: screenSize.height * 0.1,
                                    decoration: BoxDecoration(
                                      border: selectedEnemy == index ? Border.all(color: Theme.of(context).primaryColor) : Border.all(),
                                      borderRadius: BorderRadius.circular(20),
                                      color: Theme.of(context).colorScheme.primary,
                                      image: DecorationImage(
                                          image: ExactAssetImage("assets/images/enemys/infight/${actualEnemies[selectedEnemy]['name']}.png"),
                                          fit: BoxFit.cover),
                                    ),
                                  ),
                                ),
                                //Enemy Name
                                Padding(
                                  padding: const EdgeInsets.only(top: 5, bottom: 20.0, left: 20, right: 20),
                                  child: Container(
                                    width: screenSize.width * 0.5 - 40,
                                    height: screenSize.height * 0.05,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: Theme.of(context).colorScheme.primary,
                                    ),
                                    child: FittedBox(
                                      child: Padding(
                                        padding: const EdgeInsets.all(50.0),
                                        child: Text(
                                          Language.Translate('enemy_${actualEnemies[selectedEnemy]['name']}', options.language) ?? 'Language Error',
                                          style: TextStyle(color: Theme.of(context).primaryColor, fontSize: 100, fontFamily: "PressStart"),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        }),
                  ),
                ),
                body: Builder(builder: (BuildContext context) {
                  return SingleChildScrollView(
                    child: Column(
                      children: [
                        SizedBox(height: screenSize.height * 0.07),
                        //Top Side Screen
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                              style: const TextStyle(fontFamily: 'PressStart', fontSize: 500),
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
                                              style: const TextStyle(fontFamily: 'PressStart', fontSize: 500),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            //Stats Button
                            !isFighting
                                ? SizedBox(
                                    width: screenSize.width * 0.3,
                                    height: screenSize.height * 0.05,
                                    child: FittedBox(
                                      child: ElevatedButton(
                                        onPressed: () {
                                          GlobalFunctions.playerStats(context);
                                        },
                                        child: Text(Language.Translate('response_status', options.language) ?? 'Stats'),
                                      ),
                                    ),
                                  )
                                : SizedBox(
                                    width: screenSize.width * 0.3,
                                    height: screenSize.height * 0.05,
                                    child: FittedBox(
                                      child: ElevatedButton(
                                        onPressed: null,
                                        child: Text(Language.Translate('response_status', options.language) ?? 'Stats'),
                                      ),
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
                              child: Image.asset('assets/locations/prologue/paradise.png', fit: BoxFit.cover),
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
                                                actualEnemies[selectedEnemy]['level'].toString(),
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
                                                actualEnemies[selectedEnemy]['level'].toString(),
                                                style: const TextStyle(fontSize: 500, fontFamily: 'PressStart'),
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
                                        padding: const EdgeInsets.symmetric(horizontal: 500.0),
                                        child: Row(
                                          children: [
                                            //ELife Image
                                            Padding(
                                              padding: const EdgeInsets.symmetric(horizontal: 200.0),
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
                                                  '${Language.Translate('battle_life', options.language) ?? 'Life'}: ${actualEnemies[selectedEnemy]['life']}',
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
                                                  '${Language.Translate('battle_life', options.language) ?? 'Life'}: ${actualEnemies[selectedEnemy]['life']}',
                                                  style: const TextStyle(
                                                    fontSize: 500,
                                                    letterSpacing: 5,
                                                    fontFamily: 'PressStart',
                                                  ),
                                                ),
                                              ],
                                            ),
                                            //Spacer
                                            const SizedBox(width: 1200),
                                            //EMana Image
                                            Padding(
                                              padding: const EdgeInsets.symmetric(horizontal: 200.0),
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
                                                  '${Language.Translate('battle_mana', options.language) ?? 'Mana'}: ${actualEnemies[selectedEnemy]['mana']}',
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
                                                  '${Language.Translate('battle_mana', options.language) ?? 'Mana'}: ${actualEnemies[selectedEnemy]['mana']}',
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
                              SizedBox(
                                width: screenSize.width,
                                height: screenSize.height * 0.1,
                                //Party, Enemy Name, Enemies, Buttons
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    //Party Button
                                    Padding(
                                      padding: const EdgeInsets.all(10.0),
                                      child: GestureDetector(
                                        onTap: () {
                                          Scaffold.of(context).openDrawer();
                                        },
                                        child: Container(
                                          width: screenSize.width * 0.2 - 20,
                                          height: screenSize.height * 0.2,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(20),
                                            color: Theme.of(context).colorScheme.primary,
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Image.asset("assets/images/interface/party_button.png"),
                                          ),
                                        ),
                                      ),
                                    ),
                                    //Enemy Name
                                    Padding(
                                      padding: const EdgeInsets.all(16.0),
                                      child: SizedBox(
                                        width: screenSize.width * 0.6 - 32,
                                        child: FittedBox(
                                          child: Text(
                                            Language.Translate('enemy_${actualEnemies[selectedEnemy]['name']}', options.language) ?? 'Language Error',
                                            style: TextStyle(color: Theme.of(context).primaryColor, fontSize: 100, fontFamily: "PressStart"),
                                          ),
                                        ),
                                      ),
                                    ),
                                    //Enemies Button
                                    Padding(
                                      padding: const EdgeInsets.all(10.0),
                                      child: GestureDetector(
                                        onTap: () {
                                          Scaffold.of(context).openEndDrawer();
                                          setState(() {
                                            enemyNotification = false;
                                          });
                                        },
                                        child: Stack(
                                          alignment: Alignment.topRight,
                                          children: [
                                            Container(
                                              width: screenSize.width * 0.2 - 20,
                                              height: screenSize.height * 0.2,
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(20),
                                                color: Theme.of(context).colorScheme.primary,
                                              ),
                                              child: Padding(
                                                padding: const EdgeInsets.all(8.0),
                                                child: Image.asset("assets/images/interface/enemy_button.png"),
                                              ),
                                            ),
                                            enemyNotification
                                                ? Container(
                                                    width: screenSize.width * 0.04,
                                                    height: screenSize.height * 0.02,
                                                    decoration: BoxDecoration(
                                                      color: Colors.yellow,
                                                      borderRadius: BorderRadius.circular(100),
                                                    ),
                                                  )
                                                : const SizedBox(),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              //Attack & View
                              Container(
                                padding: const EdgeInsets.all(5),
                                width: screenSize.width,
                                height: screenSize.height * 0.1,
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
                                                update(context, {
                                                  'requisition': 'attack',
                                                  'playerSkill': gameplay.playerSelectedSkill,
                                                  'selectedEnemy': actualEnemies[selectedEnemy]['id'],
                                                });
                                              },
                                              child: Text(Language.Translate('magics_${gameplay.playerSelectedSkill}', options.language) ?? 'Attack'),
                                            )
                                          : ElevatedButton(
                                              onPressed: null,
                                              child: Text(Language.Translate('magics_${gameplay.playerSelectedSkill}', options.language) ?? 'Attack'),
                                            ),
                                      const SizedBox(width: 20),
                                      //Stats Button
                                      !isFighting
                                          ? ElevatedButton(
                                              onPressed: () {
                                                GlobalFunctions.playerStats(context);
                                              },
                                              child: Text(Language.Translate('response_view', options.language) ?? 'View'),
                                            )
                                          : ElevatedButton(
                                              onPressed: null,
                                              child: Text(Language.Translate('response_view', options.language) ?? 'View'),
                                            ),
                                    ],
                                  ),
                                ),
                              ),
                              //Inventory & Magics & Log
                              SizedBox(
                                width: screenSize.width,
                                height: screenSize.height * 0.1,
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
                                        decoration:
                                            BoxDecoration(borderRadius: BorderRadius.circular(20), color: Theme.of(context).colorScheme.secondary),
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
                                                    style: const TextStyle(color: Colors.white, fontSize: 18),
                                                  );
                                                }),
                                          ),
                                        ),
                                      ),
                                      //Magics
                                      TextButton(
                                        onPressed: () {
                                          Navigator.pushNamed(context, '/magics').then((value) => setState(() {}));
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
                  );
                }),
              );
            }
            //Loading
            else {
              return Scaffold(
                body: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      //Spacer
                      SizedBox(height: screenSize.height * 0.35),
                      //Progress
                      SizedBox(
                        height: screenSize.height * 0.1,
                        width: screenSize.width * 0.2,
                        child: const CircularProgressIndicator(),
                      ),
                      //Loading Text
                      SizedBox(
                        width: screenSize.width * 0.5,
                        height: screenSize.height * 0.2,
                        child: FittedBox(
                          child: Text(
                            Language.Translate("battle_entering", options.language) ?? "Starting Battle",
                            style: const TextStyle(fontFamily: "PressStart", fontSize: 100),
                          ),
                        ),
                      ),
                      //Spacer
                      SizedBox(height: screenSize.height * 0.35),
                    ],
                  ),
                ),
              );
            }
          }),
    );
  }
}

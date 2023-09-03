// ignore_for_file: use_build_context_synchronously

import 'dart:async';
import 'dart:convert';

import 'package:flublade_project/components/character_creation.dart';
import 'package:flublade_project/components/gameplay/game_engine.dart';
import 'package:flublade_project/components/loot_widget.dart';
import 'package:flublade_project/components/magic_widget.dart';
import 'package:flublade_project/components/engine.dart';
import 'package:flublade_project/data/language.dart';
import 'package:flublade_project/data/mysql.dart';
import 'package:flublade_project/data/options.dart';
import 'package:flublade_project/data/settings.dart';
import 'package:flublade_project/pages/authenticationpage.dart';
import 'package:flublade_project/pages/gameplay/ingame.dart';
import 'package:flublade_project/pages/gameplay/inventory.dart';
import 'package:flublade_project/pages/mainmenu/character_selection.dart';
import 'package:flublade_project/pages/mainmenu/characters_menu.dart';
import 'package:flublade_project/pages/mainmenu/main_menu.dart';
import 'package:flublade_project/pages/mainmenu/options_menu.dart';
import 'package:flublade_project/data/gameplay.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../pages/gameplay/magics.dart';

class SaveDatas {
  static late SharedPreferences _preferences;

  //Storage Login
  static const _keyUsername = 'username';
  static const _keyToken = 'token';
  static const _keyId = 0;
  static const _keyRemember = false;
  static const _keyServer = '0.0.0.0';
  static const _keyServerName = 'FLUBLADE';
  //Storage Options
  static const _keyCharacters = '{}';
  static const _keyLanguage = 'en_US';
  static const _keyTextSpeed = 700;

  //Load Datas
  static Future init() async => _preferences = await SharedPreferences.getInstance();

  //Set Datas Login
  static Future setUsername(String username) async => await _preferences.setString(_keyUsername, username);
  static Future setToken(String token) async => await _preferences.setString(_keyToken, token);
  static Future setId(int id) async => await _preferences.setInt(_keyId.toString(), id);
  static Future setRemember(bool remember) async => await _preferences.setBool(_keyRemember.toString(), remember);
  static Future setServerAddress(String serverAddress) async => await _preferences.setString(_keyServer, serverAddress);
  static Future setServerName(String serverName) async => await _preferences.setString(_keyServerName, serverName);

  //Set Datas Options
  static Future setLanguage(String language) async => await _preferences.setString(_keyLanguage, language);
  static Future setCharacters(String characters) async => await _preferences.setString(_keyCharacters, characters);
  static Future setTextSpeed(int textSpeed) async => await _preferences.setInt(_keyTextSpeed.toString(), textSpeed);

  //Get Datas Login
  static String? getUsername() => _preferences.getString(_keyUsername);
  static String? getToken() => _preferences.getString(_keyToken);
  static int? getId() => _preferences.getInt(_keyId.toString());
  static bool? getRemember() => _preferences.getBool(_keyRemember.toString());
  static String? getServerAddress() => _preferences.getString(_keyServer);
  static String? getServerName() => _preferences.getString(_keyServerName);

  //Get Datas Options
  static String? getLanguage() => _preferences.getString(_keyLanguage);
  static String? getCharacters() => _preferences.getString(_keyCharacters);
  static int? getTextSpeed() => _preferences.getInt(_keyTextSpeed.toString());
}

class GlobalFunctions {
  // Routes
  static final routes = {
    '/authenticationpage': (context) => const AuthenticationPage(),
    '/mainmenu': (context) => const MainMenu(),
    '/optionsmenu': (context) => const OptionsMenu(),
    '/charactersmenu': (context) => const CharactersMenu(),
    '/charactercreation': (context) => const CharacterCreation(),
    '/characterselection': (context) => const CharacterSelection(),
    '/ingame': (context) => const InGame(),
    '/inventory': (context) => const GameplayInventory(),
    '/magics': (context) => const Magics(),
  };

  //Disconnect Dialog
  static void disconnectDialog({
    required String errorMsgTitle,
    required String errorMsgContext,
    required BuildContext context,
  }) {
    final options = Provider.of<Options>(context, listen: false);
    showDialog(
        barrierColor: const Color.fromARGB(167, 0, 0, 0),
        context: context,
        builder: (context) {
          return AlertDialog(
            shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(32.0))),
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            title: Text(
              Language.Translate(errorMsgTitle, options.language) ?? 'Are you sure?',
              style: TextStyle(color: Theme.of(context).primaryColor),
            ),
            content: Text(
              Language.Translate(errorMsgContext, options.language) ?? 'MsgContext',
              style: TextStyle(color: Theme.of(context).primaryColor),
            ),
            actions: [
              //Yes
              ElevatedButton(
                onPressed: () {
                  options.changeUsername('');
                  options.changeToken('');
                  options.changeRemember(value: false);
                  options.changeId(0);
                  SaveDatas.setRemember(false);
                  Provider.of<Gameplay>(context, listen: false).changeCharacters({});
                  Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => const AuthenticationPage()), (route) => false);
                },
                child: Text(
                  Language.Translate('response_yes', options.language) ?? 'Yes',
                ),
              ),
              //No
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text(
                  Language.Translate('response_no', options.language) ?? 'No',
                ),
              ),
            ],
          );
        });
  }

  //Loot Dialog
  static void lootDialog({required BuildContext context, required List loots, required xp, required levelUpDialog}) {
    final options = Provider.of<Options>(context, listen: false);
    final gameplay = Provider.of<Gameplay>(context, listen: false);
    final settings = Provider.of<Settings>(context, listen: false);
    gameplay.resetPlayerInventorySelected();
    showDialog(
        barrierColor: const Color.fromARGB(167, 0, 0, 0),
        context: context,
        builder: (context) {
          return FittedBox(
            child: WillPopScope(
              onWillPop: () async => false,
              child: AlertDialog(
                shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(32.0))),
                backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                title: Text(
                  Language.Translate('battle_loot', options.language) ?? 'Language Error',
                  style: TextStyle(color: Theme.of(context).primaryColor),
                ),
                //Loot Items
                content: SizedBox(
                  width: 100,
                  height: 100,
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: GridView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3,
                            ),
                            shrinkWrap: true,
                            itemCount: loots.length,
                            itemBuilder: (context, index) {
                              return LootWidget(
                                loots: loots,
                                index: index,
                              );
                            },
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 15.0),
                          child: Text(
                            '${Language.Translate('battle_loot_experience', options.language) ?? 'Language Error'} $xp',
                            style: TextStyle(color: Theme.of(context).primaryColor),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                actions: [
                  //Take All
                  ElevatedButton(
                    onPressed: () async {
                      GlobalFunctions.loadingWidget(context: context, language: options.language);
                      //Add items
                      gameplay.addInventoryItem(loots);
                      //Update All Stats
                      await MySQL.updateCharacters(context: context, characters: jsonEncode(gameplay.characters));
                      Navigator.pop(context);
                      Navigator.pop(context);
                      Navigator.pop(context);
                      //Level up dialog
                      if (levelUpDialog == false) {
                      } else {
                        //Level up Dialog
                        showDialog(
                            barrierColor: const Color.fromARGB(167, 0, 0, 0),
                            context: context,
                            builder: (context) {
                              return WillPopScope(
                                onWillPop: () async => false,
                                child: FittedBox(
                                  child: AlertDialog(
                                    shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(32.0))),
                                    backgroundColor: Colors.transparent,
                                    content: Stack(
                                      children: [
                                        //Conffeti Level Up
                                        Container(
                                          decoration: BoxDecoration(
                                              color: Theme.of(context).scaffoldBackgroundColor, borderRadius: BorderRadius.circular(30)),
                                          width: 280,
                                          height: 220,
                                          child: ClipRRect(
                                            borderRadius: BorderRadius.circular(30),
                                            child: Image.asset(
                                              'assets/images/interface/levelUp.gif',
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                        //Level Up Interface
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            //Level Up Text
                                            Padding(
                                              padding: const EdgeInsets.all(20.0),
                                              child: Text(
                                                Language.Translate('response_levelup', options.language) ?? 'Level UP',
                                                style: TextStyle(fontFamily: 'PressStart', fontSize: 15, color: Theme.of(context).primaryColor),
                                              ),
                                            ),
                                            //Level Number
                                            Padding(
                                              padding: const EdgeInsets.all(30.0),
                                              child: Center(
                                                child: Text(
                                                  gameplay.playerLevel.toString(),
                                                  style: TextStyle(fontSize: 40, fontFamily: 'PressStart', color: Theme.of(context).primaryColor),
                                                ),
                                              ),
                                            ),
                                            //Ok button
                                            Padding(
                                              padding: const EdgeInsets.all(20.0),
                                              child: ElevatedButton(
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                },
                                                child: Center(
                                                  child: Text(Language.Translate('response_ok', options.language) ?? 'Ok'),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            });
                      }
                    },
                    //Text
                    child: Text(
                      Language.Translate('battle_loot_all', options.language) ?? 'Take All',
                    ),
                  ),
                  //Exit
                  ElevatedButton(
                    onPressed: () async {
                      bool levelUpDialog = false;
                      //Add items
                      if (gameplay.playerInventorySelected.isNotEmpty) {
                        //Loading
                        GlobalFunctions.loadingWidget(context: context, language: options.language);
                        //Add Items
                        gameplay.addInventoryItem(gameplay.playerInventorySelected);
                        //Update All Stats
                        await MySQL.updateCharacters(context: context, characters: jsonEncode(gameplay.characters));
                        Navigator.pop(context);
                      }
                      Navigator.pop(context);
                      Navigator.pop(context);
                      //Level up dialog
                      if (levelUpDialog == false) {
                      } else {
                        final characters = Provider.of<Gameplay>(context, listen: false).characters;
                        final characterClass = characters['character${gameplay.selectedCharacter}']['class'];
                        //Level up Dialog
                        showDialog(
                            barrierColor: const Color.fromARGB(167, 0, 0, 0),
                            context: context,
                            builder: (context) {
                              return WillPopScope(
                                onWillPop: () async => false,
                                child: FittedBox(
                                  child: AlertDialog(
                                      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(32.0))),
                                      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                                      title: Text(
                                        Language.Translate('response_levelup', options.language) ?? 'Level UP',
                                        style: TextStyle(color: Theme.of(context).primaryColor),
                                      ),
                                      content: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          //Armor Text
                                          Text(
                                            '${Language.Translate('levelup_armor', options.language) ?? 'Armor earned:'} ${settings.baseAtributes[characterClass]!['armorLevel']}',
                                            style: TextStyle(color: Theme.of(context).primaryColor),
                                          ),
                                          const SizedBox(height: 4),
                                          //Strength Text
                                          Text(
                                            '${Language.Translate('levelup_strength', options.language) ?? 'Strength earned:'} ${settings.baseAtributes[characterClass]!['strengthLevel']}',
                                            style: TextStyle(color: Theme.of(context).primaryColor),
                                          ),
                                          const SizedBox(height: 4),
                                          //Agility Text
                                          Text(
                                            '${Language.Translate('levelup_agility', options.language) ?? 'Agility earned:'} ${settings.baseAtributes[characterClass]!['agilityLevel']}',
                                            style: TextStyle(color: Theme.of(context).primaryColor),
                                          ),
                                          const SizedBox(height: 4),
                                          //Intelligence Text
                                          Text(
                                            '${Language.Translate('levelup_intelligence', options.language) ?? 'Intelligence earned:'} ${settings.baseAtributes[characterClass]!['intelligenceLevel']}',
                                            style: TextStyle(color: Theme.of(context).primaryColor),
                                          ),
                                          //Skillpoints Text
                                          const SizedBox(height: 4),
                                          Text(
                                            '${Language.Translate('levelup_skillpoints', options.language) ?? 'Skill Points earned:'} 5',
                                            style: TextStyle(color: Theme.of(context).primaryColor),
                                          ),
                                          const SizedBox(height: 20),
                                          ElevatedButton(
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                            child: Center(
                                              child: Text(Language.Translate('response_ok', options.language) ?? 'Ok'),
                                            ),
                                          ),
                                        ],
                                      )),
                                ),
                              );
                            });
                      }
                    },
                    //Text
                    child: Text(
                      Language.Translate('battle_loot_exit', options.language) ?? 'Take All',
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }

  //Error Dialog
  static errorDialog({
    required String errorMsgTitle,
    required String errorMsgContext,
    required BuildContext context,
    String? popUntil,
  }) {
    final options = Provider.of<Options>(context, listen: false);
    showDialog(
        barrierColor: const Color.fromARGB(167, 0, 0, 0),
        context: context,
        builder: (context) {
          return WillPopScope(
            onWillPop: () async => false,
            child: AlertDialog(
              shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(32.0))),
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              //Sad face
              title: Text(
                ':(',
                style: TextStyle(color: Theme.of(context).primaryColor),
              ),
              //Error information
              content: Text(
                Language.Translate(errorMsgTitle, options.language) ?? errorMsgContext,
                style: TextStyle(color: Theme.of(context).primaryColor),
              ),
              //Ok Button
              actions: [
                Center(
                    child: ElevatedButton(
                  onPressed: () {
                    if (popUntil != null) {
                      Navigator.of(context).pushNamedAndRemoveUntil(popUntil, (Route<dynamic> route) => false);
                    } else {
                      Navigator.pop(context);
                    }
                  },
                  child: const Text('Ok'),
                ))
              ],
            ),
          );
        });
  }

  //Pause Dialog
  static pauseDialog({
    required BuildContext context,
  }) {
    final websocket = Provider.of<Websocket>(context, listen: false);
    final options = Provider.of<Options>(context, listen: false);
    final gameplay = Provider.of<Gameplay>(context, listen: false);
    final engine = Provider.of<GameEngine>(context, listen: false);
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
                  Language.Translate('pausemenu_pause', options.language) ?? 'Pause',
                  style: TextStyle(color: Theme.of(context).primaryColor),
                ),
                content: Column(
                  children: [
                    //Continue
                    Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text(Language.Translate('pausemenu_continue', options.language) ?? 'Continue'),
                      ),
                    ),
                    //Options
                    Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pushNamed(context, '/optionsmenu');
                        },
                        child: Text(Language.Translate('pausemenu_options', options.language) ?? 'Options'),
                      ),
                    ),
                    //Disconnect
                    Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: ElevatedButton(
                        onPressed: () {
                          websocket.websocketDisconnectIngame(context);
                          gameplay.changeIsTalkable(false);
                          gameplay.cleanEnemiesChasing();
                          engine.changeStopIngameConnection(true);
                          Navigator.of(context).pushNamedAndRemoveUntil('/mainmenu', (Route route) => false);
                        },
                        child: Text(Language.Translate('pausemenu_disconnectIngame', options.language) ?? 'Disconnect'),
                      ),
                    ),
                  ],
                )),
          );
        });
  }

  //Show Player Stats Dialogs
  static playerStats(context) async {
    final settings = Provider.of<Settings>(context, listen: false);
    final options = Provider.of<Options>(context, listen: false);
    final gameplay = Provider.of<Gameplay>(context, listen: false);
    final mysql = Provider.of<MySQL>(context, listen: false);
    dynamic result = await http.post(
      Uri.http(mysql.serverAddress, '/playerStats'),
      headers: MySQL.headers,
      body: jsonEncode({"id": options.id, "token": options.token, "selectedCharacter": gameplay.selectedCharacter}),
    );
    result = jsonDecode(result.body);
    final playerDamage = result['playerDamage'];
    final playerMaxLife = result['playerMaxLife'];
    final playerMaxMana = result['playerMaxMana'];
    showDialog(
        barrierColor: const Color.fromARGB(167, 0, 0, 0),
        context: context,
        builder: (context) {
          return FittedBox(
            child: AlertDialog(
              shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(32.0))),
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              title: Text(
                Language.Translate('response_stats', options.language) ?? 'Stats',
                style: TextStyle(color: Theme.of(context).primaryColor, fontSize: 40),
              ),
              content: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //Life
                  Text(
                    '${Language.Translate('battle_life', options.language) ?? 'Life'}: ${Provider.of<Gameplay>(context, listen: false).playerLife.toStringAsFixed(2)} / $playerMaxLife',
                    style: TextStyle(color: Theme.of(context).primaryColor, fontSize: 30),
                  ),
                  //Mana
                  Text(
                    '${Language.Translate('battle_mana', options.language) ?? 'Mana'}: ${Provider.of<Gameplay>(context, listen: false).playerMana} / $playerMaxMana',
                    style: TextStyle(color: Theme.of(context).primaryColor, fontSize: 30),
                  ),
                  //Strength
                  Text(
                    '${Language.Translate('response_strength', options.language) ?? 'Strength'}: ${Provider.of<Gameplay>(context, listen: false).playerStrength}',
                    style: TextStyle(color: Theme.of(context).primaryColor, fontSize: 30),
                  ),
                  //Agility
                  Text(
                    '${Language.Translate('response_agility', options.language) ?? 'Agility'}: ${Provider.of<Gameplay>(context, listen: false).playerAgility}',
                    style: TextStyle(color: Theme.of(context).primaryColor, fontSize: 30),
                  ),
                  //Intelligence
                  Text(
                    '${Language.Translate('response_intelligence', options.language) ?? 'Intelligence'}: ${Provider.of<Gameplay>(context, listen: false).playerIntelligence}',
                    style: TextStyle(color: Theme.of(context).primaryColor, fontSize: 30),
                  ),
                  //Armor
                  Text(
                    '${Language.Translate('response_armor', options.language) ?? 'Armor'}: ${Provider.of<Gameplay>(context, listen: false).playerArmor}',
                    style: TextStyle(color: Theme.of(context).primaryColor, fontSize: 30),
                  ),
                  //Damage
                  Text(
                    '${Language.Translate('response_damage', options.language) ?? 'Damage'}: $playerDamage',
                    style: TextStyle(color: Theme.of(context).primaryColor, fontSize: 30),
                  ),
                  //Level
                  Text(
                    '${Language.Translate('characters_create_level', options.language) ?? 'Level'}: ${Provider.of<Gameplay>(context, listen: false).playerLevel}',
                    style: TextStyle(color: Theme.of(context).primaryColor, fontSize: 30),
                  ),
                  //Experience
                  Text(
                    '${Language.Translate('battle_loot_experience', options.language) ?? 'Experience'} ${Provider.of<Gameplay>(context, listen: false).playerXP.toStringAsFixed(2)} / ${settings.levelCaps[Provider.of<Gameplay>(context, listen: false).playerLevel.toString()]!.toStringAsFixed(2)}',
                    style: TextStyle(color: Theme.of(context).primaryColor, fontSize: 30),
                  ),
                  //Debuffs
                  gameplay.playerDebuffs.isEmpty
                      ? Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Center(
                            child: ElevatedButton(
                              onPressed: null,
                              child: Text(
                                Language.Translate('response_debuffs', options.language) ?? 'Debuffs',
                                style: TextStyle(color: Theme.of(context).primaryColor, fontSize: 30),
                              ),
                            ),
                          ),
                        )
                      : Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Center(
                            child: ElevatedButton(
                              onPressed: () {
                                final screenSize = MediaQuery.of(context).size;
                                showModalBottomSheet<void>(
                                    backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                                    shape: const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.vertical(
                                        top: Radius.circular(50.0),
                                      ),
                                    ),
                                    isScrollControlled: true,
                                    context: context,
                                    builder: (context) {
                                      return SizedBox(
                                        height: screenSize.height * 0.65,
                                        child: Padding(
                                          padding: const EdgeInsets.all(15.0),
                                          child: SingleChildScrollView(
                                            child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                //Debuffs Text
                                                SizedBox(
                                                  width: double.infinity,
                                                  height: screenSize.height * 0.1,
                                                  child: FittedBox(
                                                    child: Text(
                                                      Language.Translate('response_debuffs', options.language) ?? 'Debuffs',
                                                      style: TextStyle(color: Theme.of(context).primaryColor),
                                                    ),
                                                  ),
                                                ),
                                                //Grid Passives
                                                GridView.builder(
                                                  physics: const NeverScrollableScrollPhysics(),
                                                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
                                                  shrinkWrap: true,
                                                  itemCount: gameplay.playerDebuffs.length,
                                                  itemBuilder: (context, index) {
                                                    return TextButton(
                                                        onPressed: () {
                                                          showDialog(
                                                              context: context,
                                                              builder: (context) => FittedBox(
                                                                    child: AlertDialog(
                                                                      shape: const RoundedRectangleBorder(
                                                                          borderRadius: BorderRadius.all(Radius.circular(32.0))),
                                                                      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                                                                      title: Text(
                                                                        Language.Translate('magics_${gameplay.playerDebuffs[index]['name']}',
                                                                                options.language) ??
                                                                            'Language Error',
                                                                        style: TextStyle(color: Theme.of(context).primaryColor),
                                                                      ),
                                                                      content: SizedBox(
                                                                        width: 300,
                                                                        height: 200,
                                                                        child: Column(
                                                                          children: [
                                                                            //Description
                                                                            SizedBox(
                                                                              height: 150,
                                                                              child: SingleChildScrollView(
                                                                                child: Column(
                                                                                  children: [
                                                                                    Text(
                                                                                      Language.Translate(
                                                                                              'magics_${gameplay.playerDebuffs[index]['name']}_desc',
                                                                                              options.language) ??
                                                                                          'Language Error',
                                                                                      style: TextStyle(
                                                                                          color: Theme.of(context).primaryColor, fontSize: 20),
                                                                                    ),
                                                                                  ],
                                                                                ),
                                                                              ),
                                                                            ),
                                                                            const Spacer(),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ));
                                                        },
                                                        child: MagicWidget(
                                                          name: gameplay.playerDebuffs[index]['name'],
                                                          isDebuffs: true,
                                                          debuffIndex: index,
                                                        ));
                                                  },
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      );
                                    });
                              },
                              child: Text(
                                Language.Translate('response_debuffs', options.language) ?? 'Debuffs',
                                style: TextStyle(color: Theme.of(context).primaryColor, fontSize: 30),
                              ),
                            ),
                          ),
                        ),
                ],
              ),
            ),
          );
        });
  }

  //Loading
  static void loadingWidget({required BuildContext context, required String language}) {
    showDialog(
        barrierColor: const Color.fromARGB(167, 0, 0, 0),
        context: context,
        builder: (context) {
          return WillPopScope(
            onWillPop: () async => false,
            child: AlertDialog(
              shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(32.0))),
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              //Language Text
              title: Text(
                Language.Translate('authentication_register_loading', language) ?? 'Loading',
                style: TextStyle(color: Theme.of(context).primaryColor),
              ),
              content: const Padding(
                padding: EdgeInsets.all(50.0),
                child: SizedBox(width: 100, height: 100, child: CircularProgressIndicator()),
              ),
            ),
          );
        });
  }
}

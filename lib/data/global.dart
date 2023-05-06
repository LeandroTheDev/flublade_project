// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:flublade_project/components/character_creation.dart';
import 'package:flublade_project/components/loot_widget.dart';
import 'package:flublade_project/components/magic_widget.dart';
import 'package:flublade_project/data/language.dart';
import 'package:flublade_project/data/mysqldata.dart';
import 'package:flublade_project/pages/authenticationpage.dart';
import 'package:flublade_project/pages/gameplay/ingame.dart';
import 'package:flublade_project/pages/gameplay/inventory.dart';
import 'package:flublade_project/pages/mainmenu/character_selection.dart';
import 'package:flublade_project/pages/mainmenu/characters_menu.dart';
import 'package:flublade_project/pages/mainmenu/main_menu.dart';
import 'package:flublade_project/pages/mainmenu/options_menu.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:bonfire/bonfire.dart';
import 'package:http/http.dart' as http;

import '../pages/gameplay/magics.dart';

class Options with ChangeNotifier {
  String _language = 'en_US';
  int _textSpeed = 700;
  String _username = '';
  String _token = '';
  bool _remember = false;
  int _id = 0;

  String get language => _language;
  int get textSpeed => _textSpeed;
  String get username => _username;
  String get token => _token;
  bool get remember => _remember;
  int get id => _id;

  void changeLanguage(value) {
    _language = value;
  }

  void changeTextSpeed(value) {
    _textSpeed = value;
  }

  void changeUsername(value) {
    _username = value;
  }

  void changeToken(value) {
    _token = value;
  }

  void changeRemember({value}) {
    if (value == null) {
      _remember = !_remember;
      notifyListeners();
      return;
    }
    if (value) {
      _remember = value;
      notifyListeners();
    } else if (!value) {
      _remember = value;
      notifyListeners();
    }
  }

  void changeId(value) {
    _id = value;
  }
}

class Settings with ChangeNotifier {
  bool _isLoading = false;
  Map _baseAtributes = {};
  Map _levelCaps = {};
  Map _skillsId = {};
  Map _itemsId = {};

  bool get isLoading => _isLoading;
  Map get baseAtributes => _baseAtributes;
  Map get levelCaps => _levelCaps;
  Map get skillsId => _skillsId;
  Map get itemsId => _itemsId;

  void changeIsLoading({value}) {
    if (value == null) {
      _isLoading = !_isLoading;
      notifyListeners();
    } else if (value) {
      _isLoading = true;
      notifyListeners();
    } else {
      _isLoading = false;
      notifyListeners();
    }
  }

  //Change Items Id
  void changeItemsId(Map value) {
    _itemsId = value;
  }

  //Translate equip index
  List translateEquipsIndex(equipIndex) {
    return [0];
  }

  //Change Base Atributes
  void changeBaseAtributes(Map value) {
    _baseAtributes = value;
  }

  //Change Level Caps
  void changeLevelCaps(Map value) {
    _levelCaps = value;
  }

  //Change Skills Id
  void changeSkillsId(Map value) {
    _skillsId = value;
  }

  //Returns the Loot/Item Image
  String lootImage(itemName) {
    if (itemName.contains('%')) {
      itemName = itemName.substring(0, itemName.length - 3);
      return itemsId[itemName]['image'];
    }
    return itemsId[itemName]['image'];
  }

  //Returns the tier
  String itemTier(itemName, {addPlus = false}) {
    if (itemName.contains('%')) {
      final tier = int.parse(itemName.substring(itemName.length - 2));
      if (addPlus) {
        return '+${tier.toString()}';
      }
      return tier.toString();
    }
    return '';
  }

  //Returns the item name without Tier
  String tierCheck(itemName) {
    if (itemName.contains('%')) {
      itemName = itemName.substring(0, itemName.length - 3);
      return itemName;
    }
    return itemName;
  }
}

class SaveDatas {
  static late SharedPreferences _preferences;

  //Storage Login
  static const _keyUsername = 'username';
  static const _keyToken = 'token';
  static const _keyId = 0;
  static const _keyRemember = false;
  //Storage Options
  static const _keyCharacters = '{}';
  static const _keyLanguage = 'en_US';
  static const _keyTextSpeed = 700;

  //Load Datas
  static Future init() async => _preferences = await SharedPreferences.getInstance();

  //Set Datas
  static Future setUsername(String username) async => await _preferences.setString(_keyUsername, username);
  static Future setToken(String token) async => await _preferences.setString(_keyToken, token);
  static Future setId(int id) async => await _preferences.setInt(_keyId.toString(), id);
  static Future setRemember(bool remember) async => await _preferences.setBool(_keyRemember.toString(), remember);
  static Future setLanguage(String language) async => await _preferences.setString(_keyLanguage, language);
  static Future setCharacters(String characters) async => await _preferences.setString(_keyCharacters, characters);
  static Future setTextSpeed(int textSpeed) async => await _preferences.setInt(_keyTextSpeed.toString(), textSpeed);

  //Get Datas
  static String? getUsername() => _preferences.getString(_keyUsername);
  static String? getToken() => _preferences.getString(_keyToken);
  static int? getId() => _preferences.getInt(_keyId.toString());
  static bool? getRemember() => _preferences.getBool(_keyRemember.toString());
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
                  Provider.of<Gameplay>(context, listen: false).changeCharacters('{}');
                  Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => const AuthenticationPage()), (Route<dynamic> route) => false);
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
  static void lootDialog({
    required BuildContext context,
    required List loots,
    required xp,
  }) {
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
                      MySQL.loadingWidget(context: context, language: options.language);
                      //Earn Xp
                      gameplay.changeStats(value: gameplay.playerXP + xp, stats: 'xp');
                      //Add items
                      gameplay.addInventoryItem(loots);
                      //Level Update
                      bool levelUpDialog = false;
                      //XP Add
                      while (true) {
                        if (gameplay.playerXP >= settings.levelCaps[gameplay.playerLevel.toString()]!) {
                          //Removing the xp difference
                          gameplay.changeStats(value: gameplay.playerXP - settings.levelCaps[gameplay.playerLevel.toString()]!, stats: 'xp');
                          //Increasing the level
                          gameplay.changeStats(value: gameplay.playerLevel + 1, stats: 'level');
                          levelUpDialog = true;
                          //Update Level Stats
                          await MySQL.updateCharacters(context: context, characters: gameplay.characters, isLevelUp: true);
                          //Update All Stats
                          await MySQL.updateCharacters(context: context, characters: gameplay.characters);
                        } else {
                          break;
                        }
                      }
                      final result = await MySQL.pushUploadCharacters(context: context);
                      Navigator.pop(context);
                      Navigator.pop(context);
                      Navigator.pop(context);
                      //Error Treatment
                      if (true) {
                        //Connection
                        if (result == 'Connection Error') {
                          Navigator.pushNamed(context, '/authenticationpage');
                          GlobalFunctions.errorDialog(errorMsgTitle: 'authentication_register_problem_connection', errorMsgContext: 'Failed to connect to the Servers', context: context, popUntil: '/authenticationpage');
                          return;
                        }
                        //Invalid Login
                        if (result == 'Invalid Login') {
                          Navigator.pushNamed(context, '/authenticationpage');
                          GlobalFunctions.errorDialog(errorMsgTitle: 'authentication_invalidlogin', errorMsgContext: 'Invalid Session', context: context, popUntil: '/authenticationpage');
                          return;
                        }
                      }
                      //Level up dialog
                      if (levelUpDialog == false) {
                        Provider.of<Gameplay>(context, listen: false).changeEnemyMove(true);
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
                                          decoration: BoxDecoration(color: Theme.of(context).scaffoldBackgroundColor, borderRadius: BorderRadius.circular(30)),
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
                                                  Provider.of<Gameplay>(context, listen: false).changeEnemyMove(true);
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
                      if (gameplay.playerInventorySelected.isNotEmpty) {
                        //Loading
                        MySQL.loadingWidget(context: context, language: options.language);
                        //Earn Xp
                        gameplay.changeStats(value: gameplay.playerXP + xp, stats: 'xp');
                        //Add Items
                        gameplay.addInventoryItem(gameplay.playerInventorySelected);
                        //XP Add
                        while (true) {
                          if (gameplay.playerXP >= settings.levelCaps[gameplay.playerLevel.toString()]!) {
                            //Removing the xp difference
                            gameplay.changeStats(value: gameplay.playerXP - settings.levelCaps[gameplay.playerLevel.toString()]!, stats: 'xp');
                            //Increasing the level
                            gameplay.changeStats(value: gameplay.playerLevel + 1, stats: 'level');
                            levelUpDialog = true;
                          } else {
                            break;
                          }
                        }
                        //Update Database
                        final result = await MySQL.pushUploadCharacters(context: context);
                        //Error Treatment
                        if (true) {
                          //Connection
                          if (result == 'Connection Error') {
                            Navigator.pushNamed(context, '/authenticationpage');
                            GlobalFunctions.errorDialog(errorMsgTitle: 'authentication_register_problem_connection', errorMsgContext: 'Failed to connect to the Servers', context: context, popUntil: '/authenticationpage');
                            return;
                          }
                          //Invalid Login
                          if (result == 'Invalid Login') {
                            Navigator.pushNamed(context, '/authenticationpage');
                            GlobalFunctions.errorDialog(errorMsgTitle: 'authentication_invalidlogin', errorMsgContext: 'Invalid Session', context: context, popUntil: '/authenticationpage');
                            return;
                          }
                        }
                        Navigator.pop(context);
                      } else {
                        //Earn Xp
                        gameplay.changeStats(value: gameplay.playerXP + xp, stats: 'xp');
                        //XP Add
                        while (true) {
                          if (gameplay.playerXP >= settings.levelCaps[gameplay.playerLevel.toString()]!) {
                            //Removing the xp difference
                            gameplay.changeStats(value: gameplay.playerXP - settings.levelCaps[gameplay.playerLevel.toString()]!, stats: 'xp');
                            //Increasing the level
                            gameplay.changeStats(value: gameplay.playerLevel + 1, stats: 'level');
                            levelUpDialog = true;
                          } else {
                            break;
                          }
                        }
                        //Update Database
                        final result = await MySQL.pushUploadCharacters(context: context);
                        //Error Treatment
                        if (true) {
                          //Connection
                          if (result == 'Connection Error') {
                            Navigator.pushNamed(context, '/authenticationpage');
                            GlobalFunctions.errorDialog(errorMsgTitle: 'authentication_register_problem_connection', errorMsgContext: 'Failed to connect to the Servers', context: context, popUntil: '/authenticationpage');
                            return;
                          }
                          //Invalid Login
                          if (result == 'Invalid Login') {
                            Navigator.pushNamed(context, '/authenticationpage');
                            GlobalFunctions.errorDialog(errorMsgTitle: 'authentication_invalidlogin', errorMsgContext: 'Invalid Session', context: context, popUntil: '/authenticationpage');
                            return;
                          }
                        }
                      }
                      Navigator.pop(context);
                      Navigator.pop(context);
                      //Level up dialog
                      if (levelUpDialog == false) {
                        Provider.of<Gameplay>(context, listen: false).changeEnemyMove(true);
                      } else {
                        final characters = jsonDecode(Provider.of<Gameplay>(context, listen: false).characters);
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
                                          //Skillpoints TExt
                                          const SizedBox(height: 4),
                                          Text(
                                            '${Language.Translate('levelup_skillpoints', options.language) ?? 'Skill Points earned:'} 5',
                                            style: TextStyle(color: Theme.of(context).primaryColor),
                                          ),
                                          const SizedBox(height: 20),
                                          ElevatedButton(
                                            onPressed: () {
                                              Navigator.pop(context);
                                              Provider.of<Gameplay>(context, listen: false).changeEnemyMove(true);
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
  static pauseDialog({required BuildContext context, required options}) {
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
                          Navigator.of(context).pushNamedAndRemoveUntil('/mainmenu', (Route route) => false);
                        },
                        child: Text(Language.Translate('pausemenu_disconnect', options.language) ?? 'Disconnect'),
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
    dynamic result = await http.post(
      Uri.http(MySQL.url, '/playerStats'),
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
                                                                      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(32.0))),
                                                                      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                                                                      title: Text(
                                                                        Language.Translate('magics_${gameplay.playerDebuffs[index]['name']}', options.language) ?? 'Language Error',
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
                                                                                      Language.Translate('magics_${gameplay.playerDebuffs[index]['name']}_desc', options.language) ?? 'Language Error',
                                                                                      style: TextStyle(color: Theme.of(context).primaryColor, fontSize: 20),
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
}

class Gameplay with ChangeNotifier {
  static Map classes = {
    0: 'assets/characters/archer.png',
    1: 'assets/characters/assassin.png',
    2: 'assets/characters/bard.png',
    3: 'assets/characters/beastmaster.png',
    4: 'assets/characters/berserk.png',
    5: 'assets/characters/druid.png',
    6: 'assets/characters/mage.png',
    7: 'assets/characters/paladin.png',
    8: 'assets/characters/priest.png',
    9: 'assets/characters/trickmagician.png',
    10: 'assets/characters/weaponsmith.png',
    11: 'assets/characters/witch.png',
  };

  static String returnClassInfo(int index, String language) {
    Map classesInfo = {
      0: 'characters_class_archer_info',
      1: 'characters_class_assassin_info',
      2: 'characters_class_bard_info',
      3: 'characters_class_beastmaster_info',
      4: 'characters_class_berserk_info',
      5: 'characters_class_druid_info',
      6: 'characters_class_mage_info',
      7: 'characters_class_paladin_info',
      8: 'characters_class_priest_info',
      9: 'characters_class_trickmagician_info',
      10: 'characters_class_weaponsmith_info',
      11: 'characters_class_witch_info',
    };
    return Language.Translate(classesInfo[index], language) ?? 'Language Error';
  }

  //System Provider
  String _characters = '{}';
  int _selectedCharacter = 0;

  String get characters => _characters;
  int get selectedCharacter => _selectedCharacter;

  void changeCharacters(String value) {
    _characters = value;
  }

  void changeSelectedCharacter(int value) {
    _selectedCharacter = value;
  }

  //Ingame Provider
  bool _isTalkable = false;
  bool _enemysMove = true;
  String _selectedTalk = '';
  int _worldId = 0;
  List<String> _battleLog = [];
  double _playerLife = 0;
  double _playerMana = 0;
  double _playerGold = 0;
  double _playerArmor = 0;
  double _playerXP = 0;
  int _playerLevel = 1;
  double _playerStrength = 0;
  double _playerAgility = 0;
  double _playerIntelligence = 0;
  int _playerLuck = 0;
  Map _playerInventory = {};
  List _playerInventorySelected = [];
  List _playerEquips = [];
  Map _playerBuffs = {};
  List _playerDebuffs = [];
  int _playerSkillpoint = 0;
  Map _playerSkills = {};
  String _playerSelectedSkill = 'basicAttack';

  String _enemyName = '';
  double _enemyLife = 0;
  double _enemyMana = 0;
  double _enemyArmor = 0;
  int _enemyLevel = 0;
  double _enemyStrength = 0;
  double _enemyAgility = 0;
  double _enemyIntelligence = 0;
  double _enemyDamage = 0;
  double _enemyXP = 0;
  List _enemyBuffs = [];
  List _enemyDebuffs = [];
  List _enemySkills = [];

  bool get isTalkable => _isTalkable;
  bool get enemysMove => _enemysMove;
  int get worldId => _worldId;
  String get selectedTalk => _selectedTalk;
  List<String> get battleLog => _battleLog;
  double get playerLife => _playerLife;
  double get playerMana => _playerMana;
  double get playerGold => _playerGold;
  double get playerArmor => _playerArmor;
  double get playerXP => _playerXP;
  int get playerLevel => _playerLevel;
  double get playerStrength => _playerStrength;
  double get playerAgility => _playerAgility;
  double get playerIntelligence => _playerIntelligence;
  int get playerLuck => _playerLuck;
  Map get playerInventory => _playerInventory;
  List get playerInventorySelected => _playerInventorySelected;
  List get playerEquips => _playerEquips;
  Map get playerBuffs => _playerBuffs;
  int get playerSkillpoint => _playerSkillpoint;
  Map get playerSkills => _playerSkills;
  String get playerSelectedSkill => _playerSelectedSkill;
  List get playerDebuffs => _playerDebuffs;

  String get enemyName => _enemyName;
  double get enemyLife => _enemyLife;
  double get enemyMana => _enemyMana;
  double get enemyArmor => _enemyArmor;
  int get enemyLevel => _enemyLevel;
  double get enemyStrength => _enemyStrength;
  double get enemyAgility => _enemyAgility;
  double get enemyIntelligence => _enemyIntelligence;
  double get enemyDamage => _enemyDamage;
  double get enemyXP => _enemyXP;
  List get enemyBuffs => _enemyBuffs;
  List get enemySkills => _enemySkills;
  List get enemyDebuffs => _enemyDebuffs;

  //Change Selected Skill
  void changePlayerSelectedSkill(value) {
    _playerSelectedSkill = value;
  }

  //Change enemy XP
  void changeEnemyXP(value) {
    _enemyXP += value;
  }

  //Change enemy name
  void changeEnemyName(value) {
    _enemyName = value;
  }

  //Remove Specific Item in inventory
  void removeSpecificItemInventory(itemName, context) {
    final settings = Provider.of<Settings>(context, listen: false);
    //Base Function for removing item name from inventory
    removingFunction(removedItem) {
      //If already have quantity
      if (playerInventory[removedItem]['quantity'] > 1) {
        //Remove 1 quantity
        playerInventory[removedItem]['quantity'] = playerInventory[removedItem]['quantity'] - 1;
      } else {
        playerInventory.remove(removedItem);
      }
    }

    final equip = settings.translateEquipsIndex(settings.itemsId[settings.tierCheck(itemName)]['equip']);
    if (_playerEquips[equip[0]] != 'none') {
      addSpecificItemInventory(_playerEquips[equip[0]]);
      removingFunction(itemName);
    } else {
      removingFunction(itemName);
    }
  }

  //Change world id
  void changeWorldId(value) {
    _worldId = value;
  }

  //Add Specific Item in inventory
  void addSpecificItemInventory(item) {
    //Test if already have in inventory
    try {
      if (playerInventory[item['name']]['quantity'] >= 1) {
        //Add 1 quantity
        playerInventory[item['name']]['quantity'] = playerInventory[item['name']]['quantity'] + 1;
      }
      //Add to the inventory if doesnt exist
    } catch (error) {
      _playerInventory[item['name']] = item;
    }
  }

  //Change the talk text
  void changeIsTalkable(value, text) {
    _selectedTalk = text;
    _isTalkable = value;
    notifyListeners();
  }

  //Change if the enemys will move
  void changeEnemyMove(value) {
    _enemysMove = value;
  }

  //Add a line to battle log
  void addBattleLog(value, context) {
    final options = Provider.of<Options>(context, listen: false);
    String result = '';
    for (int i = 1; i <= value.length; i++) {
      if (!value['log$i'].toString().contains('_')) {
        result = '$result${value['log$i'].toString()}';
      } else {
        result = '$result${Language.Translate(value['log$i'], options.language) ?? 'Language Error'}';
      }
    }
    _battleLog.add(result);
    notifyListeners();
  }

  void resetBattleLog() {
    _battleLog = [];
    notifyListeners();
  }

  //Reset Selected Inventory
  void resetPlayerInventorySelected() {
    _playerInventorySelected = [];
  }

  //Change Player Inventory
  void changePlayerInventory(Map value) {
    _playerInventory = value;
  }

  //Change Player Stats (LIFE, MANA, GOLD) or Enemy Stats
  void changeStats({required value, required String stats}) {
    //Player Stats
    if (stats == 'life') {
      _playerLife = value;
      notifyListeners();
      return;
    } else if (stats == 'mana') {
      _playerMana = double.parse(value.toString());
      notifyListeners();
      return;
    } else if (stats == 'gold') {
      _playerGold = value;
      notifyListeners();
      return;
    } else if (stats == 'armor') {
      _playerArmor = double.parse(value.toString());
      notifyListeners();
      return;
    } else if (stats == 'level') {
      _playerLevel = value;
      notifyListeners();
      return;
    } else if (stats == 'xp') {
      _playerXP = double.parse(value.toString());
      notifyListeners();
      return;
    } else if (stats == 'strength') {
      _playerStrength = double.parse(value.toString());
      notifyListeners();
      return;
    } else if (stats == 'agility') {
      _playerAgility = double.parse(value.toString());
      notifyListeners();
      return;
    } else if (stats == 'intelligence') {
      _playerIntelligence = double.parse(value.toString());
      notifyListeners();
      return;
    } else if (stats == 'luck') {
      _playerLuck = value;
      notifyListeners();
      return;
    } else if (stats == 'inventory') {
      try {
        _playerInventory = value;
      } catch (_) {
        _playerInventory = jsonDecode(value);
      }
      notifyListeners();
      return;
    } else if (stats == 'equips') {
      try {
        _playerEquips = value;
      } catch (_) {
        _playerEquips = jsonDecode(value);
      }
      notifyListeners();
      return;
    } else if (stats == 'buffs') {
      try {
        _playerBuffs = jsonDecode(value);
      } catch (error) {
        _playerBuffs = value;
      }
      notifyListeners();
      return;
    } else if (stats == 'skillpoint') {
      _playerSkillpoint = value;
      notifyListeners();
      return;
    } else if (stats == 'skills') {
      try {
        _playerSkills = jsonDecode(value);
      } catch (error) {
        _playerSkills = value;
      }
      notifyListeners();
    } else if (stats == 'debuffs') {
      _playerDebuffs = value;
      notifyListeners();
    }
    //Enemy Stats
    if (stats == 'elife') {
      _enemyLife = double.parse(value.toStringAsFixed(2));
      notifyListeners();
      return;
    } else if (stats == 'emana') {
      _enemyMana = double.parse(value.toStringAsFixed(2));
      notifyListeners();
      return;
    } else if (stats == 'earmor') {
      _enemyArmor = double.parse(value.toString());
      notifyListeners();
      return;
    } else if (stats == 'elevel') {
      _enemyLevel = value;
      notifyListeners();
      return;
    } else if (stats == 'edamage') {
      _enemyDamage = value;
      notifyListeners();
      return;
    } else if (stats == 'exp') {
      _enemyXP = value;
      notifyListeners();
      return;
    } else if (stats == 'ebuffs') {
      _enemyBuffs = value;
      notifyListeners();
      return;
    } else if (stats == 'eskills') {
      _enemySkills = value;
      notifyListeners();
      return;
    } else if (stats == 'estrength') {
      _enemyStrength = value;
      notifyListeners();
      return;
    } else if (stats == 'eagility') {
      _enemyAgility = value;
      notifyListeners();
      return;
    } else if (stats == 'eintelligence') {
      _enemyIntelligence = value;
      notifyListeners();
      return;
    } else if (stats == 'edebuffs') {
      _enemyDebuffs = value;
      notifyListeners();
      return;
    }
  }

  //Add Selected playerInventorySelected
  void addPlayerInventorySelected(value) {
    _playerInventorySelected.add(value);
  }

  //Add Items to invetory
  Map addInventoryItem(List items) {
    bool jumpClear = false;
    for (int i = 0; i <= items.length - 1; i++) {
      try {
        //If inventory is clear
        if (_playerInventory.isEmpty && !jumpClear) {
          _playerInventory[items[i]['name']] = items[i];
          i++;
          jumpClear = true;
        }
        //Doesnt Exist in inventory
        if (_playerInventory[items[i]['name']] == null) {
          _playerInventory[items[i]['name']] = items[i];
          //Exist in inventory
        } else {
          final calculation = _playerInventory[items[i]['name']]['quantity'] + items[i]['quantity'];
          _playerInventory[items[i]['name']]['quantity'] = calculation;
        }
      } catch (_) {}
    }
    return _playerInventory;
  }

  //Change Skills
  void changePlayerSkills(value) {
    _playerSkills = value;
  }

  //Show Text Talk Dialog
  static void showTalkText(context, npcname) {
    final screenSize = MediaQuery.of(context).size;
    final options = Provider.of<Options>(context, listen: false);
    final gameplay = Provider.of<Gameplay>(context, listen: false);
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
            width: screenSize.width,
            height: screenSize.height * 0.30,
            child: FittedBox(
              child: Column(
                children: [
                  Row(
                    children: [
                      SizedBox(
                          child: Stack(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(1.5),
                            child: SizedBox(
                              width: 30,
                              height: 40,
                              child: Image.asset(
                                'assets/images/interface/profileimage.png',
                                fit: BoxFit.fill,
                              ),
                            ),
                          ),
                          Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: SizedBox(
                                width: 17.5,
                                height: 26,
                                child: Image.asset('assets/images/npc/wizard.png'),
                              )),
                        ],
                      )),
                      Stack(
                        children: [
                          SizedBox(
                            width: 70,
                            height: screenSize.height * 0.05,
                            child: Image.asset(
                              'assets/images/interface/boardtext.png',
                              fit: BoxFit.fill,
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.all(8),
                            width: 60,
                            height: screenSize.height * 0.05,
                            child: SingleChildScrollView(
                              child: Text(
                                Language.Translate(gameplay.selectedTalk, options.language) ?? 'Language Error',
                                style: TextStyle(fontSize: 5, color: Theme.of(context).primaryColor),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  )
                ],
              ),
            ),
          );
        });
  }

  //Load Tiles
  static TileModel loadTiles(prop) {
    late TileModelSprite sprite;
    //Grass
    if (prop.value == 0) {
      sprite = TileModelSprite(
        path: 'tilesets/overworld/grass.png',
      );
      return TileModel(
        collisions: [],
        x: prop.position.x,
        y: prop.position.y,
        sprite: sprite,
        height: 32,
        width: 32,
      );
    }
    //Stone_down
    if (prop.value == 1) {
      sprite = TileModelSprite(
        path: 'tilesets/overworld/stone_down.png',
      );
      return TileModel(
        collisions: [
          CollisionArea.rectangle(
            size: Vector2(32, 32),
            align: Vector2(0, 0),
          ),
        ],
        x: prop.position.x,
        y: prop.position.y,
        sprite: sprite,
        height: 32,
        width: 32,
      );
    }
    if (prop.value == 2) {
      sprite = TileModelSprite(
        path: 'tilesets/overworld/stone.png',
      );
      return TileModel(
        collisions: [
          CollisionArea.rectangle(
            size: Vector2(32, 32),
            align: Vector2(0, 0),
          ),
        ],
        x: prop.position.x,
        y: prop.position.y,
        sprite: sprite,
        height: 32,
        width: 32,
      );
    }
    //Null
    sprite = TileModelSprite(
      path: 'tilesets/overworld/grass.png',
    );
    return TileModel(
      collisions: [],
      x: prop.position.x,
      y: prop.position.y,
      sprite: sprite,
      height: 32,
      width: 32,
    );
  }
}

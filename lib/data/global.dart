import 'dart:convert';
import 'dart:math';

import 'package:flublade_project/components/character_creation.dart';
import 'package:flublade_project/components/loot_widget.dart';
import 'package:flublade_project/data/gameplay/items.dart';
import 'package:flublade_project/data/language.dart';
import 'package:flublade_project/data/mysqldata.dart';
import 'package:flublade_project/pages/authenticationpage.dart';
import 'package:flublade_project/pages/gameplay/battle_scene.dart';
import 'package:flublade_project/pages/gameplay/ingame.dart';
import 'package:flublade_project/pages/gameplay/inventory.dart';
import 'package:flublade_project/pages/mainmenu/character_selection.dart';
import 'package:flublade_project/pages/mainmenu/characters_menu.dart';
import 'package:flublade_project/pages/mainmenu/main_menu.dart';
import 'package:flublade_project/pages/mainmenu/options_menu.dart';

import 'package:flutter/material.dart';
import 'package:mysql1/mysql1.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:bonfire/bonfire.dart';

class Options with ChangeNotifier {
  String _language = 'en_US';
  String _username = '';
  String _password = '';
  bool _remember = false;
  int _id = 0;

  String get language => _language;
  String get username => _username;
  String get password => _password;
  bool get remember => _remember;
  int get id => _id;

  void changeLanguage(value) {
    _language = value;
  }

  void changeUsername(value) {
    _username = value;
  }

  void changePassword(value) {
    _password = value;
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

  bool get isLoading => _isLoading;

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
}

class SaveDatas {
  static late SharedPreferences _preferences;

  //Storage Login
  static const _keyUsername = 'username';
  static const _keyPassword = 'password';
  static const _keyId = 0;
  static const _keyRemember = false;
  //Storage Options
  static const _keyCharacters = '{}';
  static const _keyLanguage = 'en_US';

  //Load Datas
  static Future init() async =>
      _preferences = await SharedPreferences.getInstance();

  //Set Datas
  static Future setUsername(String username) async =>
      await _preferences.setString(_keyUsername, username);
  static Future setPassword(String password) async =>
      await _preferences.setString(_keyPassword, password);
  static Future setId(int id) async =>
      await _preferences.setInt(_keyId.toString(), id);
  static Future setRemember(bool remember) async =>
      await _preferences.setBool(_keyRemember.toString(), remember);
  static Future setLanguage(String language) async =>
      await _preferences.setString(_keyLanguage, language);
  static Future setCharacters(String characters) async =>
      await _preferences.setString(_keyCharacters, characters);

  //Get Datas
  static String? getUsername() => _preferences.getString(_keyUsername);
  static String? getPassword() => _preferences.getString(_keyPassword);
  static int? getId() => _preferences.getInt(_keyId.toString());
  static bool? getRemember() => _preferences.getBool(_keyRemember.toString());
  static String? getLanguage() => _preferences.getString(_keyLanguage);
  static String? getCharacters() => _preferences.getString(_keyCharacters);
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
    '/battlescene': (context) => const BattleScene(),
  };

  //Confirmation Dialog
  static void confirmationDialog({
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
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(32.0))),
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            title: Text(
              Language.Translate(errorMsgTitle, options.language) ??
                  'Are you sure?',
              style: TextStyle(color: Theme.of(context).primaryColor),
            ),
            content: Text(
              Language.Translate(errorMsgContext, options.language) ??
                  'MsgContext',
              style: TextStyle(color: Theme.of(context).primaryColor),
            ),
            actions: [
              ElevatedButton(
                onPressed: () {
                  options.changeUsername('');
                  options.changePassword('');
                  options.changeRemember(value: false);
                  options.changeId(0);
                  Navigator.pushReplacementNamed(
                      context, '/authenticationpage');
                },
                child: Text(
                  Language.Translate('response_yes', options.language) ?? 'Yes',
                ),
              ),
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
    required String errorMsgTitle,
    required String errorMsgContext,
    required BuildContext context,
    enemySpecialLoot,
    int enemySpecialGold = 0,
  }) {
    final options = Provider.of<Options>(context, listen: false);
    final gameplay = Provider.of<Gameplay>(context, listen: false);
    final enemyLevel = gameplay.enemyLevel;
    List<Color> rarity = [];
    gameplay.resetPlayerInventorySelected();
    List lootCalculation() {
      List loots = [];
      int lootQuantity = 0;

      //Gold Quantity Calculator
      goldQuantity() {
        if (enemyLevel >= 0 && enemyLevel <= 4) {
          return 1 + Random().nextInt(6);
        } else if (enemyLevel >= 5 && enemyLevel <= 10) {
          return 3 + Random().nextInt(15);
        } else if (enemyLevel >= 11 && enemyLevel <= 20) {
          return 6 + Random().nextInt(25);
        } else if (enemyLevel >= 21 && enemyLevel <= 30) {
          return 12 + Random().nextInt(35);
        } else if (enemyLevel >= 31 && enemyLevel <= 45) {
          return 20 + Random().nextInt(50);
        } else if (enemyLevel >= 46 && enemyLevel <= 60) {
          return 30 + Random().nextInt(80);
        } else if (enemyLevel > 60) {
          return 50 + Random().nextInt(100);
        }
        return 0;
      }

      //Gold Add
      loots.add({
        'name': 'gold',
        'quantity': goldQuantity() + enemySpecialGold,
      });
      //Gold Color
      rarity.add(Colors.grey);

      //Loot Quantity Calculator
      if (Random().nextInt(10) >= 1) {
        lootQuantity = lootQuantity + Random().nextInt(3);
        //60% Chance to increase loot
        if (Random().nextInt(10) > 2) {
          lootQuantity = lootQuantity + Random().nextInt(3);
          //40% Chance to increase loot
          if (Random().nextInt(10) >= 5) {
            lootQuantity = lootQuantity + Random().nextInt(4);
          }
          //20% Chance to increase loot
          if (Random().nextInt(10) >= 6) {
            lootQuantity = lootQuantity + Random().nextInt(5);
            //10% Chance to increase loot
            if (Random().nextInt(10) >= 7) {
              lootQuantity = lootQuantity + Random().nextInt(6);
            }
          }
        }
      }

      //Loot Ramdomizer
      lootRandom() {
        //20% To Rare Items
        if (Random().nextInt(10) >= 8) {
          //5% To Ultra Rare Items
          if (Random().nextInt(10) >= 7) {
            final int index = Random().nextInt(3) + 200;
            rarity.add(Colors.purple);
            return {
              'name': Items.lootId[index],
              'quantity': 1,
            };
          }
          final int index = Random().nextInt(3) + 100;
          rarity.add(Colors.green);
          return {
            'name': Items.lootId[index],
            'quantity': 1,
          };
        }
        final int index = Random().nextInt(3);
        int quantity = 1;
        if (index == 0) {
          quantity = goldQuantity();
        }
        rarity.add(Colors.grey);
        return {
          'name': Items.lootId[index],
          'quantity': quantity,
        };
      }

      //Loot Special Add
      if (enemySpecialLoot != null) {
        for (int i = 0; i <= enemySpecialLoot.length - 1; i++) {
          loots.add({
            'name': enemySpecialLoot[i],
            'quantity': 1,
          });
        }
      }

      //Loot Add
      for (int i = 1; i <= lootQuantity; i++) {
        loots.add(lootRandom());
      }

      return loots;
    }

    final loots = lootCalculation();
    showDialog(
        barrierColor: const Color.fromARGB(167, 0, 0, 0),
        context: context,
        builder: (context) {
          return FittedBox(
            child: WillPopScope(
              onWillPop: () async => false,
              child: AlertDialog(
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(32.0))),
                backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                title: Text(
                  Language.Translate(errorMsgTitle, options.language) ??
                      'Language Error',
                  style: TextStyle(color: Theme.of(context).primaryColor),
                ),
                //Loot Items
                content: SizedBox(
                  width: 100,
                  height: 100,
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          GridView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3,
                            ),
                            shrinkWrap: true,
                            itemCount: loots.length,
                            itemBuilder: (context, index) {
                              return LootWidget(
                                loots: loots,
                                index: index,
                                color: rarity,
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                actions: [
                  //Take All
                  ElevatedButton(
                    onPressed: () async {
                      MySQL.loadingWidget(
                          context: context, language: options.language);
                      gameplay.addInventoryItem(loots);
                      await MySQL.pushUploadCharacters(context: context);
                      // ignore: use_build_context_synchronously
                      Navigator.pop(context);
                      // ignore: use_build_context_synchronously
                      Navigator.pop(context);
                      // ignore: use_build_context_synchronously
                      Navigator.pop(context);
                      // ignore: use_build_context_synchronously
                      Provider.of<Gameplay>(context, listen: false)
                          .changeEnemyMove(true);
                    },
                    child: Text(
                      Language.Translate('battle_loot_all', options.language) ??
                          'Take All',
                    ),
                  ),
                  //Exit
                  ElevatedButton(
                    onPressed: () async {
                      if (gameplay.playerInventorySelected.isNotEmpty) {
                        //Loading
                        MySQL.loadingWidget(
                            context: context, language: options.language);
                        //Update Local
                        gameplay
                            .addInventoryItem(gameplay.playerInventorySelected);
                        //Update Database
                        await MySQL.pushUploadCharacters(context: context);
                        // ignore: use_build_context_synchronously
                        Navigator.pop(context);
                      }
                      // ignore: use_build_context_synchronously
                      Navigator.pop(context);
                      // ignore: use_build_context_synchronously
                      Navigator.pop(context);
                      // ignore: use_build_context_synchronously
                      Provider.of<Gameplay>(context, listen: false)
                          .changeEnemyMove(true);
                    },
                    child: Text(
                      Language.Translate(
                              'battle_loot_exit', options.language) ??
                          'Take All',
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
    required options,
    String? popUntil,
  }) {
    showDialog(
        barrierColor: const Color.fromARGB(167, 0, 0, 0),
        context: context,
        builder: (context) {
          return WillPopScope(
            onWillPop: () async => false,
            child: AlertDialog(
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(32.0))),
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              //Language Text
              title: Text(
                ':(',
                style: TextStyle(color: Theme.of(context).primaryColor),
              ),
              content: Text(
                Language.Translate(errorMsgTitle, options.language) ??
                    errorMsgContext,
                style: TextStyle(color: Theme.of(context).primaryColor),
              ),
              actions: [
                Center(
                    child: ElevatedButton(
                  onPressed: () {
                    if (popUntil != null) {
                      Navigator.popUntil(
                          context, ModalRoute.withName(popUntil));
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
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(32.0))),
                backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                //Language Text
                title: Text(
                  Language.Translate('pausemenu_pause', options.language) ??
                      'Pause',
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
                        child: Text(Language.Translate(
                                'pausemenu_continue', options.language) ??
                            'Continue'),
                      ),
                    ),
                    //Options
                    Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pushNamed(context, '/optionsmenu');
                        },
                        child: Text(Language.Translate(
                                'pausemenu_options', options.language) ??
                            'Options'),
                      ),
                    ),
                    //Disconnect
                    Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pushNamedAndRemoveUntil(
                              '/mainmenu', (Route route) => false);
                        },
                        child: Text(Language.Translate(
                                'pausemenu_disconnect', options.language) ??
                            'Disconnect'),
                      ),
                    ),
                  ],
                )),
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
  double _playerLife = 0;
  double _playerMana = 0;
  double _playerGold = 0;
  double _playerArmor = 0;
  double _playerXP = 0;
  int _playerLevel = 1;
  int _playerStrength = 0;
  int _playerAgility = 0;
  int _playerIntelligence = 0;
  int _playerLuck = 0;
  int _playerDamage = 0;
  Map _playerInventory = {};
  List _playerInventorySelected = [];

  double _enemyLife = 0;
  double _enemyMana = 0;
  double _enemyArmor = 0;
  int _enemyLevel = 0;
  int _enemyDamage = 0;

  bool get isTalkable => _isTalkable;
  bool get enemysMove => _enemysMove;
  String get selectedTalk => _selectedTalk;
  double get playerLife => _playerLife;
  double get playerMana => _playerMana;
  double get playerGold => _playerGold;
  double get playerArmor => _playerArmor;
  double get playerXP => _playerXP;
  int get playerLevel => _playerLevel;
  int get playerStrength => _playerStrength;
  int get playerAgility => _playerAgility;
  int get playerIntelligence => _playerIntelligence;
  int get playerLuck => _playerLuck;
  int get playerDamage => _playerDamage;
  Map get playerInventory => _playerInventory;
  List get playerInventorySelected => _playerInventorySelected;

  double get enemyLife => _enemyLife;
  double get enemyMana => _enemyMana;
  double get enemyArmor => _enemyArmor;
  int get enemyLevel => _enemyLevel;
  int get enemyDamage => _enemyDamage;

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
      _playerMana = value;
      notifyListeners();
      return;
    } else if (stats == 'gold') {
      _playerGold = value;
      notifyListeners();
      return;
    } else if (stats == 'armor') {
      _playerArmor = value;
      notifyListeners();
      return;
    } else if (stats == 'level') {
      _playerLevel = value;
      notifyListeners();
      return;
    } else if (stats == 'xp') {
      _playerXP = value;
      notifyListeners();
      return;
    } else if (stats == 'strength') {
      _playerStrength = value;
      notifyListeners();
      return;
    } else if (stats == 'agility') {
      _playerAgility = value;
      notifyListeners();
      return;
    } else if (stats == 'intelligence') {
      _playerIntelligence = value;
      notifyListeners();
      return;
    } else if (stats == 'luck') {
      _playerLuck = value;
      notifyListeners();
      return;
    } else if (stats == 'damage') {
      _playerDamage = value;
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
    }
    //Enemy Stats
    if (stats == 'elife') {
      _enemyLife = value;
      notifyListeners();
      return;
    } else if (stats == 'emana') {
      _enemyMana = value;
      notifyListeners();
      return;
    } else if (stats == 'earmor') {
      _enemyArmor = value;
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
    }
  }

  //Add Selected playerInventorySelected
  void addPlayerInventorySelected(value) {
    _playerInventorySelected.add(value);
  }

  Map addInventoryItem(items) {
    bool jumpClear = false;
    for (int i = 0; i <= items.length - 1; i++) {
      try {
        //If inventory is clear
        if (_playerInventory.isEmpty && !jumpClear) {
          _playerInventory[items[i]['name']] = {
            'name': items[i]['name'],
            'quantity': items[i]['quantity'],
          };
          i++;
          jumpClear = true;
        }
        //Inventory Scan
        for (int a = 0; a <= _playerInventory.length - 1; a++) {
          //Doesnt Exist in inventory
          if (_playerInventory[items[i]['name']] == null) {
            _playerInventory[items[i]['name']] = {
              'name': items[i]['name'],
              'quantity': items[i]['quantity'],
            };
            //Stop Loop
            break;
            //Exist in inventory
          } else {
            final calculation = _playerInventory[items[i]['name']]['quantity'] +
                items[i]['quantity'];
            _playerInventory[items[i]['name']]['quantity'] = calculation;
            //Stop Loop
            break;
          }
        }
      } catch (_) {}
    }
    return _playerInventory;
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
                                child:
                                    Image.asset('assets/images/npc/wizard.png'),
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
                                Language.Translate(gameplay.selectedTalk,
                                        options.language) ??
                                    'Language Error',
                                style: TextStyle(
                                    fontSize: 5,
                                    color: Theme.of(context).primaryColor),
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

  //Add new Character
  Future<String> addCharacter({
    required String characterUsername,
    required String characterClass,
    required MySqlConnection connection,
    required options,
    required gameplay,
  }) async {
    dynamic charactersdb = {};
    //Connection
    try {
      charactersdb = await connection
          .query('select characters from accounts where id = ?', [options.id]);
      charactersdb =
          charactersdb.toString().replaceFirst('(Fields: {characters: ', '');
      charactersdb = charactersdb.substring(0, charactersdb.length - 2);
      //Verify if Database and Provider is the Same
      if (charactersdb != gameplay.characters) {
        //Add new character
        charactersdb = jsonDecode(charactersdb);
        charactersdb['character${charactersdb.length}'] = {
          'name': characterUsername,
          'class': characterClass
              .replaceFirst('assets/characters/', '')
              .substring(
                  0,
                  characterClass.replaceFirst('assets/characters/', '').length -
                      4),
          'life': 100,
          'mana': 10,
          'armor': 0,
          'gold': 0,
          'level': 1,
          'xp': 0,
          'skillpoint': 0,
          'strength': 0,
          'agility': 0,
          'intelligence': 0,
          'luck': 0,
          'weapon': 'unarmed',
          'inventory': '{}',
          'location': 'prologue',
        };
        charactersdb = jsonEncode(charactersdb);
        //Upload to Database
        await connection.query('update accounts set characters=? where id=?',
            [charactersdb, options.id]);
        return charactersdb;
      }
    } catch (error) {
      return 'Cannot Connect to The Servers';
    }
    //Add new character in Provider
    Map characterFormat = jsonDecode(_characters);
    characterFormat['character${characterFormat.length}'] = {
      'name': characterUsername,
      'class': characterClass.replaceFirst('assets/characters/', '').substring(
          0, characterClass.replaceFirst('assets/characters/', '').length - 4),
      'life': 100,
      'mana': 10,
      'armor': 0,
      'gold': 0,
      'level': 1,
      'xp': 0,
      'skillpoint': 0,
      'strength': 0,
      'agility': 0,
      'intelligence': 0,
      'luck': 0,
      'weapon': 'unarmed',
      'inventory': '{}',
      'location': 'prologue',
    };
    //Saving Datas
    _characters = jsonEncode(characterFormat);
    SaveDatas.setCharacters(_characters);
    //Upload to Database
    await connection.query('update accounts set characters=? where id=?',
        [_characters, options.id]);
    return _characters;
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

  //Class Calculations
  static dynamic classTranslation({
    options,
    gameplay,
    context,
    required List values,
    bool isCharacterCreation = false,
    bool isIngamePlayerAttackCalculation = false,
    bool isIngamePlayerDefenceCalculation = false,
    bool isPlayerDamageCalculation = false,
  }) {
    //Character Creation Calculation
    if (isCharacterCreation) {
      if (values[0] == 'archer') {}
    }
    //Player Attack Calculation
    if (isIngamePlayerAttackCalculation) {
      final gameplay = Provider.of<Gameplay>(context, listen: false);
      final strengthDamage = (gameplay.playerStrength * 0.5).toStringAsFixed(0);
      final weaponDamage = returnWeaponDamage(gameplay);
      double totalDamage = double.parse(strengthDamage) + weaponDamage;
      totalDamage = totalDamage - gameplay.enemyArmor;
      final result = gameplay.enemyLife - totalDamage;
      gameplay.changeStats(value: result, stats: 'elife');
    }
    //Player Damage Calculation
    if (isPlayerDamageCalculation) {
      final strengthDamage = (gameplay.playerStrength * 0.5).toStringAsFixed(0);
      final weaponDamage = returnWeaponDamage(gameplay);
      final totalDamage = int.parse(strengthDamage) + weaponDamage;
      return totalDamage;
    }
  }

  //Weapons Providers
  String _playerWeapon = 'unarmed';

  String get playerWeapon => _playerWeapon;

  void changePlayerWeapon(value) {
    _playerWeapon = value;
  }

  //Weapons Calculations
  static int returnWeaponDamage(gameplay) {
    switch (gameplay.playerWeapon) {
      case 'unarmed':
        return 1;
      case 'woodsword':
        return 2;
    }
    return 0;
  }
}

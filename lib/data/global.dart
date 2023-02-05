import 'dart:convert';

import 'package:flublade_project/components/character_creation.dart';
import 'package:flublade_project/data/language.dart';
import 'package:flublade_project/pages/authenticationpage.dart';
import 'package:flublade_project/pages/gameplay/ingame.dart';
import 'package:flublade_project/pages/mainmenu/character_selection.dart';
import 'package:flublade_project/pages/mainmenu/characters_menu.dart';
import 'package:flublade_project/pages/mainmenu/main_menu.dart';
import 'package:flublade_project/pages/mainmenu/options_menu.dart';
import 'package:flutter/material.dart';

import 'package:mysql1/mysql1.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
          return AlertDialog(
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(32.0))),
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            //Language Text
            title: Text(
              'errorMsgTitle',
              style: TextStyle(color: Theme.of(context).primaryColor),
            ),
            content: Text(
              Language.Translate('errorMsgContext', options.language) ??
                  'Language Error',
              style: TextStyle(color: Theme.of(context).primaryColor),
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

  //Return class
  static String returnClass() {
    return 'berserk';
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
          'level': 1,
          'skillpoint': 0,
          'gold': 0,
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
      'level': 1,
      'skillpoint': 0,
      'gold': 0,
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
}

import 'package:flublade_project/data/language.dart';
import 'package:flutter/material.dart';
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

  //Get Datas
  static String? getUsername() => _preferences.getString(_keyUsername);
  static String? getPassword() => _preferences.getString(_keyPassword);
  static int? getId() => _preferences.getInt(_keyId.toString());
  static bool? getRemember() => _preferences.getBool(_keyRemember.toString());
  static String? getLanguage() => _preferences.getString(_keyLanguage);
}

class GlobalFunctions {
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
}

class Gameplay {
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
}

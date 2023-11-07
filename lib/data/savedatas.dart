import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';

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
  static int? getTextSpeed() => _preferences.getInt(_keyTextSpeed.toString());
}

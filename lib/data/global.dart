import 'package:flutter/cupertino.dart';

class Options with ChangeNotifier {
  String _language = 'en_US';
  String _username = '';
  String _password = '';
  int _id = 0;

  String get language => _language;
  String get username => _username;
  String get password => _password;
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

  void changeId(value) {
    _id = value;
  }
}
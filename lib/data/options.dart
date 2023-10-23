import 'package:flutter/material.dart';

class Options with ChangeNotifier {
  String _language = 'en_US';
  int _textSpeed = 700;
  String _username = '';
  String _token = '';
  bool _remember = false;
  int _id = 0;
  bool _debug = false;

  String get language => _language;
  int get textSpeed => _textSpeed;
  String get username => _username;
  String get token => _token;
  bool get remember => _remember;
  int get id => _id;
  bool get debug => _debug;

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

  void changeRemember({value, notify = true}) {
    if (value == null) {
      _remember = !_remember;
      notify ? notifyListeners() : () => {};
      return;
    }
    if (value) {
      _remember = value;
      notify ? notifyListeners() : () => {};
    } else if (!value) {
      _remember = value;
      notify ? notifyListeners() : () => {};
    }
  }

  void changeId(value) {
    _id = value;
  }

  void changeDebug(value) {
    _debug = value;
  }
}

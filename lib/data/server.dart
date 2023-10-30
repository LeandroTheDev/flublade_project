// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'dart:io';

import 'package:flublade_project/components/system/dialogs.dart';
import 'package:flublade_project/data/gameplay.dart';
import 'package:flublade_project/data/options.dart';
import 'package:flublade_project/data/settings.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

class Server with ChangeNotifier {
  String _serverAddress = '0.0.0.0:8080';
  String _serverName = '';
  String get serverAddress => _serverAddress;
  String get serverName => _serverName;

  //-----
  //Server Infos
  //-----
  //Change server IP
  void changeServerAddress(value) {
    _serverAddress = '$value:$ports';
  }

  //Change server Name
  void changeServerName(value) {
    _serverName = value;
  }

  //Backend Connection
  static const ports = 8080;
  static const headers = {
    HttpHeaders.contentTypeHeader: 'application/json',
  };

  //Return Character Inventory
  ///DEPRECATED
  static Future<String> returnPlayerInventory(BuildContext context) async {
    final options = Provider.of<Options>(context);
    final gameplay = Provider.of<Gameplay>(context);
    final server = Provider.of<Server>(context, listen: false);
    //Pickup from database
    dynamic charactersdb;
    try {
      //Connection
      charactersdb = await http.post(Uri.http(server.serverAddress, '/getCharacters'), headers: Server.headers, body: jsonEncode({'id': options.id, 'token': options.token, 'selectedCharacter': gameplay.selectedCharacter, 'onlyInventory': true}));
      //Token check
      if (jsonDecode(charactersdb.body)['message'] == 'Invalid Login') {
        return 'Invalid Login';
      }
    } catch (error) {
      return 'Connection Error';
    }
    charactersdb = jsonDecode(charactersdb.body)['inventory'];
    if (charactersdb == '{}') {
      return 'Empty';
    }
    gameplay.changePlayerInventory(charactersdb);
    return 'Success';
  }

  //Push and Upload Characters
  ///DEPRECATED
  static Future<String> pushUploadCharacters({required BuildContext context}) async {
    final options = Provider.of<Options>(context, listen: false);
    final gameplay = Provider.of<Gameplay>(context, listen: false);
    final server = Provider.of<Server>(context, listen: false);
    dynamic charactersdb;

    try {
      //Connection
      charactersdb = await http.post(Uri.http(server.serverAddress, '/getCharacters'), headers: Server.headers, body: jsonEncode({'id': options.id, 'token': options.token}));
      //Token check
      if (jsonDecode(charactersdb.body)['message'] == 'Invalid Login') {
        return 'Invalid Login';
      }
    } catch (error) {
      return 'Connection Error';
    }
    //Transform into MAP
    charactersdb = jsonDecode(charactersdb.body);
    charactersdb = jsonDecode(charactersdb['characters']);
    //Updates
    if (true) {
      //Update Inventory
      charactersdb['character${gameplay.selectedCharacter}']['inventory'] = gameplay.playerInventory;
      //Update Equips
      charactersdb['character${gameplay.selectedCharacter}']['equips'] = gameplay.playerEquips;
      //Update Level
      charactersdb['character${gameplay.selectedCharacter}']['level'] = gameplay.playerLevel;
      //Update XP
      charactersdb['character${gameplay.selectedCharacter}']['xp'] = gameplay.playerXP;
      //Update Skillpoints
      charactersdb['character${gameplay.selectedCharacter}']['skillpoint'] = gameplay.playerSkillpoint;
      //Update Strength
      charactersdb['character${gameplay.selectedCharacter}']['strength'] = gameplay.playerStrength;
      //Update Agility
      charactersdb['character${gameplay.selectedCharacter}']['agility'] = gameplay.playerIntelligence;
      //Update Intelligence
      charactersdb['character${gameplay.selectedCharacter}']['intelligence'] = gameplay.playerIntelligence;
    }
    //Transform into String
    charactersdb = jsonEncode(charactersdb);
    //Upload to database
    final result = await updateCharacters(characters: charactersdb, context: context);
    //Error Treatment
    if (true) {
      if (result == 'Invalid Login') {
        return 'Invalid Login';
      }
      if (result == 'Connection Error') {
        return 'Connection Error';
      }
    }
    return 'Success';
  }

  //Push Characters
  ///DEPRECATED
  static Future<dynamic> pushCharacters({required context}) async {
    final options = Provider.of<Options>(context, listen: false);
    final gameplay = Provider.of<Gameplay>(context, listen: false);
    final server = Provider.of<Server>(context, listen: false);
    dynamic charactersdb;
    try {
      //Connection
      charactersdb = await http.post(Uri.http(server.serverAddress, '/getCharacters'), headers: Server.headers, body: jsonEncode({'id': options.id, 'token': options.token}));
    } catch (error) {
      //Connection Error
      Dialogs.alertDialog(context: context, message: 'authentication_register_problem_connection');
      return 'Connection Error';
    }
    charactersdb = jsonDecode(charactersdb.body);
    //Token Check
    if (charactersdb['message'] == 'Invalid Login') {
      Navigator.pushNamed(context, '/authenticationpage');
      Dialogs.errorDialog(errorMsg: 'authentication_invalidlogin', context: context);
      return 'Invalid Login';
    }
    gameplay.changeCharacters(jsonDecode(charactersdb['characters']));
    return charactersdb['characters'];
  }

  //Update Characters to the database
  ///DEPRECATED
  static Future<String> updateCharacters({String characters = '', context, bool isLevelUp = false}) async {
    final options = Provider.of<Options>(context, listen: false);
    final gameplay = Provider.of<Gameplay>(context, listen: false);
    final server = Provider.of<Server>(context, listen: false);
    dynamic charactersdb = jsonDecode(characters);
    dynamic result;
    try {
      if (isLevelUp) {
        //Connection
        result = await http.post(Uri.http(server.serverAddress, '/updateCharacters'),
            headers: Server.headers,
            body: jsonEncode({
              'id': options.id,
              'token': options.token,
              'selectedCharacter': gameplay.selectedCharacter,
              'isLevelUp': true,
            }));
        //Change Stats
        gameplay.changeStats(value: jsonDecode(jsonDecode(result.body)['characters'])['character${gameplay.selectedCharacter}']['strength'], stats: 'strength');
        gameplay.changeStats(value: jsonDecode(jsonDecode(result.body)['characters'])['character${gameplay.selectedCharacter}']['agility'], stats: 'agility');
        gameplay.changeStats(value: jsonDecode(jsonDecode(result.body)['characters'])['character${gameplay.selectedCharacter}']['intelligence'], stats: 'intelligence');
        gameplay.changeStats(value: jsonDecode(jsonDecode(result.body)['characters'])['character${gameplay.selectedCharacter}']['armor'], stats: 'armor');
        gameplay.changeStats(value: jsonDecode(jsonDecode(result.body)['characters'])['character${gameplay.selectedCharacter}']['skillpoint'], stats: 'skillpoint');
      } else {
        //Connection
        result = await http.post(Uri.http(server.serverAddress, '/updateCharacters'),
            headers: Server.headers,
            body: jsonEncode({
              'id': options.id,
              'token': options.token,
              'selectedCharacter': gameplay.selectedCharacter,
              'name': charactersdb['character${gameplay.selectedCharacter}']['name'],
              'life': gameplay.playerLife,
              'mana': gameplay.playerMana,
              'armor': gameplay.playerArmor,
              'level': gameplay.playerLevel,
              'xp': gameplay.playerXP,
              'skillpoint': gameplay.playerSkillpoint,
              'strength': gameplay.playerStrength,
              'agility': gameplay.playerAgility,
              'intelligence': gameplay.playerIntelligence,
              'luck': gameplay.playerLuck,
              'inventory': gameplay.playerInventory,
              'buffs': gameplay.playerBuffs,
              'equips': gameplay.playerEquips,
              'location': charactersdb['character${gameplay.selectedCharacter}']['location'],
            }));
      }
      //Token Check
      if (jsonDecode(result.body)['message'] == 'Invalid Login') {
        return 'Invalid Login';
      }
    } catch (error) {
      //Connection Error
      return 'Connection Error';
    }
    return 'Success';
  }

  //Return Info
  ///DEPRECATED
  static dynamic returnInfo(context, {required String returned}) {
    final gameplay = Provider.of<Gameplay>(context, listen: false);
    final Map characters = gameplay.characters;
    //Return Class
    if (returned == 'class') {
      final String characterClass = characters['character${gameplay.selectedCharacter}']['class'];
      return characterClass;
    }
    //Return Player Location
    if (returned == 'location') {
      final Map characters = gameplay.characters;
      //World Name
      final String location = characters['character${gameplay.selectedCharacter}']['location'].substring(0, characters['character${gameplay.selectedCharacter}']['location'].length - 3);
      //World ID
      gameplay.changeWorldId(
        int.parse(
          characters['character${gameplay.selectedCharacter}']['location'].substring(characters['character${gameplay.selectedCharacter}']['location'].length - 3),
        ),
      );
      return location;
    }
  }

  //Return Player Stats // Update selected character to actual gameplay
  ///DEPRECATED
  static Future returnPlayerStats(context) async {
    final options = Provider.of<Options>(context, listen: false);
    final gameplay = Provider.of<Gameplay>(context, listen: false);
    final server = Provider.of<Server>(context, listen: false);
    //Receive from database
    dynamic charactersdb;
    try {
      //Connection
      charactersdb = await http.post(Uri.http(server.serverAddress, '/getCharacters'), headers: Server.headers, body: jsonEncode({'id': options.id, 'token': options.token}));
      //Token check
      if (jsonDecode(charactersdb.body)['message'] == 'Invalid Login') {
        return 'Invalid Login';
      }
    } catch (error) {
      return 'Connection Error';
    }
    //Transform into MAP
    charactersdb = jsonDecode(charactersdb.body);
    charactersdb = jsonDecode(charactersdb['characters']);
    //Pickup Selected Character
    final selectedCharacter = charactersdb['character${gameplay.selectedCharacter}'];
    //Return Stats
    gameplay.changeStats(value: double.parse(selectedCharacter['life'].toString()), stats: 'life');
    gameplay.changeStats(value: double.parse(selectedCharacter['mana'].toString()), stats: 'mana');
    gameplay.changeStats(value: double.parse(selectedCharacter['armor'].toString()), stats: 'armor');
    gameplay.changeStats(value: double.parse(selectedCharacter['xp'].toString()), stats: 'xp');
    gameplay.changeStats(value: int.parse(selectedCharacter['level'].toString()), stats: 'level');
    gameplay.changeStats(value: double.parse(selectedCharacter['strength'].toString()), stats: 'strength');
    gameplay.changeStats(value: double.parse(selectedCharacter['agility'].toString()), stats: 'agility');
    gameplay.changeStats(value: double.parse(selectedCharacter['intelligence'].toString()), stats: 'intelligence');
    gameplay.changeStats(value: selectedCharacter['inventory'], stats: 'inventory');
    gameplay.changeStats(value: selectedCharacter['equips'], stats: 'equips');
    gameplay.changeStats(value: selectedCharacter['buffs'], stats: 'buffs');
    gameplay.changeStats(value: selectedCharacter['xp'], stats: 'xp');
    gameplay.changeStats(value: selectedCharacter['skillpoint'], stats: 'skillpoint');
    gameplay.changeStats(value: selectedCharacter['skills'], stats: 'skills');
    gameplay.changeStats(value: selectedCharacter['debuffs'], stats: 'debuffs');
    gameplay.changeLocation(selectedCharacter['location']);
  }

  ///Comunicates the server via http request and return a Map with the server response
  ///
  ///Example Post:
  ///```dart
  ///sendServerMessage("/login", { username: "test", password: "123" })
  ///```
  ///
  ///Also change the get paramater to true for "get" responses,
  ///to send data via get with query parameters you can do the same with post body
  ///
  ///Example Get:
  ///```dart
  ///sendSeverMessage("/loginRemember", { username: "test", token: "123" }, true)
  ///```
  static Future<Map> sendMessage(context, {required String address, required Map<String, dynamic> body, bool get = false}) async {
    final server = Provider.of<Server>(context, listen: false);
    late final http.Response result;
    //Get Response
    if (get) {
      try {
        result = await http.get(Uri.http(server.serverAddress, address, body), headers: Server.headers);
      } catch (error) {
        return {
          "error": true,
          "message": "No Connection",
        };
      }
      return jsonDecode(result.body);
    }
    //Post Response
    else {
      try {
        result = await http.post(Uri.http(server.serverAddress, address), headers: Server.headers, body: jsonEncode(body));
      } catch (error) {
        return {
          "error": true,
          "message": "No Connection",
        };
      }
      return jsonDecode(result.body);
    }
  }

  ///Provides any dialog message for the respective error message,
  ///if the error is not listed then no dialogs will appear
  static errorTreatment(String message, BuildContext context) {
    switch (message) {
      case 'Invalid Login':
        Dialogs.errorDialog(context: context, errorMsg: 'authentication_invalid_login');
        return;
      case 'Server Crashed':
        Dialogs.alertDialog(context: context, message: 'authentication_lost_connection');
        return;
      case 'Too Many Attempts':
        Dialogs.alertDialog(context: context, message: 'authentication_temporary_blocked');
        return;
      case 'Wrong Credentials':
        Dialogs.alertDialog(context: context, message: 'authentication_login_notfound');
        return;
      case 'Empty':
        Dialogs.alertDialog(context: context, message: 'characters_create_error_empty');
        return;
      case 'Too Big':
        Dialogs.alertDialog(context: context, message: 'characters_create_error_namelimit');
        return;
      case 'Too Small or Too Big Username':
        Dialogs.alertDialog(context: context, message: 'authentication_register_problem_username');
        return;
      case 'Too Small Password or Too Big Password':
        Dialogs.alertDialog(context: context, message: 'authentication_register_problem_password');
        return;
      case 'Username Already Exists':
        Dialogs.alertDialog(context: context, message: 'authentication_register_problem_existusername');
        return;
      case 'No Connection':
        Dialogs.alertDialog(context: context, message: 'authentication_register_problem_connection');
        return;
    }
  }

  ///Remove the specific character by the index of characters account
  static Future<void> removeCharacter({required index, required context}) async {
    final options = Provider.of<Options>(context, listen: false);
    final server = Provider.of<Server>(context, listen: false);
    http.Response response;
    try {
      //Connection
      response = await http.post(Uri.http(server.serverAddress, '/removeCharacters'), headers: Server.headers, body: jsonEncode({'id': options.id, 'token': options.token, 'index': index}));
    } catch (error) {
      //Connection Error
      Dialogs.alertDialog(context: context, message: 'authentication_register_problem_connection');
      return;
    }
    Map result = jsonDecode(response.body);
    //Error Treatment
    Server.errorTreatment(result['message'], context);
  }

  ///Returns a Map of all characters from current account logged
  ///
  ///Returns any empty Map if any errors occurs,
  ///also display any alert dialog in case of errors
  static Future<Map> getCharacters({required BuildContext context}) async {
    final options = Provider.of<Options>(context, listen: false);
    final Map result = await Server.sendMessage(context, address: '/getCharacters', body: {'id': options.id.toString(), 'token': options.token}, get: true);
    if (result['message'] == "Success") {
      return jsonDecode(result["characters"]);
    } else {
      Server.errorTreatment(result['message'], context);
      return {};
    }
  }
}

class ServerGameplay {
  //Return Server Stats
  ///DEPRECATED
  static Future returnGameplayStats(context) async {
    final settings = Provider.of<Settings>(context, listen: false);
    final server = Provider.of<Server>(context, listen: false);
    dynamic result;
    //Receive All Stats
    result = await http.post(
      Uri.http(server.serverAddress, '/gameplayStats'),
      headers: Server.headers,
      body: jsonEncode({
        'all': true,
      }),
    );
    settings.changeBaseAtributes(jsonDecode(result.body)['baseAtributes']);
    settings.changeLevelCaps(jsonDecode(result.body)['levelCaps']);
    settings.changeSkillsId(jsonDecode(result.body)['skillsId']);
    settings.changeItemsId(jsonDecode(result.body)['itemsId']);
  }

  //Return Level
  ///DEPRECATED
  static Future<List<dynamic>> returnLevel({required BuildContext context, required String level}) async {
    final server = Provider.of<Server>(context, listen: false);
    final options = Provider.of<Options>(context, listen: false);
    final gameplay = Provider.of<Gameplay>(context, listen: false);
    List results = [];

    //Returning the Tiles
    dynamic result = await http.post(Uri.http(server.serverAddress, '/pushLevel'),
        headers: Server.headers,
        body: jsonEncode({
          'id': options.id,
          'token': options.token,
          'selectedCharacter': gameplay.selectedCharacter,
        }));
    result = jsonDecode(result.body);
    //Adding the tiles
    List<List<int>> level = [];
    for (int i = 0; i <= result['level'].length - 1; i++) {
      List<int> levelTile = [];
      result['level'][i] = json.decode(result['level'][i]).cast<int>().toList();
      result['level'][i].forEach((int tile) => levelTile.add(tile));
      level.add(levelTile);
    }
    results.add(level);
    return results;
  }
}

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

  //Remove Characters
  static Future removeCharacters({required index, required context}) async {
    final options = Provider.of<Options>(context, listen: false);
    final gameplay = Provider.of<Gameplay>(context, listen: false);
    final server = Provider.of<Server>(context, listen: false);
    dynamic charactersdb;
    try {
      //Connection
      charactersdb = await http.post(Uri.http(server.serverAddress, '/removeCharacters'), headers: Server.headers, body: jsonEncode({'id': options.id, 'token': options.token, 'index': index}));
    } catch (error) {
      //Connection Error
      Dialogs.alertDialog(context: context, message: 'authentication_register_problem_connection');
      return;
    }
    charactersdb = jsonDecode(charactersdb.body);
    //Token Check
    if (charactersdb['message'] == 'Invalid Login') {
      Dialogs.errorDialog(errorMsg: 'authentication_invalidlogin', context: context);
      return;
    }
    //Success
    if (charactersdb['message'] == 'Success') {
      gameplay.changeCharacters(charactersdb['characters']);
    }
    return;
  }

  //Return Info
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
}

class ServerGameplay {
  //Return Server Stats
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

import 'dart:convert';
import 'dart:io';

import 'package:flublade_project/data/gameplay/enemys.dart';
import 'package:flublade_project/data/gameplay/npc.dart';
import 'package:flublade_project/data/global.dart';
import 'package:flublade_project/data/language.dart';

import 'package:flutter/material.dart';
import 'package:mysql1/mysql1.dart';
import 'package:provider/provider.dart';
import 'package:bonfire/bonfire.dart';
import 'package:http/http.dart' as http;

class MySQL {
  //Backend Connection
  static const ip = 'localhost';
  static const ports = 8080;
  static const url = '$ip:$ports';
  static const headers = {
    HttpHeaders.contentTypeHeader: 'application/json',
  };

  //Database Connection
  static final database = MySqlConnection.connect(
    ConnectionSettings(
      host: '192.168.0.13',
      port: 3306,
      user: 'flubladeGuest',
      password: 'i@Dhs4e5E%fGz&ngbY2m&AGRCVlskBUrrCnsYFUze&fhxehb#j',
      db: 'flublade',
    ),
  );

  //Loading
  static void loadingWidget(
      {required BuildContext context, required String language}) {
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
                Language.Translate(
                        'authentication_register_loading', language) ??
                    'Loading',
                style: TextStyle(color: Theme.of(context).primaryColor),
              ),
              content: const Padding(
                padding: EdgeInsets.all(50.0),
                child: SizedBox(
                    width: 100,
                    height: 100,
                    child: CircularProgressIndicator()),
              ),
            ),
          );
        });
  }

  //Change Language
  static Future<void> changeLanguage(context, widget) async {
    final screenSize = MediaQuery.of(context).size;
    final options = Provider.of<Options>(context, listen: false);
    //Upload to MySQL
    uploadData(String language) async {
      loadingWidget(context: context, language: language);
      //Update Datas
      options.changeLanguage(language);
      SaveDatas.setLanguage(language);
      late final http.Response result;
      try {
        //Credentials Check
        result = await http.post(
          Uri.http(url, '/updateLanguage'),
          headers: headers,
          body: jsonEncode(
              {"id": options.id, "language": language, "token": options.token}),
        );
      } catch (error) {
        GlobalFunctions.errorDialog(
            errorMsgTitle: 'authentication_register_problem_connection',
            errorMsgContext: 'Failed to connect to the Servers',
            context: context);
        return;
      }
      if (jsonDecode(result.body)['message'] == 'Invalid Login') {
        Navigator.pushNamed(context, '/authenticationpage');
        GlobalFunctions.errorDialog(
            errorMsgTitle: 'authentication_invalidlogin',
            errorMsgContext: 'Invalid Session',
            context: context,
            popUntil: '/authenticationpage');
        return;
      }
      //Pop the Dialog
      Navigator.pop(context);
      Navigator.pop(context);
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (BuildContext context) => widget));
    }

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
                Language.Translate(
                        'authentication_language', options.language) ??
                    'Language',
                style: TextStyle(color: Theme.of(context).primaryColor),
              ),
              content: SizedBox(
                width: screenSize.width * 0.5,
                height: screenSize.height * 0.3,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      //en_US
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: ElevatedButton(
                          onPressed: () {
                            uploadData('en_US');
                          },
                          child: const Text(
                            'English',
                          ),
                        ),
                      ),
                      //pt_BR
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: ElevatedButton(
                          onPressed: () {
                            uploadData('pt_BR');
                          },
                          child: const Text(
                            'Português',
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          );
        });
  }

  //Return Character Inventory
  static Future<String> returnPlayerInventory(BuildContext context) async {
    final options = Provider.of<Options>(context);
    final gameplay = Provider.of<Gameplay>(context);
    //Pickup from database
    dynamic charactersdb;
    try {
      //Connection
      charactersdb = await http.post(Uri.http(url, '/getCharacters'),
          headers: MySQL.headers,
          body: jsonEncode({
            'id': options.id,
            'token': options.token,
            'selectedCharacter': gameplay.selectedCharacter,
            'onlyInventory': true
          }));
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
  static Future<String> pushUploadCharacters(
      {required BuildContext context}) async {
    final options = Provider.of<Options>(context, listen: false);
    final gameplay = Provider.of<Gameplay>(context, listen: false);
    dynamic charactersdb;

    try {
      //Connection
      charactersdb = await http.post(Uri.http(url, '/getCharacters'),
          headers: MySQL.headers,
          body: jsonEncode({'id': options.id, 'token': options.token}));
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
      charactersdb['character${gameplay.selectedCharacter}']['inventory'] =
          gameplay.playerInventory;
      //Update Equips
      charactersdb['character${gameplay.selectedCharacter}']['equips'] =
          gameplay.playerEquips;
      //Update Level
      charactersdb['character${gameplay.selectedCharacter}']['level'] =
          gameplay.playerLevel;
      //Update XP
      charactersdb['character${gameplay.selectedCharacter}']['xp'] =
          gameplay.playerXP;
      //Update Skillpoints
      charactersdb['character${gameplay.selectedCharacter}']['skillpoint'] =
          gameplay.playerSkillpoint;
      //Update Strength
      charactersdb['character${gameplay.selectedCharacter}']['strength'] =
          gameplay.playerStrength;
      //Update Agility
      charactersdb['character${gameplay.selectedCharacter}']['agility'] =
          gameplay.playerIntelligence;
      //Update Intelligence
      charactersdb['character${gameplay.selectedCharacter}']['intelligence'] =
          gameplay.playerIntelligence;
    }
    //Transform into String
    charactersdb = jsonEncode(charactersdb);
    //Upload to database
    final result =
        await updateCharacters(characters: charactersdb, context: context);
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
    dynamic charactersdb;
    try {
      //Connection
      charactersdb = await http.post(Uri.http(url, '/getCharacters'),
          headers: MySQL.headers,
          body: jsonEncode({'id': options.id, 'token': options.token}));
    } catch (error) {
      //Connection Error
      GlobalFunctions.errorDialog(
          errorMsgTitle: 'authentication_register_problem_connection',
          errorMsgContext: 'Failed to connect to the Servers',
          context: context);
      return 'Connection Error';
    }
    charactersdb = jsonDecode(charactersdb.body);
    //Token Check
    if (charactersdb['message'] == 'Invalid Login') {
      Navigator.pushNamed(context, '/authenticationpage');
      GlobalFunctions.errorDialog(
          errorMsgTitle: 'authentication_invalidlogin',
          errorMsgContext: 'Invalid Session',
          context: context,
          popUntil: '/authenticationpage');
      return 'Invalid Login';
    }
    gameplay.changeCharacters(charactersdb['characters']);
    return charactersdb['characters'];
  }

  //Update Characters
  static updateCharacters(
      {String characters = '', context, bool isLevelUp = false}) async {
    final options = Provider.of<Options>(context, listen: false);
    final gameplay = Provider.of<Gameplay>(context, listen: false);
    dynamic charactersdb = jsonDecode(characters);
    dynamic result;
    try {
      if (isLevelUp) {
        //Connection
        result = await http.post(Uri.http(url, '/updateCharacters'),
            headers: MySQL.headers,
            body: jsonEncode({
              'id': options.id,
              'token': options.token,
              'selectedCharacter': gameplay.selectedCharacter,
              'isLevelUp': true,
            }));
        //Change Stats
        gameplay.changeStats(
            value: jsonDecode(jsonDecode(result.body)['characters'])[
                'character${gameplay.selectedCharacter}']['strength'],
            stats: 'strength');
        gameplay.changeStats(
            value: jsonDecode(jsonDecode(result.body)['characters'])[
                'character${gameplay.selectedCharacter}']['agility'],
            stats: 'agility');
        gameplay.changeStats(
            value: jsonDecode(jsonDecode(result.body)['characters'])[
                'character${gameplay.selectedCharacter}']['intelligence'],
            stats: 'intelligence');
        gameplay.changeStats(
            value: jsonDecode(jsonDecode(result.body)['characters'])[
                'character${gameplay.selectedCharacter}']['armor'],
            stats: 'armor');
        gameplay.changeStats(
            value: jsonDecode(jsonDecode(result.body)['characters'])[
                'character${gameplay.selectedCharacter}']['skillpoint'],
            stats: 'skillpoint');
      } else {
        //Connection
        result = await http.post(Uri.http(url, '/updateCharacters'),
            headers: MySQL.headers,
            body: jsonEncode({
              'id': options.id,
              'token': options.token,
              'selectedCharacter': gameplay.selectedCharacter,
              'name': charactersdb['character${gameplay.selectedCharacter}']
                  ['name'],
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
              'location': charactersdb['character${gameplay.selectedCharacter}']
                  ['location'],
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
    dynamic charactersdb;
    try {
      //Connection
      charactersdb = await http.post(Uri.http(url, '/removeCharacters'),
          headers: MySQL.headers,
          body: jsonEncode(
              {'id': options.id, 'token': options.token, 'index': index}));
    } catch (error) {
      //Connection Error
      GlobalFunctions.errorDialog(
          errorMsgTitle: 'authentication_register_problem_connection',
          errorMsgContext: 'Failed to connect to the Servers',
          context: context,
          popUntil: '/charactercreation');
      return;
    }
    charactersdb = jsonDecode(charactersdb.body);
    //Token Check
    if (charactersdb['message'] == 'Invalid Login') {
      Navigator.pushNamed(context, '/authenticationpage');
      GlobalFunctions.errorDialog(
          errorMsgTitle: 'authentication_invalidlogin',
          errorMsgContext: 'Invalid Session',
          context: context,
          popUntil: '/authenticationpage');
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
    final Map characters = jsonDecode(gameplay.characters);
    //Return Class
    if (returned == 'class') {
      final String characterClass =
          characters['character${gameplay.selectedCharacter}']['class'];
      return characterClass;
    }
    //Return Player Location
    if (returned == 'location') {
      final Map characters = jsonDecode(gameplay.characters);
      //World Name
      final String location =
          characters['character${gameplay.selectedCharacter}']['location']
              .substring(
                  0,
                  characters['character${gameplay.selectedCharacter}']
                              ['location']
                          .length -
                      3);
      //World ID
      gameplay.changeWorldId(
        int.parse(
          characters['character${gameplay.selectedCharacter}']['location']
              .substring(characters['character${gameplay.selectedCharacter}']
                          ['location']
                      .length -
                  3),
        ),
      );
      return location;
    }
  }

  //Return Player Stats
  static Future returnPlayerStats(context) async {
    final options = Provider.of<Options>(context, listen: false);
    final gameplay = Provider.of<Gameplay>(context, listen: false);
    //Receive from database
    dynamic charactersdb;
    try {
      //Connection
      charactersdb = await http.post(Uri.http(url, '/getCharacters'),
          headers: MySQL.headers,
          body: jsonEncode({'id': options.id, 'token': options.token}));
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
    final selectedCharacter =
        charactersdb['character${gameplay.selectedCharacter}'];
    //Return Stats
    gameplay.changeStats(
        value: double.parse(selectedCharacter['life'].toString()),
        stats: 'life');
    gameplay.changeStats(
        value: double.parse(selectedCharacter['mana'].toString()),
        stats: 'mana');
    gameplay.changeStats(
        value: double.parse(selectedCharacter['armor'].toString()),
        stats: 'armor');
    gameplay.changeStats(
        value: double.parse(selectedCharacter['xp'].toString()), stats: 'xp');
    gameplay.changeStats(
        value: int.parse(selectedCharacter['level'].toString()),
        stats: 'level');
    gameplay.changeStats(
        value: double.parse(selectedCharacter['strength'].toString()),
        stats: 'strength');
    gameplay.changeStats(
        value: double.parse(selectedCharacter['agility'].toString()),
        stats: 'agility');
    gameplay.changeStats(
        value: double.parse(selectedCharacter['intelligence'].toString()),
        stats: 'intelligence');
    gameplay.changeStats(
        value: int.parse(selectedCharacter['luck'].toString()), stats: 'luck');
    gameplay.changeStats(
        value: selectedCharacter['inventory'], stats: 'inventory');
    gameplay.changeStats(value: selectedCharacter['equips'], stats: 'equips');
    gameplay.changeStats(value: selectedCharacter['buffs'], stats: 'buffs');
    gameplay.changeStats(value: selectedCharacter['xp'], stats: 'xp');
    gameplay.changeStats(
        value: selectedCharacter['skillpoint'], stats: 'skillpoint');
    gameplay.changeStats(value: selectedCharacter['skills'], stats: 'skills');
  }
}

class MySQLGameplay {
  //Return Server Stats
  static Future returnGameplayStats(context) async {
    final settings = Provider.of<Settings>(context, listen: false);
    dynamic result;
    //Receive Base Atributes
    result = await http.post(
      Uri.http(MySQL.url, '/gameplayStats'),
      headers: MySQL.headers,
      body: jsonEncode({
        'baseAtributes': true,
      }),
    );
    settings.changeBaseAtributes(jsonDecode(result.body)['baseAtributes']);
    //Receive Level Caps
    result = await http.post(
      Uri.http(MySQL.url, '/gameplayStats'),
      headers: MySQL.headers,
      body: jsonEncode({
        'levelCaps': true,
      }),
    );
    settings.changeLevelCaps(jsonDecode(result.body)['levelCaps']);
    //Receive Skills Info
    result = await http.post(
      Uri.http(MySQL.url, '/gameplayStats'),
      headers: MySQL.headers,
      body: jsonEncode({
        'skillsId': true,
      }),
    );
    settings.changeSkillsId(jsonDecode(result.body)['skillsId']);
  }

  //Return Level
  static Future<List<dynamic>> returnLevel(
      {required BuildContext context, required String level}) async {
    final connection = await MySQL.database;
    List results = [];
    List<List<double>> listLevel = [];
    int a = 1;
    //Push Tiles
    while (true) {
      //Receive from database
      dynamic leveldb = await connection
          .query('select list$a from world where name = ?', [level]);
      leveldb = leveldb.toString().replaceFirst('(Fields: {list$a: ', '');
      leveldb = leveldb.substring(0, leveldb.length - 2);
      //Verify if is empty
      if (leveldb == '[]') {
        break;
      }
      List levelIndex = jsonDecode(leveldb);
      listLevel.add([]);
      //Push levelIndex and returns to client
      for (int b = 0; b < levelIndex.length; b++) {
        listLevel[a - 1].add(double.parse(levelIndex[b].toString()));
      }
      a++;
    }
    //Returning the Tiles
    results.add(listLevel);

    //Returning the NPCs
    // ignore: use_build_context_synchronously
    List<GameComponent> npc = await returnNPCs(context, level);
    results.add(npc);

    //Returning the Enemys
    // ignore: use_build_context_synchronously
    List<Enemy> enemy = await returnEnemys(context, level);
    results.add(enemy);

    return results;
  }

  //Return NPCs
  static Future<List<GameComponent>> returnNPCs(
      BuildContext context, String level) async {
    final connection = await MySQL.database;
    dynamic npcdb =
        await connection.query('select npc from world where name = ?', [level]);
    npcdb = npcdb.toString().replaceFirst('(Fields: {npc: ', '');
    npcdb = npcdb.substring(0, npcdb.length - 2);
    List<GameComponent> npc = [];
    //Add NPCs to the gameplay
    if (npcdb != '{}') {
      npcdb = jsonDecode(npcdb);
      double positionx = double.parse(npcdb['npc0']['positionx']);
      double positiony = double.parse(npcdb['npc0']['positiony']);
      npc.add(parseNPC(
          npcname: npcdb['npc0']['name'],
          position: Vector2(positionx, positiony),
          talk: npcdb['npc0']['talk']));
      int i = 1;
      while (true) {
        if (npcdb['npc$i'] != null) {
          positionx = double.parse(npcdb['npc$i']['positionx']);
          positiony = double.parse(npcdb['npc$i']['positiony']);
          npc.add(parseNPC(
              npcname: npcdb['npc$i']['name'],
              position: Vector2(positionx, positiony),
              talk: npcdb['npc$i']['talk']));
        }
        i++;
        break;
      }
    }
    return npc;
  }

  //Return Enemys
  static Future<List<Enemy>> returnEnemys(
      BuildContext context, String level) async {
    final connection = await MySQL.database;
    dynamic enemysdb = await connection
        .query('select enemy from world where name = ?', [level]);
    enemysdb = enemysdb.toString().replaceFirst('(Fields: {enemy: ', '');
    enemysdb = enemysdb.substring(0, enemysdb.length - 2);
    List<Enemy> enemy = [];
    //Add Enemys to the gameplay
    if (enemysdb != '{}') {
      String name;
      double life;
      double mana;
      double damage;
      double armor;
      int level;
      double xp;
      double positionx;
      double positiony;
      //Transforming in MAP
      enemysdb = jsonDecode(enemysdb);
      name = enemysdb['enemy0']['name'].toString();
      life = double.parse(enemysdb['enemy0']['life'].toString());
      mana = double.parse(enemysdb['enemy0']['mana'].toString());
      damage = double.parse(enemysdb['enemy0']['damage'].toString());
      armor = double.parse(enemysdb['enemy0']['armor'].toString());
      level = int.parse(enemysdb['enemy0']['level'].toString());
      xp = double.parse(enemysdb['enemy0']['xp'].toString());
      positionx = double.parse(enemysdb['enemy0']['positionx'].toString());
      positiony = double.parse(enemysdb['enemy0']['positiony'].toString());
      //Adding the first enemy
      enemy.add(parseEnemy(
        enemyname: name,
        position: Vector2(positionx, positiony),
        life: life,
        mana: mana,
        damage: damage,
        armor: armor,
        level: level,
        xp: xp,
      ));
      int i = 1;
      while (true) {
        if (enemysdb['enemy$i'] != null) {
          name = enemysdb['enemy$i']['name'].toString();
          life = double.parse(enemysdb['enemy$i']['life'].toString());
          mana = double.parse(enemysdb['enemy$i']['mana'].toString());
          damage = double.parse(enemysdb['enemy$i']['damage'].toString());
          armor = double.parse(enemysdb['enemy$i']['armor'].toString());
          level = int.parse(enemysdb['enemy$i']['level'].toString());
          xp = double.parse(enemysdb['enemy$i']['xp'].toString());
          positionx = double.parse(enemysdb['enemy$i']['positionx'].toString());
          positiony = double.parse(enemysdb['enemy$i']['positiony'].toString());
          enemy.add(parseEnemy(
              enemyname: name,
              position: Vector2(positionx, positiony),
              life: life,
              mana: mana,
              damage: damage,
              armor: armor,
              level: level,
              xp: xp));
        } else {
          break;
        }
        i++;
      }
    }
    return enemy;
  }

  //Parse NPCs
  static SimpleNpc parseNPC(
      {required String npcname,
      required Vector2 position,
      required String talk}) {
    switch (npcname) {
      case "wizard":
        return NPCWizard(position, talk);
    }
    return NPCWizard(position, talk);
  }

  //Parse NPCs
  static Enemy parseEnemy({
    required String enemyname,
    required Vector2 position,
    required double life,
    required double mana,
    required double damage,
    required double armor,
    required int level,
    required double xp,
  }) {
    switch (enemyname) {
      case "smallspider":
        return EnemySmallSpider(
            name: enemyname,
            life: life,
            mana: mana,
            damage: damage,
            armor: armor,
            level: level,
            xp: xp,
            position: position);
    }
    return EnemySmallSpider(
        name: 'smallspider',
        life: 100,
        mana: 100,
        damage: 1,
        armor: 0,
        level: 0,
        xp: 0,
        position: position);
  }
}

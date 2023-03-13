import 'dart:convert';

import 'package:flublade_project/data/gameplay/enemys.dart';
import 'package:flublade_project/data/gameplay/npc.dart';
import 'package:flublade_project/data/global.dart';
import 'package:flublade_project/data/language.dart';

import 'package:flutter/material.dart';
import 'package:mysql1/mysql1.dart';
import 'package:provider/provider.dart';
import 'package:bonfire/bonfire.dart';

class MySQL {
  //Connection
  static final database = MySqlConnection.connect(
    ConnectionSettings(
      host: '192.168.0.13',
      port: 3306,
      user: 'flubladeGuest',
      password: 'i@Dhs4e5E%fGz&ngbY2m&AGRCVlskBUrrCnsYFUze&fhxehb#j',
      db: 'flublade',
    ),
  );

  //Account Creation
  static Future<String> createAccount({
    required String name,
    required String password,
    required String language,
  }) async {
    //Connection to the database
    final connection = await database;
    try {
      //Insert new account to the database
      await connection.query(
          'insert into accounts (username, password, language) values (?, ?, ?)',
          [name, password, language]);
      return 'sucess';
    } catch (error) {
      if (error.toString().contains('Duplicate entry')) {
        return 'exists';
      }
      return 'failed';
    }
  }

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

  //Login
  static login(
      {required String username,
      required String password,
      required context}) async {
    //Connection
    final connection = await database;
    try {
      int id = 1;
      //Credentials Checking
      while (true) {
        dynamic usernamedb = await connection
            .query('select username from accounts where id = ?', [id]);
        usernamedb =
            usernamedb.toString().replaceFirst('(Fields: {username: ', '');
        usernamedb = usernamedb.substring(0, usernamedb.length - 2);
        if (username == usernamedb) {
          dynamic passworddb = await connection
              .query('select password from accounts where id = ?', [id]);
          passworddb =
              passworddb.toString().replaceFirst('(Fields: {password: ', '');
          passworddb = passworddb.substring(0, passworddb.length - 2);
          if (password == passworddb) {
            final options = Provider.of<Options>(context, listen: false);
            options.changeUsername(username);
            options.changePassword(password);
            options.changeId(id);
            SaveDatas.setUsername(username);
            SaveDatas.setPassword(password);
            SaveDatas.setId(id);
            SaveDatas.setRemember(options.remember);
            return 'success';
          }
        } else if (usernamedb == '') {
          return 'notfound';
        } else {
          id++;
        }
      }
    } catch (error) {
      return 'failed';
    }
  }

  //Change Language
  static Future<void> changeLanguage(context, widget) async {
    final screenSize = MediaQuery.of(context).size;
    final options = Provider.of<Options>(context, listen: false);
    //Upload to MySQL
    uploadData(String language) {
      //Update Datas
      options.changeLanguage(language);
      SaveDatas.setLanguage(language);
      database.then((connection) async {
        await connection.query('update accounts set language=? where id=?',
            [language, options.id]);
      });

      //Pop the Dialog
      Navigator.pop(context);
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (BuildContext context) => widget));
    }

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
              Language.Translate('authentication_language', options.language) ??
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
          );
        });
  }

  //Return Character Inventory
  static Future<bool> returnPlayerInventory(BuildContext context) async {
    final options = Provider.of<Options>(context);
    final gameplay = Provider.of<Gameplay>(context);
    final connection = await database;
    //Pickup from database
    dynamic charactersdb = await connection
        .query('select characters from accounts where id = ?', [options.id]);
    charactersdb =
        charactersdb.toString().replaceFirst('(Fields: {characters: ', '');
    charactersdb = charactersdb.substring(0, charactersdb.length - 2);
    charactersdb = jsonDecode(charactersdb);
    final inventory =
        charactersdb['character${gameplay.selectedCharacter}']['inventory'];
    if (inventory == '{}') {
      return false;
    }
    gameplay.changePlayerInventory(inventory);
    return true;
  }

  //Push and Upload Characters
  static Future<void> pushUploadCharacters(
      {required BuildContext context}) async {
    final options = Provider.of<Options>(context, listen: false);
    final gameplay = Provider.of<Gameplay>(context, listen: false);
    final connection = await database;
    //Pickup from database
    dynamic charactersdb = await connection
        .query('select characters from accounts where id = ?', [options.id]);
    charactersdb =
        charactersdb.toString().replaceFirst('(Fields: {characters: ', '');
    charactersdb = charactersdb.substring(0, charactersdb.length - 2);
    //Transform into MAP
    charactersdb = jsonDecode(charactersdb);
    //Add new or remove items
    charactersdb['character${gameplay.selectedCharacter}']['inventory'] =
        gameplay.playerInventory;
    //Add new equips
    charactersdb['character${gameplay.selectedCharacter}']['equips'] =
        gameplay.playerEquips;
    //Transform into String
    charactersdb = jsonEncode(charactersdb);
    //Upload to database
    await updateCharacters(charactersdb, options);
  }

  //Create Character
  static Future<bool> createCharacter({
    required context,
    required characterUsername,
    required characterClass,
  }) async {
    final options = Provider.of<Options>(context, listen: false);
    final gameplay = Provider.of<Gameplay>(context, listen: false);
    try {
      final connection = await database;
      String characters = await gameplay.addCharacter(
        characterUsername: characterUsername,
        characterClass: characterClass,
        connection: connection,
        options: options,
        gameplay: gameplay,
      );
      if (characters == 'Cannot Connect to The Servers') {
        return false;
      }
      return true;
    } catch (error) {
      print(error);
      return false;
    }
  }

  //Push Characters
  static Future<dynamic> pushCharacters(
      {required options, update = false}) async {
    try {
      final connection = await database;
      dynamic charactersdb = await connection
          .query('select characters from accounts where id = ?', [options.id]);
      charactersdb =
          charactersdb.toString().replaceFirst('(Fields: {characters: ', '');
      charactersdb = charactersdb.substring(0, charactersdb.length - 2);
      if (update) {
        await updateCharacters(charactersdb, options);
      }
      return charactersdb;
    } catch (error) {
      return false;
    }
  }

  //Update Characters
  static updateCharacters(String characters, options) async {
    final connection = await database;
    await connection.query('update accounts set characters=? where id=?',
        [characters, options.id]);
  }

  //Remove Characters
  static Future<bool> removeCharacters(
      {required index, required options, required gameplay}) async {
    dynamic charactersdb = await pushCharacters(options: options);
    //Check Connection
    if (charactersdb == false) {
      return false;
    }
    charactersdb = jsonDecode(charactersdb);
    charactersdb.remove('character$index');
    int lenght = charactersdb.length;
    for (int i = index; i <= lenght - 1; i++) {
      charactersdb['character$i'] = charactersdb['character${i + 1}'];
    }
    charactersdb.remove('character$lenght');
    charactersdb = jsonEncode(charactersdb);
    try {
      updateCharacters(charactersdb, options);
    } catch (error) {
      return false;
    }
    SaveDatas.setCharacters(charactersdb);
    gameplay.changeCharacters(charactersdb);
    return true;
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
      final String location =
          characters['character${gameplay.selectedCharacter}']['location'];
      return location;
    }
  }

  //Return Player Stats
  static Future returnPlayerStats(context) async {
    final options = Provider.of<Options>(context, listen: false);
    final gameplay = Provider.of<Gameplay>(context, listen: false);
    final connection = await MySQL.database;
    //Receive from database
    dynamic charactersdb = await connection
        .query('select characters from accounts where id = ?', [options.id]);
    charactersdb =
        charactersdb.toString().replaceFirst('(Fields: {characters: ', '');
    charactersdb = charactersdb.substring(0, charactersdb.length - 2);
    charactersdb = jsonDecode(charactersdb);
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
        value: double.parse(selectedCharacter['gold'].toString()),
        stats: 'gold');
    gameplay.changeStats(
        value: double.parse(selectedCharacter['xp'].toString()), stats: 'xp');
    gameplay.changeStats(
        value: int.parse(selectedCharacter['level'].toString()),
        stats: 'level');
    gameplay.changeStats(
        value: int.parse(selectedCharacter['strength'].toString()),
        stats: 'strength');
    gameplay.changeStats(
        value: int.parse(selectedCharacter['agility'].toString()),
        stats: 'agility');
    gameplay.changeStats(
        value: int.parse(selectedCharacter['intelligence'].toString()),
        stats: 'intelligence');
    gameplay.changeStats(
        value: int.parse(selectedCharacter['luck'].toString()), stats: 'luck');
    gameplay.changeStats(
        value: selectedCharacter['inventory'], stats: 'inventory');
    gameplay.changeStats(value: selectedCharacter['equips'], stats: 'equips');
  }
}

class MySQLGameplay {
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
          ));
        }
        i++;
        break;
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
            position: position);
    }
    return EnemySmallSpider(
        name: 'smallspider',
        life: 100,
        mana: 100,
        damage: 1,
        armor: 0,
        level: 0,
        position: position);
  }
}

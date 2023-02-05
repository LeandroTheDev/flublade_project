import 'dart:convert';

import 'package:flublade_project/data/global.dart';
import 'package:flublade_project/data/language.dart';

import 'package:flutter/material.dart';
import 'package:mysql1/mysql1.dart';
import 'package:provider/provider.dart';

class MySQL {
  //Connection
  static final database = MySqlConnection.connect(
    ConnectionSettings(
      host: '192.168.1.25',
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
  static void changeLanguage(context, widget) {
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
}
